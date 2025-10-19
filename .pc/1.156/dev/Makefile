
ifndef OCOMP
OCOMP=o
endif
ifndef OCONV
OCONV=otoc
endif

ifndef prefix
prefix=/usr
endif

all: flags.h flagss.h flagss.oh actionswf.oh

%.h: %.ohi
	${OCOMP} $< x_file 2 logfile 0
	${OCONV} $<.x
flags.ohi: flags.oh
	echo "format elfobj64" > $@
	echo "orphan off" >> $@
	cat $< >> $@
flagss.ohi: flags_s.oh
	echo "format elfobj64" > $@
	echo "orphan off" >> $@
	echo "override include_sec 1" >> $@
	echo include \"flags.h\" \"flags.oh\" >> $@
	cat $< >> $@
flagss.oh: flags_s.oh
	echo include \"flags.oh\" > $@
	cat $< >> $@
actionswf.oh: action_swf.oh
	echo "include \"import.oh\"" > $@
	sed "s/^#//g" $< >> $@

test:
	echo dev
clean:
	-rm -f flags.ohi.x flagss.ohi.x flags.ohi flagss.ohi flags.h flagss.h  flagss.oh actionswf.oh
distclean: clean

install:
	if [ -e ../include_dev ]; then \
		install -D flags.h $(DESTDIR)$(prefix)/include/actionswf/flags.h && \
		install -D flagss.h $(DESTDIR)$(prefix)/include/actionswf/flagss.h && \
		install -D actionswf.h $(DESTDIR)$(prefix)/include/actionswf/actionswf.h && \
		install -D flags.oh $(DESTDIR)$(prefix)/include/actionswf/flags.oh && \
		install -D flagss.oh $(DESTDIR)$(prefix)/include/actionswf/flagss.oh && \
		install -D importf.oh $(DESTDIR)$(prefix)/include/actionswf/importf.oh && \
		install -D import.oh $(DESTDIR)$(prefix)/include/actionswf/import.oh && \
		install -D actionswf.oh $(DESTDIR)$(prefix)/include/actionswf/actionswf.oh; \
	fi
uninstall:
	-if [ -e ../include_dev ]; then \
		rm -f $(DESTDIR)$(prefix)/include/actionswf/flags.h; \
		rm -f $(DESTDIR)$(prefix)/include/actionswf/flagss.h; \
		rm -f $(DESTDIR)$(prefix)/include/actionswf/actionswf.h; \
		rm -f $(DESTDIR)$(prefix)/include/actionswf/flags.oh; \
		rm -f $(DESTDIR)$(prefix)/include/actionswf/flagss.oh; \
		rm -f $(DESTDIR)$(prefix)/include/actionswf/importf.oh; \
		rm -f $(DESTDIR)$(prefix)/include/actionswf/import.oh; \
		rm -f $(DESTDIR)$(prefix)/include/actionswf/actionswf.oh; \
	fi

.PHONY: all install clean distclean uninstall test
