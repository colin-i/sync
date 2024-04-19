
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
sfile=${name}.swf
OFLAGS=conv_64 ${conv_64}
linkname=actionswf
linkfile=${linkname}.lib

ifeq (${platform},win)
	OFLAGS += inplace_reloc 0
else
	libname=${linkname}.so
	OFLAGS += underscore_pref 1
	#ifeq (${conv_64},1)
	OFLAGS += include_sec 1
	#exit_end 1 #same problem as ocompiler, even at qemu-amd64
	#endif
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
                  $(LD) ${linkerflags} --dynamic-linker=/lib64/ld-linux-x86-64.so.2 ${name}.o -entry main -o ${name} -lc -L../src -l:${libname}; \
		fi \
	else \
		if [ "${conv_64}" = "1" ]; then \
			i686-w64-mingw32-ld ${linkerflags} ${name}.o -entry main -lmsvcrt -o ${name}.exe -L. -l${linkname}; \
		else \
			x86_64-w64-mingw32-ld ${linkerflags} ${name}.o -entry main -lmsvcrt -o ${name}.exe -L. -l${linkname}; \
		fi \
	fi
#same as src #$(CC) ${linkerflags} ${name}.o -o ${name} -L../src -l:${libname};

exe:
	if [ "${platform}" = "lin" ]; then \
		LD_LIBRARY_PATH=../src ${launcher} ./${name} =; \
	fi
#\? is 0x3f, inside -0x30, 0 is 0x30, \; to 0xb, = is 0xd

%: %.oc
	${OCOMP} $< ${OFLAGS} ${OFLAGSEXTRA}

clean:
	-rm -f ${name}.oc.log
	-rm -f ${name}.o
	-rm -f ${name}
	-rm -f ${name}.exe
	-rm -f ${linkfile}
	-rm -f ${sfile}.log
	-rm -f ${sfile}.x
	-rm -f ${sfile}

distclean: clean

install: test

uninstall: test

test:
	diff ${sfile} expected.swf

.PHONY: all install clean distclean uninstall test

.NOTPARALLEL:

#LD_LIBRARY_PATH=/home/bc/s/actionswf-1/src ./${name} 0
