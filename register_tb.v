// Name: register_tb.v
// Module: register_tb
// 
//
// Monitors:  DATA : Data to be written at address ADDR
//            ADDR : Address of the memory location to be accessed
//            READ : Read signal
//            WRITE: Write signal
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - Testbench for REGISTER_FILE_32x32 memory system
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module register_tb;
// Storage list
reg [`ADDRESS_INDEX_LIMIT:0] ADDR_R1;
reg [`ADDRESS_INDEX_LIMIT:0] ADDR_R2;
reg [`ADDRESS_INDEX_LIMIT:0] DATA_W;
reg [`ADDRESS_INDEX_LIMIT:0] ADDR_W;
// reset
reg READ, WRITE, RST;
// data register
reg [`DATA_INDEX_LIMIT:0] DATA_REG1;
reg [`DATA_INDEX_LIMIT:0] DATA_REG2;
integer i; // index for memory operation
integer no_of_test, no_of_pass;
integer load_data1;
integer load_data2;

// wire lists
wire  CLK;
wire [`DATA_INDEX_LIMIT:0] DATA_R1;
wire [`DATA_INDEX_LIMIT:0] DATA_R2;

assign DATA_R1 = ((READ===1'b0)&&(WRITE===1'b1))?DATA_REG1:{`DATA_WIDTH{1'bz} };
assign DATA_R2 = ((READ===1'b0)&&(WRITE===1'b1))?DATA_REG2:{`DATA_WIDTH{1'bz} };

// Clock generator instance
CLK_GENERATOR clk_gen_inst(.CLK(CLK));


REGISTER_FILE_32x32 reg_inst(.DATA_R1(DATA_R1), .DATA_R2(DATA_R2), .ADDR_R1(ADDR_R1), .ADDR_R2(ADDR_R2), 
                            .DATA_W(DATA_W), .ADDR_W(ADDR_W), .READ(READ), .WRITE(WRITE), .CLK(CLK), 
			    .RST(RST));

initial
begin
RST=1'b1;
READ=1'b0;
WRITE=1'b0;
DATA_REG1 = {`DATA_WIDTH{1'b0} };
DATA_REG2 = {`DATA_WIDTH{1'b0} };
no_of_test = 0;
no_of_pass = 0;
load_data1 = 'h00414020;
load_data2 = 'h00414020;

// Start the operation
#10    RST=1'b0;
#10    RST=1'b1;
// Write cycle
for(i=1;i<10; i = i + 1)
begin
#10     DATA_REG1=i; DATA_REG2=i; READ=1'b0; WRITE=1'b1; ADDR_R1 = i; ADDR_R2 = i; ADDR_W = i; DATA_W = i;
end

// Read Cycle
#10   READ=1'b0; WRITE=1'b0;
#5    no_of_test = no_of_test + 1;
      if ((DATA_R1 !== {`DATA_WIDTH{1'bz}}) && (DATA_R2 !== {`DATA_WIDTH{1'bz}}))
        $write("[TEST] Read %1b, Write %1b, expecting 32'hzzzzzzzz, got %8h & %8h [FAILED]\n", READ, WRITE, DATA_R1, DATA_R2);
      else 
	no_of_pass  = no_of_pass + 1;

// test of write data
for(i=0;i<10; i = i + 1)
begin
#5      READ=1'b1; WRITE=1'b0; ADDR_W = i; DATA_W = i;
#5      no_of_test = no_of_test + 1;
        if (DATA_W !== i)
	    $write("[TEST] Read %1b, Write %1b, expecting %8h, got %8h[FAILED]\n", READ, WRITE, i, DATA_W);
        else 
	    no_of_pass  = no_of_pass + 1;

end

// test for the initialize data
for(i='h001000; i<'h001010; i = i + 1)
begin
#5      READ=1'b1; WRITE=1'b0; ADDR_R1 = i; ADDR_R2 = i; ADDR_W = i; DATA_W = i;
#5      no_of_test = no_of_test + 1;
        if ((DATA_R1 !== load_data1) && (DATA_R1 !== load_data2))
            $write("[TEST] Read %1b, Write %1b, Addr_R1 %7h and Addr_R2 57h, expecting %8h and %8h, got %8h and %8h[FAILED]\n", 
                                                           READ, WRITE, ADDR_R1, ADDR_R2, load_data1, load_data2, DATA_R1, DATA_R2);
        else 
            no_of_pass  = no_of_pass + 1;
        load_data1 = load_data1 + 1;
	load_data2 = load_data2 + 1;
end
#10    READ=1'b0; WRITE=1'b0; // No op

#10 $write("\n");
    $write("\tTotal number of tests %d\n", no_of_test);
    $write("\tTotal number of pass  %d\n", no_of_pass);
    $write("\n");
    //$writememh("mem_dump_01.dat", mem_inst.sram_32x64m, 'h0000000, 'h000000f);
    //$writememh("mem_dump_02.dat", mem_inst.sram_32x64m, 'h0001000, 'h000100f);
    $stop;

end
endmodule;

