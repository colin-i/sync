/*
multi
line
*/
//not blank for deb pack. char *="1\03" is not working (src->binary is creating fuzz at deb)
char c1=1;
char c2[]={2,3};
char c3[]="45";
char a[3];
int b;
long intern(int a,int b,int c){//commenting
c;
}
long puts();
void main(){
b=b;
b+=b;
b-=b;
b*=b;
b/=b;
b/=b;
b%=b;
b%=b;
b&=b;
b|=b;
b^=b;;intern(1,"q\nw\re\tr",a);
b=puts();
if(11){}
while(12){}
{
}
__builtin_trap();
}
