
ifndef OCOMP
OCOMP=o
endif
ifndef OCONV
OCONV=otoc
endif

ifndef prefix
prefix=/usr
endif

all: flags.h flagss.h actionswf.oh

%.h: %.ohi
	${OCOMP} $< x_file 2 logfile 0
	${OCONV} $<.x
%.ohi: %.oh
	echo "format elfobj64" > $@
	echo "orphan off" >> $@
	echo "override include_sec 1" >> $@
	cat $< >> $@

actionswf.oh: action_swf.oh
	echo "include \"import.oh\"" > $@
	sed "s/^#//g" $< >> $@

test:
	echo dev
clean:
	-rm -f flags.ohi.x flagss.ohi.x flags.ohi flagss.ohi flags.h flagss.h actionswf.oh
distclean: clean

install:
	if [ -e ../include_dev ]; then \
		install -D flags.h $(DESTDIR)$(prefix)/include/actionswf/flags.h && \
		install -D flags.h $(DESTDIR)$(prefix)/include/actionswf/flagss.h && \
		install -D actionswf.oh $(DESTDIR)$(prefix)/include/actionswf/actionswf.oh; \
	fi
uninstall:
	-if [ -e ../include_dev ]; then \
		rm -f $(DESTDIR)$(prefix)/include/actionswf/flags.h; \
		rm -f $(DESTDIR)$(prefix)/include/actionswf/flagss.h; \
		rm -f $(DESTDIR)$(prefix)/include/actionswf/actionswf.oh; \
	fi

.PHONY: all install clean distclean uninstall test
