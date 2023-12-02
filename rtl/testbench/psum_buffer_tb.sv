`timescale 1ns / 1ps // Define the time scale for simulation

module psum_buffer_tb;

    // Testbench signals
    reg clk;                          // Clock signal
    reg rst_n;                        // Reset signal, active low
    reg start_conv;                   // Start conversion signal
    reg OP_MODE mode_in;              // Operation mode input
    reg [6:0] PSUM_PACKET psum_in;    // PSUM input packets
    reg [6:0] pe_psum_ack;            // Acknowledgement from PE
    wire [6:0] psum_buffer_ack;       // Acknowledgement to PE
    wire [6:0] PSUM_PACKET psum_out;  // PSUM output packets

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

        // Reset sequence
        #100;
        rst_n = 1;
        #100;

        // Begin test scenarios
        // Example: Simulate starting the conversion
        start_conv = 1;
        mode_in = ...; // Set the mode
        psum_in = ...; // Provide some input packets
        pe_psum_ack = ...; // Simulate PE acknowledgement

        // ... Add more test scenarios as needed

        // End of test
        $finish; // Terminate the simulation
    end

endmodule
