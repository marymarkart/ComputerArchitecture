`timescale 1ns/1ps
module twoscomp32_tb;

reg [31:0] A;
wire [31:0] Y;

reg [31:0] result;

TWOSCOMP32 twocomp_inst1(.Y(Y),.A(A));

initial
begin
#5 A='b11111111111111111111111111111111;
#5;
result = {Y[31:0]};
$write(result);

end
endmodule
