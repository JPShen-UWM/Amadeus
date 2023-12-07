module ASSERT_NEVER #(
    parameter MSG = ""
) (
    input logic clk,
    input logic rst_n,
    input logic en,
    input logic expr
);

`ifndef ASSERT_NEVER_DIS
    property p;
        @(posedge clk) disable iff(rst_n == 1'b0)
            en |-> ~expr;
    endproperty

    AssertAlways: assert property (p) else $error("ASSERT_NEVER : %s", MSG);
`endif

endmodule