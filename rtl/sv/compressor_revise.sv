module compressor_r(
    input                   clk,
    input                   rst_n,
    input  [15:0][7:0]      outmap_data,           // will start from the first valid data
    input                   start,
    input  [4:0]            outmap_data_valid_num, // from 0-16
    input                   mem_ack,               // will not compress new data if memack is not ready
    output [4:0]            valid_taken_num,       // the element which has been taken by compressor
    output [63:0]           compressed_data,       // // [63]=? [62:60]=***
    output                  mem_req                // mem_req will only be assert when compressed data is ready
);

    //|......|''''''|......|''''''|......|''''''|
    //   full/req        clear       new data in
    logic [2:0] compressed_data_write_ptr;
    logic [4:0][15:0] val_position_mask;
    logic [4:0][3:0]  val_position;
    logic [4:0][3:0]  val_position_insert_zero; // consider 0 as val, insert 0 as the first valid
    logic [4:0] val_position_valid;
    logic [4:0] val_position_insert_zero_valid;

    logic [4:0] val_valid;
    logic [4:0] zero_valid;

    logic [4:0][7:0] unit_val;
    logic [4:0][4:0]

    logic [3:0] previous_zero_left;
    logic first_zero_val; // if 0 can be at val position, it must appear at the first val
    logic all_zero;

    logic [4:0][3:0] zero_num_unit; // the number of zero in each unit

    logic [63:0] compress_data_next;

    // represent the position where value is not zero
    for(genvar i = 0; i < 16; i=i+1) begin
        assign val_position_mask[0][i] = outmap_data[i] != 0 && i < outmap_data_valid_num;
    end
    // if all input data is zero
    assign all_zero = outmap_data_valid_num == 16 & ~(|val_position_mask[0]);

    // mask off the chosen not zero bit
    for(genvar i = 1; i < 5; i = i+1) begin
        assign val_position_mask[i] = val_position_mask[i-1] & ~(1'b1 << val_position[i-1]);
    end

    // get the index of non-zero val
    for(genvar i = 0; i < 5; i = i + 1) begin : compress_unit_val_position
        priority_encoder #(.WIDTH(16)) pe(
            .req(val_position_mask[i]),
            .gnt(val_position[i]),
            .valid(val_position_valid[i]),
        );
    end

    // if the first val is 0
    assign first_zero_val = ( (val_position[0] > previous_zero_left) & val_position_valid[0] ) | all_zero;

    assign val_position_insert_zero = first_zero_val ? {val_position[3:0], previous_zero_left} : val_position;
    assign val_position_insert_zero_valid = first_zero_val ? {val_position_valid[3:0], 1'b1} : val_position_valid;

    // zero_num_unit is the zero number for each compress unit
    assign zero_num_unit[0] = val_position_insert_zero[0] + previous_zero_left;
    for(genvar i = 1; i < 5; i = i+1) begin: zero_num
        assign zero_num_unit[i] = val_position_insert_zero_valid[i] ? val_position_insert_zero[i] - val_position_insert_zero[i-1] - 1 : 0;
    end

    logic [4:0][2:0] val_unit_update;
    logic [4:0] val_unit_update_valid;
    for(genvar i = 0; i < 5; i=i+1) begin
        assign val_unit_update_valid[i] = compressed_data_write_ptr <= i ? 
    end

    assign valid_taken_num = 

endmodule