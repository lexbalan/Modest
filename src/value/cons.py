
import type
from type import type_print
from error import error, warning, info
from hlir import *
from util import float_align
from .value import *

from .record import value_cons_record
from .array import value_cons_array


no_warning_cast_data_loss = False



def value_cons_char(v, t, ti, method):
    # implicit casts
    if type.is_generic_char(v['type']):
        return value_cons_generic(v, t, ti)


    # explicit casts
    if method != 'explicit':
        info("cannot implicit cons Char value", ti)
        return None


    if type.is_char(v['type']) or type.is_integer(v['type']):
        return hlir_value_cast(v, t, ti)


    return None



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
        nv = value_cons_generic(v, t, ti)

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



def value_cons_float(v, t, ti, method):
    vt = v['type']

    nv = None

    if type.is_generic(vt):
        if type.is_integer(vt) or type.is_float(vt):
            # (GenericInt or GenericFloat) -> Float
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



def value_cons_pointer(v, t, ti, method):
    vtype = v['type']
    to_type = t

    nv = None

    # Nil -> *X
    if type.is_nil(vtype):
        nv = value_cons_generic(v, t, ti)

    # GenericString -> (*[]CharX | *CharX)
    elif type.is_generic_string(vtype):
        if type.is_ptr_to_arr_of_char(to_type) or type.is_ptr_to_char(to_type):

            nv = value_cons_generic(v, t, ti=ti)
            nv['att'].append("string-cons")
            from trans import module_strings_add
            module_strings_add(nv)


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



def value_cons_unit(v, t, ti, method):
    if method != 'explicit':
        return None

    return hlir_value_cast(v, t, ti=ti)




def value_cons_generic(v, t, ti):
    #info("value_cons_generic", ti)

    nv = hlir_value_cast(v, t, ti)
    nv['kind'] = 'cast_generic'
    nv['imm'] = v['imm']

    if 'nl_end' in v:
        nv['nl_end'] = v['nl_end']

    # для generic приведения констант (!)
    if 'id' in v:
        nv['id'] = v['id']

    return nv



# возвращает None если не может привести (!)
# не принтует ошибку (но может info)
# это НЕ нужно для удобства приведения полей структур
def value_cons(v, t, ti, method):
    if value_is_bad(v) or type.is_bad(t):
        return None

    if type.eq(v['type'], t):
        return v

    cons = None
    if type.is_integer(t): cons = value_cons_integer
    elif type.is_pointer(t): cons = value_cons_pointer
    elif type.is_array(t): cons = value_cons_array
    elif type.is_record(t): cons = value_cons_record
    elif type.is_float(t): cons = value_cons_float
    elif type.is_char(t): cons = value_cons_char
    elif type.is_unit(t): cons = value_cons_unit

    nv = None

    if cons != None:
        nv = cons(v, t, ti, method)

    return nv




def value_cons_soft(v, t, ti):
    from value.cons import value_cons
    c = value_cons(v, t, ti, method='implicit')
    if c == None:
        return v
    return c



def value_cons_hard(v, t, ti):
    from value.cons import value_cons
    c = value_cons(v, t, ti, method='explicit')
    if c == None:
        error("cast error", ti)
        return hlir_value_bad(ti)
    return c



def value_cons_implicit(v, t, ti):
    if value_is_bad(v) or type.is_bad(t):
        return hlir_value_bad(ti)

    from_type = v['type']
    to_type = t

    # implisit cast possible only for:
    # 1. Generic -> NonGeneric
    # 2. Nil -> AnyPointer
    # 3. *[n]T -> *[]T
    # 4. AnyPointer -> FreePointer
    # 5. FreePointer -> AnyPointer

    #if not type.is_generic(from_type):
    #    return v

    # потому что в C номинальные типы, а у нас - структурные
    if type.is_record(t):
        if type.is_record(from_type):
            if 'name' in from_type and 'name' in t:
                if from_type['name'] != t['name']:
                    #info("impl cast record", ti)
                    return hlir_value_cast(v, t, ti=ti)


    if type.is_pointer_to_record(t):
        if type.is_pointer_to_record(from_type):
            #info("impl cast pointer to record", ti)
            return hlir_value_cast(v, t, ti=ti)


    if type.eq(from_type, t):
        return v


    if type.is_generic(from_type):
        return value_cons_soft(v, t, ti)


    if type.is_pointer(t):
        # cons *[]X from *[n]X
        if type.is_pointer_to_defined_array(from_type) and type.is_pointer_to_undefined_array(t):
            return value_cons_soft(v, t, ti)

        # cons *X from Nil
        if type.is_nil(from_type) and type.is_pointer(t):
            from .cons import value_cons_generic
            return value_cons_generic(v, t, ti)

        # cons *X from FreePointer
        if type.is_free_pointer(from_type) and type.is_pointer(t):
            return hlir_value_cast(v, t, ti=ti)

        # cons FreePointer from *X
        if type.is_pointer(from_type) and type.is_free_pointer(t):
            return hlir_value_cast(v, t, ti=ti)


    return v



def value_cons_explicit(v, t, ti):
    if value_is_bad(v) or type.is_bad(t):
        return hlir_value_bad(ti)

    if type.eq(v['type'], t):
        info("explicit cast to the same type", ti)
        return v

    return value_cons_hard(v, t, ti)


