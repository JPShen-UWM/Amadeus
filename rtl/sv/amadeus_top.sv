module amadeus(
    input clk,
    input rst_n,
    input [`MEM_BANDWIDTH*8-1:0] mem_read_data,
    input mem_valid,
    input [`MEM_ADDR_SIZE-1:0] ifmap_buffer_start_addr,
    input [`MEM_ADDR_SIZE-1:0] weight_buffer_start_addr,
    input [`MEM_ADDR_SIZE-1:0] compressor_start_addr,

    output [`MEM_ADDR_SIZE-1:0] mem_addr,
    output [`MEM_BANDWIDTH*8-1:0] mem_write_data,
    output mem_read,
    output mem_write
);

    


endmodule