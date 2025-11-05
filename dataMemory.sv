module dataMemory(
    input wire clk,
    input wire [31:0] address,  //posicion a buscar o escribir(ALU)
    input wire [31:0] writeData,   // informacion que se escribe
    input wire 		 DMWR,   // 1 = write, 0 = read
    input wire [2:0]  DMCtrl,   // cuanto vamos a cargar/guardar (b8, h16, w32)
	 
    output reg [31:0] DataRd,  // Informacion de data memory que se carga (i carga)
	 
	 output wire [31:0] salidaChimbaW, // Tipo s, escribir
	 output wire [31:0] salidaChimbaR  // Tipo I carga, leer
);

    reg [7:0] memoria [0:127]; // En memoria se gurda al contrario
	 

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