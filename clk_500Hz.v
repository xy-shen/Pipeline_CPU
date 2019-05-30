`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/28 21:01:30
// Design Name: 
// Module Name: clk_500Hz
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


module clk_500Hz(
    input clk_100M,
    output reg clk_500
    );
    integer k;
    always @ (posedge clk_100M)
    begin
        if (k < 99999)
            k <= k+1;
        else
        begin
            k <= 0;
            clk_500 <= ~clk_500;
        end
    end
endmodule
