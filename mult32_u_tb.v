`timescale 1ns/1ps

module mult32_u_tb;

reg signed[31:0] Asigned;
reg signed [31:0] Bsigned;
wire [31:0] HIsigned;
wire [31:0] LOsigned;

reg signed [63:0] resultSigned;

MULT32 mult_inst(.HI(HIsigned), .LO(LOsigned), .A(Asigned), .B(Bsigned));
initial
begin
#5 Asigned='b1111; Bsigned='b10;
resultSigned = {{HIsigned[31:0]},{LOsigned[31:0]}};
$write(resultSigned);
#5 Asigned='b1; Bsigned='b1000;
resultSigned = {{HIsigned[31:0]},{LOsigned[31:0]}};
$write(resultSigned);
#5 Asigned='b0; Bsigned='b0;
resultSigned = {{HIsigned[31:0]},{LOsigned[31:0]}};
$write(resultSigned);
#5 Asigned='b1; Bsigned='b1;
resultSigned = {{HIsigned[31:0]},{LOsigned[31:0]}};
$write(resultSigned);
#5 Asigned='b11111111111111111111111111111111; Bsigned='b10;
#5;
resultSigned = {{HIsigned[31:0]},{LOsigned[31:0]}};
$write(resultSigned);
//#5 A='b1; B='b1;
end

reg unsigned [31:0] A;
reg unsigned[31:0] B;
wire [31:0] HI;
wire [31:0] LO;

reg unsigned[63:0] result;

MULT32_U mult32_inst(.HI(HI), .LO(LO), .A(A), .B( B));

initial
begin
#5 A='b1111; B='b10;
result = {{HI[31:0]},{LO[31:0]}};
$write(result);
#5 A='b1; B='b1000;
result = {{HI[31:0]},{LO[31:0]}};
$write(result);
#5 A='b0; B='b0;
result = {{HI[31:0]},{LO[31:0]}};
$write(result);
#5 A='b1; B='b1;
result = {{HI[31:0]},{LO[31:0]}};
$write(result);
#5 A='b11111111111111111111111111111111; B='b10;
#5;
result = {{HI[31:0]},{LO[31:0]}};

$write(result);
//#5 A='b1; B='b1;
end
endmodule