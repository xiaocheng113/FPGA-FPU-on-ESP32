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
reg [31:0] A;//��������������������������
reg [31:0] B;//����������������������
reg [1:0] ZT;//������ţ�1�ӣ�2����3�ˣ�4��
wire [31:0] S;//�͡��������
//registers & wire
reg [9:0] count; 
wire [7:0] rcount;//0x00 ~ 0x0f : get the data ; 0x10 ~ 0x1f : output the data to RAM
assign rcount = count[9:2];
//count: ʱ�����ڼ�����, count[1:0] == 2'b00ʱ, ��ַ�ı䣻count[1:0] == 2'b11ʱ���������ݴ洢
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
//addr: RAM��ַ��
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
//mem:  8λ���ݼĴ����飬����0x00 ~ 0x0F ������ͬʱ����FPU����
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
               ZT<=mem[0];//ѡ����㹦�ܣ�1�ӣ�2����3�ˣ�4��
               A<={mem[1],mem[2],mem[3],mem[4]};//�����һ�����ݣ��ĸ��ֽ�32bit��
               B<={mem[5],mem[6],mem[7],mem[8]};//����ڶ������ݣ��ĸ��ֽ�32bit��
               end
          end
        else if ((rcount==18)&&(count[1:0] == 2'b11))
        //mem[9]��������Ϊ�����־�����������������
        begin mem[10]<=S[31:24];//�������ĵ�һ���֣�һ���ֽ�8bit��
              mem[11]<=S[23:16];//�������ĵڶ����֣�һ���ֽ�8bit��
              mem[12]<=S[15:8];//�������ĵ������֣�һ���ֽ�8bit��
              mem[13]<=S[7:0];//�������ĵ��Ĳ��֣�һ���ֽ�8bit��
        end             
end
//data_out: ��mem�н����������
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
//wen: RAMдʹ��
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
//FPU����ģ��
FPU fpu1(
   .clk(clk),
   .ZT(ZT),
   .A(A),
   .B(B),
   .S(S)
   );
endmodule