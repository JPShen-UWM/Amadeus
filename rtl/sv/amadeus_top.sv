module amadeus(
    input clk,
    input rst_n,
    input [`MEM_BANDWIDTH*8-1:0] mem_read_data,
    input mem_valid,
    input [`MEM_ADDR_SIZE-1:0] ifmap_buffer_start_addr,
    input [`MEM_ADDR_SIZE-1:0] weight_buffer_start_addr,
    input [`MEM_ADDR_SIZE-1:0] compressor_start_addr,
    input LAYER_TYPE layer_type_in,

    output [`MEM_ADDR_SIZE-1:0] mem_addr,
    output [`MEM_BANDWIDTH*8-1:0] mem_write_data,
    output mem_read,
    output mem_write
);


    logic start_layer;
    logic ifmap_buffer_req;
    logic [`MEM_BANDWIDTH*8-1:0] decompressor_mem_data;
    logic decompressor_mem_data_valid;
    logic decompressor_mem_ack;
    logic decompressor_ack;
    DECOMRPESS_FIFO_PACKET decompressed_fifo_packet;
    logic free_ifmap_buffer;
    logic [`MEM_BATCH_SIZE-1:0][256-1:0][7:0] ifmap_data;
    logic ifmap_data_valid;
    logic ifmap_data_change;

    logic start_conv;
    logic mode;
    logic conv_complete;
    logic 


    decompressor Decompressor(
        .clk(clk),
        .rst_n(rst_n),
        .start(start_layer),
        .ifmap_buffer_req(ifmap_buffer_req),
        .mem_data(decompressor_mem_data),
        .mem_data_valid(decompressor_mem_data_valid),
        .mem_ack(decompressor_mem_ack),
        .layer_type_in(layer_type_in),

        .decompressor_ack(decompressor_ack),
        .mem_req(mem_req),
        .decompress_fifo_packet(decompressed_fifo_packet)
    );

    ifmap_buffer Ifmap_buffer(
        .clk(clk),
        .rst_n(rst_n),
        .start(start_layer),
        .layer_type_in(layer_type_in),
        .decompressed_fifo_packet(decompressed_fifo_packet),
        .decompressor_ack(decompressor_ack),
        .free_ifmap_buffer(free_ifmap_buffer),

        .ifmap_buffer_req(ifmap_buffer_req),
        .ifmap_data(ifmap_data),
        .ifmap_data_valid(ifmap_data_valid),
        .ifmap_data_change(ifmap_data_change)
    );

    NOC Noc(
        .clk(clk),
        .rst_n(rst_n),
        .start(start_layer),
        .start_con(start_conv),
        .layer_type_in(layer_type_in),
        .mode_in(mode),
        .conv_complete(conv_complete),
        .ifmap_data_in(ifmap_data),
        .pe_full(),
        .complete_count(),

        .free_ifmap_buffer(),
        .diagonal_bus_packet()
    );

    

endmodule