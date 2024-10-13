TOPTARGETS := all install clean distclean uninstall test
#distclean is called for configures (unexistent here, then, is deprecated for us)

ifeq ($(shell dpkg-architecture -qDEB_HOST_ARCH), i386)
conv_64=1
else
conv_64=0
endif

SUBDIRS := src example
# oad

$(TOPTARGETS): $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ conv_64=${conv_64} $(MAKECMDGOALS)

test:
	cd tests && conv_64=${conv_64} /bin/bash ./as && conv_64=${conv_64} /bin/bash ./c 1 && cd ffdec && conv_64=${conv_64} /bin/bash ./as && echo tests ok
clean:
	cd tests; /bin/bash ./c; cd ffdec; /bin/bash ./c; cd ../data; /bin/bash ./c
install:
	install -D oaalternative $(DESTDIR)$(prefix)/bin/oaalternative
uninstall:
	-rm -f $(DESTDIR)$(prefix)/bin/oaalternative

.PHONY: $(TOPTARGETS) $(SUBDIRS)
.NOTPARALLEL:
