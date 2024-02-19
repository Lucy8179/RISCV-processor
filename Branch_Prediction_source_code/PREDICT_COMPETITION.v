`timescale 1ns / 1ps
module PREDICT_COMPETITION (
	input clk,
	input update_en,
	input local_predict,
	input global_predict,
	input predict_outcome,	//分支预测结果(true/false)
	output reg branch_predict	//给出是否发生预测的判断
);
	
	parameter TRUE=1'b1;
	parameter FALSE=1'b0;
	parameter Strongly_Local=2'd0;
	parameter Weakly_Local=2'd1;
	parameter Weakly_Global=2'd2;
	parameter Strongly_Global=2'd3;

	reg [1:0] current_state;
	wire [1:0] current_state_in,next_state;
	assign current_state_in=current_state;
	
	initial
	begin
		current_state=Strongly_Local;
	end

	COMPETITION_FSM predict_state_gen(
		.current_state(current_state_in),
		.outcome(predict_outcome),
		.next_state(next_state)
	);

	always @(posedge clk) 
	begin
		if(update_en)
			current_state<=next_state;	
		else
			current_state<=current_state;
	end

	//output	
	always @(*) 
	begin
		case(current_state)
			Strongly_Local:
				branch_predict=local_predict;
			Weakly_Local:
				branch_predict=local_predict;
			Weakly_Global:
				branch_predict=global_predict;
			Strongly_Global:
				branch_predict=global_predict;
		endcase
	end

	
endmodule