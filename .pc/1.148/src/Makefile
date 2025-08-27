
ifndef platform
platform=lin
endif

ifndef OCOMP
OCOMP=o
endif

ifndef conv_64
conv_64=0
endif

ifndef OLINK
OLINK=ounused
endif

ifndef linkerflags
linkerflags=-O3 -s
#-O0 to 3 is same at .so here
endif
ifndef prefix
prefix=/usr
endif

ifndef OSTRIP
OSTRIP=ostrip
endif

ifndef nobits_virtual
nobits_virtual=1
endif

ifndef strippy
strippy=ostriputil
endif

#if modifying OFLAGS will lose inside data (at kinetic is reversed: first that def, then this def)
OFLAGS=conv_64 ${conv_64} ${OFLAGSEXTRA}

ifeq (${nobits_virtual},0)
OFLAGS+=nobits_virtual 0
endif

#this is like ld is linking, reason: ostrip is not adapted for this, there is another solutin with ocompiler and NOBITS
#	maybe is a 0x1000 .o size rule only from libexte.a
items = actioncode actionparse actionutil bits character file storage util ${platform} actionpool debug faction alt dtitles x local actionpush img
expitems = action swf tool ../shared/action_dllmain

exte=libexte.a

debug=
restofname=lib
projname=actionswf${debug}
name = ${projname}.so
defname = ${projname}.def
items_prefix=
prefname=${items_prefix}${name}
libname=${restofname}${name}

$(eval obs = )
$(eval eobs = )
$(foreach var,$(expitems),$(eval eobs += ${items_prefix}${var}.e.o))
$(foreach var,$(items),$(eval obs += ${items_prefix}${var}.o))
$(eval logs = )
$(foreach var,$(expitems),$(eval logs += ${items_prefix}${var}.e.oc.log))
$(foreach var,$(items),$(eval logs += ${items_prefix}${var}.oc.log))

ifeq (${platform},win)
OFLAGS += inplace_reloc 0 include_sec 1
all: compile ounused link def
link:
	if [ "${conv_64}" = "1" ]; then \
		i686-w64-mingw32-ld --no-leading-underscore ${linkerflags} ${eobs} ${obs} -shared -entry=DllMain -lmsvcrt ${L} -lzlib1 -o ${projname}.dll --exclude-modules-for-implib `printf ',%s' ${obs} | cut -c2-`; \
	else \
		x86_64-w64-mingw32-ld --no-leading-underscore ${linkerflags} ${eobs} ${obs} -shared -entry=DllMain -lmsvcrt ${L} -lzlib1 -o ${projname}.dll --exclude-modules-for-implib `printf ',%s' ${obs} | cut -c2-`; \
	fi
#on 64 is mingw-w64-x86-64-dev

#next phony will += , tested
.PHONY: link

else
OFLAGS += underscore_pref 1
#else ifeq (${conv_64},1)

all: ${libname}

ifeq (${conv_64},1)
#this past that focal ld is not. the cc variant is linking but the result will be bad with binutils
#ATLDCOM=$(CC) -m32 ${linkerflags} ${linkerflagsextra} ${eobs} -shared -shared -Wl,-entry=DllMain -o ${prefname} -lc ${L} `pkg-config --libs zlib` -L${items_prefix}. -l:${exte} -Wl,--exclude-libs=${exte}
#need to use LLVM lld for a solution, even then still getting relocation cannot be used against symbol, recompile with -fPIC
ATLDCOM = $(LD) -melf_i386 --dynamic-linker=/lib/ld-linux.so.2 ${linkerflags} ${eobs} -shared -entry DllMain -o ${prefname} ${Lc} -lc ${L} `pkg-config --libs zlib` -L${items_prefix}. -l:${exte} --exclude-libs ${exte}
${libname}: ${name}
	ln -f ${name} ${libname}

