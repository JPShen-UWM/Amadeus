`timescale 1ns/1ps

module weight_buffer_tb;

    parameter CYCLE = 10; 


    reg clk;
    reg rst_n;
    OP_MODE mode_in;
    reg mem_data_valid;
    reg [63:0] weight_data;
    reg free_weight_buffer;
    PE_IN_PACKET packet_out[0:5];
    reg output_filter;

    wire mem_req;
    wire ready_to_output;

    weight_buffer uut (
        .clk(clk),
        .rst_n(rst_n),
        .mode_in(mode_in),
        .mem_data_valid(mem_data_valid),
        .weight_data(weight_data),
        .free_weight_buffer(free_weight_buffer),
        .output_filter,
        .packet_out(packet_out),
        .mem_req(mem_req),
        .ready_to_output(ready_to_output)
    );

    always #(CYCLE/2) clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 1;
        mode_in = MODE1;
        mem_data_valid = 0;
        weight_data = 0;
        free_weight_buffer = 0;
        output_filter=0;
        #10;

       
        rst_n = 0;
        repeat_data_task;
        // weight_data = 1;
        // #10;
        // weight_data = 2;
        // #10;
        // free_weight_buffer=1;
        // #10;
        // free_weight_buffer=0;
        // mode_in = MODE3;
        // repeat_data_mode3_task;
        output_filter=1;
        #120;
        $display("Test Completed");
        $finish;
    end

    task repeat_data_task();
        integer i, j;
        begin
            for (i = 0; i < 88; i = i + 1) begin
                mem_data_valid = 1;
                for (j = 0; j < 64; j = j + 8) begin
                    weight_data[j+:8] = i;
                end
                $display("Iteration %d: Data = %h", i, weight_data);
                #10; // 
            end
        end
    endtask


    task repeat_data_mode3_task();
        integer i, j;
        begin
            for (i = 0; i < 22; i = i + 1) begin
                mem_data_valid = 1;
                    weight_data[63:24] = i;
                    weight_data[63:23] = 0; 
                #10;
                end
                $display("Iteration %d: Data = %h", i, weight_data);
        
            end
        
    endtask



endmodule
