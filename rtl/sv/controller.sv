module controller(
    // from TB
    input clk,
    input rst_n,
    input start,
    input layer_type_in,
    input [`MEM_ADDR_SIZE-1:0] start_address_in,
    // from pe
    input [5:0][6:0] pe_conv_done, // directly connected from PEs
    // from decompressor
    input decompressor_mem_req,
    // from compressor
    input compressor_mem_req,
    // from weight buffer
    input weight_buffer_mem_req,
    input weight_output_finish,
    input weight_load_finish,
    // from ifmap buffer
    input ifmap_data_valid,  // ifmap_data complete load for batch 1, ready for first convolution
    // need ifmap_data_change is becuase in layer1, output memory batch need to be changed before start conv
    input ifmap_data_change, // ifmap_data ready for doing next convolution
    // from memory
    input [MEM_BANDWIDTH*8-1:0:0] mem_data,
    input mem_valid,

    // to noc, psum, pe
    output mode,
    output start_conv,
    // to decompressor
    output start_decompressor,
    output decompressor_mem_ack,
    output [MEM_BANDWIDTH*8-1:0] decompressor_mem_data,
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
    output [MEM_BANDWIDTH*8-1:0:0] weight_buffer_mem_data,
    output weight_buffer_mem_data,
    // to compressor
    output compressor_mem_ack,
    output [MEM_BANDWIDTH*8-1:0:0] compressor_mem_data,
    output compressor_mem_data_valid,
    // to TB
    output [`MEM_ADDR_SIZE-1:0] mem_addr,
    output layer_complete
);
    CONTROL_STATE state;
    CONTROL_STATE next_state;
    // logic for layer type
    LAYER_TYPE layer_type;
    logic [`MEM_ADDR_SIZE-1:0] start_address;
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
        .clk(clk),
        .rst_n(rst_n),
        .level(state == WEIGHT_OUTPUT),
        .pulse(change_mode)
    );
    assign start_weight_buffer_output = state == WEIGHT_OUTPUT;

    /// IFMAP_LOAD
    // start decompressor and ifmap in ifmap_load
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

   fifo #(.DEPTH(16), WIDTH(32), .DTYPE(MEM_REQ_PACKET)) mem_req_fifo(
        .clk(clk),
        .rst_n(rst_n & ~start),
        .wen(decompressor_mem_req | compressor_mem_req | weight_buffer_mem_req),
        .ren(mem_valid),
        .data_in()
   );

   

endmodule