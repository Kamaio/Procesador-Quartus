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

//memory
output reg DMWR,
output reg[2:0] DMCtrl,

//wb
output reg[2:0] RUDataWrSrc
);


wire [9:0] combinacion = {funct7, funct3};


always @(*) begin
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
	 
	 
	case (opcode)
		7'b0110011: begin
			RUWr = 1'b1;
			ALUBSrc = 1'b0;
			RUDataWrSrc = 2'b0;   //quita permiso de la data memory
			DMWR = 1'b0;
		end
	
	
		7'b0010011: begin
			RUWr = 1'b1;
			IMMSrc  = 3'b000;     // tipo i
			ALUBSrc = 1'b1;       // permiso mux
			RUDataWrSrc = 2'b0;   //quita permiso de la data memory 
		end
		
      7'b0000011: begin
			RUWr = 1'b1;
			IMMSrc  = 3'b001;     // tipo i de carga
			ALUBSrc = 1'b1;       // permiso mux
			ALUop = 4'b0000;      // add
			
			DMWR = 1'b0;          // tipo I de carga
			
			DMCtrl = funct3;      //aca se decide cuantos bits se agarra de la memoria
			RUDataWrSrc = 2'b01;  //mux de data memory
			
		end
		
      7'b0100011: begin
			RUWr = 1'b0;
			IMMSrc = 3'b010;      // tipo S
			ALUBSrc = 1'b1;       // permiso mux
		end

      default: begin  
			IMMSrc = 3'h0;
			ALUBSrc = 1'b0;
		end
		
    endcase
	 
	 
	 
	 
	 
	 
  end
endmodule