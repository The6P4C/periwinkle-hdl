`default_nettype none

module alu_op_cell(
	input i_clk,

	input i_data_valid,
	input [31:0] i_data,

	input i_result_ready,
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
		end else if (i_result_ready && o_result_valid) begin
			op_cell <= {1'b0, 32'b0};
		end
	end
endmodule
