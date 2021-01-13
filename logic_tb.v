`include "prj_definition.v"

module logic_tb;

   reg [4:0] I;
   wire [31:0] De;
   reg 	       C, R, L, C2, R2, L2;
   reg [31:0]  D, D2;
   wire [31:0] Q, Q2;

   REG32 r(Q, D, L, C, R);   

   DECODER_5x32 decoder(De, I);
   
   initial
     begin
	I = 5'b10101;
	#5;
	R = 0;
	C = 0;
	D = 0;
	L = 0;
	#5 R = 1;
	#5 D = 32'h02468ace; 
	#5 L = 1;
	#5 C = 1;
	#5 L = 0;
	#5 C = 0;
	#5 D = 32'h13579bdf;
	#5 L = 1;
	#5 C = 1;
	#5 L = 0;
	#5 C = 0;
	#5 C = 1;
	#5 C = 0;
	#5 R = 0;
	#5 R = 1;
	#5;
	R2 = 0;
	C2 = 0;
	D2 = 0;
	L2 = 0;
	#5;
	
     end
endmodule // logic