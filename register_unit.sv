module register_unit(
	input  wire        clk,
	input  wire [4:0]  rs1,
	input  wire [4:0]  rs2,
	input  wire [4:0]  rd,
	input  wire        RUWr,
	input wire [31:0] resultadoALU,
	
	output wire [31:0] output_rs1,
	output wire [31:0] output_rs2
  
);

  reg [31:0] Registros [31:0];
  

  // lecturas asíncronas
  assign output_rs1 = Registros[rs1];
  assign output_rs2 = Registros[rs2];


  // escritura síncrona
  always @(posedge clk) begin

    if (RUWr && rd != 5'd0)
      Registros[rd] <= resultadoALU;
    
  end

endmodule
