`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 17:23:21
// Design Name: 
// Module Name: flipflop
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


module flipflop #(parameter WIDTH = 1)(
    input clk,rst,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
    );
    always @ (posedge clk)
    begin
        if (rst)
            out <= {WIDTH{1'b0}};
        else
            out <= in;
    end
endmodule
