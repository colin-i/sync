#include "top.h"

#ifdef HAVE_CURSES_H
#include<curses.h>
#else
#include"inc/bar/curses.h"
#endif
#ifdef HAVE_DIRENT_H
#include<dirent.h>
#else
#include"inc/bar/dirent.h"
#endif
#ifdef HAVE_ERRNO_H
#include<errno.h>
#else
#include"inc/bar/errno.h"
#endif
#ifdef HAVE_FCNTL_H
#include<fcntl.h>
#else
#include"inc/bar/fcntl.h"
#endif
#ifdef HAVE_STDLIB_H
#include<stdlib.h>
#else
#include"inc/bar/stdlib.h"
#endif
#ifdef HAVE_STDIO_H
#include<stdio.h>
#else
#include"inc/stdio.h"
#endif
#ifdef HAVE_STRING_H
#include<string.h>
#else
#include"inc/bar/string.h"
#endif
#ifdef HAVE_UNISTD_H
#include<unistd.h>
#else
#include"inc/unistd.h"
#endif

#include"base.h"

#ifdef PLATFORM64
#define protocol "%lu"
#else
#define protocol "%u"
#endif

#define err_len_min 2

bool issensitive=true;

static int err_l=0;
static char*err_s;
#define b_inf_s "F1 for help"
#define quest_ex_s "? y/C/n"
static int com_left=sizeof(b_inf_s);
static char input1[max_path_0];
static char input2[max_path_0];
static char*input0=input1;
static WINDOW*poswn;
static char inputr[max_path_0];
static size_t cursorr=0;
#define get_right getbegx(poswn)-1
static char inputf[max_path_0];
static int cursorf=0;

static int number2;//number is also negative
static int number3;
static int fprevnumber;

typedef struct{
size_t yb;
size_t xb;
size_t ye;
size_t xe;
char*data;}eundo;
static eundo*undos=nullptr;
static size_t undos_tot=0;
static size_t undos_spc=0;
static size_t undos_save=0;
static size_t undos_max=0;
static int undo_v=0;
static bool new_f=false;
#define new_s "New Path"
static int new_v=0;

void bar_init(){
	move(getmaxy(stdscr)-1,0);
	printinverted(b_inf_s);
	if(new_f/*true*/)texter_macro(new_s);
}
//command return
static int wrt(int f){
	size_t n=rows_tot-1;
	for(size_t i=0;i<n;i++){
		row*r=&rows[i];
		if((size_t)write(f,r->data,r->sz)!=r->sz)return 0;
		if((size_t)write(f,ln_term,ln_term_sz)!=ln_term_sz)return 0;
	}
	if((size_t)write(f,rows[n].data,rows[n].sz)==rows[n].sz)return command_return_ok;
	return 0;
}
static int bcdl(int y,int*p,char*input,int cursor){
	int x=getcurx(stdscr);
	int pos=p[0];
	if(pos==0&&x==com_left)return cursor;
	int of=x-com_left;
	for(int i=pos+of;i<cursor;i++){
		input[i-1]=input[i];
	}
	if(pos==0){
		x--;
		if(of==cursor){
			mvaddch(y,x,' ');
		}else{
			mvaddnstr(y,x,input+of-1,cursor-of);
			addch(' ');
		}
		move(y,x);
		return cursor-1;
	}
	pos--;int n=x-com_left;
	if(pos==0)mvaddch(y,com_left-1,' ');
	else if(n!=0)move(y,com_left);
	addnstr(input+pos,n);
	p[0]=pos;
	return cursor-1;
}
static void undo_erase(int a){
	int dif=undo_v-a;
	while(dif>0){addch(' ');dif--;}
	undo_v-=undo_v-a;
}
static bool bar_clear_mini(){
	if(new_v!=0){
		move(getmaxy(stdscr)-1,com_left);
		while(new_v!=0){addch(' ');new_v--;}
		return true;
	}else if(err_l>err_len_min){
		move(getmaxy(stdscr)-1,com_left);
		while(err_l!=0){addch(' ');err_l--;}
		return true;
	}
	return false;
}
bool bar_clear(){
	if(undo_v!=0){
		move(getmaxy(stdscr)-1,com_left);
		undo_erase(0);
		return true;
	}
	return bar_clear_mini();
}
void err_set(WINDOW*w){
	if(err_l>err_len_min){//waiting for normal clear_com
		int y=getmaxy(stdscr)-1;
		mvaddch(y,com_left,'\"');
		addnstr(err_s,err_l-err_len_min);
		addch('\"');
		wnoutrefresh(stdscr);
		wmove(w,getcury(w),getcurx(w));//newpath+save
	}
}
int open_new(char*path){
	return open(path,O_CREAT|O_WRONLY|O_TRUNC,S_IRUSR|S_IWUSR);
}
//command return
int saving_base(char*dest){
	int f;int r;
	//this 'if' can be the second time in some places, but it is not a must to write once
	if(access(dest,F_OK)==-1){
	//if(new_f/*true*/){
		f=open_new(dest);
		//new_f=f==-1;
		//if(new_f/*true*/){
	}
	else f=open(dest,O_WRONLY|O_TRUNC);
	if(f!=-1){
		r=wrt(f);
		close(f);
	}else{
		//this was for open_new, and is ok also when the file is already there
		bar_clear();//is troubleing with the bool,and more
		err_s=strerror(errno);
		err_l=(int)strlen(err_s)+err_len_min;
		int rg=get_right-com_left;
		if(err_l>rg)err_l=rg;

		r=0;
	}
	return r;
}
//command return
static int saving(){
	return saving_base(textfile);
}
static void inputpath(){
	//this comes for save(not having file) and save as(ok or overwrite)
	textfile=input0;

	restore_rebase();
	editing_rebase();

	if(input0==input1)input0=input2;
	else input0=input1;
	//good for other commands that are not storing the result
}
//-1exist,0er,1ok
static int saves(){
	if(access(input0,F_OK)==-1){
		inputpath();
		//new_f=true;
		return saving();
	}
	return -1;
}
static void clear_com(int y,int sz,int pos,int cursor){
	int len;if(pos!=0){
		move(y,com_left-1);
		len=1+cursor-pos;sz++;
	}
	else{
		move(y,com_left);
		len=cursor;
	}
	if(len>sz){
		sz++;
		for(int i=0;i<sz;i++)
			addch(' ');
		//memset(mapsel,' ',(size_t)sz+1);mapsel[sz+1]='\0';addstr(mapsel);
	}
	else{
		for(int i=0;i<len;i++)
			addch(' ');
		//memset(mapsel,' ',(size_t)len);mapsel[len]='\0';addstr(mapsel);
	}
}

