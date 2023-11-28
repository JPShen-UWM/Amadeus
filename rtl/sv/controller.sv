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

    /// free ///
    // free one full memory batch when receving the complete signal from PE array
    // if in layer1, you need to receive 2 complete signal
    logic free_change;
    assign free_change = ((layer_type == LAYER1 && complete_count[0] == 1) || (layer_type == LAYER2 && complete_count == LAYER2_COUNT-1) || layer_type == LAYER3) && complete;
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n or start) begin
            free_ifmap_buffer <= 0;
        end
        else if(free_change) begin
            free_ifmap_buffer <= 1;
        end
        else begin
            free_ifmap_buffer <= 0;
        end
    end


endmodule