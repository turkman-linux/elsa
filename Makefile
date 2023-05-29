build: clean
	meson setup build
	ninja -C build

run: clean build
	./build/elsa
clean:
	rm -rf build