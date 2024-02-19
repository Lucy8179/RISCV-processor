`timescale 1ns / 1ps
module TWO_BITS_FSM (
	input [1:0] current_state,
	input outcome,
	output reg [1:0] next_state
);

	parameter YES = 1'b1;
	parameter NO  = 1'b0;
	
	parameter strongly_not=2'd0;
	parameter weakly_not=2'd1;
	parameter weakly_yes=2'd2;
	parameter strongly_yes=2'd3;

	always @(*) 
	begin
		case(current_state)
			strongly_not:
			begin
				if(outcome==YES)
					next_state=weakly_not;
				else
					next_state=strongly_not;
			end
			weakly_not:
			begin
				if(outcome==YES)
					next_state=weakly_yes;
				else
					next_state=strongly_not;
			end
			weakly_yes:
			begin
				if(outcome==YES)
					next_state=strongly_yes;
				else
					next_state=weakly_not;
			end
			strongly_yes:
			begin
				if(outcome==YES)
					next_state=strongly_yes;
				else
					next_state=weakly_yes;
			end
		endcase	
	end
	
endmodule