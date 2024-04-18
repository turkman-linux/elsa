#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>

#include <module.h>
#include <environ.h>


static update_fn update;
void set_update_function(update_fn up_new){
    update = up_new;
}

static bool is_available_module(char* name);
static int execute_piped(char* cmd);
static char* module_path;

int module_execute(char* name){
    if(!update){
        update = (update_fn) puts;
    }

    if(!module_path){
        if(getenv("ELSA_MODULES")){
            module_path = getenv("ELSA_MODULES");
        }else {
            module_path = MODULE_PATH;
        }
    }
    if(!is_available_module(name)){
        return 2;
    }
    clear_env();
    printf("Executing module => %s\n", name);
    char module[PATH_MAX];
    strcpy(module, module_path);
    strcat(module, name);
    return execute_piped(module);
}



static int l;
static int execute_piped(char* cmd){
    FILE *pipe_fp;
    char buffer[1024*1024];

    if ((pipe_fp = popen(cmd, "r")) == NULL) {
        perror("popen");
        exit(EXIT_FAILURE);
    }

    while (fgets(buffer, BUFSIZ, pipe_fp) != NULL) {
        l = strlen(buffer);
        while(l > 0){
            if(buffer[l-1] == '\n'){
                buffer[l-1] = '\0';
                l--;
            } else {
                break;
            }
        }
        update(buffer);
    }
    int status = pclose(pipe_fp);
    if (status == -1) {
        perror("pclose");
        exit(EXIT_FAILURE);
    }
    return status;
}


static bool is_available_module(char* name){
    char module[PATH_MAX];
    strcpy(module, module_path);
    strcat(module, name);
    FILE *fd = fopen(module, "r");
    if(fd == NULL){
        printf("Module %s is not available.\n",name);
        return false;
    }else {
        fclose(fd);
        return true;
    }
}
