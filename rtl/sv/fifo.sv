module fifo#(parameter DEPTH = 8, WIDTH = 8)(
    input clk,
    input rst_n,
    input wen,
    input ren,
    input [WIDTH-1:0] data_in,
    output [WIDTH-1:0] data_out,
    output data_valid
);
    logic [$clog2(DEPTH):0] counter;
    logic [$clog2(DEPTH):0] rptr_next;
    logic [$clog2(DEPTH):0] wptr_next;
    logic [$clog2(DEPTH):0] rptr_next;
    logic [$clog2(DEPTH):0] wptr_next;

    logic [DEPTH-1:0][WIDTH-1:0] fifo_data;

    logic full,empty;

    // update counter
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            counter <= '0;
        end
        else if(wen & !full) begin
            counter <= counter + 1'b1;
        end
        else if(ren & !empty) begin
            counter <= counter - 1'b1;
        end
    end

    // update rptr and wptr
    assign rptr_next = ren & !empty ? rptr + 1'b1 : rptr;
    assign wptr_next = wen & !full  ? wptr + 1'b1 : wptr;
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rptr <= '0;
            wptr <= '0;
        end
        else begin
            rptr <= (rptr_next == DEPTH) ? 0 : rptr_next;
            wptr <= (wptr_next == DEPTH) ? 0 : wptr_next;
        end
    end

    assign full = counter == DEPTH;
    assign empty = counter == 0;

    // update fifo data
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            fifo_data <= '0;
        end
        else if(!full & wen) begin
            fifo_data[wptr] <= data_in;
        end
    end

    assign data_out = fifo_data[rptr];
    assign data_valid = !empty;
endmodule