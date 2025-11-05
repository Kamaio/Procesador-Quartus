module dataMemory(
    input wire clk,
    input wire [31:0] address,  //posicion a buscar o escribir(ALU)
    input wire [31:0] writeData,   // informacion que se escribe
    input wire 		 DMWR,   // 1 = write, 0 = read
    input wire [2:0]  DMCtrl,   // cuanto vamos a cargar/guardar (b8, h16, w32)
	 
    output reg [31:0] DataRd,  // Informacion de data memory que se carga (i carga)
	 
	 output wire [7:0] memoryD0,//vga
	 output wire [7:0] memoryD1,
	 output wire [7:0] memoryD2,
	 output wire [7:0] memoryD3,
	 output wire [7:0] memoryD4,
	 output wire [7:0] memoryD5,
	 output wire [7:0] memoryD6,
	 output wire [7:0] memoryD7,
	 output wire [7:0] memoryD8,
	 output wire [7:0] memoryD9,
	 output wire [7:0] memoryD10,
    output wire [7:0] memoryD11,
    output wire [7:0] memoryD12,
    output wire [7:0] memoryD13,
    output wire [7:0] memoryD14,
    output wire [7:0] memoryD15,
    output wire [7:0] memoryD16,
    output wire [7:0] memoryD17,
    output wire [7:0] memoryD18,
    output wire [7:0] memoryD19,
    output wire [7:0] memoryD20,
	 
	 output wire [31:0] salidaChimbaW, // Tipo s, escribir
	 output wire [31:0] salidaChimbaR  // Tipo I carga, leer
);

    reg [7:0] memoria [0:20]; // En memoria se gurda al contrario
	 assign memoryR0   = memoria[0];//vga
	 assign memoryR1   = memoria[1];
    assign memoryR2   = memoria[2];
    assign memoryR3   = memoria[3];
	 assign memoryR4   = memoria[4];
	 assign memoryR5   = memoria[5];
	 assign memoryR6   = memoria[6];
	 assign memoryR7   = memoria[7];
	 assign memoryR8   = memoria[8];
	 assign memoryR9   = memoria[9];
	 assign memoryR10  = memoria[10];
	 assign memoryR11  = memoria[11];
	 assign memoryR12  = memoria[12];
	 assign memoryR13  = memoria[13];
	 assign memoryR14  = memoria[14];
	 assign memoryR15  = memoria[15];
	 assign memoryR16  = memoria[16];
	 assign memoryR17  = memoria[17];
	 assign memoryR18  = memoria[18];
	 assign memoryR19  = memoria[19];
	 assign memoryR20  = memoria[20];
	 

    // Escritura sincrónica
    always @(posedge clk) begin
        if (DMWR) begin
            case(DMCtrl)
                3'b000: memoria[address] <= writeData[7:0]; // Sb
                3'b001: begin
                    memoria[address]   <= writeData[7:0];   //Sh
                    memoria[address+1] <= writeData[15:8];
                end
                3'b010: begin
                    memoria[address]   <= writeData[7:0];   //Sw
                    memoria[address+1] <= writeData[15:8];
                    memoria[address+2] <= writeData[23:16];
                    memoria[address+3] <= writeData[31:24];
                end
            endcase
				
				salidaChimbaW = writeData[31:0];
        end
    end

    // Lectura combinacional
    always @(*) begin
        case(DMCtrl)
            3'b000: DataRd = {{24{memoria[address][7]}}, memoria[address]}; // LB 8
            3'b001: DataRd = {{16{memoria[address+1][7]}}, memoria[address+1], memoria[address]}; // LH 16
            3'b010: DataRd = {memoria[address+3], memoria[address+2], memoria[address+1], memoria[address]}; // LW 32
            default: DataRd = 0;
        endcase
		  
		  salidaChimbaR = DataRd;
    end

endmodule