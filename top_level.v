module top_level(
  input  wire        clk,
  input  wire        rst_n,
  output wire [9:0]  leds,
  output wire [6:0]  display0,
  output wire [6:0]  display1,
  output wire [6:0]  display2,
  output wire [6:0]  display3,
  output wire [6:0]  display4,
  output wire [6:0]  display5
);

  //PC
  wire [31:0] pc;
  wire [31:0] nextPC;
  
  
  //Salidas Instruction memory
  wire [31:0] inst;
  
	
  //instrucciones partidas para tipo r
  wire [6:0] opcode = inst[6:0];
  wire [4:0] rd     = inst[11:7];
  wire [2:0] funct3 = inst[14:12];
  wire [4:0] rs1    = inst[19:15];
  wire [4:0] rs2    = inst[24:20];
  wire [6:0] funct7 = inst[31:25];
  
  
  
  wire [11:0] imm;
  //instrucciones partidas para tipo i
  wire [6:0] opcodeI = inst[6:0];
  wire [4:0] rdI     = inst[11:7];
  wire [2:0] funct3I = inst[14:12];
  wire [4:0] rs1I    = inst[19:15];
  
  
  
  //Salidas control unit
  wire RUWr;
  wire [2:0] IMMSrc;
  wire [3:0] ALUop;
  wire ALUBSrc;
  

  
  // Salidas Register unit
  wire [31:0] rdata1, rdata2;
  
  
  //multiplerxorB
  wire [31:0] rdata2Final;
  
  
  //Salidas ALU
  wire [31:0] resultadoALU;

  
 //--------------------Conexiones de los modulos-------------------------------// 
  
  
  
  // Sumar PC+4
  sumador sumar(
    .address(pc),
    .nextPC(nextPC)
  );

  
  //Cambiar PC para todo el programa
  pc pcInst(
    .clk(clk),
    .rst_n(rst_n),
    .nextPC(nextPC),
    .address(pc)
  );
  
  
  //Devuelve la instruccion del PC
  instructionMemory imem(
    .PC(pc),
    .instruccion(inst)
  );

  
  //control unit
  control_unit controla(
	.opcode(opcode),
	.funct3(funct3),
	.funct7(funct7),
	
	.RUWr(RUWr),
	.IMMSrc(IMMSrc),
	
	.ALUop(ALUop),
	.ALUBSrc(ALUBSrc)
  );
  
  
  
  // register unit
  register_unit registros(
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
	 .RUWr(RUWr),
	 .resultadoALU(resultadoALU),
    .output_rs1(rdata1),
    .output_rs2(rdata2)
  );
  
  
  //generador de imm
   Generador_Imm inmediatos(
	 .inst(inst),
	 .IMMSrc(IMMSrc),
	 .imm(imm)
	);
	
	
	Mux multiplexor1(
	 .A(rdata2),
	 .B(imm),
	 .C(ALUBSrc),
	 .decidido(rdata2Final)
	);
	
  
  
  //ALU
   ALU operaciones (
    .valA(rdata1),
    .valB(rdata2Final),
	 .operacion(ALUop),
    .resultado(resultadoALU)
  );
  

  // Displays: mostrar PC
  hex7seg displayN0(.val(pc[3:0]),    .display(display0));
  hex7seg displayN1(.val(pc[7:4]),    .display(display1));
  hex7seg displayN2(.val(pc[11:8]),   .display(display2));
  hex7seg displayN3(.val(resultadoALU[3:0]),  .display(display3));
  hex7seg displayN4(.val(rdata1),  .display(display4));
  hex7seg displayN5(.val(rdata2Final),  .display(display5));

  assign leds = 10'b1010101010;

endmodule
