TOPTARGETS := all install clean distclean uninstall test

#ifndef test

ifeq ($(shell dpkg-architecture -qDEB_HOST_ARCH), amd64)
conv_64=0
else
conv_64=1
endif

SUBDIRS := src example

$(TOPTARGETS): $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ conv_64=${conv_64} $(MAKECMDGOALS)
.PHONY: $(TOPTARGETS) $(SUBDIRS)

.NOTPARALLEL:
