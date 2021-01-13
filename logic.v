// Name: logic.v
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
// 64-bit two's complement
module TWOSCOMP64(Y,A);
//output list
output [63:0] Y;
//input list
input [63:0] A;

wire [63:0] not_a;
wire CO;

genvar i;
generate
for(i=0; i<64; i=i+1)
begin : inv64_gen_loop
       not not_inst(not_a[i], A[i]);
    end
endgenerate
RC_ADD_SUB_64 add2c_inst1(.Y(Y), .CO(CO), .A(not_a), .B(64'b1), .SnA(1'b0));

endmodule

// 32-bit two's complement
module TWOSCOMP32(Y,A);
//output list
output [31:0] Y;
//input list
input [31:0] A;

wire [31:0] not_a;
wire CO;

INV32_1x1 inv2c_inst(.Y(not_a), .A(A));
RC_ADD_SUB_32 add2c_inst(.Y(Y), .CO(CO), .A(not_a), .B(32'b1), .SnA(1'b0));

endmodule

// 32-bit registere +ve edge, Reset on RESET=0
module REG32(Q, D, LOAD, CLK, RESET);
output [31:0] Q;
wire [31:0] Qbar;

input CLK, LOAD;
input [31:0] D;
input RESET;

genvar i;

generate
for (i=0;i<32;i=i+1)
	begin
	REG1 reg_32b_inst(.Q(Q[i]), .Qbar(Qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(1'b1), .nR(RESET));
	end
endgenerate
endmodule

// 1 bit register +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module REG1(Q, Qbar, D, L, C, nP, nR);
input D, C, L;
input nP, nR;
output Q,Qbar;

wire mux_d;

MUX1_2x1 mux_selectD_inst(.Y(mux_d),.I0(Q), .I1(D), .S(L));
D_FF reg_ff_inst(.Q(Q), .Qbar(Qbar), .D(mux_d), .C(C), .nP(nP), .nR(nR));

endmodule

module REG32_PP(Q, D, LOAD, CLK, RESET);
parameter PATTERN = 32'h00000000;
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

wire [31:0] qbar;

genvar i;
generate 
for(i=0; i<32; i=i+1)
begin : reg32_gen_loop
if (PATTERN[i] == 0)
REG1 reg_inst(.Q(Q[i]), .Qbar(qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(1'b1), .nR(RESET)); 
else
REG1 reg_inst(.Q(Q[i]), .Qbar(qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(RESET), .nR(1'b1));
end 
endgenerate

endmodule

// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

wire Y;
wire Ybar;

D_LATCH dLatch(.Q(Y), .Qbar(Ybar), .D(D), .C(~C), .nP(nP), .nR(nR));
SR_LATCH srLatch(.Q(Q),.Qbar(Qbar), .S(Y), .R(Ybar), .C(C), .nP(nP), .nR(nR));


endmodule

// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

wire nand_d1;
wire nand_d2;

nand nand_inst1(nand_d1, D, C);
nand nand_inst2(nand_d2, ~D, C);
nand nand_inst3(Q, nand_d1, Qbar, nP);
nand nand_inst4(Qbar, nand_d2, Q, nR);


endmodule

// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q,Qbar, S, R, C, nP, nR);
input S, R, C;
input nP, nR;
output Q,Qbar;

wire nand1;
wire nand2;
wire nand3;
wire nand4;
nand nand_inst(nand1, S, C);
nand nand_inst2(nand2, C, R);
nand nand_inst3(Q, nand1, nP, Qbar);
nand nand_inst4(Qbar, nand2, nR, Q);


endmodule

// 5x32 Line decoder
module DECODER_5x32(D,I);
// output
output [31:0] D;
// input
input [4:0] I;

wire [15:0] D4x16;

DECODER_4x16 d_4x16inst(.D(D4x16), .I(I[3:0]));
genvar i;
generate
for (i=0;i<32;i=i+1)
    begin
	if (i < 16)
	    begin
	    and and_d(D[i], D4x16[i], ~I[4]);
	    end
	else
	    and and_d2(D[i], D4x16[i-16], I[4]);
    end
endgenerate

endmodule

// 4x16 Line decoder
module DECODER_4x16(D,I);
// output
output [15:0] D;
// input
input [3:0] I;

wire [7:0] D3x8;

DECODER_3x8 d_3x8inst(.D(D3x8), .I(I[2:0]));

genvar i;
generate
for (i=0;i<16;i=i+1)
    begin
	if (i < 8)
	    begin
	    and and_d(D[i], D3x8[i], ~I[3]);
	    end
	else
	    and and_d2(D[i], D3x8[i-8], I[3]);
    end
endgenerate
      
endmodule

// 3x8 Line decoder
module DECODER_3x8(D,I);
// output
output [7:0] D;
// input
input [2:0] I;

wire [3:0] D1;
DECODER_2x4 d_2x4inst(.D(D1),.I(I[1:0]));

genvar i;
generate
for (i=0;i<8;i=i+1)
    begin
	if (i<4)
	    begin
	    and d_and(D[i], D1[i], ~I[2]);
	    end
	else
	and d_and2(D[i], D1[i-4], I[2]);
    end
endgenerate


endmodule

// 2x4 Line decoder
module DECODER_2x4(D,I);
// output
output [3:0] D;
// input
input [1:0] I;

and d0_and(D[0], ~I[0], ~I[1]);
and d1_and(D[1], I[0], ~I[1]);
and d2_and(D[2], ~I[0], I[1]);
and d3_and(D[3], I[0], I[1]);

endmodule