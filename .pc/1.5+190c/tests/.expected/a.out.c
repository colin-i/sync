/*
multi
line
*/
#include "include.h"
char c1=1;
char c2[]={2,3};
char c3[]="45";
short c5=1;int c6=1;char* c7=1;long* c8=1;
char* c9="";short* ca=1;int* cb=1;
char cc[]={9,97,122};
#define a1 1
char a[3];
long* b=&a;
long*intern(int a,int* b,long* c,long* d){//commenting
	a++;
	a--;
	c++;
	c--;
	c=-(long)c;
	c=~(long)c;
	c=(long)c<<1;
	c=(unsigned long)c>>1;
	c=(long)c>>1;
	return d;
};
struct st{
	int a;
};
void f(){
	long* a=0;
	long* b=0;
	a=&b;
	b=a[0];
	b=((char*)a)[0];
	b=((short*)a)[0];
	b=((int*)a)[0];
	b=((long*)a)[0];
	int c;
	long* d=&c;
	a=((struct st*)d)->a;
	if(2==2){
		return;
	};
};
long*puts();
long*main(){
	b=b;
	b=(long)b+1;
	b=(long)b-1;
	b=(long)b*1;
	c1=(long)c1/1;
	c1=(long)c1/1;
	c1=(long)c1%1;
	c1=(long)c1%1;
	c1=(long)c1&1;
	c1=(long)c1|1;
	b=(long)b^1;
	intern(1,"q\nw\re\tr",a,a);
	b=puts();
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
	char z=0xff+077+12-3+(4*3/2/1&1|1^1%5%5<<3>>3>>3==2!=2<3>3<=4>=4&&7||7<6>6<=6>=6);//char er=3!!2 char er=3!2 char er=3$2
	char z2=a1;char z3=-a1;char z4=~a1;char z5=~-a1;
	__builtin_trap();
	return 2;
};
