// ============================================================
// color.v (VERSIÓN CORREGIDA CON CAMBIOS MÍNIMOS)
// ============================================================
module color(
  input clock,
  input sw0,
  input sw1, input sw2, input sw3, input sw4, input sw5,
  output reg [7:0] vga_red,
  output reg [7:0] vga_green,
  output reg [7:0] vga_blue,
  output vga_hsync,
  output vga_vsync,
  output vga_clock,
  
  // --- ENTRADAS DEL PROCESADOR ---
  input [31:0] inst,
  input [4:0]  rd,
  input [4:0]  rs1,
  input [31:0] rdata1,
  input [4:0]  rs2,
  input [31:0] rdata2,
  input [3:0]  ALUop,
  input [31:0] resultadoALU,
  input [31:0] PC,
  
  
  input [31:0] memoryR1,
  input [31:0] memoryR2,
  input [31:0] memoryR3,
  input [31:0] memoryR4,
  input [31:0] memoryR5,
  input [31:0] memoryR6,
  input [31:0] memoryR7,
  input [31:0] memoryR8,
  input [31:0] memoryR9,
  input [31:0] memoryR10,
  input [31:0] memoryR11,
  input [31:0] memoryR12,
  input [31:0] memoryR13,
  input [31:0] memoryR14,
  input [31:0] memoryR15,
  input [31:0] memoryR16,
  input [31:0] memoryR17,
  input [31:0] memoryR18,
  input [31:0] memoryR19,
  input [31:0] memoryR20,
  input [31:0] memoryR21,
  input [31:0] memoryR22,
  input [31:0] memoryR23,
  input [31:0] memoryR24,
  input [31:0] memoryR25,
  input [31:0] memoryR26,
  input [31:0] memoryR27,
  input [31:0] memoryR28,
  input [31:0] memoryR29,
  input [31:0] memoryR30,
  input [31:0] memoryR31,
  
  
  input [31:0] memoryD0,
  input [31:0] memoryD1,
  input [31:0] memoryD2,
  input [31:0] memoryD3,
  input [31:0] memoryD4,
  input [31:0] memoryD5,
  input [31:0] memoryD6,
  input [31:0] memoryD7,
  input [31:0] memoryD8,
  input [31:0] memoryD9,
  input [31:0] memoryD10,
  input [31:0] memoryD11,
  input [31:0] memoryD12,
  input [31:0] memoryD13,
  input [31:0] memoryD14,
  input [31:0] memoryD15,
  input [31:0] memoryD16,
  input [31:0] memoryD17,
  input [31:0] memoryD18,
  input [31:0] memoryD19,
  input [31:0] memoryD20

);

  // ============================================================
  // Señales y Módulos VGA
  // ============================================================
  wire [10:0] x;
  wire [9:0]  y;
  wire videoOn;
  wire vgaclk;


  vgaClock vgaclock(
    .ref_clk_clk(clock),
    .ref_reset_reset(sw0),
    .vga_clk_clk(vgaclk)
  );

  assign vga_clock = vgaclk;

  // Controlador VGA
  vga_controller_1280x800 ctrl(
    .clk(vgaclk),
    .reset(sw0),
    .video_on(videoOn),
    .hsync(vga_hsync),
    .vsync(vga_vsync),
    .hcount(x),
    .vcount(y)
  );

  // ============================================================
  // Fuente 8x16
  // ============================================================
  wire [7:0] ascii_code;
  wire [3:0] row_in_char;
  wire [2:0] col_in_char;
  wire pixel_on;

  font_renderer font_inst (
      .clk(vgaclk),
      .ascii_code(ascii_code),
      .row_in_char(row_in_char),
      .col_in_char(col_in_char),
      .pixel_on(pixel_on)
  );

  // ============================================================
  // Texto
  // ============================================================
  reg [7:0] mensaje [0:31][0:80]; // Memoria para 50 filas y 160 columnas

  //Cambia los binarios a ascii
  function[7:0] ascii;
    input[3:0] caracter;
    ascii = (caracter < 10) ? (8'd48 + caracter) : (8'd55 + caracter);
  endfunction
  
  always@(posedge clock)
  begin
    // Fila 0: Instrucción
    mensaje[0][0]  = "I"; mensaje[0][1]  = "N"; mensaje[0][2]  = "S";
    mensaje[0][3]  = ":"; mensaje[0][4]  = " ";
    mensaje[0][5]  = ascii(inst[31:28]); mensaje[0][6]  = ascii(inst[27:24]);
    mensaje[0][7]  = ascii(inst[23:20]); mensaje[0][8]  = ascii(inst[19:16]);
    mensaje[0][9]  = ascii(inst[15:12]); mensaje[0][10] = ascii(inst[11:8]);
    mensaje[0][11] = ascii(inst[7:4]);   mensaje[0][12] = ascii(inst[3:0]);
	 
	 
	 
	 // Fila 0.2: Titulo registros
    mensaje[0][20]  = "R"; mensaje[0][21]  = "E"; 
	 mensaje[0][22]  = "G"; mensaje[0][23]  = "I"; 
	 mensaje[0][24]  = "S"; mensaje[0][25]  = "T"; 
	 mensaje[0][26]  = "R"; mensaje[0][27]  = "O"; mensaje[0][28]  = "S";
	 
	 
	 
	 // Fila 0.3: Titulo data memory
    mensaje[0][40]  = "D"; mensaje[0][41]  = "A"; 
	 mensaje[0][42]  = "T"; mensaje[0][43]  = "M"; 
	 mensaje[0][44]  = "E"; mensaje[0][45]  = "M"; 
	 mensaje[0][46]  = "O"; mensaje[0][47]  = "R"; mensaje[0][48]  = "Y";
	 
	 
	 
	 
	 // Fila 0.4: Titulo intruction memory
    mensaje[0][60]  = "I"; mensaje[0][61]  = "N"; 
	 mensaje[0][62]  = "S"; mensaje[0][63]  = "M"; 
	 mensaje[0][64]  = "E"; mensaje[0][65]  = "M"; 
	 mensaje[0][66]  = "O"; mensaje[0][67]  = "R"; mensaje[0][68]  = "Y";
	 
	 
	 
	 // Fila 1: RD
    mensaje[1][0]  = "R"; mensaje[1][1]  = "D"; mensaje[1][2]  = ":";
    mensaje[1][3]  = " ";
    mensaje[1][4]  = ascii(rd[4:1]); mensaje[1][5]  = ascii(rd[0]);
	 
	 
	 
	 // Fila 1.2: Registro X1
    mensaje[1][20]  = "X"; mensaje[1][21]  = "1"; mensaje[1][22]  = ":";
    mensaje[1][23]  = " ";
    mensaje[1][24]  = ascii(memoryR1[31:28]); mensaje[1][25]  = ascii(memoryR1[27:24]);
    mensaje[1][26]  = ascii(memoryR1[23:20]); mensaje[1][27]  = ascii(memoryR1[19:16]);
    mensaje[1][28]  = ascii(memoryR1[15:12]); mensaje[1][29]  = ascii(memoryR1[11:8]);
    mensaje[1][30]  = ascii(memoryR1[7:4]);   mensaje[1][31]  = ascii(memoryR1[3:0]);
	 
	 
	 
	 // Fila 2: RS1
	 mensaje[2][0]  = "R"; mensaje[2][1]  = "S"; mensaje[2][2]  = "1";
    mensaje[2][3]  = ":"; mensaje[2][4]  = " ";
    mensaje[2][5]  = ascii(rdata1[31:28]); mensaje[2][6]  = ascii(rdata1[27:24]);
    mensaje[2][7]  = ascii(rdata1[23:20]); mensaje[2][8]  = ascii(rdata1[19:16]);
    mensaje[2][9]  = ascii(rdata1[15:12]); mensaje[2][10] = ascii(rdata1[11:8]);
    mensaje[2][11] = ascii(rdata1[7:4]);   mensaje[2][12] = ascii(rdata1[3:0]);
	 
	 
	 
	 // Fila 2.2: Registro X2
    mensaje[2][20]  = "X"; mensaje[2][21]  = "2"; mensaje[2][22]  = ":";
    mensaje[2][23]  = " ";
    mensaje[2][24]  = ascii(memoryR2[31:28]); mensaje[2][25]  = ascii(memoryR2[27:24]);
    mensaje[2][26]  = ascii(memoryR2[23:20]); mensaje[2][27]  = ascii(memoryR2[19:16]);
	 mensaje[2][28]  = ascii(memoryR2[15:12]); mensaje[2][29]  = ascii(memoryR2[11:8]);
	 mensaje[2][30]  = ascii(memoryR2[7:4]);   mensaje[2][31] = ascii(memoryR2[3:0]);
	 
	 
	 
	 // Fila 3: RS2
	 mensaje[3][0]  = "R"; mensaje[3][1]  = "S"; mensaje[3][2]  = "2";
    mensaje[3][3]  = ":"; mensaje[3][4]  = " ";
    mensaje[3][5]  = ascii(rdata2[31:28]); mensaje[3][6]  = ascii(rdata2[27:24]);
    mensaje[3][7]  = ascii(rdata2[23:20]); mensaje[3][8]  = ascii(rdata2[19:16]);
    mensaje[3][9]  = ascii(rdata2[15:12]); mensaje[3][10] = ascii(rdata2[11:8]);
    mensaje[3][11] = ascii(rdata2[7:4]);   mensaje[3][12] = ascii(rdata2[3:0]);
	 
	 
	 
	 // Fila 3.2: Registro X3
    mensaje[3][20]  = "X"; mensaje[3][21]  = "3"; mensaje[3][22]  = ":";
    mensaje[3][23]  = " ";
    mensaje[3][24]  = ascii(memoryR3[31:28]); mensaje[3][25]  = ascii(memoryR3[27:24]);
    mensaje[3][26]  = ascii(memoryR3[23:20]); mensaje[3][27]  = ascii(memoryR3[19:16]);
	 mensaje[3][28]  = ascii(memoryR3[15:12]); mensaje[3][29]  = ascii(memoryR3[11:8]);
	 mensaje[3][30]  = ascii(memoryR3[7:4]);   mensaje[3][31]  = ascii(memoryR3[3:0]);
	 
	 
	 
	 // Fila 4: Resultado que le llega a la register unit independiente de si es memory o ALU
	 mensaje[4][0]  = "A"; mensaje[4][1]  = "L"; mensaje[4][2]  = "U";
    mensaje[4][3]  = ":"; mensaje[4][4]  = " ";
    mensaje[4][5]  = ascii(resultadoALU[31:28]); mensaje[4][6]  = ascii(resultadoALU[27:24]);
    mensaje[4][7]  = ascii(resultadoALU[23:20]); mensaje[4][8]  = ascii(resultadoALU[19:16]);
    mensaje[4][9]  = ascii(resultadoALU[15:12]); mensaje[4][10] = ascii(resultadoALU[11:8]);
    mensaje[4][11] = ascii(resultadoALU[7:4]);   mensaje[4][12] = ascii(resultadoALU[3:0]);
	 
	 
	 
	 //File 4.2: Registro X4
	 mensaje[4][20]  = "X"; mensaje[4][21]  = "4"; mensaje[4][22]  = ":";
    mensaje[4][23]  = " ";
    mensaje[4][24]  = ascii(memoryR4[31:28]); mensaje[4][25]  = ascii(memoryR4[27:24]);
    mensaje[4][26]  = ascii(memoryR4[23:20]); mensaje[4][27]  = ascii(memoryR4[19:16]);
	 mensaje[4][28]  = ascii(memoryR4[15:12]); mensaje[4][29]  = ascii(memoryR4[11:8]);
	 mensaje[4][30]  = ascii(memoryR4[7:4]);   mensaje[4][31]  = ascii(memoryR4[3:0]);
	 
	 
	 
	 // Fila 5 ALUop
    mensaje[5][0]  = "A"; mensaje[5][1]  = "L"; mensaje[5][2]  = "U";
    mensaje[5][3]  = "o"; mensaje[5][4]  = "p"; mensaje[5][5]  = ": "; mensaje[5][6]  = " ";
    mensaje[5][7]  = ascii(ALUop);
	 
	 
	 
	 //File 5.2: Registro X5
	 mensaje[5][20]  = "X"; mensaje[5][21]  = "5"; mensaje[5][22]  = ":";
    mensaje[5][23]  = " ";
    mensaje[5][24]  = ascii(memoryR5[31:28]); mensaje[5][25]  = ascii(memoryR5[27:24]);
    mensaje[5][26]  = ascii(memoryR5[23:20]); mensaje[5][27]  = ascii(memoryR5[19:16]);
	 mensaje[5][28]  = ascii(memoryR5[15:12]); mensaje[5][29]  = ascii(memoryR5[11:8]);
	 mensaje[5][30]  = ascii(memoryR5[7:4]);   mensaje[5][31]  = ascii(memoryR5[3:0]);
	 
	 
	 
	 //File 6: PC
	 mensaje[6][0]  = "P"; mensaje[6][1]  = "C"; mensaje[6][2]  = ":";
    mensaje[6][3]  = " ";
    mensaje[6][4]  = ascii(PC[31:28]); mensaje[6][5]  = ascii(PC[27:24]);
    mensaje[6][6]  = ascii(PC[23:20]); mensaje[6][7]  = ascii(PC[19:16]);
	 mensaje[6][8]  = ascii(PC[15:12]); mensaje[6][9]  = ascii(PC[11:8]);
	 mensaje[6][0]  = ascii(PC[7:4]);   mensaje[6][1]  = ascii(PC[3:0]);
	 
	 
	 
	 //File 6.2: Registro X6
	 mensaje[6][20]  = "X"; mensaje[6][21]  = "6"; mensaje[6][22]  = ":";
    mensaje[6][23]  = " ";
    mensaje[6][24]  = ascii(memoryR6[31:28]); mensaje[6][25]  = ascii(memoryR6[27:24]);
    mensaje[6][26]  = ascii(memoryR6[23:20]); mensaje[6][27]  = ascii(memoryR6[19:16]);
	 mensaje[6][28]  = ascii(memoryR6[15:12]); mensaje[6][29]  = ascii(memoryR6[11:8]);
	 mensaje[6][30]  = ascii(memoryR6[7:4]);   mensaje[6][31]  = ascii(memoryR6[3:0]);
	 
	 
	 //File 7.2: Registro X7
	 mensaje[7][20]  = "X"; mensaje[7][21]  = "7"; mensaje[7][22]  = ":";
    mensaje[7][23]  = " ";
    mensaje[7][24]  = ascii(memoryR7[31:28]); mensaje[7][25]  = ascii(memoryR7[27:24]);
    mensaje[7][26]  = ascii(memoryR7[23:20]); mensaje[7][27]  = ascii(memoryR7[19:16]);
	 mensaje[7][28]  = ascii(memoryR7[15:12]); mensaje[7][29]  = ascii(memoryR7[11:8]);
	 mensaje[7][30]  = ascii(memoryR7[7:4]);   mensaje[7][31]  = ascii(memoryR7[3:0]);
	 
	 
	 //File 8.2: Registro X8
	 mensaje[8][20]  = "X"; mensaje[8][21]  = "8"; mensaje[8][22]  = ":";
    mensaje[8][23]  = " ";
    mensaje[8][24]  = ascii(memoryR8[31:28]); mensaje[8][25]  = ascii(memoryR8[27:24]);
    mensaje[8][26]  = ascii(memoryR8[23:20]); mensaje[8][27]  = ascii(memoryR8[19:16]);
	 mensaje[8][28]  = ascii(memoryR8[15:12]); mensaje[8][29]  = ascii(memoryR8[11:8]);
	 mensaje[8][30]  = ascii(memoryR8[7:4]);   mensaje[8][31]  = ascii(memoryR8[3:0]);
	 
	 
	 //File 9.2: Registro X9
	 mensaje[9][20]  = "X"; mensaje[9][21]  = "9"; mensaje[9][22]  = ":";
    mensaje[9][23]  = " ";
    mensaje[9][24]  = ascii(memoryR9[31:28]); mensaje[9][25]  = ascii(memoryR9[27:24]);
    mensaje[9][26]  = ascii(memoryR9[23:20]); mensaje[9][27]  = ascii(memoryR9[19:16]);
	 mensaje[9][28]  = ascii(memoryR9[15:12]); mensaje[9][29]  = ascii(memoryR9[11:8]);
	 mensaje[9][30]  = ascii(memoryR9[7:4]);   mensaje[9][31]  = ascii(memoryR9[3:0]);
	 
	 
	 
	 //File 10.2: Registro XA
	 mensaje[10][20]  = "X"; mensaje[10][21]  = "A"; mensaje[10][22]  = ":";
    mensaje[10][23]  = " ";
    mensaje[10][24]  = ascii(memoryR10[31:28]); mensaje[10][25]  = ascii(memoryR10[27:24]);
    mensaje[10][26]  = ascii(memoryR10[23:20]); mensaje[10][27]  = ascii(memoryR10[19:16]);
	 mensaje[10][28]  = ascii(memoryR10[15:12]); mensaje[10][29]  = ascii(memoryR10[11:8]);
	 mensaje[10][30]  = ascii(memoryR10[7:4]);   mensaje[10][31]  = ascii(memoryR10[3:0]);
	 
	 
	 
	 //File 11.2: Registro XB
	 mensaje[11][20]  = "X"; mensaje[11][21]  = "B"; mensaje[11][22]  = ":";
    mensaje[11][23]  = " ";
    mensaje[11][24]  = ascii(memoryR11[31:28]); mensaje[11][25]  = ascii(memoryR11[27:24]);
    mensaje[11][26]  = ascii(memoryR11[23:20]); mensaje[11][27]  = ascii(memoryR11[19:16]);
	 mensaje[11][28]  = ascii(memoryR11[15:12]); mensaje[11][29]  = ascii(memoryR11[11:8]);
	 mensaje[11][30]  = ascii(memoryR11[7:4]);   mensaje[11][31]  = ascii(memoryR11[3:0]);
	 
	 
	 
	 //File 12.2: Registro XC
	 mensaje[12][20]  = "X"; mensaje[12][21]  = "C"; mensaje[12][22]  = ":";
    mensaje[12][23]  = " ";
    mensaje[12][24]  = ascii(memoryR12[31:28]); mensaje[12][25]  = ascii(memoryR12[27:24]);
    mensaje[12][26]  = ascii(memoryR12[23:20]); mensaje[12][27]  = ascii(memoryR12[19:16]);
	 mensaje[12][28]  = ascii(memoryR12[15:12]); mensaje[12][29]  = ascii(memoryR12[11:8]);
	 mensaje[12][30]  = ascii(memoryR12[7:4]);   mensaje[12][31]  = ascii(memoryR12[3:0]);
	 
	 
	 
	 //File 13.2: Registro XD
	 mensaje[13][20]  = "X"; mensaje[13][21]  = "D"; mensaje[13][22]  = ":";
    mensaje[13][23]  = " ";
    mensaje[13][24]  = ascii(memoryR13[31:28]); mensaje[13][25]  = ascii(memoryR13[27:24]);
    mensaje[13][26]  = ascii(memoryR13[23:20]); mensaje[13][27]  = ascii(memoryR13[19:16]);
	 mensaje[13][28]  = ascii(memoryR13[15:12]); mensaje[13][29]  = ascii(memoryR13[11:8]);
	 mensaje[13][30]  = ascii(memoryR13[7:4]);   mensaje[13][31]  = ascii(memoryR13[3:0]);
	 
	 
	 
	 //File 14.2: Registro XE
	 mensaje[14][20]  = "X"; mensaje[14][21]  = "E"; mensaje[14][22]  = ":";
    mensaje[14][23]  = " ";
    mensaje[14][24]  = ascii(memoryR14[31:28]); mensaje[14][25]  = ascii(memoryR14[27:24]);
    mensaje[14][26]  = ascii(memoryR14[23:20]); mensaje[14][27]  = ascii(memoryR14[19:16]);
	 mensaje[14][28]  = ascii(memoryR14[15:12]); mensaje[14][29]  = ascii(memoryR14[11:8]);
	 mensaje[14][30]  = ascii(memoryR14[7:4]);   mensaje[14][31]  = ascii(memoryR14[3:0]);
	 
	 
	 
	 //File 15.2: Registro XF
	 mensaje[15][20]  = "X"; mensaje[15][21]  = "F"; mensaje[15][22]  = ":";
    mensaje[15][23]  = " ";
    mensaje[15][24]  = ascii(memoryR15[31:28]); mensaje[15][25]  = ascii(memoryR15[27:24]);
    mensaje[15][26]  = ascii(memoryR15[23:20]); mensaje[15][27]  = ascii(memoryR15[19:16]);
	 mensaje[15][28]  = ascii(memoryR15[15:12]); mensaje[15][29]  = ascii(memoryR15[11:8]);
	 mensaje[15][30]  = ascii(memoryR15[7:4]);   mensaje[15][31]  = ascii(memoryR15[3:0]);
	 
	 
	 
	 // Fila 16.2 Registro X10
    mensaje[16][20]  = "X"; mensaje[16][21] = "1"; mensaje[16][22]  = "0"; mensaje[16][23]  = ":"; mensaje[16][24]  = " ";
    mensaje[16][25]  = ascii(memoryR16[31:28]);  mensaje[16][26]  = ascii(memoryR16[27:24]);
    mensaje[16][27]  = ascii(memoryR16[23:20]);  mensaje[16][28]  = ascii(memoryR16[19:16]);
    mensaje[16][29]  = ascii(memoryR16[15:12]);  mensaje[16][30]  = ascii(memoryR16[11:8]);
    mensaje[16][31]  = ascii(memoryR16[7:4]);    mensaje[16][32]  = ascii(memoryR16[3:0]);

	 
	 
    // Fila 17.2 Registro X11
    mensaje[17][20]  = "X"; mensaje[17][21]  = "1"; mensaje[17][22] = "1"; mensaje[17][23]  = ":"; mensaje[17][24]  = " ";
    mensaje[17][25]  = ascii(memoryR17[31:28]);   mensaje[17][26] = ascii(memoryR17[27:24]);
    mensaje[17][27]  = ascii(memoryR17[23:20]);   mensaje[17][28] = ascii(memoryR17[19:16]);
    mensaje[17][29]  = ascii(memoryR17[15:12]);   mensaje[17][30] = ascii(memoryR17[11:8]);
    mensaje[17][31]  = ascii(memoryR17[7:4]);     mensaje[17][32] = ascii(memoryR17[3:0]);

	 
	 
    // Fila 18.2 Registro X12
    mensaje[18][20]  = "X"; mensaje[18][21]  = "1"; mensaje[18][22] = "2"; mensaje[18][23]  = ":"; mensaje[18][24]  = " ";
    mensaje[18][25]  = ascii(memoryR18[31:28]);   mensaje[18][26] = ascii(memoryR18[27:24]);
    mensaje[18][27]  = ascii(memoryR18[23:20]);   mensaje[18][28] = ascii(memoryR18[19:16]);
    mensaje[18][29]  = ascii(memoryR18[15:12]);   mensaje[18][30] = ascii(memoryR18[11:8]);
    mensaje[18][31]  = ascii(memoryR18[7:4]);     mensaje[18][32] = ascii(memoryR18[3:0]);

	 
	 
    // Fila 19.2 Registro X13
    mensaje[19][20]  = "X"; mensaje[19][21]  = "1"; mensaje[19][22]  = "3"; mensaje[19][23]  = ":"; mensaje[19][24]  = " ";
    mensaje[19][25]  = ascii(memoryR19[31:28]);   mensaje[19][26]  = ascii(memoryR19[27:24]);
    mensaje[19][27]  = ascii(memoryR19[23:20]);   mensaje[19][28]  = ascii(memoryR19[19:16]);
    mensaje[19][29]  = ascii(memoryR19[15:12]);   mensaje[19][30]  = ascii(memoryR19[11:8]);
    mensaje[19][31]  = ascii(memoryR19[7:4]);     mensaje[19][32]  = ascii(memoryR19[3:0]);

	 
	 
    // Fila 20.2 Registro X14
    mensaje[20][20] = "X"; mensaje[20][21] = "1"; mensaje[20][22] = "4"; mensaje[20][23] = ":"; mensaje[20][24] = " ";
    mensaje[20][25] = ascii(memoryR20[31:28]); mensaje[20][26] = ascii(memoryR20[27:24]);
    mensaje[20][27] = ascii(memoryR20[23:20]); mensaje[20][28] = ascii(memoryR20[19:16]);
    mensaje[20][29] = ascii(memoryR20[15:12]); mensaje[20][30] = ascii(memoryR20[11:8]);
    mensaje[20][31] = ascii(memoryR20[7:4]);   mensaje[20][32] = ascii(memoryR20[3:0]);
	 
	 

    // Fila 21.2 Registro X15
    mensaje[21][20] = "X"; mensaje[21][21] = "1"; mensaje[21][22] = "5"; mensaje[21][23] = ":"; mensaje[21][24] = " ";
    mensaje[21][25] = ascii(memoryR21[31:28]); mensaje[21][26] = ascii(memoryR21[27:24]);
    mensaje[21][27] = ascii(memoryR21[23:20]); mensaje[21][28] = ascii(memoryR21[19:16]);
    mensaje[21][29] = ascii(memoryR21[15:12]); mensaje[21][30] = ascii(memoryR21[11:8]);
    mensaje[21][31] = ascii(memoryR21[7:4]);   mensaje[21][32] = ascii(memoryR21[3:0]);

	 
	 
    // Fila 22.2 Registro X16
    mensaje[22][20] = "X"; mensaje[22][21] = "1"; mensaje[22][22] = "6"; mensaje[22][23] = ":"; mensaje[22][24] = " ";
    mensaje[22][25] = ascii(memoryR22[31:28]); mensaje[22][26] = ascii(memoryR22[27:24]);
    mensaje[22][27] = ascii(memoryR22[23:20]); mensaje[22][28] = ascii(memoryR22[19:16]);
    mensaje[22][29] = ascii(memoryR22[15:12]); mensaje[22][30] = ascii(memoryR22[11:8]);
    mensaje[22][31] = ascii(memoryR22[7:4]);   mensaje[22][32] = ascii(memoryR22[3:0]);

	 
	 
    // Fila 23.2 Registro X17
    mensaje[23][20] = "X"; mensaje[23][21] = "1"; mensaje[23][22] = "7"; mensaje[23][23] = ":"; mensaje[23][24] = " ";
    mensaje[23][25] = ascii(memoryR23[31:28]); mensaje[23][26] = ascii(memoryR23[27:24]);
    mensaje[23][27] = ascii(memoryR23[23:20]); mensaje[23][28] = ascii(memoryR23[19:16]);
    mensaje[23][29] = ascii(memoryR23[15:12]); mensaje[23][30] = ascii(memoryR23[11:8]);
    mensaje[23][31] = ascii(memoryR23[7:4]);   mensaje[23][32] = ascii(memoryR23[3:0]);

	 
	 
    // Fila 24.2 Registro X18
    mensaje[24][20] = "X"; mensaje[24][21] = "1"; mensaje[24][22] = "8"; mensaje[24][23] = ":"; mensaje[24][24] = " ";
    mensaje[24][25] = ascii(memoryR24[31:28]); mensaje[24][26] = ascii(memoryR24[27:24]);
    mensaje[24][27] = ascii(memoryR24[23:20]); mensaje[24][28] = ascii(memoryR24[19:16]);
    mensaje[24][29] = ascii(memoryR24[15:12]); mensaje[24][30] = ascii(memoryR24[11:8]);
    mensaje[24][31] = ascii(memoryR24[7:4]);   mensaje[24][32] = ascii(memoryR24[3:0]);

	 
	 
    // Fila 25.2 Registro X19
    mensaje[25][20] = "X"; mensaje[25][21] = "1"; mensaje[25][22] = "9"; mensaje[25][23] = ":"; mensaje[25][24] = " ";
    mensaje[25][25] = ascii(memoryR25[31:28]); mensaje[25][26] = ascii(memoryR25[27:24]);
    mensaje[25][27] = ascii(memoryR25[23:20]); mensaje[25][28] = ascii(memoryR25[19:16]);
    mensaje[25][29] = ascii(memoryR25[15:12]); mensaje[25][30] = ascii(memoryR25[11:8]);
    mensaje[25][31] = ascii(memoryR25[7:4]);   mensaje[25][32] = ascii(memoryR25[3:0]);

	 
	 
    // Fila 26.2 Registro X1A
    mensaje[26][20] = "X"; mensaje[26][21] = "1"; mensaje[26][22] = "A"; mensaje[26][23] = ":"; mensaje[26][24] = " ";
    mensaje[26][25] = ascii(memoryR26[31:28]); mensaje[26][26] = ascii(memoryR26[27:24]);
    mensaje[26][27] = ascii(memoryR26[23:20]); mensaje[26][28] = ascii(memoryR26[19:16]);
    mensaje[26][29] = ascii(memoryR26[15:12]); mensaje[26][30] = ascii(memoryR26[11:8]);
    mensaje[26][31] = ascii(memoryR26[7:4]);   mensaje[26][32] = ascii(memoryR26[3:0]);

	 
	 
    // Fila 27.2 Registro X1B
    mensaje[27][20] = "X"; mensaje[27][21] = "1"; mensaje[27][22] = "B"; mensaje[27][23] = ":"; mensaje[27][24] = " ";
    mensaje[27][25] = ascii(memoryR27[31:28]); mensaje[27][26] = ascii(memoryR27[27:24]);
    mensaje[27][27] = ascii(memoryR27[23:20]); mensaje[27][28] = ascii(memoryR27[19:16]);
    mensaje[27][29] = ascii(memoryR27[15:12]); mensaje[27][30] = ascii(memoryR27[11:8]);
    mensaje[27][31] = ascii(memoryR27[7:4]);   mensaje[27][32] = ascii(memoryR27[3:0]);

	 
	 
    // Fila 28.2 Registro X1C
    mensaje[28][20] = "X"; mensaje[28][21] = "1"; mensaje[28][22] = "C"; mensaje[28][23] = ":"; mensaje[28][24] = " ";
    mensaje[28][25] = ascii(memoryR28[31:28]); mensaje[28][26] = ascii(memoryR28[27:24]);
    mensaje[28][27] = ascii(memoryR28[23:20]); mensaje[28][28] = ascii(memoryR28[19:16]);
    mensaje[28][29] = ascii(memoryR28[15:12]); mensaje[28][30] = ascii(memoryR28[11:8]);
    mensaje[28][31] = ascii(memoryR28[7:4]);   mensaje[28][32] = ascii(memoryR28[3:0]);

	 
	 
    // Fila 29.2 Registro X1D
    mensaje[29][20] = "X"; mensaje[29][21] = "1"; mensaje[29][22] = "D"; mensaje[29][23] = ":"; mensaje[29][24] = " ";
    mensaje[29][25] = ascii(memoryR29[31:28]); mensaje[29][26] = ascii(memoryR29[27:24]);
    mensaje[29][27] = ascii(memoryR29[23:20]); mensaje[29][28] = ascii(memoryR29[19:16]);
    mensaje[29][29] = ascii(memoryR29[15:12]); mensaje[29][30] = ascii(memoryR29[11:8]);
    mensaje[29][31] = ascii(memoryR29[7:4]);   mensaje[29][32] = ascii(memoryR29[3:0]);

	 
	 
    // Fila 30.2 Registro X1E
    mensaje[30][20] = "X"; mensaje[30][21] = "1"; mensaje[30][22] = "E"; mensaje[30][23] = ":"; mensaje[30][24] = " ";
    mensaje[30][25] = ascii(memoryR30[31:28]); mensaje[30][26] = ascii(memoryR30[27:24]);
    mensaje[30][27] = ascii(memoryR30[23:20]); mensaje[30][28] = ascii(memoryR30[19:16]);
    mensaje[30][29] = ascii(memoryR30[15:12]); mensaje[30][30] = ascii(memoryR30[11:8]);
    mensaje[30][31] = ascii(memoryR30[7:4]);   mensaje[30][32] = ascii(memoryR30[3:0]);

	 
	 
    // Fila 31.2 Registro X1F
    mensaje[31][20] = "X"; mensaje[31][21] = "1"; mensaje[31][22] = "F"; mensaje[31][23] = ":"; mensaje[31][24] = " ";
    mensaje[31][25] = ascii(memoryR31[31:28]); mensaje[31][26] = ascii(memoryR31[27:24]);
    mensaje[31][27] = ascii(memoryR31[23:20]); mensaje[31][28] = ascii(memoryR31[19:16]);
    mensaje[31][29] = ascii(memoryR31[15:12]); mensaje[31][30] = ascii(memoryR31[11:8]);
    mensaje[31][31] = ascii(memoryR31[7:4]);   mensaje[31][32] = ascii(memoryR31[3:0]);
	 
	 
	 

    //DATA MEMORY (Posición Modificada, Variable 'memoryD')

	 // Fila 0.2: Registro D1
    mensaje[0][40]  = "D"; mensaje[0][41]  = "1"; mensaje[0][42]  = ":";
    mensaje[0][43]  = " ";
    mensaje[0][44]  = ascii(memoryD0[31:28]); mensaje[0][45]  = ascii(memoryD0[27:24]);
    mensaje[0][46]  = ascii(memoryD0[23:20]); mensaje[0][47]  = ascii(memoryD0[19:16]);
    mensaje[0][48]  = ascii(memoryD0[15:12]); mensaje[0][49]  = ascii(memoryD0[11:8]);
    mensaje[0][50]  = ascii(memoryD0[7:4]);   mensaje[0][51]  = ascii(memoryD0[3:0]);
	 
	 // Fila 1.2: Registro D2
    mensaje[1][40]  = "D"; mensaje[1][41]  = "2"; mensaje[1][42]  = ":";
    mensaje[1][43]  = " ";
    mensaje[1][44]  = ascii(memoryD1[31:28]); mensaje[1][45]  = ascii(memoryD1[27:24]);
    mensaje[1][46]  = ascii(memoryD1[23:20]); mensaje[1][47]  = ascii(memoryD1[19:16]);
	 mensaje[1][48]  = ascii(memoryD1[15:12]); mensaje[1][49]  = ascii(memoryD1[11:8]);
	 mensaje[1][50]  = ascii(memoryD1[7:4]);   mensaje[1][51]  = ascii(memoryD1[3:0]);
	 
	 // Fila 2.2: Registro D3
    mensaje[2][40]  = "D"; mensaje[2][41]  = "3"; mensaje[2][42]  = ":";
    mensaje[2][43]  = " ";
    mensaje[2][44]  = ascii(memoryD2[31:28]); mensaje[2][45]  = ascii(memoryD2[27:24]);
    mensaje[2][46]  = ascii(memoryD2[23:20]); mensaje[2][47]  = ascii(memoryD2[19:16]);
	 mensaje[2][48]  = ascii(memoryD2[15:12]); mensaje[2][49]  = ascii(memoryD2[11:8]);
	 mensaje[2][50]  = ascii(memoryD2[7:4]);   mensaje[2][51]  = ascii(memoryD2[3:0]);
	 
	 //File 3.2: Registro D4
	 mensaje[3][40]  = "D"; mensaje[3][41]  = "4"; mensaje[3][42]  = ":";
    mensaje[3][43]  = " ";
    mensaje[3][44]  = ascii(memoryD3[31:28]); mensaje[3][45]  = ascii(memoryD3[27:24]);
    mensaje[3][46]  = ascii(memoryD3[23:20]); mensaje[3][47]  = ascii(memoryD3[19:16]);
	 mensaje[3][48]  = ascii(memoryD3[15:12]); mensaje[3][49]  = ascii(memoryD3[11:8]);
	 mensaje[3][50]  = ascii(memoryD3[7:4]);   mensaje[3][51]  = ascii(memoryD3[3:0]);
	 
	 //File 4.2: Registro D5
	 mensaje[4][40]  = "D"; mensaje[4][41]  = "5"; mensaje[4][42]  = ":";
    mensaje[4][43]  = " ";
    mensaje[4][44]  = ascii(memoryD4[31:28]); mensaje[4][45]  = ascii(memoryD4[27:24]);
    mensaje[4][46]  = ascii(memoryD4[23:20]); mensaje[4][47]  = ascii(memoryD4[19:16]);
	 mensaje[4][48]  = ascii(memoryD4[15:12]); mensaje[4][49]  = ascii(memoryD4[11:8]);
	 mensaje[4][50]  = ascii(memoryD4[7:4]);   mensaje[4][51]  = ascii(memoryD4[3:0]);
	 
	 //File 5.2: Registro D6
	 mensaje[5][40]  = "D"; mensaje[5][41]  = "6"; mensaje[5][42]  = ":";
    mensaje[5][43]  = " ";
    mensaje[5][44]  = ascii(memoryD5[31:28]); mensaje[5][45]  = ascii(memoryD5[27:24]);
    mensaje[5][46]  = ascii(memoryD5[23:20]); mensaje[5][47]  = ascii(memoryD5[19:16]);
	 mensaje[5][48]  = ascii(memoryD5[15:12]); mensaje[5][49]  = ascii(memoryD5[11:8]);
	 mensaje[5][50]  = ascii(memoryD5[7:4]);   mensaje[5][51]  = ascii(memoryD5[3:0]);
	 
	 //File 6.2: Registro D7
	 mensaje[6][40]  = "D"; mensaje[6][41]  = "7"; mensaje[6][42]  = ":";
    mensaje[6][43]  = " ";
    mensaje[6][44]  = ascii(memoryD6[31:28]); mensaje[6][45]  = ascii(memoryD6[27:24]);
    mensaje[6][46]  = ascii(memoryD6[23:20]); mensaje[6][47]  = ascii(memoryD6[19:16]);
	 mensaje[6][48]  = ascii(memoryD6[15:12]); mensaje[6][49]  = ascii(memoryD6[11:8]);
	 mensaje[6][50]  = ascii(memoryD6[7:4]);   mensaje[6][51]  = ascii(memoryD6[3:0]);
	 
	 //File 7.2: Registro D8
	 mensaje[7][40]  = "D"; mensaje[7][41]  = "8"; mensaje[7][42]  = ":";
    mensaje[7][43]  = " ";
    mensaje[7][44]  = ascii(memoryD7[31:28]); mensaje[7][45]  = ascii(memoryD7[27:24]);
    mensaje[7][46]  = ascii(memoryD7[23:20]); mensaje[7][47]  = ascii(memoryD7[19:16]);
	 mensaje[7][48]  = ascii(memoryD7[15:12]); mensaje[7][49]  = ascii(memoryD7[11:8]);
	 mensaje[7][50]  = ascii(memoryD7[7:4]);   mensaje[7][51]  = ascii(memoryD7[3:0]);
	 
	 //File 8.2: Registro D9
	 mensaje[8][40]  = "D"; mensaje[8][41]  = "9"; mensaje[8][42]  = ":";
    mensaje[8][43]  = " ";
    mensaje[8][44]  = ascii(memoryD8[31:28]); mensaje[8][45]  = ascii(memoryD8[27:24]);
    mensaje[8][46]  = ascii(memoryD8[23:20]); mensaje[8][47]  = ascii(memoryD8[19:16]);
	 mensaje[8][48]  = ascii(memoryD8[15:12]); mensaje[8][49]  = ascii(memoryD8[11:8]);
	 mensaje[8][50]  = ascii(memoryD8[7:4]);   mensaje[8][51]  = ascii(memoryD8[3:0]);
	 
	 //File 9.2: Registro DA
	 mensaje[9][40]  = "D"; mensaje[9][41]  = "A"; mensaje[9][42]  = ":";
    mensaje[9][43]  = " ";
    mensaje[9][44]  = ascii(memoryD9[31:28]); mensaje[9][45]  = ascii(memoryD9[27:24]);
    mensaje[9][46]  = ascii(memoryD9[23:20]); mensaje[9][47]  = ascii(memoryD9[19:16]);
	 mensaje[9][48]  = ascii(memoryD9[15:12]); mensaje[9][49]  = ascii(memoryD9[11:8]);
	 mensaje[9][50]  = ascii(memoryD9[7:4]);   mensaje[9][51]  = ascii(memoryD9[3:0]);
	 
	 //File 10.2: Registro DB
	 mensaje[10][40]  = "D"; mensaje[10][41]  = "B"; mensaje[10][42]  = ":";
    mensaje[10][43]  = " ";
    mensaje[10][44]  = ascii(memoryD10[31:28]); mensaje[10][45]  = ascii(memoryD10[27:24]);
    mensaje[10][46]  = ascii(memoryD10[23:20]); mensaje[10][47]  = ascii(memoryD10[19:16]);
	 mensaje[10][48]  = ascii(memoryD10[15:12]); mensaje[10][49]  = ascii(memoryD10[11:8]);
	 mensaje[10][50]  = ascii(memoryD10[7:4]);   mensaje[10][51]  = ascii(memoryD10[3:0]);
	 
	 //File 11.2: Registro DC
	 mensaje[11][40]  = "D"; mensaje[11][41]  = "C"; mensaje[11][42]  = ":";
    mensaje[11][43]  = " ";
    mensaje[11][44]  = ascii(memoryD11[31:28]); mensaje[11][45]  = ascii(memoryD11[27:24]);
    mensaje[11][46]  = ascii(memoryD11[23:20]); mensaje[11][47]  = ascii(memoryD11[19:16]);
	 mensaje[11][48]  = ascii(memoryD11[15:12]); mensaje[11][49]  = ascii(memoryD11[11:8]);
	 mensaje[11][50]  = ascii(memoryD11[7:4]);   mensaje[11][51]  = ascii(memoryD11[3:0]);
	 
	 //File 12.2: Registro DD
	 mensaje[12][40]  = "D"; mensaje[12][41]  = "D"; mensaje[12][42]  = ":";
    mensaje[12][43]  = " ";
    mensaje[12][44]  = ascii(memoryD12[31:28]); mensaje[12][45]  = ascii(memoryD12[27:24]);
    mensaje[12][46]  = ascii(memoryD12[23:20]); mensaje[12][47]  = ascii(memoryD12[19:16]);
	 mensaje[12][48]  = ascii(memoryD12[15:12]); mensaje[12][49]  = ascii(memoryD12[11:8]);
	 mensaje[12][50]  = ascii(memoryD12[7:4]);   mensaje[12][51]  = ascii(memoryD12[3:0]);
	 
	 //File 13.2: Registro DE
	 mensaje[13][40]  = "D"; mensaje[13][41]  = "E"; mensaje[13][42]  = ":";
    mensaje[13][43]  = " ";
    mensaje[13][44]  = ascii(memoryD13[31:28]); mensaje[13][45]  = ascii(memoryD13[27:24]);
    mensaje[13][46]  = ascii(memoryD13[23:20]); mensaje[13][47]  = ascii(memoryD13[19:16]);
	 mensaje[13][48]  = ascii(memoryD13[15:12]); mensaje[13][49]  = ascii(memoryD13[11:8]);
	 mensaje[13][50]  = ascii(memoryD13[7:4]);   mensaje[13][51]  = ascii(memoryD13[3:0]);
	 
	 //File 14.2: Registro DF
	 mensaje[14][40]  = "D"; mensaje[14][41]  = "F"; mensaje[14][42]  = ":";
    mensaje[14][43]  = " ";
    mensaje[14][44]  = ascii(memoryD14[31:28]); mensaje[14][45]  = ascii(memoryD14[27:24]);
    mensaje[14][46]  = ascii(memoryD14[23:20]); mensaje[14][47]  = ascii(memoryD14[19:16]);
	 mensaje[14][48]  = ascii(memoryD14[15:12]); mensaje[14][49]  = ascii(memoryD14[11:8]);
	 mensaje[14][50]  = ascii(memoryD14[7:4]);   mensaje[14][51]  = ascii(memoryD14[3:0]);
	 
	 // Fila 15.2 Registro X10
    mensaje[15][40]  = "D"; mensaje[15][41] = "1"; mensaje[15][42]  = "0"; mensaje[15][43]  = ":"; mensaje[15][44]  = " ";
    mensaje[15][45]  = ascii(memoryD15[31:28]);  mensaje[15][46]  = ascii(memoryD15[27:24]);
    mensaje[15][47]  = ascii(memoryD15[23:20]);  mensaje[15][48]  = ascii(memoryD15[19:16]);
    mensaje[15][49]  = ascii(memoryD15[15:12]);  mensaje[15][50]  = ascii(memoryD15[11:8]);
    mensaje[15][51]  = ascii(memoryD15[7:4]);    mensaje[15][52]  = ascii(memoryD15[3:0]);

    // Fila 16.2 Registro X11
    mensaje[16][40]  = "D"; mensaje[16][41]  = "1"; mensaje[16][42] = "1"; mensaje[16][43]  = ":"; mensaje[16][44]  = " ";
    mensaje[16][45]  = ascii(memoryD16[31:28]);   mensaje[16][46] = ascii(memoryD16[27:24]);
    mensaje[16][47]  = ascii(memoryD16[23:20]);   mensaje[16][48] = ascii(memoryD16[19:16]);
    mensaje[16][49]  = ascii(memoryD16[15:12]);   mensaje[16][50] = ascii(memoryD16[11:8]);
    mensaje[16][51]  = ascii(memoryD16[7:4]);     mensaje[16][52] = ascii(memoryD16[3:0]);

    // Fila 17.2 Registro X12
    mensaje[17][40]  = "D"; mensaje[17][41]  = "1"; mensaje[17][42] = "2"; mensaje[17][43]  = ":"; mensaje[17][44]  = " ";
    mensaje[17][45]  = ascii(memoryD17[31:28]);   mensaje[17][46] = ascii(memoryD17[27:24]);
    mensaje[17][47]  = ascii(memoryD17[23:20]);   mensaje[17][48] = ascii(memoryD17[19:16]);
    mensaje[17][49]  = ascii(memoryD17[15:12]);   mensaje[17][50] = ascii(memoryD17[11:8]);
    mensaje[17][51]  = ascii(memoryD17[7:4]);     mensaje[17][52] = ascii(memoryD17[3:0]);

    // Fila 18.2 Registro X13
    mensaje[18][40]  = "D"; mensaje[18][41]  = "1"; mensaje[18][42]  = "3"; mensaje[18][43]  = ":"; mensaje[18][44]  = " ";
    mensaje[18][45]  = ascii(memoryD18[31:28]);   mensaje[18][46]  = ascii(memoryD18[27:24]);
    mensaje[18][47]  = ascii(memoryD18[23:20]);   mensaje[18][48]  = ascii(memoryD18[19:16]);
    mensaje[18][49]  = ascii(memoryD18[15:12]);   mensaje[18][50]  = ascii(memoryD18[11:8]);
    mensaje[18][51]  = ascii(memoryD18[7:4]);     mensaje[18][52]  = ascii(memoryD18[3:0]);

    // Fila 19.2 Registro X14
    mensaje[19][40] = "D"; mensaje[19][41] = "1"; mensaje[19][42] = "4"; mensaje[19][43] = ":"; mensaje[19][44] = " ";
    mensaje[19][45] = ascii(memoryD19[31:28]); mensaje[19][46] = ascii(memoryD19[27:24]);
    mensaje[19][47] = ascii(memoryD19[23:20]); mensaje[19][48] = ascii(memoryD19[19:16]);
    mensaje[19][49] = ascii(memoryD19[15:12]); mensaje[19][50] = ascii(memoryD19[11:8]);
    mensaje[19][51] = ascii(memoryD19[7:4]);   mensaje[19][52] = ascii(memoryD19[3:0]);

    // Fila 20.2 Registro X15
    mensaje[20][40] = "D"; mensaje[20][41] = "1"; mensaje[20][42] = "5"; mensaje[20][43] = ":"; mensaje[20][44] = " ";
    mensaje[20][45] = ascii(memoryD20[31:28]); mensaje[20][46] = ascii(memoryD20[27:24]);
    mensaje[20][47] = ascii(memoryD20[23:20]); mensaje[20][48] = ascii(memoryD20[19:16]);
    mensaje[20][49] = ascii(memoryD20[15:12]); mensaje[20][50] = ascii(memoryD20[11:8]);
    mensaje[20][51] = ascii(memoryD20[7:4]);   mensaje[20][52] = ascii(memoryD20[3:0]);

	 

  end

  parameter TEXT_X = 240;
  parameter TEXT_Y = 40;
  parameter CHAR_W = 8;
  parameter CHAR_H = 16;
  
  // CORRECCIÓN 5: Lógica para seleccionar el carácter correcto de la memoria 2D
  wire [5:0] text_row = (y - TEXT_Y) / CHAR_H;
  wire [6:0] text_col = (x - TEXT_X) / CHAR_W;

  wire inside_text = (y >= TEXT_Y && y < TEXT_Y + (CHAR_H * 31) && //50 filas
                      x >= TEXT_X && x < TEXT_X + (CHAR_W * 80)); // 160 columnas

  assign row_in_char = (y - TEXT_Y) % CHAR_H;
  assign col_in_char = (x - TEXT_X) % CHAR_W;
  
  // Se accede a la memoria 'mensaje' usando tanto la fila como la columna.
  assign ascii_code  = mensaje[text_row][text_col];

  // ============================================================
  // Color de salida VGA
  // ============================================================
  always @(*) begin
    if (~videoOn)
      {vga_red, vga_green, vga_blue} = 24'h000000;
    else if (inside_text && pixel_on)
      {vga_red, vga_green, vga_blue} = 24'hFFFFFF; // Texto blanco
    else
      {vga_red, vga_green, vga_blue} = 24'h000000; // Fondo negro
  end

