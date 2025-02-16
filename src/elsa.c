#include <string.h>
#include <elsa.h>

update_fn update;

static char* config;

void set_config(char* cfg){
    config = strdup(cfg);
}

void set_update_function(update_fn up_new){
    update = up_new;
}
