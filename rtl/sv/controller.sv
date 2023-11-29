module controller(
    input clk,
    input rst_n,
    input complete, // The PE are done with a part of input feature map(layer 1), full input feature map(layer 2)

    output free_ifmap_buffer
);

    LAYER_TYPE layer_type;

    /// ifmap_buffer control logic ///
    // when there is one complete from PEs, COUNT++
    localparam LAYER1_COUNT = 16;
    localparam LAYER2_COUNT = 4;
    localparam LAYER3_COUNT = 1;

    // complete count from PEs
    logic [4:0] complete_count;
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
            complete_count <= 0;
        end
        else if(complete) begin
            complete_count <= complete_count + 1'b1;
        end
    end

   

endmodule