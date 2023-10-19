

import type
from type import type_print
from error import error, warning, info
from hlir import *
from .value import *



def value_cons_float(v, t, ti, method):
    vt = v['type']

    nv = None

    if type.is_generic(vt):
        if type.is_integer(vt) or type.is_float(vt):
            # (GenericInt or GenericFloat) -> Float
            from .cons import value_cons_generic
            nv = value_cons_generic(v, t, ti)
            nv['imm'] = float_align(nv['imm'], t['power'])
            return nv


    if method != 'explicit':
        info("cannot implicit cons Float value", ti)


    if type.is_float(vt):
        # Float -> Float
        nv = hlir_value_cast(v, t, ti=ti)

        if value_is_immediate(v):
            nv['imm'] = v['imm']

    elif type.is_integer(vt):
        # Int -> Float
        nv = hlir_value_cast(v, t, ti=ti)

        if value_is_immediate(v):
            nv['imm'] = v['imm']


    return nv


