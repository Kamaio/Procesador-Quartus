module instructionMemory(
  input wire [31:0] PC,

  output wire [31:0] instruccion
);

	reg [31:0] instrucciones [0:127];
	
	initial begin
	
		$readmemb("output.bin", instrucciones);
		
	end
	
	assign instruccion = instrucciones[PC/4];
	

endmodule
