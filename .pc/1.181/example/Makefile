
platform = lin

ifndef OCOMP
OCOMP=o
endif

OLINK=ounused
linkerflags=-s

ifndef conv_64
conv_64=0
endif

ifndef ffdec
ffdec=ffdec
endif

name=example
sfile=${name}.swf
OFLAGS=conv_64 ${conv_64}
linkname=actionswf
linkfile=${linkname}.lib
ifndef _L
	_L=../src
endif

ifeq (${platform},win)
	OFLAGS += inplace_reloc 0
else
	libname=lib${linkname}.so
	OFLAGS += underscore_pref 1
	ifdef ldprefer
		OFLAGS += include_sec 1
	else
		ifeq (${conv_64},1)
			OFLAGS += include_sec 1
		endif
	endif
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
			$(LD) ${linkerflags} -melf_i386 --dynamic-linker=/lib/ld-linux.so.2 ${name}.o -entry main -o ${name} -lc ${L} `pkg-config --libs zlib` -L${_L} -l:${libname}; \
		elif [ -z "${ldprefer}" ]; then \
			$(CC) ${linkerflags} ${name}.o -o ${name} `pkg-config --libs zlib` -L${_L} -l:${libname}; \
		else \
			$(LD) ${linkerflags} --dynamic-linker=/lib64/ld-linux-x86-64.so.2 ${name}.o -entry main -o ${name} -l:libc.so.6 ${L} `pkg-config --libs zlib` -L${_L} -l:${libname}; \
		fi \
	else \
		if [ "${conv_64}" = "1" ]; then \
			i686-w64-mingw32-ld ${linkerflags} ${name}.o -entry main -lmsvcrt -o ${name}.exe -L. -l${linkname}; \
		else \
			x86_64-w64-mingw32-gcc ${linkerflags} ${name}.o -o ${name}.exe -L. -l${linkname}; \
		fi \
	fi
#launchpad amd64 is segmentation with ld instead of cc
#				$(CC) ${linkerflags} -m32 ${name}.o -o ${name} -L../src -l:${libname}; \
#x86_64-w64-mingw32-ld ${linkerflags} ${name}.o -entry main -lmsvcrt -o ${name}.exe -L. -l${linkname}; \
#at win gcc-mingw-w64-x86-64-win32 , because ld will not argc first argument

exe:
	if [ "${platform}" = "lin" ]; then \
		LD_LIBRARY_PATH=${_L}${_L2} ${launcher} ./${name} && \
		LD_LIBRARY_PATH=${_L}${_L2} ${launcher} ./${name} x ${x3}; \
	else \
		export WINEPATH=${WINEPATH}\;${_L}; \
		${launcher} ./${name}.exe && \
		${launcher} ./${name}.exe x ${x3}; \
	fi

%: %.oc
	${OCOMP} $< ${OFLAGS} ${OFLAGSEXTRA}

clean:
	-rm -f ${name}.oc.log
	-rm -f ${name}.o
	-rm -f ${name}
	-rm -f ${name}.exe
	-rm -f ${linkfile}
	-rm -f ${sfile}.log
	-rm -f ${sfile}.x ${sfile}.xx
	-rm -f ${sfile}
	-rm -f ${sfile}.data
	-rm -f expected.swf
	-rm -f expected.c.swf

distclean: clean

install:
	echo "No install"

uninstall:
	echo "No uninstall"

expected.swf:
	base64 -d expected.c.swf.txt > expected.c.swf
	${ffdec} -decompress expected.c.swf $@
test: all expected.swf
	diff ${sfile} expected.swf && echo $$?
expected.c.swf: build
	x3=x $(MAKE) exe
	mv ${sfile} $@
expected.c.swf.txt: expected.c.swf
	base64 $< > $@

.PHONY: all build uns lib link exe install clean distclean uninstall test

.NOTPARALLEL:

#LD_LIBRARY_PATH=/home/bc/s/actionswf-1/src ./${name} 0
