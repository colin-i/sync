long*intern(int,int*,long*,unsigned long*);
void f(int*,...);
long*printf(long,long);
long*sprintf(long,long,...);
long*main(int*,...);
/*
multi
line
*/
#include "stddef.h"
#include "the_setjmp.h"
static unsigned char c1=1;
static signed char c2[]={2,3};
static unsigned char c3[]=R"(01
23)";
static short c5=1;static unsigned int c6=1;static signed char* c7=1;static long c8=1;
static unsigned char* c9="";static short* ca=1;static int* cb=1;
static unsigned char cc[]={97,122};
//constu a1=1
#define a1 1
#ifndef a1
#define a1 2
#endif//ok
static unsigned char a[3];static long b=a;
static unsigned char no_hotgroup=1;static long no_hotgroup_test=&no_hotgroup;
long*     intern(int a,int* b,long* c,unsigned long* d){//commenting
	int recursion;
	unsigned long* pointing=intern;
	a++;
	a--;
	c++;
	c--;
	c=-(long)c;
	recursion=~(long)recursion;
	if(setjmp(the_jmp_buf))return -1;
	longjmp(the_jmp_buf,1);
	c=(long)c<<1;
	c=(unsigned long)c>>1;
	c=(long)c>>1;
	return d;
};
struct st{
	int b;
	int a;
};
void      f(int* dummy,...){//void f(...) was working with gcc13 but with 5 still is: ISO C requires a named argument before '...'
	long* a;
	long b=sizeof(c2);
	a=(long)&b;
	b=(long)a[0];
	b=(long)((char*)a)[0];
	b=(long)((short*)a)[0];
	b=(long)((int*)a)[0];
	b=(long)((long*)a)[0];
	int c;
	long d=c;
	a=(long)((struct st*)d)->a;
	if(2==2){
		return;
	};
};
long*     main(int* argc,...){
	signed char* sigextstr=-1;sigextstr=(long)-2;
	b=(long)b;
	b=(long)b+(long)sizeof(struct st);
	b=(long)b-(long)sizeof(struct st);
	b=(long)b*(long)sizeof(((struct st*)0)->a);
	b=(long)b*(long)sizeof(((struct st*)0)->a);
	c1=(long)c1/(long)offsetof(struct st,a);
	c1=(unsigned long)c1/(long)sizeof(struct st);
	c1=(long)c1%(long)1;
	c1=(unsigned long)c1%(long)1;
	c1=(long)c1&(long)1;
	c1=(long)c1|(long)1;
	b=(long)b^(long)1;
	intern(1,"0\n1\r2\t3\0004\\5\"6x3g07",a,a);
	b=(long)printf(b,b);
	if(1==1){
		//elseif 1!!1
		//elseif 1!1
	};
	if(1!=1){
	}else if(1<1){
	}else{};
	if(1>1){};
	if(1<=1){};
	if(1>=1){};
	if((unsigned long)1<(unsigned long)1){};
	if((unsigned long)1>(unsigned long)1){};
	if((unsigned long)1<=(unsigned long)1){};
	if((unsigned long)1>=(unsigned long)1){};
	while(1==2){
		continue;
	};
	while(1){
		break;
	};
	unsigned char z=0xff+077+12-3+(4*3/2/1&1|1^1%5%5<<3>>3>>3==2!=2<3>3<=4>=4&&7||7<6>6<=6>=6);//char er=3!!2 char er=3!2 char er=3$2
	unsigned char z2=a1;unsigned char z3=-a1;unsigned char z4=~a1;unsigned char z5=~-a1;
	unsigned char q1=sizeof(long);unsigned char q2=sizeof(struct st);unsigned char q3=offsetof(struct st,a);unsigned char q4=sizeof(((struct st*)0)->a);
	__builtin_trap();
	return 2;
	if(setjmp(the_jmp_buf))return -1;
	return main(0);
};
