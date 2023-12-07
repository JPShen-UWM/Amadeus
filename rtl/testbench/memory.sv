// Unsynthesisable memory only for simulation purpose
module memory(
    input clk,
    input [`MEM_ADDR_SIZE-1:0] mem_addr,
    input [`MEM_BANDWIDTH*8-1:0] mem_write_data,
    input mem_write_valid,
    output [`MEM_BANDWIDTH*8-1:0] mem_data,
    output mem_valid
);

	logic [63:0]  ram  [65536 - 1:0];

    always_ff @(posedge clk) begin
        if(mem_write_valid) ram[mem_addr] <= mem_write_data;
    end

    assign mem_data = ram[mem_addr];
    assign mem_valid = 1'b1;

endmodule
