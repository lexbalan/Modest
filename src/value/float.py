
import settings
import hlir.type as type
from hlir.type import hlir_type_float, type_print
from error import error, warning, info
from .value import *



def value_float(num, ti=None):
    flt_width = int(settings.get('float_width'))
    typ = hlir_type_float(width=flt_width, ti=ti)
    typ['generic'] = True
    return hlir_value_literal(typ, num, ti)



def value_cons_float_immediate(v, t, ti):
    nv = hlir_value_cast_immediate(v, t, ti)
    nv['asset'] = float_value_pack(float(nv['asset']), t['width'])
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



# получаем 32 или 64 битное представление числа
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


