`timescale 1ns/100ps
module pe_tb();
logic           clk;
logic           rst;
OP_MODE         mode;           // mode selection
logic           change_mode;
PE_IN_PACKET    filter_packet;      // PE packet broadcasted from buffer
PE_IN_PACKET    ifmap_packet;      // PE packet broadcasted from buffer
OP_STAGE        op_stage;
PSUM_PACKET     psum_in;
logic           psum_ack_in;    // The psum out has been taken by next stage
logic           onv_continue;  // reload ifmap, continue next round convolution
PSUM_PACKET     psum_out;
logic           psum_ack_out;   // The psum in is acknoledged
logic           conv_done;      // All the convolution is done, wait for continue to restart
logic           error;          // Error raise when scrach pad is full and a new packet coming in
logic           full; 
logic           conv_continue;

logic [`PSUM_DATA_SIZE-1:0] psum;

pe #(.ROW_IDX(0), .COL_IDX(0)) DUT (
    .clk(clk),
    .rst(rst),
    .mode_in(mode),           // mode selection
    .change_mode(change_mode),
    .ifmap_packet(ifmap_packet),      // PE packet broadcasted from buffer
    .filter_packet(filter_packet),
    .op_stage_in(op_stage),
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


// Verification task
task reset();
    clk = 0;
    rst = 1;
    mode = MODE1;
    change_mode = 0;
    filter_packet = '0;
    ifmap_packet = '0;
    op_stage = IDLE;
    psum_in = '0;
    psum_ack_in = 0;
    conv_continue = 0;
    @(negedge clk);
    @(negedge clk);
    rst = 0;
    $display("Reset complete\n");
endtask


// Test process

always #5 clk = ~clk;

initial begin
    reset();
    @(negedge clk);
    @(negedge clk);
    $finish();
end
endmodule