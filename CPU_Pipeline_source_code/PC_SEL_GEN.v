`timescale 1ns / 1ps
module PC_SEL_GEN (
	input branch_predict,
	input predict_outcome,
	input [1:0] pc_sel_ex,
	input pc_sel_default,
	output reg [2:0] pc_sel,
	output reg control_hazard	
);
	
	parameter pc_add4=3'd0;
	parameter pc_jalr=3'd1;
	parameter alu_ans=3'd2;
	parameter branch_addr=3'd3;
	parameter pc_add4_ex=3'd4;
	parameter TRUE=1'b1;
	parameter FALSE=1'b0;
	parameter YES=1'b1;
	parameter NO=1'b0;

	//先处理跳错异常(本不用分支但预测分支了)
	//再处理EX阶段跳转指令(如jal,jalr,beq)跳转请求
	//再响应分支预测(此时EX阶段无跳转)
	//最后则正常pc+4
	always @(*) 
	begin
		if(pc_sel_default)
		begin
			pc_sel=pc_add4_ex;
			control_hazard=YES;
		end
		else if(predict_outcome==FALSE)
		begin
			pc_sel={1'b0,pc_sel_ex};
			control_hazard=YES;
		end
		else if(branch_predict)
		begin
			pc_sel=branch_addr;
			control_hazard=NO;
		end
		else 
		begin
			pc_sel=pc_add4;
			control_hazard=NO;
		end	
	end

endmodule