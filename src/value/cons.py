
import type
from type import type_print
from error import error, warning, info
from hlir import *
from util import float_align
from .value import *

from .unit import value_cons_unit
from .char import value_cons_char, value_cons_char_immediate
from .integer import value_cons_integer, value_cons_integer_immediate
from .float import value_cons_float, value_cons_float_immediate
from .record import value_cons_record, value_cons_record_immediate
from .array import value_cons_array, value_cons_array_immediate
from .pointer import value_cons_pointer, value_cons_pointer_immediate, cons_ptr_to_str_from_generic_str



# конструирование из immediate значения
# при этом проверяется разрядность (!)
def value_cons_from_immediate(v, t, ti):
    #info("value_cons_from_immediate", ti)

    if type.is_integer(t):
        return value_cons_integer_immediate(v, t, ti)
    elif type.is_float(t):
        return value_cons_float_immediate(v, t, ti)
    elif type.is_record(t):
        return value_cons_record_immediate(v, t, ti)
    elif type.is_array(t):
        return value_cons_array_immediate(v, t, ti)
    elif type.is_char(t):
        return value_cons_char_immediate(v, t, ti)
    elif type.is_pointer(t):
        return value_cons_pointer_immediate(v, t, ti)
    elif type.is_unit(t):
        return value_cons_unit_immediate(v, t, ti)

    error("value_cons_from_immediate type not implemented", ti)
    return hlir_value_cast_immediate(v, t, ti)





def cons_default(x, ti):
    from trans import typeSysInt, typeSysStr, typeSysFloat

    from_type = x['type']

    if not type.is_generic(from_type):
        return x

    # ONLY FOR GENERIC

    method = 'implicit'

    if type.is_integer(from_type):
        return value_cons_integer(x, typeSysInt, ti, method)

    elif type.is_string(from_type):
        return cons_ptr_to_str_from_generic_str(x, typeSysStr, ti, method)

    elif type.is_float(from_type):
        return value_cons_float(x, typeSysFloat, ti, method)


    fatal("unimplemented cons_default case")
    return hlir_value_bad(ti)




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
            from .cons import value_cons_from_immediate
            return value_cons_from_immediate(v, t, ti)

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

    y = value_cons_hard(v, t, ti)
    y['att'].append('explicit_cast')
    return y


