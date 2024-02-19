`timescale 1ns / 1ps
module Branch_Predict_Analyze (
	input clk,
	input update_en,
	input control_hazard,
	output [31:0] branch_predict_total,
	output [31:0] branch_false
);

	reg [31:0] count_branch_total;
	reg [31:0] count_branch_false;

	initial 
	begin
		count_branch_total=32'h0;
		count_branch_false=32'h0;	
	end

	always @(posedge clk) 
	begin
		if(update_en)
			count_branch_total<=count_branch_total+1;
		else
			count_branch_total<=count_branch_total;
	end
	
	always @(posedge clk) 
	begin
		if(update_en&&control_hazard)
			count_branch_false<=count_branch_false+1;
		else
			count_branch_false<=count_branch_false;	
	end

	assign branch_predict_total=count_branch_total;
	assign branch_false=count_branch_false;
endmodule