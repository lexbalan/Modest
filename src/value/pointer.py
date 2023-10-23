
import type
from type import type_print
from error import error, warning, info
from hlir import *
from util import float_align
from .value import *


def cons_ptr_to_string_from_generic_string(v, t, ti, method):
    from .cons import value_cons_from_generic
    nv = value_cons_from_generic(v, t, ti=ti)
    nv['att'].append("string-cons")
    from trans import module_strings_add
    module_strings_add(nv)
    return nv



def value_cons_pointer(v, t, ti, method):
    vtype = v['type']
    to_type = t

    nv = None

    # Nil -> *X
    if type.is_nil(vtype):
        from .cons import value_cons_from_generic
        nv = value_cons_from_generic(v, t, ti)

    # GenericString -> (*[]CharX | *CharX)
    elif type.is_generic_string(vtype):
        if type.is_ptr_to_arr_of_char(to_type) or type.is_ptr_to_char(to_type):
            nv = cons_ptr_to_string_from_generic_string(v, t, ti, method)


    # *[n]X -> *[]X
    elif type.is_pointer_to_defined_array(vtype):
        if type.is_pointer_to_undefined_array(t):
            if type.eq(vtype['to']['of'], t['to']['of']):
                nv = hlir_value_cast(v, t, ti=ti)

    # Pointer -> *X
    elif type.is_free_pointer(vtype):
        nv = hlir_value_cast(v, t, ti=ti)

    # *X -> Pointer
    elif type.is_pointer(vtype):
        nv = hlir_value_cast(v, t, ti=ti)


    if nv != None:
        if value_is_immediate(v):
            nv['imm'] = v['imm']
        return nv


    if method != 'explicit':
        info("cannot implicit cast different pointers", ti)
        return None

    from main import features
    if not features.get('unsafe'):
        info("explicit typecast to pointer is forbidden in safe mode", ti)
        return None

    ### UNSAFE REGION ###

    # Ptr -> Ptr
    if type.is_pointer(vtype):
        nv = hlir_value_cast(v, t, ti=ti)

    # Int -> Ptr
    elif type.is_integer(vtype):
        if value_is_immediate(v):
            # compile-time casting
            nv = hlir_value_cast(v, t, ti=ti)
            nv['imm'] = v['imm']

        else:
            from trans import ptr_size
            if vtype['power'] > ptr_size:
                error("cons pointer from biggest integer", ti)
            nv = hlir_value_cast(v, t, ti=ti)

    # GenericString -> *CharX (only for C capability)
    elif type.is_generic_string(vtype):
        if type.is_char(to_type['to']):
            # GenericString -> *CharX
            #str_used_as(string_value=v, typ=to_type['to'])
            nv = hlir_value_cast(v, t, ti=ti) #?!


    if nv != None:
        if value_is_immediate(v):
            nv['imm'] = v['imm']

    return nv

