module top_tb();

logic clk, rst_n;
logic [`MEM_ADDR_SIZE-1:0] mem_addr;
logic [`MEM_BANDWIDTH*8-1:0] mem_write_data;
logic mem_write_valid;
logic  [`MEM_BANDWIDTH*8-1:0] mem_data;
logic  mem_valid;
logic layer_complete;
logic start;
LAYER_TYPE layer_type_in;
logic [`MEM_ADDR_SIZE-1:0] ifmap_buffer_start_addr;
logic [`MEM_ADDR_SIZE-1:0] weight_buffer_start_addr;
logic [`MEM_ADDR_SIZE-1:0] compressor_start_addr;

// Mimic memory
memory MEM(clk, mem_addr, mem_write_data, mem_write_valid, mem_data, mem_valid);

// DUT
amadeus_top DUT(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .layer_type_in(layer_type_in),
    .ifmap_buffer_start_addr(ifmap_buffer_start_addr),
    .weight_buffer_start_addr(weight_buffer_start_addr),
    .compressor_start_addr(compressor_start_addr),
    .mem_addr(mem_addr),
    .mem_write_data(mem_write_data),
    .mem_write_valid(mem_write_valid),
    .layer_complete(layer_complete)
);

task initialize_mem();
$readmemh("program.mem", memory.unified_memory);
ifmap_buffer_start_addr = memory.unified_memory[0];
weight_buffer_start_addr = memory.unified_memory[1];
compressor_start_addr = memory.unified_memory[2];
$display("Loading memory done");
endtask

task reset();
    clk = 0;
    rst_n = 0;
    start = 0;
    layer_type_in = LAYER1;
    ifmap_buffer_start_addr = 0;
    weight_buffer_start_addr = 0;
    compressor_start_addr = 0;
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
    initialize_mem();
    reset();

end
endmodule