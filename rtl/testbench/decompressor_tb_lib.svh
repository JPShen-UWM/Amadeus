`include "sv/sys_defs.svh"
class IFMAP_GENERATION;
    rand bit[7:0] ifmap_data [$];
    bit [63:0] compressed_data_set [$];

    LAYER_TYPE layer_type;
    int size;

    constraint layer1 {
        ifmap_data.size() == 51529;
        foreach(ifmap_data[i]){
            ifmap_data[i] dist {0:/3, [1:255]:/96};
        }
    };
    constraint layer2 {
        ifmap_data.size() == 729;
        foreach(ifmap_data[i]){
            ifmap_data[i] dist {0:/7, [1:255] :/3};
        }
    };
    constraint layer3 {
        ifmap_data.size() == 169;
        foreach(ifmap_data[i]){
            ifmap_data[i] dist {0:/3, [1:255] :/7};
        }
    };
    constraint last_num {
        ifmap_data[ifmap_data.size()-1] dist {0:/1, 1:/1};
    }

    function new(LAYER_TYPE layer_type);
        this.layer_type = layer_type;
        if(layer_type == LAYER1) begin
            size = 227;
        end
        else if(layer_type == LAYER2) begin
            size = 27;
        end
        else if(layer_type == LAYER3) begin
            size = 13;
        end
    endfunction

    function void compress();
        bit [63:0] compressed_data;
        bit [3:0] zero_num;
        int group_num = 0;
        zero_num = 0;
        compressed_data = 64'b0;
        this.compressed_data_set.delete();
        for(int i = 0; i < ifmap_data.size(); i=i+1) begin
            if(ifmap_data[i] != 0 || zero_num == 15) begin
                compressed_data = {{ifmap_data[i],zero_num},compressed_data[63:12]};
                zero_num = 0;
                group_num = group_num + 1;
            end
            else if(ifmap_data[i] == 0) begin
                zero_num = zero_num + 1;
            end
            if(group_num == 5) begin
                compressed_data = compressed_data >> 4;
                compressed_data[63] = 1'b1;
                compressed_data[62:60] = 3'b111;
                compressed_data_set.push_back(compressed_data);
                group_num = 0;
                compressed_data = 0;
            end
        end
        if(group_num != 0) begin
            compressed_data = compressed_data >> ((5-group_num)*12+4);
            if(zero_num == 0) begin
                compressed_data[62:60] = group_num-1;
                compressed_data[63] = 1'b1;
            end
            else begin
                compressed_data = compressed_data | (zero_num << group_num*12);
                compressed_data[62:60] = group_num;
                compressed_data[63] = 0;
            end
            compressed_data_set.push_back(compressed_data);
        end
    endfunction

    function void display_raw();
        $display("============================  IFMAP DATA ============================");
        for(int i = 0; i < size; i=i+1) begin
            for(int j = 0; j < size; j=j+1) begin
                $write("%d ",ifmap_data[i*size+j]);
            end
            $write("\n");
        end
    endfunction

    function void display_decompressed();
        $display("============================  IFMAP COMPRESSED DATA ============================");
        for(int i = 0; i < compressed_data_set.size(); i=i+1) begin
            $display("status bits = %h",compressed_data_set[i]);
            for(int j = 0; j < 5; j=j+1) begin
                $write("zero = %d, val = %d\n",(compressed_data_set[i] >> j*12) & 4'b1111,(compressed_data_set[i] >> (j*12+4)) & 8'b11111111);
            end
            $display("status bits = %b",compressed_data_set[i][63:60]);
        end
    endfunction

    function void pre_randomize();
        this.srandom($urandom);
        if(layer_type == LAYER1) begin
            this.layer2.constraint_mode(0);
            this.layer3.constraint_mode(0);
        end
        else if(layer_type == LAYER2) begin
            this.layer1.constraint_mode(0);
            this.layer3.constraint_mode(0);
        end
        else if(layer_type == LAYER3) begin
            this.layer1.constraint_mode(0);
            this.layer2.constraint_mode(0);
        end
    endfunction
endclass


class STIMULUS;
    bit [63:0] compressed_data_set [$];
    rand bit ifmap_buffer_req;
    rand bit mem_data_valid;
    rand bit mem_ack;
    logic [`MEM_BANDWIDTH*8-1:0] mem_data;

    bit [30:0] index;

    function new( bit [63:0] compressed_data_set [$]);
        this.compressed_data_set = compressed_data_set;
        this.index = 0;
        this.mem_data_valid = 0;
        this.mem_ack = 0;
        this.ifmap_buffer_req = 0;
    endfunction

    constraint req_ack{
        ifmap_buffer_req dist {1:=7, 0:=1};
        mem_ack dist {1:= 9, 0:=1};
    };

    constraint mem_valid{
        mem_data_valid dist {1:=8, 0:=1};
        (index >= compressed_data_set.size()) -> (mem_data_valid == 0);
    };

    function void post_randomize();
        mem_data = compressed_data_set[index];
        if(mem_data_valid == 1'b1) begin
            index = index + 1'b1;
        end
    endfunction
    
endclass


class GOLDEN;
    bit[7:0] ifmap_data_golden [$];
    bit[7:0] decompressor_output [$];
    LAYER_TYPE layer_type;
    int size;
    int k;

    function new(bit[7:0] ifmap_data_golden [$], LAYER_TYPE layer_type);
        this.ifmap_data_golden = ifmap_data_golden;
        this.layer_type = layer_type;
        if(layer_type == LAYER1) begin
            size = 227;
        end
        else if(layer_type == LAYER2) begin
            size = 27;
        end
        else if(layer_type == LAYER3) begin
            size = 13;
        end
    endfunction

    function void reset(bit[7:0] ifmap_data_golden [$]);
        this.ifmap_data_golden = ifmap_data_golden;
        this.decompressor_output = {};
    endfunction

    function void collect_output(DECOMRPESS_FIFO_PACKET decompress_fifo_packet);
        if(decompress_fifo_packet.packet_valid) begin
            for(int i = 0; i < 8; i=i+1) begin
                if(decompress_fifo_packet.valid_mask[i]) begin
                    this.decompressor_output.push_back(decompress_fifo_packet.data[i]);
                end
            end
        end
    endfunction

    function void display_decompressor_out();
        $display("============================  DECOMPRESSED DATA ============================");
        k = 0;
        for(int i = 0; i < this.decompressor_output.size(); i=i+1) begin
            $write("%d ",this.decompressor_output[i]);
            k = k+1;
            if(k == size) begin
                k = 0;
                $write("\n");
            end
        end
        $write("\n");
    endfunction

    function void check();
        int num = 0;
        if(this.ifmap_data_golden.size() != this.decompressor_output.size()) begin
            $display("decompressor size is not equal");
        end
        for(int i = 0; i < this.ifmap_data_golden.size(); i=i+1) begin
            if(this.ifmap_data_golden[i] != this.decompressor_output[i]) begin
                num = num+1;
                $display("data mismatch : ifmap_data_golden[%d] = %d, decompressor_out[%d] = %d",i, this.ifmap_data_golden[i], i, this.decompressor_output[i]);
            end
        end
        if(num == 0) begin
            $display("==================================================");
            $display("==================== TEST PASS ===================");
            $display("==================================================");
        end 
        else begin
            $display("==================================================");
            $display("==================== TEST FAIL ===================");
            $display("==================================================");
            display_decompressor_out();
        end
    endfunction

endclass

class UTILITY;

    function display_decompress_fifo_packet(DECOMRPESS_FIFO_PACKET decompressed_fifo_packet);
        $display("=================== decompress_fifo_packet ====================");
        for(integer i = 0; i < `IFMP_DATA_SIZE; i=i+1) begin
            $display("v: %b, data: %d",decompressed_fifo_packet.valid_mask[i], decompressed_fifo_packet.data[i]);
        end
    endfunction

endclass