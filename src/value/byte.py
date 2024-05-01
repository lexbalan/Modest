
from error import info, warning, error
import hlir.type as type
from value.value import value_is_immediate
from util import nbits_for_num
from .value import value_cons_node, value_cons_immediate


def _value_byte_cons_immediate(t, v, method, ti):
    if v['type']['width'] > t['width']:
        error("byte overflow", ti)

    return value_cons_immediate(t, v, method, ti)



def _do_cons_byte(t, v, method, ti):
    if value_is_immediate(v):
        return _value_byte_cons_immediate(t, v, method, ti)
    return value_cons_node(t, v, method, ti=ti)



def value_byte_cons(t, v, method, ti):
    from_type = v['type']

    # implicit casts
    if type.type_is_generic_integer(from_type):
        return _value_byte_cons_immediate(t, v, method, ti)

    # explicit casts
    if method != 'explicit':
        info("cannot implicitly cons Byte value", ti)
        return None

    # Integer -> Byte
    if type.type_is_integer(from_type):
        return _do_cons_byte(t, v, 'explicit', ti)

    # VA_List -> Byte
    elif type.type_is_va_list(from_type):
        return value_cons_node(t, v, 'explicit', ti)

    return None


