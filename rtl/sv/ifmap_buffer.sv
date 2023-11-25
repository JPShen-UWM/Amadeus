module ifmap_buffer(
    input clk,
    input rst_n,
    input start,
    input LAYER_TYPE layer_type,
    input DECOMRPESS_FIFO_PACKET decompressed_fifo_packet,
    input decompressor_ack,
    input complete, // The PE are done with a part of input feature map(layer 1), full input feature map(layer 2)
    output global_buffer_req,
    output logic []
);

    logic [34:0][256*8-1:0] memory_batch1;
    logic [34:0][256*8-1:0] memory_batch2;
    logic [5:0] memory_batch1_write_ptr; // the ptr on memory batch entry granularity
    logic [7:0] memory_batch1_line_write_ptr; // the ptr on line element granularity(1 byte) for each line in memory batch
    logic [5:0] memory_batch2_write_ptr;
    logic [7:0] memory_batch2_line_write_ptr;

    logic [5:0] memory_batch1_write_entry_counter;
    logic [5:0] memory_batch1_write_element_counter;
    logic [5:0] memory_batch2_write_entry_counter;
    logic [5:0] memory_batch2_write_element_counter;

    logic [1:0] ready; // if one batch of memory is full and is ready to deliver data to PEs
    logic [1:0] chosen_enqueue; // if this batch is chosen for enqueue from memory
    logic [1:0] chosen_dequeue; // if this batch is chosen for dequeue to PEs

    /// enqueue and dequeue ///
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
            
        end
        else begin
        end
    end

    /// memory batch ///
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
             memory_batch1 <= '0;
        end
        else begin
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
             memory_batch2 <= '0;
        end
        else begin
        end
    end


endmodule