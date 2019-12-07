module cpu(
	input i_clk
);
	reg [39:0] progmem [0:255];
	initial $readmemb("progmem.txt", progmem);

	reg [31:0] reg_pc = 32'b0;
	reg [31:0] reg_gprs [0:31];

	/*
	 * Instruction decoding
	 */
	reg [39:0] instr;

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
				// TODO: Read SPR
				source_value = 0;
			end else begin
				source_value = reg_gprs[instr_source_reg];
			end
		end
	end

	/*
	 * Destination writeback
	 */
	always @(posedge i_clk) begin
		if (instr_dest_reg_is_spr) begin
			// TODO: Write SPR
		end else begin
			reg_gprs[instr_dest_reg] <= source_value;
		end
	end

	/*
	 * Program counter processing
	 */
	always @(posedge i_clk) begin
		instr <= progmem[reg_pc];
		reg_pc <= reg_pc + 1;
	end
endmodule
