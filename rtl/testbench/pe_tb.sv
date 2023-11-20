`include "../amadeus/rtl/sv/sys_defs.sv"
module pe_tb();
logic           clk;
logic           rst;
OP_MODE         mode;           // mode selection
logic           change_mode;
PE_IN_PACKET    pe_packet;      // PE packet broadcasted from buffer
OP_STAGE        op_stage;
PSUM_PACKET     psum_in;
logic           psum_ack_in;    // The psum out has been taken by next stage
logic           onv_continue;  // reload ifmap, continue next round convolution
PSUM_PACKET     psum_out;
logic           psum_ack_out;   // The psum in is acknoledged
logic           conv_done;      // All the convolution is done, wait for continue to restart
logic           error;          // Error raise when scrach pad is full and a new packet coming in
logic           full; 

logic [PSUM_DATA_SIZE-1:0] psum;

pe #(.ROW_IDX(0), .COL_IDX(0)) DUT (
    .clk(clk),
    .rst(rst),
    .mode(mode[1:0]),           // mode selection
    .change_mode(change_mode),
    .pe_packet(pe_packet),      // PE packet broadcasted from buffer
    .op_stage(op_stage[1:0]),
    .psum_in(psum_in),
    .psum_ack_in(psum_ack_in),    // The psum out has been taken by next stage
    .conv_continue(conv_continue),  // reload ifmap, continue next round convolution
    .psum_out(psum_out),
    .psum_ack_out(psum_ack_out),   // The psum in is acknoledged
    .conv_done(conv_done),      // All the convolution is done, wait for continue to restart
    .error(error),          // Error raise when scrach pad is full and a new packet coming in
    .full(full)          // ifmap scratch pad is full
);

always #5 clk = ~clk;



endmodule