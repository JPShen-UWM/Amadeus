// Yi Tuo BULL SHIT
// Processing element
//`include "../amadeus/rtl/sv/sys_defs.sv"
module pe
    #(parameter ROW_IDX = 0,
    parameter COL_IDX = 0)(
    input                       clk,
    input                       rst,
    input OP_MODE               mode_in,           // mode selection
    input                       change_mode,
    input PE_IN_PACKET          pe_packet,      // PE packet broadcasted from buffer
    input OP_STAGE              op_stage_in,
    input PSUM_PACKET           psum_in,
    input                       psum_ack_in,    // The psum out has been taken by next stage
    input                       conv_continue,  // reload ifmap, continue next round convolution

    output PSUM_PACKET          psum_out,
    output logic                psum_ack_out,   // The psum in is acknoledged
    output logic                conv_done,      // All the convolution is done, wait for continue to restart
    output logic                error,          // Error raise when scrach pad is full and a new packet coming in
    output logic                full            // ifmap scratch pad is full
);
//synopsys template

// Index for receiving input feature map packet
localparam MODE1_IDX = ROW_IDX + COL_IDX * 4;
localparam MODE2_IDX = ROW_IDX + COL_IDX * 4;
localparam MODE3_IDX = ROW_IDX + COL_IDX;
localparam MODE4_IDX = (ROW_IDX < 3)? ROW_IDX + COL_IDX: ROW_IDX + COL_IDX + 4;
localparam MODE4_FILTER_IDX = (ROW_IDX < 3)? ROW_IDX: ROW_IDX-3;

// Internal signals
logic stall; // Multiplication is stall because of empty ifmap fifo
logic accum_stall; // Stall for doing psum accumulation @TODO!!!
OP_MODE cur_mode;
logic [3:0][L1_FILTER_SIZE-1:0][WDATA_SIZE-1:0] filter_ram;
logic [3:0] conv_cnt;
logic [4:0] max_conv_cnt;
logic conv_cnt_inc;
logic [1:0] filter_ptr; // Only support four filter in pe
logic [WDATA_SIZE-1:0] weight_next; // next weight that going into multiplier
logic [11:0][IFDATA_SIZE-1:0] ifmap_ram;
logic [3:0] start_ptr, read_ptr;
logic packet_in_valid; // Assert when the current packet is for this PE
// section valid bit
logic [2:0] section_valid, section_valid_comb; // valid bit tracking which section is valid
logic [2:0] section_write; // Determine which section to write
logic [2:0] section_to_free; // Determine which section to free
logic [3:0] next_start_ptr; // Next start ptr use to update start ptr and determine when a section can be free
logic [IFDATA_SIZE-1:0] mult_inA;
logic [WDATA_SIZE-1:0] mult_inB;
logic [MULT_OUT_SIZE-1:0] mult_out, mult_out_ff;
logic [IFDATA_SIZE-1:0] ifdata_next;
logic [PSUM_DATA_SIZE-1:0] adder_inA; // signed fixed point (12,5)
logic [PSUM_DATA_SIZE-1:0] adder_inB; // signed fixed point (12,5)
logic [PSUM_DATA_SIZE-1:0] psum_ram_out;
logic [PSUM_DATA_SIZE-1:0] adder_out, adder_out_ff;
logic [3:0][11:0] psum_ram;
logic [3:0][11:0] psum_output_buffer;
// Pipeline for conv cnt, stall, filter_ptr
// _mult signal at mult stage
// _accum at accumulation stage
// _wb at psum writeback stage
logic stall_mult, stall_accum, stall_wb;
logic [5:0] psum_idx_mult, psum_idx_accum, psum_idx_wb;
logic [1:0] filter_ptr_mult, filter_ptr_accum, filter_ptr_wb;
logic [3:0] conv_cnt_mult, conv_cnt_accum, conv_cnt_wb;

logic [5:0] psum_idx; // psum index in ofmap
logic [5:0] psum_idx_max; // Maximum psum_idx

logic [3:0] psum_ready, psum_ready_comb; // status of psum output buffer
logic [11:0] accum_adder_out;


always_ff @(posedge clk) begin
    if(rst) cur_mode <= MODE1;
    else if(change_mode) cur_mode <= mode;
end

