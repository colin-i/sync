
#include <stdio.h>
#include <stdlib.h>
#include "../dev/actionswf.h"

char *text(const char *filename)
{
    FILE *f = fopen(filename, "rb");
    if (!f) return NULL;

    // Seek to end to get size
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    rewind(f);

    // Allocate +1 for null terminator
    char *buffer = (char *)malloc(size + 1);
    if (!buffer) {
        fclose(f);
        return NULL;
    }

    // Read file
    size_t read = fread(buffer, 1, size, f);
    fclose(f);

    // Null-terminate
    buffer[read] = '\0';

    return buffer;
}

int main(int argc,char**argv){
	xlog_pad_set(0x30);

	int f;
	if(argc==1)f=prexx_flags|flagpre_x_pad|flagpre_write_no;
	else{
		puts("xxu_flags flag_titles");
		f=xxu_flags|flag_titles;
	}

	swf_new_ex("a.swf",0x80,0x80,0x050607,2,f);
	action(text("./aoc/a"));
	int presprite=swf_sprite_new();
	action_sprite(presprite,"trace('b'+this.value)");
	action_init_sprite(presprite,text("./aoc/b"));
	int sprite=swf_sprite_done(presprite);
	swf_exports_add(sprite,"carSymbol");

	swf_done();
	exit(erbool_get());
}
