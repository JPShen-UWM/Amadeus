`timescale 1ns / 1ps // Define the time scale for simulation
`include "testbench/decompressor_tb_lib.svh"

module decompressor_tb;

    // Testbench signals
    logic clk;                             // Clock signal
    logic rst_n;                           // Reset signal, active low
    logic ifmap_buffer_req;               // Global buffer request signal
    logic [`MEM_BANDWIDTH*8-1:0] mem_data; // Memory data input
    logic mem_data_valid;                  // Memory data valid flag
    logic mem_data_valid_random;  
    logic mem_ack;                         // Memory acknowledgment signal
    logic start;                           // Start signal from controller
    LAYER_TYPE layer_type_in;        // Layer type input
    logic decompressor_ack;               // Decompressor acknowledgment output
    logic mem_req;                        // Memory request signal from decompressor
    DECOMRPESS_FIFO_PACKET decompress_fifo_packet; // Decompressed FIFO packet output

    logic [4:0] mem_req_count;

    // Instantiate the decompressor module
    decompressor uut (
        .clk(clk),
        .rst_n(rst_n),
        .ifmap_buffer_req(ifmap_buffer_req),
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

    IFMAP_GENERATION ifmap;
    STIMULUS stimulus;
    UTILITY utility;
    GOLDEN golden;

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | start) begin
            mem_req_count <= 0;
        end
        else begin
            mem_req_count <= mem_req_count + mem_req - mem_data_valid;
        end
    end

    assign mem_data_valid = mem_req_count != 0 & mem_data_valid_random;
    

    task reset();
        clk = 1'b0;
        rst_n = 1'b1;
        start = 1'b0;
        ifmap = new(layer_type_in);
        utility = new();
        ifmap.randomize();
        ifmap.display_raw();
        ifmap.compress();
        ifmap.display_decompressed();
        stimulus = new(ifmap.compressed_data_set);
        golden = new(ifmap.ifmap_data,layer_type_in);
        ifmap_buffer_req = 0;
        mem_ack = 0;
        mem_data = 0;
        @(negedge clk)
            rst_n = 1'b0;
        @(negedge clk) begin
            rst_n = 1'b1;
            start = 1'b1;
        end
        @(negedge clk) begin
            start = 1'b0;
        end 
    endtask

    task send_stimulus();
        @(negedge clk) begin    
            stimulus.randomize();
            mem_data_valid_random = stimulus.mem_data_valid;
            ifmap_buffer_req = stimulus.ifmap_buffer_req;
            mem_ack = stimulus.mem_ack;
            mem_data = stimulus.mem_data;
        end
    endtask

    initial begin
        $dumpfile("decompressor.dump");
        $dumpvars;
    end

    task run();
        //while(uut.layer23_send_all != 2'b01) begin
        for(int i = 0; i < 1000; i=i+1) begin
            send_stimulus();
            @(posedge clk) begin
                #3;
                if(decompress_fifo_packet.packet_valid & ifmap_buffer_req)
                        golden.collect_output(decompress_fifo_packet);
            end
        end
        repeat(5)
            @(posedge clk);
    endtask;

    // Test sequence
    initial begin
        layer_type_in = LAYER3;
        repeat(1) begin
            reset();
            run();
            golden.check();
        end
        $finish; // Terminate the simulation
    end


endmodule
