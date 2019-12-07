`default_nettype none

module alu_op_cell_tb;
	reg clk;

	reg data_valid;
	reg [31:0] data;

	reg result_ready;
	wire result_valid;
	wire [31:0] result;

	wire [31:0] op_a;
	wire [31:0] op_b;
	wire [31:0] op_result = op_a & op_b;

	alu_op_cell UUT (
		.i_clk(clk),

		.i_data_valid(data_valid),
		.i_data(data),

		.i_result_ready(result_ready),
		.o_result_valid(result_valid),
		.o_result(result),

		.o_op_a(op_a),
		.o_op_b(op_b),
		.i_op_result(op_result)
	);

	initial begin
		$dumpfile("alu_op_cell_tb.vcd");
		$dumpvars(0, alu_op_cell_tb);

		// reset condition
		data_valid = 0;
		data = 32'b0;
		result_ready = 0;

		// clock in 32'b11011
		data_valid = 1;
		data = 32'b11011;
		clk = 0; #2; clk = 1; #1;

		// clock in 32'b01110
		data_valid = 1;
		data = 32'b01110;
		#1; clk = 0; #2; clk = 1; #1;

		// clock out the result, empty the op cell
		data_valid = 0;
		result_ready = 1;
		#1; clk = 0; #2; clk = 1; #1;
		result_ready = 0;

		// clock in 32'b111111
		data_valid = 1;
		data = 32'b111111;
		#1; clk = 0; #2; clk = 1; #1;

		// clock in 32'b111000
		data_valid = 1;
		data = 32'b111000;
		#1; clk = 0; #2; clk = 1; #1;

		// clock in 32'b011000
		data_valid = 1;
		data = 32'b011000;
		#1; clk = 0; #2; clk = 1; #1;

		// clock out the result, empty the op cell
		data_valid = 0;
		result_ready = 1;
		#1; clk = 0; #2; clk = 1; #1;
		result_ready = 0;

		$finish;
	end
endmodule
