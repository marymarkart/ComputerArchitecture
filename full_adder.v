// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(S,CO,A,B, CI);
output S,CO;
input A,B, CI;

wire ha1_Y;
wire ha1_C;
wire ha2_Y;
wire ha2_C;


HALF_ADDER ha_inst1(.Y(ha1_Y), .C(ha1_C), .A(A), .B(B));
HALF_ADDER ha_inst2(.Y(ha2_Y), .C(ha2_C), .A(ha1_Y), .B(CI));


or or_fa_inst(CO, ha1_C, ha2_C);
assign S = ha2_Y;


endmodule;
