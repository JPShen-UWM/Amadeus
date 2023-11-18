// Processing element
module pe(
    input                       clk,
    input                       rst,
    input OP_MODE               mode,           // mode selection
    input                       change_mode,
    input PE_IN_PACKET          pe_packet,      // PE packet broadcasted from buffer
    input OP_STAGE              op_stage,
    input PSUM_DATA_SIZE        psum_in,
    input                       psum_ack_in,    // The psum out has been taken by next stage

    output PSUM_DATA_SIZE       psum_out,
    output logic                psum_ack_out,   // The psum in is acknoledged
    output logic                error           // Error raise when scrach pad is full and a new packet coming in
);

parameter ROW_IDX = 0;
parameter COL_IDX = 0;
// Index for receiving input feature map packet
localparam MODE1_IDX = ROW_IDX + COL_IDX * 4;
localparam MODE2_IDX = ROW_IDX + COL_IDX * 4;
localparam MODE3_IDX = ROW_IDX + COL_IDX;
localparam MODE4_IDX = (ROW_IDX < 3)? ROW_IDX + COL_IDX: ROW_IDX + COL_IDX + 4;
localparam MODE4_FILTER_IDX = (ROW_IDX < 3)? ROW_IDX: ROW_IDX-3;

logic stall; // Multiplication is stall because of empty ifmap fifo

logic OP_MODE cur_mode;
always_ff @(posedge clk) begin
    if(rst) cur_mode <= MODE1;
    else if(change_mode) cur_mode <= mode;
end

// Weight fifo act as a circular fifo
logic [3:0][L1_FILTER_SIZE-1:0][WDATA_SIZE-1:0] filter_ram;
logic [3:0] conv_cnt;
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
logic max_filter_ptr =  (cur_mode == MODE1)? L1_FILTER_SIZE - 1:
                        (cur_mode == MODE2)? L2_FILTER_SIZE - 1:
                        (cur_mode == MODE3)? L3_FILTER_SIZE - 1:
                                            L4_FILTER_SIZE - 1;
always_ff @(posedge clk) begin
    if(rst) conv_cnt <= '0;
    if(change_mode) conv_cnt <= '0;
    else if(op_stage == CONV & filter_ptr_inc) begin
        if(conv_cnt == max_filter_ptr) conv_cnt <= '0;
        else conv_cnt <= conv_cnt + 1;
    end
end


// Filter pointer, each ifmap should mult with all the filters before proceed to next one
logic [1:0] filter_ptr; // Only support four filter in pe
always_ff @(posedge clk) begin
    if(rst) filter_ptr <= '0;
    if(change_mode) filter_ptr <= '0;
    else if(op_stage == CONV & !stall) begin
        filter_ptr <= filter_ptr + 1;
    end
end
logic filter_ptr_inc = filter_ptr == 2'b11 & !stall; // Increment filter pointer when each filter has been iterated

logic [WDATA_SIZE-1:0] weight_next; // next weight that going into multiplier
assign weight_next = filter_ram[filter_ptr][filter_ptr];

////////////////////////////////////////////////////////////////
//                   ifmap scratch pad                        //
////////////////////////////////////////////////////////////////
// Act as FIFO with special read write ptr
// It contains 3 sections and each has 4 data
// As the input packet has a size of 4, each section should be update together
// |    section 0  |    section 1  |    section 2    |
// |    valid      |       valid   |     invalid     |   valid_bit track the valid status of each section
// |_0_|_1_|_2_|_3_|_4_|_5_|_6_|_7_|_8_|_9_|_10_|_11_|
//           ^           ^
//      start_ptr      read_ptr
// start_ptr point to the start element of current sliding window
// While start_ptr move to a new section, the previous section will be free
// read_ptr travel between start_ptr to the each of valid section
// Once read_ptr point to an invalid section, the conv must be stall and wait
// for new pe packet
// If a new input packet come in with no valid section, an error will be asserted
logic [11:0][IFDATA_SIZE-1:0] ifmap_ram;
logic [3:0] start_ptr, read_ptr;

// Packet receiving logic
logic packet_in_valid; // Assert when the current packet is for this PE
assign packet_in_valid = !pe_packet.valid? 1'b0:
                        (cur_mode == MODE1)? pe_packet.packet_idx == MODE1_IDX:
                        (cur_mode == MODE2)? pe_packet.packet_idx == MODE2_IDX:
                        (cur_mode == MODE3)? pe_packet.packet_idx == MODE3_IDX:
                                            pe_packet.packet_idx == MODE4_IDX;
// section valid bit
logic [2:0] section_valid, section_valid_comb; // valid bit tracking which section is valid
logic [2:0] section_write; // Determine which section to write
logic [2:0] section_to_free; // Determine which section to free

// Free a section when the start pointer has just left it
always_comb begin
    section_to_free = 3'b0;
    if(start_ptr == 4 && start_ptr_ff != 4)      section_to_free == 3'b001;
    else if(start_ptr == 8 && start_ptr_ff != 8) section_to_free == 3'b010;
    else if(start_ptr == 0 && start_ptr_ff != 0) section_to_free == 3'b100;
end
always_ff @(posedge clk) begin
    if(rst) section_valid <= 3'b0;
    else section_valid <= section_valid_comb;
end
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
    else if(section_write[0]) ifmap_ram[ 3:0] <= pe_packet.data;
    else if(section_write[1]) ifmap_ram[ 7:4] <= pe_packet.data;
    else if(section_write[2]) ifmap_ram[11:8] <= pe_packet.data;
end

// Start pointer and read pointer
always_ff @(posedge clk) begin
    if(rst) start_ptr <= '0;
    else if(conv_cnt == max_filter_ptr) begin
        // Move by 4 in MODE1 MODE2
        if(cur_mode == MODE1 | cur_mode == MODE2) begin
            if(start_ptr + 4 > 11) start_ptr <= start_ptr + 4 - 11;
            else start_ptr + 4;
        end
        // Increment by 1 in other case
        else begin
            if(start_ptr + 1 > 11) start_ptr <= start_ptr + 1 - 11;
            else start_ptr + 1;
        end
    end
end

// Start_ptr_ff use to trackstart_ptr change
always_ff @(posedge clk) begin
    if(rst) start_ptr_ff <= '0;
    else start_ptr_ff <= start_ptr;
end

// Read pointer is start pointer plus conv count, check handle overflow correctly
assign read_ptr = (start_ptr + conv_cnt >= 12)?(start_ptr + conv_cnt - 12):start_ptr + conv_cnt;

// Check stall status
// Stall is asserted when read_ptr try to read invalid section
logic accum_stall; // Stall for doing psum accumulation @TODO!!!
assign stall = (!section_valid[0] && read_ptr == 0) | (!section_valid[1] && read_ptr == 4) | (!section_valid[2] && read_ptr == 8) | accum_stall;

// next input feature data going into mac
logic [IFDATA_SIZE-1:0] ifdata_next;
assign ifdata_next = ifdata_next[read_ptr];


// @TODO LIST:
// Multiplier
// Accumulator
// psum accumulation handshake



endmodule