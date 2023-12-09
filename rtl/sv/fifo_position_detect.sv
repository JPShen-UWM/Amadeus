module fifo_position_detect #(parameter WIDTH = 6)(
    input  [WIDTH-1:0] valid_entry,
    output [WIDTH-1:0] write_in_entry,
    output valid
);

    logic flip;
    logic [WIDTH-1:0] valid_entry_flip;
    logic [WIDTH-1:0] valid_entry_flip_mask; // mask of the valid entry before flip, ex: 1101 -> 0001, mask = 0011
    logic [WIDTH-1:0] valid_entry_head_mask_off;
    logic [WIDTH-1:0] write_in_entry_mask; // 0010 -> 0011, mask off all low 0
    assign flip = valid_entry[WIDTH-1];

    assign valid_entry_flip_mask = ~valid_entry | {1'b0,valid_entry_flip_mask[WIDTH-1:1]};
    assign valid_entry_flip = valid_entry & valid_entry_flip_mask;
    assign valid_entry_head_mask_off = flip ? valid_entry_flip : valid_entry;
    assign write_in_entry_mask = valid_entry_head_mask_off | {1'b0,write_in_entry_mask[WIDTH-1:1]};
    assign write_in_entry = ~((~write_in_entry_mask) << 1'b1) & ~write_in_entry_mask;

    assign valid = |write_in_entry;

endmodule