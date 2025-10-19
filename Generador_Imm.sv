module Generador_Imm(
input wire [31:0] inst,
input wire [2:0] IMMSrc,
output wire [31:0] imm
);

	always @(*) begin
    case (IMMSrc)
      3'b000: imm = {{20{inst[31]}}, inst[31:20]};   // tipo i
      3'b001: imm = {inst[31:25], inst[4:0]};        // tipo i carga

      default: imm = 12'b0;
    endcase
  end



endmodule