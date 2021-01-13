// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: RF_DATA_W  : Data to be written at register file address RF_ADDR_W
//         RF_ADDR_W  : Register file address of the memory location to be written
//         RF_ADDR_R1 : Register file address of the memory location to be read for RF_DATA_R1
//         RF_ADDR_R2 : Registere file address of the memory location to be read for RF_DATA_R2
//         RF_READ    : Register file Read signal
//         RF_WRITE   : Register file Write signal
//         ALU_OP1    : ALU operand 1
//         ALU_OP2    : ALU operand 2
//         ALU_OPRN   : ALU operation code
//         MEM_ADDR   : Memory address to be read in
//         MEM_READ   : Memory read signal
//         MEM_WRITE  : Memory write signal
//         
// Input:  RF_DATA_R1 : Data at ADDR_R1 address
//         RF_DATA_R2 : Data at ADDR_R1 address
//         ALU_RESULT    : ALU output data
//         CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Control unit synchronize operations of a processor
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(MEM_DATA, RF_DATA_W, RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2, RF_READ, RF_WRITE,
                    ALU_OP1, ALU_OP2, ALU_OPRN, MEM_ADDR, MEM_READ, MEM_WRITE,
                    RF_DATA_R1, RF_DATA_R2, ALU_RESULT, ZERO, CLK, RST); 

