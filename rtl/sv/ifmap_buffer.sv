module ifmap_buffer(
    input clk,
    input rst_n,
    input start,
    input start_layer,
    input LAYER_TYPE layer_type_in,
    input DECOMRPESS_FIFO_PACKET decompressed_fifo_packet,
    input decompressor_ack,
    input free_ifmap_buffer, // from controller, means this memory batch will not be used anymore need to free this memory batch

    output ifmap_buffer_req,
    output logic [`MEM_BATCH_SIZE-1:0][256-1:0][7:0] ifmap_data,
    output ifmap_data_valid,
    output ifmap_data_change // send to controller, represent ifmap data is ready for a new conv, used for handshake to start the new start_conv
);
    // when there is one ready in memory batch, COUNT++
    localparam LAYER1_READY_COUNT = 8;
    localparam LAYER23_READY_COUNT = 1;
    // The num of line occupied in memory batch in different layer
    localparam LAYER1_LINE_COUNT = 35;
    localparam LAYER1_LINE_COUNT_LAST_ITERATION = 31;
    localparam LAYER2_LINE_COUNT = 27;
    localparam LAYER3_LINE_COUNT = 13;
    // The num of elelment in one line in different layer
    localparam LAYER1_ELEMENT_COUNT = 227; // 227 = 28 * 8 + 3
    localparam LAYER2_ELEMENT_COUNT = 27;  // 27  = 3 * 8 + 3
    localparam LAYER3_ELEMENT_COUNT = 13;  // 13  = 1 * 8 + 5
    logic [`MEM_BATCH_SIZE-1:0][255:0][7:0] memory_batch1;
    logic [`MEM_BATCH_SIZE-1:0][255:0][7:0] memory_batch2;
    logic [5:0] memory_batch1_line_write_ptr; // the ptr on memory batch entry granularity
    logic [5:0] memory_batch1_line_write_ptr_next;
    logic [7:0] memory_batch1_element_write_ptr; // the ptr on line element granularity(1 byte) for each line in memory batch
    logic [7:0] memory_batch1_element_write_ptr_cross;
    logic [7:0] memory_batch1_element_write_ptr_next;
    logic [5:0] memory_batch2_line_write_ptr;
    logic [7:0] memory_batch2_element_write_ptr;
    logic [5:0] memory_batch2_line_write_ptr_next;
    logic [7:0] memory_batch2_element_write_ptr_next;

    logic [5:0] memory_batch_line_write_counter;
    logic [5:0] memory_batch2_line_write_counter; // taking the last iteration into consideration
    logic [7:0] memory_batch_element_write_counter;

    // status variable
    logic stop_req; // stop require new data when we get the full input feature map in ifmap_buffer
    logic [1:0] ready; // if one batch of memory is full and is ready to deliver data to PEs
    logic [1:0] chosen_enqueue; // if this batch is chosen for enqueue from memory
    logic [1:0] chosen_dequeue; // if this batch is chosen for dequeue to PEs
    logic [1:0] free; // free the memory batch
    logic ifmap_buffer_decompressor_handshake;

    logic mem_batch1_wen;
    logic mem_batch2_wen;

    logic layer1_last_iteration;

    // others
    logic [3:0] valid_element_count;
    logic chosen_dequeue_m1;

    LAYER_TYPE layer_type;
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            layer_type <= NULL;
        end
        else if(start_layer) begin
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
        if(!rst_n | &ready) begin
            chosen_enqueue <= '0;
        end
        else if(start | ready == 0) begin
            chosen_enqueue <= 2'b01;
        end
        else if(^ready) begin
            chosen_enqueue <= ~ready;
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start) begin
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
    assign ready = {(memory_batch2_line_write_ptr == memory_batch2_line_write_counter), (memory_batch1_line_write_ptr == memory_batch_line_write_counter)};

    /// free ///
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start) begin
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
    assign ready_pulse = (  ( (memory_batch1_element_write_ptr + valid_element_count) >= memory_batch_element_write_counter ) & (memory_batch1_line_write_ptr == memory_batch_line_write_counter-1) & chosen_enqueue[0] |
                            ( (memory_batch2_element_write_ptr + valid_element_count) >= memory_batch_element_write_counter ) & (memory_batch2_line_write_ptr == memory_batch_line_write_counter-1) & chosen_enqueue[1] ) & 
                         ifmap_buffer_decompressor_handshake;
    assign ready_counter_upper =    (layer_type == LAYER1)                          ? LAYER1_READY_COUNT    :
                                    (layer_type == LAYER2 || layer_type == LAYER3)  ? LAYER23_READY_COUNT   : 0;

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start) begin
            ready_counter <= 0;
        end
        else if(ready_pulse)begin
            ready_counter <= ready_counter == ready_counter_upper ? ready_counter_upper : ready_counter + 1'b1;
        end
    end
    assign stop_req = ready_counter == ready_counter_upper;

    /// logic deal with decompressed_fifo_packet ///
    countones #(.WIDTH(8)) count(
        .in(decompressed_fifo_packet.valid_mask & {8{decompressed_fifo_packet.packet_valid}}),
        .count(valid_element_count)
    );

    assign ifmap_buffer_decompressor_handshake = ifmap_buffer_req & decompressor_ack;

    /// write ptr logic ///
    // set the upper counter limit according to different layer
    assign memory_batch_element_write_counter = (layer_type == LAYER1) ? LAYER1_ELEMENT_COUNT :
                                                (layer_type == LAYER2) ? LAYER2_ELEMENT_COUNT :
                                                (layer_type == LAYER3) ? LAYER3_ELEMENT_COUNT : 0;

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start) begin
            layer1_last_iteration <= 1'b0;
        end
        else if( (ready_counter > 6 & chosen_enqueue[1]) & (layer_type == LAYER1) ) begin
            layer1_last_iteration <= 1'b1;
        end
    end
    
    assign memory_batch_line_write_counter = (layer_type == LAYER1) ? LAYER1_LINE_COUNT :
                                             (layer_type == LAYER2) ? LAYER2_LINE_COUNT :
                                             (layer_type == LAYER3) ? LAYER3_LINE_COUNT : 0;

    assign memory_batch2_line_write_counter = layer1_last_iteration ?  LAYER1_LINE_COUNT_LAST_ITERATION : memory_batch_line_write_counter;

    // update write element and line ptr for memory batch1
    assign memory_batch1_element_write_ptr_next = ( (memory_batch1_element_write_ptr + valid_element_count) >= memory_batch_element_write_counter ) ? memory_batch1_element_write_ptr + valid_element_count - memory_batch_element_write_counter : memory_batch1_element_write_ptr + valid_element_count;

    assign memory_batch1_line_write_ptr_next = ( (memory_batch1_element_write_ptr + valid_element_count) < memory_batch_element_write_counter ) ? memory_batch1_line_write_ptr      :
                                               ( (memory_batch1_line_write_ptr == memory_batch_line_write_counter) )                            ? memory_batch_line_write_counter   : memory_batch1_line_write_ptr+ 1;


    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start) begin
            memory_batch1_element_write_ptr <= '0;
            memory_batch1_line_write_ptr    <= '0;
        end
        else if(free[0]) begin
            memory_batch1_element_write_ptr <= '0;
            memory_batch1_line_write_ptr    <= layer_type == LAYER1 ? 7 : 0;
        end
        else if(chosen_enqueue[0] && ifmap_buffer_decompressor_handshake) begin
            memory_batch1_element_write_ptr <= memory_batch1_element_write_ptr_next;
            memory_batch1_line_write_ptr    <= memory_batch1_line_write_ptr_next;
        end
    end

    // update write element and line ptr for memory batch2
    assign memory_batch2_element_write_ptr_next = ( (memory_batch2_element_write_ptr + valid_element_count) >= memory_batch_element_write_counter ) ? memory_batch2_element_write_ptr + valid_element_count - memory_batch_element_write_counter : memory_batch2_element_write_ptr + valid_element_count;

    assign memory_batch2_line_write_ptr_next = ( (memory_batch2_element_write_ptr + valid_element_count) < memory_batch_element_write_counter ) ? memory_batch2_line_write_ptr      :
                                               ( (memory_batch2_line_write_ptr == memory_batch_line_write_counter) )                            ? memory_batch_line_write_counter   : memory_batch2_line_write_ptr  + 1;

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start | free[1]) begin
            memory_batch2_element_write_ptr <= '0;
            memory_batch2_line_write_ptr    <=  7;
        end
        else if(free[1]) begin
            memory_batch2_element_write_ptr <= '0;
            memory_batch2_line_write_ptr    <= layer_type == LAYER1 ? 7 : 0;
        end
        else if(chosen_enqueue[1] && ifmap_buffer_decompressor_handshake) begin
            memory_batch2_element_write_ptr <= memory_batch2_element_write_ptr_next;
            memory_batch2_line_write_ptr    <= memory_batch2_line_write_ptr_next;
        end
    end

    /// memory batch data ///
    assign mem_batch1_wen = chosen_enqueue[0] & ifmap_buffer_decompressor_handshake & !ready[0];
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start | free[0]) begin
            memory_batch1 <= '0;
        end
        else if(free[1]) begin
            memory_batch1[6:0] <= memory_batch2[34:28];
        end
        else if (mem_batch1_wen) begin
            for(integer i = 0; i < `IFMP_DATA_SIZE; i=i+1) begin
                if(memory_batch1_element_write_ptr + i < memory_batch_element_write_counter) begin
                    memory_batch1[memory_batch1_line_write_ptr][memory_batch1_element_write_ptr+i] <= decompressed_fifo_packet.valid_mask[i] ? decompressed_fifo_packet.data[i] : memory_batch1[memory_batch1_line_write_ptr][memory_batch1_element_write_ptr+i];
                end
                else if(memory_batch1_line_write_ptr+1 < `MEM_BATCH_SIZE) begin
                    memory_batch1[memory_batch1_line_write_ptr+1][memory_batch1_element_write_ptr-memory_batch_element_write_counter+i] <= decompressed_fifo_packet.valid_mask[i] ? decompressed_fifo_packet.data[i] : memory_batch1[memory_batch1_line_write_ptr+1][memory_batch1_element_write_ptr-memory_batch_element_write_counter+i];
                end
            end
        end
    end

    assign mem_batch2_wen = chosen_enqueue[1] & ifmap_buffer_decompressor_handshake & !ready[1];
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start | free[1]) begin
             memory_batch2 <= '0;
        end
        else if(free[0]) begin
            memory_batch2[6:0] <= memory_batch1[34:28];
        end
        else if(mem_batch2_wen) begin
            for(integer i = 0; i < `IFMP_DATA_SIZE; i=i+1) begin
                if(memory_batch2_element_write_ptr + i < memory_batch_element_write_counter) begin
                    memory_batch2[memory_batch2_line_write_ptr][memory_batch2_element_write_ptr+i] <= decompressed_fifo_packet.valid_mask[i] ? decompressed_fifo_packet.data[i] : memory_batch2[memory_batch2_line_write_ptr][memory_batch2_element_write_ptr+i];
                end
                else if(memory_batch2_line_write_ptr+1 < `MEM_BATCH_SIZE) begin
                    memory_batch2[memory_batch2_line_write_ptr+1][memory_batch2_element_write_ptr-memory_batch_element_write_counter+i] <= decompressed_fifo_packet.valid_mask[i] ? decompressed_fifo_packet.data[i] : memory_batch2[memory_batch2_line_write_ptr+1][memory_batch2_element_write_ptr-memory_batch_element_write_counter+i];
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
            chosen_dequeue_m1 <= '0;
        end
        else begin
            chosen_dequeue_m1 <= chosen_dequeue;
        end
    end
    assign ifmap_data_change = chosen_dequeue != chosen_dequeue_m1 & ifmap_data_valid;





    ////////////////////////////////////// DV SECTION //////////////////////////////////////
    `ifdef DV
    logic enable_assert;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            enable_assert <= 1'b0;
        end
        else if(start) begin
            enable_assert <= 1'b1;
        end
    end
    // 1. Assertion 1
    // layer element write ptr limit
    logic layer1_element_write_ptr_limit;
    assign layer1_element_write_ptr_limit = (memory_batch1_element_write_ptr < LAYER1_ELEMENT_COUNT) & (memory_batch2_element_write_ptr < LAYER1_ELEMENT_COUNT);
    ASSERT_ALWAYS #(.MSG("layer1_element_write_ptr should < 227")) layer1_element_write_ptr_chk (
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & (layer_type == LAYER1)),
        .expr(layer1_element_write_ptr_limit)
    );

    logic layer2_element_write_ptr_limit;
    assign layer2_element_write_ptr_limit = (memory_batch1_element_write_ptr < LAYER2_ELEMENT_COUNT) & (memory_batch2_element_write_ptr < LAYER2_ELEMENT_COUNT);
    ASSERT_ALWAYS #(.MSG("layer2_element_write_ptr should < 27")) layer2_element_write_ptr_chk (
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & (layer_type == LAYER2)),
        .expr(layer2_element_write_ptr_limit)
    );

    logic layer3_element_write_ptr_limit;
    assign layer3_element_write_ptr_limit = (memory_batch1_element_write_ptr < LAYER3_ELEMENT_COUNT) & (memory_batch2_element_write_ptr < LAYER3_ELEMENT_COUNT);
    ASSERT_ALWAYS #(.MSG("layer3_element_write_ptr should < 13")) layer3_element_write_ptr_chk (
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & (layer_type == LAYER3)),
        .expr(layer3_element_write_ptr_limit)
    );

    // 2. Assertion 2
    // layer line write ptr limit
    logic layer1_line_write_ptr_limit;
    assign layer1_line_write_ptr_limit = (memory_batch1_line_write_ptr <= LAYER1_LINE_COUNT) & (memory_batch1_line_write_ptr <= LAYER1_LINE_COUNT);
    ASSERT_ALWAYS #(.MSG("layer1_line_write_ptr shoud <= 35")) layer1_line_write_ptr_chk (
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & (layer_type == LAYER1)),
        .expr(layer1_line_write_ptr_limit)
    );

    logic layer2_line_write_ptr_limit;
    assign layer2_line_write_ptr_limit = (memory_batch1_line_write_ptr <= LAYER2_LINE_COUNT) & (memory_batch1_line_write_ptr <= LAYER2_LINE_COUNT);
    ASSERT_ALWAYS #(.MSG("layer1_line_write_ptr should <= 27")) layer2_line_write_ptr_chk (
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & (layer_type == LAYER2)),
        .expr(layer2_line_write_ptr_limit)
    );

    logic layer3_line_write_ptr_limit;
    assign layer3_line_write_ptr_limit = (memory_batch1_line_write_ptr <= LAYER3_LINE_COUNT) & (memory_batch1_line_write_ptr <= LAYER3_LINE_COUNT);
    ASSERT_ALWAYS #(.MSG("layer3_line_write_ptr should <= 13")) layer3_line_write_ptr_chk (
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & (layer_type == LAYER3)),
        .expr(layer3_line_write_ptr_limit)
    );

    // Assertion 3
    // for layer1, element_write_ptr + valid_element_count should no more than 227
    logic layer1_element_write_ptr_update_limit;
    assign layer1_element_write_ptr_update_limit = (memory_batch1_element_write_ptr + valid_element_count) > LAYER1_ELEMENT_COUNT & chosen_enqueue[0] | (memory_batch2_element_write_ptr + valid_element_count) > LAYER1_ELEMENT_COUNT & chosen_enqueue[1];
    ASSERT_NEVER #(.MSG("element_write_ptr + valid_element_count should not > 227 for layer1")) layer1_element_write_ptr_update_chk (
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & (layer_type == LAYER1)),
        .expr(layer1_element_write_ptr_update_limit)
    );

    // Assertion 4 
    // write_ptr position check when ready
    // 1. for write_element_ptr
    //  when ready, the write_element_ptr should point at 0 for all layer
    ASSERT_ALWAYS #(.MSG("batch1_write_element_ptr should point at 0 when ready")) batch1_write_element_ptr_ready_position_chk (
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & ready[0]),
        .expr(memory_batch1_element_write_ptr == 0)
    );
    ASSERT_ALWAYS #(.MSG("batch2_write_element_ptr should point at 0 when ready")) batch2_write_element_ptr_ready_position_chk (
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & ready[1]),
        .expr(memory_batch2_element_write_ptr == 0)
    );

    // 2. for write_line_ptr
    //  when ready, the write_element_ptr should point at 35 for layer1, 27 for layer 2, 13 for layer3
    logic write_line_ptr_ready_position_batch1;
    assign write_line_ptr_ready_position_batch1 = (layer_type == LAYER1 & memory_batch1_line_write_ptr == 35) | 
                                                  (layer_type == LAYER2 & memory_batch1_line_write_ptr == 27) | 
                                                  (layer_type == LAYER3 & memory_batch1_line_write_ptr == 13);
    logic write_line_ptr_ready_position_batch2;
    assign write_line_ptr_ready_position_batch2 = (layer_type == LAYER1 & memory_batch2_line_write_ptr == 35) | 
                                                  (layer_type == LAYER2 & memory_batch2_line_write_ptr == 27) | 
                                                  (layer_type == LAYER3 & memory_batch2_line_write_ptr == 13);
    ASSERT_ALWAYS #(.MSG("batch1_write_line_ptr do not point at correct position when ready")) batch1_write_line_ptr_ready_position_chk (
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & ready[0]),
        .expr(write_line_ptr_ready_position_batch1)
    );
    ASSERT_ALWAYS #(.MSG("batch2_write_line_ptr do not point at correct position when ready")) batch2_write_line_ptr_ready_position_chk (
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & ready[1] & ~layer1_last_iteration),
        .expr(write_line_ptr_ready_position_batch2)
    );


    // Assertion 5
    // can not update the invalid postion in memory batch
    logic write_invalid_mem_batch1;
    logic write_invalid_mem_batch2;
    assign write_invalid_mem_batch1 = mem_batch1_wen & (memory_batch1_line_write_ptr >= `MEM_BATCH_SIZE);
    assign write_invalid_mem_batch2 = mem_batch2_wen & (memory_batch2_line_write_ptr >= `MEM_BATCH_SIZE);
    ASSERT_NEVER #(.MSG("data write into invalid space of mem batch")) write_invalid_mem_batch_chk(
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert),
        .expr(write_invalid_mem_batch1 | write_invalid_mem_batch2)
    );

    // Assertion 6
    // enqueue should not be all hot
    ASSERT_NEVER #(.MSG("enqueue should not be all hot")) chosen_enqueue_hot_chk(
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert),
        .expr(&chosen_enqueue)
    );

    // Assertion 7
    // dequeue should not be all hot
    ASSERT_NEVER #(.MSG("dequeue should not be all hot")) chosen_dequeue_hot_chk(
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert),
        .expr(&chosen_dequeue)
    );

    // Assertion 8
    // chosen_enqueue should not be the ready memory batch
    logic [1:0] ready_m1;
    logic read_changed;
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            ready_m1 <= '0;
        end
        else begin
            ready_m1 <= ready;
        end
    end
    assign ready_changed = ready_m1 != ready;
    
    ASSERT_NEVER #(.MSG(" chosen_enqueue should not be the ready memory batch")) chosen_enqueue_ready_chk(
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & (^ready) & ~ready_changed),
        .expr(| (chosen_enqueue & ready))
    );

    // Assertion 9
    // chosen_dequeue should not be the not ready memory batch
    ASSERT_NEVER #(.MSG("chosen_dequeue should not be the not ready memory batch")) chosen_dequeue_ready_chk(
        .clk(clk),
        .rst_n(rst_n),
        .en(enable_assert & (^ready) & ~ready_changed),
        .expr(|(chosen_dequeue & ~ready))
    );

    `endif 

endmodule