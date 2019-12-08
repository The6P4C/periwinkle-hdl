module top(
	input CLK,

	output PIN_2,
	output PIN_3,
	output PIN_4,
	output PIN_5,
	output PIN_6,
	output PIN_7,
	output PIN_8,
	output PIN_9,
);
	wire [7:0] gpio;

	cpu CPU (
		.i_clk(CLK),

		.o_gpio(gpio)
	);

	assign {
		PIN_2, PIN_3, PIN_4, PIN_5, PIN_6, PIN_7, PIN_8, PIN_9
	} = gpio;
endmodule