// Output signals
// Outputs for register file 
output [`DATA_INDEX_LIMIT:0] RF_DATA_W;
output [`ADDRESS_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
output RF_READ, RF_WRITE;
// Outputs for ALU
output [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
output  [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;
// Outputs for memory
output [`ADDRESS_INDEX_LIMIT:0]  MEM_ADDR;
output MEM_READ, MEM_WRITE;

// Input signals
input [`DATA_INDEX_LIMIT:0] RF_DATA_R1, RF_DATA_R2, ALU_RESULT;
input ZERO, CLK, RST;

// Inout signal
inout [`DATA_INDEX_LIMIT:0] MEM_DATA;

// State nets
wire [2:0] proc_state;

//Registers for corresponding output ports
// reg for register file outputs
reg [`DATA_INDEX_LIMIT:0] RF_DATA_W_REG;
reg [`ADDRESS_INDEX_LIMIT:0] RF_ADDR_W_REG, RF_ADDR_R1_REG, RF_ADDR_R2_REG;
reg RF_READ_REG, RF_WRITE_REG;
// reg for ALU output
reg [`DATA_INDEX_LIMIT:0]  ALU_OP1_REG, ALU_OP2_REG;
reg  [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN_REG;
// reg for memory output
reg [`ADDRESS_INDEX_LIMIT:0]  MEM_ADDR_REG;
reg MEM_READ_REG, MEM_WRITE_REG;

reg [`DATA_INDEX_LIMIT:0] MEM_DATA_REG;

//Internal registers
reg [`ADDRESS_INDEX_LIMIT:0] PC_REG;
reg [`DATA_INDEX_LIMIT:0] INST_REG;
reg [`ADDRESS_INDEX_LIMIT:0] SP_REF;

assign MEM_DATA = ((MEM_READ===1'b0)&&(MEM_WRITE===1'b1))?MEM_DATA_REG:{`DATA_WIDTH{1'bz} };
//assign register files
assign RF_DATA_W = RF_DATA_W_REG;
assign RF_ADDR_W = RF_ADDR_W_REG;
assign RF_ADDR_R1 = RF_ADDR_R1_REG;
assign RF_ADDR_R2 = RF_ADDR_R2_REG;
assign RF_READ = RF_READ_REG;
assign RF_WRITE = RF_WRITE_REG;
//assign alu files
assign ALU_OP1 = ALU_OP1_REG;
assign ALU_OP2 = ALU_OP2_REG;
assign ALU_OPRN = ALU_OPRN_REG;
//assign memory files
assign MEM_ADDR = MEM_ADDR_REG;
assign MEM_READ = MEM_READ_REG;
assign MEM_WRITE = MEM_WRITE_REG;
assign MEM_DATA = MEM_DATA_REG;


PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));



always @ (proc_state)
begin
    if (proc_state === `PROC_FETCH)
	begin
	    MEM_ADDR_REG = PC_REG;
	    MEM_READ_REG = 1'b1
	    MEM_WRITE_REG = 1'b0;
	    RF_READ_REG = 1'b0;
	    RF_WRITE_REG = 1'b0;
	end
    if (proc_state === `PROC_DECODE)
	begin
	    INST_REG = MEM_DATA;
	    task print_instruction; 
		//input [`DATA_INDEX_LIMIT:0] inst; 
		reg [5:0]   opcode; 
		reg [4:0]   rs; 
		reg [4:0]   rt; 
		reg [4:0]   rd; 
		reg [4:0]   shamt; 
		reg [5:0]   funct; 
		reg [15:0]  immediate; 
		reg [25:0]  address; 
		//extends
		SIGN_EXTEND_16b =  {{16{extend[15]}}, immediate};
		ZERO_EXTEND_16b = {16'b0, immediate};
		LSB_ZERO_EXTEND = {immediate, 16'b0}
		//jump
		JUMP_ADDR = {6'b0, address}
		
		RF_ADDR_R1_REG = rs;
		RF_ADDR_R2_REG = rt;
		
		begin 
			// parse the instruction // R-type 
			{opcode, rs, rt, rd, shamt, funct} = INST_REG; 
			// I-type 
			{opcode, rs, rt, immediate } = INST_REG; 
			// J-type 
			{opcode, address} = INST_REG; 
			$write("@ %6dns -> [0X%08h] ", $time, inst); 
			case(opcode) 
				// R-Type 
				
				6'h00 : begin            
				 case(funct)                
				  6'h20: $write("add  r[%02d], r[%02d], r[%02d];", rs, rt, rd);                
				  6'h22: $write("sub  r[%02d], r[%02d], r[%02d];", rs, rt, rd);                
				  6'h2c: $write("mul  r[%02d], r[%02d], r[%02d];", rs, rt, rd);                
				  6'h24: $write("and  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
				  6'h25: $write("or   r[%02d], r[%02d], r[%02d];", rs, rt, rd);
			          6'h27: $write("nor  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
			          6'h2a: $write("slt  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
			          6'h01: $write("sll  r[%02d], %2d, r[%02d];", rs, shamt, rd);
			          6'h02: $write("srl  r[%02d], 0X%02h, r[%02d];", rs, shamt, rd);
			          6'h08: $write("jr   r[%02d];", rs);
			          default: $write("");
			         endcase
			        end 
				// I-type 
				 6'h08 : $write("addi  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
				 6'h1d : $write("muli  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				 6'h0c : $write("andi  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				 6'h0d : $write("ori   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				 6'h0f : $write("lui   r[%02d], 0X%04h;", rt, immediate);
				 6'h0a : $write("slti  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
    				 6'h04 : $write("beq   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
 				 6'h05 : $write("bne   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				 6'h23 : $write("lw    r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				 6'h2b : $write("sw    r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
				// J-Type
				 6'h02 : $write("jmp   0X%07h;", address);
				 6'h03 : $write("jal   0X%07h;", address);
				 6'h1b : $write("push;");
				 6'h1c : $write("pop;");
				 default: $write("");
			endcase $write("\n");
 		end
 	    endtask

    end

    if (proc_state === `PROC_EXE)
	begin
	    case(opcode)
		//R-TYPE
		6'h00 : begin     
			//R-Type
			//jr
			if (funct === 6'h08)
			    begin
				PC_REG = RF_DATA_R1;
			    end
			//sll || srl
			if (funct === 6'h01 || funct === 6'h02)
			    begin
				ALU_OPRN_REG = funct;
				ALU_OP1_REG = RF_DATA_R1;
				ALU_OP2_REG = shamt;
			    end

			else
			    begin		
				ALU_OPRN_REG = funct;
				ALU_OP1_REG = RF_DATA_R1;
				ALU_OP2_REG = RF_DATA_R2;
			    end //end R-Type oprns
		//I-TYPE
		6'h08 : 
			
		6'h1d : 
		6'h0c : 
		6'h0d : 
		6'h0f : 
		6'h0a : 
    		6'h04 : 
 		6'h05 : 
		6'h23 : 
		6'h2b :
		
		//J-TYPE
		6'h02 : 
		6'h03 : 
		6'h1b : 
		6'h1c : 

    end //end if `PROC_EXE


    if (proc_state === `PROC_MEM)
	//do stuff begin

    end //end if `PROC_MEM
    if (proc_state === `PROC_WB)
	begin
	    case(opcode)
		//R-TYPE
		6'h00 : begin     
			//R-Type jr
			if (funct ==== 6'h08

		end // end R-Type begin

		//I-TYPE

		//J-TYPE


	    endcase // end opcode cases
	end // end begin

    end //end if `PROC_MEM
endmodule;

//------------------------------------------------------------------------------------------
// Module: CONTROL_UNIT
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE,CLK,RST);
// list of inputs
input CLK, RST;
// list of outputs
output [2:0] STATE;
// reg list

reg [1:0] state;
reg [1:0] next_state;

// initiation of state
initial
begin
  state = `3'bxx;
  next_state = `PROC_FETCH;  
end

// reset signal handling
always @ (negedge RST)
begin
    state = `PROC_FETCH;
    next_state = `PROC_FETCH;
end

// state switching
always @(posedge CLK)
begin
    state = next_state;
end

// Action on state switching
always @(state or IN)
begin
    if (state === `PROC_FETCH)
    begin 
        next_state = `PROC_DECODE; 
    end

    if (state === `PROC_DECODE)
    begin 
        next_state = `PROC_EXE; 
    end

    if (state === `PROC_EXE)
    begin 
        `PROC_MEM; 
    end

    if (state === `PROC_MEM)
    begin 
        next_state = `PROC_WB;
    end

    if (state === `PROC_WB)
    begin 
        next_state = `PROC_FETCH;
    end

end


endmodule;