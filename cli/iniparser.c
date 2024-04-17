#include <stdio.h>
#include <iniparser.h>
int main(int argc, char * argv[]) {
    if (argc < 3) {
        puts("iniparser [file.ini] [section] (variable)");
        return 1;
    }
    char * area = ini_get_area(readlines(argv[1]), argv[2]);
    int len;
    if (argc == 3) {
        char** val_names = ini_get_value_names(area, &len);
        for(int i=0;i<len;i++){
            printf("%d %s\n", i, val_names[i]);
        }
    }else {
        puts(ini_get_value(area, argv[3]));
    }
}
