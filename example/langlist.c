#include <stdlib.h>
#include <stdio.h>
#include <elsa.h>

int main(int argc, char** argv){
    (void)argc; // -Werror=unused-parameter
    (void)argv; // -Werror=unused-parameter
    int numLayouts;
    LayoutInfo* layouts = get_keyboard_layouts(&numLayouts);
    for (int i = 0; i < numLayouts; i++) {
        printf("%s %s\n", layouts[i].name, layouts[i].description);
    }
    
    // Free layout information array
    free(layouts);

    return 0;
}
