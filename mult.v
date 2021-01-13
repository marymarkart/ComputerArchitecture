// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A; //mcnd
input [31:0] B; //mplr

wire [31:0] two_comp_mcnd;
wire [31:0] two_comp_mplr;
wire [31:0] mux_mcnd;
wire [31:0] mux_mplr;
wire [31:0] mult_HI;
wire [31:0] mult_LO;
wire [63:0] mult_res;
wire [63:0] two_comp_mult;
wire [63:0] mux_res;
wire xor_ab;

//step 1: get 2's compliment of multiplier and multiplicand
TWOSCOMP32 mcnp_2c_inst(.Y(two_comp_mcnd),.A(A));
TWOSCOMP32 mplr_2c_inst(.Y(two_comp_mplr),.A(B));

//Step 2: use left most bit to determine selection in mux
MUX32_2x1 mcnp_select(.Y(mux_mcnd), .I0(A), .I1(two_comp_mcnd), .S(A[31]));MUX32_2x1 mplr_select(.Y(mux_mplr), .I0(B), .I1(two_comp_mplr), .S(B[31]));

//step 3: unsigned multiplication
MULT32_U multu_inst1(mult_HI, mult_LO, mux_mcnd, mux_mplr);
xor xor_res(xor_ab, A[31], B[31]);

//Step 4: combine LO and HI
assign mult_res = {mult_HI[31:0], mult_LO[31:0]};

//Step 5: get 2's compliment of the multiplication result
TWOSCOMP64 mult_2c_inst(.Y(two_comp_mult), .A(mult_res));

//Step 6: use left most bit of a or b to determine selection in mux
MUX64_2x1 mux64_select(.Y(mux_res), .I0(mult_res), .I1(two_comp_mult), .S(xor_ab));

//assign resulting mux result to HI and LO output
assign HI = mux_res[63:32];
assign LO = mux_res[31:0];

endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A; //mcnd
input [31:0] B; //mplr

wire [31:0] sum [31:0];
wire [31:0] carryO;
wire [31:0] and_res1;

AND32_2x1 and_mult_inst1(.Y(sum[0]),.A(A),.B({32{B[0]}}));
assign LO[0] = sum[0][0];
assign carryO[0] = 1'b0;

genvar i;

generate
for (i=1; i<32; i=i+1)
    begin : mult_loop
	wire [31:0] and_res;
	AND32_2x1 and_mult_inst(.Y(and_res),.A(A),.B({32{B[i]}}));
	RC_ADD_SUB_32 add_mult_inst(.Y(sum[i]), .CO(carryO[i]), .A(and_res), .B({carryO[i-1], {sum[i-1][31:1]}}), .SnA(1'b0));
	assign LO[i] = sum[i][0];

    end
endgenerate

assign HI = {carryO, sum[31][31:1]};




endmodule