static void texter(const char*t){
	mvaddstr(getmaxy(stdscr)-1,com_left,t);
}
void texter_macro(const char*t){
	new_v=strlen(t);
	texter(t);
}

//1/0/-1 -2
int question(const char*q){
	//if(com_left+sz>getmaxx(stdscr))return 1;
	int y=getmaxy(stdscr)-1;
	mvaddstr(y,com_left,q);
	addstr(quest_ex_s);
	int ch=getch();
	if(ch==KEY_RESIZE)return -2;
	move(y,com_left);
	int sz=(int)(strlen(q)+sizeof(quest_ex_s)-1);
	for(int i=0;i<sz;i++)
		addch(' ');
	//memset(mapsel,' ',sz);mapsel[sz]='\0';mvaddstr(y,com_left,mapsel);
	if(ch=='y')return 1;
	else if(ch=='n')return -1;
	return 0;
}
static int del(int x,char*input,int cursor,int dif){
	if(x==cursor)return cursor;
	cursor--;
	for(int i=x;i<cursor;i++){
		input[i]=input[i+1];
	}
	int f=x+dif;int r;
	if(cursor<f)r=cursor;else r=f;
	while(x<r){addch(input[x]);x++;}
	if(cursor<f){
		addch(' ');
	}else if(f==cursor)addch(' ');
	return cursor;
}

#define AZ_to_az 'a'-'A'
static bool charcompare(char a,char b){
	if(a!=b){
		if(issensitive==false){
			if((a<='Z')&&(b>='a')){
				if((a+AZ_to_az)==b)return true;
			}else if((b<='Z')&&(a>='a')){
				if((b+AZ_to_az)==a)return true;
			}
		}
	}else return true;
	return false;
}

