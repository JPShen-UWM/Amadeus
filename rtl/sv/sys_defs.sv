/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  sys_defs.vh                                         //
//                                                                     //
//  Description :  This file has the macro-defines for macros used in  //
//                 the pipeline design.                                //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


`ifndef __SYS_DEFS_VH__
`define __SYS_DEFS_VH__

/* Synthesis testing definition, used in DUT module instantiation */

`ifdef  SYNTH_TEST
`define DUT(mod) mod``_svsim
`else
`define DUT(mod) mod
`endif

// Configuration
parameter ZERO_SKIPPING       = 1;   // Perform zero skip on multiplier

// Data size
parameter IFDATA_SIZE         =  8   ;// Input feature map data size   unsigned fixed point (8,7)
parameter OFDATA_SIZE         =  8   ;// Output feature map data size  unsigned fixed point (8,4)
parameter WDATA_SIZE          =  8   ;// Weight data size              signed fixed point (8,6)
parameter L1_FILTER_SIZE      =  11  ;// First layer filter size
parameter L2_FILTER_SIZE      =  5   ;// Second layer filter size
parameter L3_FILTER_SIZE      =  3   ;// Third and rest filter size
parameter L1_STRIDE           =  4   ;// First layer stride
parameter L1_IFMAP_SIZE       =  227 ;// First layer input feature map size
parameter L2_IFMAP_SIZE       =  31  ;// Second layer input feature map size: 27 pad 2 = 31
parameter L3_IFMAP_SIZE       =  15  ;// Third layer input feature map size: 13 pad 1 = 15
parameter L1_OFMAP_SIZE       =  55  ;// Layer 1 output feature map (227-11)/4+1 = 55
parameter L2_OFMAP_SIZE       =  27  ;// Layer 2 output feature map (31-5)/1+1 = 27
parameter L3_OFMAP_SIZE       =  13  ;// Layer 3 output feature map (15-3)/1+1 = 13
parameter MULT_OUT_SIZE       =  8   ;// PE multiplier data size signed fixed point (8,5)
parameter PSUM_DATA_SIZE      =  12  ;// PE multiplier data size signed fixed point (12,5)
parameter MULTIFILTER         =  4   ;// Maximum support calculate 4 filter at same time

// struct
typedef struct packed {
	logic valid;
    logic [4:0] packet_idx;    // packet idx for ifmap, when use for filter index, row_idx = packet_idx[2:0] and filter_idx = packet_idx[4:3]
    logic [3:0][IFDATA_SIZE-1:0] data;
} PE_IN_PACKET;

typedef struct packed {
    logic valid;                        // psum is valid for next pe accumulation
    //logic [5:0] psum_idx;               // psum index in the row
    logic [1:0] filter_idx;             // filter index
    logic [PSUM_DATA_SIZE-1:0] psum;
} PSUM_PACKET;

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

`endif // __SYS_DEFS_VH__