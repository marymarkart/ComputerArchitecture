`timescale 1ns/1ps
// testing of REG 1 bit
module reg1_tb;
reg D;
reg C;
reg L;
reg nP;
reg nR;
wire Q;
wire Qbar;

REG1 reg1_inst(.Q(Q), .Qbar(Qbar), .D(D), .L(L), .C(C), .nP(nP), .nR(nR));

initial
begin
nP = 0; nR = 1;    C = 0; D = 0; L = 1;//Q = 1
#5 nP = 1; nR = 0;                     //Q = 0
#5 C = 0; D = 1; nP = 1; nR = 1;    //Q = 0 (holds last Q value)
#5 C = 1;                             //Q = 1 (since D = 1)
#5 C = 0; D = 0;                    //Q = 1 (holds last Q value)
#5 C = 1;                            //Q = 0 (new value from D comes in)

#5 C = 0; D = 1; L = 0;                //Q = 0
#5 C = 1;                             //Q = 0 (Q does not become 1 here since L is 0.
#5 C = 0; D = 0;                    //Q = 0
#5 C = 1;                            //Q = 0

#5 $stop;
end

endmodule