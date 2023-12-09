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
    logic [2:0] available_unit; // the number of unit which can be write in

    logic [4:0][15:0] val_position_mask;
    logic [4:0][3:0]  val_position;
    logic [4:0][3:0]  val_position_insert_zero; // consider 0 as val, insert 0 as the first valid
    logic [4:0][3:0]  final_val_position; //

    logic [4:0] val_position_valid;
    logic [4:0] val_insert_zero_valid;
    logic [4:0] final_val_valid;
    logic [2:0] val_valid_count;

    logic [4:0] val_valid;
    logic [4:0] zero_valid;

    logic [3:0] previous_zero_left;
    logic first_zero_val; // if 0 can be at val position, it must appear at the first val
    logic all_zero;

    logic [4:0][3:0] zero_num_unit; // the number of zero in each unit
    logic [4:0] zero_num_unit_valid; //whether zeros should be put into compress_data unit

    logic compress_ready;

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

    assign available_unit = 5 - compressed_data_write_ptr;

    // if the first val is 0
    assign first_zero_val = ( (val_position[0] > previous_zero_left) & val_position_valid[0] ) | all_zero;

    // insert zero as first val
    /* if the input has 10 valid num
        0 0 0 1 0 3 0 5 0....
            final_val_position  , val_insert_zero_valid
        0       1                              1
        1       3                              1
        2       5                              1
        3       7                              1
        4       9                              0
        for not valid position, assign the value to valid num in input
    */
    assign val_position_insert_zero = first_zero_val ? {val_position[3:0], previous_zero_left} : val_position;
    assign val_insert_zero_valid = first_zero_val ? {val_position_valid[3:0], 1'b1} : val_position_valid;

    for(genvar i = 0; i < 5; i=i+1) begin
        assign final_val_position[i] = val_insert_zero_valid[i] ? val_position_insert_zero : valid_taken_num-1;
        assign final_val_valid[i] = val_insert_zero_valid[i];
    end
    countones #(.WIDTH(5)) count(
        .in(final_val_valid),
        .count(val_valid_count)
    );
    // zero_num_unit is the zero number for each compress unit
    assign zero_num_unit[0] = 15 + val_position_insert_zero[0] - previous_zero_left;
    for(genvar i = 1; i < 5; i = i+1) begin: zero_num
        assign zero_num_unit[i] = val_position_insert_zero[i] - val_position_insert_zero[i-1] - 1;
        assign zero_num_unit_valid[i] = final_val_valid[i] | (final_val_valid[i-1] & (outmap_data[outmap_data_valid_num-1] == 0));
    end

    // assign the val and zero to compress unit from compressed_data_write_ptr
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            compressed_data <= '0;
        end
        else if(compress_ready) begin
            compress_data <= '0;
        end
        else begin
            for(integer i = 0; i < 5; i=i+1) begin
                if( (compressed_data_write_ptr+i) < 5 ) begin
                    compress_data[(compressed_data_write_ptr+i)*12+11 : (compressed_data_write_ptr + i)*12+4] <= final_val_valid[i] ? outmap_data[final_val_position[i]] : compress_data[(compressed_data_write_ptr+i)*12+11 : (compressed_data_write_ptr + i)*12+4]; // for val
                    compress_data[(compressed_data_write_ptr+i)*12+3 : (compressed_data_write_ptr + i)*12] <= zero_num_unit_valid[i] ? zero_num_unit[i] : '0;
                end
            end
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            compress_ready <= '0;
        end
        else begin
            compress_ready <= (compressed_data_write_ptr + val_valid_count > 4);
        end
    end

    assign valid_taken_num = compress_ready ? 0 : 1;


endmodule