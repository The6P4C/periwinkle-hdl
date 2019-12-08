`default_nettype none

module alu_op_cell(
	input i_clk,

	input i_data_valid,
	input [31:0] i_data,

	input i_result_empty,
	output o_result_valid,
	output [31:0] o_result,

	output [31:0] o_op_a,
	output [31:0] o_op_b,
	input [31:0] i_op_result
);
	reg [32:0] op_cell = {1'b0, 32'b0};
	wire op_cell_empty = !op_cell[32];
	wire [31:0] op_cell_value = op_cell[31:0];

	assign o_result_valid = !op_cell_empty;
	assign o_result = op_cell_value;

	assign o_op_a = i_data;
	assign o_op_b = op_cell_value;

	always @(posedge i_clk) begin
		if (i_data_valid) begin
			if (op_cell_empty) begin
				op_cell <= {1'b1, i_data};
			end else begin
				op_cell <= {1'b1, i_op_result};
			end
		end else if (i_result_empty && o_result_valid) begin
			op_cell <= {1'b0, 32'b0};
		end
	end
endmodule

module alu_op_cell_plus(
	input i_clk,

	input i_data_valid,
	input [31:0] i_data,

	input i_result_empty,
	output o_result_valid,
	output [31:0] o_result
);
	wire [31:0] op_a;
	wire [31:0] op_b;
	wire [31:0] op_result = op_a + op_b;

	alu_op_cell UUT (
		.i_clk(i_clk),

		.i_data_valid(i_data_valid),
		.i_data(i_data),

		.i_result_empty(i_result_empty),
		.o_result_valid(o_result_valid),
		.o_result(o_result),

		.o_op_a(op_a),
		.o_op_b(op_b),
		.i_op_result(op_result)
	);
endmodule

module alu_op_cell_and(
	input i_clk,

	input i_data_valid,
	input [31:0] i_data,

	input i_result_empty,
	output o_result_valid,
	output [31:0] o_result
);
	wire [31:0] op_a;
	wire [31:0] op_b;
	wire [31:0] op_result = op_a & op_b;

	alu_op_cell UUT (
		.i_clk(i_clk),

		.i_data_valid(i_data_valid),
		.i_data(i_data),

		.i_result_empty(i_result_empty),
		.o_result_valid(o_result_valid),
		.o_result(o_result),

		.o_op_a(op_a),
		.o_op_b(op_b),
		.i_op_result(op_result)
	);
endmodule

module alu_op_cell_or(
	input i_clk,

	input i_data_valid,
	input [31:0] i_data,

	input i_result_empty,
	output o_result_valid,
	output [31:0] o_result
);
	wire [31:0] op_a;
	wire [31:0] op_b;
	wire [31:0] op_result = op_a | op_b;

	alu_op_cell UUT (
		.i_clk(i_clk),

		.i_data_valid(i_data_valid),
		.i_data(i_data),

		.i_result_empty(i_result_empty),
		.o_result_valid(o_result_valid),
		.o_result(o_result),

		.o_op_a(op_a),
		.o_op_b(op_b),
		.i_op_result(op_result)
	);
endmodule

module alu_op_cell_xor(
	input i_clk,

	input i_data_valid,
	input [31:0] i_data,

	input i_result_empty,
	output o_result_valid,
	output [31:0] o_result
);
	wire [31:0] op_a;
	wire [31:0] op_b;
	wire [31:0] op_result = op_a ^ op_b;

	alu_op_cell UUT (
		.i_clk(i_clk),

		.i_data_valid(i_data_valid),
		.i_data(i_data),

		.i_result_empty(i_result_empty),
		.o_result_valid(o_result_valid),
		.o_result(o_result),

		.o_op_a(op_a),
		.o_op_b(op_b),
		.i_op_result(op_result)
	);

endmodule

module alu(
	input i_clk,

	input [1:0] i_input_op,

	input i_data_valid,
	input [31:0] i_data,

	input [1:0] i_output_op,

	input i_result_empty,
	output reg o_result_valid,
	output reg [31:0] o_result,
	output [4:0] o_result_flags
);
	parameter OP_PLUS = 2'b00;
	parameter OP_AND = 2'b01;
	parameter OP_OR = 2'b10;
	parameter OP_XOR = 2'b11;

	reg data_valid_plus;
	reg result_empty_plus;
	wire result_valid_plus;
	wire [31:0] result_plus;
	alu_op_cell_plus UUT_plus (
		.i_clk(i_clk),

		.i_data_valid(data_valid_plus),
		.i_data(i_data),

		.i_result_empty(result_empty_plus),
		.o_result_valid(result_valid_plus),
		.o_result(result_plus)
	);

	reg data_valid_and;
	reg result_empty_and;
	wire result_valid_and;
	wire [31:0] result_and;
	alu_op_cell_and UUT_and (
		.i_clk(i_clk),

		.i_data_valid(data_valid_and),
		.i_data(i_data),

		.i_result_empty(result_empty_and),
		.o_result_valid(result_valid_and),
		.o_result(result_and)
	);

	reg data_valid_or;
	reg result_empty_or;
	wire result_valid_or;
	wire [31:0] result_or;
	alu_op_cell_or UUT_or (
		.i_clk(i_clk),

		.i_data_valid(data_valid_or),
		.i_data(i_data),

		.i_result_empty(result_empty_or),
		.o_result_valid(result_valid_or),
		.o_result(result_or)
	);

	reg data_valid_xor;
	reg result_empty_xor;
	wire result_valid_xor;
	wire [31:0] result_xor;
	alu_op_cell_xor UUT_xor (
		.i_clk(i_clk),

		.i_data_valid(data_valid_xor),
		.i_data(i_data),

		.i_result_empty(result_empty_xor),
		.o_result_valid(result_valid_xor),
		.o_result(result_xor)
	);

	/*
	 * Input muxing
	 */
	always @(*) begin
		data_valid_plus = i_data_valid && i_input_op == OP_PLUS;
		data_valid_and = i_data_valid && i_input_op == OP_AND;
		data_valid_or = i_data_valid && i_input_op == OP_OR;
		data_valid_xor = i_data_valid && i_input_op == OP_XOR;
	end

	/*
	 * Output muxing
	 */
	always @(*) begin
		result_empty_plus = i_result_empty && i_output_op == OP_PLUS;
		result_empty_and = i_result_empty && i_output_op == OP_AND;
		result_empty_or = i_result_empty && i_output_op == OP_OR;
		result_empty_xor = i_result_empty && i_output_op == OP_XOR;

		case (i_output_op)
			OP_PLUS: begin
				o_result_valid = result_valid_plus;
				o_result = result_plus;
			end
			OP_AND: begin
				o_result_valid = result_valid_and;
				o_result = result_and;
			end
			OP_OR: begin
				o_result_valid = result_valid_or;
				o_result = result_or;
			end
			OP_XOR: begin
				o_result_valid = result_valid_xor;
				o_result = result_xor;
			end
		endcase
	end

	assign o_result_flags = {
		^o_result, // parity
		~|o_result, // zero
		1'b0, // overflow TODO: implement for OP_PLUS
		o_result[31], // negative
		1'b0 // carry TODO: implement for OP_PLUS
	};
endmodule
