
import type
from error import info
from hlir import hlir_value_cast
from value.value import value_is_immediate


def value_cons_char(v, t, ti, method):

    # implicit casts
    if type.is_generic_char(v['type']):
        from .cons import value_cons_from_immediate
        return value_cons_from_immediate(v, t, ti)


    # explicit casts
    if method != 'explicit':
        info("cannot implicit cons Char value", ti)
        return None


    if type.is_char(v['type']) or type.is_integer(v['type']):
        if value_is_immediate(v):
            from .cons import value_cons_from_immediate
            return value_cons_from_immediate(v, t, ti)

        return hlir_value_cast(v, t, ti)


    return None


