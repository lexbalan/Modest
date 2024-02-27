
import hlir.type as type
from error import info, error
from value.value import value_is_immediate
from util import nbits_for_num
from .value import value_cast, value_cast_immediate



def value_cons_bool_immediate(v, t, ti):
    if v['type']['width'] > t['width']:
        error("bool overflow", ti)

    return value_cast_immediate(v, t, ti)



def do_cons_bool(v, t, ti):
    if value_is_immediate(v):
        return value_cons_bool_immediate(v, t, ti)
    return value_cast(v, t, ti=ti)



def value_cons_bool(v, t, ti, method):
    from_type = v['type']


    # explicit casts
    if method != 'explicit':
        info("cannot implicitly cons Bool value", ti)
        return None

    # Integer -> Bool
    if type.type_is_integer(from_type):
        return do_cons_bool(v, t, ti)

    # Byte -> Bool
    elif type.type_is_byte(from_type):
        return do_cons_bool(v, t, ti)

    # VA_List -> Bool
    elif type.type_is_va_list(from_type):
        return value_cast(v, t, ti)

    return None


