import hlir.type as type
from hlir.type import type_print
from trans import is_local_context
from error import error, warning, info
from hlir.hlir import *
from util import get_item_with_id



def value_is_bad(x):
    return x['kind'] == 'bad'


def value_is_immediate(x):
    return 'imm' in x


# Any immediate value are immutable,
# but not any immutable value are immediate
def value_is_immutable(x):
    if x['immutable']:
        return True

    if value_is_immediate(x):
        return True

    return not x['kind'] in [
        'var', 'access', 'access_ptr', 'index', 'index_ptr', 'deref'
    ]



def value_attribute_add(v, a):
    v['att'].append(a)


def value_attribute_check(v, a):
    return a in v['att']




def value_load(x):
    return x





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


