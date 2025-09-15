`timescale 1ns / 100ps

module tb_WB ;
reg				rRST;
reg				rCLK;

reg		[31:0]	rA;
reg		[31:0]	rD;
reg				rW;
reg				rSTART;
wire			wBUSY;

wire			wSTB;
wire			wWE;
wire	[31:0]	wADR;
wire	[31:0]	wDATrd;
wire	[31:0]	wDATwr;
wire			wACK;

WB_Master master (
	.iRST(rRST),
	.iCLK(rCLK),

	.iSTART(rSTART),
	.oBUSY(wBUSY),
	.iA(rA[31:0]),
	.iD(rD[31:0]),
	.iWE(rW),

	.oADR(wADR[31:0]),
	.iDAT(wDATrd[31:0]),
	.oDAT(wDATwr[31:0]),
	.oWE(wWE),
	.oSTB(wSTB),
	.iACK(wACK)
);

wire	[7:0]	wDOUTA;

DigOutPort #(	.BaseAddr(32'h0200_0000)
) DUT (
	.iRST(rRST),
	.iCLK(rCLK),

	.iADR(wADR[31:0]),
	.iDAT(wDATwr[31:0]),
	.oDAT(wDATrd[31:0]),
	.iWE(wWE),
	.iSTB(wSTB),
	.oACK(wACK),
	
	.oDOUTA(wDOUTA[7:0])
);

initial begin
	#0			rRST = 1'b1;
				rCLK = 1'b1;

				rSTART = 1'b0;
				
				rA[31:0] = 32'h0;
				rD[31:0] = 32'h0;
				rW = 1'b0;

	#100	@(posedge rCLK)	rRST = 1'b0;

//REG0
	#100	rA[31:0] = 32'h0200_0000;
			rD[31:0] = 32'h0000_0001;
			rW = 1'b1;
			@(posedge rCLK)	rSTART = 1'b1;
			@(posedge rCLK)	rSTART = 1'b0;
	wait(wBUSY == 1'b0);

	#100	rA[31:0] = 32'h0200_0000;
			rD[31:0] = 32'h0;
			rW = 1'b0;
			@(posedge rCLK)	rSTART = 1'b1;
			@(posedge rCLK)	rSTART = 1'b0;
	wait(wBUSY == 1'b0);

//REG1	
		#100	rA[31:0] = 32'h0200_0010;
			rD[31:0] = 32'h0000_0002;
			rW = 1'b1;
			@(posedge rCLK)	rSTART = 1'b1;
			@(posedge rCLK)	rSTART = 1'b0;
	wait(wBUSY == 1'b0);

	#100	rA[31:0] = 32'h0200_0010;
			rD[31:0] = 32'h0;
			rW = 1'b0;
			@(posedge rCLK)	rSTART = 1'b1;
			@(posedge rCLK)	rSTART = 1'b0;
	wait(wBUSY == 1'b0);

//REG2	
		#100	rA[31:0] = 32'h0200_0020;
			rD[31:0] = 32'h0000_0003;
			rW = 1'b1;
			@(posedge rCLK)	rSTART = 1'b1;
			@(posedge rCLK)	rSTART = 1'b0;
	wait(wBUSY == 1'b0);

	#100	rA[31:0] = 32'h0200_0020;
			rD[31:0] = 32'h0;
			rW = 1'b0;
			@(posedge rCLK)	rSTART = 1'b1;
			@(posedge rCLK)	rSTART = 1'b0;
	wait(~wBUSY);


end

always begin
	#5			rCLK <= ~rCLK;
end



endmodule
