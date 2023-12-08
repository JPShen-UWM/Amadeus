module output_buffer(
    input clk,
    input rst_n,
    // To pe array
    input PSUM_PACKET [6:0]         psum_row2_out,
    input PSUM_PACKET [6:0]         psum_row4_out,
    input PSUM_PACKET  [6:0]        psum_to_buffer,
    output [6:0]                    outbuff_row2_ack_in,
    output [6:0]                    outbuff_row4_ack_in,
    output [6:0]                    outbuff_row5_ack_in,
    // to compressor
    output logic [15:0][7:0]        outmap_data,
    output logic [4:0]              outmap_data_valid_num,
    input  [4:0]                    valid_taken_num,
    // to controller
    input OP_MODE                   mode_in,
    input                           change_mode,
    input CONTROL_STATE             control_state,
    output                          send_done
);



OP_MODE cur_mode;
logic [5:0] psum_size; // Maximum psum_idx

logic [5:0] rd_row_ptr, rd_col_ptr;
logic [5:0] next_rd_row_ptr, next_rd_col_ptr;
logic [1:0] rd_filter_idx, next_rd_filter_idx;

logic [3:0][54:0][54:0][7:0] ob_ram;
logic [5:0] row_start_ptr;
logic [15:0][7:0] outmap_data_next;
logic [4:0] next_outmap_data_valid_num;

OUTPUT_BUFFER_STATE state;

always_ff @(posedge clk) begin
    if(!rst_n) cur_mode <= MODE1;
    else if(change_mode) cur_mode <= mode_in;
end

always_ff @(posedge clk) begin
    if(!rst_n) state <= TAKING_OUTPUT;
    else if(control_state == COMPLETE) state <= SENDING_OUTPUT;
    else if(send_done) state <= TAKING_OUTPUT;
end

assign psum_size =  (cur_mode == MODE1)? `L1_OFMAP_SIZE:
                    (cur_mode == MODE2)? `L1_OFMAP_SIZE:
                    (cur_mode == MODE3)? `L2_OFMAP_SIZE:
                                        `L3_OFMAP_SIZE;

// Row start ptr increment when WAIT_TO_RESTART_CONV
always_ff @(posedge clk) begin
    if(!rst_n) row_start_ptr <= '0;
    else if(control_state == WAIT_TO_RESTART_CONV) row_start_ptr <= row_start_ptr + 7;
    else if(control_state == COMPLETE) row_start_ptr <= '0;
end


// genvar i;
// generate
int i;
always_ff @(posedge clk) begin
    if(!rst_n) ob_ram <= '0;
    else begin
        // Taking data from row 4 at mode2
        if(cur_mode == MODE2) begin
            for(i = 0; i < 7; i = i+1) begin
                if(i + row_start_ptr < 55) begin
                    if(psum_row4_out[i].valid) begin
                        // Right shift the required line
                        ob_ram[psum_row4_out[i].filter_idx][row_start_ptr + i] <= {relu(psum_row4_out[i].psum), ob_ram[psum_row4_out[i].filter_idx][row_start_ptr + i][54:1]};
                    end
                end
            end
        end
        // Taking data from row 4 at mode 2
        else if(cur_mode == MODE3) begin
            for(i = 0; i < 7; i++) begin
                if(i + row_start_ptr < 13) begin
                    if(psum_row4_out[i].valid) begin
                        // Right shift the required line
                        ob_ram[psum_row4_out[i].filter_idx][row_start_ptr + i] <= {relu(psum_row4_out[i].psum), ob_ram[psum_row4_out[i].filter_idx][row_start_ptr + i][54:1]};
                    end
                end
            end
        end
        // Taking data from row 2 and row 5
        else if(cur_mode == MODE4) begin
            for(i = 0; i < 7; i++) begin
                if(psum_row2_out[i].valid) begin
                    // Right shift the required line
                    ob_ram[psum_row2_out[i].filter_idx][row_start_ptr + i] <= {relu(psum_row2_out[i].psum), ob_ram[psum_row2_out[i].filter_idx][row_start_ptr + i][54:1]};
                end
            end
            for(i = 0; i < 6; i++) begin
                if(psum_to_buffer[i].valid) begin
                    // Right shift the required line
                    ob_ram[psum_to_buffer[i].filter_idx][row_start_ptr + i] <= {relu(psum_to_buffer[i].psum), ob_ram[psum_to_buffer[i].filter_idx][row_start_ptr + i][54:1]};
                end
            end
        end
    end
end
// endgenerate

always_ff @(posedge clk) begin
    if(!rst_n) begin
        rd_col_ptr <= 'b0;
        rd_row_ptr <= 'b0;
        rd_filter_idx <= 'b0;
    end
    else if(state == SENDING_OUTPUT & !send_done) begin
        rd_col_ptr <= next_rd_col_ptr;
        rd_row_ptr <= next_rd_row_ptr;
        rd_filter_idx <= next_rd_filter_idx;
    end
    else begin
        rd_col_ptr <= 'b0;
        rd_row_ptr <= 'b0;
        rd_filter_idx <= 'b0;
    end
end

assign next_rd_col_ptr = (rd_col_ptr + valid_taken_num == psum_size)? 0: rd_col_ptr + valid_taken_num;
assign next_rd_row_ptr = (rd_col_ptr + valid_taken_num == psum_size)? rd_row_ptr + 1: rd_row_ptr;
assign next_rd_filter_idx = (rd_col_ptr + valid_taken_num == psum_size && rd_row_ptr == psum_size - 1)? rd_filter_idx + 1: rd_filter_idx;
assign send_done = rd_col_ptr + valid_taken_num == psum_size && rd_row_ptr == psum_size - 1 && rd_filter_idx == 2'b11;

assign next_outmap_data_valid_num = (state != SENDING_OUTPUT)? 'b0:
                                (psum_size - next_rd_col_ptr) > 16? 16:
                                (psum_size - next_rd_col_ptr);


    for(genvar j = 0; j < 16; j++) begin
        assign outmap_data_next[j] = (rd_col_ptr + j < 55)? ob_ram[next_rd_filter_idx][next_rd_row_ptr][next_rd_col_ptr + j]: 'b0;
    end


always_ff @(posedge clk) begin
    if(!rst_n) outmap_data <= '0;
    else outmap_data <= outmap_data_next;
end

always_ff @(posedge clk) begin
    if(!rst_n) outmap_data_valid_num <= '0;
    else outmap_data_valid_num <= next_outmap_data_valid_num;
end


    for(genvar j = 0; j < 7; j++) begin
        assign outbuff_row2_ack_in[j] = (cur_mode == MODE4) & psum_row2_out[j].valid;
        assign outbuff_row4_ack_in[j] = (cur_mode == MODE2 | cur_mode == MODE3) & psum_row4_out[j].valid;
        assign outbuff_row5_ack_in[j] = (cur_mode == MODE4) & psum_to_buffer[j].valid;
    end


assert property(@(posedge clk) next_rd_col_ptr + valid_taken_num <= psum_size);
assert property(@(posedge clk) valid_taken_num <= outmap_data_valid_num);

endmodule

