
from error import info, warning, error
from util import nbits_for_num
import hlir.type as hlir_type
from hlir.type import type_print
from .value import value_terminal, value_is_immediate, value_cons_node, value_cons_immediate



def value_integer_create(num, typ=None, ti=None):
    if typ == None:
        typ = hlir_type.hlir_type_generic_int_for(num, signed=True, ti=ti)
    else:
        nbits = nbits_for_num(num)

        if nbits > typ['width']:
            print(nbits)
            print(typ)
            from error import error
            error("value size not corresponded type size", ti)
            return value_bad(ti)

    v = value_terminal(typ, num, ti)
    v['nsigns'] = 0  # add field nsigns
    v['immediate'] = True
    return v



warning_cast_data_loss = True


def _check_width(from_type, t, method, ti):
    rv = True

    if from_type['width'] > t['width']:
        if method == 'explicit':
            if warning_cast_data_loss:
                from main import features
                if not (features.get('unsafe') or features.get('unsafe-downcast')):
                    warning("value cons with potential data loss", ti)
                pass

        else:
            error("value cons with potential data loss", ti)
            rv = False

    if not rv:
        print("attempt to construct ", end='')
        type_print(t)
        print(" from ", end='')
        type_print(from_type)
        print()

    return rv



def _value_integer_cons_immediate(t, v, method, ti):
    #info("value_cons_int_immediate", ti)
    width = t['width']
    need_width = nbits_for_num(v['asset'])

    if need_width > width:
        error("integer overflow", ti)

    return value_cons_immediate(t, v, method, ti)



def _do_cons_integer(t, v, method, ti):
    _check_width(v['type'], t, method, ti)
    if value_is_immediate(v):
        if method == 'explicit':
            nv = value_cons_node(t, v, method, ti=ti)
            nv['asset'] = int(v['asset'])  # here can be float
            nv['immediate'] = True
            return nv
        return _value_integer_cons_immediate(t, v, method, ti)
    return value_cons_node(t, v, method, ti=ti)



def value_integer_cons(t, v, method, ti):
    from_type = v['type']

    if value_is_immediate(v):
        if hlir_type.type_is_generic_integer(from_type):
            # GenericInt -> Int
            _check_width(from_type, t, method, ti)

            if not t['signed']:
                if v['asset'] < 0:
                    return None

            return _do_cons_integer(t, v, method, ti)


    # runtime cast generic-integer to integer
    if hlir_type.type_is_generic_integer(from_type):
        return _do_cons_integer(t, v, method, ti)


    if method != 'explicit':
        info("cannot implicitly cons Int value", ti)
        return None

    # Int -> Int
    if hlir_type.type_is_integer(from_type):
        return _do_cons_integer(t, v, 'explicit', ti)

    # Float -> Int
    elif hlir_type.type_is_float(from_type):
        return _do_cons_integer(t, v, 'explicit', ti=ti)

    # Char -> Int
    elif hlir_type.type_is_char(from_type):
        return _do_cons_integer(t, v, 'explicit', ti)

    # Bool -> Int
    elif hlir_type.type_is_bool(from_type):
        return _do_cons_integer(t, v, 'explicit', ti)

    # Byte -> Int
    elif hlir_type.type_is_byte(from_type):
        return _do_cons_integer(t, v, 'explicit', ti)

    # Pointer -> Int
    elif hlir_type.type_is_pointer(from_type):
        from main import features
        if not (features.get('unsafe') or features.get("unsafe-ptr-to-int")):
            info("explicit typecast to pointer is forbidden in safe mode", ti)
            pass
        return _do_cons_integer(t, v, 'explicit', ti)

    # VA_List -> Int
    elif hlir_type.type_is_va_list(from_type):
        return value_cons_node(t, v, 'explicit', ti)

    return None


