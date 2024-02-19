`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 21:07:06
// Design Name: 
// Module Name: ALU
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

	// //alu_func
	// parameter ADD=4'd0;
	// parameter SUB=4'd1;
	// parameter EQUAL=4'd2;
	// parameter UNSIGNED_LESS_THAN=4'd3;
	// parameter LESS_THAN=4'd4;
	// parameter AND=4'd5;
	// parameter OR=4'd6;
	// parameter XOR=4'd7;
	// parameter SHIFT_RIGHT=4'd8;
	// parameter SHIFT_LEFT=4'd9;
	// parameter SHIFT_LEFT_ARITH=4'd10;
	// parameter SHIFT_RIGHT_ARITH=4'd11;
	// parameter ELSE=4'd12;

module ALU #(parameter WIDTH = 32)(
	input [WIDTH-1:0] alu_src1, alu_src2, //两操作数（ 对于减运算， a是被减数）
	input [3:0] alu_func, //操作功能（ 加、 减、 与、 或、 异或等）
	output reg [WIDTH-1:0] alu_ans //运算结果（ 和、 差 …）
);
	always @(*)
	begin
		case(alu_func)
			4'b0000:
				begin
					alu_ans=alu_src1+alu_src2;
				end
			4'b0001:
				begin
					alu_ans=alu_src1-alu_src2;
				end
			4'b0010:
			begin
				alu_ans=(alu_src1==alu_src2);
			end
			4'b0011:
			begin
				alu_ans=(alu_src1<alu_src2);
			end
			4'b0100:
			begin
				alu_ans=($signed(alu_src1)<$signed(alu_src2));
			end
			4'b0101:
			begin
				alu_ans=alu_src1&alu_src2;
			end
			4'b0110:
			begin
				alu_ans=alu_src1|alu_src2;
			end
			4'b111:
			begin
				alu_ans=alu_src1^alu_src2;
			end
			4'b1000:
			begin
				alu_ans=alu_src1>>(alu_src2[4:0]);
			end
			4'b1001:
			begin
				alu_ans=alu_src1<<(alu_src2[4:0]);
			end
			4'b1010:
			begin
				alu_ans=$signed(alu_src1)<<<(alu_src2[4:0]);
			end
			4'b1011:
			begin
				alu_ans=$signed(alu_src1)>>>(alu_src2[4:0]);
			end
			default:
			begin
				alu_ans=0;
			end
		endcase
	end
endmodule

