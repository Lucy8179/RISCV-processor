`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 10:42:48
// Design Name: 
// Module Name: PC
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


module PC(
	input [31:0] pc_next,
	input clk,stall,rst,
	output reg [31:0] pc_cur
    );
	initial pc_cur=32'h2ffc;
	always @(posedge clk)
	begin
		if(rst)
			pc_cur<=32'h2ffc;
		else
		begin
			if(stall)
				pc_cur<=pc_cur;
			else
				pc_cur<=pc_next;
		end
	end
endmodule
