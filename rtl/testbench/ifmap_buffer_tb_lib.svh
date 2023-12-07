`include "sv/sys_defs.svh"

virtual class IFMAP_DATA;

    rand bit[7:0] ifmap_data [$];
    DECOMRPESS_FIFO_PACKET ifmap_buffer_payload_set [$];
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
            ifmap_data[i] dist {0:/6, [1:255] :/3};
        }
    };
    constraint layer3 {
        ifmap_data.size() == 169;
        foreach(ifmap_data[i]){
            ifmap_data[i] dist {0:/8, [1:255] :/2};
        }
    };
    constraint last_num {
        ifmap_data[ifmap_data.size()-1] dist {0:/1, [1:255]:/1};
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

    function void pre_randomize();
        int seed = $urandom;
        this.srandom(seed); //-305490073
        $display(seed);
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
    
    function void display_raw();
        $display("============================  IFMAP DATA ============================");
        for(int i = 0; i < size; i=i+1) begin
            for(int j = 0; j < size; j=j+1) begin
                $write("%d ",ifmap_data[i*size+j]);
            end
            $write("\n");
        end
    endfunction

    function void display_payload();
        $display("============================  IFMAP BUFFER PAYLOAD ============================");
        for(int i = 0; i < ifmap_buffer_payload_set.size(); i=i+1) begin
            for(int j = 0; j < 8; j=j+1) begin
                $write("v : %b, data : %d   ",ifmap_buffer_payload_set[i].valid_mask[j], ifmap_buffer_payload_set[i].data[j]);
            end
            $write("\n");
        end
    endfunction

    pure virtual function void payload_generation();

endclass

class LAYER1_IFMAP_DATA extends IFMAP_DATA;

    function new();
        super.new(LAYER1);
    endfunction 

    virtual function void payload_generation();
        int index_packet;
        int index_line;
        DECOMRPESS_FIFO_PACKET decompressed_fifo_packet;
        decompressed_fifo_packet = 0;
        index_packet = 0;
        index_line = 0;
        for(int i = 0; i < super.ifmap_data.size(); i=i+1) begin
            decompressed_fifo_packet.valid_mask[index_packet] = 1;
            decompressed_fifo_packet.data[index_packet] = super.ifmap_data[i];
            if(index_packet%8 == 7) begin
                decompressed_fifo_packet.packet_valid = 1'b1;
                super.ifmap_buffer_payload_set.push_back(decompressed_fifo_packet);
                index_packet = 0;
                decompressed_fifo_packet = 0;
                index_line = index_line + 1;
                continue;
            end
            else if(index_line % 227 == 226) begin
                decompressed_fifo_packet.packet_valid = 1'b1;
                super.ifmap_buffer_payload_set.push_back(decompressed_fifo_packet);
                index_line = 0;
                index_packet = 0;
                continue;
            end
            index_packet = index_packet + 1;
            index_line = index_line + 1;
        end
    endfunction

endclass 

class LAYER23_IFMAP_DATA extends IFMAP_DATA;

    function new(LAYER_TYPE layer_type);
        super.new(layer_type);
    endfunction 

    virtual function void payload_generation();
        int index_packet;
        DECOMRPESS_FIFO_PACKET decompressed_fifo_packet;
        decompressed_fifo_packet = 0;
        index_packet = 0;
        for(int i = 0; i < super.ifmap_data.size(); i=i+1) begin
            decompressed_fifo_packet.valid_mask[index_packet] = 1;
            decompressed_fifo_packet.data[index_packet] = super.ifmap_data[i];
            if(index_packet%8 == 7) begin
                decompressed_fifo_packet.packet_valid = 1'b1;
                super.ifmap_buffer_payload_set.push_back(decompressed_fifo_packet);
                index_packet = 0;
                decompressed_fifo_packet = 0;
                continue;
            end
            index_packet = index_packet + 1;
        end
        decompressed_fifo_packet.packet_valid = 1'b1;
        super.ifmap_buffer_payload_set.push_back(decompressed_fifo_packet);
    endfunction

endclass


class STIMULUS;
    rand bit decompressor_ack;
    rand bit free_ifmap_buffer;
    bit ifmap_buffer_req;
    DECOMRPESS_FIFO_PACKET decompressed_fifo_packet;
    DECOMRPESS_FIFO_PACKET ifmap_buffer_payload_set [$];
    int index;

    function new(DECOMRPESS_FIFO_PACKET ifmap_buffer_payload_set [$]);
        this.ifmap_buffer_payload_set = ifmap_buffer_payload_set; 
        this.ifmap_buffer_req = 1'b0; 
        this.index = 0; 
    endfunction

    constraint ack{
        decompressor_ack dist {0:=2,1:=8};
        index >= this.ifmap_buffer_payload_set.size() -> decompressor_ack == 0;
    };

    function void update_ifmap_buffer_req(bit ifmap_buffer_req);
        this.ifmap_buffer_req = ifmap_buffer_req;
    endfunction

    function void post_randomize();
        if(index >= this.ifmap_buffer_payload_set.size()) begin
            decompressed_fifo_packet = 0;
        end
        else begin
            decompressed_fifo_packet = this.ifmap_buffer_payload_set[index]; 
        end
        if(decompressor_ack & ifmap_buffer_req) begin
            index = index + 1;
        end
    endfunction
endclass

class SCOREBOARD;
    logic [`MEM_BATCH_SIZE-1:0][256-1:0][7:0] memory_batch1;
    logic [`MEM_BATCH_SIZE-1:0][256-1:0][7:0] memory_batch2;


    
endclass