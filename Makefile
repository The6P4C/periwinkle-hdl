VVP:=vvp
IVERILOG:=iverilog

IVERILOG_IVL:=C:\\Users\\The6P4C\\.apio\\packages\\toolchain-iverilog\\lib\\ivl
IVERILOG_LIB:=C:\\Users\\The6P4C\\.apio\\packages\\toolchain-iverilog\\vlib\\cells_sim.v

sim_cpu: cpu_tb.vcd

sim_alu_op_cell: alu_op_cell_tb.vcd

sim_alu_ops: alu_ops_tb.vcd

clean:
	rm -f cpu_tb.vcd cpu_tb.out

cpu_tb.vcd: cpu_tb.out
	$(VVP) -M $(IVERILOG_IVL) $^

cpu_tb.out: alu.v cpu.v cpu_tb.v progmem.txt
	$(IVERILOG) -B $(IVERILOG_IVL) -o $@ -D VCD_OUTPUT=cpu_tb.vcd $(IVERILOG_LIB) alu.v cpu.v cpu_tb.v

progmem.txt: assemble.py prog.txt
	python assemble.py prog.txt progmem.txt

alu_op_cell_tb.vcd: alu_op_cell_tb.out
	$(VVP) -M $(IVERILOG_IVL) $^

alu_op_cell_tb.out: alu.v alu_op_cell_tb.v
	$(IVERILOG) -B $(IVERILOG_IVL) -o $@ -D VCD_OUTPUT=alu_op_cell_tb.vcd $(IVERILOG_LIB) alu.v alu_op_cell_tb.v

alu_ops_tb.vcd: alu_ops_tb.out
	$(VVP) -M $(IVERILOG_IVL) $^

alu_ops_tb.out: alu.v alu_ops_tb.v
	$(IVERILOG) -B $(IVERILOG_IVL) -o $@ -D VCD_OUTPUT=alu_ops_tb.vcd $(IVERILOG_LIB) alu.v alu_ops_tb.v

.PHONY: sim_cpu sim_alu_op_cell sim_alu_ops clean
