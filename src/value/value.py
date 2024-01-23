
import hlir.type as type
from hlir.type import type_print
from trans import is_local_context
from error import error, warning, info
from hlir.hlir import *
from util import get_item_with_id



def value_print(x, msg="here"):
    print("\nvalue_print:")
    print("isa: " + str(x['isa']))
    print("kind: " + str(x['kind']))
    print("type: ", end=""); type.type_print(x['type']); print()
    print("att: " + str(x['att']))
    print("additional properties:")
    for prop in x:
        if not prop in ['isa', 'kind', 'type', 'att', 'ti']:
            print(" - %s" % prop)
    info(msg, x['ti'])



def value_attribute_add(v, a):
    v['att'].append(a)


def value_attribute_check(v, a):
    return a in v['att']



def value_is_bad(x):
    return x['kind'] == 'bad'



def value_is_zero(x):
    if value_is_immediate(x):
        return x['imm'] == None
    return False



def value_is_immutable(x):
    if 'immutable' in x['att']:
        return True

    if value_is_immediate(x):
        return True

    return not x['kind'] in [
        'var', 'access', 'access_ptr', 'index', 'index_ptr', 'deref'
    ]



def value_is_immediate(x):
    if 'imm' in x:
        return 'imm' != None
    return False



def value_is_ptr_to_str(x):
    if not type.type_is_pointer_to_array(x['type']):
        return False
    return type.type_is_char(x['type']['to']['of'])



def value_load(x):
    return x


