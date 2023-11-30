module psum_buffer(
    input clk,
    input rst_n,
    input start_conv,
    input OP_MODE mode_in,
    input PSUM_PACKET[6:0] psum_in,
    input [6:0] pe_psum_ack, // if pe receive the psum from psum buffer
    output [6:0] psum_buffer_ack, // sen to pe to tell that the psum packet has been accepted by psum buffer
    output PSUM_PACKET[6:0] psum_out
);

    logic psum_buffer_reset;
    OP_MODE mode;
    logic [6:0][3:0] psum_buffer_wen;
    logic [6:0][3:0] psum_buffer_ren;
    logic [6:0][3:0][`PSUM_DATA_SIZE-1:0] psum_fifo_data;
    logic [6:0][3:0] psum_fifo_data_valid;
    logic [6:0][3:0] psum_fifo_full;
    logic [6:0][3:0] psum_fifo_empty;

    logic [6:0][3:0] psum_filter_idx_onehot; // represent psum corresponding to which filter is outputing to top of one column pe
    logic [6:0][1:0] psum_filter_idx;

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            mode <= MODE1;
        end
        else if(start_conv) begin
            mode <= mode_in;
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            psum_buffer_reset <= 1'b1;
        end
        else if(mode == MODE1 & start_conv) begin
            psum_buffer_reset <= 1'b0;
        end
        else begin
            psum_buffer_reset <= 1'b1;
        end
    end

    for(genvar i = 0; i < 7; i=i+1) begin:psum_set
        for(genvar i = 0; i < 4; i=i+1) begin : psum_buffer
            fifo #(.DEPTH(55),.WIDTH(`PSUM_DATA_SIZE)) queue(
                .clk(clk),
                .rst_n(rst_n & psum_buffer_reset),
                .wen(psum_buffer_wen[i][j]),
                .ren(psum_buffer_ren[i][j]),
                .data_in(psum_in[i].psum),
                .data_out(psum_fifo_data[i][j]),
                .data_valid(psum_fifo_data_valid[i][j]),
                .full(psum_fifo_full[i][j]),
                .empty(psum_fifo_empty[i][j])
            );
        end
    end

    /// psum write logic ///
    for(genvar i = 0; i < 7; i=i+1) begin
        assign psum_buffer_ack[i] = ~psum_fifo_full[i][psum_in[i].filter_idx];
        assign psum_buffer_wen[i] = psum_in[i].valid ? 1'b1 << psum_in[i].filter_idx : '0;
    end

    /// psum read logic ///
    logic read_enable; // only assert when there is read eanble
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            read_enable <= 1'b0;
        end
        else if(start_conv && mode == MODE2) begin
            read_enable <= 1'b1;
        end
        else if(&psum_fifo_empty) begin
            read_enable <= 1'b0;
        end
    end

    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            psum_filter_idx_onehot <= '0;
        end
        else if(start_conv && mode == MODE2) begin
            for(integer i = 0; i < 7; i=i+1) begin
                psum_filter_idx_onehot[i] <= 1'b1;
            end
        end
        else begin
            for(integer i = 0; i < 7; i=i+1) begin
                psum_filter_idx_onehot[i] <= pe_psum_ack[i] ? {psum_filter_idx_onehot[2:0],psum_filter_idx_onehot[3]} : psum_filter_idx_onehot;
            end
        end
    end

    for(genvar i = 0; i < 7; i=i+1) begin:psum_ren
        assign psum_buffer_ren[i] = psum_filter_idx_onehot[i] & {4{pe_psum_ack[i]}}; // assign ren = 1 for currently output pe fifo if receive pe_psum_ack
    end

    // generate the psum_pakcet to each column of pe
    always_comb begin
        for(int i = 0; i < 7; i=i+1) begin
            psum_filter_idx[i] = 0;
            for(int j = 0; j < 4; j=j+1) begin
                if(psum_filter_idx_onehot[i]) begin
                    psum_filter_idx[i] = j;
                end
            end
        end
    end

    for(genvar i = 0; i < 7; i=i+1) begin:psum_out_packet
        assign psum_out[i].valid = |(psum_fifo_data_valid[i] & psum_filter_idx_onehot[i]) & read_enable;
        assign psum_out[i].filter_idx = psum_filter_idx[i];
        assign psum_out[i].psum = psum_fifo_data[i][psum_filter_idx[i]];
    end

endmodule