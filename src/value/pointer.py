
import hlir.type as type
from error import error, warning, info
from hlir.value import *
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
                return cons_ptr_to_str_from_generic_str(v, t, ti, method)


    if nv != None:
        return nv

    ### EXPLICIT REGION ###

    if method != 'explicit':
        info("cannot implicit cast different pointers", ti)
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

