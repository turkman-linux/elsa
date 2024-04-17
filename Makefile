SHELL=/bin/bash
build: clean
	mkdir build
	$(CC) -o build/libelsa.so `find src/ -type f -iname '*.c'` -Iinclude -shared -fPIC
	for file in `ls cli/*.c` ; do \
	    gcc $$file -o build/$$(basename $$file | sed "s/\.c//g") -Iinclude -Lbuild -lelsa;\
	done

clean:
	rm -rf build