`timescale 1ns / 1ps  // Define the time unit and time precision

module tb_output_buffer;

    // Testbench Signals
    logic clk;
    logic rst_n;
    PSUM_PACKET [6:0] psum_row2_out;
    PSUM_PACKET [6:0] psum_row4_out;
    PSUM_PACKET [6:0] psum_to_buffer;
    logic [6:0] outbuff_row2_ack_in;
    logic [6:0] outbuff_row4_ack_in;
    logic [6:0] outbuff_row5_ack_in;
    logic [15:0][7:0] outmap_data;
    logic [4:0] outmap_data_valid_num;
    logic [4:0] valid_taken_num;
    OP_MODE mode_in;
    logic change_mode;
    CONTROL_STATE control_state;
    logic send_done;

    // Instantiate the output_buffer module
    output_buffer uut (
        .clk(clk),
        .rst_n(rst_n),
        .psum_row2_out(psum_row2_out),
        .psum_row4_out(psum_row4_out),
        .psum_to_buffer(psum_to_buffer),
        .outbuff_row2_ack_in(outbuff_row2_ack_in),
        .outbuff_row4_ack_in(outbuff_row4_ack_in),
        .outbuff_row5_ack_in(outbuff_row5_ack_in),
        .outmap_data(outmap_data),
        .outmap_data_valid_num(outmap_data_valid_num),
        .valid_taken_num(valid_taken_num),
        .mode_in(mode_in),
        .change_mode(change_mode),
        .control_state(control_state),
        .send_done(send_done)
    );

    always #10 clk = ~clk;  // Generate a clock with a period of 10 time units

    // Clock Generation
    initial begin
        clk = 0;
    end

    // Testbench Stimulus
    initial begin
        // Reset the design
        rst_n = 0;
        #20;
        rst_n = 1;

        // Initialize other input signals
        psum_row2_out = 0;
        psum_row4_out = 0;
        psum_to_buffer = 0;
        valid_taken_num = 0;
        mode_in = 0;
        change_mode = 0;
        control_state = 0;

        // Add additional stimulus here
        // ...

    end

    // Add additional tasks, functions, or initial blocks as needed for your test
    // ...

endmodule