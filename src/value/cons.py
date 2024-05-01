
import hlir.type as type
from error import info, warning, error

from .value import value_is_bad, value_bad, value_is_immediate, value_cons_node
from .unit import value_cons_unit
from .bool import value_bool_cons
from .byte import value_byte_cons
from .char import value_char_cons
from .integer import value_cons_integer
from .float import value_cons_float
from .record import value_cons_record
from .array import value_array_cons
from .pointer import value_cons_pointer, cons_ptr_to_str_from_string


# данная локальная функция пытается привести v к t
# возвращает None если не может привести (!)
# не принтует ошибку (но может info)
# это НЕ нужно для удобства приведения полей структур
def _value_cons(t, v, method, ti):
    if value_is_bad(v) or type.type_is_bad(t):
        return None

    if method == 'implicit':
        if type.type_eq(v['type'], t):
            return v

    constructor = None
    if type.type_is_integer(t): constructor = value_cons_integer
    elif type.type_is_float(t): constructor = value_cons_float
    elif type.type_is_array(t): constructor = value_array_cons
    elif type.type_is_record(t): constructor = value_cons_record
    elif type.type_is_char(t): constructor = value_char_cons
    elif type.type_is_byte(t): constructor = value_byte_cons
    elif type.type_is_bool(t): constructor = value_bool_cons
    elif type.type_is_pointer(t): constructor = value_cons_pointer
    elif type.type_is_unit(t): constructor = value_cons_unit
    elif type.type_is_bad(t): constructor = value_cons_bad
    else: assert False, "unknown type kind '%s'" % t['kind']

    if constructor == None:
        return None

    nv = constructor(t, v, method, ti)
    if nv != None:
        if 'nl' in v:
            nv['nl'] = v['nl']

    return nv



def _try_to_implicit_cons(t, v, ti):
    nv = _value_cons(t, v, 'implicit', ti)
    return nv if (nv != None) else v



def value_cons_implicit(t, v):
    assert(t['isa'] == 'type')
    assert(v['isa'] == 'value')

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
            return _try_to_implicit_cons(t, v, ti)

        if not type.type_eq_record(t, from_type, opt=[], nominative=True):
            return value_cons_node(t, v, 'implicit', ti=ti)  # value_cons_node!

    # for structural type system support
    if type.type_is_pointer_to_record(t):
        if type.type_is_pointer_to_record(from_type):
            if type.type_eq_record(from_type['to'], t['to'], opt=[], nominative=True):
                # если номинативно равны - приведение не нужно
                return v
            elif type.type_eq_record(from_type['to'], t['to'], opt=[]):
                # если равны но не номенативно - для C & LLVM нужно привдение
                return value_cons_node(t, v, 'implicit', ti=ti)  # value_cons_node!


    if type.type_eq(from_type, t):
        return v

    if type.type_is_generic(from_type):
        return _try_to_implicit_cons(t, v, ti)

    if type.type_is_pointer(t):
        return _try_to_implicit_cons(t, v, ti) #?

    return v



def value_cons_explicit(t, v, ti):
    assert(t['isa'] == 'type')
    assert(v['isa'] == 'value')

    if value_is_bad(v) or type.type_is_bad(t):
        return value_bad(v['expr_ti'])

    if type.type_eq(v['type'], t):
        warning("explicit cast to the same type", ti)
        return v

    nv = _value_cons(t, v, 'explicit', ti)

    if nv == None:
        error("cannot construct value", ti)
        return value_bad(v['expr_ti'])

    return nv



def value_cons_default(x, ti):
    from_type = x['type']

    # THIS FUNCTION WORKS ONLY FOR GENERIC VALUES
    if not type.type_is_generic(from_type):
        return x

    from trans import typeSysInt, typeSysFloat, typeSysChar, typeSysStr

    if type.type_is_integer(from_type):
        t = typeSysInt
        if not type.type_is_signed(from_type):
            t = typeSysNat
        return _try_to_implicit_cons(t, x, ti)

    elif type.type_is_string(from_type):
        return cons_ptr_to_str_from_string(typeSysStr, x, ti)

    elif type.type_is_float(from_type):
        return _try_to_implicit_cons(typeSysFloat, x, ti)

    elif type.type_is_char(from_type):
        return _try_to_implicit_cons(typeSysChar, x, ti)

    from error import fatal
    fatal("unimplemented value_cons_default case")



def value_cons_implicit_check(t, v):
    nv = value_cons_implicit(t, v)
    type.check(nv['type'], t, v['expr_ti'])
    return nv



def value_cons_bad(t, v, method, ti):
    return value_bad(ti)

