#ifndef MODULE_PATH
#define MODULE_PATH "/lib/elsa/"
#endif
#ifndef PATH_MAX
#define PATH_MAX 1024
#endif


typedef void (*update_fn)(char*);
void set_update_function(update_fn up_new);

int module_execute(char* name);
