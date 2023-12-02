`timescale 1ns / 1ps

module compressor_tb;


    reg clk;
    reg rst_n;
    reg [15:0][7:0] outmap_data;
    reg start;
    reg [4:0] outmap_data_valid_num;
    reg mem_ack;
    wire [4:0] valid_taken_num;
    wire [63:0] compressed_data;
    wire mem_req;

    compressor uut (
        .clk(clk),
        .rst_n(rst_n),
        .outmap_data(outmap_data),
        .start(start),
        .outmap_data_valid_num(outmap_data_valid_num),
        .mem_ack(mem_ack),
        .valid_taken_num(valid_taken_num),
        .compressed_data(compressed_data),
        .mem_req(mem_req)
    );


    always #10 clk = ~clk; 


    initial begin

        clk = 0;
        rst_n = 0;
        outmap_data = 0;
        start = 0;
        outmap_data_valid_num = 0;
        mem_ack = 0;

        // ????
        #100;
        rst_n = 1;
        #100;


        #1000;
        $finish;
    end

endmodule
