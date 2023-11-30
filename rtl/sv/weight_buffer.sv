module weight_buffer(
    input            clk,
    input            rst_n,
    input OP_MODE mode_in,           // mode selection
    input mem_data_valid,
    input [63:0] weight_data,//8bytes one cycle frome memory
    //add start signal to tell WB output the filter
    input output_filter,
    //from controller
    input free_weight_buffer,
    //to memory
    output logic mem_req,//need data or not
    // to controller
    output logic ready_to_output,//buffer is full ready to output
    //to pe

    output PE_IN_PACKET packet_out[0:5]//line6
);
    // localparam buffer_maxrow_idx=`L1_FILTER_SIZE*`MULT_OUT_SIZE;//44*11*8bits
    logic mem_req_comb,ready_to_output_comb;
    logic [5:0] row_idx;        
    logic  cycle_count;    
    OP_MODE cur_mode;
    always_ff @(posedge clk) begin
        if(rst_n) cur_mode <= MODE1;
        else  cur_mode <= mode_in;
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
                    if (row_idx>43) begin
                        mem_req_comb=0;
                        ready_to_output_comb=1;
                    end
                    else begin
                        mem_req_comb=1;
                        ready_to_output_comb=0;
                    end
                end
                MODE3: begin 
                    if (row_idx>19) begin
                        mem_req_comb=0;
                        ready_to_output_comb=1;
                    end
                    else begin
                        mem_req_comb=1;
                        ready_to_output_comb=0;
                    end
                end
                MODE4: begin 
                    if (row_idx>11) begin
                        mem_req_comb=0;
                        ready_to_output_comb=1;
                    end
                    else begin
                        mem_req_comb=1;
                        ready_to_output_comb=0;
                    end
                end
            endcase
    end
     always_ff@(posedge clk) begin
        if(rst_n||free_weight_buffer)begin
            mem_req<=1;
            ready_to_output<=0;
        end else begin
            mem_req<=mem_req_comb;
            ready_to_output<=ready_to_output_comb;
        end
     end
///buffer register file 
    localparam buffer_row_length=`WDATA_SIZE*`L1_FILTER_SIZE;
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
                    filter_ram[row_idx][63:0] <= weight_data;
                end else begin
                    filter_ram[row_idx][87:64] <= weight_data[23:0];
                end

            end
            MODE3,MODE4: begin 
                filter_ram[row_idx][63:0] <= weight_data;
            end
        endcase
        end
    end
// ////////////////////////output logic/////////////////////////////////////////////////////
//output counter calculation,
logic output_finsih_comb,output_finsih;
logic [1:0] output_cycle_counter;
logic [1:0] output_layer_idx;
localparam [5:0] offset [3:0]={33,22,11,0};
localparam [5:0] offset3 [3:0]={15,10,5,0};
localparam [5:0] offset4 [3:0]={9,6,3,0};
localparam [5:0] idx4 [5:0]={2,1,0,2,1,0};
    always_ff@(posedge clk) begin
        if(rst_n||!ready_to_output||!output_filter)begin
            output_layer_idx<=0;
            output_cycle_counter<=0;
        end
        else if(!output_finsih)begin
           if(output_cycle_counter==2) begin
            output_cycle_counter<=0;
            output_layer_idx<=output_layer_idx+1;
           end
           else output_cycle_counter<=output_cycle_counter+1;
        end
    end
