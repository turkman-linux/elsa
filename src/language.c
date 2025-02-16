#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <libintl.h>
#include <locale.h>

static bool language_init = false;

char* get_locale_string(char* domain, char* locale, char* msg){
    (void)domain;
    (void)locale;
    if(!language_init){
        language_init = true;
        setlocale(LC_ALL,"");
        bindtextdomain ("xkeyboard-config", "/usr/share/locale");
        textdomain ("xkeyboard-config");
    }
    //char* lang = strdup(getenv("LANG"));
    //setenv("LANG", locale, 1);
    char* ret = strdup(gettext(msg));
    //setenv("LANG", lang, 1);
    return ret;
} 

char* get_language_name(char* locale, char* msg){

    return get_locale_string("xkeyboard-config", locale, msg);
}