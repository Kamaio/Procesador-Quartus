module control_unit(
input wire [6:0] opcode,
input wire [2:0] funct3,
input wire [6:0] funct7,


//decode
output wire RUWr,

//execute
output wire [3:0] ALUop
);


wire [9:0] combinacion = {funct7, funct3};

assign RUWr = 1'b1;


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
      default:        ALUop = 32'h0;
    endcase
  end
endmodule