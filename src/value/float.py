

import hlir.type as type
from hlir.type import type_print
from error import error, warning, info
from hlir.value import *
from .value import *



def value_cons_float_immediate(v, t, ti):
    nv = hlir_value_cast_immediate(v, t, ti)
    nv['imm'] = float_value_pack(float(nv['imm']), t['width'])
    return nv


def do_cons_float(v, t, ti):
    if value_is_immediate(v):
        return value_cons_float_immediate(v, t, ti)
    return hlir_value_cast(v, t, ti=ti)


def value_cons_float(v, t, ti, method):
    vt = v['type']

    if type.type_is_generic(vt):
        # (GenericInt or GenericFloat) -> Float
        if type.type_is_integer(vt) or type.type_is_float(vt):
            return value_cons_float_immediate(v, t, ti)


    if method != 'explicit':
        info("cannot implicit cons Float value", ti)
        return None

	# Int -> Float
    if type.type_is_integer(vt):
        return do_cons_float(v, t, ti=ti)

    # Float -> Float
    elif type.type_is_float(vt):
        return do_cons_float(v, t, ti=ti)

    # VA_List -> Float
    elif type.type_is_va_list(vt):
        return hlir_value_cast(v, t, ti)

    return None





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

