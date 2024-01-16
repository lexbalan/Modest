
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




def value_cons_integer(v, t, ti, method):
    vtype = v['type']

    nv = None

    if type.is_generic_integer(vtype):
        # GenericInt -> Int
        check_width(vtype, t, method, ti)

        if not t['signed']:
            if v['imm'] < 0:
                return None

        nv = value_cons_integer_immediate(v, t, ti)


    if method == 'explicit':

        if type.is_integer(vtype) or type.is_char(vtype) or type.is_bool(vtype):
            # (Int or Char) -> Int
            check_width(vtype, t, method, ti)
            nv = hlir_value_cast(v, t, ti)

        elif type.is_float(vtype):
            # Float -> Int
            nv = hlir_value_cast(v, t, ti=ti)
            # need float imm int part check
            if value_is_immediate(v):
                imm_fltval = v['imm']
                imm_intval = int(imm_fltval)
                typ = hlir_type_generic_int_for(imm_intval, unsigned=True, ti=ti)
                check_width(typ, t, method, ti)
                nv['imm'] = imm_intval
                return v  # (!)

        elif type.is_pointer(vtype):
            # Pointer -> Int
            nv = hlir_value_cast(v, t, ti)

        elif type.is_va_list(vtype):
            # VA_List -> Int
            nv = hlir_value_cast(v, t, ti)


    if nv != None:
        if value_is_immediate(v):
            nv['imm'] = v['imm']

    return nv
