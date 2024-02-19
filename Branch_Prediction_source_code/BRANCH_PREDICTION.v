`timescale 1ns / 1ps
module BRANCH_PREDICTION (
	input clk,
	input [31:0] pc_cur_if,
	input [31:0] pc_cur_ex,
	input update_en,
	input branch_outcome,	//是否发生分支
	input predict_outcome,	//分支预测结果(true/false)
	input [31:0] update_addr,
	output reg branch_predict,	//预测是否要发生分支
	output [31:0] branch_addr		//分支的地址
);

	parameter YES = 1'b1;
	parameter NO = 	1'b0;

	wire local_predict,global_predict,branch_predict_learning;

	LOCAL_PREDICTION local_prediction(
		.clk(clk),
		.pc_cur_if(pc_cur_if),
		.pc_cur_ex(pc_cur_ex),
		.branch_outcome(branch_outcome),
		.update_en(update_en),
		.local_predict(local_predict)
	);

	GLOBAL_PREDICTION global_prediction(
		.clk(clk),
		.pc_cur_if(pc_cur_if),
		.pc_cur_ex(pc_cur_ex),
		.branch_outcome(branch_outcome),
		.update_en(update_en),
		.global_predict(global_predict)
	);

	PREDICT_COMPETITION predict_competition(
		.clk(clk),
		.update_en(update_en),
		.local_predict(local_predict),
		.global_predict(global_predict),
		.predict_outcome(predict_outcome),
		.branch_predict(branch_predict_learning)
	);

	wire hit;
	BTB btb (
		.clk(clk),
		.pc_cur_if(pc_cur_if),
		.pc_cur_ex(pc_cur_ex),
		.update_en(update_en),
		.update_addr(update_addr),
		.hit(hit),
		.branch_addr(branch_addr)
	);

	always @(*) 
	begin
		if(branch_predict_learning&&hit)
			branch_predict=YES;
		else
			branch_predict=NO;
	end
	
endmodule