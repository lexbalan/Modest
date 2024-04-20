
import hlir.type as type
from error import info, warning, error

from .value import value_is_bad, value_bad, value_is_immediate, value_cons_node
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
        if type.type_is_signed(from_type):
            return value_cons_integer(x, typeSysInt, 'implicit', ti)
        else:
            return value_cons_integer(x, typeSysNat, 'implicit', ti)


    elif type.type_is_generic_array_of_char(from_type):
        return cons_ptr_to_str_from_generic_str(x, typeSysStr, ti)

    elif type.type_is_float(from_type):
        return value_cons_float(x, typeSysFloat, 'implicit', ti)

    elif type.type_is_char(from_type):
        return value_cons_char(x, typeSysChar, 'implicit', ti)

    from error import fatal
    fatal("unimplemented value_cons_default case")



def value_cons_bad(v, t, method, ti):
    return value_bad(ti)


# возвращает None если не может привести (!)
# не принтует ошибку (но может info)
# это НЕ нужно для удобства приведения полей структур
def value_cons(v, t, method, ti):
    if value_is_bad(v) or type.type_is_bad(t):
        return None

    if type.type_eq(v['type'], t):
        return v

    constructor = None
    if type.type_is_integer(t): constructor = value_cons_integer
    elif type.type_is_float(t): constructor = value_cons_float
    elif type.type_is_array(t): constructor = value_cons_array
    elif type.type_is_record(t): constructor = value_cons_record
    elif type.type_is_char(t): constructor = value_cons_char
    elif type.type_is_byte(t): constructor = value_cons_byte
    elif type.type_is_bool(t): constructor = value_cons_bool
    elif type.type_is_pointer(t): constructor = value_cons_pointer
    elif type.type_is_unit(t): constructor = value_cons_unit
    elif type.type_is_bad(t): constructor = value_cons_bad

    if constructor != None:
        nv = constructor(v, t, method, ti)
        if nv != None:
            if 'nl' in v:
                nv['nl'] = v['nl']
        return nv

    return None



def implicit_cons_if_possible(v, t, ti):
    c = value_cons(v, t, 'implicit', ti)

    if c == None:
        return v

    return c



def value_cons_implicit(v, t):
    if value_is_bad(v) or type.type_is_bad(t):
        return value_bad(v['expr_ti'])

    ti = v['expr_ti']

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

    # (!) потому что в C номинальные типы, а у нас - структурные

    # for structural type system support
    if type.type_is_record(t) and type.type_is_record(from_type):

        if type.type_is_generic(from_type):
            return implicit_cons_if_possible(v, t, ti)

        if not type.type_eq_record(t, from_type, opt=[], nominative=True):
            return value_cons_node(v, t, 'implicit', ti=ti)  # value_cast!

    # for structural type system support
    if type.type_is_pointer_to_record(t):
        if type.type_is_pointer_to_record(from_type):
            if type.type_eq_record(from_type['to'], t['to'], opt=[], nominative=True):
                # если номинативно равны - приведение не нужно
                return v
            elif type.type_eq_record(from_type['to'], t['to'], opt=[]):
                # если равны но не номенативно - для C & LLVM нужно привдение
                return value_cons_node(v, t, 'implicit', ti=ti)  # value_cast!


    if type.type_eq(from_type, t):
        return v

    if type.type_is_generic(from_type):
        return implicit_cons_if_possible(v, t, ti)

    # cons Pointer from:
    if type.type_is_pointer(t):
        #return implicit_cons_if_possible(v, t, ti) #?
        return value_cons_pointer(v, t, 'implicit', ti)


    return v



def value_cons_implicit_check(v, t):
    nv = value_cons_implicit(v, t)
    type.check(nv['type'], t, v['expr_ti'])
    return nv


def value_cons_explicit(v, t, ti):
    if value_is_bad(v) or type.type_is_bad(t):
        return value_bad(v['expr_ti'])

    if type.type_eq(v['type'], t):
        warning("explicit cast to the same type", ti)
        return v

    y = value_cons(v, t, 'explicit', ti)

    if y == None:
        error("cannot construct value", ti)
        return value_bad(v['expr_ti'])

    return y


