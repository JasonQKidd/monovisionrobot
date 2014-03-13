#include<reg51.h> // 头文件
#include<math.h>
#define uchar unsigned char 
#define uint unsigned int 
sbit enA=P1^4;   // A相始能端
sbit enB=P1^5;
sbit inL1=P1^0;   //
sbit inL2=P1^1;   // 输入端
sbit inR1=P1^2;
sbit inR2=P1^3;
char zkb=-100;   // 设置占空比，范围在（-100~100）占空比的绝对值越大，速度越大
uchar t1=0,t2=0; // 中断计数器
uchar dianjiL=0; // 电机速度值
uchar dianjiR=0; 
uchar SPACHL; // 电机当前速度值  
uchar SPACHR;
uchar d[4];

void timer0() interrupt 1 //T0中断服务程序 
{ 
	if(t1==0) //1个PWM周期完成后才会接受新数值 
		{ 
			SPACHL=dianjiL; 
		} 
	if(t1<SPACHL) enA=1; else if(t1>SPACHL)enA=0; //产生电机1的PWM信号 
	t1++; 
	if(t1>=100) t1=0; //1个PWM信号由100次中断产生  
	
	if(t2==0) //1个PWM周期完成后才会接受新数值 
		{ 
			SPACHR=dianjiR; 
		} 
	if(t2<SPACHR) enB=1; else if(t2>SPACHR)enB=0; //产生电机1的PWM信号 
	t2++; 
	if(t2>=100) t2=0; //1个PWM信号由100次中断产生  	
}

void motor(char speedL,speedR) 
{ 
	if(speedL<=100)
	{ 
		dianjiL=abs(speedL);//  取speed的绝对值
		if(speedL>0) //  不为负数则正转  
		{ 
			inL1=0; 
			inL2=1; 
		} 
	if(speedL<0)    //  否者反转
	{
		inL1=1;
		inL2=0;
		}
	} 
	if(speedR<=100)
	{ 
		dianjiR=abs(speedR);//  取speed的绝对值
		if(speedR>0) //  不为负数则正转  
		{ 
			inR1=0; 
			inR2=1; 
		} 
	if(speedR<0)    //  否者反转
	{
		inR1=1;
		inR2=0;
		}
	} 	
}


void delay(unsigned char t)//延时示程序
{
	unsigned char j,k;
	for(t=15;t>0;t--)
	for(j=202;j>0;j--)
	for(k=81;k>0;k--);
}

void Com_Int(void) interrupt 4//串口接收终端
{
	static uchar i =0 ;    //定义为静态变量，当重新进入这个子函数时 i 的值不会发生改变
	EA = 0;
	if(RI == 1)
	{
		RI = 0;
		if(SBUF==0xFF)
		{
			i=3;
		}
		else if(i>0)  //当硬件接收到一个数据时，RI会置位
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
     TH1 = 0xFd;    //设置波特率 9600
     TL1 = 0xFd;
     TR1 = 1;		//启动定时器1
	 ES = 1;		//开串口中断
	 EA = 1;		//开总中断		
}

void main() 
{  
	TMOD=0x02; //设定T0的工作模式为工作方式2  
	TH0=0x9B; //装入定时器的初值
	TL0=0x9B; 
	EA=1; //开中断  
	ET0=1; // 定时器0允许中断  
	TR0=1;  //启动定时器0  
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