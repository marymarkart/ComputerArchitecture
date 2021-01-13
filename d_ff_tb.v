`timescale 1ns/1ps

module d_ff_tb;

//module d_ff_tb;
reg D;
reg C;
reg nP;
reg nR;
wire Q;
wire Qbar;

D_FF d_ff_inst(.Q(Q), .Qbar(Qbar), .D(D), .C(C), .nP(nP), .nR(nR));

initial
begin
nP = 0; nR = 1;    C = 0; D = 0;                //Q = 1
#5 nP = 1; nR = 0;                     //Q = 0
#5 C = 0; D = 1; nP = 1; nR = 1;    //Q = 0 (holds last Q value)
#5 C = 1;                             //Q = 1 (since D = 1)
#5 C = 0; D = 0;                    //Q = 1 (holds last Q value)
#5 C = 1;                            //Q = 0 (new value from D comes in)

#5 $stop;
end

endmodule
//reg D;
//reg C;
//reg nP;
//reg nR;
//
//wire Q;
//wire Qbar;
//
//D_FF flipflop_inst(.Q(Q), .Qbar(Qbar), .D(D), .C(C), .nP(nP), .nR(nR));
//initial
//begin
//#5 C=1'bx; D=1'bx;  nP=1'b0; nR= 1'b0;
//#5 C=1'bx; D=1'bx; nP=1'b0; nR= 1'b1;
//#5 C=1'bx; D=1'bx; nP=1'b1; nR= 1'b0;
//#5 C=1'b0; D=1'bx; nP=1'b1; nR= 1'b1;
//#5 C=1'b0; D=1'bx; nP=1'b1; nR= 1'b1;
//#5 C=1'b1; D=1'b0; nP=1'b1; nR= 1'b1;
//#5 C=1'b1; D=1'b1; nP=1'b1; nR= 1'b1;
//#5;
//end
//endmodule