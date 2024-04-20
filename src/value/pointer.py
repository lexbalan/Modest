
from error import info, warning, error
import hlir.type as type
from .value import value_cons_node, value_is_immediate, value_cons_node, value_cons_immediate
from .char import value_char_create
import foundation


def value_cons_pointer_immediate(t, v, method, ti):
    #info("value_cons_pointer_immediate", ti)
    return value_cons_immediate(t, v, method, ti)


def cons_ptr_to_str_from_generic_str(t, v, method, ti):
    #info("cons_ptr_to_str_from_generic_str", ti)
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
    # именно value_cons_node чтобы не пошел как immediate! тк *StrX это не immed
    nv = value_cons_node(t, v, method, ti=ti)
    nv['asset'] = s_imm
    # 'zstring' означает что строка должна быть нуль-терминирована
    # TODO: хотя - может это стоит переложить на бекенд? надо подумать
    nv['att'].append('zstring')
    module_strings_add(nv)
    return nv



def _do_cons_pointer(t, v, method, ti):
    if value_is_immediate(v):
        return value_cons_pointer_immediate(t, v, method, ti)
    return value_cons_node(t, v, method, ti=ti)



def value_cons_pointer(t, v, method, ti):
    vtype = v['type']
    to_type = t

    if type.type_is_pointer(vtype):
        v_pointer_to = vtype['to']

        # Implicit cons pointer from pointer

        from_type = v['type']

        # cons *[]X from *[n]X +
        if type.type_is_pointer_to_defined_array(from_type) and type.type_is_pointer_to_undefined_array(t):
            if type.type_eq(from_type['to']['of'], t['to']['of']):
                return _do_cons_pointer(t, v, method, ti)

        # cons *X from Nil
        if type.type_is_free_pointer(from_type):
            return _do_cons_pointer(t, v, method, ti)

        # cons FreePointer from *X
        if type.type_is_pointer(from_type):
            if type.type_is_free_pointer(t):
                return _do_cons_pointer(t, v, method, ti=ti)


    else:
        # implicit cons pointer from non-pointer value

        if type.type_is_generic_array_of_char(vtype):
            if type.type_is_pointer_to_array_of_char(to_type):
                return cons_ptr_to_str_from_generic_str(t, v, method, ti)


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
        return _do_cons_pointer(t, v, 'explicit', ti=ti)

    # Int -> Ptr
    elif type.type_is_integer(vtype):
        return _do_cons_pointer(t, v, 'explicit', ti=ti)

    # VA_List -> Ptr
    elif type.type_is_va_list(vtype):
        return value_cons_node(t, v, 'explicit', ti)


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
            char = value_char_create(char_code, _type=typeChar8, ti=None)
            chars8.append(char)
            i = i + 1

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
            char = value_char_create(char_code, _type=typeChar16, ti=None)
            chars16.append(char)

    return chars16



def str2utf32(string_items):
    # (python uses utf32 by default)
    typeChar32 = foundation.typeChar32

    chars32 = []
    for cc in string_items:
        chars32.append(cc)

    return chars32


