build: clean
	meson setup build --prefix=/usr
	ninja -C build

install:
	ninja -C build install

run: clean build
	./build/elsa-test
clean:
	rm -rf build
