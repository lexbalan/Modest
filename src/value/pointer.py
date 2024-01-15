
import type
from type import type_print
from error import error, warning, info
from hlir import *
from .value import *



def value_cons_pointer_immediate(v, t, ti):
    #info("value_cons_pointer_immediate", ti)
    return hlir_value_cast_immediate(v, t, ti)



def hlir_string_imm_from_codes(codes, char_type):
    items = []

    for code in codes:
        char = hlir_value_literal(char_type, code, ti=None)
        items.append(char)

    # append Zero
    char = hlir_value_literal(char_type, 0, ti=None)
    items.append(char)

    return items


def str_literal(imm, charType, ti):
    items = hlir_string_imm_from_codes(imm, charType)
    vol = hlir_value_int(len(items))
    strType = hlir_type_array(charType, volume=vol, generic=True, ti=ti)
    return hlir_value_literal(strType, items, ti)



def cons_ptr_to_str_from_generic_str(v, t, ti, method):
    from util import str2utf8, str2utf16, str2utf32
    from trans import module_strings_add

    char_pow = t['to']['of']['width']

    method = str2utf8
    if char_pow == 16: method = str2utf16
    elif char_pow == 32: method = str2utf32

    # получаем список кодов чаров для строки в целевой кодировке
    # из списка чар кодов в utf-32
    s_imm = method(v['imm'])
    # массив кодов
    # длина полученной строки может отличаться от длины оригинала в utf-32
    nv = value_cons_pointer_immediate(v, t, ti=ti)
    nv['imm'] = s_imm
    module_strings_add(nv)

    return nv



def value_cons_pointer(v, t, ti, method):
    vtype = v['type']
    to_type = t

    nv = None

    # Nil -> *X
    if type.is_nil(vtype):
        nv = value_cons_pointer_immediate(v, t, ti)

    # GenericString -> *[]CharX
    elif type.is_generic_string(vtype):
        if type.is_pointer_to_string(to_type):
            s = cons_ptr_to_str_from_generic_str(v, t, ti, method)
            return s

    # *[n]X -> *[]X
    elif type.is_pointer_to_defined_array(vtype):
        if type.is_pointer_to_undefined_array(t):
            if type.eq(vtype['to']['of'], t['to']['of']):
                nv = hlir_value_cast(v, t, ti=ti)

    # Pointer -> *X
    elif type.is_free_pointer(vtype):
        nv = hlir_value_cast(v, t, ti=ti)

    # *X -> Pointer
    elif type.is_pointer(vtype):
        nv = hlir_value_cast(v, t, ti=ti)


    if nv != None:
        if value_is_immediate(v):
            nv['imm'] = v['imm']
        return nv


    if method != 'explicit':
        info("cannot implicit cast different pointers", ti)
        return None

    from main import features
    if not features.get('unsafe'):
        info("explicit typecast to pointer is forbidden in safe mode", ti)
        return None

    ### UNSAFE REGION ###

    # Ptr -> Ptr
    if type.is_pointer(vtype):
        nv = hlir_value_cast(v, t, ti=ti)

    # Int -> Ptr
    elif type.is_integer(vtype):
        if value_is_immediate(v):
            # compile-time casting
            nv = hlir_value_cast(v, t, ti=ti)
            nv['imm'] = v['imm']

        else:
            from trans import ptr_width
            if vtype['width'] > ptr_width:
                error("cons pointer from biggest integer", ti)
            nv = hlir_value_cast(v, t, ti=ti)

    elif type.is_va_list(vtype):
        # VA_List -> Int
        nv = hlir_value_cast(v, t, ti)


    if nv != None:
        if value_is_immediate(v):
            nv['imm'] = v['imm']

    return nv

