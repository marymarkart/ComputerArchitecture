`timescale 1ns/1ps

module SR_latch_tb;

reg C;
reg S;
reg R;
reg nP;
reg nR;

wire Q;
wire Qbar;


SR_LATCH latch_inst(.Q(Q),.Qbar(Qbar), .S(S), .R(R), .C(C), .nP(nP), .nR(nR));


initial
begin
#5 C=1'b0; S=1'b0; R=1'b0; nP=1'b0; nR= 1'b0;
#5 C=1'b0; S=1'bx; R=1'bx; nP=1'b1; nR= 1'b0;
#5 C=1'b0; S=1'bx; R=1'bx; nP=1'b1; nR= 1'b0;
#5 C=1'b1; S=1'b1; R=1'b0; nP=1'b1; nR= 1'b0;
#5 C=1'b1; S=1'b0; R=1'b1; nP=1'b1; nR= 1'b0;
#5 C=1'b1; S=1'b0; R=1'b0; nP=1'b1; nR= 1'b0;
#5 C=1'b1; S=1'b0; R=1'b0; nP=1'b1; nR= 1'b0;
#5 C=1'b1; S=1'b1; R=1'b1; nP=1'b1; nR= 1'b0;
#5;

end
endmodule