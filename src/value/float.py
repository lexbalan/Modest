

import hlir.type as type
from hlir.type import type_print
from error import error, warning, info
from hlir.value import *
from .value import *



def value_cons_float_immediate(v, t, ti):
    #info("value_cons_float_immediate", ti)
    return hlir_value_cast_immediate(v, t, ti)



def value_cons_float(v, t, ti, method):
    vt = v['type']

    nv = None

    if type.is_generic(vt):
        if type.is_integer(vt) or type.is_float(vt):
            # (GenericInt or GenericFloat) -> Float
            nv = value_cons_float_immediate(v, t, ti)
            nv['imm'] = float_value_pack(float(nv['imm']), t['width'])
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

    elif type.is_va_list(vt):
        # VA_List -> Float
        nv = hlir_value_cast(v, t, ti)


    return nv





def float_value_pack(f_num, width):
    import struct
    z = 0
    if width == 32:
        z = struct.unpack('<f', struct.pack('<f', f_num))[0]
    elif width == 64:
        z = struct.unpack('<d', struct.pack('<d', f_num))[0]
    else:
        fatal("too big float, float_value_pack not implemented")

    return z

