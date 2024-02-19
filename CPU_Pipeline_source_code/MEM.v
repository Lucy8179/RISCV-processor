module MEM(
    input clk,

    // MEM Data BUS with CPU
	// IM port
    input [31:0] im_addr,
    output [31:0] im_dout,
	
	// DM port
    input  [31:0] dm_addr,
    input dm_we,
    input  [31:0] dm_din,
    output [31:0] dm_dout,

	input [2:0] read_type,
	input [1:0] write_type,

    // MEM Debug BUS
    input [31:0] mem_check_addr,
    output [31:0] mem_check_data
);
   
   // TODO: Your IP here.
   // Remember that we need [9:2]?

ROM inst_mem (
  .a(im_addr[10:2]),      // input wire [7 : 0] a
  .spo(im_dout)  // output wire [31 : 0] spo
);


Data_Mem data_mem(
	.clk(clk),
	.dm_addr(dm_addr),
	.dm_we(dm_we),
	.read_type(read_type),
	.write_type(write_type),
	.dm_din(dm_din),
	.dm_dout(dm_dout),
	.mem_check_addr(mem_check_addr),
	.mem_check_data(mem_check_data)
);

endmodule