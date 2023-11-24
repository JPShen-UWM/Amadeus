module ifmp_buffer(
    input clk,
    input rst_n,
    input LAYER_TYPE layer_type,
    input IFMP_BUFFER_PACKET ifmp_packet_in,
    input slave_ack,
    input channel_switch,
    output read_req
);
    
    logic [IFMP_BUFFER_ENRTY_NUM-1:0][IFMP_BUFFER_ENTRY_WIDTH-1:0] data_batch_1;
    logic [IFMP_BUFFER_ENRTY_NUM-1:0][IFMP_BUFFER_ENTRY_WIDTH-1:0] data_batch_2;


endmodule