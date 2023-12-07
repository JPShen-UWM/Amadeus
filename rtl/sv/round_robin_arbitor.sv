module round_robin_arbitor #(parameter WIDTH = 6)(
    input clk,
    input rst_n,
    input [WIDTH-1:0] req,

    output [WIDTH-1:0] gnt
);

    logic [WIDTH-1:0] position_reg;
    logic [WIDTH-1:0] position_reg_next;

    logic [WIDTH-1:0] req_high;
    logic [WIDTH-1:0] req_mask_high;
    logic [WIDTH-1:0] gnt_high;

    logic [WIDTH-1:0] req_low;
    logic [WIDTH-1:0] req_mask_low;
    logic [WIDTH-1:0] gnt_low;

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            position_reg <= {WIDTH{1'b1}};
        end
        else begin
            position_reg <= position_reg_next;
        end
    end

    assign req_high = req & position_reg;
    assign req_mask_high = req_high | {req_mask_high[WIDTH-2:0],1'b0};
    assign gnt_high = req_mask_high & ~(req_mask_high << 1'b1);

    assign req_low = req & ~position_reg;
    assign req_mask_low = req_low | {req_mask_low[WIDTH-2:0],1'b0};
    assign gnt_low = req_mask_low & ~(req_mask_low << 1'b1);

    assign gnt = |gnt_high ? gnt_high : gnt_low;

    assign position_reg_next = (|gnt_high ? req_mask_high : req_mask_low) << 1'b1;

endmodule