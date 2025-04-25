#include <windows.h>
#include <stdio.h>
#include <direct.h>
#include <io.h>
#include <fcntl.h>

#pragma comment(lib, "User32.lib")
#pragma warning( disable : 4995 )
#pragma warning( disable : 4996 )

char* format;
void fwr(char* nm){
	FILE* f;

	printf(nm);printf("\n");
	f=fopen(nm,"r+");
	fseek(f,0,SEEK_SET);
	fwrite(format,strlen(format),1,f);
	fclose(f);
}
void files(int x){
	char z[MAX_PATH];int f;char* content;long ln;int p;int i;long length;

	sprintf(z,"../dev/f%u.txt",x);
	f=_open(z,_O_RDONLY|_O_BINARY);ln=_filelength(f);length=ln+1;
	content=malloc(length);_read(f,content,ln);_close(f);
	content[ln]=',';

	p=0;
	for(i=0;i<length;i++){
		if(content[i]==','){
			content[i]=0;
			sprintf(z,"%s.oc",&content[p]);fwr(z);
			p=i+1;
		}
	}
	free(content);
}

void main(int argc,char** argv)
{

   if(argc<2)return;
	format=argv[1];

	_chdir("../");_chdir("shared");
	fwr("action_dllmain.oc");

	_chdir("../");_chdir("src");
	files(1);files(2);
}
