module ifmap_buffer(
    input clk,
    input rst_n,
    input start,
    input LAYER_TYPE layer_type_in,
    input DECOMRPESS_FIFO_PACKET decompressed_fifo_packet,
    input decompressor_ack,
    input free_ifmap_buffer, // from controller, means this memory batch will not be used anymore need to free this memory batch

    output ifmap_buffer_req,
    output logic [34:0][256*8-1:0] ifmap_data,
    output ifmap_data_valid,
    output ifmap_data_change // send to controller, represent ifmap data is ready for a new conv, used for handshake to start the new start_conv
);
    // when there is one ready in memory batch, COUNT++
    localparam LAYER1_READY_COUNT = 8;
    localparam LAYER23_READY_COUNT = 1;
    // The num of line occupied in memory batch in different layer
    localparam LAYER1_LINE_COUNT = 35;
    localparam LAYER2_LINE_COUNT = 27;
    localparam LAYER3_LINE_COUNT = 13;
    // The num of elelment in one line in different layer
    localparam LAYER1_ELEMENT_COUNT = 227; // 227 = 28 * 8 + 3
    localparam LAYER2_ELEMENT_COUNT = 27;  // 27  = 3 * 8 + 3
    localparam LAYER3_ELEMENT_COUNT = 13;  // 13  = 1 * 8 + 5
    logic [34:0][256*8-1:0] memory_batch1;
    logic [34:0][256*8-1:0] memory_batch2;
    logic [5:0] memory_batch1_line_write_ptr; // the ptr on memory batch entry granularity
    logic [5:0] memory_batch1_line_write_ptr_next;
    logic [7:0] memory_batch1_element_write_ptr; // the ptr on line element granularity(1 byte) for each line in memory batch
    logic [7:0] memory_batch1_element_write_ptr_next;
    logic [5:0] memory_batch2_line_write_ptr;
    logic [7:0] memory_batch2_element_write_ptr;
    logic [5:0] memory_batch2_line_write_ptr_next;
    logic [7:0] memory_batch2_element_write_ptr_next;

    logic [5:0] memory_batch_line_write_counter;
    logic [5:0] memory_batch_element_write_counter;

    // status variable
    logic stop_req; // stop require new data when we get the full input feature map in ifmap_buffer
    logic [1:0] ready; // if one batch of memory is full and is ready to deliver data to PEs
    logic [1:0] chosen_enqueue; // if this batch is chosen for enqueue from memory
    logic [1:0] chosen_dequeue; // if this batch is chosen for dequeue to PEs
    logic [1:0] free; // free the memory batch
    logic global_buffer_decompressor_handshake;
    logic stop_loading;

    // others
    logic [3:0] valid_element_count;
    logic chosen_dequeue_m1;

    LAYER_TYPE layer_type;
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            layer_type <= NULL;
        end
        else if(start) begin
            layer_type <= layer_type_in;
        end
    end

    /// The cycle for two batch is full, free one and enqueue the empty batch
    /// |''''''|......|''''''|......|''''''|......|''''''|......|''''''|.......|
    ///  free_signal        free          ready       en/dequeue
    ///                                           | set wptr = 7|  start request new data and write in from 7 line |

    /// The cycle for one batch is just full, enqueue the other batch
    /// |''''''|......|''''''|......|''''''|......|
    ///       full         ready       en/dequeue
    /// enqueue and dequeue ///
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or &ready) begin
            chosen_enqueue <= '0;
        end
        else if(start or ready == 0) begin
            chosen_enqueue <= 2'b01;
        end
        else if(^ready) begin
            chosen_enqueue <= ~ready;
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
            chosen_dequeue <= '0;
        end
        else if(!(|ready)) begin
            chosen_dequeue <= '0;
        end
        else if(^ready) begin
            chosen_dequeue <= ready;
        end
    end

    /// ready ///
    assign ready = {(memory_batch2_line_write_ptr == memory_batch_line_write_counter), (memory_batch1_line_write_ptr == memory_batch_line_write_counter)};

    /// free ///
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
            free <= 2'b0;
        end
        else if(free_ifmap_buffer) begin
            free <= ready & chosen_dequeue;
        end
        else begin
            free <= 2'b0;
        end
    end

    /// stop_req ///
    // stop global buffer require after we get full input feature map
    logic [3:0] ready_counter;
    logic [3:0] ready_counter_upper;
    logic ready_pulse;
    assign ready_pulse = ( (memory_batch1_element_write_ptr + valid_element_count) >= memory_batch_element_write_counter ) & (memory_batch1_line_write_ptr == memory_batch_line_write_counter-1) ||
                         ( (memory_batch2_element_write_ptr + valid_element_count) >= memory_batch_element_write_counter ) & (memory_batch2_line_write_ptr == memory_batch_line_write_counter-1);
    assign ready_counter_upper =    (layer_type == LAYER1)                          ? LAYER1_READY_COUNT    :
                                    (layer_type == LAYER1 || layer_type == LAYER2)  ? LAYER23_READY_COUNT   : 0;

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
            ready_counter <= 0;
        end
        else if(ready_pulse)begin
            ready_counter <= ready_counter == ready_counter_upper ? ready_counter_upper : ready_counter + 1'b1;
        end
    end
    assign stop_req = ready_counter == ready_counter_upper;

    /// logic deal with decompressed_fifo_packet ///
    countones #(.WIDTH(8)) count(
        .input(decompress_fifo_packet.valid_mask & {8{decompress_fifo_packet.packet_valid}}),
        .output(valid_element_count)
    );

    assign global_buffer_decompressor_handshake = ifmap_buffer_req & decompressor_ack;

    /// write ptr logic ///
    // set the upper counter limit according to different layer
    assign memory_batch_element_write_counter = (layer_type == LAYER1) ? LAYER1_ELEMENT_COUNT :
                                                (layer_type == LAYER2) ? LAYER2_ELEMENT_COUNT :
                                                (layer_type == LAYER3) ? LAYER3_ELEMENT_COUNT : 0;

    assign memory_batch_line_write_counter = (layer_type == LAYER1) ? LAYER1_LINE_COUNT :
                                             (layer_type == LAYER2) ? LAYER2_LINE_COUNT :
                                             (layer_type == LAYER3) ? LAYER3_LINE_COUNT : 0;

    // update write element and line ptr for memory batch1
    assign memory_batch1_element_write_ptr_next = ( (memory_batch1_element_write_ptr + valid_element_count) >= memory_batch_element_write_counter ) ? memory_batch1_element_write_ptr - memory_batch_element_write_counter : memory_batch1_element_write_ptr + valid_element_count;

    assign memory_batch1_line_write_ptr_next = ( (memory_batch1_element_write_ptr + valid_element_count) < memory_batch_element_write_counter ) ? memory_batch1_line_write_ptr      :
                                               ( (memory_batch1_line_write_ptr == memory_batch_line_write_counter) )                            ? memory_batch_line_write_counter   : memory_batch1_line_write_ptr+ 1;


    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
            memory_batch1_element_write_ptr <= '0;
            memory_batch1_line_write_ptr    <= '0;
        end
        else if(free[0]) begin
            memory_batch1_element_write_ptr <= '0;
            memory_batch1_line_write_ptr    <= layer_type == LAYER1 ? 7 : 0;
        end
        else if(chosen_enqueue[0] && global_buffer_decompressor_handshake) begin
            memory_batch1_element_write_ptr <= memory_batch1_element_write_ptr_next;
            memory_batch1_line_write_ptr    <= memory_batch1_line_write_ptr_next;
        end
    end

    // update write element and line ptr for memory batch2
    assign memory_batch2_element_write_ptr_next = ( (memory_batch2_element_write_ptr + valid_element_count) >= memory_batch_element_write_counter ) ? memory_batch2_element_write_ptr - memory_batch_element_write_counter : memory_batch2_element_write_ptr + valid_element_count;

    assign memory_batch2_line_write_ptr_next = ( (memory_batch2_element_write_ptr + valid_element_count) < memory_batch_element_write_counter ) ? memory_batch2_line_write_ptr      :
                                               ( (memory_batch2_line_write_ptr == memory_batch_line_write_counter) )                            ? memory_batch_line_write_counter   : memory_batch2_line_write_ptr  + 1;

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start or free[1]) begin
            memory_batch2_element_write_ptr <= '0;
            memory_batch2_line_write_ptr    <= '0;
        end
        else if(free[1]) begin
            memory_batch2_element_write_ptr <= '0;
            memory_batch2_line_write_ptr    <= layer_type == LAYER1 ? 7 : 0;
        end
        else if(chosen_enqueue[1] && global_buffer_decompressor_handshake) begin
            memory_batch2_element_write_ptr <= memory_batch2_element_write_ptr_next;
            memory_batch2_line_write_ptr    <= memory_batch2_line_write_ptr_next;
        end
    end


    /// memory batch data ///
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start or free[0]) begin
            memory_batch1 <= '0;
        end
        else if(free[1]) begin
            memory_batch1[6:0] <= memory_batch2[6:0];
        end
        else if (chosen_enqueue[0] && global_buffer_decompressor_handshake && !ready[0]) begin
            for(integer i = 0; i < `IFMP_DATA_SIZE; i=i+1) begin
                if(memory_batch1_element_write_ptr + i < memory_batch_element_write_counter) begin
                    memory_batch1[memory_batch1_line_write_ptr][8*(memory_batch1_element_write_ptr+i)+7:8*(memory_batch1_element_write_ptr+i)] <= decompressed_fifo_packet.valid_mask[i] ? decompressed_fifo_packet.data[i] : memory_batch1[memory_batch1_line_write_ptr][8*(memory_batch1_element_write_ptr+i)+7:8*(memory_batch1_element_write_ptr+i)];
                end
                else begin
                    memory_batch1[memory_batch1_line_write_ptr+1][8*(memory_batch1_element_write_ptr-memory_batch_element_write_counter+i)+7:8*(memory_batch1_element_write_ptr-memory_batch_element_write_counter+i)] <= decompressed_fifo_packet.valid_mask[i] ? decompressed_fifo_packet.data[i] : memory_batch1[memory_batch1_line_write_ptr+1][8*(memory_batch1_element_write_ptr-memory_batch_element_write_counter+i)+7:8*(memory_batch1_element_write_ptr-memory_batch_element_write_counter+i)];
                end
            end
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start or free[1]) begin
             memory_batch2 <= '0;
        end
        else if(free[0]) begin
            memory_batch2[6:0] <= memory_batch1[6:0];
        end
        else if(chosen_enqueue[1] && global_buffer_decompressor_handshake && !ready[1]) begin
            for(integer i = 0; i < `IFMP_DATA_SIZE; i=i+1) begin
                if(memory_batch2_element_write_ptr + i < memory_batch_element_write_counter) begin
                    memory_batch2[memory_batch2_line_write_ptr][8*(memory_batch2_element_write_ptr+i)+7:8*(memory_batch2_element_write_ptr+i)] <= decompressed_fifo_packet.valid_mask[i] ? decompressed_fifo_packet.data[i] : memory_batch2[memory_batch2_line_write_ptr][8*(memory_batch2_element_write_ptr+i)+7:8*(memory_batch2_element_write_ptr+i)];
                end
                else begin
                    memory_batch2[memory_batch2_line_write_ptr+1][8*(memory_batch2_element_write_ptr-memory_batch_element_write_counter+i)+7:8*(memory_batch2_element_write_ptr-memory_batch_element_write_counter+i)] <= decompressed_fifo_packet.valid_mask[i] ? decompressed_fifo_packet.data[i] : memory_batch2[memory_batch2_line_write_ptr+1][8*(memory_batch2_element_write_ptr-memory_batch_element_write_counter+i)+7:8*(memory_batch2_element_write_ptr-memory_batch_element_write_counter+i)];
                end
            end
        end
    end

    /// output ///
    assign ifmap_buffer_req = |(chosen_enqueue & ~ready) & ~stop_req & ~(|free); // in free cycle, need to send the top 7 line of dequeue memory batch to enqueue memory batch
    assign ifmap_data = chosen_dequeue[0] ? memory_batch1 :
                        chosen_dequeue[1] ? memory_batch2 :
                                            '0;
    assign ifmap_data_valid = |chosen_dequeue;

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            chosen_dequeue_m1 <= '0
        end
        else begin
            chosen_dequeue_m1 <= chosen_dequeue;
        end
    end
    assign ifmap_data_change = chosen_dequeue != chosen_dequeue_m1 & ifmap_data_valid;

endmodule