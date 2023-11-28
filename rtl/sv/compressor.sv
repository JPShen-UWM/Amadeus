module compressor(
    input                   clk,
    input                   rst_n,
    input  [15:0][7:0]      outmap_data,           // will start from the first valid data
    input                   start,
    input  [4:0]            outmap_data_valid_num, // from 0-16
    input                   mem_ack,               // will not compress new data if memack is not ready
    output [4:0]            valid_taken_num,       // the element which has been taken by compressor
    output [63:0]           compressed_data,       // // [63]=? [62:60]=***
    output                  mem_req                // mem_req will only be assert when compressed data is ready
);

logic                        nxt_mem_req;
logic [63:0]                 nxt_compressed_data;
COMPRESS_UNIT [5:1]          compress_group;
COMPRESS_UNIT [5:1]          nxt_compress_group;

always_ff @(posedge clk) begin
    if(!rst_n) begin
       mem_req          <= 'b0; 
       compressed_data  <= 'b0;
       compress_group   <= 'b0;
    end else begin 
       mem_req          <= nxt_mem_req; 
       compressed_data  <= nxt_compressed_data;
       compress_group   <= nxt_compress_group;
    end
end

logic [15:0]                 zero;
logic [15:0][4:0]            zero_num; //0-15:
logic [2:0]                  group; // group over 5 is invalid
logic [15:0][4:0]            valid_taken_count;
logic [15:0][4:0]            min_vld;
logic [15:0]                 outmap_data_valid;
logic [5:1][15:0]            group_zero_update;
logic [5:1]                  group_zero_update_OR;
logic [5:1][15:0][3:0]       group_zero_update_value;
logic [5:1][15:0]            group_value_update;
logic [5:1]                  group_value_update_OR;
logic [5:1][15:0][7:0]       group_value_update_value;
logic [3:0]                  last_cycle_info; // [3]=? [2:0]=***
logic [5:1]                  AND_result;
logic [5:1]                  XOR_result;
logic [5:1]                  OR_result;
logic [5:1][3:0]             update_group_num;

genvar i,j;
generate
    assign zero[0] = ~(|outmap_data[0]);
    for(i=1;i<16;i++) begin
       assign zero[i] = ~(|outmap_data[i]);
    end

    // sent compressed packet, start brand new
    assign last_cycle_info = (mem_req && mem_ack) ? 4'd0 : compressed_data[63:60];

    assign zero_num[0] = last_cycle_info[3] ? zero[i] : ((compress_group[last_cycle_info[2:0]].zero == 15)? 'b0 : compress_group[last_cycle_info[2:0]].zero + zero[0]);
    for(i=1;i<16;i++) begin
       assign zero_num[i] = ((zero_num[i-1]==15)||(!zero[i])) ? 'b0: zero_num[i-1] + zero[i];
    end

    assign group[0] = ((|zero_num[0])||(last_cycle_info[2:0]==3'b111)) ? last_cycle_info[2:0] : last_cycle_info[2:0] + 1;
    for(i=1;i<16;i++) begin
       assign group[i] = ((|zero_num[0])||(group[i-1]==3'b111)) ? group[i-1] : group[i-1] + 1;
    end  

    assign min_vld[0] = 5'd1;
    assign outmap_data_valid[0] = min_vld[0] <= outmap_data_valid_num;
    for(i=1;i<16;i++) begin
       assign min_vld[i] = min_vld[i-1] + 1;
       assign outmap_data_valid[i] = min_vld[i] <= outmap_data_valid_num;
    end      

    assign valid_taken_count[0] = (group[0] < 6) && (outmap_data_valid[0]);
    for(i=0;i<16;i++) begin
       assign valid_taken_count[i] = valid_taken_count[i-1] + ((group[i] < 6) && (outmap_data_valid[i]));
    end  
    assign valid_taken_num = valid_taken_count[15];

    for(i=1;i<6;i++) begin
       for(j=0;j<16;j++) begin
          assign group_zero_update[i][j]  = (group[j]==i) && outmap_data_valid[j] && (|zero_num[j]);
          assign group_value_update[i][j] = (group[j]==i) && outmap_data_valid[j] && (~(|zero_num[j]));
       end
    end  
    
    for(i=1;i<6;i++) begin
       assign group_zero_update_value[i][0]  = group_zero_update[i][0]  ? zero_num[0] : 4'd0;
       assign group_value_update_value[i][0] = group_value_update[i][0] ? outmap_data[0] : 8'd0;
       for(j=1;j<16;j++) begin // the correct zero # and value to update is always at group_zero_update_value[i][15]
          assign group_zero_update_value[i][j]  = group_zero_update[i][j]  ? zero_num[j] : group_zero_update_value[i][j-1];
          assign group_value_update_value[i][j] = group_value_update[i][j] ? outmap_data[j] : group_value_update_value[i][j-1];
       end
    end

    for(i=1;i<6;i++) begin
      assign nxt_compress_group[i].zero = |group_zero_update[i]  ? group_zero_update_value[i][15]  : compress_group[i].zero;
      assign nxt_compress_group[i].val  = |group_value_update[i] ? group_value_update_value[i][15] : compress_group[i].val;
    end

    for(i=0;i<5;i++) begin
      assign nxt_compressed_data[12*i+3:12*i]    = nxt_compress_group[i+1].zero;
      assign nxt_compressed_data[12*i+11:12*i+4] = nxt_compress_group[i+1].val;
    end

    for(i=1;i<6;i++) begin
      assign group_zero_update_OR[i]  = |group_zero_update[i];
      assign group_value_update_OR[i] = |group_value_update[i];
      assign AND_result[i] = group_zero_update_OR[i] & group_value_update_OR[i];
      assign XOR_result[i] = group_zero_update_OR[i] ^ group_value_update_OR[i];
      assign OR_result[i]  = group_zero_update_OR[i] | group_value_update_OR[i];
    end
    
    // Total updated group num will appear at the update_group_num[5]
    assign update_group_num[1] = OR_result[1];
    for(i=2;i<6;i++) begin
       assign update_group_num[i] = update_group_num[i-1] + OR_result[i];
    end


    assign nxt_compressed_data[63] = (mem_req & (!mem_ack)) ? compressed_data[63] : 
                                                            (|AND_result ? (&AND_result ? 1'b1 : (|XOR_result ? 1'b0 : 1'b1)) : 1'b0);
    assign nxt_compressed_data[62:60] = (mem_req & (!mem_ack)) ? compressed_data[62:60] : update_group_num[5];

    assign nxt_mem_req = (mem_req & (!mem_ack)) ? mem_req : (&AND_result || (!(&AND_result) && (|OR_result) && (outmap_data_valid_num<16)));

endgenerate



endmodule