
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
	ifeq ($(findstring mingw,$(CC)),)
		linkerflags += -march=native
	endif
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
ifndef platform
platform=lin
endif

ifeq (${conv_64},1) #to cross compile
	ifneq ($(CC),arm-linux-gnueabihf-gcc)
		model=-m32
	endif
else
	ifeq (${platform},win) #to long long
		OCONVFLAGS=-
	endif
endif

OFLAGS=x_file 2

firstname=liboaas
libname=${firstname}.so
libnamedll=${firstname}.dll

objs=translate util ${platform}

$(eval obs = )
$(foreach var,$(objs),$(eval obs += ${var}.o))
$(eval logs = )
$(foreach var,$(objs),$(eval logs += ${var}.oc.log))
$(eval cfiles = )
$(foreach var,$(objs),$(eval cfiles += ${var}.c))
$(eval xfiles = )
$(foreach var,$(objs),$(eval xfiles += ${var}.oc.x))

objects=main.o
exte=libexte.a

all: ${libname}

${libname}: headers ${objects} ${exte}
	${OLINK} main.oc.log ${logs}
	if [ "${platform}" = "lin" ]; then \
		$(CC) ${model} ${linkerflags} -shared ${objects} ${exte} -o ${libname} -L. -l:${exte} -Wl,--exclude-libs=${exte}; \
	else \
		x86_64-w64-mingw32-gcc --no-leading-underscore ${linkerflags} ${objects} ${obs} -shared -lmsvcrt -o ${libnamedll} -Wl,--exclude-modules-for-implib `printf ',%s' ${obs} | cut -c2-`; \
	fi

headers:
	$(MAKE) -C ../include common.h

${exte}: ${obs}
	$(AR) cr ${exte} $^

%.o: %.oc
	${OCOMP} $< ${OFLAGS} include_sec 1
	${OCONV} ${OCONVFLAGS} $<.x import
	$(CC) ${model} -c -w -fPIC ${compilerflags} ${EXTRA_CFLAGS} $*.c

clean:
	$(MAKE) -C ../include clean
	-rm -f main.oc.log main.oc.x main.c
	-rm -f ${objects} ${exte} ${libname} ${libnamedll}
	-rm -f ${obs} ${logs} ${xfiles} ${cfiles}

distclean: clean

test:
	echo "Nothing"

install-lib:
	install -D ${libname} $(DESTDIR)$(prefix)/lib/${libname}

install: all install-lib

uninstall:
	-rm -f $(DESTDIR)$(prefix)/lib/${libname}

.PHONY: all headers install install-lib clean distclean uninstall test
