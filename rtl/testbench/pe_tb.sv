`timescale 1ns/1ns
module pe_tb();
logic           clk;
logic           rst;
OP_MODE         mode;           // mode selection
logic           change_mode;
PE_IN_PACKET    filter_packet;      // PE packet broadcasted from buffer
PE_IN_PACKET    ifmap_packet;      // PE packet broadcasted from buffer
OP_STAGE        op_stage;
PSUM_PACKET     psum_in;
logic           psum_ack_in;    // The psum out has been taken by next stage
logic           onv_continue;  // reload ifmap, continue next round convolution
PSUM_PACKET     psum_out;
logic           psum_ack_out;   // The psum in is acknoledged
logic           conv_done;      // All the convolution is done, wait for continue to restart
logic           error;          // Error raise when scrach pad is full and a new packet coming in
logic           full; 
logic           conv_continue;

real filter[3:0][10:0];
real ifmap[226:0];
real ofmap[3:0][54:0];
real psum_queue[3:0][$];

logic time_out;

pe #(.ROW_IDX(0), .COL_IDX(0)) DUT (
    .clk(clk),
    .rst(rst),
    .mode_in(mode),           // mode selection
    .change_mode(change_mode),
    .ifmap_packet(ifmap_packet),      // PE packet broadcasted from buffer
    .filter_packet(filter_packet),
    .op_stage_in(op_stage),
    .psum_in(psum_in),
    .psum_ack_in(psum_ack_in),    // The psum out has been taken by next stage
    .conv_continue(conv_continue),  // reload ifmap, continue next round convolution
    .psum_out(psum_out),
    .psum_ack_out(psum_ack_out),   // The psum in is acknoledged
    .conv_done(conv_done),      // All the convolution is done, wait for continue to restart
    .error(error),          // Error raise when scrach pad is full and a new packet coming in
    .full(full)          // ifmap scratch pad is full
);

always #5 clk = ~clk; // 100 MHz clock

task load_filter();
    logic signed [3:0][10:0][7:0] filter_fixed; // Fixed point filter
    integer filter_mantissa;
    // Convert real filter to fixed point
    for(int i = 0; i < 4; i++) begin
        for(int j = 0; j < 11; j++) begin
            filter_mantissa = $rtoi(filter[i][j] * 64);
            filter_fixed[i][j] = filter_mantissa[7:0];
        end
    end
    // Set op stage
    @(posedge clk);
    op_stage = LOAD_FILTER;
    // Send filter packet
    for(int i = 0; i < 4; i++) begin
        if(mode == MODE1 || mode == MODE2) begin
            @(posedge clk);
            filter_packet.data = {8'b0, filter_fixed[0][10:8]};
            filter_packet.packet_idx[2:0] = 0; 
            filter_packet.packet_idx[4:3] = i;
            filter_packet.valid = 1;
            @(posedge clk);
            filter_packet.data = filter_fixed[0][7:4];
            filter_packet.packet_idx[2:0] = 0; 
            filter_packet.packet_idx[4:3] = i;
            filter_packet.valid = 1;
            @(posedge clk);
            filter_packet.data = filter_fixed[0][3:0];
            filter_packet.packet_idx[2:0] = 0; 
            filter_packet.packet_idx[4:3] = i;
            filter_packet.valid = 1;
            @(posedge clk);
            filter_packet.valid = 0;
        end
        // @TODO add mode3, mode4
    end
    $display("Finish loading filter at time: %0t",$time); 
endtask   

task send_ifmap();
    logic signed [226:0][7:0] ifmap_fixed; // Fixed point ifmap
    integer ifmap_mantissa;
    // Convert real ifmap to fixed point
    for(int j = 0; j < 226; j++) begin
        ifmap_mantissa = $rtoi(ifmap[j] * 128);
        ifmap_fixed[j] = ifmap_mantissa[7:0];
    end
    // Send ifmap when pe is not full
    @(posedge clk);
    if(mode == MODE1 || mode == MODE2) begin
        for(int i = 0; i < 227; i=i+4) begin
            // Wait till ifmap scratch pad is not full
            while(full) begin
                @(posedge clk);
            end
            ifmap_packet.valid = 1;
            ifmap_packet.packet_idx = 0;
            ifmap_packet.data[0] = ifmap_fixed[i];
            ifmap_packet.data[1] = ifmap_fixed[i+1];
            ifmap_packet.data[2] = ifmap_fixed[i+2];
            if(i+3 >= 227) ifmap_packet.data[3] = 8'b0;
            else ifmap_packet.data[3] = ifmap_fixed[i+3];
            @(posedge clk);
            ifmap_packet.valid = 0;
        end
    end
    $display("All ifmap packet sent at time: %0t",$time);
endtask

// Feed in psum packet
task feed_psum();
    while(!time_out) begin
        for(int i = 0; i < 3; i++) begin
            psum_in.valid = 1;
            psum_in.filter_idx = i;
            psum_in.psum = 0;
            while(!psum_ack_out & !time_out) begin
                @(posedge clk);
            end
            @(posedge clk);
        end
    end
endtask

// Collect psum and push to psum queue
task collect_psum();
    real psum_real;
    // Infinite loop
    while(!time_out) begin
        if(psum_out.valid) begin
            psum_ack_in = 1;
            psum_real = $bitstoreal(psum_out.psum)/32.0;
            psum_queue[psum_out.filter_idx].push_back(psum_real);
            @(posedge clk)
            psum_ack_in = 0;
        end
    end
endtask

// Termination task
task time_out_check();
    integer cycle_count = 0;
    while(!conv_done) begin
        cycle_count = cycle_count + 1;
        if(cycle_count > 4000) begin
            time_out = 1;
            $display("ERROR! TIME OUT!");
            break;
        end
    end
    if(conv_done) begin
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        time_out = 1;
        $display("Conv_done assert at cycle: %i, time: %0t", cycle_count, $time);
    end
endtask

// Simple filter set
task set_simple_filter();
    filter[0] = {1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0};
    filter[1] = {1.0, 0.0, -1.0, 0.0, 1.0, 0.0, -1.0, 0.0, 1.0, 0.0, -1.0};
    filter[2] = {1.0, 1.0, 1.0, 1.0, 1.0, 0.0, -1.0, -1.0, -1.0, -1.0, -1.0};
    filter[3] = {-1.0, -1.0, -1.0, -1.0, -1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0};
endtask
// Simple ifmap
task set_simple_ifmap();
    for(int i = 0; i < 50; i++) begin
        ifmap[i] = 1.0;
    end
    for(int i = 50; i < 100; i++) begin
        ifmap[i] = 0.5;
    end
    for(int i = 100; i < 150; i++) begin
        ifmap[i] = 1.0;
    end
    for(int i = 150; i < 227; i++) begin
        ifmap[i] = 1.0;
    end
endtask


// Report task
task report_phase();
    integer psum_size0, psum_size1, psum_size2, psum_size3;
    psum_size0 = psum_queue[0].size();
    psum_size1 = psum_queue[1].size();
    psum_size2 = psum_queue[2].size();
    psum_size3 = psum_queue[3].size();
    $display("Conv done at time :%0t",$time);
    $display("PSUM 0 size: %i", psum_size0);
    $display("PSUM 1 size: %i", psum_size1);
    $display("PSUM 2 size: %i", psum_size2);
    $display("PSUM 3 size: %i", psum_size3);
    $display("PSUM 0 = %p", psum_queue[0]);
    $display("PSUM 1 = %p", psum_queue[1]);
    $display("PSUM 2 = %p", psum_queue[2]);
    $display("PSUM 3 = %p", psum_queue[3]);
endtask

// Start convolution
task conv_start();
    time_out = 0;
    @(posedge clk);
    op_stage = CONV;
    @(posedge clk);
    conv_continue = 1;
    @(posedge clk);
    conv_continue = 0;
    @(posedge clk);
    $display("Convolution start at time: %0t",$time);
endtask

// Reset system
task reset();
    clk = 0;
    rst = 1;
    mode = MODE1;
    change_mode = 0;
    filter_packet = '0;
    ifmap_packet = '0;
    op_stage = IDLE;
    psum_in = '0;
    psum_ack_in = 0;
    conv_continue = 0;
    time_out = 0;
    @(negedge clk);
    @(negedge clk);
    rst = 0;
    $display("Reset complete at time: %0t",$time); 
endtask


// Test process

always #5 clk = ~clk;

initial begin
    reset();
    set_simple_filter();
    set_simple_ifmap();
    load_filter();
    conv_start();
    fork
        feed_psum();
        time_out_check();
        collect_psum();
        send_ifmap();
    join
    report_phase();
    $finish();
end
endmodule