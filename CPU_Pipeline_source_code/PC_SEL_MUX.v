`timescale 1ns / 1ps
module PC_SEL_MUX (
	input [31:0] src0,src1,src2,src3,src4,
	input [2:0] pc_sel,
	output reg [31:0] res
);

	parameter NULL=32'h0;
	
	always @(*) 
	begin
		case(pc_sel)
			3'd0:	res=src0;
			3'd1:	res=src1;
			3'd2:	res=src2;
			3'd3:	res=src3;
			3'd4:	res=src4;
			default:res=NULL;
		endcase	
	end

endmodule