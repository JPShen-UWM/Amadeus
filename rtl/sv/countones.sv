module countones #(parameter WIDTH = 6)(
    input [WIDTH-1:0] in,
    output [$clog2(WIDTH):0] count
);

    always_comb begin
        count = 0;
        for(integer i = 0; i < WIDTH; i=i+1) begin
            count = count + in[i];
        end
    end

endmodule