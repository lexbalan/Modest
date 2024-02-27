
import hlir.type as type
from error import info, error
from util import nbits_for_num
from .value import value_literal, hlir_value_cast, hlir_value_cast_immediate



def value_char(char_code, _type=None, ti=None):
    if _type == None:
        # if type not specified, set type as GenericChar
        char_width = nbits_for_num(char_code)
        _type = type.hlir_type_char(char_width, ti=ti)
        _type['generic'] = True

    return value_literal(_type, char_code, ti)



def value_cons_char_immediate(v, t, ti):
    if v['type']['width'] > t['width']:
        info("char overflow", ti)

    return hlir_value_cast_immediate(v, t, ti)



def do_cons_char(v, t, ti):
    from value.value import value_is_immediate
    if value_is_immediate(v):
        return value_cons_char_immediate(v, t, ti)
    return hlir_value_cast(v, t, ti=ti)



def value_cons_char(v, t, ti, method):
    from_type = v['type']


    # Generic([1]GenericChar) -> Char
    # ex: var c: Char8 = "A"
    if type.type_is_generic_array_of_char(from_type):
        if from_type['volume']['asset'] == 2:
            # extract GenericChar item for next cast step (see below)
            v = v['asset'][0]
            from_type = v['type']


    # implicit casts
    if type.type_is_generic_char(from_type):
        return value_cons_char_immediate(v, t, ti)


    # explicit casts
    if method != 'explicit':
        info("cannot implicit cons Char value", ti)
        return None


    # Char -> Char
    if type.type_is_char(from_type):
        return do_cons_char(v, t, ti)

    # Integer -> Char
    elif type.type_is_integer(from_type):
        return do_cons_char(v, t, ti)

    # VA_List -> Char
    elif type.type_is_va_list(from_type):
        return hlir_value_cast(v, t, ti)

    #print("??")
    #from hlir.type import type_print
    #type_print(from_type)
    return None


