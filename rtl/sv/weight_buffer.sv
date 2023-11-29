module weight_buffer(
    input            clk,
    input            rst_n,
    input OP_MODE mode_in,           // mode selection
    input mem_data_valid,
    input [63:0] weight_data,//8bytes one cycle frome memory
    input free_weight_buffer,
    output mem_req,//need data or not
    output ready_to_output,//buffer is full ready to output
    output PE_IN_PACKET       weight_buffer_out_packet
)
    localparam buffer_maxrow_idx=`L1_FILTER_SIZE*`MULT_OUT_SIZE;//44*11*8bits
    logic [5:0] row_idx;        
    logic  cycle_count;   
    OP_MODE cur_mode;
    always_ff @(posedge clk) begin
        if(rst_n) cur_mode <= MODE1;
        else if(change_mode) cur_mode <= mode_in;
    end 
//input counter calculation,
    always_ff@(posedge clk) begin
        if(rst_n||free_weight_buffer)begin
        row_idx<=0;
        cycle_count<=0;
        end
        else if(mem_data_valid&&mem_req) begin
            case (cur_mode)
            MODE1,MODE2: begin // mode1 ? mode2
                    cycle_count <= cycle_count+1;
                    if (cycle_count == 1) begin
                        row_idx<=row_idx+1;
                        cycle_count <= 0;
                    end
                end
            MODE3,MODE4: begin 
                    row_idx<= row_idx+1;
                end
            endcase
        end
    end
////mem_req set and ready to output set
    always_comb begin
        case (cur_mode)
                MODE1,MODE2: begin                 
                    if (row_idx==43) begin
                        mem_req=0;
                        ready_to_output=1;
                    end
                    else begin
                        mem_req=1;
                        ready_to_output=0;
                    end
                end
                MODE3: begin 
                    if (row_idx==19) begin
                        mem_req=0;
                        ready_to_output=1;
                    end
                    else begin
                        mem_req=1;
                        ready_to_output=0;
                    end
                end
                MODE4: begin 
                    if (row_idx==11) begin
                        mem_req=0;
                        ready_to_output=1;
                    end
                    else begin
                        mem_req=1;
                        ready_to_output=0;
                    end
                end
            endcase
    end

///buffer register file 
    localparam buffer_row_length=`WDATA_SIZE*`L1_FILTER_SIZE
    logic [43:0][87:0] filter_ram;//4*11*11*8 multlayer*row*colunme*8bits data
// load data from memeory 
    always_ff@(posedge clk) begin
        if(rst_n||free_weight_buffer)begin
            filter_ram<='0;
        end
        else if(mem_data_valid&&mem_req) begin
        case (cur_mode)
            MODE1,MODE2: begin 
             if (cycle_count == 0) begin
                    filter_ram[row_idx][87:24] <= weight_data;
                end else begin
                    filter_ram[row_idx][23:0] <= weight_data[63:40];
                end

            end
            MODE3,MODE4: begin 
                filter_ram[row_idx] <= weight_data;
            end
        endcase
        end
    end

endmodule