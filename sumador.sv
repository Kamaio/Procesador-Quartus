module sumador(
  input  wire [31:0] address,
  output wire [31:0] nextPC
);
  assign nextPC = address + 32'h4;
endmodule
