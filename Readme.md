# Elsa (Efficient Linux Setup Assistant) installer
Simple and module based installation tool.
## build:
```
make
```

## testing
```bash
# for using libelsa
export LD_LIBRARY_PATH=$PWD/build
# for module path
./build/elsa -c example/elsa.conf -m example/
# Note: This will erase disk. You may loss your data!!!
```

## Using libelsa
Using libelsa with C
```C
#include <elsa.h>

void updater_func(char* msg){
     puts(msg);
}

int main(int argc, char** argv){
    set_update_function(updater_func);
    return module_execute("main");
}
```
