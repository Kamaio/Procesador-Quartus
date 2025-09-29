module top_level(
input wire clk,
input wire rst_n,
output wire [9:0] leds,
output wire[6:0] display0,
output wire[6:0] display1,
output wire[6:0] display2,
output wire[6:0] display3,
output wire[6:0] display4,
output wire[6:0] display5
);

wire [31:0] nextPC;
wire [31:0] address;


sumador sumar(
	//.clk(clk),
	.address(address),
	.nextPC(nextPC)
);


pc pcInst(
	.clk(clk),
	.rst_n(rst_n),
	.nextPC(nextPC),
	.address(address)
);


hex7seg displayN0(
	.val(address[3:0]),
	.display(display0)
);
hex7seg displayN1(
	.val(address[7:4]),
	.display(display1)
);
hex7seg displayN2(
	.val(address[11:8]),
	.display(display2)
);
hex7seg displayN3(
	.val(address[15:12]),
	.display(display3)
);
hex7seg displayN4(
	.val(address[19:16]),
	.display(display4)
);
hex7seg displayN5(
	.val(address[23:20]),
	.display(display5)
);



assign leds = 10'b1010101010;


endmodule





