`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 22:12:09
// Design Name: 
// Module Name: CTRL
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


module CTRL(
	input [31:0] inst,
	output reg rf_re0,rf_re1,
	output reg jal,jalr,
	output reg [2:0] br_type,
	output reg rf_we,
	output reg [1:0] rf_wd_sel,
	output reg alu_src1_sel,
	output reg alu_src2_sel,
	output reg [3:0] alu_func,
	output reg [2:0] imm_type,
	output reg mem_we,
	output reg [2:0] read_type,
	output reg [1:0] write_type
    );
	wire [6:0] opcode;
	wire [2:0] funct3;
	wire [6:0] funct7;
	wire [4:0] ra0,ra1,wa;
	assign opcode=inst[6:0];
	assign funct3=inst[14:12];
	assign funct7=inst[31:25];
	assign ra0=inst[19:15];
	assign ra1=inst[24:20];
	assign wa=inst[11:7];

	//rf_re part
	parameter Reg0=0;

	//alu_func
	parameter ADD=4'd0;
	parameter SUB=4'd1;
	parameter EQUAL=4'd2;
	parameter UNSIGNED_LESS_THAN=4'd3;
	parameter LESS_THAN=4'd4;
	parameter AND=4'd5;
	parameter OR=4'd6;
	parameter XOR=4'd7;
	parameter SHIFT_RIGHT=4'd8;
	parameter SHIFT_LEFT=4'd9;
	parameter SHIFT_LEFT_ARITH=4'd10;
	parameter SHIFT_RIGHT_ARITH=4'd11;
	parameter ELSE=4'd12;
	
	//br_type
	parameter NO_BR=3'd0;
	parameter beq=3'd1;
	parameter blt=3'd2;
	parameter bne=3'd3;
	parameter bge=3'd4;
	parameter bltu=3'd5;
	parameter bgeu=3'd6;

	//imm_type
	parameter NO_IMM=3'd0;
	parameter I_Type=3'd1;//addi,jalr
	parameter S_Type=3'd2;//sw
	parameter SB_Type=3'd3;//beq,blt
	parameter U_Type=3'd4;//auipc,lui
	parameter UJ_Type=3'd5;//jal

	//MUX1 alu_src1_sel
	parameter RD0=1'd0;
	parameter PC_CUR=1'd1;

	//MUX1 alu_src2_sel
	parameter RD1=1'd0;
	parameter IMM=1'd1;

	//MUX2 rf_wd_sel
	parameter alu_res=2'd0;
	parameter pc_add4=2'd1;
	parameter mem_rd=2'd2;
	parameter imm=2'd3; 
	
	parameter NO=1'b0;
	parameter YES=1'b1;

	//read type
	parameter lw=3'd0;
	parameter lb=3'd1;
	parameter lbu=3'd2;
	parameter lh=3'd3;
	parameter lhu=3'd4;
	
	//write type
	parameter sw=2'd0;
	parameter sb=2'd1;
	parameter sh=2'd2;

	always @(*)
	begin
		case(opcode)
			7'b0000011://load(lw,lb,lh......)
			begin
				if(ra0!=Reg0)
					rf_re0=YES;
				else
					rf_re0=NO;
				rf_re1=NO;
				jal=NO;
				jalr=NO;
				br_type=NO_BR;
				if(wa!=Reg0)
					rf_we=YES;
				else
					rf_we=NO;
				rf_wd_sel=mem_rd;
				alu_src1_sel=RD0;
				alu_src2_sel=IMM;
				alu_func=ADD;
				imm_type=I_Type;
				mem_we=NO;
			end
			7'b0010011://addi,slli,slti......
			begin
				case(funct3)
					3'b000://addi
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=IMM;
						alu_func=ADD;
						imm_type=I_Type;
						mem_we=NO;						
					end
					3'b001://slli
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=IMM;
						alu_func=SHIFT_LEFT;
						imm_type=I_Type;
						mem_we=NO;						
					end
					3'b010://slti
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=IMM;
						alu_func=LESS_THAN;
						imm_type=I_Type;
						mem_we=NO;						
					end
					3'b011://sltiu
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=IMM;
						alu_func=UNSIGNED_LESS_THAN;
						imm_type=I_Type;
						mem_we=NO;						
					end
					3'b100://xori
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=IMM;
						alu_func=XOR;
						imm_type=I_Type;
						mem_we=NO;						
					end
					3'b101://srli&srai
					begin
						case(funct7)
							7'b0000000://srli
							begin
								if(ra0!=Reg0)
									rf_re0=YES;
								else
									rf_re0=NO;
								if(ra1!=Reg0)
									rf_re1=YES;
								else
									rf_re1=NO;
								jal=NO;
								jalr=NO;
								br_type=NO_BR;
								if(wa!=Reg0)
									rf_we=YES;
								else
									rf_we=NO;
								rf_wd_sel=alu_res;
								alu_src1_sel=RD0;
								alu_src2_sel=IMM;
								alu_func=SHIFT_RIGHT;
								imm_type=I_Type;
								mem_we=NO;													
							end
							7'b0100000://srai
							begin
								if(ra0!=Reg0)
									rf_re0=YES;
								else
									rf_re0=NO;
								if(ra1!=Reg0)
									rf_re1=YES;
								else
									rf_re1=NO;
								jal=NO;
								jalr=NO;
								br_type=NO_BR;
								if(wa!=Reg0)
									rf_we=YES;
								else
									rf_we=NO;
								rf_wd_sel=alu_res;
								alu_src1_sel=RD0;
								alu_src2_sel=IMM;
								alu_func=SHIFT_RIGHT_ARITH;
								imm_type=I_Type;
								mem_we=NO;		
							end
							default:
							begin
								rf_re0=NO;
								rf_re1=NO;
								jal=NO;
								jalr=NO;
								br_type=NO_BR;
								rf_we=NO;
								rf_wd_sel=mem_rd;
								alu_src1_sel=RD0;
								alu_src2_sel=IMM;
								alu_func=ELSE;
								imm_type=NO_IMM;
								mem_we=NO;								
							end
						endcase
					end
					3'b110://ori
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=IMM;
						alu_func=OR;
						imm_type=I_Type;
						mem_we=NO;						
					end
					3'b111://andi
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=IMM;
						alu_func=AND;
						imm_type=I_Type;
						mem_we=NO;						
					end
					default:
					begin
						rf_re0=NO;
						rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						rf_we=NO;
						rf_wd_sel=mem_rd;
						alu_src1_sel=RD0;
						alu_src2_sel=IMM;
						alu_func=ELSE;
						imm_type=NO_IMM;
						mem_we=NO;						
					end
				endcase
			end
			7'b0010111://auipc
			begin
				rf_re0=NO;
				rf_re1=NO;
				jal=NO;
				jalr=NO;
				br_type=NO_BR;
				if(wa!=Reg0)
					rf_we=YES;
				else
					rf_we=NO;
				rf_wd_sel=alu_res;
				alu_src1_sel=PC_CUR;
				alu_src2_sel=IMM;
				alu_func=ADD;
				imm_type=U_Type;
				mem_we=NO;
			end
			7'b0100011://store(sw,sb,sh)
			begin
				if(ra0!=Reg0)
					rf_re0=YES;
				else
					rf_re0=NO;
				if(ra1!=Reg0)
					rf_re1=YES;
				else
					rf_re1=NO;
				jal=NO;
				jalr=NO;
				br_type=NO_BR;
				rf_we=NO;
				rf_wd_sel=mem_rd;
				alu_src1_sel=RD0;
				alu_src2_sel=IMM;
				alu_func=ADD;
				imm_type=S_Type;
				mem_we=YES;		
			end
			7'b0110011://add,sub,sll......
			begin
				case(funct3)
					3'b000://add,sub
					begin
						case(funct7)
							7'b0000000://add
							begin
								if(ra0!=Reg0)
									rf_re0=YES;
								else
									rf_re0=NO;
								if(ra1!=Reg0)
									rf_re1=YES;
								else
									rf_re1=NO;
								jal=NO;
								jalr=NO;
								br_type=NO_BR;
								if(wa!=Reg0)
									rf_we=YES;
								else
									rf_we=NO;
								rf_wd_sel=alu_res;
								alu_src1_sel=RD0;
								alu_src2_sel=RD1;
								alu_func=ADD;
								imm_type=NO_IMM;
								mem_we=NO;								
							end
							7'b0100000://sub
							begin
								if(ra0!=Reg0)
									rf_re0=YES;
								else
									rf_re0=NO;
								if(ra1!=Reg0)
									rf_re1=YES;
								else
									rf_re1=NO;
								jal=NO;
								jalr=NO;
								br_type=NO_BR;
								if(wa!=Reg0)
									rf_we=YES;
								else
									rf_we=NO;
								rf_wd_sel=alu_res;
								alu_src1_sel=RD0;
								alu_src2_sel=RD1;
								alu_func=SUB;
								imm_type=NO_IMM;
								mem_we=NO;								
							end
							default:
							begin
								rf_re0=NO;
								rf_re1=NO;
								jal=NO;
								jalr=NO;
								br_type=NO_BR;
								rf_we=NO;
								rf_wd_sel=mem_rd;
								alu_src1_sel=RD0;
								alu_src2_sel=IMM;
								alu_func=ELSE;
								imm_type=NO_IMM;
								mem_we=NO;
							end
						endcase
					end
					3'b001://sll
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=RD1;
						alu_func=SHIFT_LEFT;
						imm_type=NO_IMM;
						mem_we=NO;								
					end
					3'b010://slt
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=RD1;
						alu_func=LESS_THAN;
						imm_type=NO_IMM;
						mem_we=NO;		
					end
					3'b011://sltu
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=RD1;
						alu_func=UNSIGNED_LESS_THAN;
						imm_type=NO_IMM;
						mem_we=NO;		
					end
					3'b100://xor
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=RD1;
						alu_func=XOR;
						imm_type=NO_IMM;
						mem_we=NO;		
					end
					3'b101://srl&sra
					begin
						case(funct7)
							7'b0000000://srl
							begin
								if(ra0!=Reg0)
									rf_re0=YES;
								else
									rf_re0=NO;
								if(ra1!=Reg0)
									rf_re1=YES;
								else
									rf_re1=NO;
								jal=NO;
								jalr=NO;
								br_type=NO_BR;
								if(wa!=Reg0)
									rf_we=YES;
								else
									rf_we=NO;
								rf_wd_sel=alu_res;
								alu_src1_sel=RD0;
								alu_src2_sel=RD1;
								alu_func=SHIFT_RIGHT;
								imm_type=NO_IMM;
								mem_we=NO;		
							end
							7'b0100000://sra
							begin
								if(ra0!=Reg0)
									rf_re0=YES;
								else
									rf_re0=NO;
								if(ra1!=Reg0)
									rf_re1=YES;
								else
									rf_re1=NO;
								jal=NO;
								jalr=NO;
								br_type=NO_BR;
								if(wa!=Reg0)
									rf_we=YES;
								else
									rf_we=NO;
								rf_wd_sel=alu_res;
								alu_src1_sel=RD0;
								alu_src2_sel=RD1;
								alu_func=SHIFT_RIGHT_ARITH;
								imm_type=NO_IMM;
								mem_we=NO;		
							end
							default:
							begin
								rf_re0=NO;
								rf_re1=NO;
								jal=NO;
								jalr=NO;
								br_type=NO_BR;
								rf_we=NO;
								rf_wd_sel=mem_rd;
								alu_src1_sel=RD0;
								alu_src2_sel=IMM;
								alu_func=ELSE;
								imm_type=NO_IMM;
								mem_we=NO;
							end
						endcase
					end
					3'b110://or
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=RD1;
						alu_func=OR;
						imm_type=NO_IMM;
						mem_we=NO;		
					end
					3'b111://and
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						if(wa!=Reg0)
							rf_we=YES;
						else
							rf_we=NO;
						rf_wd_sel=alu_res;
						alu_src1_sel=RD0;
						alu_src2_sel=RD1;
						alu_func=AND;
						imm_type=NO_IMM;
						mem_we=NO;		
					end
					default:
					begin
						rf_re0=NO;
						rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						rf_we=NO;
						rf_wd_sel=mem_rd;
						alu_src1_sel=RD0;
						alu_src2_sel=IMM;
						alu_func=ELSE;
						imm_type=NO_IMM;
						mem_we=NO;
					end
				endcase
			end
			7'b0110111://lui
			begin
				rf_re0=NO;
				rf_re1=NO;
				jal=NO;
				jalr=NO;
				br_type=NO_BR;
				if(wa!=Reg0)
					rf_we=YES;
				else
					rf_we=NO;
				rf_wd_sel=imm;
				alu_src1_sel=RD0;
				alu_src2_sel=IMM;
				alu_func=ELSE;
				imm_type=U_Type;
				mem_we=NO;
			end
			7'b1100011://beq,blt......
			begin
				case(funct3)
					3'b000://beq
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=beq;
						rf_we=NO;
						rf_wd_sel=mem_rd;
						alu_src1_sel=PC_CUR;
						alu_src2_sel=IMM;
						alu_func=ADD;
						imm_type=SB_Type;
						mem_we=NO;
					end
					3'b100://blt
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=blt;
						rf_we=NO;
						rf_wd_sel=mem_rd;
						alu_src1_sel=PC_CUR;
						alu_src2_sel=IMM;
						alu_func=ADD;
						imm_type=SB_Type;
						mem_we=NO;
					end
					3'b001://bne
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=bne;
						rf_we=NO;
						rf_wd_sel=mem_rd;
						alu_src1_sel=PC_CUR;
						alu_src2_sel=IMM;
						alu_func=ADD;
						imm_type=SB_Type;
						mem_we=NO;
					end
					3'b101://bge
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=bge;
						rf_we=NO;
						rf_wd_sel=mem_rd;
						alu_src1_sel=PC_CUR;
						alu_src2_sel=IMM;
						alu_func=ADD;
						imm_type=SB_Type;
						mem_we=NO;
					end
					3'b110://bltu
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=bltu;
						rf_we=NO;
						rf_wd_sel=mem_rd;
						alu_src1_sel=PC_CUR;
						alu_src2_sel=IMM;
						alu_func=ADD;
						imm_type=SB_Type;
						mem_we=NO;
					end
					3'b111://bgeu
					begin
						if(ra0!=Reg0)
							rf_re0=YES;
						else
							rf_re0=NO;
						if(ra1!=Reg0)
							rf_re1=YES;
						else
							rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=bgeu;
						rf_we=NO;
						rf_wd_sel=mem_rd;
						alu_src1_sel=PC_CUR;
						alu_src2_sel=IMM;
						alu_func=ADD;
						imm_type=SB_Type;
						mem_we=NO;
					end
				default:
					begin
						rf_re0=NO;
						rf_re1=NO;
						jal=NO;
						jalr=NO;
						br_type=NO_BR;
						rf_we=NO;
						rf_wd_sel=mem_rd;
						alu_src1_sel=RD0;
						alu_src2_sel=IMM;
						alu_func=ELSE;
						imm_type=NO_IMM;
						mem_we=NO;
					end
				endcase
			end
			7'b1100111://jalr
			begin
				if(ra0!=Reg0)
					rf_re0=YES;
				else
					rf_re0=NO;
				rf_re1=NO;
				jal=NO;
				jalr=YES;
				br_type=NO_BR;
				if(wa!=Reg0)
					rf_we=YES;
				else
					rf_we=NO;
				rf_wd_sel=pc_add4;
				alu_src1_sel=RD0;
				alu_src2_sel=IMM;
				alu_func=ADD;
				imm_type=I_Type;
				mem_we=NO;
			end
			7'b1101111://jal
			begin
				rf_re0=NO;
				rf_re1=NO;
				jal=YES;
				jalr=NO;
				br_type=NO_BR;
				if(wa!=Reg0)
					rf_we=YES;
				else
					rf_we=NO;
				rf_wd_sel=pc_add4;
				alu_src1_sel=PC_CUR;
				alu_src2_sel=IMM;
				alu_func=ADD;
				imm_type=UJ_Type;
				mem_we=NO;
			end
			default:
			begin
				rf_re0=NO;
				rf_re1=NO;
				jal=NO;
				jalr=NO;
				br_type=NO_BR;
				rf_we=NO;
				rf_wd_sel=mem_rd;
				alu_src1_sel=RD0;
				alu_src2_sel=IMM;
				alu_func=ELSE;
				imm_type=NO_IMM;
				mem_we=NO;
			end
		endcase
	end

	//load
	always @(*) 
	begin
		if(opcode==7'b0000011)	//load
		begin
			case(funct3)
				3'b000://lb
					read_type=lb;
				3'b001://lh
					read_type=lh;
				3'b010://lw
					read_type=lw;
				3'b100://lbu
					read_type=lbu;
				3'b101://lhu
					read_type=lhu;
				default:
					read_type=lw;
			endcase
		end
		else	
			read_type=lw;	
	end

	//store
	always @(*) 
	begin
		if(opcode==7'b0100011)	//store
		begin
			case(funct3)
				3'b000://sb
					write_type=sb;
				3'b001://sh
					write_type=sh;
				3'b010:
					write_type=sw;
				default:
					write_type=sw;
			endcase
		end	
		else
			write_type=sw;
	end
endmodule
