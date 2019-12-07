module cpu(
	input i_clk
);
	reg [39:0] progmem [0:255];
	initial $readmemb("progmem.txt", progmem);

	parameter SPR_PC = 0;
	parameter SPR_SIZ = 8;
	parameter SPR_SINZ = 9;
	reg [31:0] reg_pc = 32'b0;

	reg [31:0] reg_gprs [0:31];

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
	reg [31:0] source_value;

	always @(*) begin
		if (!instr_transfer) begin
			source_value = instr_source_literal;
		end else begin
			if (instr_source_reg_is_spr) begin
				case (instr_source_reg)
					SPR_PC: source_value = reg_pc;
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
		next_pc = reg_pc + 1;

		if (instr_dest_reg_is_spr) begin
			case (instr_dest_reg)
				SPR_SIZ: next_pc = source_value == 32'b0
					? next_pc_skip : next_pc_no_skip;
				SPR_SINZ: next_pc = source_value != 32'b0
					? next_pc_skip : next_pc_no_skip;
			endcase
		end
	end

	always @(posedge i_clk) begin
		if (instr_dest_reg_is_spr) begin
			// TODO: Write to SPR
		end else begin
			reg_gprs[instr_dest_reg] <= source_value;
		end

		reg_pc <= next_pc;
	end
endmodule
