
import hlir.type as type
from hlir.type import type_print
from error import error, warning, info
from hlir.value import *
from .value import *


no_warning_cast_data_loss = False


def check_width(vtype, t, method, ti):
    rv = True

    if vtype['width'] > t['width']:
        if method == 'explicit':
            if not no_warning_cast_data_loss:
                from main import features
                if not features.get('unsafe'):
                    warning("casting with potential data loss", ti)
                pass

        else:
            error("casting with potential data loss", ti)
            rv = False

    if not rv:
        type_print(vtype)
        print(" -> ", end="")
        type_print(t)
        print()

    return rv



def value_cons_integer_immediate(v, t, ti):
    #info("value_cons_int_immediate", ti)
    width = t['width']
    need_width = nbits_for_num(v['imm'])

    if need_width > width:
        error("integer overflow", ti)

    return hlir_value_cast_immediate(v, t, ti)



def do_cons_integer(v, t, method, ti):
    check_width(v['type'], t, method, ti)
    if value_is_immediate(v):
        if method == 'explicit':
            nv = hlir_value_cast(v, t, ti=ti)
            nv['imm'] = int(v['imm'])  # here can be float
            return nv
        return value_cons_integer_immediate(v, t, ti)
    return hlir_value_cast(v, t, ti=ti)



def value_cons_integer(v, t, ti, method):
    vtype = v['type']

    nv = None

    if type.type_is_generic_integer(vtype):
        # GenericInt -> Int
        check_width(vtype, t, method, ti)

        if not t['signed']:
            if v['imm'] < 0:
                return None

        nv = do_cons_integer(v, t, method, ti)


    if nv != None:
        return nv


    if method == 'explicit':

        # (Int or Char) -> Int
        if type.type_is_integer(vtype) or type.type_is_char(vtype) or type.type_is_bool(vtype):
            nv = do_cons_integer(v, t, method, ti)

        # Float -> Int
        elif type.type_is_float(vtype):
            nv = do_cons_integer(v, t, method, ti=ti)

        # Pointer -> Int
        elif type.type_is_pointer(vtype):
            nv = do_cons_integer(v, t, method, ti)

        # VA_List -> Int
        elif type.type_is_va_list(vtype):
            nv = hlir_value_cast(v, t, ti)

    return nv
