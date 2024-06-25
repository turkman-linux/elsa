typedef struct {
    char* name;
    char* description;
} VariantInfo;

// Struct to hold layout information
typedef struct {
    char* name;
    char* description;
    VariantInfo* variants;
    int numVariant;
} LayoutInfo;

LayoutInfo* get_keyboard_layouts(int* len);
