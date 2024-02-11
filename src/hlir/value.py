######################################################################
#                           HLIR VALUE                               #
######################################################################


from util import nbits_for_num
import hlir.type as type
from hlir.type import *
import foundation



def hlir_value_bad(ti=None):
    return {
        'isa': 'value',
        'kind': 'bad',
        'id': hlir_id('_', ti=ti),
        'type': hlir_type_bad(ti),
        'immutable': False,
        'att': [],
        'ti': ti
    }


def hlir_value_literal(t, imm, ti):
    return {
        'isa': 'value',
        'kind': 'literal',
        'type': t,
        'asset': imm,
        'immutable': False,
        'att': [],
        'nl_end': 0,
        'nl': 0,
        'ti': ti
    }



def hlir_value_zero(t, ti=None):
    imm_val = 0
    if type.type_is_record(t): imm_val = []
    elif type.type_is_array(t): imm_val = []
    return hlir_value_literal(t, imm_val, ti)



def hlir_value_char(char_code, type=None, ti=None):
    if type == None:
        # if type not specified, set type as PerfectChar
        char_width = nbits_for_num(char_code)
        type = hlir_type_char(char_width, ti=ti)
        type['perfect'] = True

    return hlir_value_literal(type, char_code, ti)



def hlir_value_int(num, typ=None, ti=None):
    if typ == None:
        typ = hlir_type_perfect_int_for(num, unsigned=False, ti=ti)
    else:
        nbits = nbits_for_num(num)

        if nbits > typ['width']:
            print(nbits)
            print(typ)
            from error import error
            error("value size not corresponded type size", ti)
            return hlir_value_bad(ti)

    return hlir_value_literal(typ, num, ti)



def hlir_value_float(num, ti=None):
    typ = hlir_type_float(width=flt_width, ti=ti)
    typ['perfect'] = True
    return hlir_value_literal(typ, num, ti)



def hlir_value_array(items, type=None, ti=None):
    if type == None:
        length = len(items)

        of = None
        if length > 0:
            of = items[0]['type']

        array_volume = hlir_value_int(length)
        type = hlir_type_array(of, volume=array_volume, ti=ti)
        type['perfect'] = True

    return hlir_value_literal(type, items, ti)



def hlir_value_string(string, length=0, ti=None):
    if length == 0:
        length = len(string) + 1

    vol = hlir_value_int(length)  # <=> len(string) + 1
    genStrType = hlir_type_array(foundation.typeChar32, volume=vol, ti=ti)
    genStrType['perfect'] = True

    chars = []
    for ch in string:
        chars.append(ord(ch))

    # #imm of string literal is array of chars
    return hlir_value_literal(genStrType, chars, ti)



def hlir_value_record(typ, initializers=[], ti=None):
    return hlir_value_literal(typ, initializers, ti)



def hlir_value_un(k, value, type, ti=None):
    return {
        'isa': 'value',
        'kind': k,
        'value': value,
        'type': type,
        'immutable': True,
        'att': [],
        'ti': ti
    }


def hlir_value_bin(op, l, r, t, ti):
    return {
        'isa': 'value',
        'kind': op,
        'left': l,
        'right': r,
        'type': t,
        'immutable': True,
        'att': [],
        'ti': ti
    }


def hlir_value_func(id, type, ti=None):
    return {
        'isa': 'value',
        'kind': 'func',
        'id': id,
        'type': type,
        'usecnt': 0,
        'immutable': True,
        'att': [],
        'ti': ti
    }


def hlir_value_var(id, type, ti=None):
    return {
        'isa': 'value',
        'kind': 'var',
        'id': id,
        'type': type,
        'usecnt': 0,
        'immutable': False,
        'att': [],
        'ti': ti
    }


# hlir_const is an immutable value
# (not necessary immediate)
def hlir_value_const(id, type, value=None, ti=None):
    return {
        'isa': 'value',
        'kind': 'const',
        'id': id,
        'type': type,
        'value': value,
        'usecnt': 0,
        'immutable': True,
        'att': [],
        'ti': ti
    }


def hlir_value_call(func, rettype, args, ti=None):
    return {
        'isa': 'value',
        'kind': 'call',
        'func': func,
        'args': args,
        'type': rettype,
        'immutable': True,
        'att': [],
        'ti': ti
    }


def hlir_value_index_array(array, index, ti=None):
    return {
        'isa': 'value',
        'kind': 'index',
        'array': array,
        'index': index,
        'type': array['type']['of'],
        'immutable': False,
        'att': [],
        'ti': ti
    }


def hlir_value_index_array_by_ptr(ptr_to_array, index, ti=None):
    return {
        'isa': 'value',
        'kind': 'index_ptr',
        'pointer': ptr_to_array,
        'index': index,
        'type': ptr_to_array['type']['to']['of'],
        'immutable': False,
        'att': [],
        'ti': ti
    }


def hlir_value_access_record(record, field, ti=None):
    return {
        'isa': 'value',
        'kind': 'access',
        'record': record,
        'field': field,
        'record_type': record['type'],
        'type': field['type'],
        'immutable': False,
        'att': [],
        'ti': ti
    }


def hlir_value_access_record_by_ptr(ptr_to_record, field, ti=None):
    return {
        'isa': 'value',
        'kind': 'access_ptr',
        'pointer': ptr_to_record,
        'field': field,
        'record_type': ptr_to_record['type']['to'],
        'type': field['type'],
        'immutable': False,
        'att': [],
        'ti': ti
    }


def hlir_value_cast(value, type, ti=None):
    return {
        'isa': 'value',
        'kind': 'cast',
        'value': value,
        'type': type,
        'immutable': True,
        'att': [],
        'ti': ti
    }


def hlir_value_cast_immediate(v, t, ti=None):
    nv = hlir_value_cast(v, t, ti)
    nv['kind'] = 'cast_immediate'
    nv['asset'] = v['asset']
    if 'nl_end' in v:
        nv['nl_end'] = v['nl_end']
    return nv


def hlir_value_sizeof(of, ti=None):
    size = type.type_get_size(of)
    typ = hlir_type_perfect_int_for(size, unsigned=True, ti=ti)
    return {
        'isa': 'value',
        'kind': 'sizeof',
        'of': of,
        'type': typ,
        'asset': size,
        'immutable': True,
        'att': [],
        'ti': ti
    }


def hlir_value_alignof(of, ti=None):
    align = type.type_get_align(of)
    typ = hlir_type_perfect_int_for(align, unsigned=True, ti=ti)
    return {
        'isa': 'value',
        'kind': 'alignof',
        'of': of,
        'type': typ,
        'asset': align,
        'immutable': True,
        'att': [],
        'ti': ti
    }


def hlir_value_offsetof(of, field_id, ti=None):
    field = type.record_field_get(of, field_id['str'])
    offset = field['offset']
    typ = hlir_type_perfect_int_for(offset, unsigned=True, ti=ti)
    return {
        'isa': 'value',
        'kind': 'offsetof',
        'of': of,
        'field': field_id,
        'type': typ,
        'asset': offset,
        'immutable': True,
        'att': [],
        'ti': ti
    }







def hlir_is_value(x):
    return x['isa'] == 'value'


