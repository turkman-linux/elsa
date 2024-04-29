#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include <dirent.h>

#include <module.h>
#include <environ.h>
#include <iniparser.h>


static update_fn update;
void set_update_function(update_fn up_new){
    update = up_new;
}

static bool is_available_module(char* name);
static int module_invoke(char* name);
static void module_init();
static int execute_piped(char* cmd);
static char* config;

char* module_path;
char* config_path;


int module_execute(char* name){
    module_init();
    if(!name || strlen(name) == 0){
        return 0;
    }
    if(!is_available_module(name)){
        return 2;
    }

    char* area = ini_get_area(config, name);
    char* fdeps = ini_get_value(area, "dependencies");
    char** deps = strsplit(fdeps, " ");
    for(int i=0;i<strcount(fdeps, " ");i++){
        int status = module_execute(deps[i]);
        if(status){
            return status;
        }
    }
    module_invoke(name);
}
static void module_init(){
    if(!update){
        update = (update_fn) puts;
    }

    if(!module_path){
        if(getenv("ELSA_MODULES")){
            module_path = getenv("ELSA_MODULES");
        }else {
            module_path = MODULE_PATH;
        }
        DIR* f = opendir(module_path);
        if(!f){
            printf("Module path %s is invalid!\n", module_path);
            return;
        }
        closedir(f);
        module_path = strdup(module_path);
    }
    if(!config_path){
        if(getenv("ELSA_CONFIG")){
            config_path = getenv("ELSA_CONFIG");
        } else {
            config_path = CONFIG_FILE;
        }
        FILE* f = fopen(config_path, "r");
        if(!f){
            printf("Config file %s is invalid!\n", config_path);
            return;
        }
        fclose(f);
        config_path = strdup(config_path);
    }
    if(!config) {
        config = readlines(config_path);
    }
}
static bool is_available_module(char* name){
    char module[PATH_MAX];
    strcpy(module, module_path);
    strcat(module, "/");
    strcat(module, name);
    FILE *fd = fopen(module, "r");
    if(fd == NULL){
        printf("Module %s is not available.\n  => %s\n",name, module);
        return false;
    }else {
        fclose(fd);
        return true;
    }
}

#define startswith(A, B) \
    strlen(A) >= strlen(B) && strncmp(A, B, strlen(A)) == 0
static int module_invoke(char* name){
    printf("Executing module => %s\n", name);
    char** envs = save_env();
    clear_env();
    char module[PATH_MAX];
    int len;
    char** sections = ini_get_section_names(config, &len);
    for(int i=0;i<len;i++){
        if(!startswith(sections[i], name)){
            continue;
        }
        char* area = ini_get_area(config, sections[i]);
        int llen;
        char** names = ini_get_value_names(area, &llen);
        for(int j=0;j<llen;j++){
            char envname[PATH_MAX];
            strcpy(envname, sections[i]);
            strcat(envname, "_");
            strcat(envname, names[j]);
            setenv(envname, ini_get_value(area, names[j]), 1);
        }
    }
    setenv("ELSA_CONFIG", config_path, 1);
    setenv("ELSA_MODULES", module_path, 1);
    strcpy(module, module_path);
    strcat(module, "/");
    strcat(module, name);
    int status = execute_piped(module);
    restore_env(envs);
    return status;
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

