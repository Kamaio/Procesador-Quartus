module top_level(
  input  wire        clk,
  input  wire        clkFPGA,
  input  wire        rst_n,
  output wire [9:0]  leds,
  output wire [6:0]  display0,
  output wire [6:0]  display1,
  output wire [6:0]  display2,
  output wire [6:0]  display3,
  output wire [6:0]  display4,
  output wire [6:0]  display5,
  
  
  input switch0,
  input switch1,
  input switch2,
  input switch3,
  input switch4,
  input switch5,
  
  
  
  output [7:0] vga_red,
  output [7:0] vga_green,
  output [7:0] vga_blue,
  output vga_hsync,
  output vga_vsync,
  output vga_clock
);

	//Multiplexor Inicial
  reg [31:0] PcFinal;
	

  //PC
  wire [31:0] pc;
  wire [31:0] nextPC;
  
  
  //Salidas Instruction memory
  wire [31:0] inst;
  
	
  //instrucciones partidas generales
  wire [6:0] opcode = inst[6:0];
  wire [4:0] rd     = inst[11:7];
  wire [2:0] funct3 = inst[14:12];
  wire [4:0] rs1    = inst[19:15];
  wire [4:0] rs2    = inst[24:20];
  wire [6:0] funct7 = inst[31:25];
  
  
  //Salida del generador de Imm
  wire [31:0] imm;
  
  
  //Salidas control unit
  wire RUWr;
  wire [2:0] IMMSrc;
  wire [3:0] ALUop;
  wire ALUASrc;
  wire ALUBSrc;
  wire [3:0] BrOp;
  
  wire DMWR;
  wire [2:0] DMCtrl;
  wire [1:0] RUDataWrSrc;
  

  
  // Salidas Register unit
  wire [31:0] rdata1, rdata2;
  wire [31:0] registrosVGA [31:0];
  
  
  //multiplexorBranch
  reg [31:0] rdata1Final;
  
  
  //multiplerxorImm
  reg [31:0] rdata2Final;
  
  
  //Salidas ALU
  wire [31:0] resultadoALU;
  
  
  //Salida Branch Unit
  wire resultadoBU;
  
  
  //salida dataMemory
  wire [31:0] DataRd;
  wire [7:0] memoriaVGA [0:20];
  
  
  //multiplexor resultadoalu/datamemory
  reg [31:0] dataFinal;
  
  
  wire [31:0] salidaChimbaW;
  wire [31:0] salidaChimbaR;

  
 //--------------------Conexiones de los modulos-------------------------------// 
  
  
  
  // Sumar PC+4
  sumador sumar(
    .address(pc),
    .nextPC(nextPC)
  );

  
 // Multiplexor inicio
	always @(*) begin
		PcFinal = resultadoBU ? resultadoALU : nextPC; 
	end 

  
  //Cambiar PC para todo el programa
  pc pcInst(
    .clk(clk),
    .rst_n(rst_n),
    .nextPC(PcFinal),
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
	.ALUBSrc(ALUBSrc),
	.BrOp(BrOp),
	.ALUASrc(ALUASrc),
	
	.DMWR(DMWR),
	.DMCtrl(DMCtrl),
	.RUDataWrSrc(RUDataWrSrc)
	
  );
  
  
  // register unit
  register_unit registros(
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
	 .RUWr(RUWr),
	 .resultadoALU(dataFinal),
    .output_rs1(rdata1),
    .output_rs2(rdata2),
	 
	 .registrosVGA(registrosVGA)
  );
  
  
  //generador de imm
   Generador_Imm inmediatos(
	 .inst(inst),
	 .IMMSrc(IMMSrc),
	 .imm(imm)
	);
	
	
	//multiplexor A
	always @(*) begin
		rdata1Final = ALUASrc ? pc : rdata1;
	end
	
	
	//multiplexor B
	always @(*) begin
		rdata2Final = ALUBSrc ? imm : rdata2;
	end
  
  
  //ALU
   ALU operaciones (
    .valA(rdata1Final),
    .valB(rdata2Final),
	 .operacion(ALUop),
    .resultado(resultadoALU)
  );
  
  
  //Branch Unit
  branch_unit branch_unit(
    .valA(rdata1),
    .valB(rdata2),
    .operacion(BrOp),
    .resultado(resultadoBU)
  );
  
  
  //dataMemory
  dataMemory dataMemory(
	 .clk(clk),
	 .address(resultadoALU),
	 .writeData(rdata2),
	 .DMWR(DMWR),
	 .DMCtrl(DMCtrl),
	 .DataRd(DataRd),
	 
	 
	 .memoriaVGA(memoriaVGA),
	 
	 
	 .salidaChimbaW(salidaChimbaW),
	 .salidaChimbaR(salidaChimbaR)
  );
  
  
  //multiplexor 3
  always @(*) begin
		dataFinal = (RUDataWrSrc == 2'b01)? DataRd : (RUDataWrSrc == 2'b10)? nextPC : resultadoALU; //devuelve el siguiente pc o la data memory o la ALU
	end
  
  
  
  color color(
     .clock(clkFPGA),
	  .sw0(switch0),                   // reset
     .sw1(switch1),
     .sw2(switch2),
     .sw3(switch3),
     .sw4(switch4),
     .sw5(switch5),
	  .vga_red(vga_red),
	  .vga_green(vga_green),
	  .vga_blue(vga_blue),
	  .vga_hsync(vga_hsync),
	  .vga_vsync(vga_vsync),
	  .vga_clock(vga_clock),
	  
	  
	  .inst(inst),
	  .rd(rd),
	  .rs1(rs1),
	  .rdata1(rdata1),
	  .rs2(rs2),
	  .rdata2(rdata2),
	  .ALUop(ALUop),
	  .resultadoALU(dataFinal),
	  .imm(imm),
	  .Pc(PcFinal),
	  .BrOp(BrOp),
	  .rdata1Final(rdata1Final),
	  .rdata2Final(rdata2Final),
	  .RUDataWrSrc(RUDataWrSrc),
	  

	  .memoryR(registrosVGA),
	  .memoryD(memoriaVGA)
  );

  
  // Displays: mostrar PC
	reg [3:0] d0, d1, d2, d3, d4, d5;

	wire [2:0] sel = switch1 ? 3'b010 :
						  switch2 ? 3'b100 :
						  switch3 ? 3'b110 : 
						  switch4 ? 3'b111 : 3'b000;

						  
	always @(*) begin
	  d0=0; d1=0; d2=0; d3=0; d4=0; d5=0;

	  case (sel)
		 3'b010: begin
			d0 = rdata1[3:0];    
			d1 = rdata1[7:4];
			d2 = rdata1[11:8];   
			d3 = rdata1[15:12];
			d4 = rdata1[19:16];  
			d5 = rdata1[23:20];
		 end
		 
		 3'b100: begin
			d0 = rdata2Final[3:0];   
			d1 = rdata2Final[7:4];
			d2 = rdata2Final[11:8];  
			d3 = rdata2Final[15:12];
			d4 = rdata2Final[19:16]; 
			d5 = rdata2Final[23:20];
		 end
		 
		 3'b110: begin
			d0 = resultadoALU[3:0];    
			d1 = resultadoALU[7:4];
			d2 = resultadoALU[11:8];   
			d3 = resultadoALU[15:12];
			d4 = resultadoALU[19:16];  
			d5 = resultadoALU[23:20];
		 end
		 
		 3'b111: begin
			d0 = salidaChimbaW[3:0];
			d1 = salidaChimbaW[7:4];
			d2 = salidaChimbaW[11:8];   
			d3 = salidaChimbaR[3:0];
			d4 = salidaChimbaR[7:4];  
			d5 = 1'b1;
		 end
		 
		 default: begin
			d0 = pc[3:0];
			d1 = pc[7:4];
			d2 = resultadoBU;
			d3 = resultadoALU[3:0];
			d4 = rdata2Final[3:0];
			d5 = 2'd2;
		 end
		 
	  endcase
	end

	
	// Instancias fuera del always
	hex7seg displayN0(.val(d0), .display(display0));
	hex7seg displayN1(.val(d1), .display(display1));
	hex7seg displayN2(.val(d2), .display(display2));
	hex7seg displayN3(.val(d3), .display(display3));
	hex7seg displayN4(.val(d4), .display(display4));
	hex7seg displayN5(.val(d5), .display(display5));

	  
  
  
  
  
  

  assign leds = 10'b1010101010;

endmodule