static int inputcmp(char*S1,size_t L1,size_t l2){
	if(l2>L1)return -1;
	size_t n=L1-l2;
	size_t i=0;
	while(i<=n){
		if(charcompare(S1[i],inputf[0])/*true*/){
			size_t j=1;
			for(;j<l2;j++){
				if(charcompare(S1[i+j],inputf[j])==false)break;
			}
			if(j==l2)return(int)i;
			i+=j;
		}else i++;
	}
	return -1;
}
static bool findingf(size_t cursor,size_t r,size_t c){
	size_t i=ytext;
	if(i+r>=rows_tot)i=0;
	else{
		i+=r;
		c+=xtext;
		if(c<rows[i].sz){
			int a=inputcmp(rows[i].data+c,rows[i].sz-c,cursor);
			if(a>=0){xtext=c+(size_t)a;ytext=i;return true;}
		}
		i++;
		if(i==rows_tot)i=0;
	}
	size_t b=i;
	size_t e=rows_tot;
	for(;;){
		int a=inputcmp(rows[i].data,rows[i].sz,cursor);
		if(a>=0){xtext=(size_t)a;ytext=i;return true;}
		i++;
		if(i==e){
			if(e==rows_tot){
				if(b==0)return false;
				i=0;e=b;
			}
			else return false;
		}
	}
}
static int inputrcmp(char*S1,size_t L1,size_t l2){
	if(l2>L1)return -1;
	size_t m=l2-1;
	size_t i=L1;
	while(l2<=i){
		i--;
		if(charcompare(S1[i],inputf[m])/*true*/){
			size_t j=m;
			size_t p=i-j;
			while(j>0){
				j--;
				if(charcompare(S1[p+j],inputf[j])==false){
					j++;
					break;
				}
			}
			i-=m-j;
			if(j==0)return(int)i;
		}
	}
	return -1;
}
static bool findingb(size_t cursor,size_t r,size_t c){
	size_t i=ytext;
	if(i+r>=rows_tot)i=rows_tot-1;
	else{//safe when find first fails
		i+=r;
		c+=xtext;
		if(c<rows[i].sz){
			int n=inputrcmp(rows[i].data,c,cursor);
			if(n>=0){xtext=(size_t)n;ytext=i;return true;}
			if(i==0)i=rows_tot-1;
			else i--;
		}
	}
	size_t b=i;
	size_t e=0;
	for(;;){
		int a=inputrcmp(rows[i].data,rows[i].sz,cursor);
		if(a>=0){xtext=(size_t)a;ytext=i;return true;}
		if(i==e){
			if(e==0){
				if(b==rows_tot-1)return false;
				i=rows_tot-1;e=b+1;
			}else return false;
		}else i--;
	}
}
static bool finding(size_t cursor,size_t r,size_t c,bool f){
	if(cursor==0)return false;
	if(f/*true*/)return findingf(cursor,r,c);
	return findingb(cursor,r,c);
}
void position_core(size_t y,size_t x){
	char posbuf[10+1+10+1];
	int n=sprintf(posbuf,protocol "," protocol,y+1,x+1);
	int dif=getmaxx(poswn)-n;
	if(dif!=0){
		if(dif>0){
			int d=dif;
			wmove(poswn,0,0);
			while(d>0){waddch(poswn,' ');d--;}
			wnoutrefresh(poswn);
		}
		wresize(poswn,1,n);
		mvwin(poswn,getbegy(poswn),getbegx(poswn)+dif);
	}
	mvwaddstr(poswn,0,0,posbuf);
	wnoutrefresh(poswn);
}
void position(int rw,int cl){
	size_t y=ytext+(size_t)rw;size_t x;
	if(y>=rows_tot){y=rows_tot-1;x=rows[y].sz;}
	else{
		x=xtext+c_to_xc(cl,rw);
		if(x>rows[y].sz)x=rows[y].sz;
	}
	position_core(y,x);
}
void centering3(WINDOW*w,size_t*prw,size_t*pxc,bool right){
	int mx=getmaxx(w);
	int wd=mx/3;
	if(right/*true*/)wd=mx-wd;
	int c=0;char*d=rows[ytext].data;
	size_t xc=xtext;
	do{
		if(xtext==0)break;
		xtext--;
		c+=d[xtext]=='\t'?tab_sz:1;
	}while(c<wd);
	size_t hg=centeringy(w);
	wmove(w,(int)hg,c);
	if(prw!=nullptr){
		prw[0]=hg;pxc[0]=xc-xtext;
	}
}
size_t centeringy(WINDOW*w){
	size_t hg=(size_t)getmaxy(w)/2;
	if((int)(ytext-hg)<0){hg=ytext;ytext=0;}
	else ytext=ytext-hg;
	refreshpage(w);
	return hg;
}
static void colorfind(int a,int y,size_t pos,size_t sz){
	attrset(COLOR_PAIR(a));
	mvaddnstr(y,com_left,inputf+pos,(int)sz);
	attrset(0);
}
static void replace_text_add(WINDOW*w,chtype c,int*rstart,int*rstop){
	int cx=getcurx(w);
	if(getmaxx(w)-1==cx){
		int cy=getcury(w);
		if(getmaxy(w)-1==cy){
			wmove(w,0,0);
			wdeleteln(w);
			wmove(w,cy-1,cx);
			rstart[0]=0;
		}
	}else if(cx==0){
		int cy=getcury(w);
		if(cy==rstop[0])rstop[0]++;
	}
	waddch(w,c);
}
static bool replace_text(WINDOW*w,int yb,int xb,int rstart,int rstop){
	vis('R',w);
	for(;;){
		int c=wgetch(w);
		if(c==Char_Return){
			wattrset(w,0);
			refreshrowsbot(w,rstart,rstop);
			wmove(w,yb,xb);
			visual(' ');
			return false;
		}
		else if(is_KEY_BACKSPACE(c)){
			if(cursorr!=0){
				int x=getcurx(w);int y=getcury(w);
				if(x==0){
					x=getmaxx(w)-1;if(y!=0)y--;}
				else x--;
				mvwaddch(w,y,x,' ');
				wmove(w,y,x);
				cursorr--;
			}
		}
		else if(c==KEY_RESIZE)return true;
		else if(cursorr!=max_path&&no_char((char)c)==false){
			replace_text_add(w,(chtype)c,&rstart,&rstop);
			inputr[cursorr]=(char)c;
			cursorr++;
		}
	}
}
static int go_to(int cursor){
	int i=0;size_t y;size_t x;
	for(;;){
		if(input0[i]==','){
			input0[i]='\0';
			y=(size_t)atoi(input0);
			x=(size_t)atoi(input0+i+1);
			break;
		}
		if(i==cursor){
			y=(size_t)atoi(input0);
			x=1;break;
		}
		i++;
	}
	if(y>0){
		if(y>rows_tot)y=rows_tot;
		ytext=y-1;
		x--;if(x>rows[ytext].sz)
			xtext=rows[ytext].sz;
		else xtext=x;
		return 1;
	}
	return 0;
}
int save(){
	if(textfile!=nullptr){
		return saving();
	}
	char a=0;
	return command(&a);
}
WINDOW*position_init(){
	poswn=newwin(1,3,0,0);
	return poswn;
}
void position_reset(){
	wresize(poswn,1,3);
	mvwin(poswn,getmaxy(stdscr)-1,getmaxx(stdscr)-5);
}
static bool undo_expand(){
	size_t sz=undos_tot+1;
	size_t dif=sz&row_pad;
	if(dif!=0)sz+=((dif^row_pad)+1);
	if(sz>undos_spc){
		void*v=realloc(undos,sz*sizeof(eundo));
		if(v==nullptr)return false;
		undos=(eundo*)v;undos_spc=sz;
	}
	return true;
}
static void undo_ok(){
	if(undos_tot<undos_save)undos_save=0;
	undos_tot++;undos_max++;
}
static void undo_release(size_t a,size_t b){
	while(a<b){
		if(undos[a].data!=nullptr)
			free(undos[a].data);
		a++;
	}
}
static void undo_newway(){
	if(undos_tot!=undos_max){
		undo_release(undos_tot,undos_max);
		undos_max=undos_tot;
	}
}
bool undo_add(size_t yb,size_t xb,size_t ye,size_t xe){
	if(undo_expand()/*true*/){
		undo_newway();
		eundo*un=&undos[undos_tot];
		un->yb=yb;un->xb=xb;un->ye=ye;un->xe=xe;
		un->data=nullptr;
		undo_ok();return false;}
	return true;
}
static bool undo_del_backward(eundo*un,size_t yb,size_t xb,size_t ye,size_t xe){
	size_t x=sizemembuf(yb,xb,ye,xe);
	char*v=(char*)malloc(x);
	if(v==nullptr)return true;
	un->yb=yb;un->xb=xb;un->ye=ye;un->xe=x;
	un->data=v;
	cpymembuf(yb,xb,ye,xe,v);
	return false;
}
bool undo_add_del(size_t yb,size_t xb,size_t ye,size_t xe){
	if(undo_expand()/*true*/){
		size_t x=sizemembuf(yb,xb,ye,xe);
		size_t dif=x&row_pad;
		if(dif!=0)dif=(dif^row_pad)+1;
		char*v=(char*)malloc(x+dif);
		if(v!=nullptr){
			undo_newway();
			eundo*un=&undos[undos_tot];
			un->yb=yb;un->xb=xb;un->ye=ye;un->xe=x;
			un->data=v;
			cpymembuf(yb,xb,ye,xe,v);
			undo_ok();return false;}}
	return true;
}
bool undo_add_ind(size_t yb,size_t ye){
	if(undo_expand()/*true*/){
		undo_newway();
		eundo*un=&undos[undos_tot];
		un->ye=yb;un->yb=ye;
		un->data=nullptr;
		undo_ok();return false;}
	return true;
}
static void undo_ind_del(eundo*un,size_t yb,size_t ye,char*d){
	un->yb=ye;un->ye=yb;
	un->data=d;
	for(size_t i=yb;i<ye;i++){
		if(rows[i].sz==0)d[i-yb]=ln_term[0];
		else d[i-yb]=rows[i].data[0];
	}
}
bool undo_add_ind_del(size_t yb,size_t ye){
	if(undo_expand()/*true*/){
		void*d=malloc(ye-yb);
		if(d!=nullptr){
			undo_newway();
			undo_ind_del(&undos[undos_tot],yb,ye,(char*)d);
			undo_ok();return false;}}
	return true;
}
void undo_free(){
	if(undos!=nullptr){
		undo_release(0,undos_max);
		free(undos);
	}
}
static bool undo_add_replace(size_t cursor){
	if(undo_expand()/*true*/){
		char*d=(char*)malloc(1+sizeof(cursor)+cursor);
		if(d!=nullptr){
			undo_newway();
			eundo*un=&undos[undos_tot];
			un->yb=ytext;un->xb=xtext;
			un->ye=un->yb;un->xe=cursorr;
			un->data=d;
			d[0]=ln_term[0];((size_t*)((void*)&d[1]))[0]=cursor;
			//memcpy(&d[1]+sizeof(cursor),inputf,cursor);inputf can be insensitive
			memcpy(&d[1]+sizeof(cursor),&rows[ytext].data[xtext],cursor);
			undo_ok();return false;}}
	return true;
}
static bool undo_replace(eundo*un,char*data,size_t yb,size_t xb,size_t xe,bool is_undo){
	size_t*sz_p=(size_t*)((void*)&data[1]);
	size_t sz2=sz_p[0];
	row*r=&rows[yb];
	int memdif=(int)(sz2-xe);
	size_t sz=r->sz;
	if(memdif>0){
		if(row_alloc(r,sz,(size_t)memdif,0)/*true*/)return true;
	}
	else if(xe>sz2&&is_undo/*true*/){
		data=(char*)realloc(data,1+sizeof(xe)+xe);
		if(data==nullptr)return true;
		un->data=data;sz_p=(size_t*)((void*)&data[1]);
	}
	char*a=&r->data[xb];
	char*b=(char*)(sz_p+1);
	if(memdif>0){
		for(size_t i=0;i<xe;i++){
			char c=a[i];a[i]=b[i];b[i]=c;
		}
		size_t left=xb+xe;
		row_set(r,left,(size_t)memdif,sz-left,&b[xe]);
	}else{
		for(size_t i=0;i<sz2;i++){
			char c=a[i];a[i]=b[i];b[i]=c;
		}
		if(is_undo/*true*/)
			for(size_t i=sz2;i<xe;i++)b[i]=a[i];
		row_set(r,xb+sz2,sz-xb-xe,0,&r->data[xb+xe]);
	}
	sz_p[0]=xe;un->xe=sz2;
	ytext=yb;xtext=xb+sz2;
	return false;
}
static bool dos(WINDOW*w,eundo*un,size_t vl){
	bar_clear_mini();
	char*d=un->data;
	size_t y1=un->yb;size_t y2=un->ye;
	if(y1<=y2){
		size_t xb=un->xb;size_t xe=un->xe;
		if(d!=nullptr){
			if(y1==y2&&d[0]==ln_term[0]){
				if(undo_replace(un,d,y1,xb,xe,vl!=1)/*true*/)return false;
				centering2(w,nullptr,nullptr,true)
			}else{
				if(paste(y1,xb,&xe,d,xe,y2-y1+1,false)==false)return false;
				un->xe=xe;un->data=nullptr;
				ytext=y2;xtext=xe;
				centering2(w,nullptr,nullptr,true)
				free(d);
			}
		}
		else{
			if(deleting_init(y1,xb,y2,xe)/*true*/)return false;
			if(undo_del_backward(un,y1,xb,y2,xe)/*true*/)return false;
			deleting(y1,xb,y2,xe);
			ytext=y1;xtext=xb;
			centering_simple(w)
		}
	}else{
		if(d!=nullptr){
			for(size_t i=y2;i<y1;i++){
				row*r=&rows[i];
				if(row_alloc(r,0,1,r->sz)/*true*/)return false;
			}
			un->data=nullptr;
			for(size_t i=y2;i<y1;i++){
				char a=d[i-y2];
				if(a==ln_term[0])continue;
				row*r=&rows[i];
				row_set(r,0,1,r->sz,&a);
			}
			free(d);
			ytext=y1;xtext=1;
			centering2(w,nullptr,nullptr,true)
		}else{
			void*mem=malloc(y1-y2);
			if(mem==nullptr)return false;
			undo_ind_del(un,y2,y1,(char*)mem);
			for(size_t i=y2;i<y1;i++){
				size_t n=rows[i].sz;char*dt=rows[i].data;
				for(size_t j=1;j<=n;j++)dt[j-1]=dt[j];
				rows[i].sz--;
			}
			ytext=y2;xtext=0;
			centering_simple(w)
		}
	}
	undos_tot+=vl;
	if(undos_tot==undos_save)
		mod_set_on();
	else if(undos_tot==undos_save+vl)
		mod_set_off();
	else mod_set_off_wrap();//only if not
	return true;
}
#define maxuint 10
#define maxuint_nul maxuint+1
static void undo_show(size_t n){
	char nr[maxuint_nul];
	int a=sprintf(nr,protocol,n);
	texter(nr);
	undo_erase(a);
	wnoutrefresh(stdscr);
}
void undo(WINDOW*w){
	if(undos_tot==0)return;
	if(dos(w,&undos[undos_tot-1],(size_t)-1)/*true*/){
		if(undos_tot<=undos_save)undo_show(undos_tot);
		else undo_show(undos_tot-undos_save);
	}
}
void redo(WINDOW*w){
	if(undos_tot==undos_max)return;
	if(dos(w,&undos[undos_tot],1)/*true*/){
		if(undos_tot>=undos_save)undo_show(undos_max-undos_tot);
		else undo_show(undos_save-undos_tot);
	}
}
void undo_save(){undos_save=undos_tot;}
bool undo_type(size_t yb,size_t xb,size_t ye,size_t xe){
	if(undos_tot!=0){
		eundo*un=&undos[undos_tot-1];
		if(un->data==nullptr&&un->yb<=un->ye){
			if(un->ye==yb&&un->xe==xb){
				if(mod_flag==false){
					un->xe++;return false;
				}
			}
		}
	}
	return undo_add(yb,xb,ye,xe);
}
bool undo_bcsp(size_t yb,size_t xb,size_t ye,size_t xe){
	if(undos_tot!=0){
		eundo*un=&undos[undos_tot-1];
		if(un->data!=nullptr&&un->yb<=un->ye){
			if(un->yb==ye&&un->xb==xe){
				if(mod_flag==false){
					char*d;if((un->xe&row_pad)==0){
						d=(char*)realloc(un->data,un->xe+row_pad+1);
						if(d==nullptr)return true;
						un->data=d;
					}else d=un->data;
					for(size_t i=un->xe;i>0;i--)d[i]=d[i-1];
					d[0]=rows[yb].data[xb];
					un->xb--;un->xe++;
					return false;
				}
			}
		}
	}
	return undo_add_del(yb,xb,ye,xe);
}
bool undo_delk(size_t yb,size_t xb,size_t ye,size_t xe){
	if(undos_tot!=0){
		eundo*un=&undos[undos_tot-1];
		if(un->data!=nullptr&&un->yb<=un->ye){
			if(un->yb==yb&&un->xb==xb){
				if(mod_flag==false){
					char*d;if((un->xe&row_pad)==0){
						d=(char*)realloc(un->data,un->xe+row_pad+1);
						if(d==nullptr)return true;
						un->data=d;
					}else d=un->data;
					d[un->xe]=rows[yb].data[xb];
					un->xe++;
					return false;
				}
			}
		}
	}
	return undo_add_del(yb,xb,ye,xe);
}
void undo_loop(WINDOW*w){
	for(;;){
		int c=wgetch(w);
		if(c==KEY_LEFT)undo(w);
		else if(c==KEY_RIGHT)redo(w);
		else break;
	}
}
static bool replace(size_t cursor){
	row*r=&rows[ytext];
	if(cursorr>cursor)if(row_alloc(r,r->sz,cursorr-cursor,0)/*true*/)return true;
	if(undo_add_replace(cursor)==false){
		if(cursorr>cursor)row_set(r,xtext,cursorr,r->sz-xtext-cursor,inputr);
		else{
			memcpy(&r->data[xtext],inputr,cursorr);
			row_set(r,xtext+cursorr,r->sz-xtext-cursor,0,&r->data[xtext+cursor]);
		}
		mod_set_off_wrap();
		return false;
	}
	return true;
}

