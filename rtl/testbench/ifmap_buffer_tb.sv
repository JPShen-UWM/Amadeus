`timescale 1ns / 1ps // Define the time scale for simulation
`include "testbench/ifmap_buffer_tb_lib.svh"

module ifmap_buffer_tb;

    // Testbench signals
    logic clk;                                // Clock signal
    logic rst_n;                              // Reset signal, active low
    logic start;                              // Start signal
    LAYER_TYPE layer_type_in;           // Layer type input
    DECOMRPESS_FIFO_PACKET decompressed_fifo_packet; // Decompressed FIFO packet input
    logic decompressor_ack;                   // Decompressor acknowledgment input
    logic free_ifmap_buffer;                  // Signal to free IFMAP buffer
    logic ifmap_buffer_req;                 // Global buffer request output
    logic [34:0][255:0][7:0] ifmap_data;      // IFMAP data output
    logic ifmap_data_valid;                  // IFMAP data valid flag
    logic ifmap_data_change;                 // IFMAP data change signal

    // Instantiate the ifmap_buffer module
    ifmap_buffer uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .layer_type_in(layer_type_in),
        .decompressed_fifo_packet(decompressed_fifo_packet),
        .decompressor_ack(decompressor_ack),
        .free_ifmap_buffer(free_ifmap_buffer),
         
        .ifmap_buffer_req(ifmap_buffer_req),
        .ifmap_data(ifmap_data),
        .ifmap_data_valid(ifmap_data_valid),
        .ifmap_data_change(ifmap_data_change)
    );

    // Clock generation
    always #10 clk = ~clk; // Generate a 50MHz clock

    IFMAP_DATA ifmap_data_base;
    LAYER1_IFMAP_DATA layer1_ifmap_data;
    LAYER23_IFMAP_DATA layer2_ifmap_data;
    LAYER23_IFMAP_DATA layer3_ifmap_data;
    STIMULUS stimulus;

    bit [7:0] ifmap_buffer_data [$];
    bit [7:0] ifmap_data_golden  [$];
    bit [7:0] ifmap_buffer_data_golden [$];

    // agent for free_ifmap_buffer;
    logic [13:0] memory_batch1_free_counter;
    logic [13:0] memory_batch2_free_counter;

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | uut.free[0]) begin
            memory_batch1_free_counter <= '0;
        end
        else if(uut.chosen_dequeue[0]) begin
            memory_batch1_free_counter <= memory_batch1_free_counter == 3000 ? 3000 : memory_batch1_free_counter + 1'b1;
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n | uut.free[1]) begin
            memory_batch2_free_counter <= '0;
        end
        else if(uut.chosen_dequeue[1]) begin
            memory_batch2_free_counter <= memory_batch2_free_counter == 3000 ? 3000 : memory_batch2_free_counter + 1'b1;
        end
    end

    assign free_ifmap_buffer = memory_batch1_free_counter == 2999 |  memory_batch2_free_counter == 2999;

    logic [3:0] layer1_counter;
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            layer1_counter <= 0;
        end
        else if(free_ifmap_buffer) begin
            layer1_counter <= layer1_counter + 1'b1;
        end
    end

    task automatic reset();
        input LAYER_TYPE layer_type;
        clk = 0;
        rst_n = 0;
        start = 0;
        decompressor_ack = 0;
        layer_type_in = layer_type;
        if(layer_type_in == LAYER1) begin
            ifmap_data_base = layer1_ifmap_data;
        end
        else if(layer_type_in == LAYER2) begin
            ifmap_data_base = layer2_ifmap_data;
        end
        else begin
            ifmap_data_base = layer3_ifmap_data;
        end
        ifmap_data_base.randomize();
        ifmap_data_base.payload_generation();
        //ifmap_data_base.display_payload(); 
        ifmap_data_golden = ifmap_data_base.ifmap_data;
        stimulus = new(ifmap_data_base.ifmap_buffer_payload_set);

        @(negedge clk) begin
            rst_n = 1'b1;
        end
        @(negedge clk) begin
            start = 1'b1;
        end
        @(negedge clk) begin
            start = 1'b0;
        end
    endtask

    function void display_mem_batch(int batch_num, LAYER_TYPE layer_type);
        int size;
        case(layer_type)
            LAYER1 : size = 228;
            LAYER2 : size = 28;
            LAYER3 : size = 14;
            default: size = 0;
        endcase
        $display(size);
        if(batch_num == 1) begin
            $display("============================  MEMORY BATCH1 DATA ============================");
        end
        else begin
            $display("============================  MEMORY BATCH2 DATA ============================");
        end
        for(int i = 0; i < 35; i=i+1) begin
            for(int j = 0; j < size; j++) begin
                if(batch_num == 1) begin
                    $write("%d ",uut.memory_batch1[i][j]);
                end
                else begin
                    $write("%d ",uut.memory_batch2[i][j]);
                end
            end
            $write("\n");
        end
    endfunction

    function automatic void check(bit[7:0] ifmap_data_golden [$], bit[7:0] ifmap_buffer_data [$]);
        for(int i = 0; i < ifmap_data_golden.size(); i=i+1) begin
            if(ifmap_data_golden[i] != ifmap_buffer_data[i]) begin
                $display("==================================================");
                $display("==================== TEST FAIL ===================");
                $display("==================================================");
                $display("FAIL AT index %d",i);
                return;
            end
        end
        $display("==================================================");
        $display("==================== TEST PASS ===================");
        $display("==================================================");
    endfunction

    function void collect_mem_batch1(int line, int element);
        ifmap_buffer_data = {};
        for(int i = 0; i < line; i= i+1) begin
            for(int j = 0; j < element; j=j+1) begin
                ifmap_buffer_data.push_back(uut.memory_batch1[i][j]);
                //$write("%d ",uut.memory_batch1[i][j]);
            end
        end
    endfunction

    function void collect_mem_batch2(int line, int element);
        ifmap_buffer_data = {};
        for(int i = 0; i < line; i= i+1) begin
            for(int j = 0; j < element; j=j+1) begin
                ifmap_buffer_data.push_back(uut.memory_batch2[i][j]);
                //$write("%d ",uut.memory_batch2[i][j]);
            end
        end
    endfunction

    function automatic void gen_ifmap_data_golden(int iteration);
        ifmap_buffer_data_golden = {};
        for(int i = iteration * 28 * 227; i < (iteration * 28 + 35) * 227; i=i+1) begin
            ifmap_buffer_data_golden.push_back(ifmap_data_golden[i]);
        end
    endfunction

    task send_stimulus();
        @(negedge clk) begin
            stimulus.update_ifmap_buffer_req(ifmap_buffer_req);
            stimulus.randomize();
            decompressor_ack = stimulus.decompressor_ack;
            decompressed_fifo_packet = stimulus.decompressed_fifo_packet;
        end
    endtask

    task automatic run_check_layer1();
        int iteration;
        iteration = 0;
        while(layer1_counter != 8) begin
        //for(int i = 0; i < 20000; i=i+1) begin
            send_stimulus();

                if(free_ifmap_buffer) begin
                    assert(|uut.chosen_dequeue);
                    if(uut.chosen_dequeue[0]) begin
                        collect_mem_batch1(35, 227);
                    end
                    else if(uut.chosen_dequeue[1]) begin
                        collect_mem_batch2(35, 227);
                    end
                    gen_ifmap_data_golden(iteration);
                    check(ifmap_buffer_data_golden, ifmap_buffer_data);
                    iteration = iteration + 1;
                end

        end
        @(negedge clk);
    endtask

    task automatic run_check_layer2();
        while(uut.ready[0] != 1) begin
            send_stimulus();
        end
        @(negedge clk) begin
            collect_mem_batch1(27,27);
            check(ifmap_data_golden, ifmap_buffer_data);
        end
        @(negedge clk);
    endtask

    task automatic run_check_layer3();
        while(uut.ready[0] != 1) begin
            send_stimulus();
        end
        @(negedge clk) begin
            collect_mem_batch1(13,13);
            check(ifmap_data_golden, ifmap_buffer_data);
        end
        @(negedge clk);
    endtask



    // Test sequence
    initial begin
        repeat(100) begin
            $srandom($urandom);
            layer1_ifmap_data = new();
            layer2_ifmap_data = new(LAYER2);
            layer3_ifmap_data = new(LAYER3);
            reset(LAYER1);
            run_check_layer1();
            @(negedge clk);
            reset(LAYER2);
            run_check_layer2();
            @(negedge clk);
            reset(LAYER3);
            run_check_layer3();
            @(negedge clk);
        end
        $finish;
    end

endmodule
