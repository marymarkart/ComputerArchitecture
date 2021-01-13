`timescale 1ns/1ps

module barrel_shifter_tb;

reg [31:0] D;
reg [4:0] S;

wire [31:0] Y;

SHIFT32_L shift_left(.Y(Y), .D(D), .S(S));
initial
begin
#5 D='b1111; S='b0010;
#5;
end

reg [31:0] Dr;
reg [4:0] Sr;
wire [31:0] Yr;

//SHIFT32_R shift_right(.Y(Yr), .D(Dr), .S(Sr));
//initial
//begin
//#5 Dr='b10000; Sr='b00101;
//#5;
//end
//
//reg [31:0] Db;
//reg [31:0] Sb;
//reg LnR;
//wire [31:0] Yb;

//SHIFT32 barrel_shift(.Y(Yb),.D(Db),.S(Sb), .LnR(LnR));
//initial
//begin
//#5 Db= 'b1111; Sb= 'b10; LnR = 1;
//#5 Db='b111100; Sb='b10; LnR =0;
//#5 Db='b1111; Sb='b111111; LnR=1;
//#5;
//end
endmodule