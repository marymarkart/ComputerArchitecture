// Name: data_path.v
// Module: DATA_PATH
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - 32 bit processor implementing cs147sec05 instruction set
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);

// output list
output [`ADDRESS_INDEX_LIMIT:0] ADDR;
output ZERO;
output [`DATA_INDEX_LIMIT:0] DATA_OUT, INSTRUCTION;

// input list
input [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
input CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_IN;

wire [31:0] pc_add1, pc_mux1, pc_add2, pc_mux2, pc_mux3, zeroExt6, instReg, 
		r1_selmux, wasel_1, wasel_2, wasel_3, op1sel_1, op2sel_1,
		op2sel_2, op2sel_3, op2sel_4, R1, R2, wdsel_1, wdsel_2, wd_sel3, masel_1, ALU_out ;
wire CO;

//Extends
wire SignExtImm =  {{16{instReg[15]}}, instReg[15:0]};
wire ZeroExtImm = {16'b0, instReg[15:0]};
wire ZeroExt27 = {27'b0, instReg[10:6]};
//LUI
wire LUI = {instReg[15:0], 16'b0};
//jump
wire JUMP_ADDR = {6'b0, instReg[25:0]};

// Program Counter
defparam pc_inst.PATTERN = `INST_START_ADDR;
REG32_PP pc_inst(.Q(pc), .D(pc_mux3), .LOAD(CTRL[0]), .CLK(CLK), .RESET(RST));
// Stack Pointer
defparam sp_inst.PATTERN = `INIT_STACK_POINTER;
REG32_PP sp_inst(.Q(sp), .D(ALU_out), .LOAD(CTRL[8]), .CLK(CLK), .RESET(RST));
//Register File
REGISTER_FILE_32x32 regFile(.DATA_R1(R1), .DATA_R2(R2), .ADDR_R1(r1_selmux), .ADDR_R2(instReg[20:16]), 
                            .DATA_W(wdsel_3), .ADDR_W(wasel_3), .READ(CTRL[6]), .WRITE(CTRL[7]), .CLK(CLK), .RST(RST));
//ALU
ALU(.OUT(ALU_out), .ZERO(ZERO), .OP1(op1sel_1), .OP2(op2sel_4), .OPRN(CTRL[19:14]));

//PC path
RC_ADD_SUB_32 pc_addinst1(.Y(pc_add1), .CO(CO), .A(1'b1), .B(pc), .SnA(1'b0));
MUX32_2x1 pc_muxinst1(.Y(pc_mux1), .I0(R1), .I1(pc_add1), .S(CTRL[1]));
RC_ADD_SUB_32 pc_addinst2(.Y(pc_add2), .CO(CO), .A(pc_add1), .B(SignExtImm), .SnA(1'b0));
MUX32_2x1 pc_muxinst2(.Y(pc_mux2), .I0(pc_mux1), .I1(pc_add2), .S(CTRL[2]));
MUX32_2x1 pc_muxinst3(.Y(pc_mux3), .I0(JUMP_ADDR), .I1(pc_mux2), .S(CTRL[3]));

//wa sel
MUX32_2x1 wa_muxinst1(.Y(wasel_1), .I0(instReg[15:11]), .I1(instReg[20:16]), .S(CTRL[26]));
MUX32_2x1 wa_muxinst2(.Y(wasel_2), .I0(5'b0), .I1(5'b11111), .S(CTRL[27]));
MUX32_2x1 wa_muxinst3(.Y(wasel_3), .I0(wasel_2), .I1(wasel_1), .S(CTRL[28]));

//op 1
MUX32_2x1 op1_muxinst1(.Y(op1_sel1), .I0(R1), .I1(sp), .S(CTRL[9]));

//op2 selection
MUX32_2x1 op2_muxinst1(.Y(op2_sel1), .I0(1'b1), .I1(ZeroExt27), .S(CTRL[10]));
MUX32_2x1 op2_muxinst2(.Y(op2_sel2), .I0(ZeroExtImm), .I1(SignExtImm), .S(CTRL[11]));
MUX32_2x1 op2_muxinst3(.Y(op2_sel3), .I0(op2_sel2), .I1(op2_sel1), .S(CTRL[12]));
MUX32_2x1 op2_muxinst4(.Y(op2_sel4), .I0(op2_sel3), .I1(R2), .S(CTRL[13]));

//wd selection
MUX32_2x1 wd_muxinst1(.Y(wdsel_1), .I0(ALU_out), .I1(DATA_IN), .S(CTRL[23]));
MUX32_2x1 wd_muxinst2(.Y(wdsel_2), .I0(wdsel_1), .I1(LUI), .S(CTRL[24]));
MUX32_2x1 wd_muxinst3(.Y(wdsel_3), .I0(pc_add1), .I1(wdsel_2), .S(CTRL[25]));

//r1 selection
MUX32_2x1 r1_muxinst(.Y(r1_selmux), .I0(instReg[25:21]), .I1(5'b0), .S(CTRL[5]));

//md selection
MUX32_2x1 md_muxinst(.Y(DATA_OUT), .I0(R2), .I1(R1), .S(CTRL[22]));

//ma selection
MUX32_2x1 ma_muxinst1(.Y(masel_1), .I0(ALU_out), .I1(sp), .S(CTRL[20]));
MUX32_2x1 ma_muxinst2(.Y(ADDR), .I0(masel_1), .I1(pc_add1), .S(CTRL[21]));


RC_ADD_SUB_32(Y, CO, A, B, SnA);

endmodule
