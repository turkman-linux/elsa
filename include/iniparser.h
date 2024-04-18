char * ini_get_area(char * ctx, char * name);
char * ini_get_value(char * ctx, char * name);
char** ini_get_value_names(char* ctx, int* len);
char** ini_get_section_names(char* ctx, int* len);
char * readlines(const char * filename);

char ** strsplit(const char * s, const char * delim);
int strcount(char * buf, char * c);
