// Single cycle combination multiplier
//`include "../amadeus/rtl/sv/sys_defs.sv"
module mult_fixed(
    input [IFDATA_SIZE-1:0] inA,  // unsigned fixed point (8,7)
    input signed [WDATA_SIZE-1:0] inB,  // signed fixed point (8,6)
    output signed [MULT_OUT_SIZE-1:0] out // signed fixed point (8,5)
);

logic signed [15:0] mult_temp; // (16,13)
assign mult_temp = inA * inB;
assign out = mult_temp[15:8]; // Trim to (8,5)
// Ideally, overflow should not happen in multiplier
endmodule