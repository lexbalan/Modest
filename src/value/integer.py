
import type
from type import type_print
from error import error, warning, info
from hlir import *
from .value import *


no_warning_cast_data_loss = False


def check_power(vtype, t, method, ti):
    rv = True

    if vtype['power'] > t['power']:
        if method == 'explicit':
            if not no_warning_cast_data_loss:
                warning("casting with data loss", ti)

        else:
            error("casting with data loss", ti)
            rv = False

    if not rv:
        type_print(vtype)
        print(" -> ", end="")
        type_print(t)
        print()

    return rv



def value_cons_integer(v, t, ti, method):
    vtype = v['type']

    nv = None

    if type.is_generic_integer(vtype):
        # GenericInt -> Int
        check_power(vtype, t, method, ti)
        from .cons import value_cons_from_generic
        nv = value_cons_from_generic(v, t, ti)

    if nv != None:
        if value_is_immediate(v):
            nv['imm'] = v['imm']
        return nv


    if method != 'explicit':
        info("cannot implicit cons Integer value", ti)
        return None


    if type.is_integer(vtype) or type.is_char(vtype):
        # (Int or Char) -> Int
        check_power(vtype, t, method, ti)
        nv = hlir_value_cast(v, t, ti)

    elif type.is_float(vtype):
        # Float -> Int
        nv = hlir_value_cast(v, t, ti=ti)
        # need float imm int part check
        if value_is_immediate(v):
            imm_fltval = v['imm']
            imm_intval = int(imm_fltval)
            typ = hlir_type_generic_int_for(imm_intval, unsigned=True, ti=ti)
            check_power(typ, t, method, ti)
            nv['imm'] = imm_intval
            return v # (!)


    if nv != None:
        if value_is_immediate(v):
            nv['imm'] = v['imm']

    return nv
