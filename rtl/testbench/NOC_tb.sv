`timescale 1ns / 1ps // Define the time scale for simulation

module noc_tb;

    // Testbench signals
    reg clk;                            // Clock signal
    reg rst_n;                          // Reset signal, active low
    reg start;                          // Start signal
    reg start_conv;                     // Start convolution signal
    reg LAYER_TYPE layer_type_in;       // Layer type input
    reg OP_MODE mode_in;                // Operation mode input
    reg conv_complete;                  // Convolution complete signal
    reg [34:0][256*8-1:0] ifmap_data_in; // IFMAP data input
    reg ifmap_data_valid_in;            // IFMAP data valid flag
    reg [5:0][6:0] pe_full;             // PE full signals
    reg [4:0] complete_count;           // Complete count signal
    wire pe_calculation_complete;       // PE calculation complete output
    wire free_ifmap_buffer;             // Signal to free IFMAP buffer
    wire DIAGONAL_BUS_PACKET diagonal_bus_packet; // Diagonal bus packet output

    // Instantiate the NOC module
    NOC uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .start_conv(start_conv),
        .layer_type_in(layer_type_in),
        .mode_in(mode_in),
        .conv_complete(conv_complete),
        .ifmap_data_in(ifmap_data_in),
        .ifmap_data_valid_in(ifmap_data_valid_in),
        .pe_full(pe_full),
        .complete_count(complete_count),
        .pe_calculation_complete(pe_calculation_complete),
        .free_ifmap_buffer(free_ifmap_buffer),
        .diagonal_bus_packet(diagonal_bus_packet)
    );

    // Clock generation
    always #10 clk = ~clk; // Generate a 50MHz clock

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        start = 0;
        start_conv = 0;
        layer_type_in = ...; // Set this based on LAYER_TYPE definition
        mode_in = ...; // Set this based on OP_MODE definition
        conv_complete = 0;
        ifmap_data_in = ...; // Provide IFMAP data
        ifmap_data_valid_in = 0;
        pe_full = ...; // Set PE full signals
        complete_count = 0;

        // Reset sequence
        #100;
        rst_n = 1;
        #100;

        // Begin test scenarios
        // Example: Simulate the start of operation
        start = 1;
        start_conv = 1;
        ifmap_data_valid_in = 1;
        // ... Simulate more scenarios and signal changes as needed

        // End of test
        $finish; // Terminate the simulation
    end

endmodule
