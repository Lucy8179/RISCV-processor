`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 10:57:41
// Design Name: 
// Module Name: RF
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


module RF(
	input clk,we,
	input [4:0] ra0,ra1,wa,ra_dbg,
	input [31:0] wd,
	output reg [31:0] rd0,rd1,rd_dbg
    );
	reg [31:0] Regfile [0:31];
	
	integer i;
	initial 
	begin
		i = 0;
		while (i < 32) 
		begin
			Regfile[i] = 32'b0;
			i = i + 1;
		end
		Regfile[2] = 32'h2ffc;
		Regfile[3] = 32'h1800;
	end 

	always @(posedge clk)
	begin
		if(we&&(wa!=0))
			Regfile[wa]<=wd;
		else
			Regfile[wa]<=Regfile[wa];
	end

	always @(*)
	begin
		if(we&&(wa!=0))
		begin
			if(wa==ra0)
				rd0=wd;
			else
				rd0=Regfile[ra0];
		end
		else
		begin
			rd0=Regfile[ra0];
		end
	end

	always @(*)
	begin
		if(we&&(wa!=0))
		begin
			if(wa==ra1)
				rd1=wd;
			else
				rd1=Regfile[ra1];
		end
		else
		begin
			rd1=Regfile[ra1];
		end
	end

	always @(*)
	begin
		if(we&&wa!=0)
		begin
			if(wa==ra_dbg)
				rd_dbg=wd;
			else
				rd_dbg=Regfile[ra_dbg];
		end
		else
		begin
			rd_dbg=Regfile[ra_dbg];
		end
	end
endmodule