static void finds_clean(){
	move(0,number3);//clear finds

	//clrtoeol();//even at resize
	//if number3==maxx, move fails and last line is clr. one more if? no

	int max=getmaxx(stdscr);
	while(number3<max){addch(' ');number3++;}
}
static void finds_big_clean(){
	finds_clean();
	wnoutrefresh(stdscr);
	number3=getmaxx(stdscr);number2=0;
}
static int positiveInt_length(unsigned int nr){
	int x=0;
	while(nr>0){nr/=10;x++;}
	return x;
}
static void finds(bool phase,int number,int number_fix){//,bool*header_was){
	//if(*header_was==false){if(phase/*true*/){*header_was=true;}return 0;}

	char buf[maxuint+1+maxuint_nul];
	if(number<0){
		number*=-1;
	}
	if(phase/*true*/){
		number2=sprintf(buf,"/%u",number);
		mvaddstr(0,getmaxx(stdscr)-number2,buf);
	}else{//fprevnumber
		int dif=positiveInt_length(fprevnumber)-positiveInt_length(number);
		move(0,number3);
		while(dif>0){addch(' ');dif--;}
	}
	number+=number_fix;
	int nr=sprintf(buf,"%u",number);
	fprevnumber=number;//for 10->9, 10/10->1/10, ... , 100/100->1/100, ...
	number3=getmaxx(stdscr)-number2-nr;
	mvaddstr(0,number3,buf);
	wnoutrefresh(stdscr);
}

