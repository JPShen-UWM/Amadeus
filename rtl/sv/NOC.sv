module NOC(
    input                           clk,
    input                           rst_n,
    input                           start,
    input                           start_conv, // controller sen start_conv to NOC and PEs, in controller, if start_conv, ifmap_data_in has to be valid
    input LAYER_TYPE                layer_type_in,
    input OP_MODE                   mode_in,          // mode selection
    input                           pe_complete,
    input [34:0][256*8-1:0]         ifmap_data_in,
    input                           ifmap_data_valid_in,
    input [5:0][6:0]                pe_full,
    //
    output                          pe_calculation_complete, // to controller
    output                          free_ifmap_buffer,
    output DIAGONAL_BUS_PACKET      diagonal_bus_packet
);

    /// |......|''''''|......|''''''|......|''''''|......|''''''|
    ///      free               start_conv   ifmap_data
    LAYER_TYPE layer_type;
    logic free_change;
    logic enable;
    OP_MODE mode;
    logic [34:0][256*8-1:0] ifmap_data;
    logic ifmap_data_valid;
    localparam MODE1_LINE_COUNTER = 30;
    localparam MODE2_LINE_COUNTER = 29;
    localparam MODE3_LINE_COUNTER = 11;
    localparam MODE4_LINE_COUNTER = ;
    localparam LAYER1_ELEMENT_COUNTER = 56;
    localparam LAYER2_ELEMENT_COUNTER = 7;
    localparam LAYER2_ELEMENT_COUNTER = 3;
    logic [5:0] ifmap_data_line_read_ptr_counter;
    logic [5:0] ifmap_data_element_read_ptr_counter;
    logic [5:0] ifmap_data_line_read_ptr;
    logic [5:0] ifmap_data_element_read_ptr;


    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            layer_type <= NULL;
        end
        else if(start) begin
            layer_type <= layer_type_in;
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            mode <= MODE1;
        end
        else if(start_conv) begin
            mode <= mode_in;
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
            enable <= 1'b0;
        end
        else if(free_change) begin
            enable <= 1'b0;
        end
        else(start_conv)begin
            enable <= 1'b1;
        end
    end

    /// zero pad the ifmap data ///
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
            ifmap_data <= '0;
            ifmap_data_valid <= 0;
        end
        else if(start_conv) begin
            // update data
            if(mode == MODE1 || mode == MODE2) begin
                ifmap_data <= ifmap_data_in;
            end
            else if(mode == MODE3) begin
                for(integer i = 0; i < `MEM_BATCH_SIZE; i=i+1) begin
                    if(i == 0) begin
                        ifmap_data[i]   <= '0;
                    end
                    else begin
                        ifmap_data[i+1] <= {ifmap_data_in[i][254*8-1:0]:{16{1'b0}}};
                    end
                end
            end
            else if(mode == MODE4) begin
                for(integer i = 0; i < `MEM_BATCH_SIZE; i=i+1) begin
                    if(i == 0) begin
                        ifmap_data[i]   <= '0;
                    end
                    else begin
                        ifmap_data[i+1] <= {ifmap_data_in[i][255*8-1:0]:{8{1'b0}}};
                    end
                end
            end
            // update valid
            ifmap_data_valid <= 1'b1;
        end
        else if(free_change) begin
            ifmap_data <= '0;
            ifmap_data_valid <= 1'b0;
        end
    end

    /// ifmap_read_ptr update logic //
    assign 

    /// ifmap_buffer free control logic ///
    // when there is one pe_complete from PEs, COUNT++
    localparam LAYER1_COUNT = 16;
    localparam LAYER2_COUNT = 4;
    localparam LAYER3_COUNT = 1;

    // pe_complete count from PEs
    logic [4:0] complete_count;
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
            complete_count <= 0;
        end
        else if(pe_complete) begin
            complete_count <= complete_count + 1'b1;
        end
    end

    // free one full memory batch when receving the pe_complete signal from PE array
    // if in layer1, you need to receive 2 pe_complete signal
    assign free_change = ((layer_type == LAYER1 && complete_count[0] == 1) || (layer_type == LAYER2 && complete_count == LAYER2_COUNT-1) || layer_type == LAYER3) && pe_complete;
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
            free_ifmap_buffer <= 0;
        end
        else if(free_change) begin
            free_ifmap_buffer <= 1;
        end
        else begin
            free_ifmap_buffer <= 0;
        end
    end

    /// diagnal bus configuration
    /* layer 1
    diagonal bus    d0      0	4	8	12	16	20	24
                    d1      1	5	9	13	17	21	25
                    d2      2	6	10	14	18	22	26
                    d3      3	7	11	15	19	23	27
                    d4      4	8	12	16	20	24	28
                    d5      5	9	13	17	21	25	29
                                d6  d7  d8  d9  d10 d11
    */
    logic [28:0][11:0] layer1_diagbus_pattern;
    assign layer1_diagbus_pattern[0]  = 12'b000000000001;
    assign layer1_diagbus_pattern[1]  = 12'b000000000010;
    assign layer1_diagbus_pattern[2]  = 12'b000000000100;
    assign layer1_diagbus_pattern[3]  = 12'b000000001000;
    assign layer1_diagbus_pattern[4]  = 12'b000000010010;
    assign layer1_diagbus_pattern[5]  = 12'b000000100100;
    assign layer1_diagbus_pattern[6]  = 12'b000000001000;
    assign layer1_diagbus_pattern[7]  = 12'b000000010000;
    assign layer1_diagbus_pattern[8]  = 12'b000000100100;
    assign layer1_diagbus_pattern[9]  = 12'b000001001000;
    assign layer1_diagbus_pattern[10] = 12'b000000010000;
    assign layer1_diagbus_pattern[11] = 12'b000000100000;
    assign layer1_diagbus_pattern[12] = 12'b000001001000;
    assign layer1_diagbus_pattern[13] = 12'b000010010000;
    assign layer1_diagbus_pattern[14] = 12'b000000100000;
    assign layer1_diagbus_pattern[15] = 12'b000001000000;
    assign layer1_diagbus_pattern[16] = 12'b000010010000;
    assign layer1_diagbus_pattern[17] = 12'b000100100000;
    assign layer1_diagbus_pattern[18] = 12'b000001000000;
    assign layer1_diagbus_pattern[19] = 12'b000010000000;
    assign layer1_diagbus_pattern[20] = 12'b000100100000;
    assign layer1_diagbus_pattern[21] = 12'b001001000000;
    assign layer1_diagbus_pattern[22] = 12'b000010000000;
    assign layer1_diagbus_pattern[23] = 12'b000100000000;
    assign layer1_diagbus_pattern[24] = 12'b001001000000;
    assign layer1_diagbus_pattern[25] = 12'b010010000000;
    assign layer1_diagbus_pattern[26] = 12'b000100000000;
    assign layer1_diagbus_pattern[27] = 12'b001000000000;
    assign layer1_diagbus_pattern[28] = 12'b010000000000;
    assign layer1_diagbus_pattern[29] = 12'b100000000000;

    // the full signal for input feature map in layer1
    logic [28:0] layer1_pe_full;
    // if current calculation is the 8th iteration for layer1, the 7th column of pe should be disable
    logic layer1_is_last_iteration;
    assign layer1_is_last_iteration = complete_count > 5;
    assign layer1_pe_full[0]  = pe_full[0][0];
    assign layer1_pe_full[1]  = pe_full[1][0];
    assign layer1_pe_full[2]  = pe_full[2][0];
    assign layer1_pe_full[3]  = pe_full[3][0];
    assign layer1_pe_full[4]  = pe_full[4][0] | pe_full[0][1];
    assign layer1_pe_full[5]  = (pe_full[5][0] & mode == MODE1) | pe_full[1][1];
    assign layer1_pe_full[6]  = pe_full[2][1];
    assign layer1_pe_full[7]  = pe_full[3][1];
    assign layer1_pe_full[8]  = pe_full[4][1] | pe_full[0][2];
    assign layer1_pe_full[9]  = (pe_full[5][1] & mode == MODE1) | pe_full[1][2];
    assign layer1_pe_full[10] = pe_full[2][1];
    assign layer1_pe_full[11] = pe_full[3][1];
    assign layer1_pe_full[12] = pe_full[4][1] | pe_full[0][2];
    assign layer1_pe_full[13] = (pe_full[5][1] & mode == MODE1) | pe_full[1][2];

    /* layer 2
    diagonal bus    d0      0	1	2	3	4	5	6
                    d1      1	2	3	4	5	6	7
                    d2      2	3	4	5	6	7	8
                    d3      3	4	5	6	7	8	9
                    d4      4	5	6	7	8	9	10
                    d5      x   x   x   x   x   x   x
                                d6  d7  d8  d9  d10 d11
    */
    logic [10:0][11:0] layer2_diagbus_pattern;
    assign layer2_diagbus_pattern[0]  = 12'b1;
    assign layer2_diagbus_pattern[1]  = 12'b10;
    assign layer2_diagbus_pattern[2]  = 12'b100;
    assign layer2_diagbus_pattern[3]  = 12'b1000;
    assign layer2_diagbus_pattern[4]  = 12'b10000;
    assign layer2_diagbus_pattern[5]  = 12'b100000;
    assign layer2_diagbus_pattern[6]  = 12'b1000000;
    assign layer2_diagbus_pattern[7]  = 12'b10000000;
    assign layer2_diagbus_pattern[8]  = 12'b100000000;
    assign layer2_diagbus_pattern[9]  = 12'b1000000000;
    assign layer2_diagbus_pattern[10] = 12'b10000000000;

    /* layer 3
    diagonal bus    d0      0	1	2	3	4	5	6
                    d1      1	2	3	4	5	6	7
                    d2      2	3	4	5	6	7	8
                    d3      7	8	9	10	11	12	x
                    d4      8	9	10	11	12	13	x
                    d5      9	10	11	12	13	14	x
                                d6  d7  d8  d9  d10 d11
    */
    logic [14:0][11:0] layer3_diagbus_pattern;
    assign layer3_diagbus_pattern[0]  = 12'b1;
    assign layer3_diagbus_pattern[1]  = 12'b10;
    assign layer3_diagbus_pattern[2]  = 12'b100;
    assign layer3_diagbus_pattern[3]  = 12'b1000;
    assign layer3_diagbus_pattern[4]  = 12'b10000;
    assign layer3_diagbus_pattern[5]  = 12'b100000;
    assign layer3_diagbus_pattern[6]  = 12'b1000000;
    assign layer3_diagbus_pattern[7]  = 12'b10001000;
    assign layer3_diagbus_pattern[8]  = 12'b100010000;
    assign layer3_diagbus_pattern[9]  = 12'b100000;
    assign layer3_diagbus_pattern[10] = 12'b1000000;
    assign layer3_diagbus_pattern[11] = 12'b10000000;
    assign layer3_diagbus_pattern[12] = 12'b100000000;
    assign layer3_diagbus_pattern[13] = 12'b1000000000;
    assign layer3_diagbus_pattern[14] = 12'b10000000000;


endmodule