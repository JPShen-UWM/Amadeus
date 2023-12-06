module compressor(
    input                   clk,
    input                   rst_n,
    input  [15:0][7:0]      outmap_data,           // will start from the first valid data
    input                   start,
    input  [4:0]            outmap_data_valid_num, // from 0-16
    input                   mem_ack,               // will not compress new data if memack is not ready
    output [4:0]            valid_taken_num,       // the element which has been taken by compressor
    output logic [63:0]     compressed_data,       // // [63]=? [62:60]=***
    output logic            mem_req                // mem_req will only be assert when compressed data is ready
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
logic [15:0][2:0]            group; // group over 5 is invalid
logic [15:0][4:0]            valid_taken_count;
logic [15:0][4:0]            min_vld;
logic [15:0]                 outmap_data_valid;
logic [5:1][15:0]            group_zero_update;
logic [5:1]                  group_zero_update_OR;
logic [5:1][15:0][3:0]       group_zero_update_value;
logic [5:1][15:0]            group_value_update;
logic [5:1]                  group_value_update_OR;
logic [5:1][15:0][7:0]       group_value_update_value;
logic [5:1]                  AND_result;
logic [5:1]                  XOR_result;
logic [5:1]                  OR_result;
logic [15:0][2:0]            update_group_num;

logic                        mem_req_accepted;


assign mem_req_accepted = (mem_req && mem_ack);


genvar i,j;
generate
    assign zero[0] = ~(|outmap_data[0]);
    for(i=1;i<16;i++) begin
       assign zero[i] = ~(|outmap_data[i]);
    end

    /*
    zero_num[0]
    1. if mem req accepeted, new compression, first zero_num is either 1 or 0 depend on first outmap_data input
    2. or if last cycle end with compressing vld data, fist zero_num is the same as above 
      (if outmap_data[0]=0, it is the first 0 in a new group, zero_num[0]=1. if outmap_data[0]!=0, it skips the 4-bit zero to the vld data, zero_num[0]=0)
    3. if not the above two cases, then last cycle compression end with zero, ?=0. 
            if compress_group[last_cycle_update_group].zero is full, no matter outmap_data input is 0 or value, zero_num[0]=0.
            if compress_group[last_cycle_update_group].zero is not full, but outmap_data input is non-0 value, zero_num[0]=0.
            else compress_group[last_cycle_update_group].zero is not full, and outmap_data input is 0, we increment compress_group[last_cycle_update_group].zero

    zero_num[i]
    1. if zero_num[i-1]==15 and outmap_data[i]==0, record this 0 as a value, thus zero_num[i]=0
    2. if outmap_data[i]!=0, zero_num[i]=0
    3. else keep incrementing on zero_num[i-1]
    */
    assign zero_num[0] = (start || mem_req_accepted || compressed_data[63]) ? zero[0] : ((compress_group[compressed_data[62:60]]==15) || (!zero[0]) ? 'b0 : compress_group[compressed_data[62:60]].zero + 1);
    for(i=1;i<16;i++) begin
       assign zero_num[i] = ((zero_num[i-1]==15)||(!zero[i])) ? 'b0: zero_num[i-1] + zero[i];
    end
    
    /*
      group[0]
      1. if mem req accepted, reset group to 1. Might need to change if we want to add in Start control signal.
      2. if last cycle end with compressing value, increment last cycle group
      3. else no change 

      group[i]
      1. if zero_num[i]!=0, thus handling zero#, group stay the same
      2. or if last group is 7(which is invalid), group stay the same, we will only use group 1-5
      3. else handling non-0 value, increment group[i-1] 
    */
    assign group[0] = (start || mem_req_accepted) ? 3'd1 : (compressed_data[63] ? (compressed_data[62:60] + 1) : compressed_data[62:60]);
    for(i=1;i<16;i++) begin
       //assign group[i] = ((|zero_num[i])||(group[i-1]==3'b111)) ? group[i-1] : group[i-1] + 1;
       assign group[i] = (|zero_num[i-1]) ? group[i-1] : group[i-1] + 1;
    end  

    // Check if each outmap_data is valid
    assign min_vld[0] = 5'd1;
    assign outmap_data_valid[0] = min_vld[0] <= outmap_data_valid_num;
    for(i=1;i<16;i++) begin
       assign min_vld[i] = min_vld[i-1] + 1;
       assign outmap_data_valid[i] = min_vld[i] <= outmap_data_valid_num;
    end      


    /* Obtain valid taken num by checking:
      1. if each outmap_data input's group is in valid range 1-5 (if compress_group can take this outmap_data)
      2. if each outmap_data is valid
    */
    assign valid_taken_count[0] = (group[0] < 6) && (outmap_data_valid[0]);
    for(i=1;i<16;i++) begin
       assign valid_taken_count[i] = valid_taken_count[i-1] + ((group[i] < 6) && (outmap_data_valid[i]));
    end  
    assign valid_taken_num = valid_taken_count[15];

    /*
      Update group_zero_update: 1.group in valid range 2.outmap_data valid 3. this outmap_data should be updated as a zero
      Update group_value_update: 1.group in valid range 2.outmap_data valid 3. this outmap_data should be updated as a value
      We will obtain total of ten [15:0], use them to determine: which are the correct zeros / value to udpate for each group (mask)
    */
    for(i=1;i<6;i++) begin
       for(j=0;j<16;j++) begin
          assign group_zero_update[i][j]  = (group[j]==i) && outmap_data_valid[j] && (|zero_num[j]);
          assign group_value_update[i][j] = (group[j]==i) && outmap_data_valid[j] && (~(|zero_num[j]));
       end
    end  
    
    /*
    group_zero_update_value: will be searched and accumulated from top to bottom with the group_zero_update mask, correct zero# will appear at group_zero_update_value[i][15]
    group_value_update_value: will be searched and accumulated from top to bottom with the group_value_update mask, correct value will appear at group_value_update_value[i][15]
    */
    for(i=1;i<6;i++) begin
       assign group_zero_update_value[i][0]  = group_zero_update[i][0]  ? zero_num[0] : 4'd0;
       assign group_value_update_value[i][0] = group_value_update[i][0] ? outmap_data[0] : 8'd0;
       for(j=1;j<16;j++) begin
          assign group_zero_update_value[i][j]  = group_zero_update[i][j]  ? zero_num[j] : group_zero_update_value[i][j-1];
          assign group_value_update_value[i][j] = group_value_update[i][j] ? outmap_data[j] : group_value_update_value[i][j-1];
       end
    end

    // Update nxt_compress_group zero and val

    for(i=1;i<6;i++) begin
      assign nxt_compress_group[i].zero = |group_zero_update[i]  ? group_zero_update_value[i][15]  : (start ? 4'd0 : compress_group[i].zero);
      assign nxt_compress_group[i].val  = |group_value_update[i] ? group_value_update_value[i][15] : (start ? 8'd0 : compress_group[i].val);
    end

    // Update nxt_compressed_data
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
    
    // Total updated group num will appear at the update_group_num[15]
    /*
    assign update_group_num[1] = start ? OR_result[1] : ;
    for(i=2;i<6;i++) begin
       assign update_group_num[i] = update_group_num[i-1] + OR_result[i];
    end
    */
    assign update_group_num[0] = group[0];
    for(i=1;i<16;i++) begin
       assign update_group_num[i] = (group[i] < 6) && (outmap_data_valid[i]) ? group[i-1] : group[i];
    end

endgenerate

    // Determine if we end compression with zero# or val
    assign nxt_compressed_data[63] =(mem_req & (!mem_ack)) ? compressed_data[63] :  //TODO: Not correctly update when end with valid data
                                                            (|AND_result ? (&AND_result[5] ? 1'b1 : (|XOR_result ? 1'b0 : 1'b1)) : 1'b0);
    // Determine the group that we end compression with
    assign nxt_compressed_data[62:60] = (mem_req & (!mem_ack)) ? compressed_data[62:60] : ((outmap_data_valid_num==0) ? 'b0 : (&AND_result[5] ? 3'b111 : update_group_num[15]));
    
    // Determine if we want to send mem req: 1. no space in compress_group 2. some space in compress_group but outmap_valid_data<16 (no more outmap_data input for this compression)
    assign nxt_mem_req = (mem_req & (!mem_ack)) ? mem_req : (&AND_result[5] || (!(&AND_result[5]) && (|OR_result) && (outmap_data_valid_num<16)));

endmodule
