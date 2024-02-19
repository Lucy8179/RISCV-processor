`timescale 1ns / 1ps
module Data_Mem (
    input clk,

    // MEM Data BUS with CPU
	// DM port
    input  [31:0] dm_addr,
    input dm_we,
	input [2:0] read_type,
	input [1:0] write_type,
    input  [31:0] dm_din,
    output [31:0] dm_dout,

    // MEM Debug BUS
    input [31:0] mem_check_addr,
    output [31:0] mem_check_data
);
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

	//read part
	reg [31:0] read_data;

	//write part
	//sb instruction
	wire [1:0] byte_offset;
	assign byte_offset=dm_addr[1:0];
	parameter BYTE_1=2'd0;
	parameter BYTE_2=2'd1;
	parameter BYTE_3=2'd2;
	parameter BYTE_4=2'd3;

	//sh insruction
	wire half_word_offset=dm_addr[1];
	parameter LOW_HALF=1'd0;
	parameter HIGH_HALF=1'd1;

	wire we;
	wire [7:0] a,dpra;
	wire [31:0] d,spo,dpo;

	reg [31:0] write_data;
	
	initial 
	begin
		read_data=32'h0;
		write_data=32'h0;	
	end

	//read part
	always @(*) 
	begin
		case(read_type)
			lw:
				read_data=spo;
			lb://31~24	23~16 15~8 7~0
			begin
				case(byte_offset)
					BYTE_1:
						read_data={{24{spo[7]}},spo[7:0]};
					BYTE_2:
						read_data={{24{spo[15]}},spo[15:8]};
					BYTE_3:
						read_data={{24{spo[23]}},spo[23:16]};
					BYTE_4:
						read_data={{24{spo[31]}},spo[31:24]};
				endcase
			end
			lbu:
			begin
				case(byte_offset)
					BYTE_1:
						read_data={24'h0,spo[7:0]};
					BYTE_2:
						read_data={24'h0,spo[15:8]};
					BYTE_3:
						read_data={24'h0,spo[23:16]};
					BYTE_4:
						read_data={24'h0,spo[31:24]};
				endcase
			end
			lh://31~16 15~0
			begin
				case(half_word_offset)
					LOW_HALF:
						read_data={{16{spo[15]}},spo[15:0]};
					HIGH_HALF:
						read_data={{16{spo[31]}},spo[31:16]};
				endcase
			end
			lhu:
			begin
				case(half_word_offset)
					LOW_HALF:
						read_data={16'h0,spo[15:0]};
					HIGH_HALF:
						read_data={16'h0,spo[31:16]};
				endcase
			end
			default:
				read_data=spo;
		endcase	
	end

	//write part
	always @(*) 
	begin
		if(dm_we)
		begin
			case(write_type)
				sw:
					write_data=dm_din;
				sb:
				//31~24	23~16 15~8 7~0
				begin
					case(byte_offset)
						BYTE_1:
							write_data={spo[31:8],dm_din[7:0]};
						BYTE_2:
							write_data={spo[31:16],dm_din[7:0],spo[7:0]};
						BYTE_3:
							write_data={spo[31:24],dm_din[7:0],spo[23:0]};
						BYTE_4:
							write_data={dm_din[7:0],spo[23:0]};
					endcase
				end
				sh:
				begin
					case(half_word_offset)
						LOW_HALF:
							write_data={spo[31:16],dm_din[15:0]};
						HIGH_HALF:
							write_data={dm_din[15:0],spo[15:0]};
					endcase
				end
				default:
					write_data=dm_din;
			endcase
		end	
		else
			write_data=dm_din;
	end

	//input
	assign a=dm_addr[9:2];
	assign d=write_data;
	assign dpra=mem_check_addr[7:0];
	assign we=dm_we;
	
	//output
	assign dm_dout=read_data;
	assign mem_check_data=dpo;

	DPRAM data_mem (
	.a(a),        // input wire [7 : 0] a
	.d(d),        // input wire [31 : 0] d
	.dpra(dpra),  // input wire [7 : 0] dpra
	.clk(clk),    // input wire clk
	.we(we),      // input wire we
	.spo(spo),    // output wire [31 : 0] spo
	.dpo(dpo)    // output wire [31 : 0] dpo
	);

endmodule