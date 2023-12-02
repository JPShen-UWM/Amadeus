module ASSERT_NEVER_IMM #(
    MSG = ""
)(
    input logic en,
    input logic expr
);

`ifndef ASSERT_NEVER_IMM_DIS
    always@(*) begin
        if(en) begin
            assert #0 (~expr) else $error("ASSERT_NEVER_IMM: ",MSG);
        end
    end
`endif

endmodule