// Weight fifo act as a circular fifo
always_ff @(posedge clk) begin
    if(rst) begin
        filter_ram <= '0;
    end
    else if(op_stage == LOAD_FILTER && pe_packet.valid) begin
        // Check if this filter belong to self
        if((cur_mode == MODE4 && pe_packet.packet_idx[2:0] == MODE4_FILTER_IDX) |
        (cur_mode != MODE4 && pe_packet.packet_idx[2:0] == ROW_IDX)) begin
            // Left shift filter line and put new data in right most position
            filter_ram[pe_packet.packet_idx[4:3]] <= {filter_ram[pe_packet.packet_idx[4:3]][L1_FILTER_SIZE-1: 4], pe_packet.data};
        end
    end
end

// weight ptr go through the weight ram circularly
// max_conv_cnt have the filter size
assign max_conv_cnt = (cur_mode == MODE1)? L1_FILTER_SIZE - 1:
                      (cur_mode == MODE2)? L1_FILTER_SIZE - 1:
                      (cur_mode == MODE3)? L2_FILTER_SIZE - 1:
                                           L3_FILTER_SIZE - 1;

assign conv_cnt_inc = filter_ptr == 2'b11 & !stall; // Increment filter pointer when each filter has been iterated

// conv_cnt count from 0 to max_conv_cnt represent MAC iteration for a single output
always_ff @(posedge clk) begin
    if(rst) conv_cnt <= '0;
    if(change_mode) conv_cnt <= '0;
    else if(op_stage == CONV & conv_cnt_inc) begin
        if(conv_cnt == conv_cnt_inc) conv_cnt <= '0;
        else conv_cnt <= conv_cnt + 1;
    end
end


// Filter pointer, each ifmap should mult with all the filters before proceed to next one
always_ff @(posedge clk) begin
    if(rst) filter_ptr <= '0;
    if(change_mode) filter_ptr <= '0;
    else if(op_stage == CONV & !stall) begin
        filter_ptr <= filter_ptr + 1;
    end
end

assign weight_next = filter_ram[filter_ptr][conv_cnt];

////////////////////////////////////////////////////////////////
//                   ifmap scratch pad                        //
////////////////////////////////////////////////////////////////
// Act as FIFO with special read write ptr
// It contains 3 sections and each has 4 data
// As the input packet has a size of 4, each section should be update together
// |    section 0  |    section 1  |    section 2    |
// |    valid      |       valid   |     invalid     |   valid_bit track the valid status of each section
// |_0_|_1_|_2_|_3_|_4_|_5_|_6_|_7_|_8_|_9_|_10_|_11_|
//           ^       ^       ^
//      start_ptr read_ptr next_start_ptr
// start_ptr point to the start element of current sliding window
// While start_ptr move to a new section, the previous section will be free
// read_ptr travel between start_ptr to the each of valid section
// Once read_ptr point to an invalid section, the conv must be stall and wait
// for new pe packet
// If a new input packet come in with no valid section, an error will be asserted

// Packet receiving logic
assign packet_in_valid = !pe_packet.valid? 1'b0:
                        (cur_mode == MODE1)? pe_packet.packet_idx == MODE1_IDX:
                        (cur_mode == MODE2)? pe_packet.packet_idx == MODE2_IDX:
                        (cur_mode == MODE3)? pe_packet.packet_idx == MODE3_IDX:
                                            pe_packet.packet_idx == MODE4_IDX;

// Free a section when the next_start_ptr point to a new section and read_ptr reach it in a new filter round
always_comb begin
    section_to_free = 3'b0;
    if(filter_ptr == 0) begin
        if(next_start_ptr == 4 && read_ptr == 4)      section_to_free = 3'b001;
        else if(next_start_ptr == 8 && read_ptr == 8) section_to_free = 3'b010;
        else if(next_start_ptr == 0 && read_ptr == 0) section_to_free = 3'b100;
    end
end

always_ff @(posedge clk) begin
    if(rst) section_valid <= 3'b0;
    else if(conv_continue) section_valid <= 3'b0;
    else section_valid <= section_valid_comb;
end

assign full = &section_valid;

