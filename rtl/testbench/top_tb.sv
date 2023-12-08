module top_tb();

logic clk, rst_n;
logic [`MEM_ADDR_SIZE-1:0] mem_addr;
logic [`MEM_BANDWIDTH*8-1:0] mem_write_data;
logic mem_read_valid;

logic  [`MEM_BANDWIDTH*8-1:0] mem_data;
logic  mem_valid;
logic layer_complete;
logic start;
LAYER_TYPE layer_type_in;
logic [`MEM_ADDR_SIZE-1:0] ifmap_buffer_start_addr;
logic [`MEM_ADDR_SIZE-1:0] weight_buffer_start_addr;
logic [`MEM_ADDR_SIZE-1:0] compressor_start_addr;
logic mem_write_valid;
// Mimic MEM
memory MEM(clk, mem_addr, mem_write_data, mem_write_valid, mem_data, mem_valid, mem_read_valid);


// DUT
amadeus_top DUT(
    .clk(clk),
    .rst_n(rst_n),
    .start_layer(start),
    .mem_read_data(mem_data),
    .mem_valid(mem_read_valid),
    .ifmap_buffer_start_addr(ifmap_buffer_start_addr),
    .weight_buffer_start_addr(weight_buffer_start_addr),
    .compressor_start_addr(compressor_start_addr),
    .layer_type_in(layer_type_in),

    .mem_addr(mem_addr),
    .mem_write_data(mem_write_data),
    .mem_read(mem_read_valid),
    .mem_write(mem_write_valid),
    .layer_complete(layer_complete)
);

always #10 clk = ~clk;

task initialize_mem();
$readmemh("program.mem", MEM.ram);
@(negedge clk) begin
    // ifmap_buffer_start_addr = MEM.ram[0];
    // weight_buffer_start_addr = MEM.ram[1];
    // compressor_start_addr = MEM.ram[2];
    $display("Loading MEM done");
end
endtask

task reset();
    rst_n = 0;
    start = 0;
    layer_type_in = LAYER1;
    ifmap_buffer_start_addr = 3;
    weight_buffer_start_addr = 16'h19ba;
    compressor_start_addr = 16'h1a12;
    @(negedge clk);
    @(negedge clk);
    rst_n = 1;
    $display("Reset done.");
endtask

task start_layer1();
@(posedge clk);
layer_type_in <= LAYER1;
start <= 1;
@(posedge clk);
start <= 0;
endtask

initial begin
        $fsdbDumpfile("dump.fsdb");
        $fsdbDumpvars(0,top_tb,"+all");
        $fsdbDumpon;
    end

initial begin
    clk = 0;
    initialize_mem();
    reset();
    start_layer1();
    for(int i = 0; i < 60000; i=i+1) begin
        @(negedge clk);
    end
    $finish;
end
endmodule