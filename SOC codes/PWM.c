/*
#include<reg52.h>
#include<math.h>
#define uint unsigned int
#define uchar unsigned char

sbit en1=P1^0; //L298的Enable A 
sbit en2=P1^1; // L298的Enable B
sbit s1=P1^2; // L298的Input 1   
sbit s2=P1^3; //L298的Input 2   
sbit s3=P1^4; // L298的Input 3   
sbit s4=P1^5; // L298的Input 4   
uchar t=0; //中断计数器   
uchar m1=0; // 电机1速度值   
uchar m2=0; // 电机2速度值   
uchar tmp1,tmp2; //电机当前速度值   

// 电机控制函数 index-电机号(1,2); speed-电机速度(-100—100)
void motor(uchar index, char speed) 
{ 
	if(speed>=-100 && speed<=100) 
	{ 
		if(index==1) //电机1的处理   
		{ 
			m1=abs(speed); //取速度的绝对值   
			if(speed<0) //速度值为负则反转   
			{ 
				s1=0; 
				s2=1; 
			} 
			else //不为负数则正转   
			{ 
				s1=1; 
				s2=0; 
			} 
		} 
		if(index==2) //电机2的处理   
		{ 
			m2=abs(speed); //电机2的速度控制   
			if(speed<0) //电机2的方向控制   
			{ 
				s3=0; 
				s4=1; 
			} 
			else 
			{ 
				s3=1; 
				s4=0; 
			} 
		} 
	} 
} 

void delay(uint j)//1ms延时
{
	uchar x,i;
	for(i=0;i<j;i++)
	for(x=0;x<=148;x++);	
}

void main() 
{ 
	uchar i; 
	TMOD=0x02; //设定T0的工作模式为2   
	TH0=0x9B; //装入定时器的初值   
	TL0=0x9B; 
	EA=1; //开中断   
	ET0=1; //定时器0允许中断   
	TR0=1; //启动定时器0   
	while(1) //电机实际控制演示   
	{ 
		for(i=0;i<=100;i++) //正转加速   
		{ 
			motor(1,i); 
			motor(2,i); 
			delay(5000); 
		} 
		for(i=100;i>0;i--) //正转减速   
		{ 
			motor(1,i); 
			motor(2,i); 
			delay(5000); 
		} 
		for(i=0;i<=100;i++) //反转加速   
		{ 
			motor(1,-i); 
			motor(2,-i); 
			delay(5000); 
		} 
		for(i=100;i>0;i--) //反转减速   
		{ 
			motor(1,-i); 
			motor(2,-i); 
			delay(5000); 
		} 
	} 
} 

void timer0() interrupt 1 //T0中断服务程序   
{ 
	if(t==0) //1个PWM周期完成后才会接受新数值   
	{ 
		tmp1=m1; 
		tmp2=m2; 
	} 
	if(t<tmp1) en1=1; else en1=0; //产生电机1的PWM信号   
	if(t<tmp2) en2=1; else en2=0; //产生电机2的PWM信号   
	t++; 
	if(t>=100) t=0; //1个PWM信号由100次中断产生   
	}
*/
#include<reg51.h> // 头文件
#include<math.h> // 头文件
#define uchar unsigned char 
#define uint unsigned int 
sbit enA=P1^2;   // A相始能端
sbit in1=P1^1;   //
sbit in2=P1^0;   // 输入端
char zkb=-100;   // 设置占空比，范围在（-100~100）占空比的绝对值越大，速度越大
uchar t=0; // 中断计数器
uchar dianji=0; // 电机速度值 
uchar SPACH; // 电机当前速度值  
//***********************************************************************//
//********************** 正反转控制 *************************************//
//***********************************************************************//
void motor(char speed) 
{ 
	if(speed<=100)
		{ 
					dianji=abs(speed);//  取speed的绝对值
					if(speed>0) //  不为负数则正转  
						{ 
							in1=0; 
							in2=1; 
						} 
					if(speed<0)    //  否者反转
						{
							in1=1;
							in2=0;
						}
		} 
} 
//***********************************************************************//
//*********************** 延时函数 **************************************//
//***********************************************************************//
void delay(uint j)
	{ 
		for(j;j>0;j--); 
	} 
//***********************************************************************//
//*********************** 主函数 ****************************************//
//***********************************************************************//
void main() 
	{  
		TMOD=0x02; //设定T0的工作模式为工作方式2  
		TH0=0x9B; //装入定时器的初值
		TL0=0x9B; 
		EA=1; //开中断  
		ET0=1; // 定时器0允许中断  
		TR0=1;  //启动定时器0  
		while(1) 
		{ 
					motor(zkb);   //   
					delay(1000);  //延时
		} 
} 
//***********************************************************************//
//******************* 中断服务子函数 ************************************//
//***********************************************************************//

void timer0() interrupt 1 //T0中断服务程序 
{ 
	if(t==0) //1个PWM周期完成后才会接受新数值 
		{ 
			SPACH=dianji; 
		} 
	if(t<SPACH) enA=1; else if(t>SPACH)enA=0; //产生电机1的PWM信号 
	t++; 
	if(t>=100) t=0; //1个PWM信号由100次中断产生  
}