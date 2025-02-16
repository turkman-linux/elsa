#include <elsa.h>

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void aaa(char* msg){
    puts(msg);
}

int main(int argc, char** argv){
    for(int i=0;i<argc;i++){
        if(iseq(argv[i], "-c") && i<argc-1){
             set_config(argv[i+1]);
	      }
        if(iseq(argv[i], "-h")){
            puts("Usage: elsa <options>");
            puts("Options:");
            puts("  -h : print help message");
            puts("  -m /path/to/modules :  module path");
            puts("  -c /path/to/config  :  config file");
            return 0;
        }
    }
    set_update_function(aaa);
    return module_execute("main");
}
