module ASSERT_COND #(
    parameter MSG = "",
    parameter NUM_CYCLES = 0
)(
    input logic clk,
    input logic rst_n,
    input logic en,
    input logic cond,
    input logic expr
);

`ifndef ASSERT_COND
    logic [NUM_CYCLES:0] condDelayed;
    assign condDelayed[0] = cond;
    for(genvar cycle = 1; cycle <= NUM_CYCLES; cycle = cycle+1) begin: cond_delay_cycle
        always_ff@(posedge clk or negedge rst_n) begin
            condDelayed[cycle] <= rst_n ? condDelayed[cycle-1] : '0;
        end
    end

    property p;
        @(posedge clk) disable iff (rst_n == 1'b0)
            en & condDelayed[NUM_CYCLES] |-> expr;
    endproperty

    assert property(p) else $error("ASSERT COND : %s",MSG);
`endif

endmodule