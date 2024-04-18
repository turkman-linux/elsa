# Elsa installer
Simple and module installation tool
## build:
```
make
```

## testing
```
# for using libelsa
export LD_LIBRARY_PATH=$PWD/build
# for module path
export ELSA_MODULES=$PWD/example/
./build/test
```