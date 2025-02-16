#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include <dirent.h>

#include <elsa.h>

static Module *mods[1024];
static int module_cur = 0;
static bool module_begin = false;

static void module_init();
extern void ctx_init();

extern update_fn update;

int module_execute(char* name){
    if(!module_begin){
        module_init();
        module_begin = true;
    }
    for (int i=0; i<module_cur; i++){
        if(strcmp(mods[i]->name, name) == 0){
            printf("Execting %s\n", name);
            mods[i]->action();
            break;
        }
    }
    return 0;
}
static void default_print(char* message){
    puts(message);
}

void add_module(Module *mod){
    mods[module_cur] = mod;
    module_cur++;
}

static void module_init(){
    if(!update){
        update = (update_fn) default_print;
    }
    ctx_init();
}
#define startswith(A, B) \
    strncmp(A, B, strlen(B)) == 0

static int l;
int execute_piped(char* cmd){
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

