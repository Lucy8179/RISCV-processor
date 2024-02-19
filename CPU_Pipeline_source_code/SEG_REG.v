`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 21:26:29
// Design Name: 
// Module Name: SEG_REG
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

	// SEG_REG name(
	// 	//input port
	// 	.clk(),
	// 	.flush(),
	// 	.stall(),
	// 	.pc_cur_in(),
	// 	.inst_in(),
	// 	.rf_ra0_in(),
	// 	.rf_ra1_in(),
	// 	.rf_re0_in(),
	// 	.rf_re1_in(),
	// 	.rf_rd0_raw_in(),
	// 	.rf_rd1_raw_in(),
	// 	.rf_rd0_in(),
	// 	.rf_rd1_in(),
	// 	.rf_wa_in(),
	// 	.rf_wd_sel_in(),
	// 	.rf_we_in(),
	// 	.imm_type_in(),
	// 	.imm_in(),
	// 	.alu_src1_sel_in(),
	// 	.alu_src2_sel_in(),
	// 	.alu_src1_in(),
	// 	.alu_src2_in(),
	// 	.alu_func_in(),
	// 	.alu_ans_in(),
	// 	.pc_add4_in(),
	// 	.pc_br_in(),
	// 	.pc_jal_in(),
	// 	.pc_jalr_in(),
	// 	.jal_in(),
	// 	.jalr_in(),
	// 	.br_type_in(),
	// 	.br_in(),
	// 	.pc_sel_in(),
	// 	.pc_next_in(),
	// 	.dm_addr_in(),
	// 	.dm_din_in(),
	// 	.dm_dout_in(),
	// 	.dm_we_in(),

	// 	//output port
	// 	.pc_cur_out(),
	// 	.inst_out(),
	// 	.rf_ra0_out(),
	// 	.rf_ra1_out(),
	// 	.rf_re0_out(),
	// 	.rf_re1_out(),
	// 	.rf_rd0_raw_out(),
	// 	.rf_rd1_raw_out(),
	// 	.rf_rd0_out(),
	// 	.rf_rd1_out(),
	// 	.rf_wa_out(),
	// 	.rf_wd_sel_out(),
	// 	.rf_we_out(),
	// 	.imm_type_out(),
	// 	.imm_out(),
	// 	.alu_src1_sel_out(),
	// 	.alu_src2_sel_out(),
	// 	.alu_src1_out(),
	// 	.alu_src2_out(),
	// 	.alu_func_out(),
	// 	.alu_ans_out(),
	// 	.pc_add4_out(),
	// 	.pc_br_out(),
	// 	.pc_jal_out(),
	// 	.pc_jalr_out(),
	// 	.jal_out(),
	// 	.jalr_out(),
	// 	.br_type_out(),
	// 	.br_out(),
	// 	.pc_sel_out(),
	// 	.pc_next_out(),
	// 	.dm_addr_out(),
	// 	.dm_din_out(),
	// 	.dm_dout_out(),
	// 	.dm_we_out()
	// );

module SEG_REG(
	input clk,flush,stall,

	input [31:0] pc_cur_in,
	output [31:0] pc_cur_out,
	
	input [31:0] inst_in,
	output [31:0] inst_out,

	input [4:0] rf_ra0_in,rf_ra1_in,
	output [4:0] rf_ra0_out,rf_ra1_out,

	input rf_re0_in,rf_re1_in,
	output rf_re0_out,rf_re1_out,

	input [31:0] rf_rd0_raw_in,rf_rd1_raw_in,
	output [31:0] rf_rd0_raw_out,rf_rd1_raw_out,

	input [31:0] rf_rd0_in,rf_rd1_in,
	output [31:0] rf_rd0_out,rf_rd1_out,

	input [4:0] rf_wa_in,
	output [4:0] rf_wa_out,

	input [1:0] rf_wd_sel_in,
	output [1:0] rf_wd_sel_out,

	input rf_we_in,
	output rf_we_out,

	input [2:0] imm_type_in,
	output [2:0] imm_type_out,

	input [31:0] imm_in,
	output [31:0] imm_out,

	input alu_src1_sel_in,alu_src2_sel_in,
	output alu_src1_sel_out,alu_src2_sel_out,

	input [31:0] alu_src1_in,alu_src2_in,
	output [31:0] alu_src1_out,alu_src2_out,

	input [3:0] alu_func_in,
	output [3:0] alu_func_out,
	
	input [31:0] alu_ans_in,
	output [31:0] alu_ans_out,

	input [31:0] pc_add4_in,pc_br_in,pc_jal_in,pc_jalr_in,
	output [31:0] pc_add4_out,pc_br_out,pc_jal_out,pc_jalr_out,

	input jal_in,jalr_in,
	output jal_out,jalr_out,

	input [2:0] br_type_in,
	output [2:0] br_type_out,

	input br_in,
	output br_out,

	input [1:0] pc_sel_in,
	output [1:0] pc_sel_out,

	input [31:0] pc_next_in,
	output [31:0] pc_next_out,

	input [31:0] dm_addr_in,dm_din_in,dm_dout_in,
	output [31:0] dm_addr_out,dm_din_out,dm_dout_out,

	input dm_we_in,
	output dm_we_out,

	input [2:0] read_type_in,
	output [2:0] read_type_out,

	input [1:0] write_type_in,
	output [1:0] write_type_out,

	input branch_predict_in,
	output branch_predict_out	//分支预测

	);

	wire rst,reg_en;
	assign rst=flush;
	assign reg_en=~stall;

	Register #(32) PC_CUR_OUT  (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(pc_cur_in),
        .reg_dout(pc_cur_out)
    );

	Register #(32) INST_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(inst_in),
        .reg_dout(inst_out)
    );

	Register #(5) RF_RA0_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(rf_ra0_in),
        .reg_dout(rf_ra0_out)
    );

	Register #(5) RF_RA1_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(rf_ra1_in),
        .reg_dout(rf_ra1_out)
    );

	Register #(1) RF_RE0_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(rf_re0_in),
        .reg_dout(rf_re0_out)
    );

	Register #(1) RF_RE1_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(rf_re1_in),
        .reg_dout(rf_re1_out)
    );

	Register #(32) RF_RD0_RAW_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(rf_rd0_raw_in),
        .reg_dout(rf_rd0_raw_out)
    );

	Register #(32) RF_RD1_RAW_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(rf_rd1_raw_in),
        .reg_dout(rf_rd1_raw_out)
    );

	Register #(32) RF_RD0_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(rf_rd0_in),
        .reg_dout(rf_rd0_out)
    );

	Register #(32) RF_RD1_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(rf_rd1_in),
        .reg_dout(rf_rd1_out)
    );

	Register #(5) RF_WA_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(rf_wa_in),
        .reg_dout(rf_wa_out)
    );

	Register #(2) RF_WD_SEL_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(rf_wd_sel_in),
        .reg_dout(rf_wd_sel_out)
    );

	Register #(1) RF_WE_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(rf_we_in),
        .reg_dout(rf_we_out)
    );

	Register #(3) IMM_TYPE_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(imm_type_in),
        .reg_dout(imm_type_out)
    );

	Register #(32) IMM_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(imm_in),
        .reg_dout(imm_out)
    );

	Register #(1) ALU_SRC1_SEL_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(alu_src1_sel_in),
        .reg_dout(alu_src1_sel_out)
    );

	Register #(1) ALU_SRC2_SEL_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(alu_src2_sel_in),
        .reg_dout(alu_src2_sel_out)
    );

	Register #(32) ALU_SRC1_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(alu_src1_in),
        .reg_dout(alu_src1_out)
    );

	Register #(32) ALU_SRC2_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(alu_src2_in),
        .reg_dout(alu_src2_out)
    );

	Register #(4) ALU_FUNC_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(alu_func_in),
        .reg_dout(alu_func_out)
    );

	Register #(32) ALU_ANS_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(alu_ans_in),
        .reg_dout(alu_ans_out)
    );

	Register #(32) PC_ADD4_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(pc_add4_in),
        .reg_dout(pc_add4_out)
    );

	Register #(32) PC_BR_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(pc_br_in),
        .reg_dout(pc_br_out)
    );

	Register #(32) PC_JAL_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(pc_jal_in),
        .reg_dout(pc_jal_out)
    );

	Register #(32) PC_JALR_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(pc_jalr_in),
        .reg_dout(pc_jalr_out)
    );

	Register #(1) JAL_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(jal_in),
        .reg_dout(jal_out)
    );

	Register #(1) JALR_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(jalr_in),
        .reg_dout(jalr_out)
    );

	Register #(3) BR_TYPE_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(br_type_in),
        .reg_dout(br_type_out)
    );

	Register #(1) BR_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(br_in),
        .reg_dout(br_out)
    );

	Register #(2) PC_SEL_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(pc_sel_in),
        .reg_dout(pc_sel_out)
    );

	Register #(32) PC_NEXT_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(pc_next_in),
        .reg_dout(pc_next_out)
    );

	Register #(32) DM_ADDR_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(dm_addr_in),
        .reg_dout(dm_addr_out)
    );

	Register #(32) DM_DIN_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(dm_din_in),
        .reg_dout(dm_din_out)
    );

	Register #(32) DM_DOUT_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(dm_dout_in),
        .reg_dout(dm_dout_out)
    );

	Register #(1) DM_WE_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(dm_we_in),
        .reg_dout(dm_we_out)
    );

    Register #(3) READ_TYPE_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(read_type_in),
        .reg_dout(read_type_out)
    );	

    Register #(2) WRITE_TYPE_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(write_type_in),
        .reg_dout(write_type_out)
    );

	Register #(1) BRANCH_PREDICT_OUT (
        .clk(clk),
        .rst(rst),

        .reg_en(reg_en),
        .reg_din(branch_predict_in),
        .reg_dout(branch_predict_out)
    );

endmodule
