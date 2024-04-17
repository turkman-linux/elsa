#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>

#include <module.h>

static bool is_available_module(char* name);

int module_execute(char* name){
    if(!is_available_module(name)){
        return 2;
    }
}

static bool is_available_module(char* name){
    char module[PATH_MAX];
    strcpy(module, MODULE_PATH);
    strcat(module, name);
    FILE *fd = fopen(module, "r+");
    if(fd == NULL){
        printf("Module %s is not available.\n",name);
        return false;
    }else {
        fclose(fd);
        free(fd);
        return true;
    }
}