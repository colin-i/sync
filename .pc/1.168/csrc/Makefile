
ifndef platform
platform=lin
endif
ifndef OCONV
OCONV=otoc
endif
ifndef linkerflags
linkerflags=-s #-O1..fast will break the test at bionic(at least)
endif
ifndef compilerflags
compilerflags=${linkerflags}
endif
ifndef EXTRA_CFLAGS
include ../oad/cflags
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
	$(CC) ${model} ${linkerflags} -shared ${eobs} -o $@ -L. -l:${exte} -Wl,--exclude-libs=${exte}
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

clean:
	$(MAKE) -C ../include clean
	$(MAKE) -C ../dev clean-csrc
	-rm -f ${obs} ${eobs} ${logs} ${exte} ${proj}
	-rm -f ${xfiles} ${cfiles}
distclean: clean

.PHONY: all headers clean distclean

# global usings: abcdefghiloprstuwx jkmnqvy
