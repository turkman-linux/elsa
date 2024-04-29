# Elsa (Efficient Linux Setup Asistant) installer
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
Using libelsa with Python
```python
from elsa import module

def updater_func(msg):
    print(msg)

if __name__ == "__main__":
    module.set_update_function(updater_func)
    return module.execute("main")
```

