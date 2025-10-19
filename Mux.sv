module Mux(
  input  wire [31:0] A,
  input  wire [31:0] B,
  input  wire        C,
  output reg  [31:0] decidido
);


	always @(*) begin
		decidido = C ? B : A;
	end
	
endmodule