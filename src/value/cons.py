
import hlir.type as type
from hlir.type import type_print
from error import error, warning, info
from hlir.value import hlir_value_cast
from .value import *

from .unit import value_cons_unit
from .char import value_cons_char
from .integer import value_cons_integer
from .float import value_cons_float
from .record import value_cons_record
from .array import value_cons_array
from .pointer import value_cons_pointer, cons_ptr_to_str_from_generic_str



def cons_default(x, ti):
    from trans import typeSysInt, typeSysFloat, typeSysChar, typeSysStr

    from_type = x['type']

    if not type.type_is_generic(from_type):
        return x

    # ONLY FOR GENERIC

    method = 'implicit'

    if type.type_is_integer(from_type):
        return value_cons_integer(x, typeSysInt, ti, method)

    elif type.type_is_generic_array_of_char(from_type):
        print("cons_ptr_to_str_from_generic_str")
        s = cons_ptr_to_str_from_generic_str(x, typeSysStr, ti, 'explicit')
        #print(s)
        return s

    elif type.type_is_float(from_type):
        return value_cons_float(x, typeSysFloat, ti, method)

    elif type.type_is_char(from_type):
        return value_cons_char(x, typeSysChar, ti, method)

    from error import fatal
    fatal("unimplemented cons_default case")
    return hlir_value_bad(ti)




# возвращает None если не может привести (!)
# не принтует ошибку (но может info)
# это НЕ нужно для удобства приведения полей структур
def value_cons(v, t, ti, method):
    if value_is_bad(v) or type.type_is_bad(t):
        return None

    if type.type_eq(v['type'], t):
        return v

    cons = None
    if type.type_is_integer(t): cons = value_cons_integer
    elif type.type_is_pointer(t): cons = value_cons_pointer
    elif type.type_is_array(t): cons = value_cons_array
    elif type.type_is_record(t): cons = value_cons_record
    elif type.type_is_float(t): cons = value_cons_float
    elif type.type_is_char(t): cons = value_cons_char
    elif type.type_is_unit(t): cons = value_cons_unit

    nv = None

    if cons != None:
        nv = cons(v, t, ti, method)

    return nv





def value_cons_soft(v, t, ti):
    c = value_cons(v, t, ti, method='implicit')

    if c == None:
        return v

    return c




def value_cons_implicit(v, t, ti):
    if value_is_bad(v) or type.type_is_bad(t):
        return hlir_value_bad(ti)

    from_type = v['type']
    to_type = t

    # implisit cast possible only for:
    # 1. Generic -> NonGeneric
    # 2. Nil -> AnyPointer
    # 3. *[n]T -> *[]T
    # 4. AnyPointer -> FreePointer
    # 5. FreePointer -> AnyPointer

    #if not type.type_is_generic(from_type):
    #    return v

    # потому что в C номинальные типы, а у нас - структурные
    if type.type_is_record(t):
        if type.type_is_record(from_type):
            if from_type['id'] != None and t['id'] != None:
                if from_type['id']['str'] != t['id']['str']:
                    #info("impl cast record", ti)
                    return hlir_value_cast(v, t, ti=ti)


    # for structural type system support
    if type.type_is_pointer_to_record(t):
        if type.type_is_pointer_to_record(from_type):

            if type.type_eq_record(from_type['to'], t['to'], opt=[]):
                return hlir_value_cast(v, t, ti=ti)
            else:
                return v


    if type.type_eq(from_type, t):
        return v


    if type.type_is_generic(from_type):
        return value_cons_soft(v, t, ti)


    if type.type_is_pointer(t):
        # cons *[]X from *[n]X
        if type.type_is_pointer_to_defined_array(from_type) and type.type_is_pointer_to_undefined_array(t):
            return value_cons_soft(v, t, ti)

        # cons *X from Nil
        if type.type_is_free_pointer(from_type):
            return value_cons_pointer(v, t, ti, method='implicit')
            #return hlir_value_cast(v, t, ti=ti)

        # cons FreePointer from *X
        if type.type_is_pointer(from_type):
            return hlir_value_cast(v, t, ti=ti)

    return v



def value_cons_explicit(v, t, ti):
    if value_is_bad(v) or type.type_is_bad(t):
        return hlir_value_bad(ti)

    if type.type_eq(v['type'], t):
        info("explicit cast to the same type", ti)
        return v

    y = value_cons(v, t, ti, method='explicit')

    if y == None:
        error("cast error", ti)
        return hlir_value_bad(ti)

    y['att'].append('explicit_cast')  # used by CM backend

    return y


