`timescale 1ns / 1ps // Define the time scale for simulation
`include "testbench/noc_tb_lib.svh"

module noc_tb;

    // Testbench signals
    logic clk;                            // Clock signal
    logic rst_n;                          // Reset signal, active low
    logic start;                          // Start signal
    logic start_conv;                     // Start convolution signal
    LAYER_TYPE layer_type_in;       // Layer type input
    OP_MODE mode_in;                // Operation mode input
    logic conv_complete;                  // Convolution complete signal
    logic [34:0][255:0][7:0] ifmap_data_in; // IFMAP data input
    logic ifmap_data_valid_in;            // IFMAP data valid flag
    logic [5:0][6:0] pe_full;             // PE full signals
    logic [4:0] complete_count;           // Complete count signal
    logic free_ifmap_buffer;             // Signal to free IFMAP buffer
    DIAGONAL_BUS_PACKET diagonal_bus_packet; // Diagonal bus packet output


    MEMORY_BATCH_DATA memory_batch;
    MEMORY_BATCH_DATA memory_batch_layer1;
    MEMORY_BATCH_DATA_LAYER2 memory_batch_layer2;
    MEMORY_BATCH_DATA_LAYER3 memory_batch_layer3;
    PE_FULL_GEN pe_full_gen;
    

    bit [7:0] output_collection [$][$];

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
        .pe_full(pe_full),
        .complete_count(complete_count),

        .free_ifmap_buffer(free_ifmap_buffer),
        .diagonal_bus_packet(diagonal_bus_packet)
    );

    // Clock generation
    always #10 clk = ~clk; // Generate a 50MHz clock

    task reset();
        input LAYER_TYPE layer_type;
        input logic [4:0] complete_count_in; 
        // Initialize signals
        layer_type_in = layer_type;
        memory_batch_layer1 = new();
        memory_batch_layer2 = new();
        memory_batch_layer3 = new();
        pe_full_gen = new;
        output_collection = {};
        if(layer_type_in == LAYER1) begin
            memory_batch = memory_batch_layer1;
            mode_in = complete_count_in[0] ? MODE2 : MODE1;
        end
        else if(layer_type_in == LAYER2) begin
            memory_batch = memory_batch_layer2;
            mode_in = MODE3;
        end
        else if(layer_type_in == LAYER3) begin
            memory_batch = memory_batch_layer3;
            mode_in = MODE4;
        end
        memory_batch.randomize();
        //memory_batch.update_memory_batch_golden();
        //memory_batch.display_raw();
        memory_batch.display_raw_golden();

        clk = 0;
        rst_n = 0;
        start = 0;
        start_conv = 0;
        conv_complete = 0;
        ifmap_data_in = memory_batch.memory_batch;
        ifmap_data_valid_in = 1'b1;
        pe_full = '0;
        complete_count = complete_count_in;

        @(posedge clk);
        @(negedge clk) begin
            rst_n = 1'b1;
        end
        @(negedge clk) begin
            start = 1'b1;
        end
        @(negedge clk) begin
            start = 1'b0;
            start_conv = 1'b1;
        end
        @(negedge clk) begin
            start_conv = 1'b0;
        end
    endtask

    function void check(LAYER_TYPE layer_type);
        int line_element_size = 0; 
        int num = 0;
        case(layer_type)
            LAYER1 : line_element_size = 227;
            LAYER2 : line_element_size = 31;
            LAYER3 : line_element_size = 15;
        endcase

        if(output_collection.size() != uut.ifmap_data_line_read_ptr_counter - uut.line_read_ptr_start + 1) begin
            num = num + 1;
            $display("WRONG SIZE of output_collection queue");
        end

        for(int i = uut.line_read_ptr_start; i <= uut.ifmap_data_line_read_ptr_counter; i=i+1) begin
            for(int j = 0; j < line_element_size; j=j+1) begin
                if(output_collection[i-uut.line_read_ptr_start][j] != memory_batch.memory_batch_golden[i][j]) begin
                    num = num + 1;
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
            for(int i = 0; i < output_collection.size(); i=i+1) begin
                for(int j = 0; j < output_collection[i].size(); j=j+1) begin
                     $write("%d ",output_collection[i][j]);
                end
                $write("\n");
            end
        end
    endfunction

    function automatic void get_noc_detination(logic [29:0][11:0] diagbus_pattern);
        int set[12][$];
        for(int i = 0; i < 30; i= i+1) begin
            for(int j = 0; j < 12; j++) begin
                if(diagbus_pattern[i][j]) begin
                    set[j].push_back(i);
                end
            end
        end
        $display("==================== DIAGBUS PATTERN ===================");
        for(int i = 0; i < 12; i=i+1) begin
            $write("bus %d : ",i);
            foreach(set[i][j]) begin
                $write("%d ",set[i][j]);
            end
            $write("\n");
        end
    endfunction



    // Test sequence
    initial begin
        get_noc_detination(uut.layer1_diagbus_pattern);
        get_noc_detination(uut.layer2_diagbus_pattern);
        get_noc_detination(uut.layer3_diagbus_pattern);
        reset(LAYER3,0);
        // corner case for pe_full
        // pe_full_gen.gen_mode4();
        // pe_full = pe_full_gen.pe_full;
        while(uut.enable) begin
            @(negedge clk);
                pe_full_gen.randomize();
                pe_full = pe_full_gen.pe_full;
                #3
                if(uut.ifmap_packet.valid) begin
                    // $display("line ptr : %d",uut.ifmap_data_line_read_ptr);
                    // $display("element ptr : %d",uut.ifmap_data_element_read_ptr);
                    for(int j = 0; j < 4; j=j+1) begin
                        // $write("%d ",uut.ifmap_packet.data[j]);
                        output_collection[uut.ifmap_packet.packet_idx].push_back(uut.ifmap_packet.data[j]);
                    end
                    // $write("\n");
                end
        end
        check(LAYER3);
        $finish; // Terminate the simulation
    end

endmodule
