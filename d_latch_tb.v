`timescale 1ns/1ps

module D_latch_tb;

reg C;
reg D;
reg nP;
reg nR;

wire Q;
wire Qbar;


D_LATCH latch_inst(.Q(Q),.Qbar(Qbar), .D(D), .C(C), .nP(nP), .nR(nR));


initial
begin
#5 C=1'b0; D=1'bx;  nP=1'b1; nR= 1'b0;
#5 C=1'b0; D=1'bx; nP=1'b1; nR= 1'b0;
#5 C=1'b1; D=1'b1; nP=1'b1; nR= 1'b0;
#5 C=1'b1; D=1'b0; nP=1'b1; nR= 1'b0;
#5;

end
endmodule