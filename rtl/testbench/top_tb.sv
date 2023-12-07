module top_tb();

logic clk, rst_n;
logic [`MEM_ADDR_SIZE-1:0] mem_addr;
logic [`MEM_BANDWIDTH*8-1:0] mem_write_data;
logic mem_write_valid;
logic  [`MEM_BANDWIDTH*8-1:0] mem_data;
logic  mem_valid;

// Mimic memory
memory MEM(clk, mem_addr, mem_write_data, mem_write_valid, mem_data, mem_valid);

// DUT

task initialize_mem();
$readmemh("program.mem", memory.unified_memory);
$display("Loading memory done");
endtask

endmodule