static bool delim_touch(size_t y1,size_t x1,size_t c){return ytext==y1&&(xtext==x1||(xtext<x1&&xtext+c>x1));}
static bool delimiter(size_t y1,size_t x1,int y,size_t pos,size_t sz,size_t c,bool phase){
	if(delim_touch(y1,x1,c)/*true*/){
		colorfind(2,y,pos,sz);
		wnoutrefresh(stdscr);
		return true;
	}
	if(phase/*true*/){
		colorfind(1,y,pos,sz);
		wnoutrefresh(stdscr);
	}
	return false;
}

#define quick_get(z) ((WINDOW**)((void*)z))[1]
#define find_returner return a==KEY_RESIZE?-2:1;

//1,0cancel,-2resz
static int find_core(WINDOW*w,size_t cursor,size_t xr,size_t xc,int y,size_t pos,size_t sz){
	bool forward=true;
	size_t y1=ytext;size_t x1=xtext;
	bool phase=false;
	wnoutrefresh(stdscr);
	centering(w,&xr,&xc)
	bool untouched=true;bool delimiter_touched=false;
	char prev_key=' ';
	//bool is_for_forward=true;//last key only at next/prev/replace

	int number=0;
	number2=0;
	number3=getmaxx(stdscr);//in case is required at clean

	for(;;){
		int a=wgetch(w);
		if(a==Char_Return){
			if(untouched/*true*/){
				xc+=cursor;//add only when last was simple find
				number+=1;
			}else{
				if(number<0)number+=1;
			//	if(forward/*true*/)number+=1;
				//else if(number==0)finds_big_clean();//header switch
			}
			forward=true;
		}else if(a==prev_key){
			if(untouched/*true*/)number-=1;
			else{
				if(number>0)number-=1;
			//	if(forward==false)number-=1;
				//else if(number==0)finds_big_clean();//header switch
			}
			forward=false;
		}else if(a==KEY_RIGHT){
			if(number2==0){//only when not knowing the total
				if(delimiter_touched==false){//to omit last replace return if that can happen at this point
					//set a limit
					const size_t max=100;
					//keep markers
					size_t ystart=ytext;size_t xstart=xtext;size_t xrstart=xr;size_t xcstart=xc;
					size_t n;
					//only depending on number not on forward
					int here_sense;bool here_forward;
					if(number==0){//on delimiter or after a replace at 1/-1
						here_sense=1;
						ytext=y1;xtext=x1;xr=0;xc=cursor;
						n=1;
						here_forward=true;
					}else{
						ytext+=xr;xr=0;//xtext+=xc;xc=0;
						if(number>0){
							here_sense=1;
							if(untouched/*true*/){
								xc+=cursor;
								n=1;
							}else n=0;
							here_forward=true;
						}else{
							here_sense=-1;
							if(untouched/*true*/)n=1;
							else n=0;
							here_forward=false;
						}
					}
					for(;;){
						finding(cursor,xr,xc,here_forward);//is true
						if(ytext==y1&&xtext==x1)break;
						n++;
						if(n==max)break;
						//xr=0;//only first was with offset
						xc=here_forward?cursor:0;//at backward must stay there
					}
					if(n!=max){
						finds(true,number+(n*here_sense),-n);
						wmove(w,getcury(w),getcurx(w));//print the result
					}
					//restore markers
					ytext=ystart;xtext=xstart;xr=xrstart;xc=xcstart;
					continue;
				}
			}
			find_returner
		}else if(a==KEY_LEFT){
			size_t iferrory=ytext;size_t iferrorx=xtext;
			if(untouched/*true*/){
				ytext+=xr;xtext+=xc;
				if(replace(cursor)/*true*/){ytext=iferrory;xtext=iferrorx;continue;}

				if(number3!=getmaxx(stdscr)){
					finds_big_clean();//wnoutrefresh when not on delimiter
				}
				if(number!=0){//0 is on delimiter
					//if(forward/*true*/)number-=1;
					//else number+=1;
					//fprevnumber=number;

					//if(delim_touch(y1,x1,cursorr)/*true*/){delimiter_touched=true;}else
					if(ytext==y1&&xtext<x1)x1-=cursor-cursorr;//this can be on delimiter but is observed outside
				}else delimiter_touched=true;

				if(forward){xtext+=cursorr;centering2(w,&xr,&xc,true)}
				else{centering(w,&xr,&xc)}
				untouched=false;
				//is_for_forward=false;
				continue;
			}
			if(finding(cursor,xr,xc,forward)/*true*/){
				if(replace(cursor)/*true*/){ytext=iferrory;xtext=iferrorx;continue;}

				phase=delimiter(y1,x1,y,pos,sz,cursorr,phase);
				if(phase/*true*/)delimiter_touched=true;
				else if(ytext==y1&&xtext<x1)x1-=cursor-cursorr;

				if(forward){xtext+=cursorr;centering2(w,&xr,&xc,true)}
				else{centering(w,&xr,&xc)}
				//is_for_forward=false;
				continue;
			}
			return 1;
		}else if(a=='r'){
			cursorr=0;wattrset(w,COLOR_PAIR(2));
			int rstart=getcury(w);
			if(replace_text(w,rstart,getcurx(w),rstart,rstart+1)/*true*/)return -2;
			continue;
		}else if(a=='R'){
			wattrset(w,COLOR_PAIR(2));
			int yb=getcury(w);int xb=getcurx(w);
			int rstart=yb;int rstop=yb+1;
			for(size_t i=0;i<cursorr;i++){
				replace_text_add(w,inputr[i],&rstart,&rstop);
			}
			if(replace_text(w,yb,xb,rstart,rstop)/*true*/)return -2;
			continue;
		}else if(a=='c'){
			return 0;
		}else{
			find_returner
		}
		if(finding(cursor,xr,xc,forward)==false){
			//was last replace
			return 1;
		}
		phase=delimiter(y1,x1,y,pos,sz,cursor,phase);

		if(delimiter_touched/*true*/){
			y1=ytext;x1=xtext;
			delimiter_touched=false;
		}else{
			if(number!=0){
				finds(phase,number,0);
				if(phase/*true*/)number=0;
			}else finds(false,0,0);
		}
		untouched=true;
		centering(w,&xr,&xc)
	}
}
//same
static int find(char*z,size_t cursor,size_t pos,size_t visib,int y){
	/*warning: cast from
      'char *' to 'size_t *' (aka
      'unsigned int *') increases required
      alignment from 1 to 4*/
	/*warning: arithmetic on
      a pointer to void is a GNU extension*/
	//z+=sizeof(void*);
	WINDOW*w=quick_get(z);
	size_t xr=(size_t)getcury(w);
	size_t xc=c_to_xc(getcurx(w),(int)xr);
	//
	size_t sz=cursor-pos;
	if(sz>visib)sz=visib;
	colorfind(1,y,pos,sz);
	//
	if(finding(cursor,xr,xc,true)/*true*/){
		int r=find_core(w,cursor,xr,xc,y,pos,sz);
		finds_clean();
		return r;
	}
	int a=getch();
	if(a=='c'){
		return 0;
	}
	find_returner
}
static void command_rewrite(int y,int x,int pos,char*input,int cursor,int visib){
	if(pos!=0)mvaddch(y,com_left-1,'<');
	else move(y,com_left);
	int len=cursor-pos;
	bool rt=len>visib;
	if(rt/*true*/)len=visib;
	addnstr(input+pos,len);
	if(rt/*true*/)addch('>');
	move(y,x);
}
static int word_at_cursor(char*z){
	WINDOW*w=quick_get(z);
	size_t y;size_t x;
	fixed_yx(&y,&x,getcury(w),getcurx(w));
	size_t sz=rows[y].sz;
	if(x==sz)return 0;
	char*d=rows[y].data;
	if(is_word_char(d[x])==false){if(no_char(d[x])==false){*inputf=d[x];return 1;}return 0;}
	int cursor=0;
	if(*z==com_nr_findword){
		size_t xpos=x;
		while(xpos>0&&is_word_char(d[xpos-1])/*true*/)xpos--;
		while(xpos<x){
			inputf[cursor]=d[xpos];cursor++;
			if(cursor==max_path)return cursor;
			xpos++;
		}
	}
	do{
		inputf[cursor]=d[x];cursor++;
		if(cursor==max_path)return cursor;
		x++;
	}while(x<sz&&is_word_char(d[x])/*true*/);
	return cursor;
}

