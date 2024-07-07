import ctypes

# Load the C library
elsa = ctypes.CDLL("libelsa.so")

# module.h
elsa.set_update_function.argtypes = [ctypes.CFUNCTYPE(None, ctypes.c_char_p)]
elsa.module_execute.argtypes = [ctypes.c_char_p]

# iniparser.h
elsa.ini_get_area.argtypes = [ctypes.c_char_p, ctypes.c_char_p]
elsa.ini_get_area.restype = ctypes.c_char_p

elsa.ini_get_value.argtypes = [ctypes.c_char_p, ctypes.c_char_p]
elsa.ini_get_value.restype = ctypes.c_char_p

elsa.ini_get_value_names.argtypes = [ctypes.c_char_p, ctypes.POINTER(ctypes.c_int)]
elsa.ini_get_value_names.restype = ctypes.POINTER(ctypes.c_char_p)

elsa.ini_get_section_names.argtypes = [ctypes.c_char_p, ctypes.POINTER(ctypes.c_int)]
elsa.ini_get_section_names.restype = ctypes.POINTER(ctypes.c_char_p)

elsa.readlines.argtypes = [ctypes.c_char_p]
elsa.readlines.restype = ctypes.c_char_p

# environ.h
clear_env = elsa.clear_env
clear_env.argtypes = []
clear_env.restype = None

save_env = elsa.save_env
save_env.argtypes = []
save_env.restype = ctypes.POINTER(ctypes.c_char_p)

restore_env = elsa.restore_env
restore_env.argtypes = [ctypes.POINTER(ctypes.c_char_p)]
restore_env.restype = None

# module.h
class module:
    def set_update_function(self, func):
        callback_func = ctypes.CFUNCTYPE(None, ctypes.c_char_p)(func)
        elsa.set_update_function(callback_func)

    def execute(self, name):
        return elsa.module_execute(name.encode("UTF-8"))

# iniparser.h
class ini:
    def get_area(self, ctx, name):
        return elsa.ini_get_area(ctx.encode(), name.encode()).decode()

    def get_value(self, ctx, name):
        return elsa.ini_get_value(ctx.encode(), name.encode()).decode()

    def get_value_names(self, ctx):
        length = ctypes.c_int()
        names_ptr = elsa.ini_get_value_names(ctx.encode(), ctypes.byref(length))
        names = [names_ptr[i].decode() for i in range(length.value)]
        return names

    def get_section_names(self, ctx):
        length = ctypes.c_int()
        names_ptr = elsa.ini_get_section_names(ctx.encode(), ctypes.byref(length))
        names = [names_ptr[i].decode() for i in range(length.value)]
        return names

def readlines(filename):
    return elsa.readlines(filename.encode()).decode()

# environ.h
# empty...

# layout.h
class VariantInfo(ctypes.Structure):
    _fields_ = [
        ("name", ctypes.c_char_p),
        ("description", ctypes.c_char_p)
    ]

class LayoutInfo(ctypes.Structure):
    _fields_ = [
        ("name", ctypes.c_char_p),
        ("description", ctypes.c_char_p),
        ("variants", ctypes.POINTER(VariantInfo)),
        ("numVariant", ctypes.c_int)
    ]

elsa.get_keyboard_layouts.restype = ctypes.POINTER(LayoutInfo)
elsa.get_keyboard_layouts.argtypes = [ctypes.POINTER(ctypes.c_int)]

# Define a wrapper function for get_keyboard_layouts
def get_keyboard_layouts():
    length = ctypes.c_int()
    layouts_ptr = elsa.get_keyboard_layouts(ctypes.byref(length))
    layouts = layouts_ptr[:length.value]
    return layouts
