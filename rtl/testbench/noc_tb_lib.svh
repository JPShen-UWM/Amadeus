`include "sv/sys_defs.svh"
class MEMORY_BATCH_DATA;

    rand bit [34:0][255:0][7:0] memory_batch;
    bit [34:0][255:0][7:0] memory_batch_golden;
    
    function void display_raw();
        $display("============================  MEMORY BATCH DATA ============================");
        for(int i = 0; i < 35; i=i+1) begin
            for(int j = 0; j < 256; j=j+1) begin
                $write("%d ",memory_batch[i][j]);
            end
            $write("\n");
        end
    endfunction

     function void display_raw_golden();
        $display("============================  MEMORY BATCH GOLDEN DATA ============================");
        for(int i = 0; i < 35; i=i+1) begin
            for(int j = 0; j < 256; j=j+1) begin
                $write("%d ",memory_batch_golden[i][j]);
            end
            $write("\n");
        end
    endfunction

    virtual function void update_memory_batch_golden();
        memory_batch_golden = memory_batch;
    endfunction

    function void post_randomize();
        update_memory_batch_golden();
    endfunction

endclass

class MEMORY_BATCH_DATA_LAYER2 extends MEMORY_BATCH_DATA;
    constraint line {
        foreach(super.memory_batch[i]){
            if(i > 26) {
                super.memory_batch[i] == 0;
            }
        }
    }

    constraint element {
        foreach(super.memory_batch[i]){
            foreach(memory_batch[i][j]){
                if(j > 26) {
                    super.memory_batch[i][j] == 0;
                }
            }
        }
    }

    virtual function void update_memory_batch_golden();
            for(integer i = 0; i < `MEM_BATCH_SIZE; i=i+1) begin
                if(i < 2) begin
                    super.memory_batch_golden[i]  = '0;
                end
                else begin
                    super.memory_batch_golden[i]  = {super.memory_batch[i-2][253:0],{16{1'b0}}};
                end
            end
    endfunction


endclass

class MEMORY_BATCH_DATA_LAYER3 extends MEMORY_BATCH_DATA;
    constraint line {
        foreach(super.memory_batch[i]){
            if(i > 12) {
                super.memory_batch[i] == 0;
            }
        }
    }

    constraint element {
        foreach(super.memory_batch[i]){
            foreach(memory_batch[i][j]){
                if(j > 12) {
                    super.memory_batch[i][j] == 0;
                }
            }
        }
    }

    virtual function void update_memory_batch_golden();
        for(integer i = 0; i < `MEM_BATCH_SIZE; i=i+1) begin
            if(i < 1) begin
                super.memory_batch_golden[i]  = '0;
            end
            else begin
                super.memory_batch_golden[i]  = {super.memory_batch[i-1][254:0],{8{1'b0}}};
            end
        end
    endfunction

endclass

class PE_FULL_GEN;
    bit [5:0][6:0] pe_full;
    randc bit[2:0] row,column;
    int index;

    function void gen_mode1_last_iteration();
        pe_full = '0;
        for(int i = 0; i < 6; i=i+1) begin
            pe_full[i][6] = 1'b1;
        end
    endfunction

    function void gen_mode2_last_iteration();
        pe_full = '0;
        for(int i = 0; i < 6; i=i+1) begin
            pe_full[i][6] = 1'b1;
        end
        for(int i = 0; i < 7 ; i=i+1) begin
            pe_full[5][i] = 1'b1;
        end
    endfunction

    function void gen_mode3();
        pe_full = '0;
        for(int i = 0; i < 7 ; i=i+1) begin
            pe_full[5][i] = 1'b1;
        end
    endfunction

    function void gen_mode4();
        for(int i = 3; i < 6 ; i=i+1) begin
            pe_full[i][6] = 1'b1;
        end
    endfunction

    constraint inject_full{
        row < 6;
        column < 7;
    }

    function void post_randomize();
        pe_full = '0;
        if(index < 100) begin
            pe_full[row][column] = 1'b1;
            index = index + 1'b1;
        end
    endfunction

endclass