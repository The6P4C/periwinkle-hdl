module cpu(
	input i_clk
);
	reg [39:0] progmem [0:255];
	initial $readmemb("progmem.txt", progmem);

	reg [6:0] i;
	reg [31:0] datamem [0:(2**6-1)];
	initial begin
		for (i = 0; i < 2**6; i = i + 1) begin
			datamem[i] = 0;
		end
	end

	parameter SPR_PC = 0;
	parameter SPR_SIZ = 8;
	parameter SPR_SINZ = 9;
	parameter SPR_REF = 10;
	parameter SPR_DEF = 11;
	parameter SPR_NULL = 12;
	reg [31:0] reg_pc = 32'b0;
	reg [5:0] reg_ref = 6'b0;
	wire [31:0] reg_def = datamem[reg_ref];

	reg [31:0] reg_gprs [0:31];
	initial begin
		reg_gprs[0] = 32'b0;
		reg_gprs[1] = 32'b0;
		reg_gprs[2] = 32'b0;
		reg_gprs[3] = 32'b0;
		reg_gprs[4] = 32'b0;
		reg_gprs[5] = 32'b0;
		reg_gprs[6] = 32'b0;
		reg_gprs[7] = 32'b0;
		reg_gprs[8] = 32'b0;
		reg_gprs[9] = 32'b0;
		reg_gprs[10] = 32'b0;
		reg_gprs[11] = 32'b0;
		reg_gprs[12] = 32'b0;
		reg_gprs[13] = 32'b0;
		reg_gprs[14] = 32'b0;
		reg_gprs[15] = 32'b0;
		reg_gprs[16] = 32'b0;
		reg_gprs[17] = 32'b0;
		reg_gprs[18] = 32'b0;
		reg_gprs[19] = 32'b0;
		reg_gprs[20] = 32'b0;
		reg_gprs[21] = 32'b0;
		reg_gprs[22] = 32'b0;
		reg_gprs[23] = 32'b0;
		reg_gprs[24] = 32'b0;
		reg_gprs[25] = 32'b0;
		reg_gprs[26] = 32'b0;
		reg_gprs[27] = 32'b0;
		reg_gprs[28] = 32'b0;
		reg_gprs[29] = 32'b0;
		reg_gprs[30] = 32'b0;
		reg_gprs[31] = 32'b0;
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
	reg [31:0] source_value;

	always @(*) begin
		if (!instr_transfer) begin
			source_value = instr_source_literal;
		end else begin
			if (instr_source_reg_is_spr) begin
				case (instr_source_reg)
					SPR_PC: source_value = reg_pc;
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
			case (instr_dest_reg)
				SPR_REF: reg_ref <= source_value;
				SPR_DEF: datamem[reg_ref] <= source_value;
			endcase
		end else begin
			reg_gprs[instr_dest_reg] <= source_value;
		end

		reg_pc <= next_pc;
	end
endmodule
