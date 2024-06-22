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
	cd tests && conv_64=${conv_64} /bin/bash ./as && conv_64=${conv_64} /bin/bash ./c 1 && cd ffdec && /bin/bash ./as && echo tests ok

.NOTPARALLEL:
