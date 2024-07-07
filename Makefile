SHELL=/bin/bash

DESTDIR=/
PREFIX=/usr/local
LIBDIR=/lib
BINDIR=/bin

Deps=libxml-2.0

DepCFLAGS=$(shell pkg-config --cflags $(Deps)) -Wall -Wextra -Werror
DepLIBS=$(shell pkg-config --libs $(Deps))

ELSA_OBJS=$(shell find src/ -type f -iname '*.c' | sed "s/\.c/.o/g")
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
	chmod 755 modules/*
	mkdir -p $(DESTDIR)/$(PREFIX)/$(LIBDIR)/pkgconfig
	mkdir -p $(DESTDIR)/$(PREFIX)/include/elsa
	mkdir -p $(DESTDIR)/$(PREFIX)/$(BINDIR)
	mkdir -p $(DESTDIR)/$(PREFIX)/share/icons/hicolor/scalable/apps
	mkdir -p $(DESTDIR)/lib/elsa/
	install data/pkgconfig $(DESTDIR)/$(PREFIX)/$(LIBDIR)/pkgconfig/elsa.pc
	sed -i "s/@prefix@/$(PREFIX)/g" $(DESTDIR)/$(PREFIX)/$(LIBDIR)/pkgconfig/elsa.pc
	install data/icon.svg $(DESTDIR)/$(PREFIX)/share/icons/hicolor/scalable/apps/elsa.svg
	install build/libelsa.so $(DESTDIR)/$(PREFIX)/$(LIBDIR)
	install build/elsa $(DESTDIR)/$(PREFIX)/$(BINDIR)
	install modules/* $(DESTDIR)/lib/elsa/
	install include/* $(DESTDIR)/$(PREFIX)/include/elsa/

install_launcher:
	mkdir -p $(DESTDIR)/$(PREFIX)/share/applications
	install data/application.desktop $(DESTDIR)/$(PREFIX)/share/applications/elsa.desktop
	sed -i "s|@BINDIR@|$(PREFIX)/$(BINDIR)|g" $(DESTDIR)/$(PREFIX)/share/applications/elsa.desktop

test: build
	env LD_LIBRARY_PATH=$$PWD/build \
	    $(gdb) ./build/elsa \
	        -m example \
	        -c example/elsa.conf
