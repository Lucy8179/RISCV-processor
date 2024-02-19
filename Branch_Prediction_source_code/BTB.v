`timescale 1ns / 1ps
module BTB (
	input clk,
	input [31:0] pc_cur_if,
	input [31:0] pc_cur_ex,
	input update_en,	//是否能更新(只有非jalr的跳转指令能更新)
	input [31:0] update_addr,
	output reg hit,		//是否命中
	output [31:0] branch_addr
);

	parameter YES = 1'b1;
	parameter NO  = 1'b0;

	//下列三个表位于同一行，即共享一个行地址（PC hash值）
	reg [31:0] BTB_32 [0:63];
	reg [23:0] Tag [0:63];	//BTB的Tag位
	reg [63:0] valid;	//地址是否有效

	integer i;
	initial 
	begin
		i=0;
		while(i<64)
		begin
			BTB_32[i]<=32'h0;
			Tag[i]<=24'h0;
			i=i+1;
		end	
	end

	initial
	begin
		valid=32'h0;
	end
	
	wire [5:0] pc_if_hash;
	wire [5:0] pc_ex_hash;
	assign pc_if_hash=pc_cur_if[7:2];
	assign pc_ex_hash=pc_cur_ex[7:2];
	
	wire [23:0] pc_if_tag;
	wire [23:0] pc_check_tag;
	assign pc_if_tag=pc_cur_if[31:8];
	assign pc_check_tag=Tag[pc_if_hash];

	//detect hit/miss
	always @(*) 
	begin
		if((pc_if_tag==pc_check_tag)&&valid[pc_if_hash])
			hit=YES;
		else
		 	hit=NO;	
	end

	wire [23:0] pc_ex_tag;
	assign pc_ex_tag=pc_cur_ex[31:8];
	
	//update BTB
	always @(posedge clk) 
	begin
		if(update_en)
		begin
			valid[pc_ex_hash]<=YES;
			Tag[pc_ex_hash]<=pc_ex_tag;
			BTB_32[pc_ex_hash]<=update_addr;
		end
		else	
		begin
			valid[pc_ex_hash]<=valid[pc_ex_hash];
			Tag[pc_ex_hash]<=Tag[pc_ex_hash];
			BTB_32[pc_ex_hash]<=BTB_32[pc_ex_hash];
		end
	end

	assign branch_addr=BTB_32[pc_if_hash];

endmodule