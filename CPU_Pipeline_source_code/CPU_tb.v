`timescale 1ns / 1ps
/* 
 *   Author: wintermelon
 *   Last update: 2023.04.20
 */

// CPU testbench
module CPU_tb();

    reg cpu_clk, cpu_rst;
    wire[31:0] mem_addr, mem_din, mem_dout, im_addr, im_dout, current_pc, next_pc;
    wire mem_we;
	wire [31:0] branch_predict_total,branch_false;
	wire [2:0] read_type;
	wire [1:0] write_type;
    CPU cpu (
        .clk(cpu_clk), 
        .rst(cpu_rst),

        // ================================ Memory and MMIO Part ================================
        // MEM And MMIO Data BUS
        .im_addr(im_addr),
        .im_dout(im_dout),
        .mem_addr(mem_addr),
        .mem_we(mem_we),			
        .mem_din(mem_din),	
        .mem_dout(mem_dout),
		.read_type(read_type),
		.write_type(write_type),

        // ================================ Debug Part ================================
        // Debug BUS with PDU
        .current_pc(current_pc), 	 
        .next_pc(next_pc),   
        .cpu_check_addr('b0),	
        .cpu_check_data(),    // No need to connect
		.branch_predict_total(branch_predict_total),
		.branch_false(branch_false)
    );


    MEM memory (
        .clk(cpu_clk),
        // No reset signals here

        // ================================ Memory Part ================================
        // MEM Data BUS with CPU
        .im_addr(im_addr),
        .im_dout(im_dout),
        .dm_addr(mem_addr),
        .dm_we(mem_we),
        .dm_din(mem_din),
        .dm_dout(mem_dout),
		.read_type(read_type),
		.write_type(write_type),
        
        // ================================ Debug Part ================================
        // MEM Debug BUS
        .mem_check_addr('b0),
        .mem_check_data()   // No need to connect
    );


    // Set the signals

    initial begin
        cpu_clk = 0;
        cpu_rst = 1;

        #20 cpu_rst = 0;
    end

    always #5 cpu_clk <= ~cpu_clk;      // 10ns Clock

endmodule
