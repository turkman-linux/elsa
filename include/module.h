#ifndef MODULE_PATH
#define MODULE_PATH "/lib/elsa/"
#define CONFIG_FILE "/etc/elsa.conf"
#endif
#ifndef PATH_MAX
#define PATH_MAX 1024
#endif


typedef struct {
    char* name;
    void (*action)();
} Module;

int module_execute(char* name);
int execute_piped(char* cmd);
void add_module(Module *mod);

extern char* module_path;
extern char* config_path;
