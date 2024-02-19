`timescale 1ns / 1ps
/* 
 *   Author: wintermelon
 *   Last update: 2023.05.03
 */

// This is a simple 4-1 Mux.
/* Ports
    Mux2 #(32) my_mux (
        .src0(),
        .src1(),
        .src2(),
        .src3(),
        .sel(),

        .res()
    );
*/

module Mux2 #(WIDTH = 32) (
    input [WIDTH-1: 0]          src0,
    input [WIDTH-1: 0]          src1,
    input [WIDTH-1: 0]          src2,
    input [WIDTH-1: 0]          src3,
    input [1:0]                 sel,

    output reg [WIDTH-1: 0]     res
);  

    always @(*) begin
        case (sel)
            2'b00: res = src0;
            2'b01: res = src1;
            2'b10: res = src2;
            2'b11: res = src3;
        endcase // We don't need default here
    end

endmodule