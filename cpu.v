`default_nettype none

module cpu(
	input i_clk
);
	reg [39:0] progmem [0:255];
	initial $readmemb("progmem.txt", progmem);

	reg [6:0] i;
	reg [31:0] datamem [0:(2**6-1)];
	initial begin
		for (i = 0; i < 2**6; i = i + 1) begin
			datamem[i] = 32'b0;
		end
	end

	reg [1:0] alu_input_op;

	reg alu_data_valid;
	reg [31:0] alu_data;

	reg [1:0] alu_output_op;

	reg alu_result_empty;
	wire alu_result_valid;
	wire [31:0] alu_result;
	wire [4:0] alu_result_flags;

	alu ALU (
		.i_clk(i_clk),

		.i_input_op(alu_input_op),

		.i_data_valid(alu_data_valid),
		.i_data(alu_data),

		.i_output_op(alu_output_op),

		.i_result_empty(alu_result_empty),
		.o_result_valid(alu_result_valid),
		.o_result(alu_result),
		.o_result_flags(alu_result_flags)
	);

	parameter SPR_PC = 0;
	parameter SPR_STATUS = 1;
	parameter SPR_RNG = 3;
	parameter SPR_ALU_OPS_XMASK = 4'b1xx;
	parameter SPR_SIZ = 8;
	parameter SPR_SINZ = 9;
	parameter SPR_REF = 10;
	parameter SPR_DEF = 11;
	parameter SPR_NULL = 12;
	reg [31:0] reg_pc = 32'b0;
	reg [4:0] reg_status = 5'b0;
	reg [31:0] reg_rng = 32'b0;
	reg [5:0] reg_ref = 6'b0;
	wire [31:0] reg_def = datamem[reg_ref];

	reg [31:0] reg_gprs [0:31];
	initial begin
		for (i = 0; i < 32; i = i + 1) begin
			reg_gprs[i] = 32'b0;
		end
	end

	/*
	 * Instruction decoding
	 */
	wire [39:0] instr = progmem[reg_pc];

	wire instr_transfer = instr[39];
	wire [31:0] instr_source = instr[37:6];
	wire [5:0] instr_dest = instr[5:0];

	wire instr_dest_reg_is_spr = !instr_dest[5];
	wire [4:0] instr_dest_reg = instr_dest[4:0];

	// Valid only if transfer == 1'b0
	wire [31:0] instr_source_literal = instr_source;

	// Valid only if transfer == 1b'1
	wire instr_source_reg_is_spr = !instr_source[5];
	wire [4:0] instr_source_reg = instr_source[4:0];

	/*
	 * Source value calculation
	 */
	reg rng_next;

	reg [31:0] source_value;

	always @(*) begin
		rng_next = 1'b0;

		alu_output_op = 2'b0;
		alu_result_empty = 1'b0;

		if (!instr_transfer) begin
			source_value = instr_source_literal;
		end else begin
			if (instr_source_reg_is_spr) begin
				casex (instr_source_reg)
					SPR_PC: source_value = reg_pc;
					SPR_STATUS: source_value = reg_status;
					SPR_RNG: begin
						source_value = reg_rng;
						rng_next = 1'b1;
					end
					SPR_ALU_OPS_XMASK: begin
						alu_output_op = instr_source_reg[1:0];
						alu_result_empty = 1'b1;

						source_value = alu_result;
					end
					SPR_REF: source_value = reg_ref;
					SPR_DEF: source_value = reg_def;
					SPR_NULL: source_value = 0;
					default: source_value = 0;
				endcase
			end else begin
				source_value = reg_gprs[instr_source_reg];
			end
		end
	end

	/*
	 * Destination writeback
	 */
	wire [31:0] next_pc_no_skip = reg_pc + 1;
	wire [31:0] next_pc_skip = reg_pc + 2;

	reg [31:0] next_pc;
	always @(*) begin
		alu_input_op = 2'b0;
		alu_data_valid = 1'b0;
		alu_data = 32'b0;

		next_pc = reg_pc + 1;

		if (instr_dest_reg_is_spr) begin
			casex (instr_dest_reg)
				SPR_PC: next_pc = source_value;
				SPR_ALU_OPS_XMASK: begin
					alu_input_op = instr_dest_reg[1:0];
					alu_data_valid = 1'b1;
					alu_data = source_value;
				end
				SPR_SIZ: next_pc = source_value == 32'b0
					? next_pc_skip : next_pc_no_skip;
				SPR_SINZ: next_pc = source_value != 32'b0
					? next_pc_skip : next_pc_no_skip;
			endcase
		end
	end

	wire rng_next_bit = ^(reg_rng & 32'h800007D8);
	always @(posedge i_clk) begin
		if (instr_dest_reg_is_spr) begin
			case (instr_dest_reg)
				SPR_RNG: reg_rng <= source_value;
				SPR_REF: reg_ref <= source_value;
				SPR_DEF: datamem[reg_ref] <= source_value;
			endcase
		end else begin
			reg_gprs[instr_dest_reg] <= source_value;
		end

		reg_pc <= next_pc;
		if (alu_result_valid) begin
			reg_status <= {27'b0, alu_result_flags};
		end
		if (rng_next) begin
			reg_rng <= {rng_next_bit, reg_rng[31:1]};
		end
	end
endmodule
