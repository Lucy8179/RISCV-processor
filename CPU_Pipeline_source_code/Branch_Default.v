`timescale 1ns / 1ps
module Branch_Default (
	input [1:0] pc_sel_ex,
	input branch_predict,
	output reg pc_sel_default,
	output reg branch_outcome,
	output reg predict_outcome
);

	//pc_sel_ex
	parameter pc_add4=2'd0;
	parameter pc_jalr=2'd1;
	parameter alu_ans=2'd2;
	parameter branch_addr=2'd3;

	parameter TRUE=1'b1;
	parameter FALSE=1'b0;
	parameter YES=1'b1;
	parameter NO=1'b0;

	always @(*) 
	begin
		if(pc_sel_ex==alu_ans||pc_sel_ex==pc_jalr)
		begin
			if(branch_predict==YES)
			begin
				branch_outcome=YES;
				predict_outcome=TRUE;
			end
			else
			begin
				branch_outcome=YES;
				predict_outcome=FALSE;
			end
		end
		else
		begin
			if(branch_predict==YES)
			begin
				branch_outcome=NO;
				predict_outcome=FALSE;
			end
			else
			begin
				branch_outcome=NO;
				predict_outcome=TRUE;
			end
		end
	end

	always @(*) 
	begin
		if((pc_sel_ex==pc_add4)&&(branch_predict==YES))
			//不用分支但预测了分支
			pc_sel_default=YES;
		else
			pc_sel_default=NO;
	end
	
	
endmodule