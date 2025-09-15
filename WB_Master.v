`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/05 22:16:58
// Design Name: 
// Module Name: WB_Master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module WB_Master (
	input				iRST,
	input				iCLK,
	
	input				iSTART,
	output	reg			oBUSY,
	input		[31:0]	iA,
	input		[31:0]	iD,
	input				iWE,

	output	reg	[31:0]	oADR,
	input		[31:0]	iDAT,
	output	reg	[31:0]	oDAT,
	output	reg			oWE,
	output	reg			oSTB,
	input				iACK
);

reg		[3:0]	rST;	// rest, address, data, 

always @ (posedge iRST or posedge iCLK)
begin
	if (iRST) begin
		oBUSY <= 1'b0;

		oSTB <= 1'b0;
		oWE <= 1'b0;
		oADR[31:0] <= 32'h0;
		oDAT[31:0] <= 32'h0;

		rST[3:0] <= 4'h0;
	end
	else begin
		case (rST[3:0])
			4'h0: begin
					if (iSTART) begin
						oBUSY <= 1'b1;

						oSTB <= 1'b1;
						oWE <= iWE;
						oADR[31:0] <= iA[31:0];
						oDAT[31:0] <= iD[31:0];
					
						rST[3:0] <= 4'h1;
					end
				end
				
			4'h1: begin
					if (iACK) begin
						oBUSY <= 1'b0;

						oSTB <= 1'b0;
						oWE <= 1'b0;
						oADR[31:0] <= 32'h0;
						oDAT[31:0] <= 32'h0;

						rST[3:0] <= 4'h0;
					end
				end
				
			default: begin
					oBUSY <= 1'b0;

					rST[3:0] <= 4'h0;
				end
		endcase
	end
end

endmodule
