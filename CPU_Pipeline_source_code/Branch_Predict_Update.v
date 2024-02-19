`timescale 1ns / 1ps
module Branch_Predict_Update (
	input jal_ex,
	input [2:0] br_type_ex,
	output reg update_en
);

	parameter NO_BR=3'd0;
	parameter YES=1'b1;
	parameter NO=1'b0;

	always @(*) 
	begin
		if(jal_ex)
			update_en=YES;
		else if(br_type_ex!=NO_BR)
			update_en=YES;
		else
			update_en=NO;	
	end
endmodule