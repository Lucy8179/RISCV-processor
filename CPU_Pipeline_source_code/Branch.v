`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 21:50:47
// Design Name: 
// Module Name: Branch
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


module Branch(
	input [31:0] op1,op2,
	input [2:0] br_type,
	output reg br
    );

	//br_type
	parameter NO_BR=3'd0;
	parameter beq=3'd1;
	parameter blt=3'd2;
	parameter bne=3'd3;
	parameter bge=3'd4;
	parameter bltu=3'd5;
	parameter bgeu=3'd6;

	parameter YES=1'b1;
	parameter NO=1'b0;

	always @(*) 
	begin
		case(br_type)
			beq:
			begin
				if(op1==op2)
					br=YES;
				else
					br=NO;
			end
			blt:
			begin
				if($signed(op1)<$signed(op2))
					br=YES;
				else
					br=NO;
			end
			bne:
			begin
				if(op1!=op2)
					br=YES;
				else	
					br=NO;
			end
			bge:
			begin
				if($signed(op1)>=$signed(op2))
					br=YES;
				else
					br=NO;
			end
			bltu:
			begin
				if(op1<op2)
					br=YES;
				else
					br=NO;
			end
			bgeu:
			begin
				if(op1>=op2)
					br=YES;
				else
					br=NO;
			end
			default:br=0;
		endcase
	end
endmodule
