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
        #20;
        rst_n = 1;
        repeat_data_task();
        data_in=66;
         #20;
         ren=1;
        #20;
        ren=1;
        // assert (full) else $error("full is not right");
        repeat_data_task();

        $finish; // Terminate the simulation
    end
    task repeat_data_task();
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                wen=1;
                data_in = i+1;
                
                $display("Iteration %d: Data = %h", i, data_in);
             #20; // 
            end
        end
    endtask
endmodule
