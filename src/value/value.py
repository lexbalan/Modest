
import type
from type import type_print
from trans import is_local_context
from error import error, warning, info
from hlir import *
from util import get_item_with_id, float_align



def value_print(x):
    print("print_value:")
    print("isa: " + str(x['isa']))
    print("kind: " + str(x['kind']))
    print("type: ", end=""); type.type_print(x['type']); print()
    print("att: " + str(x['att']))
    print("additional properties:")
    for prop in x:
        if not prop in ['isa', 'kind', 'type', 'att', 'ti']:
            print(" - %s" % prop)
    info("here", x['ti'])



def str_used_as(string_value, typ):
    if typ['power'] == 8: string_value['imm']['used_char8'] = True
    elif typ['power'] == 16: string_value['imm']['used_char16'] = True
    elif typ['power'] == 32: string_value['imm']['used_char32'] = True



def do_cast_generic(v, t, ti):
    #info("do_cast_generic", ti)

    nv = hlir_value_cast(v, t, ti)
    nv['kind'] = 'cast_generic'
    nv['imm'] = v['imm']

    if 'nl_end' in v:
        nv['nl_end'] = v['nl_end']

    # для generic приведения констант (!)
    if 'id' in v:
        nv['id'] = v['id']

    return nv



def value_attribute_add(v, a):
    v['att'].append(a)


def value_attribute_check(v, a):
    return a in v['att']




def value_is_bad(x):
    assert x != None
    return x['kind'] == 'bad'


def value_is_mutable(x):
    if 'immutable' in x['att']:
        return False

    if value_is_immediate(x):
        return False

    return x['kind'] in [
        'var', 'access', 'access_ptr', 'index', 'index_ptr', 'deref'
    ]



def value_is_immutable(x):
    if 'readonly' in x['type']['att']:
        return True
    return not value_is_mutable(x)



def value_is_immediate(x):
    if 'imm' in x:
        return 'imm' != None


def value_is_immediate_integer(x):
    return value_is_immediate(x) and type.is_integer(x['type'])


def value_is_zero(x):
    if not value_is_immediate(x):
        return False

    return x['imm'] == None



def value_generic_char(c, ti=None):
    char_code = ord(c)
    typ = hlir_type_generic_char(nbits_for_num(char_code), ti=ti)
    return hlir_value_int(char_code, typ=typ, ti=ti)



def value_load(x):
    return x



def value_soft_cast(v, t, ti):
    from value.cons import value_cons
    c = value_cons(v, t, ti, method='implicit')
    if c == None:
        return v
    return c



def value_hard_cast(v, t, ti):
    from value.cons import value_cons
    c = value_cons(v, t, ti, method='explicit')
    if c == None:
        error("cast error", ti)
        return hlir_value_bad(ti)
    return c



def value_cast_implicit(v, t, ti):
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
        return value_soft_cast(v, t, ti)


    if type.is_pointer(t):
        # cons *[]X from *[n]X
        if type.is_pointer_to_defined_array(from_type) and type.is_pointer_to_undefined_array(t):
            return value_soft_cast(v, t, ti)

        # cons *X from Nil
        if type.is_nil(from_type) and type.is_pointer(t):
            return do_cast_generic(v, t, ti)

        # cons *X from FreePointer
        if type.is_free_pointer(from_type) and type.is_pointer(t):
            return hlir_value_cast(v, t, ti=ti)

        # cons FreePointer from *X
        if type.is_pointer(from_type) and type.is_free_pointer(t):
            return hlir_value_cast(v, t, ti=ti)


    return v



def value_cast_explicit(v, t, ti):
    if value_is_bad(v) or type.is_bad(t):
        return hlir_value_bad(ti)

    if type.eq(v['type'], t):
        info("explicit cast to the same type", ti)
        return v

    return value_hard_cast(v, t, ti)



