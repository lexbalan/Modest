
import hlir.type as type
from error import info, error
from hlir.value import hlir_value_cast, hlir_value_cast_immediate
from value.value import value_is_immediate
from util import nbits_for_num



def value_cons_char_immediate(v, t, ti):
    #info("value_cons_char_immediate", ti)
    width = t['width']
    imm = v['imm']
    v_width = v['type']['width']

    if v_width > width:
        error("char overflow", ti)

    return hlir_value_cast_immediate(v, t, ti)



def do_cons_char(v, t, ti):
    if value_is_immediate(v):
        return value_cons_char_immediate(v, t, ti)
    return hlir_value_cast(v, t, ti=ti)



def value_cons_char(v, t, ti, method):
    vtype = v['type']

    # implicit casts
    if type.type_is_generic_char(vtype):
        return value_cons_char_immediate(v, t, ti)


    # explicit casts
    if method != 'explicit':
        info("cannot implicit cons Char value", ti)
        return None

    # (Char or Integer) -> Char
    if type.type_is_char(vtype) or type.type_is_integer(vtype):
        return do_cons_char(v, t, ti)

    # VA_List -> Char
    elif type.type_is_va_list(vtype):
        return hlir_value_cast(v, t, ti)


    return None


