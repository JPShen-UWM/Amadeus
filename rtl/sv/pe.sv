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
    output logic                psum_ack_out    // The psum in is acknoledged
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
logic [L1_FILTER_SIZE-1:0][WDATA_SIZE-1:0] weight_ram;
logic [3:0] weight_ptr;
always_ff @(posedge clk) begin
    if(rst) begin
        weight_ram <= '0;
    end
    else if(op_stage == LOAD_FILTER && pe_packet.valid) begin
        // Check if this filter belong to self
        if((cur_mode == MODE4 && pe_packet.packet_idx == MODE4_FILTER_IDX) |
        (cur_mode != MODE4 && pe_packet.packet_idx == ROW_IDX)) begin
            weight_ram <= pe_packet.data[L1_FILTER_SIZE-1:0];
        end
    end
end

// weight ptr go through the weight ram circularly
logic max_weight_ptr =  (cur_mode == MODE1)? L1_FILTER_SIZE - 1:
                        (cur_mode == MODE2)? L2_FILTER_SIZE - 1:
                        (cur_mode == MODE3)? L3_FILTER_SIZE - 1:
                                            L4_FILTER_SIZE - 1;
always_ff @(posedge clk) begin
    if(rst) weight_ptr <= '0;
    if(change_mode) weight_ptr <= '0;
    else if(op_stage == CONV & !stall) begin
        if(weight_ptr == max_weight_ptr) weight_ptr <= '0;
        else weight_ptr <= weight_ptr + 1;
    end
end

logic [WDATA_SIZE-1:0] weight_next; // next weight that going into multiplier
assign weight_next = weight_ram[weight_ptr];

endmodule