`timescale 1ns / 1ps
module LOCAL_PREDICTION (
	input clk,
	input [31:0] pc_cur_if,	//search
	input [31:0] pc_cur_ex,	//update
	input branch_outcome,	//实际跳转结果，在EXE阶段给出
	input update_en,		//更新使能，避免非分支指令对BHT和PHT进行修改
	output reg local_predict	//局部历史分支预测结果
);

	parameter YES = 1'b1;
	parameter NO  = 1'b0;
	parameter strongly_not=2'd0;
	parameter weakly_not=2'd1;
	parameter weakly_yes=2'd2;
	parameter strongly_yes=2'd3;

	reg [3:0] BHT [0:63];	//BHT
	reg [1:0] PHT [0:63][0:15];	//PHT

	integer i,j;
	initial 
	begin
		i=0;
		while(i<64)
		begin
			BHT[i]=4'h0;
			i=i+1;
		end
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

	wire [5:0] pc_if_hash;
	wire [5:0] pc_ex_hash;
	wire [3:0] search_hash;
	wire [3:0] update_hash;

	assign pc_if_hash=pc_cur_if[7:2];
	assign pc_ex_hash=pc_cur_ex[7:2];
	assign search_hash=BHT[pc_if_hash];
	assign update_hash=BHT[pc_ex_hash];

	//update the BHT
	always @(posedge clk) 
	begin
		if(update_en)
		begin
			if(branch_outcome==YES)
				BHT[pc_ex_hash]<=(BHT[pc_ex_hash]<<1)|3'b1;
			else
				BHT[pc_ex_hash]<=(BHT[pc_ex_hash]<<1)|3'b0;
		end
		else
			BHT[pc_ex_hash]<=BHT[pc_ex_hash];
	end

	//update the PHT
	wire [1:0] old_state;
	wire [1:0] new_state;
	assign old_state=PHT[pc_ex_hash][update_hash];

	TWO_BITS_FSM update_PHT_local(
		.current_state(old_state),
		.outcome(branch_outcome),
		.next_state(new_state)
	);

	always @(posedge clk) 
	begin
		if(update_en)
		begin
			PHT[pc_ex_hash][update_hash]<=new_state;
		end
		else
			PHT[pc_ex_hash][update_hash]<=PHT[pc_ex_hash][update_hash];
	end

	//branch predict
	wire [1:0] search_state;
	assign search_state=PHT[pc_if_hash][search_hash];

	always @(*)
	begin
		case(search_state)
			strongly_not:
				local_predict=NO;
			weakly_not:
				local_predict=NO;
			weakly_yes:
				local_predict=YES;
			strongly_yes:
				local_predict=YES;
		endcase
	end

endmodule