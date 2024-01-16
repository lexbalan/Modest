

import copy
import hlir.type as type
from hlir.type import *
from util import nbits_for_num
from .id import hlir_id





def hlir_init():
    type.hlir_type_init()


######################################################################
#                          HLIR COMMON                               #
######################################################################


def hlir_field(id, type, ti=None):
    return {
        'isa': 'field',
        'id': id,
        'type': type,
        'field_no': 0,
        'offset': 0,
        'nl': 0,
        'ti': ti
    }





######################################################################
#                           HLIR VALUE                               #
######################################################################


def hlir_value_bad(ti=None):
    return {
        'isa': 'value',
        'kind': 'bad',
        'type': hlir_type_bad(),
        'att': [],
        'id': hlir_id('_', ti=ti),
        'ti': ti
    }


def hlir_value_literal(t, imm, ti):
    return {
        'isa': 'value',
        'kind': 'literal',
        'type': t,
        'imm': imm,
        'att': [],
        'nl_end': 0,
        'nl': 0,
        'ti': ti
    }



def hlir_value_zero(t, ti=None):
    imm_val = 0
    if type.is_record(t): imm_val = {}
    elif type.is_array(t): imm_val = []
    return hlir_value_literal(t, imm_val, ti)





def hlir_value_char(char_code, type=None, ti=None):
    if type == None:
        # if type not specified, set type as GenericChar
        char_width = nbits_for_num(char_code)
        type = hlir_type_char(None, char_width, generic=True, ti=ti)

    return hlir_value_literal(type, char_code, ti)





def hlir_value_int(num, typ=None, ti=None):
    if typ == None:
        typ = type.hlir_type_generic_int_for(num, unsigned=False, ti=ti)
    else:
        nbits = nbits_for_num(num)

        if nbits > typ['width']:
            print(nbits)
            print(typ)
            from error import error
            error("value size not corresponded type size", ti)
            1 / 0
            #print("nbits = %d" % nbits)
            #print("typ['width'] = %d" % typ['width'])
            return hlir_value_bad(ti)

    return hlir_value_literal(typ, num, ti)



def hlir_value_float(num, ti=None):
    typ = hlir_type_float('Float', width=flt_width, ti=ti)
    typ['generic'] = True
    return hlir_value_literal(typ, num, ti)



def hlir_string_imm(string):
    # imm of string - it just list of UTF-32 codes
    items = []
    for ch in string:
        code = ord(ch)
        items.append(code)

    return items



def hlir_value_array(items, type=None, ti=None):
    if type == None:
        length = len(items)

        of = None
        if length > 0:
            of = items[0]['type']

        array_volume = hlir_value_int(length)
        type = hlir_type_array(of, volume=array_volume, generic=True, ti=ti)

    return hlir_value_literal(type, items, ti)



def hlir_value_record(typ, initializers={}, ti=None):
    return hlir_value_literal(typ, initializers, ti)



def hlir_value_un(k, value, type, ti=None):
    return {
        'isa': 'value',
        'kind': k,
        'value': value,
        'type': type,
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
        'att': [],
        'ti': ti
    }


def hlir_value_var(id, type, init=None, ti=None):
    return {
        'isa': 'value',
        'kind': 'var',
        'id': id,
        'type': type,
        'init': init,
        'usecnt': 0,
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
        'att': [],
        'ti': ti
    }


def hlir_value_cast(value, type, ti=None):
    return {
        'isa': 'value',
        'kind': 'cast',
        'value': value,
        'type': type,
        'att': [],
        'ti': ti
    }


def hlir_value_cast_immediate(v, t, ti=None):
    nv = hlir_value_cast(v, t, ti)
    nv['kind'] = 'cast_immediate'
    nv['imm'] = v['imm']
    if 'nl_end' in v:
        nv['nl_end'] = v['nl_end']
    return nv


def hlir_value_sizeof(of, ti=None):
    size = type.type_get_size(of)
    typ = hlir_type_generic_int_for(size, unsigned=True, ti=ti)
    return {
        'isa': 'value',
        'kind': 'sizeof',
        'of': of,
        'type': typ,
        'att': [],
        'imm': size,
        'ti': ti
    }


def hlir_value_alignof(of, ti=None):
    align = type.type_get_align(of)
    typ = hlir_type_generic_int_for(align, unsigned=True, ti=ti)
    return {
        'isa': 'value',
        'kind': 'alignof',
        'of': of,
        'type': typ,
        'att': [],
        'imm': align,
        'ti': ti
    }


def hlir_value_offsetof(of, field_id, ti=None):
    field = type.record_field_get(of, field_id['str'])
    offset = field['offset']
    typ = hlir_type_generic_int_for(offset, unsigned=True, ti=ti)
    return {
        'isa': 'value',
        'kind': 'offsetof',
        'of': of,
        'field': field_id,
        'type': typ,
        'att': [],
        'imm': offset,
        'ti': ti
    }




######################################################################
#                           HLIR VALUE                               #
######################################################################


def hlir_stmt_bad(ti=None):
    return {'isa': 'stmt', 'kind': 'bad', 'att': [], 'ti': ti}


def hlir_stmt_block(stmts, ti=None, end_nl=1):
    return {
        'isa': 'stmt',
        'kind': 'block',
        'stmts': stmts,
        # количество пустых строк перед закрывающей скобкой блока
        'end_nl': end_nl,
        'att': [],
        'ti': ti
    }


def hlir_stmt_def_var(var_value, init_value=None, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'def_var',
        'var': var_value,
        'init_value': init_value,
        'att': [],
        'ti': ti
    }


def hlir_stmt_let(id, value, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'let',
        'id': id,
        'value': value,
        'att': [],
        'ti': ti
    }


def hlir_stmt_value(value, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'value',
        'value': value,
        'att': [],
        'ti': ti
    }


def hlir_stmt_assign(left, right, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'assign',
        'left': left,
        'right': right,
        'att': [],
        'ti': ti
    }


def hlir_stmt_if(cond, then, els=None, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'if',
        'cond': cond,
        'then': then,
        'else': els,
        'att': [],
        'ti': ti
    }


def hlir_stmt_while(cond, stmt, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'while',
        'cond': cond,
        'stmt': stmt,
        'att': [],
        'ti': ti
    }


def hlir_stmt_again(ti=None):
    return {'isa': 'stmt', 'kind': 'again', 'att': [], 'ti': ti}


def hlir_stmt_break(ti=None):
    return {'isa': 'stmt', 'kind': 'break', 'att': [], 'ti': ti}


def hlir_stmt_return(value=None, ti=None):
    return {
        'isa': 'stmt',
        'kind': 'return',
        'value': value,
        'att': [],
        'ti': ti
    }



######################################################################
#                        HLIR DEFINITIONS                            #
######################################################################


def hlir_decl_type(type, ti):
    return {
        'isa': 'decl_type',
        'type': type,
        'ti': ti
    }


def hlir_def_type(type, already_declared=False, ti=None):
    return {
        'isa': 'def_type',
        'type': type,
        'afterdef': already_declared,
        'ti': ti
    }


def hlir_def_const(value_const, ti):
    return {
        'isa': 'def_const',
        'value': value_const,
        'ti': ti
    }


def hlir_def_var(value_var, ti):
    return {
        'isa': 'def_var',
        'value': value_var,
        'ti': ti
    }


def hlir_decl_func(value_func, ti):
    return {
        'isa': 'decl_func',
        'value': value_func,
        'ti': ti
    }


def hlir_def_func(value_func, ti):
    return {
        'isa': 'def_func',
        'value': value_func,
        'ti': ti
    }