assign output_finsih_comb=(output_layer_idx<3)? 0:(output_cycle_counter==2)? 1:0;
    always_ff@(posedge clk) begin
        if(rst_n||!ready_to_output||!output_filter)begin
            output_finsih<=0;
        end
        else begin
            output_finsih<=output_finsih_comb;
        end
    end
 always_ff@(posedge clk) begin
        if(rst_n||(!ready_to_output)||!(output_filter))begin
            for (int i = 0; i < 6; i++) begin
                packet_out[i]<='{default:0};
            end
        end
        else if(!output_finsih)  begin
        case (cur_mode)
            MODE1: begin 
                if(output_cycle_counter==0)begin
                    for (logic[2:0] i = 0; i < 6; i++) begin
                        packet_out[i].data<={8'b0, filter_ram[i+offset[output_layer_idx]][87:64]};//10:8
                        packet_out[i].valid<=1;
                        packet_out[i].packet_idx<={output_layer_idx,i};
                    end
                end
                if(output_cycle_counter==1)begin
                    for (logic[2:0] i = 0; i < 6; i++) begin
                        packet_out[i].data<=filter_ram[i+offset[output_layer_idx]][63:32];//7:4
                        packet_out[i].valid<=1;
                        packet_out[i].packet_idx<={output_layer_idx,i};
                    end
                end
                if(output_cycle_counter==2)begin
                    for (logic[2:0] i = 0; i < 6; i++) begin
                        packet_out[i].data<=filter_ram[i+offset[output_layer_idx]][31:0];//3:0
                        packet_out[i].valid<=1;
                        packet_out[i].packet_idx<={output_layer_idx,i};
                    end
                end
            end
            MODE2: begin 
                if(output_cycle_counter==0)begin
                    for (logic[2:0] i = 0; i < 5; i++) begin
                        packet_out[i].data<={8'b0, filter_ram[6+i+offset[output_layer_idx]][87:64]};
                        packet_out[i].valid<=1;
                        packet_out[i].packet_idx<={output_layer_idx,i};
                    end
                end
                if(output_cycle_counter==1)begin
                    for (logic[2:0] i = 0; i < 5; i++) begin
                        packet_out[i].data<=filter_ram[6+i+offset[output_layer_idx]][63:32];
                        packet_out[i].valid<=1;
                        packet_out[i].packet_idx<={output_layer_idx,i};
                    end
                end
                if(output_cycle_counter==2)begin
                    for (logic[2:0] i = 0; i < 5; i++) begin
                        packet_out[i].data<=filter_ram[6+i+offset[output_layer_idx]][31:0];
                        packet_out[i].valid<=1;
                        packet_out[i].packet_idx<={output_layer_idx,i};
                    end
                end 
                        packet_out[5].data<='0;
                        packet_out[5].valid<=0;
                        packet_out[5].packet_idx<={output_layer_idx,3'b101};            
            end
            MODE3: begin 
                if(output_cycle_counter==0)begin
                    for (logic[2:0] i = 0; i < 5; i++) begin
                        packet_out[i].data<={8'b0, filter_ram[i+offset3[output_layer_idx]][87:64]};
                        packet_out[i].valid<=1;
                        packet_out[i].packet_idx<={output_layer_idx,i};
                    end
                end
                if(output_cycle_counter==1)begin
                    for (logic[2:0] i = 0; i < 5; i++) begin
                        packet_out[i].data<=filter_ram[i+offset3[output_layer_idx]][63:32];
                        packet_out[i].valid<=1;
                        packet_out[i].packet_idx<={output_layer_idx,i};
                    end
                end
                if(output_cycle_counter==2)begin
                    for (logic[2:0] i = 0; i < 5; i++) begin
                        packet_out[i].data<=filter_ram[i+offset3[output_layer_idx]][31:0];
                        packet_out[i].valid<=1;
                        packet_out[i].packet_idx<={output_layer_idx,i};
                    end
                end 
                        packet_out[5].data<='0;
                        packet_out[5].valid<=0;
                        packet_out[5].packet_idx<={output_layer_idx,3'b101};               
            end
            MODE4: begin 
                if(output_cycle_counter==0)begin
                    for (logic[2:0] i = 0; i < 6; i++) begin
                        packet_out[i].data<={8'b0, filter_ram[idx4[i]+offset4[output_layer_idx]][87:64]};
                        packet_out[i].valid<=1;
                        packet_out[i].packet_idx<={output_layer_idx,i};
                    end
                end
                if(output_cycle_counter==1)begin
                    for (logic[2:0] i = 0; i < 6; i++) begin
                        packet_out[i].data<=filter_ram[idx4[i]+offset4[output_layer_idx]][63:32];
                        packet_out[i].valid<=1;
                        packet_out[i].packet_idx<={output_layer_idx,i};
                    end
                end
                if(output_cycle_counter==2)begin
                    for (logic[2:0] i = 0; i < 6; i++) begin
                        packet_out[i].data<=filter_ram[idx4[i]+offset4[output_layer_idx]][31:0];
                        packet_out[i].valid<=1;
                        packet_out[i].packet_idx<={output_layer_idx,i};
                    end
                end             
            end
        endcase
        end
    end

endmodule