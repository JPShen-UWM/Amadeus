`timescale 1ns / 1ps // Define the time scale for simulation
`include "testbench/ifmap_buffer_tb_lib.svh"

module ifmap_buffer_tb;

    // Testbench signals
    reg clk;                                // Clock signal
    reg rst_n;                              // Reset signal, active low
    reg start;                              // Start signal
    reg LAYER_TYPE layer_type_in;           // Layer type input
    reg DECOMRPESS_FIFO_PACKET decompressed_fifo_packet; // Decompressed FIFO packet input
    reg decompressor_ack;                   // Decompressor acknowledgment input
    reg free_ifmap_buffer;                  // Signal to free IFMAP buffer
    wire global_buffer_req;                 // Global buffer request output
    wire [34:0][256*8-1:0] ifmap_data;      // IFMAP data output
    wire ifmap_data_valid;                  // IFMAP data valid flag
    wire ifmap_data_change;                 // IFMAP data change signal

    // Instantiate the ifmap_buffer module
    ifmap_buffer uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .layer_type_in(layer_type_in),
        .decompressed_fifo_packet(decompressed_fifo_packet),
        .decompressor_ack(decompressor_ack),
        .free_ifmap_buffer(free_ifmap_buffer),
        .global_buffer_req(global_buffer_req),
        .ifmap_data(ifmap_data),
        .ifmap_data_valid(ifmap_data_valid),
        .ifmap_data_change(ifmap_data_change)
    );

    // Clock generation
    always #10 clk = ~clk; // Generate a 50MHz clock

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        start = 0;
        layer_type_in = ...; // Set this based on LAYER_TYPE definition
        decompressed_fifo_packet = ...; // Provide decompressed FIFO packet data
        decompressor_ack = 0;
        free_ifmap_buffer = 0;

        // Reset sequence
        #100;
        rst_n = 1;
        #100;

        // Begin test scenarios
        // Example: Simulate the start of IFMAP buffer processing
        start = 1;
        decompressor_ack = 1; // Simulate decompressor acknowledgment
        // ... Simulate more scenarios and signal changes as needed

        // End of test
        $finish; // Terminate the simulation
    end

endmodule
