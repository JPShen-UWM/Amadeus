`timescale 1ns/100ps
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
logic           conv_continue;  // reload ifmap, continue next round convolution
PSUM_PACKET     psum_out;
logic           psum_ack_out;   // The psum in is acknoledged
logic           conv_done;      // All the convolution is done, wait for continue to restart
logic           error;          // Error raise when scrach pad is full and a new packet coming in
logic           full; 

real filter[3:0][10:0];
real ifmap[226:0];
real golden_psum[3:0][54:0];
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
            filter_packet.data = {8'b0, filter_fixed[i][10:8]};
            filter_packet.packet_idx[2:0] = 0; 
            filter_packet.packet_idx[4:3] = i;
            filter_packet.valid = 1;
            @(posedge clk);
            filter_packet.data = filter_fixed[i][7:4];
            filter_packet.packet_idx[2:0] = 0; 
            filter_packet.packet_idx[4:3] = i;
            filter_packet.valid = 1;
            @(posedge clk);
            filter_packet.data = filter_fixed[i][3:0];
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
    for(int j = 0; j < 227; j++) begin
        ifmap_mantissa = $rtoi(ifmap[j] * 128);
        ifmap_fixed[j] = ifmap_mantissa[7:0];
    end
    // Send ifmap when pe is not full
    @(posedge clk);
    if(mode == MODE1 || mode == MODE2) begin
        for(int i = 0; i < 227; i=i+4) begin
            // Wait till ifmap scratch pad is not full
            ifmap_packet.valid = 0;
            while(full & !time_out) begin
                @(posedge clk);
                #0.1;
            end
            // Add data gap to test no ifmap stall work correctly
            if(i%7 == 0 | i%5 == 0) begin
                repeat(300) @(posedge clk);
            end
            ifmap_packet.valid = 1;
            ifmap_packet.packet_idx = 0;
            ifmap_packet.data[0] = ifmap_fixed[i];
            ifmap_packet.data[1] = ifmap_fixed[i+1];
            ifmap_packet.data[2] = ifmap_fixed[i+2];
            if(i+3 >= 227) ifmap_packet.data[3] = 8'b0;
            else ifmap_packet.data[3] = ifmap_fixed[i+3];
            @(posedge clk);
            #0.1;
            ifmap_packet.valid = 0;
            if(time_out) break;
        end
    end
    $display("All ifmap packet sent at time: %0t",$time);
endtask

// Feed in psum packet
task feed_psum();
integer counter = 0;
@(posedge clk);
    while(!time_out) begin
        for(int i = 0; i < 4; i++) begin
            //#0.1;
            // Insert random psum input stall
            if(counter%19 == 3 | counter%23 == 5) begin
                repeat(100) @(posedge clk);
            end
            #0.1
            psum_in.valid = 1;
            psum_in.filter_idx = i;
            psum_in.psum = 0;
            @(posedge clk);
            while(!psum_ack_out & !time_out) begin
                @(posedge clk);
            end
            psum_in.valid = 0;
            counter = counter + 1;
        end
    end
endtask

// Collect psum and push to psum queue
task collect_psum();
    real psum_real;
    real mantissa_real;
    integer mantissa_int;
    integer counter = 0;
    // Infinite loop
    @(posedge clk);
    while(!time_out) begin
        #0.1;
        if(psum_out.valid) begin
            // Insert random collecting psum stall
            // Try to trigger accum_stall
            if(counter % 21 == 10 | counter % 14 == 10) begin
                repeat(100) @(posedge clk);
            end
            counter = counter + 1;
            psum_ack_in = 1;
            mantissa_int = {{20{psum_out.psum[11]}},psum_out.psum};
            mantissa_real = $itor(mantissa_int);
            psum_real = mantissa_real/32.0;
            psum_queue[psum_out.filter_idx].push_back(psum_real);
        end
        @(posedge clk);
        psum_ack_in <= 0;
    end
endtask

// Termination task
task time_out_check();
    integer cycle_count = 0;
    while(!conv_done) begin
        cycle_count = cycle_count + 1;
        if(cycle_count > 20000) begin
            time_out = 1;
            $display("ERROR! TIME OUT!");
            break;
        end
        @(posedge clk);
    end
    if(conv_done) begin
        repeat(100) @(posedge clk);
        time_out = 1;
        $display("Conv_done assert at cycle: %d, time: %0t", cycle_count, $time);
    end
endtask

// Simple filter set
task set_simple_filter();
    filter[0] = {1.0, 0.0, 1.0, -0.25, 1.0, 0.0, 1.0, 0.0, 1.0, 0.25, 1.0};
    filter[1] = {1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0};
    filter[2] = {1.0, 0.25, 1.0, 1.0, 1.0, 0.0, -1.0, -1.0, -1.0, -1.0, -1.0};
    filter[3] = {-1.0, 0.25, -1.0, 0, -1.0, 1.0, -1.0, 0.5, -1.0, 0, -1.0};
endtask

// Simple ifmap
task set_simple_ifmap();
    for(int i = 0; i < 11; i++) begin
        ifmap[i] = 1.0;
    end
    for(int i = 11; i < 50; i++) begin
        ifmap[i] = 0.25;
    end
    for(int i = 50; i < 101; i++) begin
        ifmap[i] = 0.5;
    end
    for(int i = 101; i < 153; i++) begin
        ifmap[i] = 0.75;
    end
    for(int i = 153; i < 227; i++) begin
        ifmap[i] = 0.25;
    end
endtask

// Golden output
task golden_output();
    int filter_size;
    int ifmap_size;
    int ofmap_size;
    int stride;
    if(mode == MODE1 | mode == MODE2) begin
        filter_size = `L1_FILTER_SIZE;
        ifmap_size = `L1_IFMAP_SIZE;
        ofmap_size = `L1_OFMAP_SIZE;
        stride = 4;
    end
    else if(mode == MODE3) begin
        filter_size = `L2_FILTER_SIZE;
        ifmap_size = `L2_IFMAP_SIZE;
        ofmap_size = `L2_OFMAP_SIZE;
        stride = 1;
    end
    else if(mode == MODE4) begin
        filter_size = `L3_FILTER_SIZE;
        ifmap_size = `L3_IFMAP_SIZE;
        ofmap_size = `L3_OFMAP_SIZE;
        stride = 1;
    end
    // Convolution
    for(int i = 0; i < ofmap_size; i++) begin
        for(int j = 0; j < 4; j++) begin
            golden_psum[j][i] = 0.0;
            for(int k = 0; k < filter_size; k++) begin
                golden_psum[j][i] = golden_psum[j][i] + filter[j][k] * ifmap[i*stride + k];
            end
        end
    end
endtask

// fuzzy compare
// Return 0 if x = y
function bit compare(input real x,y);
    real tolerance = 0.1;
    if(x < y - tolerance | x > y + tolerance) return 1;
    else return 0;
endfunction

// Report task
task report_phase();
    int psum_size0, psum_size1, psum_size2, psum_size3;
    int error_count;
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
    error_count = 0;
    for(int i = 0; i < 4; i++) begin
        for(int j = 0; j < psum_size0; j++) begin
            if(compare(psum_queue[i][j], golden_psum[i][j])) begin
                $display("ERROR! psum[%d][%d] expected: %f, get: %f", i, j, golden_psum[i][j], psum_queue[i][j]);
                error_count++;
            end
        end
    end
    if(error_count == 0) begin
        $display("Yahoo!!! All Test Pass!!!");
    end
    else begin
        $display("Fuck!!! There are %d potential errors!", error_count);
    end
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
    rst = 0;
    $display("Reset complete at time: %0t",$time); 
endtask


// Test process

always begin
    #5;
    clk = ~clk;
end

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
    golden_output();
    report_phase();
    $finish();
end
endmodule