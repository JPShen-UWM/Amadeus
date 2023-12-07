// PE array network
`timescale 1ns/100ps
module pe_array(
    input                           clk,
    input                           rst,
    // input feature noc
    output logic [5:0][6:0]         pe_full,
    input DIAGONAL_BUS_PACKET       diagonal_bus_packet,
    // weight buffer
    input PE_IN_PACKET              weight_in_array[0:5],
    // to psum buffer
    input PSUM_PACKET   [6:0]       psum_to_pe,
    output logic        [6:0]       pe_psum_ack,
    output PSUM_PACKET  [6:0]       psum_to_buffer,
    input logic         [6:0]       psum_buffer_ack,
    // To controller
    input OP_MODE                   mode_in,
    input                           change_mode,
    input                           conv_continue,
    input OP_STAGE                  op_stage_in,
    output [5:0][6:0]               pe_conv_done,
    // To output buffer
    output PSUM_PACKET [6:0]        psum_row2_out,
    output PSUM_PACKET [6:0]        psum_row4_out,
    input [6:0]                     outbuff_row2_ack_in,
    input [6:0]                     outbuff_row4_ack_in,
    input [6:0]                     outbuff_row5_ack_in,
    // to tb
    output wor                      error
);

PE_IN_PACKET ifmap_packet[6][7];
PSUM_PACKET psum_in[6][7];
PSUM_PACKET psum_out[6][7];
PSUM_PACKET psum_in_top_row[7];
PSUM_PACKET psum_in_mid_row[7];
logic psum_ack_in[6][7];
logic psum_ack_out[6][7];

OP_MODE cur_mode;
always_ff @(posedge clk) begin
    if(rst) cur_mode <= MODE1;
    else if(change_mode) cur_mode <= mode_in;
end

genvar i, j;
generate
    // PE array 6x7
    for(i = 0; i < 6; i++) begin
        for(j = 0; j < 7; j++) begin
            pe #(.ROW_IDX(i), .COL_IDX(j)) PE_ARRAY (
                .clk(clk),
                .rst(rst),
                .mode_in(mode_in),           // mode selection
                .change_mode(change_mode),
                .ifmap_packet(ifmap_packet[i][j]),      // PE packet broadcasted from buffer
                .filter_packet(weight_in_array[i]),
                .op_stage_in(op_stage_in),
                .psum_in(psum_in[i][j]),
                .psum_ack_in(psum_ack_in[i][j]),    // The psum out has been taken by next stage
                .conv_continue(conv_continue),  // reload ifmap, continue next round convolution
                .psum_out(psum_out[i][j]),
                .psum_ack_out(psum_ack_out[i][j]),   // The psum in is acknoledged
                .conv_done(pe_conv_done[i][j]),      // All the convolution is done, wait for continue to restart
                .error(error),          // Error raise when scrach pad is full and a new packet coming in
                .full(pe_full[i][j])          // ifmap scratch pad is full
            );
        end
    end
    // Top zero_psum_gen
    for(i = 0; i < 7; i++) begin
        zero_psum_gen TOP_ROW_PSUM_GEN(
            .clk(clk),
            .rst(rst),
            .psum_ack(psum_ack_out[0][i]),
            .mode_in(mode_in),
            .change_mode(change_mode),
            .conv_continue(conv_continue),
            .op_stage_in(op_stage_in),
            .psum_out(psum_in_top_row[i])
        );
    end
    // Middle zero_psum_gen
    for(j = 0; j < 7; j++) begin
        zero_psum_gen MID_ROW_PSUM_GEN(
            .clk(clk),
            .rst(rst),
            .psum_ack(psum_ack_out[3][j]),
            .mode_in(mode_in),
            .change_mode(change_mode),
            .conv_continue(conv_continue),
            .op_stage_in(op_stage_in),
            .psum_out(psum_in_mid_row[j])
        );
    end


    // **********************Psum connection****************************//
    // Top to row0
    // Connect to psum_buffer while in mode2
    for(j = 0; j < 7; j++) begin
        assign psum_in[0][j] = cur_mode == MODE2? psum_to_pe[j]: psum_in_top_row[j];
        assign pe_psum_ack[j] = cur_mode == MODE2? psum_ack_out[0][j]: 1'b0;
    end

    // row0 to row1
    for(j = 0; j < 7; j++) begin
        assign psum_in[1][j] = psum_out[0][j];
        assign psum_ack_in[0][j] = psum_ack_out[1][j];
    end

    // row1 to row2
    for(j = 0; j < 7; j++) begin
        assign psum_in[2][j] = psum_out[1][j];
        assign psum_ack_in[1][j] = psum_ack_out[2][j];
    end

    // row2 to row3
    // row3 connect to middle psum gen at mode4
    // row2 output to output buffer at mode4
    for(j = 0; j < 7; j++) begin
        assign psum_in[3][j] = cur_mode == MODE4? psum_in_mid_row[j]: psum_out[2][j];
        assign psum_ack_in[2][j] = cur_mode == MODE4? outbuff_row2_ack_in[j]: psum_ack_out[3][j];
        assign psum_row2_out[j] = psum_out[2][j];
    end

    // row3 to row4
    for(j = 0; j < 7; j++) begin
        assign psum_in[4][j] = psum_out[3][j];
        assign psum_ack_in[3][j] = psum_ack_out[4][j];
    end

    // row4 to row5
    // row4 output to output buffer at mode2
    for(j = 0; j < 7; j++) begin
        assign psum_in[5][j] = psum_out[4][j];
        assign psum_ack_in[4][j] = cur_mode == MODE2? outbuff_row4_ack_in[j]: psum_ack_out[5][j];
        assign psum_row4_out[j] = psum_out[4][j];
    end

    // row5 to output buffer
    // row5 connect to psum buffer at mode1, connect to output buffer at mode3,mode4
    for(j = 0; j < 7; j++) begin
        assign psum_ack_in[5][j] = cur_mode == MODE1? psum_buffer_ack[j]:
                                   cur_mode == MODE2? 1'b1: outbuff_row5_ack_in[j];
        assign psum_to_buffer[j] = psum_out[5][j];
    end


    // **********************Psum connection end****************************//

    // ********************** ifmap connection begin **********************//
    /*
    diagonal bus    d0      0	1	2	3	4	5	6
                    d1      1	2	3	4	5	6	7
                    d2      2	3	4	5	6	7	8
                    d3      7	8	9	10	11	12	x
                    d4      8	9	10	11	12	13	x
                    d5      9	10	11	12	13	14	x
                                d6  d7  d8  d9  d10 d11
    */
    for(i = 0; i < 6; i++) begin
        for(j = 0; j < 7; j++) begin
            assign ifmap_packet[i][j] = diagonal_bus_packet.diagonal_bus[i+j];
        end
    end
    // ********************** ifmap connection end **********************//

endgenerate



endmodule