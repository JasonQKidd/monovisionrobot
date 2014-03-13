#include<reg51.h> // ͷ�ļ�
#include<math.h>
#define uchar unsigned char 
#define uint unsigned int 
sbit enA=P1^4;   // A��ʼ�ܶ�
sbit enB=P1^5;
sbit inL1=P1^0;   //
sbit inL2=P1^1;   // �����
sbit inR1=P1^2;
sbit inR2=P1^3;
char zkb=-100;   // ����ռ�ձȣ���Χ�ڣ�-100~100��ռ�ձȵľ���ֵԽ���ٶ�Խ��
uchar t1=0,t2=0; // �жϼ�����
uchar dianjiL=0; // ����ٶ�ֵ
uchar dianjiR=0; 
uchar SPACHL; // �����ǰ�ٶ�ֵ  
uchar SPACHR;
uchar d[4];

void timer0() interrupt 1 //T0�жϷ������ 
{ 
	if(t1==0) //1��PWM������ɺ�Ż��������ֵ 
		{ 
			SPACHL=dianjiL; 
		} 
	if(t1<SPACHL) enA=1; else if(t1>SPACHL)enA=0; //�������1��PWM�ź� 
	t1++; 
	if(t1>=100) t1=0; //1��PWM�ź���100���жϲ���  
	
	if(t2==0) //1��PWM������ɺ�Ż��������ֵ 
		{ 
			SPACHR=dianjiR; 
		} 
	if(t2<SPACHR) enB=1; else if(t2>SPACHR)enB=0; //�������1��PWM�ź� 
	t2++; 
	if(t2>=100) t2=0; //1��PWM�ź���100���жϲ���  	
}

void motor(char speedL,speedR) 
{ 
	if(speedL<=100)
	{ 
		dianjiL=abs(speedL);//  ȡspeed�ľ���ֵ
		if(speedL>0) //  ��Ϊ��������ת  
		{ 
			inL1=0; 
			inL2=1; 
		} 
	if(speedL<0)    //  ���߷�ת
	{
		inL1=1;
		inL2=0;
		}
	} 
	if(speedR<=100)
	{ 
		dianjiR=abs(speedR);//  ȡspeed�ľ���ֵ
		if(speedR>0) //  ��Ϊ��������ת  
		{ 
			inR1=0; 
			inR2=1; 
		} 
	if(speedR<0)    //  ���߷�ת
	{
		inR1=1;
		inR2=0;
		}
	} 	
}


void delay(unsigned char t)//��ʱʾ����
{
	unsigned char j,k;
	for(t=15;t>0;t--)
	for(j=202;j>0;j--)
	for(k=81;k>0;k--);
}

void Com_Int(void) interrupt 4//���ڽ����ն�
{
	static uchar i =0 ;    //����Ϊ��̬�����������½�������Ӻ���ʱ i ��ֵ���ᷢ���ı�
	EA = 0;
	if(RI == 1)
	{
		RI = 0;
		if(SBUF==0xFF)
		{
			i=3;
		}
		else if(i>0)  //��Ӳ�����յ�һ������ʱ��RI����λ
		{
			i--;
			d[i] = SBUF; 
			//P0=d[i]; 
			//delay(10);
		}
		//P0 = SBUF;
		//delay(10);
	}
	EA = 1;
}

void Com_Init(void)
{
     TMOD = 0x20;
     PCON = 0x00;
     SCON = 0x50;			
     TH1 = 0xFd;    //���ò����� 9600
     TL1 = 0xFd;
     TR1 = 1;		//������ʱ��1
	 ES = 1;		//�������ж�
	 EA = 1;		//�����ж�		
}

void main() 
{  
	TMOD=0x02; //�趨T0�Ĺ���ģʽΪ������ʽ2  
	TH0=0x9B; //װ�붨ʱ���ĳ�ֵ
	TL0=0x9B; 
	EA=1; //���ж�  
	ET0=1; // ��ʱ��0�����ж�  
	TR0=1;  //������ʱ��0  
	Com_Init();
	while(1) 
{ 
		if (d[1]>=50)
		{
		motor (20,20);
		delay (300);
		//P0=0x80;
		}
		else if (d[0]>=50)
		{	
			motor(15,40);
			delay (5000);
		//	P0=0x40;
		}
		else if(d[2]>=50)
			{
			motor (40,15);
			delay(5000);
		//	P0=0x20;
			}
		else{ motor(-20,20);
			delay (5000); 
		//	P0=0x10; 
			}
	} 
}