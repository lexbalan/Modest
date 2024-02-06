
import hlir.type as type
from hlir.type import type_print
from error import error, warning, info
from hlir.value import *
from .value import *


no_warning_cast_data_loss = False


def check_width(from_type, t, method, ti):
    rv = True

    if from_type['width'] > t['width']:
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
        type_print(from_type)
        print(" -> ", end="")
        type_print(t)
        print()

    return rv



def value_cons_integer_immediate(v, t, ti):
    #info("value_cons_int_immediate", ti)
    width = t['width']
    need_width = nbits_for_num(v['asset'])

    if need_width > width:
        error("integer overflow", ti)

    return hlir_value_cast_immediate(v, t, ti)



def do_cons_integer(v, t, method, ti):
    check_width(v['type'], t, method, ti)
    if value_is_immediate(v):
        if method == 'explicit':
            nv = hlir_value_cast(v, t, ti=ti)
            nv['asset'] = int(v['asset'])  # here can be float
            return nv
        return value_cons_integer_immediate(v, t, ti)
    return hlir_value_cast(v, t, ti=ti)



def value_cons_integer(v, t, ti, method):
    from_type = v['type']

    if type.type_is_generic_integer(from_type):
        # GenericInt -> Int
        check_width(from_type, t, method, ti)

        if not t['signed']:
            if v['asset'] < 0:
                return None

        return do_cons_integer(v, t, method, ti)


    if method != 'explicit':
        info("cannot implicit cons Int value", ti)
        return None

	# Int -> Int
    if type.type_is_integer(from_type):
        return do_cons_integer(v, t, method, ti)

    # Float -> Int
    elif type.type_is_float(from_type):
        return do_cons_integer(v, t, method, ti=ti)

    # Char -> Int
    elif type.type_is_char(from_type):
        return do_cons_integer(v, t, method, ti)

    # Bool -> Int
    elif type.type_is_bool(from_type):
        return do_cons_integer(v, t, method, ti)

    # Byte -> Int
    elif type.type_is_byte(from_type):
        return do_cons_integer(v, t, method, ti)

    # Pointer -> Int
    elif type.type_is_pointer(from_type):
        return do_cons_integer(v, t, method, ti)

    # VA_List -> Int
    elif type.type_is_va_list(from_type):
        return hlir_value_cast(v, t, ti)

    return None


