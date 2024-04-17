SHELL=/bin/bash
build: clean
	mkdir build
	$(CC) -o build/libelsa.so `find src/ -type f -iname '*.c'` -Iinclude -shared -fPIC $(CFLAGS)
	for file in `ls cli/*.c` ; do \
	    gcc $$file -o build/$$(basename $$file | sed "s/\.c//g") -Iinclude -Lbuild -lelsa $(CFLAGS);\
	done

clean:
	rm -rf build