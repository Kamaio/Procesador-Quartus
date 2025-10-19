module ALU(
  input  wire [31:0] valA,
  input  wire [31:0] valB,
  input  wire [3:0]  operacion,
  output reg  [31:0] resultado
);
  always @(*) begin
    case (operacion)
      4'b0000: resultado = valA + valB;                     // add
      4'b0001: resultado = valA << valB[4:0];               // sll
      4'b0010: resultado = ($signed(valA) < $signed(valB)); // slt
      4'b0011: resultado = (valA < valB);                   // sltu
      4'b0100: resultado = valA ^ valB;                     // xor
      4'b0101: resultado = valA >> valB[4:0];               // srl
      4'b0110: resultado = valA | valB;                     // or
      4'b0111: resultado = valA & valB;                     // and
      4'b1000: resultado = valA - valB;                     // sub
      4'b1101: resultado = $signed(valA) >>> valB[4:0];     // sra
      default: resultado = 32'h0;
    endcase
  end
endmodule
