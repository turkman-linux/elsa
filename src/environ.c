#include <stdlib.h>
#include <string.h>

extern char **environ;
void clear_env(){
    system("env");
    char *path = strdup(getenv("PATH"));
    char *env[1];
    env[0] = NULL;
    environ = env;
    setenv("PATH", path, 1);
}

char** save_env(){
    int len = 0;
    while(environ[len]){
        len++;
    }
    char **ret = malloc((len+1)*sizeof(char*));
    len = 0;
    while(environ[len]){
        ret[len] = strdup(environ[len]);
        len++;
    }
    ret[len] = NULL;
    return ret;
}

void restore_env(char** envs){
    environ = envs;
}
