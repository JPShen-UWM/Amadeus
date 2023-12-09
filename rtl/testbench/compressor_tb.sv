`timescale 1ns / 1ps

module compressor_tb;


    reg clk;
    reg rst_n;
    reg [15:0][7:0] outmap_data;
    reg start;
    reg [4:0] outmap_data_valid_num;
    reg mem_ack;
    wire [4:0] valid_taken_num;
    wire [63:0] compressed_data;
    wire mem_req;

    logic             start_reg;
    logic [15:0][7:0] outmap_data_reg;
    logic [4:0]       outmap_data_valid_num_reg;
    logic             mem_ack_reg;
    

    compressor uut (
        .clk(clk),
        .rst_n(rst_n),
        .outmap_data(outmap_data_reg),
        .start(start_reg),
        .outmap_data_valid_num(outmap_data_valid_num_reg),
        .mem_ack(mem_ack_reg),
        .valid_taken_num(valid_taken_num),
        .compressed_data(compressed_data),
        .mem_req(mem_req)
    );

    always_ff @(posedge clk) begin
       if(!rst_n) begin
          start_reg                 <= 'b0;
          outmap_data_reg           <= 'b0;
          outmap_data_valid_num_reg <= 'b0;
          mem_ack_reg               <= 'b0;
       end else begin 
          start_reg                 <= start;
          outmap_data_reg           <= outmap_data;
          outmap_data_valid_num_reg <= outmap_data_valid_num;
          mem_ack_reg               <= mem_ack;
       end
    end


    always #10 clk = ~clk; 


    initial begin

        clk = 1'b0;
        rst_n = 1'b1;
        outmap_data = 'b0;
        start = 1'b0;
        outmap_data_valid_num = 'b0;
        mem_ack = 1'b0;

        // ????
        //#100;
        // Test group 1: 16*5 zeros
        @(negedge clk)
        rst_n = 1'b0;
        @(negedge clk)
        rst_n = 1'b1;
        start = 1'b1;
        for(int i=0;i<16;i++) begin
           outmap_data[i] = 8'd0;
        end
        outmap_data_valid_num = 5'd16;
        mem_ack = 1'b0;
        
        repeat(3) begin
           @(negedge clk)
           start = 1'b0;
           for(int i=0;i<16;i++) begin
              outmap_data[i] = 8'd0;
           end
           outmap_data_valid_num = 5'd16;
           mem_ack = 1'b0;
        end

        @(negedge clk)
        start = 1'b0;
        for(int i=0;i<16;i++) begin
           outmap_data[i] = 8'd0;
        end
        outmap_data_valid_num = 5'd16;
        mem_ack = 1'b0;

        // Test group 2: 16*5 zeros, mem req accepted 2 cycle after it sent
        @(negedge clk)
        start = 1'b1;
        for(int i=0;i<16;i++) begin
           outmap_data[i] = 8'd0;
        end
        outmap_data_valid_num = 5'd16;
        mem_ack = 1'b1;

        repeat(3) begin
           @(negedge clk)
           start = 1'b0;
           for(int i=0;i<16;i++) begin
              outmap_data[i] = 8'd0;
           end
           outmap_data_valid_num = 5'd16;
           mem_ack = 1'b0;
        end

        @(negedge clk)
        start = 1'b0;
        for(int i=0;i<16;i++) begin
           outmap_data[i] = 8'd0;
        end
        outmap_data_valid_num = 5'd16;
        mem_ack = 1'b0;
    
        @(negedge clk)
        mem_ack = 1'b0;
        outmap_data_valid_num = 5'd0;
        for(int i=0;i<16;i++) begin
           outmap_data[i] = 8'd5;
        end
        @(negedge clk)
        mem_ack = 1'b0;

        @(negedge clk)
        mem_ack = 1'b1;

        // Test group 3: 16 valid values
        @(negedge clk)
        start = 1'b1;
        for(int i=0;i<16;i++) begin
           outmap_data[i] = 8'd1;
        end
        outmap_data_valid_num = 5'd16;
        mem_ack = 1'b0;

        // Test group 4: Mixed zero and valid value
        @(negedge clk)
        start = 1'b1;
        for(int i=0;i<8;i++) begin //filling up grp_1_zero
           outmap_data[i] = 8'd0;
        end
        for(int i=8;i<12;i++) begin //filling up grp_1234_value
           outmap_data[i] = 8'd1;
        end
        for(int i=12;i<16;i++) begin //filling up grp_5_zero
           outmap_data[i] = 8'd0;
        end
        outmap_data_valid_num = 5'd16;
        mem_ack = 1'b1;

        @(negedge clk)
        start = 1'b0;
        for(int i=0;i<16;i++) begin //filling up grp_5_zero and grp_5_value = 11 + 1 input taken
           outmap_data[i] = 8'd0;
        end
        outmap_data_valid_num = 5'd16;
        mem_ack = 1'b0;

        @(negedge clk)
        start = 1'b0;
        mem_ack = 1'b1;
        repeat(3) begin
           @(negedge clk)
           start = 1'b0;
           outmap_data_valid_num = 5'd0;
        end

        // Test group 5: outmap_data_valid_num < 16
        @(negedge clk)
        start = 1'b1;
        for(int i=0;i<16;i++) begin
           outmap_data[i] = 8'd1;
        end
        outmap_data_valid_num = 5'd9;
        mem_ack = 1'b0;

        @(negedge clk)
        start = 1'b0;
        outmap_data_valid_num = 5'd4;
        mem_ack = 1'b1;

        repeat(5) begin
           @(negedge clk)
           start = 1'b0;
           outmap_data_valid_num = 5'd0;
           mem_ack = 1'b1;
        end

        //#1000;
        $finish;
    end

    initial begin
        $fsdbDumpfile("dump.fsdb");
        $fsdbDumpvars(0,compressor_tb,"+all");
        $fsdbDumpon;
    end
               
                
endmodule
