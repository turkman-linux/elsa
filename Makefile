SHELL=/bin/bash

DESTDIR=/
PREFIX=/usr/local
LIBDIR=/lib
BINDIR=/bin

Deps=libxml-2.0

DepCFLAGS=$(shell pkg-config --cflags $(Deps)) -Wall -Wextra -Werror
DepLIBS=$(shell pkg-config --libs $(Deps))

ELSA_OBJS=$(shell find src modules -type f -iname '*.c' | sed "s/\.c/.o/g")
CLI_OBJS=$(shell find example/ cli/ -type f -iname '*.c' | sed "s/\.c/.o/g")


build: clean libelsa cli

%.o: %.c
	@install -d $(shell dirname build/$@)
	$(CC) -c -fPIC -Iinclude $(DepCFLAGS) -o build/$@ $< -Iinclude -g3

libelsa: $(ELSA_OBJS)
	cd build ; $(CC)  $(ELSA_OBJS) $(DepLIBS) -o libelsa.so -shared -fPIC $(CFLAGS)

cli: libelsa $(CLI_OBJS)
	cd build ; for cli in $(CLI_OBJS) ; do \
	    $(CC) $$cli -o $$(basename $$cli | sed "s/\.o//g") -L. -lelsa ;\
	done

clean:
	rm -rf build

install: libelsa cli
	install -Dm644 data/pkgconfig $(DESTDIR)/$(PREFIX)/$(LIBDIR)/pkgconfig/elsa.pc
	sed -i "s|@prefix@|$(PREFIX)|g" $(DESTDIR)/$(PREFIX)/$(LIBDIR)/pkgconfig/elsa.pc
	install -Dm644 data/icon.svg $(DESTDIR)/$(PREFIX)/share/icons/hicolor/scalable/apps/elsa.svg
	install -Dm755 build/libelsa.so $(DESTDIR)/$(PREFIX)/$(LIBDIR)
	install -Dm755 build/elsa $(DESTDIR)/$(PREFIX)/$(BINDIR)
	install -Dm755 include/*.h $(DESTDIR)/$(PREFIX)/include/elsa/

install_launcher:
	install -Dm755 data/application.desktop $(DESTDIR)/$(PREFIX)/share/applications/elsa.desktop
	sed -i "s|@BINDIR@|$(PREFIX)/$(BINDIR)|g" $(DESTDIR)/$(PREFIX)/share/applications/elsa.desktop

test: build
	env LD_LIBRARY_PATH=$$PWD/build \
	    $(gdb) ./build/elsa \
	        -m example \
	        -c example/elsa.conf
