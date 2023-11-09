
import type
from error import info, error
from hlir import hlir_value_cast, hlir_value_cast_immediate
from value.value import value_is_immediate
from util import nbits_for_num



def value_cons_char_immediate(v, t, ti):
    #info("value_cons_char_immediate", ti)
    power = t['power']
    imm = v['imm']
    v_power = v['type']['power']

    if v_power > power:
        error("char overflow", ti)

    return hlir_value_cast_immediate(v, t, ti)



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


