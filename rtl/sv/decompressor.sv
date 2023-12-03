module decompressor(
    input clk,
    input rst_n,
    input start, // from controller (TO DO: maybe in global buffer)
    input ifmap_buffer_req,
    input [`MEM_BANDWIDTH*8-1:0] mem_data,
    input mem_data_valid,
    input mem_ack, // if decompressor issue a mem_req, in the same cycle if memory bandwidth is available, it will return a mem_ack
    input LAYER_TYPE layer_type_in,

    output decompressor_ack, // decompressor can give valid data
    output mem_req, // assert when compress fifo can receive data from memory
    output DECOMRPESS_FIFO_PACKET decompress_fifo_packet
);
    // clock gating for layer1
    logic layer1_gated_clk;
    logic layer1_latch;
    // clock gating for layer23
    logic layer23_gated_clk;
    logic layer23_latch;

    localparam DATA_FIFO_DEPTH = 16; // assuem that the memory access latency will last 16 cycle
    logic [DATA_FIFO_DEPTH-1:0][63:0] data_fifo;
    logic fetch;

    // write logic for data fifo
    logic [$clog2(DATA_FIFO_DEPTH):0] data_fifo_write_ptr, data_fifo_fetch_ptr;
    logic [$clog2(DATA_FIFO_DEPTH)-1:0] data_fifo_write_index;
    logic [$clog2(DATA_FIFO_DEPTH):0] data_fifo_read_ptr;
    logic data_fifo_fetch_full;

    logic enable;
    logic stop_fetch; // stop_fetch is high, if whole input feature map on one channel has been read
    logic [4:0] data_counter_write_inner; // counter_inner
    logic [7:0] data_counter_write_outer; // counter_outer
    logic [4:0] layer1_data_counter_read; // read_counter
    logic [6:0] layer23_data_counter_read; // read_counter
    logic [6:0] layer23_data_counter_read_upper;
    LAYER_TYPE layer_type;

    DECOMRPESS_FIFO_PACKET layer1_fifo_packet;
    DECOMRPESS_FIFO_PACKET layer23_fifo_packet;
    DECOMRPESS_FIFO_PACKET layer23_fifo_packet_comb;
    DECOMRPESS_FIFO_PACKET layer23_fifo_packet_next;

    logic [$clog2(DATA_FIFO_DEPTH):0] layer1_data_fifo_read_ptr; // fetch_ptr
    logic [$clog2(DATA_FIFO_DEPTH):0] layer1_data_fifo_read_ptr_p1;
    logic [$clog2(DATA_FIFO_DEPTH)-1:0] layer1_data_fifo_read_index;
    logic [$clog2(DATA_FIFO_DEPTH)-1:0] layer1_data_fifo_read_index_p1;
    logic fetch_layer1;
    logic fetch_full_layer1;
    logic data_fifo_layer1_empty;
    logic layer1_hanshake; // for layer1 decompressor hansdshake with global buffer

    logic [$clog2(DATA_FIFO_DEPTH):0] layer23_data_fifo_read_ptr; // data fifo entry read ptr for layer2 and layer3
    
    logic [$clog2(DATA_FIFO_DEPTH):0] layer23_data_fifo_read_ptr_next;
    logic fetch_layer23;
    logic fetch_full_layer23;
    logic data_fifo_layer23_empty;
    logic data_fifo_layer23_full;
    logic layer23_stop_fetch;
    logic layer23_stall; // for layer23, if the fifo_packet is all valid but global buffer has not require, we need to stall all operation
    logic layer23_handshake; // for layer23 decrompressor handshake with global buffer
    
    COMPRESS_UNIT[9:0] layer23_aligned_data; // 5 compress unit + 5 compress unit (2 entries in data fifo);
    COMPRESS_UNIT[9:0] layer23_aligned_data_minus; // layer23_aligned_data - the data out to global buffer
    COMPRESS_UNIT[9:0] layer23_aligned_data_next; // 5 compress unit + 5 compress unit (2 entries in data fifo);
    COMPRESS_UNIT[9:0] layer23_aligned_data_comb; // 5 compress unit + 5 compress unit (2 entries in data fifo); for data_fifo_read_ptr, data_fifo_read_ptr+1
    COMPRESS_UNIT[9:0] layer23_aligned_data_comb_next; // 5 compress unit + 5 compress unit (2 entries in data fifo); for data_fifo_read_ptr+1, data_fifo_read_ptr+2
    logic [1:0] layer23_aligned_data_valid_group; // [0] is the lower 5 of compress unit, [1] is the higher 5 of compress unit
    logic [1:0] layer23_aligned_data_valid_group_next; // [0] is the lower 5 of compress unit, [1] is the higher 5 of compress unit
    logic [1:0] is_end; // if 01 end in compress group[0], if 10 end in compress group[1]
    logic [3:0] layer23_aligned_data_read_ptr; // index layer23_aligned_data_read_ptr
    logic [3:0] layer23_aligned_data_tail_ptr; // index layer23_aligned_data_read_ptr
    logic [4:0][4:0] layer23_aligned_data_compress_unit_num; // the number of valid element in each compress unit among the five compress unit which can be handle during one cycle
    logic [4:0][6:0] layer23_aligned_data_accumulate_num; // the accumulated element number from the layer23_aligned_data_read_ptr;
    logic [1:0] aligned_data_valid; // valid bit for aligned_data[9:5] and aligned_data[4:0]
    logic [1:0] aligned_data_flag; // 0 represent end from zero in compress unit, 1 represent end from val in compress unit
    logic [4:0] aligned_data_accumulate_num_mask; // 00111 represent the accumulate num from the third compress unit is larger than remained slot in decompressed_fifo_packet
    logic [2:0] aligned_data_read_ptr_move; // the num that aligned_data_read_ptr can move, taking compress unit is invalid into consideration, will not pass invalid compress unit
    logic [3:0] layer23_aligned_data_read_ptr_next;
    logic aligned_data_read_ptr_move_not_full; // aligned data read ptr will move the full 5 compress unit, which is the size of compress unit can be handle within one cycle
    logic [4:0] aligned_data_read_ptr_move_max; // the max positon the aligned_data_read_ptr can move, for example
                                                // 1. remaining slot = 6, and aligned_data_accumulate_num_mask[2][3][4] = 5, so aligned_data_accumulate_num_mask = 5'b0, however the layer23_aligned_data_valid_handle_group = 5'b00111, the 4th and 5th compress units are invalid
                                                // in this case, we can only move aligned_data_read_ptr to index "3" instead of index "5"
                                                // aligned_data_read_ptr_move_max = 5'b11000, when we give it to priority encoder, it will give (01000), encode to 3, add to current align_data_read_ptr
    logic [4:0] layer23_aligned_data_valid_handle_group; // valid for 5 compress unit which will be handled within one cycle
    logic [6:0] layer23_fifo_packet_remain_num; // The remaining slot to fill within layer23_fifo_packet which have 8 slot (every cycle send to global buffer for 8 element)
    logic [6:0] layer23_fifo_packet_remain_num_next;
    logic [6:0] layer23_fifo_packet_enqueue_num; // The number of byte which send from aligned_data to fifo_packet
    logic [1:0] layer23_send_all;
    logic layer23_sending_last_packet; // if layer23 is sendin last packet, 1

    logic [3:0] layer23_fifo_packet_ptr;
    logic [4:0] compress_unit_val_valid; // The val is choosen to send to fifo_packet in one compress unit; we have total 5 compress unit to handle in one cycle
    logic [4:0][2:0] compress_unit_val_position; // The position for val, considering variant zero ahead


    assign stop_fetch =     (layer_type == LAYER1 && data_counter_write_outer == `L1_IFMAP_SIZE)  | layer23_stop_fetch;
    

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | stop_fetch) begin
            enable <= 0;
        end
        else if(start) begin
            enable <= 1'b1;
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            layer_type <= NULL;
        end
        else if(start)begin
            layer_type <= layer_type_in;
        end
    end

    always_comb begin
        if(!clk) begin
            layer1_latch = layer_type == LAYER1;
        end
    end
    assign layer1_gated_clk = clk & layer1_latch;

    always_comb begin
        if(!clk) begin
            layer23_latch = (layer_type == LAYER2) | (layer_type == LAYER3);
        end
    end
    assign layer23_gated_clk = clk & layer23_latch;

    // This is the data fifo for buffering the data from memory,
    // The fifo has 16 entry which each entry has 64 bits
    // The fifo has two group of control logic
    // 1. control logic for layer1, if ifmap_buffer_req assert, it will read one entry from data fifo
    // 2, control logic for layer2 and layer3, if ifmap_buffer_req assert, it will read base on the decompress_reult

    assign data_fifo_write_index = data_fifo_write_ptr[$clog2(DATA_FIFO_DEPTH)-1:0];
    assign data_fifo_read_ptr = layer_type == LAYER1                            ? layer1_data_fifo_read_ptr  : 
                                layer_type == LAYER2 || layer_type == LAYER3    ? layer23_data_fifo_read_ptr : 0;

    // if fetch request not full in data fifo, continue fetch
    assign data_fifo_fetch_full = (data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)-1:0] == data_fifo_read_ptr[$clog2(DATA_FIFO_DEPTH)-1:0]) & (data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)] ^ data_fifo_read_ptr[$clog2(DATA_FIFO_DEPTH)]);
    assign fetch = ~data_fifo_fetch_full;
    

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start) begin
            data_fifo_write_ptr      <= '0;
            data_fifo_fetch_ptr      <= '0;
        end
        else if(enable) begin
            data_fifo_write_ptr      <= mem_data_valid & !stop_fetch ? (data_fifo_write_ptr + 1'b1) : data_fifo_write_ptr;
            data_fifo_fetch_ptr      <= fetch & mem_ack ? (data_fifo_fetch_ptr + 1'b1) : data_fifo_fetch_ptr; // fetch_ptr can only move if 1. there is available slot if data_fifo, 2. there is mem_ack
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start) begin
            data_fifo <= '0;
        end
        else if(mem_data_valid & !stop_fetch & enable) begin
            data_fifo[data_fifo_write_index] <= mem_data;
        end
    end


    /// Layer1 datFetch/fetch Logic ///
    // for layer1 the data is not compressed
    assign data_fifo_layer1_empty = layer1_data_fifo_read_ptr == data_fifo_write_ptr;
    assign fetch_full_layer1 = (data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)] != layer1_data_fifo_read_ptr[$clog2(DATA_FIFO_DEPTH)]) && (data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)-1:0] == layer1_data_fifo_read_ptr[$clog2(DATA_FIFO_DEPTH)-1:0]);
    assign layer1_handshake = !data_fifo_layer1_empty && ifmap_buffer_req;
    assign layer1_data_fifo_read_ptr_p1 = layer1_data_fifo_read_ptr + 1;
    assign layer1_data_fifo_read_index = layer1_data_fifo_read_ptr[$clog2(DATA_FIFO_DEPTH)-1:0];
    assign layer1_data_fifo_read_index_p1 = layer1_data_fifo_read_ptr_p1[$clog2(DATA_FIFO_DEPTH)-1:0];

    // control logic for layer1
    always_ff@(posedge layer1_gated_clk or negedge rst_n) begin
        if(!rst_n | start) begin
            layer1_data_fifo_read_ptr       <= '0;
        end
        else begin
            layer1_data_fifo_read_ptr       <= layer1_handshake ? layer1_data_fifo_read_ptr_p1 : layer1_data_fifo_read_ptr;
        end
    end

    assign fetch_layer1 = !fetch_full_layer1 && (layer_type == LAYER1);

    // for layer1 the enbale signal for decompressor is disable after it has already loaded one full input feature map channel from memory
    always_ff@(posedge layer1_gated_clk or negedge rst_n) begin
        if(!rst_n | start) begin
            data_counter_write_inner <= '0;
            data_counter_write_outer <= '0;
        end
        else if(enable & layer_type == LAYER1 & mem_data_valid) begin
            data_counter_write_inner <= (data_counter_write_inner) == 29 ? 1 : data_counter_write_inner + 1'b1;
            data_counter_write_outer <= (data_counter_write_inner) == 29 ? data_counter_write_outer + 1'b1 : data_counter_write_outer;
        end
    end

    // data read counter for layer1
    always_ff@(posedge layer1_gated_clk or negedge rst_n) begin
        if(!rst_n | start) begin
            layer1_data_counter_read <= '0;
        end
        else if(layer1_handshake) begin
            layer1_data_counter_read <= (layer1_data_counter_read == 29) ? 1 : layer1_data_counter_read + 1'b1;
        end
    end

    // generate the fifo output for layer1
    assign layer1_fifo_packet.packet_valid = !data_fifo_layer1_empty;
    assign layer1_fifo_packet.valid_mask = (layer1_data_counter_read == 29) ? 8'b00000111 : {8{1'b1}}; // TO DO,need to have a read counter
    for(genvar i = 0; i < 8; i=i+1) begin : layer1_fifo_packet_gen
        assign layer1_fifo_packet.data[i] = data_fifo[layer1_data_fifo_read_index][8*i+7:8*i];
    end


    /// Layer2 and Layer3 datFetch/fetch Logic ///

    // Data compress format for layer2 and layer 3 //
    // 1. In layer2 or layer3, data is compressed on 64 bits granularity, 60 bits of data + 4 bits of info bits, which is regarded as ONE COMPRESS GROUP
    // 2. for one COMPRESS GROUP (64 bits): 4bits(zeros), 8 bits, 4bits(zeros), 8 bits, 4bits(zeros), 8 bits, 4bits(zeros), 8 bits, 4bits(zeros), 8 bits, 4bits(zeros) , 8 bits, 4bits(info bits)  0bit -> 63bits, each [4bits(zeros), 8 bits] is a COMPRESS UNIT
    // 3. info bits can be devided as 1 + 3 bits: ?,***
    //    Since not all bits in COMPRESS GROUP is useful, for example, in one COMPRESS UNIT if 4 bits < 15 and 8 bits == 0, it can be regarded as the end of the WHOLE input feature map
    //    a. the *** represent which COMPRESS UNIT in COMPRESS GROUP is the end, The value is [0:4]
    //    b. if all COMPRESS UNITS in one COMPRESS GROUP is valid, *** == 3'b111
    //    b. the ? == 1 : COMPRESS GROUP end with 8 bits; ? == 0 : COMPRESS GROUP end with 4 bits(zeros)

    // Compress Strategy
    // 1. The whole output feature map is compressed as a whole, row by row
    // 2. There is NO BUBBLE between EACH ROW, no matter aligned or not
    // 3. The only case where the 64 bits compress is unit has invalid bits is when compressiong the last part of output feature map, the remaining data COULD NOT FILL THE WHOLE 64 BITS of COMPRESS GROUP

    // Decompress Strategy //
    // 1. in every cycle, decompressor can at most read ONE COMPRESS GROUP from memory, every COMPRESS GROUP represent one entry in data fifo
    // 2. in one cycle, can decompress at most (64-4) bits in data fifo, 5 COMPRESS UNIT
    // 3. we will handle the cross-entry situation, where (64-4) bits can be located along 2 entries in data fifo

    assign data_fifo_layer23_empty = layer23_data_fifo_read_ptr == data_fifo_write_ptr;
    assign layer23_stall = layer23_fifo_packet.packet_valid & !ifmap_buffer_req;

    assign layer23_aligned_data_valid_group[0] = (layer23_data_fifo_read_ptr != data_fifo_write_ptr);
    assign layer23_aligned_data_valid_group[1] = ((layer23_data_fifo_read_ptr + 1) != data_fifo_write_ptr) & layer23_aligned_data_valid_group[0];
    assign layer23_aligned_data_valid_group_next[0] = (layer23_data_fifo_read_ptr_next != data_fifo_write_ptr);
    assign layer23_aligned_data_valid_group_next[1] = ((layer23_data_fifo_read_ptr_next + 1) != data_fifo_write_ptr) & layer23_aligned_data_valid_group_next[0];
    assign is_end[0] = layer23_aligned_data_valid_group[0] & ~(&data_fifo[layer23_data_fifo_read_ptr][62:60]);
    assign is_end[1] = layer23_aligned_data_valid_group[1] & ~(&data_fifo[layer23_data_fifo_read_ptr + 1'b1][62:60]);
    assign aligned_data_flag[0] = is_end[0] & data_fifo[layer23_data_fifo_read_ptr][63];
    assign aligned_data_flag[1] = is_end[1] & data_fifo[layer23_data_fifo_read_ptr+1'b1][63];
    assign fetch_full_layer23 = (data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)] != layer23_data_fifo_read_ptr[$clog2(DATA_FIFO_DEPTH)]) && (data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)-1:0] == layer23_data_fifo_read_ptr[$clog2(DATA_FIFO_DEPTH)-1:0]);
    assign fetch_layer23 = !fetch_full_layer23 && (layer_type == LAYER2 || layer_type == LAYER3);

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start) begin
            layer23_stop_fetch <= 1'b0;
        end
        else if((layer_type == LAYER2 | layer_type == LAYER3) && mem_data_valid && ~(&mem_data[62:60])) begin
            layer23_stop_fetch <= 1'b1;
        end
    end

    always_ff@(posedge layer23_gated_clk or negedge rst_n) begin
        if(!rst_n | start) begin
            aligned_data_valid <= '0;
        end
        else if (!layer23_stall) begin
            if(layer23_aligned_data_read_ptr_next > 4) begin
                aligned_data_valid <= layer23_aligned_data_valid_group_next;
            end
            else begin
                aligned_data_valid <= layer23_aligned_data_valid_group;
            end
        end
    end

    // generate align data
    for(genvar i = 0; i < 5; i= i+1) begin:aligned_data
        assign layer23_aligned_data_comb[i].zero            = data_fifo[layer23_data_fifo_read_ptr][12*i+3:12*i];
        assign layer23_aligned_data_comb[i].val             = data_fifo[layer23_data_fifo_read_ptr][12*i+11:12*i+4];
        assign layer23_aligned_data_comb[5+i].zero          = data_fifo[layer23_data_fifo_read_ptr+1][12*i+3:12*i];
        assign layer23_aligned_data_comb[5+i].val           = data_fifo[layer23_data_fifo_read_ptr+1][12*i+11:12*i+4];
        assign layer23_aligned_data_comb_next[i].zero       = data_fifo[layer23_data_fifo_read_ptr_next][12*i+3:12*i];
        assign layer23_aligned_data_comb_next[i].val        = data_fifo[layer23_data_fifo_read_ptr_next][12*i+11:12*i+4];
        assign layer23_aligned_data_comb_next[5+i].zero     = data_fifo[layer23_data_fifo_read_ptr_next+1][12*i+3:12*i];
        assign layer23_aligned_data_comb_next[5+i].val      = data_fifo[layer23_data_fifo_read_ptr_next+1][12*i+11:12*i+4];
    end

    // minus the number which has been send to decompress_fifo_packet from compress unit
    always_comb begin
        layer23_aligned_data_minus = layer23_aligned_data;
        // layer23_aligned_data_minus[layer23_aligned_data_read_ptr_next].zero =   !aligned_data_read_ptr_move_not_full                                 ?  layer23_aligned_data[layer23_aligned_data_read_ptr_next].zero - (layer23_fifo_packet_remain_num - layer23_aligned_data_accumulate_num[4]) :
        //                                                                         layer23_aligned_data_valid_handle_group[aligned_data_read_ptr_move]  ?  (aligned_data_read_ptr_move == 0 ? layer23_aligned_data[layer23_aligned_data_read_ptr_next].zero - layer23_fifo_packet_remain_num  : layer23_aligned_data[layer23_aligned_data_read_ptr_next].zero - (layer23_fifo_packet_remain_num - layer23_aligned_data_accumulate_num[aligned_data_read_ptr_move-1])) : 
        //                                                                                                                                                 layer23_aligned_data[layer23_aligned_data_read_ptr_next].zero;
        layer23_aligned_data_minus[layer23_aligned_data_read_ptr_next].zero =   aligned_data_read_ptr_move_not_full  & layer23_aligned_data_valid_handle_group[aligned_data_read_ptr_move]  ?  
                                                                                (aligned_data_read_ptr_move == 0 ? layer23_aligned_data[layer23_aligned_data_read_ptr_next].zero - layer23_fifo_packet_remain_num  : layer23_aligned_data[layer23_aligned_data_read_ptr_next].zero - (layer23_fifo_packet_remain_num - layer23_aligned_data_accumulate_num[aligned_data_read_ptr_move-1])) : 
                                                                                layer23_aligned_data[layer23_aligned_data_read_ptr_next].zero;
    end

    always_comb begin
        layer23_aligned_data_next = layer23_aligned_data_minus;
        case(aligned_data_valid)
            2'b00   : layer23_aligned_data_next = layer23_aligned_data_comb;
            2'b01   : layer23_aligned_data_next = {layer23_aligned_data_comb[9:5],layer23_aligned_data_minus[4:0]};
            default : layer23_aligned_data_next = layer23_aligned_data_minus;
        endcase
        if(layer23_aligned_data_read_ptr_next > 4) begin
            layer23_aligned_data_next = {layer23_aligned_data_comb_next[9:5],layer23_aligned_data_next[9:5]};
        end
    end

    always_ff@(posedge layer23_gated_clk or negedge rst_n) begin
        if(!rst_n | start) begin
            layer23_aligned_data <= '0;
        end
        else if (!layer23_stall) begin
            layer23_aligned_data <= layer23_aligned_data_next;
        end
    end

    always_comb begin
        layer23_aligned_data_tail_ptr = 0;
        // if(layer23_aligned_data_valid_group[1]) begin
        if(aligned_data_valid[1]) begin
            layer23_aligned_data_tail_ptr = &data_fifo[layer23_data_fifo_read_ptr + 1'b1][62:60] ? 9 : data_fifo[layer23_data_fifo_read_ptr + 1'b1][62:60] + 5;
        end
        //else if(layer23_aligned_data_valid_group[0]) begin
        else if(aligned_data_valid[0]) begin
            layer23_aligned_data_tail_ptr = &data_fifo[layer23_data_fifo_read_ptr][62:60] ? 4 : data_fifo[layer23_data_fifo_read_ptr][62:60];
        end
    end


    // get the accumulated valid element number in one handle group
    for(genvar i = 0; i < 5; i= i+1) begin:aligned_data_compress_unit_num
        assign layer23_aligned_data_compress_unit_num[i] =  layer23_aligned_data_read_ptr+i >  layer23_aligned_data_tail_ptr | layer23_aligned_data_tail_ptr == 0       ? 0 :
                                                            layer23_aligned_data_read_ptr+i <  layer23_aligned_data_tail_ptr                                            ? layer23_aligned_data[layer23_aligned_data_read_ptr+i].zero + 1'b1 :
                                                            layer23_aligned_data_read_ptr+i == layer23_aligned_data_tail_ptr                                            ? ( ((~(|is_end)) | (|aligned_data_flag)) ? layer23_aligned_data[layer23_aligned_data_read_ptr+i].zero + 1'b1 : layer23_aligned_data[layer23_aligned_data_read_ptr+i].zero) : 0;
    end

    assign layer23_aligned_data_accumulate_num[0] = layer23_aligned_data_compress_unit_num[0];
    assign layer23_aligned_data_accumulate_num[1] = layer23_aligned_data_accumulate_num[0] + layer23_aligned_data_compress_unit_num[1];
    assign layer23_aligned_data_accumulate_num[2] = layer23_aligned_data_accumulate_num[1] + layer23_aligned_data_compress_unit_num[2];
    assign layer23_aligned_data_accumulate_num[3] = layer23_aligned_data_accumulate_num[2] + layer23_aligned_data_compress_unit_num[3];
    assign layer23_aligned_data_accumulate_num[4] = layer23_aligned_data_accumulate_num[3] + layer23_aligned_data_compress_unit_num[4];

    // get the first position of compress unit which has accumulated element num larger than layer23_fifo_packet_remain_num 
    for(genvar i = 0; i < 5; i=i+1) begin:accumulate_num_mask
        assign aligned_data_accumulate_num_mask[i] = layer23_aligned_data_accumulate_num[i] > layer23_fifo_packet_remain_num ? 1'b1 : 1'b0;
        assign layer23_aligned_data_valid_handle_group[i] = (layer23_aligned_data_read_ptr+i <= layer23_aligned_data_tail_ptr) & (layer23_aligned_data_tail_ptr != 0);
    end
    assign aligned_data_read_ptr_move_max = aligned_data_accumulate_num_mask | (~layer23_aligned_data_valid_handle_group);

    assign layer23_fifo_packet_enqueue_num = layer23_fifo_packet_remain_num > layer23_aligned_data_accumulate_num[4] ? layer23_aligned_data_accumulate_num[4] : layer23_fifo_packet_remain_num;

    priority_encoder #(.WIDTH(5)) pen(
        .req(aligned_data_read_ptr_move_max),
        .gnt(aligned_data_read_ptr_move),
        .valid(aligned_data_read_ptr_move_not_full)
    );

    // update the layer23_data_fifo_read_ptr, move the layer23_data_fifo_read_ptr only when "layer23_aligned_data_read_ptr > 4"
    assign layer23_data_fifo_read_ptr_next = (layer23_aligned_data_read_ptr_next > 4) ? layer23_data_fifo_read_ptr + 1'b1 : layer23_data_fifo_read_ptr;
    always_ff@(posedge layer23_gated_clk or negedge rst_n) begin
        if(!rst_n | start) begin
            layer23_data_fifo_read_ptr  <= '0;
        end
        else if(!data_fifo_layer23_empty & !layer23_stall) begin
            layer23_data_fifo_read_ptr  <= layer23_data_fifo_read_ptr_next;
        end
    end

    // update the layer23_aligned_data_read_ptr
    assign layer23_aligned_data_read_ptr_next = !aligned_data_read_ptr_move_not_full ? layer23_aligned_data_read_ptr + 5 : layer23_aligned_data_read_ptr + aligned_data_read_ptr_move;
    always_ff@(posedge layer23_gated_clk or negedge rst_n) begin
        if(!rst_n | start) begin
            layer23_aligned_data_read_ptr  <= '0;
        end
        else if (!layer23_stall) begin
            layer23_aligned_data_read_ptr  <= (layer23_aligned_data_read_ptr_next > 4) ? layer23_aligned_data_read_ptr_next - 5 : layer23_aligned_data_read_ptr_next;
        end
    end

    // update the layer23_fifo_packet_remain_num
    assign layer23_fifo_packet_remain_num_next = (layer23_fifo_packet_remain_num > layer23_aligned_data_accumulate_num[4]) ? layer23_fifo_packet_remain_num - layer23_aligned_data_accumulate_num[4] : 8;
    always_ff@(posedge layer23_gated_clk or negedge rst_n) begin
        if(!rst_n) begin
            layer23_fifo_packet_remain_num <= 8;
        end
        else if (!layer23_stall) begin
            layer23_fifo_packet_remain_num <= layer23_fifo_packet_remain_num_next;
        end
    end

    /// generate the fifo output for layer23 ///

    assign layer23_fifo_packet_ptr = 8 - layer23_fifo_packet_remain_num;
    assign compress_unit_val_valid = ~aligned_data_read_ptr_move_max;
    for(genvar i = 0; i < 5; i=i+1) begin: compress_unit_val_position_gen
        assign compress_unit_val_position[i] = layer23_aligned_data_accumulate_num[i]-1;
    end

    // align the element output to the fifo_packet, start from index 0
    always_comb begin
        layer23_fifo_packet_comb = '0;
        for(integer i = 0; i < 5; i=i+1) begin
            if(compress_unit_val_valid[i]) begin
                layer23_fifo_packet_comb.data[compress_unit_val_position[i]] = layer23_aligned_data[layer23_aligned_data_read_ptr+i].val;
            end
        end
        layer23_fifo_packet_comb.valid_mask = {8{1'b1}} >> (8-layer23_fifo_packet_enqueue_num);
    end

    // check if has already send all ifmap data
    assign layer23_sending_last_packet = (layer23_data_counter_read == layer23_data_counter_read_upper-2) & layer23_handshake & (layer23_aligned_data_accumulate_num[4] > 0) | (layer23_data_counter_read == layer23_data_counter_read_upper-1) & (layer23_aligned_data_accumulate_num[4] > 0);
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start) begin
            layer23_send_all <= 2'b0;
        end
        else if(layer23_send_all == 2'b1 & layer23_handshake) begin
            layer23_send_all <= 2'b11;
        end
        else if(layer23_sending_last_packet) begin
            layer23_send_all <= 2'b1;
        end
    end
    
    // assign the aligned element to fifo_packet from the fifo_packet_ptr
    assign layer23_handshake = decompressor_ack & ifmap_buffer_req;
    always_comb begin
        layer23_fifo_packet_next = layer23_handshake ? '0 : layer23_fifo_packet;
        for(integer i = 0; i < 8; i = i+1) begin
            if(layer23_fifo_packet_ptr + i < 8 && layer23_fifo_packet_comb.valid_mask[i]) begin
                layer23_fifo_packet_next.data[layer23_fifo_packet_ptr + i]           = layer23_fifo_packet_comb.data[i];
                layer23_fifo_packet_next.valid_mask[layer23_fifo_packet_ptr + i]     = 1'b1;
            end
        end

        layer23_fifo_packet_next.packet_valid = ( &layer23_fifo_packet_next.valid_mask |  layer23_sending_last_packet | layer23_send_all == 2'b1) & ~(&layer23_send_all | layer23_send_all == 2'b1 & layer23_handshake); // the conor case for last serval elements can not fill the full fifo_packet, 27 * 27 = 8 * 91 + 1, 13 * 13 = 8 * 21 + 1

        layer23_fifo_packet_next.valid_mask =  layer23_sending_last_packet | layer23_send_all == 2'b1  ? 8'b1 : layer23_fifo_packet_next.valid_mask; // the last decompress group, only the the first bit of valid mask should be 1;
    end

    assign layer23_data_counter_read_upper = layer_type == LAYER2 ? 92 :
                                             layer_type == LAYER3 ? 22 : 0;
    always_ff@(posedge layer23_gated_clk or negedge rst_n) begin
        if(!rst_n | start) begin
            layer23_data_counter_read <= '0;
        end
        else if(layer23_handshake) begin
            layer23_data_counter_read <= layer23_data_counter_read == layer23_data_counter_read_upper ? layer23_data_counter_read_upper : layer23_data_counter_read + 1'b1;
        end
    end

    always_ff@(posedge layer23_gated_clk or negedge rst_n) begin
        if(!rst_n | start) begin
            layer23_fifo_packet <= '0;
        end
        else begin
            layer23_fifo_packet <= layer23_fifo_packet_next;
        end
    end


    /// Output of Decompressor
    assign decompressor_ack = decompress_fifo_packet.packet_valid;
    assign mem_req = (fetch_layer1 | fetch_layer23) & enable;
    assign decompress_fifo_packet = (layer_type == LAYER1) ? layer1_fifo_packet : layer23_fifo_packet;

    `ifdef DV
    // 1. Assertion 1
    logic data_fifo_empty;
    assign data_fifo_empty = (layer_type == LAYER1) && (data_fifo_write_ptr == layer1_data_fifo_read_ptr ) ||
                             (layer_type == LAYER2 || layer_type == LAYER3) && (data_fifo_write_ptr == layer23_data_fifo_read_ptr);
    ASSERT_ALWAYS #(.MSG("Decompressor do not ack when data fifo is not empty")) decompressor_ack_chk(
        .clk(clk),
        .rst_n(rst_n),
        .en(ifmap_buffer_req & enable & !data_fifo_empty),
        .expr(decompressor_ack)
    );

    // 2. Assertion 2
    // in one cycyle , aligned_data_read_ptr can not move more than 5
    logic [2:0] aligned_data_read_ptr_move_num;
    logic aligned_ptr_move_limit;
    assign aligned_data_read_ptr_move_num = layer23_aligned_data_read_ptr_next - layer23_aligned_data_read_ptr;
    assign aligned_ptr_move_limit = aligned_data_read_ptr_move_num > 5;

    ASSERT_NEVER #(.MSG("Aligned data read ptr move more than 5")) aligned_data_read_ptr_chk(
        .clk(clk),
        .rst_n(rst_n),
        .en(enable),
        .expr(aligned_ptr_move_limit)
    );

    // 3. Assertion 3
    // data fifo fetch ptr can not pass data fifo write ptr
    logic data_fifo_fetch_ptr_pass;
    assign data_fifo_fetch_ptr_pass = (data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)-1:0] >  data_fifo_read_ptr[$clog2(DATA_FIFO_DEPTH)-1:0]) & (data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)] ^ data_fifo_read_ptr[$clog2(DATA_FIFO_DEPTH)]) | 
                                      (data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)-1:0] < data_fifo_read_ptr[$clog2(DATA_FIFO_DEPTH)-1:0]) & (data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)] == data_fifo_read_ptr[$clog2(DATA_FIFO_DEPTH)]);
    ASSERT_NEVER #(.MSG("data fifo fetch ptr pass read ptr")) data_fifo_fetch_ptr_chk(
        .clk(clk),
        .rst_n(rst_n),
        .en(enable),
        .expr(data_fifo_fetch_ptr_pass)
    );

    // 4. Assertion 4
    // date fifo write ptr can not pass data fifo fetch ptr
    logic data_fifo_write_ptr_pass;
    assign data_fifo_write_ptr_pass = (data_fifo_write_ptr[$clog2(DATA_FIFO_DEPTH)-1:0] < data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)-1:0]) & (data_fifo_write_ptr[$clog2(DATA_FIFO_DEPTH)] ^ data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)]) | 
                                      (data_fifo_write_ptr[$clog2(DATA_FIFO_DEPTH)-1:0] > data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)-1:0]) & (data_fifo_write_ptr[$clog2(DATA_FIFO_DEPTH)] == data_fifo_fetch_ptr[$clog2(DATA_FIFO_DEPTH)]);
    ASSERT_NEVER #(.MSG("datan fifo write ptr pass fetch ptr")) data_fifo_write_ptr_chk(
        .clk(clk),
        .rst_n(rst_n),
        .en(enable),
        .expr(data_fifo_write_ptr_pass)
    );

    // 5. Assertion 5
    // aligned data read ptr move to invalid section
    logic aligned_data_read_ptr_invalid;
    assign aligned_data_read_ptr_invalid = layer23_data_fifo_read_ptr_next > 5 & ~layer23_aligned_data_valid_group[1];
    ASSERT_NEVER #(.MSG("Aligned data fetch move to invalid area")) aligned_data_read_ptr_invalid_chk(
        .clk(clk),
        .rst_n(rst_n),
        .en(enable),
        .expr(aligned_data_read_ptr_invalid)
    );

    // 6. Assertion 6
    // layer23_aligned_data_compress_unit_num should be 0 if unit is in invalid group
    logic [4:0] unit_invalid;
    for(genvar i = 0; i < 5; i=i+1) begin : unit_invalid_gen
        assign unit_invalid[i] = layer23_aligned_data_read_ptr+i > 4 & ~layer23_aligned_data_valid_group[1];
    end
    for(genvar i = 0; i < 5; i=i+1) begin: aligned_data_read_ptr_invalid_checker
        ASSERT_ALWAYS #(.MSG("compress_unit_num is not 0 for invalid unit")) aligned_data_read_ptr_invalid_chk(
            .clk(clk),
            .rst_n(rst_n),
            .en(enable & unit_invalid[i]),
            .expr(layer23_aligned_data_compress_unit_num[i] == 0)
        );
    end
    `endif 

endmodule