`timescale 1ns / 1ps

module qspi_adder#(
parameter addr_width = 8
)(
input clk,
input rst_n,
//RAM 
output reg [addr_width-1:0] addr,
input [7:0]data_in,
output reg [7:0] data_out,
output reg wen
);

//FPU
reg [31:0] A;//加数、被减数、乘数、被除数
reg [31:0] B;//加数、减数、乘数、除数
reg [1:0] ZT;//运算符号，1加，2减，3乘，4除
wire [31:0] S;//和、差、积、商
//registers & wire
reg [9:0] count; 
wire [7:0] rcount;//0x00 ~ 0x0f : get the data ; 0x10 ~ 0x1f : output the data to RAM
assign rcount = count[9:2];
//count: 时钟周期计数器, count[1:0] == 2'b00时, 地址改变；count[1:0] == 2'b11时，进行数据存储
always @(posedge clk,negedge rst_n)
begin
    if (!rst_n)
        count <= 0;
    else
        if (rcount < 32)
            count <= count + 1;
        else
            count <= 0;
end
//addr: RAM地址端
always @(posedge clk,negedge rst_n)
begin
    if (!rst_n)
        addr <= 0;
    else
        if (rcount < 32)
            addr <= rcount;
        else
            addr <= 0;
end
//mem:  8位数据寄存器组，储存0x00 ~ 0x0F 的数据同时进行FPU操作
reg [7:0] mem [0:15];
integer i;
always @(posedge clk,negedge rst_n)
begin
    if (!rst_n)
    begin
        for (i=0;i<15;i=i+1)
            mem[i] <= 0;
    end
    else
        if ((rcount < 16)&&(count[1:0] == 2'b11))
          begin 
               mem[rcount]<=data_in;
               if(rcount==11)
               begin
               ZT<=mem[0];//选择计算功能：1加，2减，3乘，4除
               A<={mem[1],mem[2],mem[3],mem[4]};//输入第一个数据（四个字节32bit）
               B<={mem[5],mem[6],mem[7],mem[8]};//输入第二个数据（四个字节32bit）
               end
          end
        else if ((rcount==18)&&(count[1:0] == 2'b11))
        //mem[9]保持零作为间隔标志，隔开输出和输出结果
        begin mem[10]<=S[31:24];//输出结果的第一部分（一个字节8bit）
              mem[11]<=S[23:16];//输出结果的第二部分（一个字节8bit）
              mem[12]<=S[15:8];//输出结果的第三部分（一个字节8bit）
              mem[13]<=S[7:0];//输出结果的第四部分（一个字节8bit）
        end             
end
//data_out: 从mem中进行数据输出
always @(posedge clk,negedge rst_n)
begin
    if (!rst_n)
        data_out <= 0;
    else
        if (rcount < 32)
            data_out <= mem[rcount-16];
        else
            data_out <= 0;
end
//wen: RAM写使能
always @(posedge clk,negedge rst_n)
begin
    if (!rst_n)
    begin
        wen <= 0;
    end
    else
        if ((rcount >= 16)&&(rcount < 32))
            wen <= 1;
        else
            wen <= 0;
end
//FPU交互模块
FPU fpu1(
   .clk(clk),
   .ZT(ZT),
   .A(A),
   .B(B),
   .S(S)
   );
endmodule