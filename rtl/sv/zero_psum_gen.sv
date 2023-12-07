module zero_psum_gen (
    input                   clk,
    input                   rst,
    input                   psum_ack,
    input OP_MODE           mode_in,
    input                   change_mode,
    input                   conv_continue,
    input OP_STAGE          op_stage_in,
    output PSUM_PACKET      psum_out
);

OP_MODE cur_mode;
logic [5:0] psum_idx; // psum index in ofmap
logic [5:0] psum_idx_max; // Maximum psum_idx
logic [1:0] filter_idx;
logic send_done;

assign psum_idx_max = (cur_mode == MODE1)? `L1_OFMAP_SIZE - 1:
                      (cur_mode == MODE2)? `L1_OFMAP_SIZE - 1:
                      (cur_mode == MODE3)? `L2_OFMAP_SIZE - 1:
                                           `L3_OFMAP_SIZE - 1;

always_ff @(posedge clk) begin
    if(rst) cur_mode <= MODE1;
    else if(change_mode) cur_mode <= mode_in;
end

always_ff @(posedge clk) begin
    if(rst) begin
        filter_idx <= 'b0;
        psum_idx <= 'b0;
        send_done <= 'b0;
    end
    else if(conv_continue | change_mode) begin
        filter_idx <= 'b0;
        psum_idx <= 'b0;
        send_done <= 'b0;
    end
    else if(psum_ack) begin
        filter_idx <= filter_idx + 1;
        if(filter_idx == 3) psum_idx <= psum_idx + 1;
        if(filter_idx == 3 && psum_idx == psum_idx_max) send_done <= 1;
    end
end

assign psum_out.psum = 'b0;
assign psum_out.valid = op_stage_in == CONV & ~send_done;
assign psum_out.filter_idx = filter_idx;

endmodule