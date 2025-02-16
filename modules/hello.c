#include <module.h>
#include <stdlib.h>
#include <stdio.h>

void hello(){
    puts("Hello World");
}

void hello_init(){
    Module *mod = malloc(sizeof(Module));
    mod->name = "hello";
    mod->action = hello;
}