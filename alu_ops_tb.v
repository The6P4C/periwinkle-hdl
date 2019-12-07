
`default_nettype none

module alu_ops_tb;
	reg clk;

	reg data_valid;
	reg [31:0] data;

	reg result_ready;

	wire result_valid_plus;
	wire [31:0] result_plus;
	alu_op_cell_plus UUT_plus (
		.i_clk(clk),

		.i_data_valid(data_valid),
		.i_data(data),

		.i_result_ready(result_ready),
		.o_result_valid(result_valid_plus),
		.o_result(result_plus)
	);

	wire result_valid_and;
	wire [31:0] result_and;
	alu_op_cell_and UUT_and (
		.i_clk(clk),

		.i_data_valid(data_valid),
		.i_data(data),

		.i_result_ready(result_ready),
		.o_result_valid(result_valid_and),
		.o_result(result_and)
	);

	wire result_valid_or;
	wire [31:0] result_or;
	alu_op_cell_or UUT_or (
		.i_clk(clk),

		.i_data_valid(data_valid),
		.i_data(data),

		.i_result_ready(result_ready),
		.o_result_valid(result_valid_or),
		.o_result(result_or)
	);

	wire result_valid_xor;
	wire [31:0] result_xor;
	alu_op_cell_xor UUT_xor (
		.i_clk(clk),

		.i_data_valid(data_valid),
		.i_data(data),

		.i_result_ready(result_ready),
		.o_result_valid(result_valid_xor),
		.o_result(result_xor)
	);

	initial begin
		$dumpfile("alu_ops_tb.vcd");
		$dumpvars(0, alu_ops_tb);

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
