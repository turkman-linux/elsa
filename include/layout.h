// Struct to hold layout information
typedef struct {
    char* name;
    char* description;
} LayoutInfo;

LayoutInfo* get_keyboard_layouts(int* len);
