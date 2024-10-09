
TOPTARGETS := install-proj clean distclean uninstall test

#NOOCONV ? is at debian/ocompiler.install , will install here but not in the final deb

ifeq ($(shell dpkg-architecture -qDEB_HOST_ARCH), amd64)
SUBDIRS := src ounused ostrip otoc
conv_64=0
else
SUBDIRS := src ounused otoc
conv_64=1
endif

#all must be first rule (rule: ...) to be executed in case of make with no args
all: $(SUBDIRS)
	$(MAKE) verify_comp_with_link

$(TOPTARGETS): $(SUBDIRS)

install:
	$(MAKE) all
	$(MAKE) install-proj
$(SUBDIRS):
	conv_64=${conv_64} $(MAKE) -C $@ $(MAKECMDGOALS)

verify_comp_with_link:
	cd ./src; ${launcher} ../ounused/ounused ./linux/obj.oc.log
version.h:
	s=`pwd`; cd ..; /bin/bash ./versionscript; cd ${s}

test:
	cd tests; /bin/bash ./tests

clean:
	-rm -f version.h
	cd tests; /bin/bash ./c

#phony only in this file not in subdirs, then can write extra for a PHONYTOPTARGETS
.PHONY: all install $(TOPTARGETS) $(SUBDIRS) verify_comp_with_link
.NOTPARALLEL:
