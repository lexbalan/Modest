from error import info, warning, error
from hlir.id import hlir_id
from hlir.hlir import *
from util import get_item_with_id
import hlir.type as hlir_type


def value_is_bad(x):
    return x['kind'] == 'bad'


def value_is_immediate(x):
    return 'asset' in x


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




def value_is_zero_array(x):
    if not value_is_immediate(x):
        return False
    for item in x['asset']:
        if not value_is_zero(item):
            return False
    return True


def value_is_zero_record(x):
    if not value_is_immediate(x):
        return False
    for item in x['asset']:
        if not value_is_zero(item['value']):
            return False
    return True


# Only for immediate value (!)
def value_is_zero(x):
    if not value_is_immediate(x):
        return False
    t = x['type']
    if hlir_type.type_is_array(t):
        return value_is_zero_array(x)
    elif hlir_type.type_is_record(t):
        return value_is_zero_record(x)

    if not 'asset' in x:
        value_print(x)

    return x['asset'] == 0





def value_attribute_add(v, a):
    v['att'].append(a)


def value_attribute_check(v, a):
    return a in v['att']



def value_load(x):
    if x['kind'] == 'var':
        x['att'].append('load')
        pass
    elif x['kind'] == 'index':
        x['att'].append('load')
        pass
    elif x['kind'] == 'access':
        x['att'].append('load')
        pass
    elif x['kind'] == 'deref':
        x['att'].append('load')
        pass

    return x




def value_bad(x):
    ti = None
    if 'ti' in x:
        ti = x['ti']
    return {
        'isa': 'value',
        'kind': 'bad',
        'id': hlir_id('_', ti=ti),
        'type': hlir_type.hlir_type_bad({'ti': ti}),
        'immutable': False,
        'att': [],
        'ast_value': x,
        'expr_ti': ti,
        'ti': ti
    }


def value_literal(t, imm, ti):
    return {
        'isa': 'value',
        'kind': 'literal',
        'type': t,
        'asset': imm,
        'immutable': False,
        'att': [],
        'nl_end': 0,
        'nl': 0,
        'expr_ti': ti,
        'ti': ti
    }


def value_zero(t, ti=None):
    imm_val = 0

    if hlir_type.type_is_composite(t):
        imm_val = []

    return value_literal(t, imm_val, ti)



def value_var(id, type, ti=None):
    return {
        'isa': 'value',
        'kind': 'var',
        'id': id,
        'type': type,
        'usecnt': 0,
        'immutable': False,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


# hlir_const is an immutable value
# (not necessary immediate)
def value_const(id, type, value=None, ti=None):
    return {
        'isa': 'value',
        'kind': 'const',
        'id': id,
        'type': type,
        'value': value,
        'usecnt': 0,
        'immutable': True,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_func(id, type, ti=None):
    return {
        'isa': 'value',
        'kind': 'func',
        'id': id,
        'type': type,
        'usecnt': 0,
        'immutable': True,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_un(k, value, type, ti=None):
    return {
        'isa': 'value',
        'kind': k,
        'value': value,
        'type': type,
        'immutable': True,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_bin(op, l, r, t, ti):
    return {
        'isa': 'value',
        'kind': op,
        'left': l,
        'right': r,
        'type': t,
        'immutable': True,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_call(func, rettype, args, ti=None):
    return {
        'isa': 'value',
        'kind': 'call',
        'func': func,
        'args': args,
        'type': rettype,
        'immutable': True,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_index_array(array, index, ti=None):
    return {
        'isa': 'value',
        'kind': 'index',
        'array': array,
        'index': index,
        'type': array['type']['of'],
        'immutable': False,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_index_array_by_ptr(ptr_to_array, index, ti=None):
    return {
        'isa': 'value',
        'kind': 'index_ptr',
        'pointer': ptr_to_array,
        'index': index,
        'type': ptr_to_array['type']['to']['of'],
        'immutable': False,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_access_record(record, field, ti=None):
    return {
        'isa': 'value',
        'kind': 'access',
        'record': record,
        'field': field,
        'record_type': record['type'],
        'type': field['type'],
        'immutable': False,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_access_record_by_ptr(ptr_to_record, field, ti=None):
    return {
        'isa': 'value',
        'kind': 'access_ptr',
        'pointer': ptr_to_record,
        'field': field,
        'record_type': ptr_to_record['type']['to'],
        'type': field['type'],
        'immutable': False,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_cast(value, type, ti=None):
    return {
        'isa': 'value',
        'kind': 'cast',
        'value': value,
        'type': type,
        'immutable': True,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_cast_immediate(v, t, ti=None):
    nv = value_cast(v, t, ti)

    nv['kind'] = 'cast_immediate'
    nv['asset'] = v['asset']

    if 'hexadecimal' in v['att']:
        nv['att'].append('hexadecimal')

    if 'nl_end' in v:
        nv['nl_end'] = v['nl_end']
    return nv



def value_sizeof(of, ti=None):
    size = hlir_type.type_get_size(of)
    from foundation import typeSizeof
    return {
        'isa': 'value',
        'kind': 'sizeof',
        'of': of,
        'type': typeSizeof,
        'asset': size,
        'immutable': True,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_alignof(of, ti=None):
    align = hlir_type.type_get_align(of)
    from foundation import typeSizeof
    return {
        'isa': 'value',
        'kind': 'alignof',
        'of': of,
        'type': typeSizeof,
        'asset': align,
        'immutable': True,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_offsetof(of, field_id, ti=None):
    field = hlir_type.record_field_get(of, field_id['str'])
    if field == None:
        error("undefined field '%s'" % field_id['str'], field_id['ti'])
        return value_bad({'ti': ti})

    offset = field['offset']
    from foundation import typeSizeof
    return {
        'isa': 'value',
        'kind': 'offsetof',
        'of': of,
        'field': field_id,
        'type': typeSizeof,
        'asset': offset,
        'immutable': True,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }


def value_lengthof(of_value, ti=None):
    length = of_value['type']['volume']['asset']
    from foundation import typeSizeof
    return {
        'isa': 'value',
        'kind': 'lengthof',
        'of_value': of_value,
        'type': typeSizeof,
        'asset': length,
        'immutable': True,
        'att': [],
        'expr_ti': ti,
        'ti': ti
    }




def value_print(x, msg="here"):
    print("\nvalue_print:")
    print("isa: " + str(x['isa']))
    print("kind: " + str(x['kind']))
    print("type: ", end=""); hlir_type.type_print(x['type']); print()
    print("att: " + str(x['att']))
    print("additional properties:")
    for prop in x:
        if not prop in ['isa', 'kind', 'type', 'att', 'ti']:
            print(" - %s" % prop)
    info(msg, x['ti'])


