
p=wstbld

all: ${p}
${p}:
	RUN__SHELL=$(SHELL) . ./shl && $${RUN__SHELL} ./mk
install:
	install -D ${p} $(DESTDIR)$(prefix)/bin/${p}
clean:
	RUN__SHELL=$(SHELL) . ./shl && $${RUN__SHELL} ./mkc
distclean: clean
uninstall:
	-rm -f $(DESTDIR)$(prefix)/bin/${p}
test:
	echo ok

.PHONY: all install clean distclean uninstall test
