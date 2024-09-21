
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

OFLAGS=x_file 2

libname=liboadbgdata.so
exte=libexte.a

all: ${libname} oadbgdatai.h
re:
	$(MAKE) clean
	$(MAKE) all

xlog=../include/xlog.

${exte}: intern.o
	$(AR) cr ${exte} $^
objects=main.o intern.o
${objects}: common.h
${libname}: ${exte} main.o
	${OLINK} main.oc.log intern.oc.log
	$(CC) ${linkerflags} -shared $(word 3,$^) -o ${libname} -L. -l:${exte} -Wl,--exclude-libs ${exte}
	# -l:intern.o ? is ok but exclude-libs intern.o/...a will not exclude

%.o: %.oc
	${OCOMP} $< ${OFLAGS}
	${OCONV} $<.x
	$(CC) -c -w ${compilerflags} $*.c
	#-Wimplicit-function-declaration is good but anyway when making .x, ocompiler is also checking for this error
%.oh: %.h.oh
	echo "format elfobj64" > $@
	echo "orphan off" >> $@
	cat $< >> $@
%.h: %.oh
	if [ $@ = common.h ]; then $(MAKE) ${xlog}h;fi
	${OCOMP} $< ${OFLAGS}
	${OCONV} $<.x

clean:
	-rm -f common.oh.log common.oh.x common.oh common.h
	-rm -f ${xlog}oh.log ${xlog}oh.x ${xlog}oh ${xlog}h
	-rm -f intern.o intern.oc.log intern.oc.x intern.c
	-rm -f main.o main.oc.log main.oc.x main.c
	-rm -f ${exte} ${libname}
	-rm -f oadbgdatai.oh.log oadbgdatai.oh.x oadbgdatai.oh oadbgdatai.h

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
