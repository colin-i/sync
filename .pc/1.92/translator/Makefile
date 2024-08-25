
ifndef OCOMP
OCOMP=o
endif
ifndef OLINK
OLINK=ounused
endif
ifndef OCONV
OCONV=otoc
endif
ifndef linkerflags
linkerflags=-O3 -s
endif

OFLAGS=x_file 2

proj=oatouch

all: ${proj}

${proj}: main.o
	${OLINK} main.oc.log
	@echo
	$(CC) ${linkerflags} $< -o ${proj}
	# `pkg-config --libs gtk4`

%.o: %.oc
	${OCOMP} $< ${OFLAGS}
	${OCONV} $<.x
	$(CC) -c $*.c

clean:
	-rm -f main.o
	-rm -f main.oc.log
	-rm -f main.oc.x
	-rm -f main.c
	-rm -f ${proj}
