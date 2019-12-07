VVP:=vvp
IVERILOG:=iverilog

IVERILOG_IVL:=C:\\Users\\The6P4C\\.apio\\packages\\toolchain-iverilog\\lib\\ivl
IVERILOG_LIB:=C:\\Users\\The6P4C\\.apio\\packages\\toolchain-iverilog\\vlib\\cells_sim.v

sim_cpu: cpu_tb.vcd

sim_alu_op_cell: alu_op_cell_tb.vcd

clean:
	rm -f cpu_tb.vcd cpu_tb.out

cpu_tb.vcd: cpu_tb.out
	$(VVP) -M $(IVERILOG_IVL) $^

cpu_tb.out: cpu.v cpu_tb.v progmem.txt
	$(IVERILOG) -B $(IVERILOG_IVL) -o $@ -D VCD_OUTPUT=cpu_tb.vcd $(IVERILOG_LIB) cpu.v cpu_tb.v

alu_op_cell_tb.vcd: alu_op_cell_tb.out
	$(VVP) -M $(IVERILOG_IVL) $^

alu_op_cell_tb.out: alu.v alu_op_cell_tb.v
	$(IVERILOG) -B $(IVERILOG_IVL) -o $@ -D VCD_OUTPUT=alu_op_cell_tb.vcd $(IVERILOG_LIB) alu.v alu_op_cell_tb.v

.PHONY: sim_cpu sim_alu_op_cell clean
