module priority_encoder #(parameter WIDTH = 6) (
    input [WIDTH-1:0] req,
    output [$clog2(WIDTH)-1:0] gnt,
    output valid
);

    logic [WIDTH-1:0] mask;
    logic [WIDTH-1:0] gnt_one_hot;
    assign mask[0] = req[0];
    for(genvar i = 1; i < WIDTH; i=i+1) begin
        assign mask = mask[i-1] | req;
    end
    assign gnt_one_hot = mask & ~(mask << 1'b1);
    assign valid = |gnt_one_hot;
    always_comb begin
        gnt = 0;
        for(integer i = 0; i < WIDTH; i=i+1) begin
            if(gnt_one_hot[i] == 1'b1) begin
                gnt = i;
            end
        end
    end
endmodule