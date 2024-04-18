#include <module.h>
#include <stdio.h>

void aaa(char* msg){
    puts(msg);
}

int main(){
    set_update_function(aaa);
    return module_execute("main");
}