//-2resize,-1no/quit,0er/fals,1ok
int command(char*comnrp){
	int rightexcl=get_right;
	int right=rightexcl-1;
	int visib=rightexcl-com_left;
	if(visib<2)return 0;//phisical visib is 1
	bar_clear();
	int y=getmaxy(stdscr)-1;int pos=0;
	char*input;int cursor;bool is_find=*comnrp<=com_nr_find_numbers;
	if(is_find/*true*/){
		if(*comnrp==com_nr_findagain)cursor=cursorf;
		else cursor=*comnrp>=com_nr_findword?word_at_cursor(comnrp):0;
		input=inputf;
	}else{
		input=input0;
		if(*comnrp==com_nr_goto_alt)cursor=sprintf(input,protocol ",",1+ytext
			+(size_t)getcury(quick_get(comnrp)));
		else if(*comnrp==com_nr_ext)cursor=sprintf(input,"%s",ocode_extension);//on prefs is len<=0xff and max_path_0 is 0x100
		else cursor=0;
	}
	if(cursor==0)move(y,com_left);
	else{
		command_rewrite(y,com_left+(cursor<visib?cursor:0),0,input,cursor,visib);
	}
	int r;for(;;){
		int a=getch();
		if(a==Char_Return){
			char comnr=comnrp[0];
			if(is_find/*true*/){
				int ifback=getcurx(stdscr);
				r=find(comnrp,(size_t)cursor,(size_t)pos,(size_t)visib,y);
				if(r==-2)break;
				int dif=rightexcl-getbegx(poswn);
				if(dif!=-1){
					right-=dif+1;rightexcl=right+1;
					visib=rightexcl-com_left;
					if(visib<2)break;
				}
				if(r==0){
					//the text was highlighted
					//but can be increased
					//can be resized big,resized small
					//if(dif>=0 here is not relevant
					command_rewrite(y,ifback>right?right:ifback,pos,inputf,cursor,visib);
					continue;
				}
			}else if(comnr<=com_nr_goto_numbers){
				input[cursor]='\0';
				r=go_to(cursor);
			}else if(comnr==com_nr_save){
				input[cursor]='\0';
				r=saves();
				if(r==-1){
					int x=getcurx(stdscr);
					clear_com(y,visib,pos,cursor);
					r=question("Overwrite");
					if(r==1){
						inputpath();
						//new_f=false;
						r=saving();
					}else if(r==0){
						command_rewrite(y,x,pos,input0,cursor,visib);
						continue;
					}else if(r==-2)return -2;
					wnoutrefresh(stdscr);
					return r;
				}
			}else{//com_nr_ext
				//                                              will not call on 8bits char*, can call on long* but long is not a pointer on all platform, better to define
				(*reinterpret_cast<void(*)(char*,unsigned long int)>(  ((comnrp_define*)comnrp)[1]  ))(input,cursor);
				r=1;
			}
			break;
		}
		else if(a==KEY_LEFT){
			int x=getcurx(stdscr);
			if(x>com_left)
				move(y,x-1);
			else if(pos>0){
				pos--;
				addnstr(input+pos,visib);
				if(pos+visib==cursor-1)addch('>');
				if(pos==0)mvaddch(y,com_left-1,' ');
				else move(y,com_left);
			}
		}
		else if(a==KEY_RIGHT){
			int x=getcurx(stdscr);
			if(x<right){if(x<com_left+cursor)move(y,x+1);}
			else if(pos+visib<=cursor){
				if(pos==0)mvaddch(y,com_left-1,'<');
				else move(y,com_left);
				if(pos+visib==cursor){
					pos++;
					addnstr(input+pos,visib-1);
					addch(' ');
				}
				else{
					pos++;
					addnstr(input+pos,visib);
					if(pos+visib==cursor)addch(' ');
				}
				move(y,x);
			}
		}
		else if(a==KEY_HOME){
			if(pos>0){
				mvaddch(y,com_left-1,' ');
				addnstr(input,visib);
				if(visib<cursor)addch('>');
				pos=0;
			}
			move(y,com_left);
		}
		else if(a==KEY_END){
			if(pos+visib<=cursor){
				if(pos==0)mvaddch(y,com_left-1,'<');
				else move(y,com_left);
				pos=cursor-visib+1;
				addnstr(input+pos,visib-1);
				const chtype t[]={' ',' '};
				addchnstr(t,2);
			}else move(y,com_left+cursor-pos);
		}
		else if(is_KEY_BACKSPACE(a)){
			cursor=bcdl(y,&pos,input,cursor);
		}
		else if(a==KEY_DC){
			int x=getcurx(stdscr);
			cursor=del(x-com_left+pos,input,cursor,rightexcl-x);
			move(y,x);
		}
		else if(a==KEY_RESIZE){r=-2;break;}
		else{
			const char*s=keyname(a);
			if(strcmp(s,"^Q")==0){r=-1;break;}
			if(cursor!=max_path){
				char ch=(char)a;
				if(no_char(ch)==false){
					int x=getcurx(stdscr);
					int off=pos+(x-com_left);
					for(int i=cursor;i>off;i--){
						input[i]=input[i-1];
					}
					input[off]=ch;
					int dif=right-x;
					if(dif==0){
						if(pos==0)mvaddch(y,com_left-1,'<');
						else move(y,com_left);
						pos++;
						addnstr(input+pos,visib-1);
					}else addch(ch);
					int d=cursor-off;
					if(d!=0){
						int n=right-x;
						if(dif!=0)x++;else n++;
						if(d<n)n=d;
						int i=off+1;
						addnstr(input+i,n);
						if(i+n==cursor)addch('>');
						move(y,x);
					}
					cursor++;
				}
			}
		}
	}
	if(r!=-2){
		clear_com(y,visib,pos,cursor);
		wnoutrefresh(stdscr);
	}
	if(is_find/*true*/)cursorf=cursor;
	return r;
}
bool new_visual(char*f){
	if(access(f,F_OK)==-1){
		textfile=f;

		new_f=true;
		return true;
	}
	return false;
}
bool is_dir(int fd){
	DIR*d=fdopendir(fd);
	if(d!=nullptr){closedir(d);return true;}
	return false;
}