else
#same problems like ocompiler and arm #ATLDCOM = $(CC) ${linkerflags} ${eobs} -shared -e DllMain -o ${name} -lc -L. -l:${exte} -Wl,--exclude-libs ${exte}
ATLDCOM = $(LD) ${linkerflags} --dynamic-linker=/lib64/ld-linux-x86-64.so.2 ${eobs} -shared -e DllMain -o ${name} -l:libc.so.6 ${L} `pkg-config --libs zlib` -L. -l:${exte} --build-id --exclude-libs ${exte}
#and pkg-config for -lc? is not in libc6-dev. where is?
#--build-id for rpm
ifeq (${nobits_virtual},1)
${libname}: ${name}
	ln -f ${name} ${libname}
#is not with ln -s because will be one file install
else
${libname}: ${name}
	$(eval strp = )
	$(foreach var,$(expitems),$(eval strp += ${items_prefix}${var}.e.oc.log ${items_prefix}${var}.e.o))
	cat 1 | grep ^./libexte.a | grep -o '^[^ ]*' | grep -Po '(?<=\()[^\)]*' > 2
	for a in `cat 2`; do if [ -n "$$b" ]; then b="$$b $${a}c.log $$a"; else b="$${a}c.log $$a"; fi; done; echo $$b > 3
	${OSTRIP} ${name} ${strp} `cat 3`
	${strippy} ${name} ${libname} ${anotherobjcopy}
#if [ ! -e "./strip.py" ]; then wget https://raw.githubusercontent.com/colin-i/o/master/ostrip/strip.py; fi
endif

endif

${name}: ${obs} ${eobs}
	${OLINK} ${logs}
	$(AR) cr ${exte} ${obs}
	${ATLDCOM} > 1
# > 1 for ostrip
endif

%.o: %.oc
	${OCOMP} $< ${OFLAGS}
%.o: %.e.oc
	${OCOMP} $< ${OFLAGS}

ounused:
	${OLINK} ${logs}

compile: ${obs} ${eobs}

#noleadingunderscore for exporting symbols

#obs =   :in case it is called after an object (make bits link)
#(make action link)

def:
	../fix/makedef ${defname}

clean:
	-rm -f ${logs}
	-rm -f ${obs}
	-rm -f ${eobs}
	-rm -f ${exte}
	-rm -f ${libname}
	-rm -f ${name}
	-rm -f ${projname}.dll
	-rm -f ${defname}
	-rm -f 1 2 3
	-rm -f .data
	-rm -f .text
	-rm -f .rela.dyn
	-rm -f .symtab
	-rm -f .symtab_offset

distclean: clean

test:
	echo "Nothing"

install-lib:
	install -D ${libname} $(DESTDIR)$(prefix)/lib${install_number}/${libname}
	if [ -e ../include_dev ]; then \
		install -D ../dev/flags.oh $(DESTDIR)$(prefix)/include/${projname}/flags.oh && \
		install -D ../dev/flags.oh $(DESTDIR)$(prefix)/include/${projname}/flagss.oh && \
		install -D ../dev/importf.oh $(DESTDIR)$(prefix)/include/${projname}/importf.oh && \
		install -D ../dev/import.oh $(DESTDIR)$(prefix)/include/${projname}/import.oh && \
		install -D ../dev/actionswf.h $(DESTDIR)$(prefix)/include/${projname}/actionswf.h; \
	fi

install: all install-lib

uninstall:
	-rm -f $(DESTDIR)$(prefix)/lib${install_number}/${libname}
	-if [ -e ../include_dev ]; then \
		rm -f $(DESTDIR)$(prefix)/include/${projname}/flags.oh; \
		rm -f $(DESTDIR)$(prefix)/include/${projname}/flagss.oh; \
		rm -f $(DESTDIR)$(prefix)/include/${projname}/importf.oh; \
		rm -f $(DESTDIR)$(prefix)/include/${projname}/import.oh; \
		rm -f $(DESTDIR)$(prefix)/include/${projname}/actionswf.h; \
	fi

.PHONY: all compile ounused def install install-lib clean distclean uninstall test

.NOTPARALLEL:

#make compile && make link linkerflags= items_prefix=/home/bc/s/actionswf-1/src/ LD=/home/bc/Desktop/out/LD-.glibc2.27-x86_64.AppImage
#make linkerflags= conv_64=0
#make linkerflags= conv_64=0 link
