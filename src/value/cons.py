
import hlir.type as type
from hlir.type import type_print
from error import info, warning, error

from .value import value_is_bad, value_is_immediate, value_cast
from .unit import value_cons_unit
from .bool import value_cons_bool
from .byte import value_cons_byte
from .char import value_cons_char
from .integer import value_cons_integer
from .float import value_cons_float
from .record import value_cons_record
from .array import value_cons_array
from .pointer import value_cons_pointer, cons_ptr_to_str_from_generic_str



def value_cons_default(x, ti):
    from_type = x['type']

    # ONLY FOR GENERIC
    if not type.type_is_generic(from_type):
        return x

    from trans import typeSysInt, typeSysFloat, typeSysChar, typeSysStr

    if type.type_is_integer(from_type):
        return value_cons_integer(x, typeSysInt, ti, 'implicit')

    elif type.type_is_generic_array_of_char(from_type):
        return cons_ptr_to_str_from_generic_str(x, typeSysStr, ti)

    elif type.type_is_float(from_type):
        return value_cons_float(x, typeSysFloat, ti, 'implicit')

    elif type.type_is_char(from_type):
        return value_cons_char(x, typeSysChar, ti, 'implicit')

    from error import fatal
    fatal("unimplemented value_cons_default case")



def value_cons_bad(v, t, ti, method):
    return value_bad(ti)


# возвращает None если не может привести (!)
# не принтует ошибку (но может info)
# это НЕ нужно для удобства приведения полей структур
def value_cons(v, t, ti, method):
    if value_is_bad(v) or type.type_is_bad(t):
        return None

    if type.type_eq(v['type'], t):
        return v

    constructor = None
    if type.type_is_integer(t): constructor = value_cons_integer
    elif type.type_is_pointer(t): constructor = value_cons_pointer
    elif type.type_is_array(t): constructor = value_cons_array
    elif type.type_is_record(t): constructor = value_cons_record
    elif type.type_is_float(t): constructor = value_cons_float
    elif type.type_is_char(t): constructor = value_cons_char
    elif type.type_is_byte(t): constructor = value_cons_byte
    elif type.type_is_bool(t): constructor = value_cons_bool
    elif type.type_is_unit(t): constructor = value_cons_unit
    elif type.type_is_bad(t): constructor = value_cons_bad

    if constructor != None:
        return constructor(v, t, ti, method)

    return None



def value_cons_soft(v, t, ti):
    c = value_cons(v, t, ti, method='implicit')

    if c == None:
        return v

    return c



def value_cons_implicit(v, t, ti):
    if value_is_bad(v) or type.type_is_bad(t):
        return value_bad(ti)

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
    if type.type_is_record(t) and type.type_is_record(from_type):
        #if from_type['id'] != None and t['id'] != None:
        #    if from_type['id']['str'] != t['id']['str']:
                #info("impl cast record", ti)

        #if from_type['declaration'] != None and t['declaration'] != None:
        #    if from_type['declaration'] != t['declaration']:
        #if t != from_type:

        if type.type_is_generic(from_type):
            return value_cons_soft(v, t, ti)

        if not type.type_eq_record(t, from_type, opt=[], nominative=True):
            return value_cast(v, t, ti=ti)

    # for structural type system support
    if type.type_is_pointer_to_record(t):
        if type.type_is_pointer_to_record(from_type):
            if type.type_eq_record(from_type['to'], t['to'], opt=[], nominative=True):
                # если номинативно равны - приведение не нужно
                return v
            elif type.type_eq_record(from_type['to'], t['to'], opt=[]):
                # если равны но не номенативно - для C & LLVM нужно привдение
                return value_cast(v, t, ti=ti)


    if type.type_eq(from_type, t):
        return v


    if type.type_is_generic(from_type):
        return value_cons_soft(v, t, ti)


    # cons Pointer from:
    if type.type_is_pointer(t):
        return value_cons_pointer(v, t, ti, method='implicit')


    return v



def value_cons_explicit(v, t, ti):
    if value_is_bad(v) or type.type_is_bad(t):
        return value_bad(ti)

    if type.type_eq(v['type'], t):
        warning("explicit cast to the same type", ti)
        return v

    y = value_cons(v, t, ti, method='explicit')

    if y == None:
        error("cast error", ti)
        return value_bad(ti)

    y['att'].append('explicit_cast')  # used by CM backend

    return y


