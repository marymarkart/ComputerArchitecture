// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module RC_ADD_SUB_64(Y, CO, A, B, SnA);
// output list
output [63:0] Y;
output CO;
// input list
input [63:0] A;
input [63:0] B;
input SnA;

wire [63:0] SnA_xor;
wire [63:0] CI;

genvar i;

generate
for(i=0; i<64; i=i+1)
    begin
	case(i)
	    0:
		begin
		xor xor_inst64(SnA_xor[i], SnA, B[i]);
		FULL_ADDER fa_inst64(.S(Y[i]), .CO(CI[i]), .A(A[i]), .B(SnA_xor[i]), .CI(SnA));
		end
	    63:
		begin
		xor xor_inst64(SnA_xor[i], SnA, B[i]);
		FULL_ADDER fa_inst64(.S(Y[i]), .CO(CO), .A(A[i]), .B(SnA_xor[i]), .CI(CI[i-1]));
		end
	    default:
		begin
	    	xor xor_inst64(SnA_xor[i], SnA, B[i]);
		FULL_ADDER fa_inst64(.S(Y[i]), .CO(CI[i]), .A(A[i]), .B(SnA_xor[i]), .CI(CI[i-1]));
		end
	endcase
    end
endgenerate	 
endmodule

module RC_ADD_SUB_32(Y, CO, A, B, SnA);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
output CO;
// input list
input [`DATA_INDEX_LIMIT:0] A;
input [`DATA_INDEX_LIMIT:0] B;
input SnA;

wire [31:0] SnA_xor;
wire [31:0] CI;

genvar i;

generate
for(i=0; i<32; i=i+1)
    begin
	case(i)
	    0:
		begin
		xor xor_inst32(SnA_xor[i], SnA, B[i]);
		FULL_ADDER fa_inst32(.S(Y[i]), .CO(CI[i]), .A(A[i]), .B(SnA_xor[i]), .CI(SnA));
		end
	    31:
		begin
		xor xor_inst32(SnA_xor[i], SnA, B[i]);
		FULL_ADDER fa_inst32(.S(Y[i]), .CO(CO), .A(A[i]), .B(SnA_xor[i]), .CI(CI[i-1]));
		end
	    default:
		begin
	    	xor xor_inst32(SnA_xor[i], SnA, B[i]);
		FULL_ADDER fa_inst32(.S(Y[i]), .CO(CI[i]), .A(A[i]), .B(SnA_xor[i]), .CI(CI[i-1]));
		end
	endcase
    end
endgenerate

endmodule

