
#this lib is helping oaas3 to shortcut the repeatable translation calls

ifndef OCOMP
OCOMP=o
endif
ifndef OLINK
OLINK=ounused
endif
ifndef OCONV
OCONV=otoc
endif
ifndef linkerflags
linkerflags=-O3 -s
endif
ifndef compilerflags
compilerflags=${linkerflags}
endif
ifndef EXTRA_CFLAGS
include ../oad/cflags
endif
ifndef prefix
prefix=/usr
endif

ifeq (${conv_64},1) #to cross compile
	ifneq ($(CC),arm-linux-gnueabihf-gcc)
		model=-m32
	endif
endif

OFLAGS=x_file 2

libname=liboaas.so

objects=main.o

all: ${libname}

${libname}: ${objects}
	${OLINK} main.oc.log
	$(CC) ${model} ${linkerflags} -shared $< -o ${libname}

%.o: %.oc
	${OCOMP} $< ${OFLAGS}
	${OCONV} ${OCONVFLAGS} $<.x import
	$(CC) ${model} -c -w -fPIC ${compilerflags} ${EXTRA_CFLAGS} $*.c

clean:
	-rm -f main.oc.log main.oc.x main.c
	-rm -f ${objects} ${libname}

distclean: clean

test:
	echo "Nothing"

install-lib:
	install -D ${libname} $(DESTDIR)$(prefix)/lib/${libname}

install: all install-lib

uninstall:
	-rm -f $(DESTDIR)$(prefix)/lib/${libname}

.PHONY: all install install-lib clean distclean uninstall test
