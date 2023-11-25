module compressor(
    input clk,
    input rst_n,
    input [15:0][7:0] outmap_data,     // will start from the first valid data
    input start,
    input [3:0] outmap_data_valid_num, // from 0-8
    input mem_ack, // will not compress new data if memack is not ready
    output [3:0] valid_taken_num, // the element which has been taken by compressor
    output [64:0] compressed_data,
    output mem_req // mem_req will only be assert when compressed data is ready
);


endmodule