#define acall      "aftercall"
#define acall_size (1+2+2+2+2)
#define acallu     "AFTERCALL"
#define acall_size1 acall_size+1
char*ocode_extension=(char*)"oc";// iso forbids

size_t aftercall_find(){
	for(size_t i=0;i<rows_tot;i++){
		row*r=&rows[i];
		size_t sz=r->sz;
		char*data=r->data;

		//first must skip spaces
		for(;sz!=0&&(*data=='\t'||*data==' ');sz--)data++;

		if(sz>acall_size1){//if still '\0' end at new mem, that is undefined
		//>= is enough if without # check, but is still a definition next, then without = is ok
			if(data[0]=='#'){//a fast solution is to comment in included .oc files to show them here
				data++;
			}
			int j;
			for(j=0;(acall[j]==data[j]||acallu[j]==data[j])&&j<acall_size;j++){}//readed text has a\n\b0
			if(j==acall_size){
				char ext=data[j];
				if(ext=='i'||ext=='I'||ext==' '||ext=='\t')return i;
			}
		}
	}
	return rows_tot;
}
void aftercall_draw(WINDOW*w){
	int row=getcury(w);int col=getcurx(w);
	refreshpage(w);
	wmove(w,row,col);
}
size_t init_aftercall(){
	if(textfile!=nullptr){
		char*pos=strrchr(textfile,'.');
		if(pos!=nullptr){
			pos++;
			if(strcmp(pos,ocode_extension)==0)return aftercall_find();
		}
	}
	return rows_tot;//still need a value
}
