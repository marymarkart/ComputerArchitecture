// Name: mux.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
// 32-bit mux
module MUX32_32x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15,
                     I16, I17, I18, I19, I20, I21, I22, I23,
                     I24, I25, I26, I27, I28, I29, I30, I31, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0, I1, I2, I3, I4, I5, I6, I7;
input [31:0] I8, I9, I10, I11, I12, I13, I14, I15;
input [31:0] I16, I17, I18, I19, I20, I21, I22, I23;
input [31:0] I24, I25, I26, I27, I28, I29, I30, I31;
input [4:0] S;

wire [31:0] mux1;
wire [31:0] mux2;
wire [31:0] mux3;

MUX32_16x1 mux_inst1(.Y(mux1), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5), .I6(I6), .I7(I7),
                     .I8(I8), .I9(I9), .I10(I10), .I11(I11), .I12(I12), .I13(I13), .I14(I14), .I15(I15), .S(S[3:0]));
MUX32_16x1 mux_inst2(.Y(mux2), .I0(I16), .I1(I17), .I2(I18), .I3(I19), .I4(I20), .I5(I21), .I6(I22), .I7(I23),
                     .I8(I24), .I9(I25), .I10(I26), .I11(I27), .I12(I28), .I13(I29), .I14(I30), .I15(I31), .S(S[3:0]));
MUX32_2x1 mux_inst3(.Y(Y), .I0(mux1), .I1(mux2), .S(S[4]));

endmodule

// 32-bit 16x1 mux
module MUX32_16x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [31:0] I4;
input [31:0] I5;
input [31:0] I6;
input [31:0] I7;
input [31:0] I8;
input [31:0] I9;
input [31:0] I10;
input [31:0] I11;
input [31:0] I12;
input [31:0] I13;
input [31:0] I14;
input [31:0] I15;
input [3:0] S;

wire [31:0] mux1_S0;
wire [31:0] mux2_S0;
wire [31:0] mux3_S1;

MUX32_8x1 mux_inst1(.Y(mux1_S0), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5), .I6(I6), .I7(I7), .S(S[2:0]));
MUX32_8x1 mux_inst2(.Y(mux2_S0), .I0(I8), .I1(I9), .I2(I10), .I3(I11), .I4(I12), .I5(I13), .I6(I14), .I7(I15), .S(S[2:0]));
MUX32_2x1 mux_inst3(.Y(Y), .I0(mux1_S0), .I1(mux2_S0), .S(S[3]));

endmodule

// 32-bit 8x1 mux
module MUX32_8x1(Y, I0, I1, I2, I3, I4, I5, I6, I7, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [31:0] I4;
input [31:0] I5;
input [31:0] I6;
input [31:0] I7;
input [2:0] S;

wire [31:0] mux1_S0;
wire [31:0] mux2_S0;
wire [31:0] mux3_S1;

MUX32_4x1 mux_inst1(.Y(mux1_S0), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .S(S[1:0]));
MUX32_4x1 mux_inst2(.Y(mux2_S0), .I0(I4), .I1(I5), .I2(I6), .I3(I7), .S(S[1:0]));
MUX32_2x1 mux_inst3(.Y(Y), .I0(mux1_S0), .I1(mux2_S0), .S(S[2]));


endmodule

// 32-bit 4x1 mux
module MUX32_4x1(Y, I0, I1, I2, I3, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [1:0] S;

wire [31:0] mux1_S0;
wire [31:0] mux2_S0;
wire [31:0] mux3_S1;

MUX32_2x1 mux_inst1(.Y(mux1_S0), .I0(I0), .I1(I1), .S(S[0]));
MUX32_2x1 mux_inst2(.Y(mux2_S0), .I0(I2), .I1(I3), .S(S[0]));
MUX32_2x1 mux_inst3(.Y(Y), .I0(mux1_S0), .I1(mux2_S0), .S(S[1]));


endmodule

// 32-bit mux
module MUX32_2x1(Y, I0, I1, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input S;

wire notS;
wire [31:0] and1;
wire [31:0] and2;

genvar i;
not not_int1b(notS, S);

generate
for(i=0; i<32; i=i+1)
  begin
   MUX1_2x1 mux2x1_inst32(.Y(Y[i]), .I0(I0[i]), .I1(I1[i]), .S(S));
  end
endgenerate

endmodule

// 1-bit mux
module MUX1_2x1(Y,I0, I1, S);
//output list
output Y;
//input list
input I0, I1, S;

wire notS;
wire and1;
wire and2;

//not not_int1b(notS, S);
and and_1b_inst1(and1, I0, ~S);
and and_1b_inst2(and2, I1, S);
or or_1b_inst(Y, and1, and2);

endmodule

module MUX64_2x1(Y, I0, I1, S);
// output list
output [63:0] Y;
//input list
input [63:0] I0;
input [63:0] I1;
input S;

wire notS;
wire [63:0] and1;
wire [63:0] and2;

genvar i;
not not_int1b(notS, S);

generate
for(i=0; i<64; i=i+1)
  begin
   MUX1_2x1 mux2x1_inst32(.Y(Y[i]), .I0(I0[i]), .I1(I1[i]), .S(S));
  end
endgenerate

endmodule