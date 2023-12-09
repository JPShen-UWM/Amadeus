module controller_tb;

    // Testbench Signals
    logic clk;
    logic rst_n;
    logic start;
    LAYER_TYPE layer_type_in;
    logic [`MEM_ADDR_SIZE-1:0] ifmap_buffer_start_addr;
    logic [`MEM_ADDR_SIZE-1:0] weight_buffer_start_addr;
    logic [`MEM_ADDR_SIZE-1:0] compressor_start_addr;
    logic [5:0][6:0] pe_conv_done;
    logic decompressor_mem_req;
    logic compressor_mem_req;
    logic [`MEM_BANDWIDTH*8-1:0] compressed_data;
    logic weight_buffer_mem_req;
    logic weight_output_finish;
    logic weight_load_finish;
    logic ifmap_data_valid;
    logic [`MEM_BANDWIDTH*8-1:0] mem_data;
    logic mem_valid;
    
    logic start_conv;
    OP_MODE mode;
    logic start_decompressor;
    logic [`MEM_BANDWIDTH*8-1:0] decompressor_mem_data;
    logic decompressor_mem_data_valid;
    logic decompressor_mem_ack;
    logic [4:0] complete_count;
    OP_STAGE op_stage;
    logic change_mode;
    logic start_ifmap_buffer_load;
    logic start_weight_buffer_load;
    logic start_weight_buffer_output;
    logic weight_buffer_mem_ack;
    logic [`MEM_BANDWIDTH*8-1:0] weight_buffer_mem_data;
    logic weight_buffer_mem_data_valid;
    logic compressor_mem_ack;
    logic [`MEM_ADDR_SIZE-1:0] mem_addr;
    logic [`MEM_BANDWIDTH*8-1:0] mem_write_data;
    logic mem_read_valid;
    logic mem_write_valid;
    logic layer_complete;
    
    always #10 clk = ~clk;
    // Instantiate the controller module
    controller uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .layer_type_in(layer_type_in),
        .ifmap_buffer_start_addr(ifmap_buffer_start_addr),
        .weight_buffer_start_addr(weight_buffer_start_addr),
        .compressor_start_addr(compressor_start_addr),
        .pe_conv_done(pe_conv_done),
        .decompressor_mem_req(decompressor_mem_req),
        .compressor_mem_req(compressor_mem_req),
        .compressed_data(compressed_data),
        .weight_buffer_mem_req(weight_buffer_mem_req),
        .weight_output_finish(weight_output_finish),
        .weight_load_finish(weight_load_finish),
        .ifmap_data_valid(ifmap_data_valid),
        .mem_data(mem_data),
        .mem_valid(mem_valid),
        .start_conv(start_conv),
        .mode(mode),
        .start_decompressor(start_decompressor),
        .decompressor_mem_data(decompressor_mem_data),
        .decompressor_mem_data_valid(decompressor_mem_data_valid),
        .decompressor_mem_ack(decompressor_mem_ack),
        .complete_count(complete_count),
        .op_stage(op_stage),
        .change_mode(change_mode),
        .start_ifmap_buffer_load(start_ifmap_buffer_load),
        .start_weight_buffer_load(start_weight_buffer_load),
        .start_weight_buffer_output(start_weight_buffer_output),
        .weight_buffer_mem_ack(weight_buffer_mem_ack),
        .weight_buffer_mem_data(weight_buffer_mem_data),
        .weight_buffer_mem_data_valid(weight_buffer_mem_data_valid),
        .compressor_mem_ack(compressor_mem_ack),
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_read_valid(mem_read_valid),
        .mem_write_valid(mem_write_valid),
        .layer_complete(layer_complete)
    );

    initial begin
        clk = 0;
    end


endmodule
