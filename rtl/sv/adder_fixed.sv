// Single cycle combination adder
`include "../amadeus/rtl/sv/sys_defs.sv"
module adder_fixed(
    input signed [PSUM_DATA_SIZE-1:0] inA,  // signed fixed point (12,5)
    input signed [PSUM_DATA_SIZE-1:0] inB,  // signed fixed point (12,5)
    output signed [PSUM_DATA_SIZE-1:0] out // signed fixed point (12,5)
);

logic [PSUM_DATA_SIZE:0] sum_temp;
logic pos_overflow; // Positive overflow
logic neg_overflow; // Negative overflow

assign sum_temp = inA + inB;
// Check overflow
assign pos_overflow = sum_temp[PSUM_DATA_SIZE-1] & ~sum_temp[PSUM_DATA_SIZE];
assign neg_overflow = ~sum_temp[PSUM_DATA_SIZE-1] & sum_temp[PSUM_DATA_SIZE];

// Perform saturation
assign out = pos_overflow? 12'h7FF:
             neg_overflow? 12'h800:
             sum_temp[PSUM_DATA_SIZE-1:0];

endmodule