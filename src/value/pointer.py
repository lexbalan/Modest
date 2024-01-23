
import hlir.type as type
from error import error, warning, info
from hlir.value import *
from .value import *



def value_cons_pointer_immediate(v, t, ti):
    #info("value_cons_pointer_immediate", ti)
    return hlir_value_cast_immediate(v, t, ti)


def cons_ptr_to_str_from_generic_str(v, t, ti):
    from trans import module_strings_add

    char_pow = t['to']['of']['width']

    s_imm = []
    if char_pow == 8: s_imm = str2utf8(v['imm'])
    elif char_pow == 16: s_imm = str2utf16(v['imm'])
    elif char_pow == 32: s_imm = str2utf32(v['imm'])

    # получаем список кодов чаров для строки в целевой кодировке
    # из списка чар кодов в utf-32
    #s_imm = method(v['imm'])
    # массив кодов
    # длина полученной строки может отличаться от длины оригинала в utf-32
    nv = value_cons_pointer_immediate(v, t, ti=ti)
    nv['imm'] = s_imm
    module_strings_add(nv)

    return nv



def do_cons_pointer(v, t, ti):
    if value_is_immediate(v):
        return value_cons_pointer_immediate(v, t, ti)
    return hlir_value_cast(v, t, ti=ti)


def value_cons_pointer(v, t, ti, method):
    vtype = v['type']
    to_type = t

    nv = None

    if type.type_is_pointer(vtype):
        v_pointer_to = vtype['to']

        # Implicit cons pointer from pointer

        # implicit *Unit -> *Any
        if type.type_is_unit(v_pointer_to):
            nv = do_cons_pointer(v, t, ti)

        # implicit  *[n]Any -> *[]Any
        elif type.type_is_defined_array(v_pointer_to):
            if type.type_is_pointer_to_undefined_array(t):
                if type.type_eq(vtype['to']['of'], t['to']['of']):
                    nv = do_cons_pointer(v, t, ti)

        # implicit *Any -> *Unit
        elif type.type_is_free_pointer(t):
            nv = do_cons_pointer(v, t, ti)

    else:
        # implicit cons pointer from non-pointer value

        if type.type_is_generic_array_of_char(vtype):
            if type.type_is_pointer_to_array_of_char(to_type):
                return cons_ptr_to_str_from_generic_str(v, t, ti)


    if nv != None:
        return nv

    ### EXPLICIT REGION ###

    if method != 'explicit':
        info("cannot implicit cons Pointer value", ti)
        return None

    from main import features
    if not features.get('unsafe'):
        info("explicit typecast to pointer is forbidden in safe mode", ti)
        return None

    ### UNSAFE REGION ###

    # Ptr -> Ptr
    if type.type_is_pointer(vtype):
        nv = do_cons_pointer(v, t, ti=ti)

    # Int -> Ptr
    elif type.type_is_integer(vtype):
        nv = do_cons_pointer(v, t, ti=ti)

    # VA_List -> Int
    elif type.type_is_va_list(vtype):
        nv = do_cons_pointer(v, t, ti)

    return nv





def str2utf8(string_items):
    codes = []
    for cc in string_items:
        c = chr(cc)
        utf8_bytes = bytes(c, encoding='utf-8')
        i = 0
        while i < len(utf8_bytes):
            k = utf8_bytes[i]
            codes.append(k)
            i = i + 1

    codes.append(0)
    return codes



def str2utf16(string_items):
    codes = []
    for cc in string_items:
        c = chr(cc)
        utf16_bytes = bytes(c, encoding='utf-16')[2:]  # [2:] - skip BOM

        i = 0
        encode = 'big-endian'
        while i < len(utf16_bytes):
            first = utf16_bytes[i+0]
            second = utf16_bytes[i+1]
            k = 0
            if encode == 'big-endian':
                k = second * 256 + first
            else:
                k = first * 256 + second
            i = i + 2

            codes.append(k)

    codes.append(0)
    return codes



def str2utf32(string_items):
    # (python uses utf32 by default)
    codes = []
    for cc in string_items:
        codes.append(cc)
    codes.append(0)
    return codes


