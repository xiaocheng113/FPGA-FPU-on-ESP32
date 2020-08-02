`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/31 21:13:34
// Design Name: 
// Module Name: FPU_tb
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


module FPU_tb();
    reg clk;
    reg [31:0]A;
    reg [31:0]B;
    reg [1:0]ZT;
    wire [31:0]S;
    always #5 clk=~clk;
    initial
    begin
        clk=0;
        ZT=2'h04;
        A=32'b01000000010010111000010100011110;
        B=32'b01000000010000111101011100001010;
    end
     
    FPU text(
    .clk(clk),
    .A(A),
    .B(B),
    .ZT(ZT),
    .S(S)
    );    
endmodule
