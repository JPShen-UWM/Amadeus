`timescale 1ns / 1ps // Define the time scale for simulation

module psum_buffer_tb;

    // Testbench signals
    logic clk;                          // Clock signal
    logic rst_n;                        // Reset signal, active low
    logic start_conv;                   // Start conversion signal
    OP_MODE mode_in;              // Operation mode input
    PSUM_PACKET [6:0] psum_in;    // PSUM input packets
    logic [6:0] pe_psum_ack;            // Acknowledgement from PE
    logic [6:0] psum_buffer_ack;       // Acknowledgement to PE
    PSUM_PACKET [6:0] psum_out;  // PSUM output packets

    // Instantiate the psum_buffer module
    psum_buffer uut (
        .clk(clk),
        .rst_n(rst_n),
        .start_conv(start_conv),
        .mode_in(mode_in),
        .psum_in(psum_in),
        .pe_psum_ack(pe_psum_ack),
        .psum_buffer_ack(psum_buffer_ack),
        .psum_out(psum_out)
    );

    // Clock generation
    always #10 clk = ~clk; // Generate a 50MHz clock

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        start_conv = 0;
        mode_in = 0; // Adjust this based on OP_MODE definition
        psum_in = 0;
        pe_psum_ack = 0;

        // ... Add more test scenarios as needed

        // End of test
        $finish; // Terminate the simulation
    end

endmodule
