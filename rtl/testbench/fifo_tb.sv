`timescale 1ns / 1ps // Define the time scale for simulation

module fifo_tb;

    // Testbench parameters
    localparam DEPTH = 8;
    localparam WIDTH = 8;

    // Testbench signals
    reg clk;                       // Clock signal
    reg rst_n;                     // Reset signal, active low
    reg wen;                       // Write enable signal
    reg ren;                       // Read enable signal
    reg [WIDTH-1:0] data_in;       // Data input for FIFO
    wire [WIDTH-1:0] data_out;     // Data output from FIFO
    wire data_valid;               // Data valid flag
    wire full;                     // FIFO full flag
    wire empty;                    // FIFO empty flag

    // Instantiate the FIFO module
    fifo #(.DEPTH(DEPTH), .WIDTH(WIDTH)) uut (
        .clk(clk),
        .rst_n(rst_n),
        .wen(wen),
        .ren(ren),
        .data_in(data_in),
        .data_out(data_out),
        .data_valid(data_valid),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #10 clk = ~clk; // Generate a 50MHz clock

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        wen = 0;
        ren = 0;
        data_in = 0;

        // Reset sequence
        #100;
        rst_n = 1;
        #100;

        // Begin test scenarios
        // Example: Write data into the FIFO
        wen = 1;
        data_in = 8'hAA; // Test data
        #20;
        wen = 0;

        // Example: Read data from the FIFO
        #100;
        ren = 1;
        #20;
        ren = 0;

        // ... Add more test scenarios as needed

        // End of test
        $finish; // Terminate the simulation
    end

endmodule
