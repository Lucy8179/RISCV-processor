`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/20 15:06:43
// Design Name: 
// Module Name: Hazard
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Hazard(
	input [4:0] rf_ra0_id,rf_ra1_id,rf_ra0_ex,rf_ra1_ex,
	input rf_re0_id,rf_re1_id,rf_re0_ex,rf_re1_ex,
	input [4:0] rf_wa_ex,rf_wa_mem,
	input rf_we_ex,rf_we_mem,
	input [1:0] rf_wd_sel_ex,rf_wd_sel_mem,
	input [31:0] alu_ans_mem,
	input [31:0] pc_add4_mem,
	input [31:0] imm_mem,
	input [4:0] rf_wa_wb,
	input rf_we_wb,
	input [31:0] rf_wd_wb,
	input control_hazard,
	output reg rf_rd0_fe,rf_rd1_fe,
	output reg [31:0] rf_rd0_fd,rf_rd1_fd,
	output stall_if,stall_id,
	output flush_id,flush_ex
    );
	//MUX2 rf_wd_sel
	parameter alu_res=2'd0;
	parameter pc_add4=2'd1;
	parameter mem_rd=2'd2;
	parameter imm=2'd3; 

	parameter NO=1'b0;
	parameter YES=1'b1;
	parameter NULL=32'b0;

	//pc_sel_ex
	parameter pc_jalr=2'd1;
	parameter alu_ans=2'd2;

	//data hazard
	reg stall_if_data_hazard,stall_id_data_hazard;
	reg flush_ex_data_hazard;
	initial 
	begin
		stall_if_data_hazard=NO;
		stall_id_data_hazard=NO;
		flush_ex_data_hazard=NO;
	end
	//forwarding part without bubbles
	wire mem_forward0,mem_forward1;
	wire wb_forward0,wb_forward1;

	assign mem_forward0=(rf_we_mem==YES)&&(rf_re0_ex==YES)&&(rf_wa_mem==rf_ra0_ex);
	
	assign wb_forward0=(rf_we_wb==YES)&&(rf_re0_ex==YES)&&(rf_wa_wb==rf_ra0_ex);
	
	assign mem_forward1=(rf_we_mem==YES)&&(rf_re1_ex==YES)&&(rf_wa_mem==rf_ra1_ex);
	
	assign wb_forward1=(rf_we_wb==YES)&&(rf_re1_ex==YES)&&(rf_wa_wb==rf_ra1_ex);
	
	always @(*)
	begin
		if(mem_forward0)
		begin
			rf_rd0_fe=YES;
			case(rf_wd_sel_mem)
				alu_res:rf_rd0_fd=alu_ans_mem;
				pc_add4:rf_rd0_fd=pc_add4_mem;
				imm:rf_rd0_fd=imm_mem;
				default:rf_rd0_fd=NULL;
			endcase
		end
		else if(wb_forward0)
		begin
			rf_rd0_fd=rf_wd_wb;
			rf_rd0_fe=YES;
		end
		else
		begin
			rf_rd0_fd=NULL;
			rf_rd0_fe=NO;
		end
	end

	always @(*)
	begin
		if(mem_forward1)
		begin
			rf_rd1_fe=YES;
			case(rf_wd_sel_mem)
				alu_res:rf_rd1_fd=alu_ans_mem;
				pc_add4:rf_rd1_fd=pc_add4_mem;
				imm:rf_rd1_fd=imm_mem;
				default:rf_rd1_fd=NULL;
			endcase
		end
		else if(wb_forward1)
		begin
			rf_rd1_fd=rf_wd_wb;
			rf_rd1_fe=YES;
		end
		else
		begin
			rf_rd1_fd=NULL;
			rf_rd1_fe=NO;
		end
	end

	//fowarding part with bubbles
	//load use_hazard
	wire load_use_hazard;
	wire load_use_hazard_part1,load_use_hazard_part2;
	
	assign load_use_hazard_part1=(rf_we_ex==YES)&&(rf_re0_id==YES)&&(rf_wa_ex==rf_ra0_id)&&(rf_wd_sel_ex==mem_rd);
	assign load_use_hazard_part2=(rf_we_ex==YES)&&(rf_re1_id==YES)&&(rf_wa_ex==rf_ra1_id)&&(rf_wd_sel_ex==mem_rd);
	assign load_use_hazard=load_use_hazard_part1||load_use_hazard_part2;
	
	always @(*)
	begin
		if(load_use_hazard)
		begin
			flush_ex_data_hazard=YES;
			stall_if_data_hazard=YES;
			stall_id_data_hazard=YES;
		end
		else
		begin
			flush_ex_data_hazard=NO;
			stall_if_data_hazard=NO;
			stall_id_data_hazard=NO;
		end
	end

	//control hazard
	reg flush_id_ctrl_hazard,flush_ex_ctrl_hazard;
	initial
	begin
		flush_id_ctrl_hazard=NO;
		flush_ex_ctrl_hazard=NO;
	end

	always @ (*)
	begin
		if(control_hazard)
		begin
			flush_id_ctrl_hazard=YES;
			flush_ex_ctrl_hazard=YES;
		end
		else
		begin
			flush_id_ctrl_hazard=NO;
			flush_ex_ctrl_hazard=NO;
		end
	end

	//output stall/flush signal

	assign stall_if=stall_if_data_hazard;
	assign stall_id=stall_id_data_hazard;

	assign flush_id=flush_id_ctrl_hazard;
	assign flush_ex=flush_ex_data_hazard||flush_ex_ctrl_hazard;

	
endmodule
