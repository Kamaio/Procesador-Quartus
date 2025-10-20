module dataMemory(
	input wire[31:0] address,
	//aca va la sehgunda entarda que aun no se usa
	input wire DMWR,
	input wire[2:0] DMCtrl,
	
	output reg[31:0] DataRd
);
	
	reg [7:0] memoria [0:127];
	
	wire [7:0]  b0 = memoria[address + 0];
	wire [7:0]  b1 = memoria[address + 1];
	wire [7:0]  b2 = memoria[address + 2];
	wire [7:0]  b3 = memoria[address + 3];
		

	always @(*)begin
	
		if(DMWR)begin
		//aca van las cosas de las tipo S porque DMRW esta encendido
		end
		
		else begin
			case(DMCtrl) 
				3'b000:  DataRd = {{ 24{b0[7]} }, b0 };             //8  lb
				3'b001:  DataRd = {{ 16{b1[7]} }, b1, b0 };         //16 lh
				3'b010:  DataRd = {               b3, b2, b1, b0 }; //32 lw
				3'b100:  DataRd = { 24'b0,        b0};              //8  lb sin la u
				3'b101:  DataRd = { 16'b0,        b1, b0 };         //16 lh sin la u porque aun no se como funciona
				default: DataRd = 32'b0;
			endcase
		end
	
	end

endmodule