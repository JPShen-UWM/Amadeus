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
    

    task reset();
        clk = 1'b0;
        rst_n = 1'b1;
        start = 1'b0;
        ifmap = new(layer_type_in);
        utility = new();
        ifmap.randomize();
        //ifmap.display_raw();
        ifmap.compressed_data_set_gen();
        stimulus = new(ifmap.compressed_data_set);
        //$display(ifmap.compressed_data_set.size());
        golden = new(ifmap.ifmap_data,layer_type_in);
        ifmap_buffer_req = 0;
        mem_ack = 0;
        mem_data = 0;
        mem_data_valid = 0;
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
            stimulus.update_mem_count(mem_req,mem_ack);
            stimulus.randomize();
            mem_data_valid= stimulus.mem_data_valid;
            // mem_data_valid = stimulus.mem_ack & mem_req;
            ifmap_buffer_req = stimulus.ifmap_buffer_req;
            mem_ack = stimulus.mem_ack;
            mem_data = stimulus.mem_data;
        end
    endtask

    task run_layer1();
        for(int i = 0; i < 10000; i=i+1) begin
            send_stimulus();
            #3;
            if(decompress_fifo_packet.packet_valid & ifmap_buffer_req) begin
                golden.collect_output(decompress_fifo_packet);
            end
        end
        repeat(5)
            @(posedge clk);
    endtask;

    task run_layer23();
        while(uut.layer23_send_all != 2'b11) begin
        //for(int i = 0; i < 100; i=i+1) begin
            send_stimulus();
            #3;
            if(decompress_fifo_packet.packet_valid & ifmap_buffer_req) begin
                golden.collect_output(decompress_fifo_packet);
            end
        end
        repeat(5)
            @(posedge clk);
    endtask;

    // Test sequence
    initial begin
        layer_type_in = LAYER1;
        reset();
        run_layer1();
        golden.check();

        layer_type_in = LAYER2;
        repeat(10000) begin
            reset();
            run_layer23();
            golden.check();
        end
        
        layer_type_in = LAYER3;
        repeat(10000) begin
            reset();
            run_layer23();
            golden.check();
        end
        $finish; // Terminate the simulation
    end


endmodule
