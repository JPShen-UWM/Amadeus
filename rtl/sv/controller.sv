module controller(
    // from TB
    input clk,
    input rst_n,
    input start,
    input layer_type_in,
    input [`MEM_ADDR_SIZE-1:0] ifmap_buffer_start_addr,
    input [`MEM_ADDR_SIZE-1:0] weight_buffer_start_addr,
    input [`MEM_ADDR_SIZE-1:0] compressor_start_addr,
    // from pe
    input [5:0][6:0] pe_conv_done, // directly connected from PEs
    // from decompressor
    input decompressor_mem_req,
    // from compressor
    input compressor_mem_req,
    input [`MEM_BANDWIDTH*8-1:0] compressed_data, 
    // from weight buffer
    input weight_buffer_mem_req,
    input weight_output_finish,
    input weight_load_finish,
    // from ifmap buffer
    input ifmap_data_valid,  // ifmap_data complete load for batch 1, ready for first convolution
    // from memory
    input [`MEM_BANDWIDTH*8-1:0] mem_data,
    input mem_valid,
    
    output start_conv,
    // to decompressor
    output start_decompressor,
    output decompressor_mem_ack,
    output [`MEM_BANDWIDTH*8-1:0] decompressor_mem_data,
    output decompressor_mem_data_valid,
    // to NOC
    output [4:0] complete_count, // if one pe array calculation complete
    // to pe
    output OP_STAGE op_stage,
    output change_mode,
    // to ifmap buffer
    output start_ifmap_buffer_load,
    // to weight buffer
    output start_weight_buffer_load,
    output start_weight_buffer_output,
    output weight_buffer_mem_ack,
    output [`MEM_BANDWIDTH*8-1:0] weight_buffer_mem_data,
    output weight_buffer_mem_data_valid,
    // to compressor
    output compressor_mem_ack,
    // to TB
    output [`MEM_ADDR_SIZE-1:0] mem_addr,
    output [`MEM_BANDWIDTH*8-1:0] mem_write_data,
    output mem_write_valid,
    output layer_complete
);
    CONTROL_STATE state;
    CONTROL_STATE next_state;
    // logic for layer type
    LAYER_TYPE layer_type;
    logic [`MEM_ADDR_SIZE-1:0] start_address;
    MEM_REQ_PACKET
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            layer_type <= NULL;
            start_address <= '0;
        end
        else if(start) begin
            layer_type <= layer_type_in;
            start_address <= start_address_in;
        end
    end

    /// ifmap_buffer control logic ///
    // when there is one complete from PEs, COUNT++
    localparam LAYER1_COUNT = 16;
    localparam LAYER2_COUNT = 4;
    localparam LAYER3_COUNT = 1;

    // complete count from PEs
    logic [5:0][6:0] pe_conv_status; // 1 represent complete, 0 represent not complete
    logic conv_done; // level
    logic conv_complete; // pulse of conv_done
    logic is_last_iteration;

    assign is_last_iteration = (layer_type == LAYER1 & complete_count > 13) | (layer_type == LAYER2 & complete_count > 2);
    for(genvar i = 0; i < 5; i=i+1) begin
        for(genvar j = 0; j < 6; j=j+1) begin
            assign pe_conv_status[i][j] = pe_conv_done[i][j];
        end
    end
    assign pe_conv_status[5][0] = pe_conv_done[5][0] | (mode != MODE1 && mode != MODE4);
    assign pe_conv_status[5][1] = pe_conv_done[5][1] | (mode != MODE1 && mode != MODE4);
    assign pe_conv_status[5][2] = pe_conv_done[5][2] | (mode != MODE1 && mode != MODE4);
    assign pe_conv_status[5][3] = pe_conv_done[5][3] | (mode != MODE1 && mode != MODE4);
    assign pe_conv_status[5][4] = pe_conv_done[5][4] | (mode != MODE1 && mode != MODE4);
    assign pe_conv_status[5][5] = pe_conv_done[5][5] | (mode != MODE1 && mode != MODE4);
    assign pe_conv_status[5][6] = pe_conv_done[5][6] | (mode != MODE1) | is_last_iteration;
    assign pe_conv_status[0][6] = pe_conv_done[0][6] | is_last_iteration;
    assign pe_conv_status[1][6] = pe_conv_done[1][6] | is_last_iteration;
    assign pe_conv_status[2][6] = pe_conv_done[2][6] | is_last_iteration;
    assign pe_conv_status[3][6] = pe_conv_done[3][6] | is_last_iteration | (mode == MODE4);
    assign pe_conv_status[4][6] = pe_conv_done[4][6] | is_last_iteration | (mode == MODE4);

    assign conv_done = &pe_conv_status;
    pulse conv_done_pulse(
        .clk(clk),
        .rst_n(rst_n),
        .level(conv_done),
        .pulse(conv_complete)
    );

    // | running convolution | counter update   |
    //                       |  mode update     |
    //                       |   wait_to_start  | ... | running conv
    //                                                | start_conv pulse
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
            complete_count <= 0;
        end
        else if(conv_complete) begin
            complete_count <= complete_count + 1'b1;
        end
    end

    // logic for mode
    assign mode = (layer_type == LAYER1 & !complete_count[0]) ? MODE1 :
                  (layer_type == LAYER1 & complete_count[0])  ? MODE2 :
                   layer_type == LAYER2                       ? MODE3 :
                   layer_type == LAYER3                       ? MODE4 :
                                                                MODE1;


    //######################################## FSM controller ########################################//
    CONTROL_STATE state;
    CONTROL_STATE next_state;
    CONTROL_STATE conv_mode_state;
    logic running_conv;
    assign conv_mode_state = mode == MODE1 ? PE_CONV_MODE1 :
                             mode == MODE2 ? PE_CONV_MODE2 :
                             mode == MODE3 ? PE_CONV_MODE3 : MODE4;
    assign running_conv = (state == PE_CONV_MODE1) | (state == PE_CONV_MODE2) | (state == PE_CONV_MODE3) | (state == PE_CONV_MODE4);

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
        end
        else if(start) begin
            state <= WEIGHT_LOAD;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
        case(state)
            IDLE_C                      : next_state = start                    ? WEIGHT_LOAD;
            WEIGHT_LOAD                 : next_state = weight_load_finish       ? WEIGHT_OUTPUT : WEIGHT_LOAD;
            WEIGHT_OUTPUT               : next_state = weight_output_finish     ? (complete_count == 0  ? IFMAP_LOAD : WAIT_TO_RESTART_CONV_P4) : WEIGHT_OUTPUT;
            IFMAP_LOAD                  : next_state = ifmap_data_valid         ? conv_mode_state : IFMAP_LOAD;
            PE_CONV_MODE1               : next_state = conv_done                ? WEIGHT_OUTPUT   : PE_CONV_MODE1;
            PE_CONV_MODE2               : next_state = conv_done                ? (complete_count == 15 ? COMPLETE   : WEIGHT_OUTPUT)           : PE_CONV_MODE2;
            PE_CONV_MODE3               : next_state = conv_done                ? (complete_count == 3  ? COMPLETE   : WAIT_TO_RESTART_CONVP4)  : PE_CONV_MODE3;
            PE_CONV_MODE4               : next_state = conv_done                ? COMPLETE        : PE_CONV_MODE4;
            WAIT_TO_RESTART_CONV_P4     : next_state = WAIT_TO_RESTART_CONV_P3;
            WAIT_TO_RESTART_CONV_P3     : next_state = WAIT_TO_RESTART_CONV_P2;
            WAIT_TO_RESTART_CONV_P2     : next_state = WAIT_TO_RESTART_CONV_P1;
            WAIT_TO_RESTART_CONV_P1     : next_state = WAIT_TO_RESTART_CONV;
            WAIT_TO_RESTART_CONV        : next_state = ifmap_data_valid         ? conv_mode_state : WAIT_TO_RESTART_CONV;
            COMPLETE                    : next_state = IDLE_C;
        endcase
    end

    /// WEIGHT_LOAD
    // to weight buffer
    assign start_weight_buffer_load = state == WEIGHT_LOAD;

    /// WEIGHT_OUTPUT
    /// | conv_done | WEIGHT_LOAD | WEIGHT_LOAD
    ///             | change_mode | mode_changed
    ///             | wake up wb  | wb send first_data
    pulse change_mode_pulse(
        .clk(clk),ifmap_buffer_addr; and ifmap in ifmap_load
    pulse start_decompressor_pulse(
        .clk(clk),
        .rst_n(rst_n),
        .level(state == IFMAP_LOAD),
        .pulse(start_decompressor)
    );
    assign start_ifmap_buffer_load = start_decompressor;

    /// PE_CONV_MODEX
    // send start_conv to NOC , psum and PEs
    pulse start_conv_pulse(
        .clk(clk),
        .rst_n(rst_n),
        .level(running_conv),
        .pulse(start_conv)
    );

    /// COMPLETE
    assign layer_complete = state == COMPLETE;

    // op_stage to PE
    assign op_stage = state == WEIGHT_OUTPUT ? LOAD_FILTER :
                      running_conv           ? CONV        :
                                               IDLE;


    //######################################## MEMORY CONTROL ########################################///
    logic [`MEM_ADDR_SIZE-1:0] ifmap_buffer_addr;
    logic [`MEM_ADDR_SIZE-1:0] weight_buffer_addr;
    logic [`MEM_ADDR_SIZE-1:0] compressor_addr;

    logic [2:0] mem_req_mask;
    logic [2:0] mem_req_gnt;
    MEMORY_SOURCE mem_req_src;
    MEMORY_SOURCE mem_gnt_src;
    logic mem_fifo_data_valid;
    logic mem_fifo_full;
    logic mem_fifo_empty;

    assign mem_req_mask = {compressor_mem_req, weight_buffer_mem_req, decompressor_mem_req};

    round_robin_arbitor #(.WIDTH(3)) rra(
        .clk(clk),
        .rst_n(rst_n),
        .req(mem_req_mask),
        .gnt(mem_req_gnt)
    );

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            ifmap_buffer_addr <= ifmap_buffer_start_addr;
        end
        else if(mem_req_gnt[0]) begin
            ifmap_buffer_addr <= ifmap_buffer_addr + 1'b1;
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            weight_buffer_addr <= weight_buffer_start_addr;
        end
        else if(mem_req_gnt[0]) begin
            weight_buffer_addr <= weight_buffer_addr + 1'b1;
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            compressor_addr <= compressor_start_addr;
        end
        else if(mem_req_gnt[0]) begin
            compressor_addr <= compressor_addr + 1'b1;
        end
    end

    assign mem_req_src =    mem_req_gnt[0] ? IFMAP_BUFFER  : 
                            mem_req_gnt[1] ? WEIGHT_BUFFER :
                            mem_req_gnt[2] ? COMPRESSOR    : NONE;

    assign mem_addr =   mem_req_gnt[0] ? ifmap_buffer_addr  : 
                        mem_req_gnt[1] ? weight_buffer_addr :
                        mem_req_gnt[2] ? compressor_addr    : NONE;

    
    assign decompressor_mem_ack     = mem_req_gnt[0] & ~mem_fifo_empty;
    assign weight_buffer_mem_ack    = mem_req_gnt[1] & ~mem_fifo_empty;
    assign compressor_mem_ack       = mem_req_gnt[2];

    assign decompressor_mem_data = mem_data;
    assign weight_buffer_mem_data = mem_data;

    assign decompressor_mem_data_valid = mem_valid & mem_fifo_data_valid & (mem_gnt_src == IFMAP_BUFFER);
    assign weight_buffer_mem_data_valid = mem_valid & mem_fifo_data_valid & (mem_gnt_src == WEIGHT_BUFFER);

    assign mem_write_data = compressed_data;
    assign mem_write_valid = mem_gnt_req[2];

    fifo #(.DEPTH(16), WIDTH(32), .DTYPE(MEMORY_SOURCE)) mem_req_fifo(
        .clk(clk),
        .rst_n(rst_n & ~start),
        .wen(|mem_req_gnt[1:0]),
        .ren(mem_valid),
        .data_in(mem_req_src),
        .data_out(mem_gnt_src),
        .data_valid(mem_fifo_data_valid),
        .full(mem_fifo_full),
        .empty(mem_fifo_empty)
    );


    ////////////////////////////////////// DV SECTION //////////////////////////////////////
    `ifdef DV
    // Assertion 1
    ASSERT_NEVER #(.MSG("mem_req_fifo can not enqueue NONE as mem_req_src")) mem_req_fifo_chk(
        .clk(clk),
        .rst_n(rst_n),
        .en(|mem_req_mask[1:0]),
        .expr(mem_req_src == NONE | mem_req_src == COMPRESSOR)
    );

    // Assertion 2
    ASSERT_ONEHOT #(
            .MSG("mem_req_gnt can most be one hot"),
            .ALLOW_ZERO(1'b1),
            .WIDTH(4)
        ) psum_wen_chk(
            .clk(clk),
            .rst_n(rst_n),
            .en(1'b1),
            .expr(mem_req_gnt)
        );
    `endif

endmodule