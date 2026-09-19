
ifndef platform
platform=lin
endif
ifndef OCONV
OCONV=otoc
endif
ifndef linkerflags
linkerflags=-O3 -march=native -s
# -flto currently breaks. ... block_get_size is pointer(translator), int when we use it, at == 0 comparation lto if having O1 will skip
#	when trying to find what lto/O mix, -fno-strict-aliasing will produce less crashes
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

ifeq ($(shell dpkg-architecture -qDEB_HOST_ARCH), arm64)
#let error if not dpkg-architecture to be visible for correction . or || uname -m , patsubst
	OCONVFLAGS=-s
endif

backsrc=../src/

logs_prefix=${backsrc}
include ${backsrc}items
exte=libexte.a
proj=libactionswf.so

items_prefix=${backsrc}
$(eval xfiles = )
$(foreach var,$(expitems),$(eval xfiles += ${items_prefix}${var}.e.oc.x))
$(foreach var,$(items),$(eval xfiles += ${items_prefix}${var}.oc.x))
$(eval cfiles = )
$(foreach var,$(expitems),$(eval cfiles += ${items_prefix}${var}.e.c))
$(foreach var,$(items),$(eval cfiles += ${items_prefix}${var}.c))

ifeq (${conv_64},1) #to cross compile
	OCONVFLAGS=-s
#yes, was not set earlier at arm64 when cross for armhf(even setting CC to armhf will change that), and i386 is not like x86_64 in terms of va_list
	ifneq ($(CC),arm-linux-gnueabihf-gcc)
		model=-m32
	endif
#else
#	ifeq (${platform},win) #to long long
#		OCONVFLAGS - or plus l
#	endif
endif

OFLAGS=x_file 2

all: headers ${proj}
#can't put headers at proj, will phony libactionswf.so
${proj}: ${exte} ${eobs}
	${OLINK} ${logs}
	$(CC) ${model} ${linkerflags} -shared ${eobs} -o $@ `pkg-config --libs zlib` -L. -l:${exte} -Wl,--exclude-libs=${exte}
${exte}: ${obs}
	$(AR) cr ${exte} $^
# -e DllMain

headers:
	$(MAKE) -C ../include
	$(MAKE) -C ../dev flags.h action_swf.h

%.o: ${backsrc}%.oc
	${OCOMP} $< ${OFLAGS} include_sec 1
	${OCONV} ${OCONVFLAGS} $<.x import
	$(CC) ${model} -c -w -fPIC ${compilerflags} ${EXTRA_CFLAGS} ${backsrc}$*.c -o $@

clean-obj:
	-rm -f ${obs} ${eobs}
clean: clean-obj
	$(MAKE) -C ../include clean
	$(MAKE) -C ../dev clean-csrc
	-rm -f ${logs} ${exte} ${proj}
	-rm -f ${xfiles} ${cfiles}
distclean: clean

install:
	install -D ${proj} $(DESTDIR)$(prefix)/lib${install_number}/${proj}

uninstall:
	-rm -f $(DESTDIR)$(prefix)/lib${install_number}/${proj}

.PHONY: all headers clean clean-obj distclean install uninstall

# global usings: abcdefghiloprstuwx jkmnqvy