endmodule


module vga_controller_1280x800 (
  input clk,
  input reset,
  output wire hsync,
  output wire vsync,
  output reg [10:0] hcount,
  output reg [9:0]  vcount,
  output video_on
);

  parameter H_VISIBLE = 1280;
  parameter H_FP      = 48;
  parameter H_SYNC    = 32;
  parameter H_BP      = 80;
  parameter H_TOTAL   = H_VISIBLE + H_FP + H_SYNC + H_BP;

  parameter V_VISIBLE = 800;
  parameter V_FP      = 3;
  parameter V_SYNC    = 6;
  parameter V_BP      = 22;
  parameter V_TOTAL   = V_VISIBLE + V_FP + V_SYNC + V_BP;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      hcount <= 0;
      vcount <= 0;
    end else begin
      if (hcount == H_TOTAL - 1) begin
        hcount <= 0;
        if (vcount == V_TOTAL - 1)
          vcount <= 0;
        else
          vcount <= vcount + 1;
      end else begin
        hcount <= hcount + 1;
      end
    end
  end

  assign hsync = (hcount >= H_VISIBLE + H_FP) && 
                 (hcount < H_VISIBLE + H_FP + H_SYNC);
  assign vsync = (vcount >= V_VISIBLE + V_FP) && 
                 (vcount < V_VISIBLE + V_FP + V_SYNC);
  assign video_on = (hcount < H_VISIBLE) && (vcount < V_VISIBLE);
endmodule