`timescale 1ns / 1ps // Define the time scale for simulation
`include "testbench/psum_buffer_tb_lib.svh"

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

    PSUM_GEN psum_gen;
    STIMULUS stimulus;

    PSUM_PACKET collect_output [6:0][3:0][$];

    function void check();
        int num = 0;
        for(int i = 0; i < 7; i=i+1) begin
            for(int j = 0; j < 4; j=j+1) begin
                if(collect_output[i][j].size() != 55) begin
                    num = num + 1;
                    $display(collect_output[i][j].size());
                end
                for(int k = 0; k < 55; k=k+1) begin
                    if(collect_output[i][j][k] != psum_gen.psum_golden[i][j][k]) begin
                        $display("group : %d, filter_index : %d, index : %d",i,j,k);
                        $display("actual data: %d, golden data: %d",collect_output[i][j][k], psum_gen.psum_golden[i][j][k]);
                        num = num + 1;
                    end
                end
            end
        end
        if(num == 0) begin
            $display("==================================================");
            $display("==================== TEST PASS ===================");
            $display("==================================================");
        end
        else begin
            $display("==================================================");
            $display("==================== TEST FAIL ===================");
            $display("==================================================");
            $display("ERROR NUM : %d",num);
        end
    endfunction

    task load();
        clk = 0;
        rst_n = 0;
        start_conv = 0;
        mode_in = MODE1;
        psum_in = 0;
        pe_psum_ack = 0;
        psum_gen = new();
        psum_gen.randomize();
        stimulus = new(psum_gen.psum_golden);

        @(negedge clk) begin
            rst_n = 1'b1;
        end
        @(negedge clk) begin
            start_conv = 1'b1;
        end
        @(negedge clk) begin
            start_conv = 1'b0;
        end

        for(int i = 0; i < 4*55; i=i+1) begin
            @(negedge clk) begin
                psum_in = stimulus.send_psum_packet();
            end
        end

        @(negedge clk);
            psum_in = '0;
    endtask;

    task read();
        @(negedge clk) 
            mode_in = MODE2;
        @(negedge clk) 
            start_conv = 1;
        @(negedge clk) begin
            start_conv = 0;
            for(int j = 0; j < 4*55; j=j+1) begin
                int filter_idx = 0;
                @(negedge clk) begin
                    pe_psum_ack = 7'b1111111;
                    for(int i = 0; i < 7; i=i+1) begin
                        //if(psum_out[i].valid) begin
                            collect_output[i][filter_idx].push_back(psum_out[i]);
                        //end
                    end
                    if(filter_idx == 3) begin
                        filter_idx = 0;
                    end
                    else begin
                        filter_idx = filter_idx + 1;
                    end
                end
            end
        end
        check();
    endtask

    // Test sequence
    initial begin
        $srandom(999999);
        load();
        read();
        $finish; // Terminate the simulation
    end

endmodule
