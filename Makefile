SHELL=/bin/bash

ELSA_OBJS=$(shell find src/ -type f -iname '*.c' | sed "s/\.c/.o/g")
CLI_OBJS=$(shell find cli/ -type f -iname '*.c' | sed "s/\.c/.o/g")


build: clean libelsa cli

%.o: %.c
	install -d $(shell dirname build/$@)
	$(CC) -c -fPIC -o build/$@ $< -Iinclude -g3

libelsa: $(ELSA_OBJS)
	cd build ; $(CC) $(ELSA_OBJS) -o libelsa.so -shared -fPIC $(CFLAGS) -nostdlib -lc

cli: libelsa $(CLI_OBJS)
	cd build ; for cli in $(CLI_OBJS) ; do \
	    $(CC) $$cli -o $$(basename $$cli | sed "s/\.o//g") -L. -lelsa ;\
	done

clean:
	rm -rf build

test: build
	env LD_LIBRARY_PATH=$$PWD/build \
	    ELSA_CONFIG=example/elsa.conf \
	    ELSA_MODULES=example/ \
	    $(gdb) ./build/elsa