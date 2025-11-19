module branch_unit(

	input wire [31:0] valA,
	input wire [31:0] valB,
	input wire [3:0] operacion,
	
	output wire resultado
);

always @ (*) begin
	case (operacion)
		4'b1000: resultado = ($signed(valA) == $signed(valB)); //Equal
		4'b1001: resultado = ($signed(valA) != $signed(valB)); //Diff
		4'b1100: resultado = ($signed(valA) < $signed(valB));  //Menorq
		4'b1101: resultado = ($signed(valA) >= $signed(valB)); //Mayorq
		default: resultado = 1'b0;
    endcase
  end
endmodule