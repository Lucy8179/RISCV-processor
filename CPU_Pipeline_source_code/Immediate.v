`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 21:11:26
// Design Name: 
// Module Name: Immediate
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


module Immediate(
	input [31:0] inst,
	input [2:0] imm_type,
	output reg [31:0] imm
    );
	parameter I_Type=3'd1;//addi,jalr
	parameter S_Type=3'd2;//sw
	parameter SB_Type=3'd3;//beq,blt
	parameter U_Type=3'd4;//auipc,lui
	parameter UJ_Type=3'd5;//jal
	always @(*)
	begin
		case(imm_type)
			I_Type:
				imm={{20{inst[31]}},inst[31:20]};
			S_Type:
				imm={{20{inst[31]}},inst[31:25],inst[11:7]};
			SB_Type:
				imm={{19{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8],1'b0};
			U_Type:
				imm={inst[31:12],12'b0};
			UJ_Type:
				imm={{11{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21],1'b0};
			default:
				imm=0;
		endcase
	end
endmodule
