
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
ifeq (${conv_64},1) #to cross compile
	ifneq ($(CC),arm-linux-gnueabihf-gcc)
		model=-m32
	endif
#else
#	model=
endif

OFLAGS=x_file 2

libname=liboadbgdata.so
exte=libexte.a

all: ${libname} oadbgdata.h
re:
	$(MAKE) clean
	$(MAKE) all

xlog=../include/xlog.

items=intern compare frame string branch ibranch log save mark
#$(eval subobjects = )
$(foreach var,$(items),$(eval subobjects += ${var}.o))
#$(eval sublogs = )
$(foreach var,$(items),$(eval sublogs += ${var}.oc.log))
#$(eval subx = )
$(foreach var,$(items),$(eval subx += ${var}.oc.x))
#$(eval subc = )
$(foreach var,$(items),$(eval subc += ${var}.c))

objects=main.o ${subobjects}
${objects}: common.h
common.h: oadbgdatas.h ${xlog}h
${exte}: ${subobjects}
	$(AR) cr ${exte} $^
${libname}: main.o ${exte}
	${OLINK} main.oc.log ${sublogs}
	$(CC) ${model} ${linkerflags} -shared $< -o ${libname} -L. -l:${exte} -Wl,--exclude-libs ${exte}
# -l:intern.o ? is ok but exclude-libs intern.o/...a will not exclude

%.o: %.oc
	${OCOMP} $< ${OFLAGS}
	${OCONV} $<.x
	$(CC) ${model} -c -w -fPIC ${compilerflags} $*.c
#-fPIC since launchpad bionic build
#-Wimplicit-function-declaration is good but anyway when making .x, ocompiler is also checking for this error
%.ohi: %.oh
	echo "format elfobj64" > $@
	echo "orphan off" >> $@
	echo "override include_sec 1" >> $@
	cat $< >> $@
%.h: %.ohi
#	if [ $@ = common.h ]; then $(MAKE) ${xlog}h;fi
	${OCOMP} $< ${OFLAGS} logfile 0
	${OCONV} $<.x

clean:
	-rm -f common.ohi            common.ohi.x     common.h
	-rm -f ${xlog}ohi            ${xlog}ohi.x     ${xlog}h
	-rm -f oadbgdatas.ohi        oadbgdatas.ohi.x oadbgdatas.h
	-rm -f ${objects} ${sublogs} ${subx}          ${subc}
	-rm -f           main.oc.log main.oc.x        main.c
	-rm -f oadbgdata.ohi         oadbgdata.ohi.x  oadbgdata.h

	-rm -f ${exte} ${libname}

distclean: clean

test:
	echo "Nothing"

install-lib:
	install -D ${libname} \
		$(DESTDIR)$(prefix)/lib/${libname}

install: all install-lib

uninstall:
	-rm -f $(DESTDIR)$(prefix)/lib/${libname}

#.PHONY targets are not default files, then, make will not try to test if a rule has an updated file on the disk (if has will skip that rule)
.PHONY: all install install-lib clean distclean uninstall test re
#tested: .NOTPARALLEL: in parent is not preserved here
