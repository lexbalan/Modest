
from error import info, warning, error
import hlir.type as type
from .value import value_cast, value_is_immediate, value_cast, value_cast_immediate
from .char import value_char
import foundation


def value_cons_pointer_immediate(v, t, ti):
    #info("value_cons_pointer_immediate", ti)
    return value_cast_immediate(v, t, ti)


def cons_ptr_to_str_from_generic_str(v, t, ti):
    from trans import module_strings_add

    char_pow = t['to']['of']['width']

    s_imm = []
    if char_pow == 8: s_imm = str2utf8(v['asset'])
    elif char_pow == 16: s_imm = str2utf16(v['asset'])
    elif char_pow == 32: s_imm = str2utf32(v['asset'])

    # получаем список кодов чаров для строки в целевой кодировке
    # из списка чар кодов в utf-32
    #s_imm = method(v['asset'])
    # массив кодов
    # длина полученной строки может отличаться от длины оригинала в utf-32
    nv = value_cons_pointer_immediate(v, t, ti=ti)
    nv['asset'] = s_imm
    module_strings_add(nv)

    return nv



def do_cons_pointer(v, t, ti):
    if value_is_immediate(v):
        return value_cons_pointer_immediate(v, t, ti)
    return value_cast(v, t, ti=ti)



def value_cons_pointer(v, t, ti, method):
    vtype = v['type']
    to_type = t

    if type.type_is_pointer(vtype):
        v_pointer_to = vtype['to']

        # Implicit cons pointer from pointer

        from_type = v['type']

        # cons *[]X from *[n]X +
        if type.type_is_pointer_to_defined_array(from_type) and type.type_is_pointer_to_undefined_array(t):
            if type.type_eq(from_type['to']['of'], t['to']['of']):
                return do_cons_pointer(v, t, ti)

        # cons *X from Nil
        if type.type_is_free_pointer(from_type):
            return do_cons_pointer(v, t, ti)

        # cons FreePointer from *X
        if type.type_is_pointer(from_type):
            if type.type_is_free_pointer(t):
                return do_cons_pointer(v, t, ti=ti)


    else:
        # implicit cons pointer from non-pointer value

        if type.type_is_generic_array_of_char(vtype):
            if type.type_is_pointer_to_array_of_char(to_type):
                return cons_ptr_to_str_from_generic_str(v, t, ti)


    ### EXPLICIT REGION ###

    if method != 'explicit':
        info("cannot implicitly cons Pointer value", ti)
        return v

    from main import features
    if not (features.get('unsafe') or features.get('unsafe-int-to-ptr')):
        info("explicit typecast pointer to integer is forbidden in safe mode", ti)
        return None

    ### UNSAFE REGION ###

    # Ptr -> Ptr
    if type.type_is_pointer(vtype):
        return do_cons_pointer(v, t, ti=ti)

    # Int -> Ptr
    elif type.type_is_integer(vtype):
        return do_cons_pointer(v, t, ti=ti)

    # VA_List -> Ptr
    elif type.type_is_va_list(vtype):
        return value_cast(v, t, ti)


    return None





def str2utf8(string_items):
    chars8 = []
    typeChar8 = foundation.typeChar8

    for cc in string_items:
        c = chr(cc['asset'])
        utf8_bytes = bytes(c, encoding='utf-8')
        i = 0
        while i < len(utf8_bytes):
            k = utf8_bytes[i]

            char_code = k
            char = value_char(char_code, _type=typeChar8, ti=None)
            chars8.append(char)
            i = i + 1

    z = 0
    chars8.append(value_char(z, _type=typeChar8, ti=None))
    return chars8



def str2utf16(string_items):
    chars16 = []

    typeChar16 = foundation.typeChar16

    for cc in string_items:
        c = chr(cc['asset'])
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

            char_code = k
            char = value_char(char_code, _type=typeChar16, ti=None)
            chars16.append(char)

    z = 0
    chars16.append(value_char(z, _type=typeChar16, ti=None))
    return chars16



def str2utf32(string_items):
    # (python uses utf32 by default)
    typeChar32 = foundation.typeChar32

    chars32 = []
    for cc in string_items:
        chars32.append(cc)

    z = 0
    chars32.append(value_char(z, _type=typeChar32, ti=None))

    return chars32


