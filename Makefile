SHELL=/bin/bash

DESTDIR=/
PREFIX=/usr/local
LIBDIR=/lib
BINDIR=/bin

ELSA_OBJS=$(shell find src/ -type f -iname '*.c' | sed "s/\.c/.o/g")
CLI_OBJS=$(shell find cli/ -type f -iname '*.c' | sed "s/\.c/.o/g")


build: clean libelsa cli

%.o: %.c
	install -d $(shell dirname build/$@)
	$(CC) -c -fPIC -o build/$@ $< -Iinclude -g3

libelsa: $(ELSA_OBJS)
	cd build ; $(CC) $(ELSA_OBJS) -o libelsa.so -shared -fPIC $(CFLAGS)

cli: libelsa $(CLI_OBJS)
	cd build ; for cli in $(CLI_OBJS) ; do \
	    $(CC) $$cli -o $$(basename $$cli | sed "s/\.o//g") -L. -lelsa ;\
	done

clean:
	rm -rf build

install: libelsa cli
	mkdir -p $(DESTDIR)/$(PREFIX)/$(LIBDIR)
	mkdir -p $(DESTDIR)/$(PREFIX)/$(BINDIR)
	mkdir -p $(DESTDIR)/$(PREFIX)/share/icons/hicolor/scalable/apps
	mkdir -p $(DESTDIR)/lib/elsa/
	install data/icon.svg $(DESTDIR)/$(PREFIX)/share/icons/hicolor/scalable/apps/elsa.svg
	install build/libelsa.so $(DESTDIR)/$(PREFIX)/$(LIBDIR)
	install build/elsa $(DESTDIR)/$(PREFIX)/$(BINDIR)
	install modules/* $(DESTDIR)/lib/elsa/

install_launcher:
	mkdir -p $(DESTDIR)/$(PREFIX)/share/applications
	install data/application.desktop $(DESTDIR)/$(PREFIX)/share/applications/elsa.desktop
	sed -i "s|@BINDIR@|$(PREFIX)/$(BINDIR)|g" $(DESTDIR)/$(PREFIX)/share/applications/elsa.desktop

test: build
	env LD_LIBRARY_PATH=$$PWD/build \
	    $(gdb) ./build/elsa \
	        -m example \
	        -c example/elsa.conf
