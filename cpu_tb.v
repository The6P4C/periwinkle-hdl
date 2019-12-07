module cpu_tb;
	reg clk;

	cpu UUT (
		.i_clk(clk)
	);

	wire [31:0] reg_gprs0 = UUT.reg_gprs[0];
	wire [31:0] reg_gprs1 = UUT.reg_gprs[1];
	wire [31:0] reg_gprs2 = UUT.reg_gprs[2];
	wire [31:0] reg_gprs3 = UUT.reg_gprs[3];
	wire [31:0] reg_gprs4 = UUT.reg_gprs[4];
	wire [31:0] reg_gprs5 = UUT.reg_gprs[5];
	wire [31:0] reg_gprs6 = UUT.reg_gprs[6];
	wire [31:0] reg_gprs7 = UUT.reg_gprs[7];
	wire [31:0] reg_gprs8 = UUT.reg_gprs[8];
	wire [31:0] reg_gprs9 = UUT.reg_gprs[9];
	wire [31:0] reg_gprs10 = UUT.reg_gprs[10];
	wire [31:0] reg_gprs11 = UUT.reg_gprs[11];
	wire [31:0] reg_gprs12 = UUT.reg_gprs[12];
	wire [31:0] reg_gprs13 = UUT.reg_gprs[13];
	wire [31:0] reg_gprs14 = UUT.reg_gprs[14];
	wire [31:0] reg_gprs15 = UUT.reg_gprs[15];
	wire [31:0] reg_gprs16 = UUT.reg_gprs[16];
	wire [31:0] reg_gprs17 = UUT.reg_gprs[17];
	wire [31:0] reg_gprs18 = UUT.reg_gprs[18];
	wire [31:0] reg_gprs19 = UUT.reg_gprs[19];
	wire [31:0] reg_gprs20 = UUT.reg_gprs[20];
	wire [31:0] reg_gprs21 = UUT.reg_gprs[21];
	wire [31:0] reg_gprs22 = UUT.reg_gprs[22];
	wire [31:0] reg_gprs23 = UUT.reg_gprs[23];
	wire [31:0] reg_gprs24 = UUT.reg_gprs[24];
	wire [31:0] reg_gprs25 = UUT.reg_gprs[25];
	wire [31:0] reg_gprs26 = UUT.reg_gprs[26];
	wire [31:0] reg_gprs27 = UUT.reg_gprs[27];
	wire [31:0] reg_gprs28 = UUT.reg_gprs[28];
	wire [31:0] reg_gprs29 = UUT.reg_gprs[29];
	wire [31:0] reg_gprs30 = UUT.reg_gprs[30];
	wire [31:0] reg_gprs31 = UUT.reg_gprs[31];
	initial begin
		$dumpfile("cpu_tb.vcd");
		$dumpvars(0, cpu_tb);

		repeat (50) begin
			clk = 0;
			#1;
			clk = 1;
			#1;
		end

		$finish;
	end
endmodule