// Combination logic to determine which section to allocate when new packet in
always_comb begin
    section_valid_comb = section_valid;
    section_write = 3'b0;
    error = 0;
    // Free section
    section_valid_comb = section_valid_comb & !section_to_free;
    if(packet_in_valid) begin
        case(section_valid_comb)
            3'b000: begin
                section_write = 3'b001;
                section_valid_comb = 3'b001;
            end
            3'b001: begin
                section_write = 3'b010;
                section_valid_comb = 3'b011;
            end
            3'b010: begin
                section_write = 3'b010;
                section_valid_comb = 3'b011;
            end
            3'b011: begin
                section_write = 3'b100;
                section_valid_comb = 3'b111;
            end
            3'b100: begin
                section_write = 3'b001;
                section_valid_comb = 3'b101;
            end
            3'b101: begin
                section_write = 3'b010;
                section_valid_comb = 3'b111;
            end
            3'b110: begin
                section_write = 3'b001;
                section_valid_comb = 3'b111;
            end
            3'b111: begin
                error = 1; // Assert error when trying to write when section full
            end
        endcase
    end
end

// ifmap ram
always_ff @(posedge clk) begin
    if(rst) ifmap_ram <= '0;
    else if(conv_continue) ifmap_ram <= '0;
    else if(section_write[0]) ifmap_ram[ 3:0] <= pe_packet.data;
    else if(section_write[1]) ifmap_ram[ 7:4] <= pe_packet.data;
    else if(section_write[2]) ifmap_ram[11:8] <= pe_packet.data;
end

// Start pointer and read pointer
always_comb begin
    next_start_ptr = start_ptr;
    if(cur_mode == MODE1 | cur_mode == MODE2) begin
        if(start_ptr + 4 > 11) next_start_ptr = start_ptr + 4 - 11;
        else next_start_ptr = start_ptr + 4;
    end
    // Increment by 1 in other case
    else begin
        if(start_ptr + 1 > 11) next_start_ptr = start_ptr + 1 - 11;
        else next_start_ptr = start_ptr + 1;
    end
end
always_ff @(posedge clk) begin
    if(rst) start_ptr <= '0;
    else if(conv_continue) start_ptr <= '0;
    else if(conv_cnt == max_conv_cnt) begin
        start_ptr <= next_start_ptr;
    end
end

/*
// Start_ptr_ff use to trackstart_ptr change
always_ff @(posedge clk) begin
    if(rst) start_ptr_ff <= '0;
    else start_ptr_ff <= start_ptr;
end
*/

// Read pointer is start pointer plus conv count, check handle overflow correctly
assign read_ptr = (start_ptr + conv_cnt >= 12)?(start_ptr + conv_cnt - 12):start_ptr + conv_cnt;

// Check stall status
// Stall is asserted when read_ptr try to read invalid section
assign stall = (!section_valid[0] && read_ptr == 0) | (!section_valid[1] && read_ptr == 4) | (!section_valid[2] && read_ptr == 8) | accum_stall;

// next input feature data going into mac
assign ifdata_next = ifmap_ram[read_ptr];

// Multiplier
mult_fixed MULT(.inA(mult_inA), .inB(mult_inB), .out(mult_out));

// Not zero skipping or zero skipping
/*
`ifndef ZERO_SKIPPING
`define
always_ff @(posedge clk) begin
    if(rst) begin
        mult_inA <= '0;
        mult_inB <= '0;
        mult_out_ff <= '0;
    end
    else if(!accum_stall) begin
        mult_inA <= ifdata_next;
        mult_inB <= weight_next;
        mult_out_ff <= mult_out;
    end
end

`else
`define
*/
logic skip_zero, skip_zero_ff;
// Perform zero skip when either input is zero or conv is stall
assign skip_zero = ~|ifdata_next | ~|weight_next | stall;

always_ff @(posedge clk) begin
    if(rst) begin
		mult_out_ff <= '0;
        mult_inA <= '0;
        mult_inB <= '0;
    end
    // Zero skip block data go into multiplier
    else begin
        if(!skip_zero & !accum_stall) begin
            mult_inA <= ifdata_next;
            mult_inB <= weight_next;
        end
        if(skip_zero_ff) mult_out_ff <= '0;
        else if(!accum_stall) mult_out_ff <= mult_out;
    end
end

always_ff @(posedge clk) begin
    if(rst) skip_zero_ff <= 0;
    else skip_zero_ff <= skip_zero;
end
//`endif // ZERO SKIPPING END

// MAC adder
assign adder_inA = {{4{mult_out_ff[MULT_OUT_SIZE-1]}}, mult_out_ff}; // Sign extension of mult output
assign adder_inB = psum_ram_out;

adder_fixed MAC_ADDER(.inA(adder_inA), .inB(adder_inB), .out(adder_out));

always_ff @(posedge clk) begin
    if(rst) adder_out_ff <= '0;
    else if(!accum_stall) adder_out_ff <= adder_out;
end


