#ifndef _elsa_h
#define _elsa_h
#include <module.h>
#include <environ.h>
#include <iniparser.h>
#include <layout.h>
#include <language.h>

typedef void (*update_fn)(char*);
void set_update_function(update_fn up_new);

void set_config(char* cfg);

#endif
