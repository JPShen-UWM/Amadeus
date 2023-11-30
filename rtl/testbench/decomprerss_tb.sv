`timescale 1ns / 1ps // Define the time scale for simulation

module decompressor_tb;

    // Testbench signals
    reg clk;                             // Clock signal
    reg rst_n;                           // Reset signal, active low
    reg global_buffer_req;               // Global buffer request signal
    reg [`MEM_BANDWIDTH*8-1:0] mem_data; // Memory data input
    reg mem_data_valid;                  // Memory data valid flag
    reg mem_ack;                         // Memory acknowledgment signal
    reg start;                           // Start signal from controller
    reg LAYER_TYPE layer_type_in;        // Layer type input
    wire decompressor_ack;               // Decompressor acknowledgment output
    wire mem_req;                        // Memory request signal from decompressor
    wire DECOMRPESS_FIFO_PACKET decompress_fifo_packet; // Decompressed FIFO packet output

    // Instantiate the decompressor module
    decompressor uut (
        .clk(clk),
        .rst_n(rst_n),
        .global_buffer_req(global_buffer_req),
        .mem_data(mem_data),
        .mem_data_valid(mem_data_valid),
        .mem_ack(mem_ack),
        .start(start),
        .layer_type_in(layer_type_in),
        .decompressor_ack(decompressor_ack),
        .mem_req(mem_req),
        .decompress_fifo_packet(decompress_fifo_packet)
    );

    // Clock generation
    always #10 clk = ~clk; // Generate a 50MHz clock

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        global_buffer_req = 0;
        mem_data = 0;
        mem_data_valid = 0;
        mem_ack = 0;
        start = 0;
        layer_type_in = 0; // Set this based on LAYER_TYPE definition

        // Reset sequence
        #100;
        rst_n = 1;
        #100;

        // Begin test scenarios
        // Example: Simulate memory data input and control signals
        global_buffer_req = 1;
        mem_data = ...; // Provide some memory data
        mem_data_valid = 1;
        mem_ack = 1;
        start = 1;
        layer_type_in = ...; // Set the layer type

        // ... Add more test scenarios as needed

        // End of test
        $finish; // Terminate the simulation
    end

endmodule
