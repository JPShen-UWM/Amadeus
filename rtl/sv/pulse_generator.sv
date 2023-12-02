module pulse(
    input clk,
    input rst_n,
    input level,
    output pulse
);
    logic reg_val;
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            reg_val <= 0;
        end
        else begin
            reg_val <= level;
        end
    end
    assign pulse = level & (level ^ reg_val);
endmodule