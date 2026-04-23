
ifndef platform
platform=lin
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

items_prefix=../src/
include ../src/items
exte=libexte.a
proj=libactionswf.so

$(eval xfiles = )
$(foreach var,$(expitems),$(eval xfiles += ${items_prefix}${var}.e.oc.x))
$(foreach var,$(items),$(eval xfiles += ${items_prefix}${var}.oc.x))
$(eval cfiles = )
$(foreach var,$(expitems),$(eval cfiles += ${items_prefix}${var}.e.c))
$(foreach var,$(items),$(eval cfiles += ${items_prefix}${var}.c))

ifeq (${conv_64},1) #to cross compile
	ifneq ($(CC),arm-linux-gnueabihf-gcc)
		model=-m32
	endif
#else
#	ifeq (${platform},win) #to long long
#		OCONVFLAGS=-
#	endif
endif

OFLAGS=x_file 2

all: headers ${proj}
#can't put headers at proj, will phony libactionswf.so
${proj}: ${exte} ${eobs}
	${OLINK} ${logs}
	$(CC) ${model} ${linkerflags} -shared ${eobs} -o $@ -L. -l:${exte} -e DllMain -Wl,--exclude-libs=${exte}
${exte}: ${obs}
	$(AR) cr ${exte} $^

headers:
	$(MAKE) -C ../include
	$(MAKE) -C ../dev flags.h action_swf.h

%.o: %.oc
	${OCOMP} $< ${OFLAGS} include_sec 1
	${OCONV} ${OCONVFLAGS} $<.x import
	$(CC) ${model} -c -w -fPIC ${compilerflags} ${EXTRA_CFLAGS} $*.c -o $@

clean:
	$(MAKE) -C ../include clean
	$(MAKE) -C ../dev clean-csrc
	-rm -f ${obs} ${eobs} ${logs} ${exte} ${proj}
	-rm -f ${xfiles} ${cfiles}
distclean: clean

.PHONY: all headers clean distclean

# global usings: abcdefghiloprstuwx jkmnqvy
