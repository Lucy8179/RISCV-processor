`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/20 14:08:42
// Design Name: 
// Module Name: Encoder
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


module Encoder(
	input jal,jalr,br,
	output reg [1:0] pc_sel
    );
	
	//pc_sel_ex
	parameter pc_add4=2'd0;
	parameter pc_jalr=2'd1;
	parameter alu_ans=2'd2;
	
	always @(*) 
	begin
		if(jal)
			pc_sel=alu_ans;
		else if(jalr)
			pc_sel=pc_jalr;
		else if(br)
			pc_sel=alu_ans;
		else
			pc_sel=pc_add4;
	end
endmodule
