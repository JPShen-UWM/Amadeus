module ASSERT_ONEHOT #(
    parameter MSG = "",
    parameter ALLOW_ZERO = 0,
    parameter WIDTH = 64
) (
    input logic                 clk,
    input logic                 rst_n,
    input logic                 en,
    input logic [WIDTH-1:0]     expr
);

`ifndef ASSERT_ONEHOT_DIS
    logic allow_zero;
    assign allow_zero = (ALLOW_ZERO != 0);

    property p;
        @(posedge clk) disable iff(rst_n == 1'b0)
            en |-> $onehot(expr) | allow_zero & ~(|expr);
    endproperty

    AssertAlways: assert property (p) else $error("ASSERT_ONEHOT: %s", MSG);
`endif

endmodule