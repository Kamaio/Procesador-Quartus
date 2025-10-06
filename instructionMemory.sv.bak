module instructionMemory(
  input wire [31:0] PC,

  output wire [31:0] instruccion
);

	reg [31:0] instrucciones [0:127];
	
	assign instruccion = instrucciones[PC/4];
	

endmodule
