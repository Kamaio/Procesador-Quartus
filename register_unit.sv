module register_unit(
	input  wire        clk,
	input  wire [4:0]  rs1,
	input  wire [4:0]  rs2,
	input  wire [4:0]  rd,
	input  wire        RUWr,
	input  wire [31:0] resultadoALU,  //alu y dat memory(i carga)
	
	output wire [31:0] output_rs1,
	output wire [31:0] output_rs2,
	
	
	output wire [31:0] registrosVGA [31:0]
);

  reg [31:0] Registros [31:0];
  assign memoryR1   = Registros[1];//vga
  assign memoryR2   = Registros[2];
  assign memoryR3   = Registros[3];
  assign memoryR4   = Registros[4];
  assign memoryR5   = Registros[5];
  assign memoryR6   = Registros[6];
  assign memoryR7   = Registros[7];
  assign memoryR8   = Registros[8];
  assign memoryR9   = Registros[9];
  assign memoryR10  = Registros[10];
  assign memoryR11  = Registros[11];
  assign memoryR12  = Registros[12];
  assign memoryR13  = Registros[13];
  assign memoryR14  = Registros[14];
  assign memoryR15  = Registros[15];
  assign memoryR16  = Registros[16];
  assign memoryR17  = Registros[17];
  assign memoryR18  = Registros[18];
  assign memoryR19  = Registros[19];
  assign memoryR20  = Registros[20];
  assign memoryR21  = Registros[21];
  assign memoryR22  = Registros[22];
  assign memoryR23  = Registros[23];
  assign memoryR24  = Registros[24];
  assign memoryR25  = Registros[25];
  assign memoryR26  = Registros[26];
  assign memoryR27  = Registros[27];
  assign memoryR28  = Registros[28];
  assign memoryR29  = Registros[29];
  assign memoryR30  = Registros[30];
  assign memoryR31  = Registros[31];

  

  // lecturas asíncronas
  assign output_rs1 = Registros[rs1];
  assign output_rs2 = Registros[rs2];


  // escritura síncrona
  always @(posedge clk) begin

    if (RUWr && rd != 5'd0)
      Registros[rd] <= resultadoALU;
    
  end
  
  assign registrosVGA = Registros;

endmodule
