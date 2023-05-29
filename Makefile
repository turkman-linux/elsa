build: clean
	meson setup build
	ninja -C build

run: clean build
	./build/elsa-test
clean:
	rm -rf build