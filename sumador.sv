module sumador(
//input clk,
input wire [31:0] address,
output reg [31:0] nextPC
);

//always @(posedge clk) nextPC <= address+32'h4;
assign nextPC = address + 32'h4;


endmodule