`include "sv/sys_defs.svh"
class PSUM_GEN;
    rand logic signed [`PSUM_DATA_SIZE-1:0] psum_random_data[6:0][3:0][54:0];
    PSUM_PACKET [6:0][3:0][54:0] psum_golden;

    function void post_randomize();
        for(int i = 0; i < 7; i=i+1) begin
            for(int j = 0; j < 4; j=j+1) begin
                for(int k = 0 ; k < 55; k=k+1) begin
                    psum_golden[i][j][k].valid = 1'b1;
                    psum_golden[i][j][k].filter_idx = j;
                    psum_golden[i][j][k].psum = psum_random_data[i][j][k];
                end
            end
        end
    endfunction
endclass

class STIMULUS;

    PSUM_PACKET [6:0][3:0][54:0] psum_golden;
    PSUM_PACKET[6:0] psum_packet;

    int index;
    int filter_index;

    function new(PSUM_PACKET [6:0][3:0][54:0] psum_golden);
        this.psum_golden = psum_golden;
        this.index = 0;
        this.filter_index = 0;
    endfunction

    function PSUM_PACKET[6:0] send_psum_packet();
        PSUM_PACKET[6:0] psum_packet;
        for(int i = 0; i < 7; i=i+1) begin
            psum_packet[i] = psum_golden[i][this.filter_index][this.index];
        end
        if(this.filter_index == 3) begin
            this.index = this.index + 1;
            this.filter_index = 0;
        end
        else begin
            this.filter_index = this.filter_index + 1;
        end
        return psum_packet;
    endfunction

endclass