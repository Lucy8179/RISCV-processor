`timescale 1ns / 1ps
module COMPETITION_FSM (
	input [1:0] current_state,
	input outcome,	//分支结果是否正确
	output reg [1:0] next_state
);

	parameter TRUE=1'b1;
	parameter FALSE=1'b0;
	parameter Strongly_Local=2'd0;
	parameter Weakly_Local=2'd1;
	parameter Weakly_Global=2'd2;
	parameter Strongly_Global=2'd3;

	always @(*) 
	begin
		case(current_state)
			Strongly_Local:
			begin
				if(outcome==TRUE)
					next_state=Strongly_Local;
				else
					next_state=Weakly_Local;
			end
			Weakly_Local:
			begin
				if(outcome==TRUE)
					next_state=Strongly_Local;
				else
					next_state=Weakly_Global;
			end
			Weakly_Global:
			begin
				if(outcome==TRUE)
					next_state=Strongly_Global;
				else
					next_state=Weakly_Local;
			end
			Strongly_Global:
			begin
				if(outcome==TRUE)
					next_state=Strongly_Global;
				else
					next_state=Weakly_Global;
			end
		endcase	
	end


endmodule