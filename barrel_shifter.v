// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [31:0] S;
input LnR;

wire [31:0] barrel_res;
wire [25:0] or27res;

BARREL_SHIFTER32 barrel_shift(.Y(barrel_res),.D(D),.S(S[4:0]), .LnR(LnR));

genvar i;
or or_inst27(or27res[0], S[6], S[5]);
generate
for (i=7;i<32;i=i+1)
    begin
	or or_inst27(or27res[i-6], S[i], or27res[i-7]);
    end
endgenerate

MUX32_2x1 shift_select(.Y(Y), .I0(barrel_res), .I1(32'b0), .S(or27res[25]));

endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
input LnR;

wire [31:0] right_res;
wire [31:0] left_res;

SHIFT32_R right_shift(.Y(right_res),.D(D),.S(S));
SHIFT32_L left_shift(.Y(left_res),.D(D),.S(S));

MUX32_2x1 shift_select(.Y(Y), .I0(right_res), .I1(left_res), .S(LnR));

endmodule

// Right shifter
module SHIFT32_R(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

wire [31:0] shifts [31:0];



//shift S0
genvar i;
generate
for (i=0;i<31;i=i+1)
    begin
	MUX32_2x1 mux_bshifter(.Y(shifts[0][i]), .I0(D[i]), .I1(D[i+1]), .S(S[0]));
    end
endgenerate
MUX32_2x1 mux_bshift(.Y(shifts[0][31]),.I0(D[31]), .I1(1'b0), .S(S[0]));

//shift S1
genvar j;
generate
for (j=0;j<32;j=j+1)
    begin
	if (j>=30)
	begin
	MUX32_2x1 mux_bshift2(.Y(shifts[1][j]),.I0(shifts[0][j]), .I1(1'b0), .S(S[1]));
	end
	else
	MUX32_2x1 mux_bshifter(.Y(shifts[1][j]),.I0(shifts[0][j]), .I1(shifts[0][j+2]), .S(S[1]));
    end
endgenerate


//shift S2
genvar k;
generate
for (k=0;k<32;k=k+1)
    begin
	if (k>=28)
	begin
	MUX32_2x1 mux_bshift4(.Y(shifts[2][k]),.I0(shifts[1][k]), .I1(1'b0), .S(S[2]));
	end
 	else   
	MUX32_2x1 mux_bshifter(.Y(shifts[2][k]),.I0(shifts[1][k]), .I1(shifts[1][k+4]), .S(S[2]));
    end
endgenerate


//shift S3
genvar l;
generate
for (l=0;l<32;l=l+1)
    begin
	if (l>=24)
	begin
	MUX32_2x1 mux_bshift8(.Y(shifts[3][l]),.I0(shifts[2][l]), .I1(1'b0), .S(S[3]));
	end
	else
	MUX32_2x1 mux_bshift4(.Y(shifts[3][l]),.I0(shifts[2][l]), .I1(shifts[2][l+8]), .S(S[3]));
    end
endgenerate


//shift S4
genvar m;
generate
for (m=0;m<32;m=m+1)
    begin
	if (m>=16)
	begin
	MUX32_2x1 mux_bshift11(.Y(shifts[4][m]),.I0(shifts[3][m]), .I1(1'b0), .S(S[4]));
	end
	else
	MUX32_2x1 mux_bshift4(.Y(shifts[4][m]),.I0(shifts[3][m]), .I1(shifts[3][m+16]), .S(S[4]));
    end
endgenerate
assign Y = {shifts[4][31:0]};

endmodule

// Left shifter
module SHIFT32_L(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

wire [31:0] shifts [31:0];

wire mux_res;

//shift S0
genvar i;
MUX32_2x1 mux_bshift(.Y(shifts[0][0]),.I0(D[0]), .I1(1'b0), .S(S[0]));
generate
for (i=1;i<32;i=i+1)
    begin
	MUX32_2x1 mux_bshifter(.Y(shifts[0][i]), .I0(D[i]), .I1(D[i-1]), .S(S[0]));
    end
endgenerate
//shift S1
genvar j;
generate
for (j=0;j<32;j=j+1)
    begin
	if (j<=1)
	begin
	MUX32_2x1 mux_bshifter(.Y(shifts[1][j]), .I0(shifts[0][j]), .I1(1'b0), .S(S[1]));
	end
	else
	MUX32_2x1 mux_bshifter(.Y(shifts[1][j]),.I0(shifts[0][j]), .I1(shifts[0][j-2]), .S(S[1]));
    end
endgenerate
//shift S2
genvar k;
generate
for (k=0;k<32;k=k+1)
    begin
	if (k<=3)
	begin
	MUX32_2x1 mux_bshifter(.Y(shifts[2][k]),.I0(shifts[1][k]), .I1(1'b0), .S(S[2]));
	end
	else
	MUX32_2x1 mux_bshifter(.Y(shifts[2][k]),.I0(shifts[1][k]), .I1(shifts[1][k-4]), .S(S[2]));
    end
endgenerate
//shift S3
genvar l;
generate
for (l=0;l<32;l=l+1)
    begin
	if (l <=7)
	begin
	MUX32_2x1 mux_bshifter(.Y(shifts[3][l]),.I0(shifts[2][l]), .I1(1'b0), .S(S[3]));
	end
	else
	MUX32_2x1 mux_bshifter(.Y(shifts[3][l]),.I0(shifts[2][l]), .I1(shifts[2][l-8]), .S(S[3]));
    end
endgenerate
//shift S4
genvar m;
generate
for (m=0;m<32;m=m+1)
    begin
	if (m<=15)
	begin
	MUX32_2x1 mux_bshift11(.Y(shifts[4][m]),.I0(shifts[3][m]), .I1(1'b0), .S(S[4]));
	end
	else
	MUX32_2x1 mux_bshifter(.Y(shifts[4][m]),.I0(shifts[3][m]), .I1(shifts[3][m-16]), .S(S[4]));
    end
endgenerate

assign Y = {shifts[4][31:0]};

endmodule

