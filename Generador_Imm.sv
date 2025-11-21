module Generador_Imm(
input wire [31:0] inst,
input wire [2:0] IMMSrc,
output wire [31:0] imm
);

	always @(*) begin
    case (IMMSrc)
      3'b000: imm = {{20{inst[31]}}, inst[31:20]};                            // tipo i
      3'b001: imm = {{20{inst[31]}}, inst[31:20]};                            // tipo i carga
		3'b010: imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};                //tipo S
		3'b011: imm = {{19{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}; //tipo B
		3'b100: imm = {inst[31:12], 12'b0};                                     //tipo U
		3'b101: imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};//tipo j

      default: imm = 12'b0;
    endcase
  end



endmodule