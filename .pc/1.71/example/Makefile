
platform = lin

ifndef OCOMP
OCOMP=o
endif

OLINK=ounused
linkerflags=-s

ifndef conv_64
conv_64=0
endif

name=example
OFLAGS=conv_64 ${conv_64}
linkname=actionswf
linkfile=${linkname}.lib

ifeq (${platform},win)
	OFLAGS += inplace_reloc 0
else
	libname=${linkname}.so
	OFLAGS += underscore_pref 1
	ifeq (${conv_64},1)
		OFLAGS += exit_end 1 include_sec 1
	endif
endif

all: build exe

build: ${name} uns lib link

uns:
	${OLINK} ${name}.oc.log

lib:
	if [ "${platform}" = "win" ]; then \
		if [ "${conv_64}" = "1" ]; then \
			i686-w64-mingw32-dlltool --no-leading-underscore -d ../src/actionswf.def -l ${linkfile}; \
		else \
			x86_64-w64-mingw32-dlltool --no-leading-underscore -d ../src/actionswf.def -l ${linkfile}; \
		fi \
	fi

link:
	if [ "${platform}" = "lin" ]; then \
		if [ "${conv_64}" = "1" ]; then \
			$(LD) ${linkerflags} -melf_i386 --dynamic-linker=/lib/ld-linux.so.2 ${name}.o -entry main -o ${name} -lc -L../src -l:${libname}; \
		else \
			$(CC) ${linkerflags} ${name}.o -o ${name} -L../src -l:${libname}; \
		fi \
	else \
		if [ "${conv_64}" = "1" ]; then \
			i686-w64-mingw32-ld ${linkerflags} ${name}.o -entry main -lmsvcrt -o ${name}.exe -L. -l${linkname}; \
		else \
			x86_64-w64-mingw32-ld ${linkerflags} ${name}.o -entry main -lmsvcrt -o ${name}.exe -L. -l${linkname}; \
		fi \
	fi
#$(LD) ${linkerflags} --dynamic-linker=/lib64/ld-linux-x86-64.so.2 ${name}.o -entry main -o ${name} -lc -L../src -l:actionswf.so; \

exe:
	if [ "${platform}" = "lin" ]; then \
		export LD_LIBRARY_PATH=../src; ./${name} 1; \
	fi

%: %.oc
	${OCOMP} $< ${OFLAGS}

clean:
	-rm -f ${name}.oc.log
	-rm -f ${name}.o
	-rm -f ${name}
	-rm -f ${name}.exe
	-rm -f ${linkfile}
	-rm -f ${name}.swf.log

distclean: clean

install: test

uninstall: test

test:
	echo "Nothing"

.PHONY: all install clean distclean uninstall test

.NOTPARALLEL:

#LD_LIBRARY_PATH=/home/bc/s/actionswf-1/src ./${name} 0
