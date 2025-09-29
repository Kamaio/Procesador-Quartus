module pc(
input clk,
input wire rst_n,
input wire [31:0] nextPC,
output reg [31:0] address
);

always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		address <= 32'h0;
	else
		address <= nextPC;
end


endmodule