
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
    """p = typ['power']
    imm = string_value['imm']
    if p == 8: imm['used_char8'] = True
    elif p == 16: imm['used_char16'] = True
    elif p == 32: imm['used_char32'] = True"""




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


