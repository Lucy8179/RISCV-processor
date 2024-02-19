`timescale 1ns / 1ps
module GLOBAL_PREDICTION (
	input clk,
	input [31:0] pc_cur_if,	//search
	input [31:0] pc_cur_ex,	//update
	input branch_outcome,	//实际跳转结果，在EXE阶段给出
	input update_en,		//更新使能，避免非分支指令(以及jalr指令)对BHT和PHT进行修改
	output reg global_predict	//局部历史分支预测结果
);

	parameter YES=1'b1;
	parameter NO=1'b0;
	parameter strongly_not=2'd0;
	parameter weakly_not=2'd1;
	parameter weakly_yes=2'd2;
	parameter strongly_yes=2'd3;

	reg [7:0] GHR;
	reg [1:0] PHT [0:63][0:15];	//PHT

	integer i,j;
	initial
	begin
		GHR=8'h0;
	end
	initial
	begin
		i=0;
		j=0;
		while(i<64)
		begin
			j=0;
			while (j<16) 
			begin
				PHT[i][j]=2'b01;
				j=j+1;
			end
			i=i+1;
		end
	end

	wire [3:0] GHR_hash;
	assign GHR_hash=GHR[3:0];

	wire [5:0] pc_if_hash;
	wire [5:0] pc_ex_hash;
	assign pc_if_hash=pc_cur_if[7:2];
	assign pc_ex_hash=pc_cur_ex[7:2];

	//update GHR
	always @(posedge clk) 
	begin
		if(update_en)
		begin
			if(branch_outcome==YES)
				GHR<=(GHR<<1)|8'b1;
			else
				GHR<=(GHR<<1)|8'b0;	
		end
		else
			GHR<=GHR;
	end

	//update PHT
	wire [1:0] old_state;
	wire [1:0] new_state;
	assign old_state=PHT[pc_ex_hash][GHR_hash];
	TWO_BITS_FSM update_PHT_global(
		.current_state(old_state),
		.outcome(branch_outcome),
		.next_state(new_state)
	);
	always @(posedge clk) 
	begin
		if(update_en)
		begin
			PHT[pc_ex_hash][GHR_hash]<=new_state;
		end
		else
		begin
			PHT[pc_ex_hash][GHR_hash]<=PHT[pc_ex_hash][GHR_hash];
		end
	end

	//global predict
	wire [1:0] search_state;
	assign search_state=PHT[pc_if_hash][GHR_hash];

	always @(*)
	begin
		case(search_state)
			strongly_not:
				global_predict=NO;
			weakly_not:
				global_predict=NO;
			weakly_yes:
				global_predict=YES;
			strongly_yes:
				global_predict=YES;
		endcase
	end
endmodule