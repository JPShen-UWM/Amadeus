`timescale 1ns / 1ps

module controller_tb;


    reg clk;
    reg rst_n;
    reg complete;
    wire free_ifmap_buffer;


    controller uut (
        .clk(clk),
        .rst_n(rst_n),
        .complete(complete),
        .free_ifmap_buffer(free_ifmap_buffer)
    );


    always #10 clk = ~clk; 

    initial begin

        clk = 0;
        rst_n = 0;
        complete = 0;

        #100;
        rst_n = 1;
        #100;

        complete = 1;
        #20;
        complete = 0;
        #100;


        $finish;
   