// PSUM scratchpad
assign psum_idx_max = (cur_mode == MODE1)? L1_OFMAP_SIZE - 1:
                      (cur_mode == MODE2)? L1_OFMAP_SIZE - 1:
                      (cur_mode == MODE3)? L2_OFMAP_SIZE - 1:
                                           L3_OFMAP_SIZE - 1;
always_ff @(posedge clk) begin
    if(rst) psum_idx <= '0;
    else if(conv_cnt == max_conv_cnt && filter_ptr == 3) begin
        if(psum_idx == psum_idx_max) psum_idx <= '0;
        else psum_idx <= psum_idx + 1;
    end
end

// Pipeline for conv cnt, stall, filter_ptr
always_ff @(posedge clk) begin
    if(rst) begin
        stall_mult          <= '0;
        stall_accum         <= '0;
        stall_wb            <= '0;
        psum_idx_mult       <= '0;
        psum_idx_accum      <= '0;
        psum_idx_wb         <= '0;
        filter_ptr_mult     <= '0;
        filter_ptr_accum    <= '0;
        filter_ptr_wb       <= '0;
        conv_cnt_mult       <= '0;
        conv_cnt_accum      <= '0;
        conv_cnt_wb         <= '0;
    end
    else if(!accum_stall) begin
        stall_mult          <= stall;
        stall_accum         <= stall_mult;
        stall_wb            <= stall_accum;
        psum_idx_mult       <= psum_idx;
        psum_idx_accum      <= psum_idx_mult;
        psum_idx_wb         <= psum_idx_accum;
        filter_ptr_mult     <= filter_ptr;
        filter_ptr_accum    <= filter_ptr_mult;
        filter_ptr_wb       <= filter_ptr_accum;
        conv_cnt_mult       <= conv_cnt;
        conv_cnt_accum      <= conv_cnt_mult;
        conv_cnt_wb         <= conv_cnt_accum;
    end
end

// Psum scratch pad sram
always_ff @(posedge clk) begin
    if(rst) psum_ram <= '0;
    else if(conv_cnt_wb == max_conv_cnt) psum_ram[filter_ptr_wb] <= 12'b0;
    else psum_ram[filter_ptr_wb] <= adder_out_ff;
end
assign psum_ram_out = psum_ram[filter_ptr_accum];

// Psum output buffer
always_ff @(posedge clk) begin
    if(rst) psum_output_buffer <= '0;
    else if(conv_cnt_wb == max_conv_cnt) psum_output_buffer[filter_ptr_wb] <= adder_out_ff;
end

// psum output buffer status
always_comb begin
    psum_ready_comb = psum_ready;
    psum_ack_out = 0;
    accum_stall = 0;
    // Check if output packet slot is free or will be free next cycle
    if(!psum_out.valid | psum_ack_in) begin
        if(psum_in.valid && psum_ready[psum_in.filter_idx]) begin
            psum_ack_out = 1;
            psum_ready_comb[psum_in.filter_idx] = 1'b0;
        end
    end
    if (conv_cnt_wb == max_conv_cnt) begin
        if(psum_ready_comb[filter_ptr_wb]) accum_stall = 1; // Accumulation stall when try to write in unfree buffer slot
        else psum_ready_comb[filter_ptr_wb] <= 1'b1;
    end
end

always_ff @(posedge clk) begin
    if(rst) psum_ready <= '0;
    else psum_ready <= psum_ready_comb;
end

// Accumulation adder for vertically accumulate psum
adder_fixed ACCUM_ADDER(.inA(psum_in.psum), .inB(psum_output_buffer[psum_in.filter_idx]), .out(accum_adder_out));

// Psum out packet
always_ff @(posedge clk) begin
    if(rst) begin
        psum_out.valid <= 0;
        psum_out.psum <= '0;
        psum_out.filter_idx <= '0;
    end
    // allocate new output packet
    else if(psum_ack_out) begin
        psum_out.valid <= 1;
        psum_out.psum <= accum_adder_out;
        psum_out.filter_idx <= psum_in.filter_idx;
    end
    // If not allocate new packet and last packet it takken, free output slot
    else if(psum_ack_in) psum_out.valid <= 0;
end

// convolution state: done/running
always_ff @(posedge clk) begin
    if(rst) conv_done <= 1'b1;
    else if(conv_continue) conv_done <= '0;
    else if(psum_idx_wb == psum_idx_max && filter_ptr_wb == 2'b11) conv_done <= 1;
end

endmodule