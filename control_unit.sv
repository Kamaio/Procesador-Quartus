module control_unit(
input wire [6:0] opcode,
input wire [2:0] funct3,
input wire [6:0] funct7,


//decode
output wire RUWr,
output wire [2:0] IMMSrc,

//execute
output reg [3:0] ALUop,
output reg ALUBSrc,
output reg [3:0] BrOp, 
output reg ALUASrc,

//memory
output reg DMWR,
output reg[2:0] DMCtrl,

//wb
output reg[2:0] RUDataWrSrc
);


wire [9:0] combinacion = {funct7, funct3};


always @(*) begin
	 
	case (opcode)
		7'b0110011: begin        //tipo r
			RUWr = 1'b1;
			ALUASrc = 1'b0;       //multiplexor A
			ALUBSrc = 1'b0;       //multiplexor B
			RUDataWrSrc = 2'b0;   //deja pasara el resultado de la ALU
			DMWR = 1'b0;			 // Permiso de escribir en la data memory
			
			BrOp = 4'b0000;       //apaga la branch unit
			
			case (combinacion)
				10'b0000000000: ALUop = 4'b0000; // add
				10'b0000000001: ALUop = 4'b0001; // sll
				10'b0000000010: ALUop = 4'b0010; // slt
				10'b0000000011: ALUop = 4'b0011; // sltu
				10'b0000000100: ALUop = 4'b0100; // xor
				10'b0000000101: ALUop = 4'b0101; // srl
				10'b0000000110: ALUop = 4'b0110; // or
				10'b0000000111: ALUop = 4'b0111; // and
				10'b1000000000: ALUop = 4'b1000; // sub
				10'b1000000101: ALUop = 4'b1101; // sra
				default:        ALUop = 4'b0;
			 endcase
			
		end
	
	
		7'b0010011: begin
			RUWr = 1'b1;
			IMMSrc  = 3'b000;     // tipo i
			ALUASrc = 1'b0;       //multiplexor A
			ALUBSrc = 1'b1;       //multiplexor B
			RUDataWrSrc = 2'b0;   //deja pasara el resultado de la ALU
			DMWR = 1'b0;
			
			BrOp = 4'b0000;       //apaga la branch unit
			
			case (funct3)
				3'b000: ALUop = 4'b0000; // add
				3'b001: ALUop = 4'b0001; // sll
				3'b010: ALUop = 4'b0010; // slt
				3'b011: ALUop = 4'b0011; // sltu
				3'b100: ALUop = 4'b0100; // xor
				3'b101: ALUop = 4'b0101; // srl
				3'b110: ALUop = 4'b0110; // or
				3'b111: ALUop = 4'b0111; // and
				3'b101: ALUop = 4'b1101; // sra
				default:        ALUop = 4'b0;
			 endcase
		end
		
      7'b0000011: begin
			RUWr = 1'b1;
			IMMSrc  = 3'b001;     // tipo i de carga
			ALUASrc = 1'b0;       // multiplexor A
			ALUBSrc = 1'b1;       // multiplexor B
			ALUop = 4'b0000;      // add
			
			DMWR = 1'b0;          // tipo I de carga
			
			DMCtrl = funct3;      //aca se decide cuantos bits se agarra de la memoria
			RUDataWrSrc = 2'b01;  //deja pasar el resultado de la data memory
			
			BrOp = 4'b0000;       //apaga la branch unit
			
		end
		
      7'b0100011: begin
			RUWr = 1'b0;          //le dice a la register unit que no escriba nada
			IMMSrc = 3'b010;      // tipo S
			ALUASrc = 1'b0;       // multiplexor A
			ALUBSrc = 1'b1;       // multiplexor B
			ALUop = 4'b0000;      // add(problema explicar a andrea)
			
			DMWR = 1'b1;          //escribir en la data memory
			
			DMCtrl = funct3;
			RUDataWrSrc = 2'b01;  //mux de data memory pero esto deberia dar igual porque no escribe nada en la register unit
			
			BrOp = 4'b0000;       //apaga la branch unit
		end

		7'b1100011: begin			//tipo B
			RUWr = 1'b1;         
			IMMSrc = 3'b011;
			ALUASrc = 1'b1;      //multiplerxor A manda el pc en vez de el registro rs1
			ALUBSrc = 1'b1;      //multiplexor B
			ALUop = 4'b0000;     //add
			
			DMWR = 1'b0;
			
			case(funct3)
				3'b000: BrOp = 4'b1000; //equal
				3'b001: BrOp = 4'b1001; //diff
				3'b010: BrOp = 4'b1100; //menorq
				3'b011: BrOp = 4'b1101; //mayorq
				default: BrOp = 4'b0;
			endcase
		end
		
      default: begin  
			IMMSrc = 3'h0;
			ALUBSrc = 1'b0;
		end
		
    endcase
	 
	 
	 
	 
	 
	 
  end
endmodule