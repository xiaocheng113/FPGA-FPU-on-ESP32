`timescale 1ns / 1ps
module FPU(clk,A,B,S,ZT);
input clk;//时钟
input [31:0]A;//加数、被减数、乘数、被除数
input [31:0]B;//加数、减数、乘数、除数
input [1:0]ZT;//运算符号，1加，2减，3乘，4除
output [31:0]S;//和、差、积、商

reg [31:0]S;//结果
reg signA;//A的符号位
reg signB;//B的符号位
reg signS;//S的符号位
reg [7:0]expA;//A的指数位
reg [7:0]expB;//B的指数位
reg [7:0]expS;//S的指数位
reg [23:0]manA;//A的尾数位
reg [23:0]manB;//B的尾数位
reg [24:0]manS;//S的尾数位		//manS[24:0]取25位是为了防止溢出
reg [7:0]count=0;//阶差
reg [47:0]temp;//乘法缓存区
reg [24:0]DmanA;//将尾数增加1位，是为了方便类似0.5/2.5（小数/大数）运算
reg [24:0]DmanB;//同上
reg [23:0]yshang=0;//除法得出的商
reg [24:0]yyushu;//除法得出的余数
integer i;

always@(posedge clk)
begin
case(ZT)
2'h01:	
//加法器
begin
	signA=A[31];
	signB=B[31];
	expA=A[30:23];
	expB=B[30:23];
	manA={1'b1,A[22:0]};
	manB={1'b1,B[22:0]};
		
	if(expA==expB)begin//对阶
		count=8'b0;
		expS=expA;end
	else if(expA>expB)
		begin
			count=expA-expB;
			manB[23:0]=manB[23:0]>>count;
			expS=expA;
		end
	else
		begin
			count=expB-expA;
			manA=manA>>count;
			expS=expB;
		end
	
	if(signA^signB)//尾数相加，注意正负数相加的4种情况
	begin
		if(manA>=manB)begin
			manS=manA-manB;
			signS=signA;end
		else begin
			manS=manB-manA;
			signS=signB;end
	end
	else begin
		manS=manA+manB;
		signS=signA;
		end
		
		if(manS[24])begin//判断溢出，若溢出则指数+1
			expS=expS+1;
			S={signS,expS[7:0],manS[23:1]};end
		
		else begin
	if(manS[23])begin//尾规格化数
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[22])begin
			expS=expS-1;
			manS=manS<<1;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[21])begin
			expS=expS-2;
			manS=manS<<2;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[20])begin
			expS=expS-3;
			manS=manS<<3;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[19])begin
			expS=expS-4;
			manS=manS<<4;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[18])begin
			expS=expS-5;
			manS=manS<<5;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[17])begin
			expS=expS-6;
			manS=manS<<6;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[16])begin
			expS=expS-7;
			manS=manS<<7;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[15])begin
			expS=expS-8;
			manS=manS<<8;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[14])begin
			expS=expS-9;
			manS=manS<<9;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[13])begin
			expS=expS-10;
			manS=manS<<10;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[12])begin
			expS=expS-11;
			manS=manS<<11;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[11])begin
			expS=expS-12;
			manS=manS<<12;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[10])begin
			expS=expS-13;
			manS=manS<<13;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[9])begin
			expS=expS-14;
			manS=manS<<14;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[8])begin
			expS=expS-15;
			manS=manS<<15;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[7])begin
			expS=expS-16;
			manS=manS<<16;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[6])begin
			expS=expS-17;
			manS=manS<<17;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[5])begin
			expS=expS-18;
			manS=manS<<18;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[4])begin
			expS=expS-19;
			manS=manS<<19;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[3])begin
			expS=expS-20;
			manS=manS<<20;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[2])begin
			expS=expS-21;
			manS=manS<<21;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[1])begin
			expS=expS-22;
			manS=manS<<22;
			S={signS,expS[7:0],manS[22:0]};end
	else begin
			expS=expS-23;
			manS=manS<<23;
			S={signS,expS[7:0],manS[22:0]};end
	end		
end

2'h02:	
//减法器
begin
	signA=A[31];
	signB=B[31];
	expA=A[30:23];
	expB=B[30:23];
	manA={1'b1,A[22:0]};
	manB={1'b1,B[22:0]};
		
	if(expA==expB)begin//对阶
		count=8'b0;
		expS=expA;end
	else if(expA>expB)
		begin
			count=expA-expB;
			manB[23:0]=manB[23:0]>>count;
			expS=expA;
		end
	else
		begin
			count=expB-expA;
			manA=manA>>count;
			expS=expB;
		end
	
	if(signA^signB)//尾数相减，注意正负数相减的4种情况
	begin
			manS=manA+manB;
			signS=signA;
	end
	else begin
		if(manA>=manB)begin
			manS=manA-manB;
			signS=signA;end
		else begin
			manS=manB-manA;
			signS=~signA;end
		end
		
		
		if(manS[24])begin//判断溢出，若溢出则指数+1
			expS=expS+1;
			S={signS,expS[7:0],manS[23:1]};end		
		else begin
	if(manS[23])begin//尾规格化数
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[22])begin
			expS=expS-1;
			manS=manS<<1;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[21])begin
			expS=expS-2;
			manS=manS<<2;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[20])begin
			expS=expS-3;
			manS=manS<<3;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[19])begin
			expS=expS-4;
			manS=manS<<4;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[18])begin
			expS=expS-5;
			manS=manS<<5;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[17])begin
			expS=expS-6;
			manS=manS<<6;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[16])begin
			expS=expS-7;
			manS=manS<<7;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[15])begin
			expS=expS-8;
			manS=manS<<8;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[14])begin
			expS=expS-9;
			manS=manS<<9;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[13])begin
			expS=expS-10;
			manS=manS<<10;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[12])begin
			expS=expS-11;
			manS=manS<<11;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[11])begin
			expS=expS-12;
			manS=manS<<12;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[10])begin
			expS=expS-13;
			manS=manS<<13;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[9])begin
			expS=expS-14;
			manS=manS<<14;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[8])begin
			expS=expS-15;
			manS=manS<<15;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[7])begin
			expS=expS-16;
			manS=manS<<16;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[6])begin
			expS=expS-17;
			manS=manS<<17;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[5])begin
			expS=expS-18;
			manS=manS<<18;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[4])begin
			expS=expS-19;
			manS=manS<<19;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[3])begin
			expS=expS-20;
			manS=manS<<20;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[2])begin
			expS=expS-21;
			manS=manS<<21;
			S={signS,expS[7:0],manS[22:0]};end
	else if(manS[1])begin
			expS=expS-22;
			manS=manS<<22;
			S={signS,expS[7:0],manS[22:0]};end
	else begin
			expS=expS-23;
			manS=manS<<23;
			S={signS,expS[7:0],manS[22:0]};end
	end		
end
2'h03:	
//乘法器
begin
	signA=A[31];
	signB=B[31];
	expA=A[30:23];
	expB=B[30:23];
	manA={1'b1,A[22:0]};
	manB={1'b1,B[22:0]};
	signS=signA^signB;
	expS=expA+expB-127;
	temp=manA*manB;
	if(temp[47])begin
		expS=expS+1;
		temp=temp>>1;end
	S={signS,expS[7:0],temp[45:23]};
end
2'h04:	
//除法器
/*对于阶码为0或255的情况，IEEE754标准有特别的规定：
如果 E 是0 并且 M 是0，则这个数的真值为±0（正负号和数符位有关
如果 E = 255 并且 M 是0，则这个数的真值为±∞（同样和符号位有关
如果 E = 255 并且 M 不是0，则这不是一个数（NaN）。

除法运算的方法是：if(余数>=除数),商左移1位，并加1（即商1）；if(余数<除数)，商左移1位,（即商0）?
循环进行24次是为了得到足够的精度，若可以除尽，很早就是全0的结果?
若除不尽则可以得到足够精度；最后的移位是为了把类似0.5/2.5（小数/大数）的结果规格化
*/
begin
	if(A==0)//若被除数为0，则结果为0，除数为0的情况在进行除法运算前就要进行判断，即判断在除法器外面进行
		S=32'b0;
	else begin
	signA=A[31];
	signB=B[31];
	expA=A[30:23];
	expB=B[30:23];
	DmanA={2'b01,A[22:0]};
	DmanB={2'b01,B[22:0]};
	yshang=0;	
	expS=expA-expB+8'b01111111;
	signS=signA^signB;
	yyushu=DmanA;
	for(i = 0;i < 24;i = i + 1)
        begin
          if(yyushu>=DmanB)begin
				yshang[23:0]=yshang[23:0]<<1;
				yshang[23:0]=yshang[23:0]+24'h000001;
				yyushu=yyushu-DmanB;end
			else begin
				yshang[23:0]=yshang[23:0]<<1;
				end
			yyushu=yyushu<<1;
        end
	if(yshang[23])begin
		S={signS,expS[7:0],yshang[22:0]};
		end
	else if(yshang[22]) begin
		yshang=yshang<<1;
		expS=expS-1;
		S={signS,expS[7:0],yshang[22:0]};end
	else if(yshang[21]) begin
		yshang=yshang<<2;
		expS=expS-2;
		S={signS,expS[7:0],yshang[22:0]};end	
	else if(yshang[20]) begin
		yshang=yshang<<3;
		expS=expS-3;
		S={signS,expS[7:0],yshang[22:0]};end
	else if(yshang[19]) begin
		yshang=yshang<<4;
		expS=expS-4;
		S={signS,expS[7:0],yshang[22:0]};end	
	else if(yshang[18]) begin
		yshang=yshang<<5;
		expS=expS-5;
		S={signS,expS[7:0],yshang[22:0]};end
	else if(yshang[17]) begin
		yshang=yshang<<6;
		expS=expS-6;
		S={signS,expS[7:0],yshang[22:0]};end	
	else if(yshang[16]) begin
		yshang=yshang<<7;
		expS=expS-7;
		S={signS,expS[7:0],yshang[22:0]};end
	else if(yshang[15]) begin
		yshang=yshang<<8;
		expS=expS-8;
		S={signS,expS[7:0],yshang[22:0]};end	
	else if(yshang[14]) begin
		yshang=yshang<<9;
		expS=expS-9;
		S={signS,expS[7:0],yshang[22:0]};end
	else if(yshang[13]) begin
		yshang=yshang<<10;
		expS=expS-10;
		S={signS,expS[7:0],yshang[22:0]};end	
	else if(yshang[12]) begin
		yshang=yshang<<11;
		expS=expS-11;
		S={signS,expS[7:0],yshang[22:0]};end
	else if(yshang[11]) begin
		yshang=yshang<<12;
		expS=expS-12;
		S={signS,expS[7:0],yshang[22:0]};end	
	else if(yshang[10]) begin
		yshang=yshang<<13;
		expS=expS-13;
		S={signS,expS[7:0],yshang[22:0]};end
	else if(yshang[9]) begin
		yshang=yshang<<14;
		expS=expS-14;
		S={signS,expS[7:0],yshang[22:0]};end	
	else if(yshang[8]) begin
		yshang=yshang<<15;
		expS=expS-15;
		S={signS,expS[7:0],yshang[22:0]};end
	else if(yshang[7]) begin
		yshang=yshang<<16;
		expS=expS-16;
		S={signS,expS[7:0],yshang[22:0]};end	
	else if(yshang[6]) begin
		yshang=yshang<<17;
		expS=expS-17;
		S={signS,expS[7:0],yshang[22:0]};end
	else if(yshang[5]) begin
		yshang=yshang<<18;
		expS=expS-18;
		S={signS,expS[7:0],yshang[22:0]};end	
	else if(yshang[4]) begin
		yshang=yshang<<19;
		expS=expS-19;
		S={signS,expS[7:0],yshang[22:0]};end
	else if(yshang[3]) begin
		yshang=yshang<<20;
		expS=expS-20;
		S={signS,expS[7:0],yshang[22:0]};end	
	else if(yshang[2]) begin
		yshang=yshang<<21;
		expS=expS-21;
		S={signS,expS[7:0],yshang[22:0]};end
	else if(yshang[1]) begin
		yshang=yshang<<22;
		expS=expS-21;
		S={signS,expS[7:0],yshang[22:0]};end	
	else begin
		yshang=yshang<<23;
		expS=expS-23;
		S={signS,expS[7:0],yshang[22:0]};end	
  	end
end
default:
//乘法器
begin
	signA=A[31];
	signB=B[31];
	expA=A[30:23];
	expB=B[30:23];
	manA={1'b1,A[22:0]};
	manB={1'b1,B[22:0]};
	signS=signA^signB;
	expS=expA+expB-127;
	temp=manA*manB;
	if(temp[47])begin
		expS=expS+1;
		temp=temp>>1;end
	S={signS,expS[7:0],temp[45:23]};
end		
endcase
end
endmodule
