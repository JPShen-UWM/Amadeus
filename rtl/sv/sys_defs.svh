/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  sys_defs.vh                                         //
//                                                                     //
//  Description :  This file has the macro-defines for macros used in  //
//                 the pipeline design.                                //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

`ifndef __SYS_DEFS_VH__
`define __SYS_DEFS_VH__

/* Synthesis testing definition, used in DUT module instantiation */

`ifdef  SYNTH_TEST
`define DUT(mod) mod``_svsim
`else
`define DUT(mod) mod
`endif

// Configuration
`define ZERO_SKIPPING       1   // Perform zero skip on multiplier

// Data size
`define IFDATA_SIZE         8   // Input feature map data size   unsigned fixed point (8,7)
`define OFDATA_SIZE         8   // Output feature map data size  unsigned fixed point (8,4)
`define WDATA_SIZE          8   // Weight data size              signed fixed point (8,6)
`define L1_FILTER_SIZE      11  // First layer filter size
`define L2_FILTER_SIZE      5   // Second layer filter size
`define L3_FILTER_SIZE      3   // Third and rest filter size
`define L1_STRIDE           4   // First layer stride
`define L1_IFMAP_SIZE       227 // First layer input feature map size
`define L2_IFMAP_SIZE       31  // Second layer input feature map size: 27 pad 2 = 31
`define L3_IFMAP_SIZE       15  // Third layer input feature map size: 13 pad 1 = 15
`define L1_OFMAP_SIZE       55  // Layer 1 output feature map (227-11)/4+1 = 55
`define L2_OFMAP_SIZE       27  // Layer 2 output feature map (31-5)/1+1 = 27
`define L3_OFMAP_SIZE       13  // Layer 3 output feature map (15-3)/1+1 = 13
`define MULT_OUT_SIZE       8   // PE multiplier data size signed fixed point (8,5)
`define PSUM_DATA_SIZE      12  // PE multiplier data size signed fixed point (12,5)
`define MULTIFILTER         4   // Maximum support calculate 4 filter at same time]
`define IFMP_BUFFER_ENRTY_NUM   35  // The number of entry one scratch in ifmp_buffer
`define IFMP_BUFFER_ENTRY_WIDTH 256 // The width for one entry in ifmp_buffer scratch
`define IFMP_DATA_SIZE      8   // The data size in byte from compress fifo to global buffer
`define MEM_BANDWIDTH       8   // The memory bandwidth in byte
`define MEM_BATCH_SIZE      35
`define MEM_ADDR_SIZE       16


// struct
typedef struct packed {
    logic valid;
    logic [4:0] packet_idx;    // packet idx for ifmap, when use for filter index, row_idx = packet_idx[2:0] and filter_idx = packet_idx[4:3]
    logic [3:0][`IFDATA_SIZE-1:0] data;
} PE_IN_PACKET;

typedef struct packed {
    logic valid;                        // psum is valid for next pe accumulation
    //logic [5:0] psum_idx;               // psum index in the row
    logic [1:0] filter_idx;             // filter index
    logic signed [`PSUM_DATA_SIZE-1:0] psum;
} PSUM_PACKET;

typedef struct packed {
    logic packet_valid;
    logic [`IFMP_DATA_SIZE-1:0] valid_mask;
    logic [`IFMP_DATA_SIZE-1:0][7:0] data;
} DECOMRPESS_FIFO_PACKET;

typedef struct packed {
    logic [3:0] zero;
    logic [7:0] val;
} COMPRESS_UNIT;

/*
typedef struct packed {
    logic [5:0][6:0] 
} PE_IFMAP_STATUS_ARRAY;
*/

typedef struct packed {
    PE_IN_PACKET [11:0] diagonal_bus;
} DIAGONAL_BUS_PACKET;

typedef struct packer {
    MEMORY_SOURCE mem_req_src;
    logic [`MEM_ADDR_SIZE-1:0] addr;
} MEM_REQ_PACKET;


// enum
typedef enum logic [1:0] {
    MODE1 = 2'b00,      // Layer 1 up part
    MODE2 = 2'b01,      // Layer 1 down part
    MODE3 = 2'b10,      // Layer 2
    MODE4 = 2'b11       // Layer 3 and rest
} OP_MODE;

typedef enum logic [1:0] {
    IDLE            = 2'b00,
    LOAD_FILTER     = 2'b01,
    CONV            = 2'b10
} OP_STAGE;

typedef enum logic [1:0] {
    LAYER1,
    LAYER2,
    LAYER3,
    NULL
} LAYER_TYPE;

typedef enum logic[3:0] {
    IDLE,
    WEIGHT_LOAD,
    WEIGHT_OUTPUT,
    IFMAP_LOAD,
    WAIT_TO_RESTART_CONV_P4, // if pe array just finish all conv, ifmap need to change to ifmap
    WAIT_TO_RESTART_CONV_P3,
    WAIT_TO_RESTART_CONV_P2,
    WAIT_TO_RESTART_CONV_P1,
    WAIT_TO_RESTART_CONV;
    PE_CONV_MODE1,
    PE_CONV_MODE2,
    PE_CONV_MODE3,
    PE_CONV_MODE4,
    COMPLETE
} CONTROL_STATE;

typedef enum logic[1:0] {
    DECOMPRESSOR  = 2'b00,
    WEIGHT_BUFFER = 2'b01,
    COMPRESSOR    = 2'b10
} MEMORY_SOURCE;


typedef enum logic[1:0]{
    TAKING_OUTPUT = 1'b0,
    SENDING_OUTPUT = 1'b1
} OUTPUT_BUFFER_STATE;
// synthesizable functions

// relu to psum
function logic [7:0] relu(input [11:0] psum);
    begin
        if(!psum[11] & |psum[10:9]) return 8'hFF; // Max satuation
        else if(psum[11]) return 8'h00; // RELU
        else return psum[8:1];
    end
endfunction
`endif // __SYS_DEFS_VH__