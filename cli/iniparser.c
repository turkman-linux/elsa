#include <stdio.h>
#include <iniparser.h>
int main(int argc, char * argv[]) {
    if (argc < 2) {
        puts("iniparser [file.ini] [section] (variable)");
        return 1;
    }
    int len;
    if (argc == 2) {
        char** sec_names = ini_get_section_names(readlines(argv[1]), &len);
        for(int i=0;i<len;i++){
            printf("%s\n", sec_names[i]);
        }
    } else if (argc == 3) {
        char * area = ini_get_area(readlines(argv[1]), argv[2]);
        char** val_names = ini_get_value_names(area, &len);
        for(int i=0;i<len;i++){
            printf("%s\n", val_names[i]);
        }
    }else {
        char * area = ini_get_area(readlines(argv[1]), argv[2]);
        puts(ini_get_value(area, argv[3]));
    }
}
