`timescale 1ns / 1ps
module FPU(clk,A,B,S,ZT);
input clk;//ʱ��
input [31:0]A;//��������������������������
input [31:0]B;//����������������������
input [1:0]ZT;//������ţ�1�ӣ�2����3�ˣ�4��
output [31:0]S;//�͡��������

reg [31:0]S;//���
reg signA;//A�ķ���λ
reg signB;//B�ķ���λ
reg signS;//S�ķ���λ
reg [7:0]expA;//A��ָ��λ
reg [7:0]expB;//B��ָ��λ
reg [7:0]expS;//S��ָ��λ
reg [23:0]manA;//A��β��λ
reg [23:0]manB;//B��β��λ
reg [24:0]manS;//S��β��λ		//manS[24:0]ȡ25λ��Ϊ�˷�ֹ���
reg [7:0]count=0;//�ײ�
reg [47:0]temp;//�˷�������
reg [24:0]DmanA;//��β������1λ����Ϊ�˷�������0.5/2.5��С��/����������
reg [24:0]DmanB;//ͬ��
reg [23:0]yshang=0;//�����ó�����
reg [24:0]yyushu;//�����ó�������
integer i;

always@(posedge clk)
begin
case(ZT)
2'h01:	
//�ӷ���
begin
	signA=A[31];
	signB=B[31];
	expA=A[30:23];
	expB=B[30:23];
	manA={1'b1,A[22:0]};
	manB={1'b1,B[22:0]};
		
	if(expA==expB)begin//�Խ�
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
	
	if(signA^signB)//β����ӣ�ע����������ӵ�4�����
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
		
		if(manS[24])begin//�ж�������������ָ��+1
			expS=expS+1;
			S={signS,expS[7:0],manS[23:1]};end
		
		else begin
	if(manS[23])begin//β�����
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
//������
begin
	signA=A[31];
	signB=B[31];
	expA=A[30:23];
	expB=B[30:23];
	manA={1'b1,A[22:0]};
	manB={1'b1,B[22:0]};
		
	if(expA==expB)begin//�Խ�
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
	
	if(signA^signB)//β�������ע�������������4�����
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
		
		
		if(manS[24])begin//�ж�������������ָ��+1
			expS=expS+1;
			S={signS,expS[7:0],manS[23:1]};end		
		else begin
	if(manS[23])begin//β�����
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
//�˷���
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
//������
/*���ڽ���Ϊ0��255�������IEEE754��׼���ر�Ĺ涨��
��� E ��0 ���� M ��0�������������ֵΪ��0�������ź�����λ�й�
��� E = 255 ���� M ��0�������������ֵΪ���ޣ�ͬ���ͷ���λ�й�
��� E = 255 ���� M ����0�����ⲻ��һ������NaN����

��������ķ����ǣ�if(����>=����),������1λ������1������1����if(����<����)��������1λ,������0��?
ѭ������24����Ϊ�˵õ��㹻�ľ��ȣ������Գ������������ȫ0�Ľ��?
������������Եõ��㹻���ȣ�������λ��Ϊ�˰�����0.5/2.5��С��/�������Ľ�����
*/
begin
	if(A==0)//��������Ϊ0������Ϊ0������Ϊ0������ڽ��г�������ǰ��Ҫ�����жϣ����ж��ڳ������������
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
//�˷���
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
