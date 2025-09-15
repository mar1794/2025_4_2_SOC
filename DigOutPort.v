`timescale 1ns / 100ps

module DigOutPort #(
	parameter	BaseAddr = 32'h0000_0000
)
(
	input			iRST,
	input			iCLK,
	
	input	[31:0]	iADR,//address
	input	[31:0]	iDAT,//data input
	output	[31:0]	oDAT,//data output
	input			iWE,//write enable
	input			iSTB,//bus transaction active high
	output			oACK,//handshake
	
	output	[7:0]	oDOUTA,
	output	[7:0]	oDOUTB,
    output	[7:0]	oDOUTC
	
);

wire                wSel;
assign wSel = (BaseAddr <= iADR <= BaseAddr + 32'h0000_0020);

reg                 rACK;
assign oACK = rACK;

//handshake
always@(posedge iRST or posedge iCLK)
begin
    if (iRST) begin
            rACK <= 1'b0;
    end
    else begin
        if (iSTB & wSel) begin
            if (~rACK) begin
                rACK <= 1'b1;
            end
            else begin
                rACK <= 1'b0;
            end
        end
    end
end

reg     [31:0]      rREG0;
reg     [31:0]      rREG1;
reg     [31:0]      rREG2;

assign oDOUTA = rREG0[7:0];
assign oDOUTB = rREG1[7:0];
assign oDOUTC = rREG2[7:0];

//REG0 write
always@(posedge iRST or posedge iCLK)
begin
    if (iRST) begin
        rREG0[31:0] <= 32'b0;
    end
    else begin
        if (iSTB & rACK & iWE) begin
            if (iADR[31:0] == BaseAddr) begin
                rREG0[31:0] <= iDAT[31:0];
            end
        end
    end
end



//REG1 write        
always@(posedge iRST or posedge iCLK)
begin
    if (iRST) begin
        rREG1[31:0] <= 32'b0;
    end
    else begin
        if (iSTB & rACK & iWE) begin
            if (iADR[31:0] == BaseAddr + 32'h0000_0010) begin
                rREG1[31:0] <= iDAT[31:0];
            end
        end
    end
end


//REG2 write
always@(posedge iRST or posedge iCLK)
begin
    if (iRST) begin
        rREG2[31:0] <= 32'b0;
    end
    else begin
        if (iSTB & rACK & iWE) begin
            if (iADR[31:0] == BaseAddr + 32'h0000_0020) begin
                rREG2[31:0] <= iDAT[31:0];
            end
        end
    end
end

//REG0, REG1, REG2 read
assign oDAT = (~iWE & rACK & (iADR[31:0] == BaseAddr)) ? rREG0[31:0] : 
       (~iWE & rACK & (iADR[31:0] == BaseAddr + 32'h0000_0010))? rREG1[31:0] :
           (~iWE & rACK & (iADR[31:0] == BaseAddr + 32'h0000_0020))? rREG2[31:0] : 32'h0 ;

         
   

endmodule




















