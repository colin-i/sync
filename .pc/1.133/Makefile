TOPTARGETS := all install clean distclean uninstall test
#distclean is called for configures (unexistent here, then, is deprecated for us)

ifeq ($(shell dpkg-architecture -qDEB_HOST_ARCH), i386)
conv_64=1
else
conv_64=0
endif

SUBDIRS := src example oad

$(TOPTARGETS): $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ conv_64=${conv_64} $(MAKECMDGOALS)

test:
	RUN__SHELL=$(SHELL) . ./shl && cd tests && conv_64=${conv_64} RUN__SHELL="$${RUN__SHELL}" $${RUN__SHELL} ./as && conv_64=${conv_64} $${RUN__SHELL} ./c 1 && \
	cd ffdec && conv_64=${conv_64} RUN__SHELL="$${RUN__SHELL}" $${RUN__SHELL} ./as && \
	cd ../data && conv_64=${conv_64} RUN__SHELL="$${RUN__SHELL}" $${RUN__SHELL} ./test x && echo tests ok
clean:
	RUN__SHELL=$(SHELL) . ./shl && cd tests && $${RUN__SHELL} ./c && cd ffdec && $${RUN__SHELL} ./c && cd ../data && $${RUN__SHELL} ./c
install:
	install -D oaalternative $(DESTDIR)$(prefix)/bin/oaalternative
uninstall:
	-rm -f $(DESTDIR)$(prefix)/bin/oaalternative

.PHONY: $(TOPTARGETS) $(SUBDIRS)
.NOTPARALLEL:
