
import type
from type import type_print
from error import error, warning, info
from hlir import *
from util import float_align
from .value import *

from .char import value_cons_char
from .record import value_cons_record
from .array import value_cons_array
from .pointer import value_cons_pointer, cons_ptr_to_string_from_generic_string


no_warning_cast_data_loss = False



def cons_default(x, ti):
    from trans import typeSysInt, typeSysStr, typeSysFloat

    from_type = x['type']

    if not type.is_generic(from_type):
        return x

    if type.is_integer(from_type):
        return value_cons_integer(x, typeSysInt, ti, method='implicit')

    elif type.is_generic_string(from_type):
        return cons_ptr_to_string_from_generic_string(x, typeSysStr, ti, method='implicit')

    elif type.is_float(from_type):
        return value_cons_float(x, typeSysFloat, ti, method='implicit')

    else:
        fatal("unimplemented cons_default case")

    return hlir_value_bad(ti)




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






def value_cons_unit(v, t, ti, method):
    if method != 'explicit':
        return None

    return hlir_value_cast(v, t, ti=ti)




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


