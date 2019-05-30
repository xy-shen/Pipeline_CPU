`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/24 09:08:43
// Design Name: 
// Module Name: DDUsegdisplay
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


module DDUsegdisplay(
    input clk_500,
    input [31:0] ddudata,
    output [7:0] an,
    output [6:0] seg
    );
    wire [3:0] dt [0:7];
    wire [3:0] m;
    reg [2:0] cnt;
    
    assign an[0] = ~(cnt==0);
    assign an[1] = ~(cnt==1);
    assign an[2] = ~(cnt==2);
    assign an[3] = ~(cnt==3);
    assign an[4] = ~(cnt==4);
    assign an[5] = ~(cnt==5);
    assign an[6] = ~(cnt==6);
    assign an[7] = ~(cnt==7);
    assign dt[0] = ddudata%10;
    assign dt[1] = (ddudata/10) % 10;
    assign dt[2] = (ddudata/100) % 10;
    assign dt[3] = (ddudata/1000) % 10;
    assign dt[4] = (ddudata/10000) % 10;
    assign dt[5] = (ddudata/100000) % 10;
    assign dt[6] = (ddudata/1000000) % 10;
    assign dt[7] = (ddudata/10000000) % 10;
    assign m = dt[cnt];
    
    always @ (posedge clk_500)
    begin
        cnt <= cnt+1;
    end

    assign seg[0] = (~m[3] & ~m[2] & ~m[1] & m[0])|(~m[3] & m[2] & ~m[1] & ~m[0]);
    assign seg[1] = (~m[3] & m[2] & ~m[1] & m[0])|(~m[3] & m[2] & m[1] & ~m[0]);
    assign seg[2] = (~m[3] & ~m[2] & m[1] & ~m[0]);
    assign seg[3] = (~m[3] & ~m[2] & ~m[1] & m[0])|(~m[3] & m[2] & ~m[1] & ~m[0])|(~m[3] & m[2] & m[1] & m[0]);
    assign seg[4] = (m[0]|(~m[3] & m[2] & ~m[1]));
    assign seg[5] = (~m[3] & ~m[2] & m[0])|(~m[3] & ~m[2] & m[1]) | (~m[3] & m[1] & m[0]);
    assign seg[6] = (~m[3] & ~m[2] & ~m[1])|(~m[3] & m[2] & m[1] & m[0]);
endmodule