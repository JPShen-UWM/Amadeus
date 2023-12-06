# make          <- runs simv (after compiling simv if needed)
# make simv     <- compiles simv without running
# make dve      <- runs GUI debugger (after compiling it if needed)
# make syn      <- runs syn_simv (after synthesizing if needed then 
#                                 compiling syn_simv if needed)
# make clean    <- remove files created during compilations (but not synthesis)
# make nuke     <- remove all files created during compilation and synthesis
#
# To compile additional files, add them to the TESTBENCH or SIMFILES as needed
# Every .vg file will need its own rule and one or more synthesis scripts
# The information contained here (in the rules for those vg files) will be 
# similar to the information in those scripts but that seems hard to avoid.
#

VCS = SW_VCS=2020.12-SP2-1 vcs -sverilog +vc -Mupdate -line -full64 +define+DV
LIB = /afs/umich.edu/class/eecs470/lib/verilog/lec25dscc25.v

all:	simv
	./simv | tee program.out

##### 
# Modify starting here
#####
HEADERS = sv/sys_defs.svh
PRIMITIVES = $(wildcard primitive/*.sv)
TESTBENCH = testbench/NOC_tb.sv
SIMFILES = sv/decompressor.sv sv/countones.sv sv/priority_encoder.sv sv/ifmap_buffer.sv sv/NOC.sv sv/psum_buffer.sv sv/fifo.sv

SYNFILES = pe.vg

export HEADERS
export SIMFILES

#####
# Should be no need to modify after here
#####
simv:	$(HEADERS) $(SIMFILES) $(PRIMITIVES) $(TESTBENCH)
	$(VCS) $(HEADERS) $(TESTBENCH) $(SIMFILES) $(PRIMITIVES) -o simv | tee simv.log

dve:	$(HEADERS) $(SIMFILES) $(PRIMITIVES) $(TESTBENCH)
	$(VCS) $(HEADERS) $(TESTBENCH) $(SIMFILES) $(PRIMITIVES) -o dve -R -gui -debug_acccess+all -kdb | tee dve.log

.PHONY: dve

$(SYNFILES): my_waveform_gen.sv tut_synth.tcl
	dc_shell-t -f tut_synth.tcl | tee synth.out

syn_simv:	$(HEADERS) $(SYNFILES) $(TESTBENCH)
	$(VCS) $(HEADERS) $(TESTBENCH) $(SYNFILES) $(LIB) -o syn_simv | tee syn_simv.log

syn:	syn_simv
	./syn_simv | tee syn_program.out | tee syn.log

clean:
	rm -rvf simv *.daidir csrc vcs.key program.out \
	syn_simv syn_simv.daidir syn_program.out \
	dve *.vpd *.vcd *.dump ucli.key \
        inter.fsdb novas* verdiLog	

nuke:	clean
	rm -rvf *.vg *.rep *.db *.chk *.log *.out *.ddc *.svf DVEfiles/