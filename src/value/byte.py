
from error import info, warning, error
import hlir.type as type
from value.value import value_is_immediate
from util import nbits_for_num
from .value import value_cast, value_cast_immediate


def value_cons_byte_immediate(v, t, ti):
    if v['type']['width'] > t['width']:
        error("byte overflow", ti)

    return value_cast_immediate(v, t, ti)



def do_cons_byte(v, t, ti):
    if value_is_immediate(v):
        return value_cons_byte_immediate(v, t, ti)
    return value_cast(v, t, ti=ti)



def value_cons_byte(v, t, ti, method):
    from_type = v['type']

    # implicit casts
    if type.type_is_generic_integer(from_type):
        return value_cons_byte_immediate(v, t, ti)

    # explicit casts
    if method != 'explicit':
        info("cannot implicitly cons Byte value", ti)
        return None

    # Integer -> Byte
    if type.type_is_integer(from_type):
        return do_cons_byte(v, t, ti)

    # VA_List -> Byte
    elif type.type_is_va_list(from_type):
        return value_cast(v, t, ti)

    return None


