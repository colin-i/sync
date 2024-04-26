TOPTARGETS := all install clean distclean uninstall test

#ifndef test

ifeq ($(shell dpkg-architecture -qDEB_HOST_ARCH), i386)
conv_64=1
else
conv_64=0
endif

SUBDIRS := src example

$(TOPTARGETS): $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ conv_64=${conv_64} $(MAKECMDGOALS)
.PHONY: $(TOPTARGETS) $(SUBDIRS)

test:
	cd tests && /bin/bash conv_64=${conv_64} ./as && /bin/bash ./c 1 && echo tests ok

.NOTPARALLEL:
