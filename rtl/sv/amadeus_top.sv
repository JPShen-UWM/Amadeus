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
    logic [5:0][6:0] pe_full;
    logic [4:0] complete_count;
    DIAGONAL_BUS_PACKET diagonal_bus_packet;
    PE_IN_PACKET [0:5] weight_in_array;
    PSUM_PACKET [6:0] psum_to_pe;
    logic [6:0] pe_psum_ack;
    PSUM_PACKET [6:0] psum_to_buffer;
    logic [6:0] psum_buffer_ack;
    OP_MODE mode_in;
    logic change_mode;
    logic conv_continue;
    OP_STAGE op_stage_in;
    logic [5:0][6:0] pe_conv_done;
    PSUM_PACKET [6:0] psum_row2_out;
    PSUM_PACKET [6:0] psum_row4_out;
    logic [6:0] outbuff_row2_ack_in;
    logic [6:0] outbuff_row4_ack_in;
    logic [6:0] outbuff_row5_ack_in;
    wor error;
    
    logic [15:0][7:0] outmap_data;
    logic [4:0] outmap_data_valid_num;
    logic [4:0] valid_taken_num;

    logic send_done;

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
        .start_conv(start_conv),
        .layer_type_in(layer_type_in),
        .mode_in(mode),
        .conv_complete(conv_complete),
        .ifmap_data_in(ifmap_data),
        .pe_full(pe_full),
        .complete_count(complete_count),

        .free_ifmap_buffer(free_ifmap_buffer),
        .diagonal_bus_packet(diagonal_bus_packet)
    );

    pe_array Pe_array(
        .clk(clk),
        .rst_n(rst_n),
        .pe_full(pe_full),
        .diagonal_bus_packet(diagonal_bus_packet),
        .weight_in_array(weight_in_array),
        .psum_to_pe(psum_to_pe),
        .pe_psum_ack(pe_psum_ack),
        .psum_to_buffer(psum_to_buffer),
        .psum_buffer_ack(psum_buffer_ack),
        .mode_in(mode),
        .change_mode(change_mode),
        .conv_continue(start_conv),
        .op_stage_in(op_stage_in),
        .pe_conv_done(pe_conv_done),
        .psum_row2_out(psum_row2_out),
        .psum_row4_out(psum_row4_out),
        .outbuff_row2_ack_in(outbuff_row2_ack_in),
        .outbuff_row4_ack_in(outbuff_row4_ack_in),
        .outbuff_row5_ack_in(outbuff_row5_ack_in),
        .error(error)
    );

    psum_buffer Psum_buffer(
        .clk(clk),
        .rst_n(rst_n),
        .start_conv(start_conv),
        .mode_in(mode),
        .psum_in(psum_to_buffer),
        .pe_psum_ack(pe_psum_ack),

        .psum_buffer_ack(psum_buffer_ack), // send to pe to tell that the psum packet has been accepted by psum buffer
        .psum_out(psum_to_pe)
    );

    output_buffer Output_buffer(
        .clk(clk),
        .rst_n(rst_n),
        // To pe array
        .psum_row2_out(psum_row2_out),
        .psum_row4_out(psum_row4_out),
        .psum_to_buffer(psum_to_buffer),
        .outbuff_row2_ack_in(outbuff_row2_ack_in),
        .outbuff_row4_ack_in(outbuff_row4_ack_in),
        .outbuff_row5_ack_in(outbuff_row5_ack_in),
        // to compressor
        .outmap_data(outmap_data),
        .outmap_data_valid_num(outmap_data_valid_num),
        .valid_taken_num(valid_taken_num),
        // to controller
        .mode_in(mode),
        .change_mode(change_mode),
        .control_state(),
        .send_done(send_done)
    );


    output_buffer Output_buffer(
        input clk,
        input rst,
        // To pe array
        input PSUM_PACKET [6:0]         psum_row2_out,
        input PSUM_PACKET [6:0]         psum_row4_out,
        input PSUM_PACKET  [6:0]        psum_to_buffer,
        output [6:0]                    outbuff_row2_ack_in,
        output [6:0]                    outbuff_row4_ack_in,
        output [6:0]                    outbuff_row5_ack_in,
        // to compressor
        output logic [15:0][7:0]        outmap_data,
        output logic [4:0]              outmap_data_valid_num,
        input  [4:0]                    valid_taken_num,
        // to controller
        input OP_MODE                   mode_in,
        input                           change_mode,
        input CONTROL_STATE             control_state, // TO DO
        output                          send_done
    );

    compressor Compressor(
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

endmodule