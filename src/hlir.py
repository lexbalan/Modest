

import copy
import type
from util import nbits_for_num, nbytes_for_bits
import settings

ptr_width = 0
flt_width = 0


def hlir_init():
    global ptr_width, flt_width
    ptr_width = int(settings.get('pointer_width'))
    flt_width = int(settings.get('float_width'))



def hlir_type_bad(ti=None):
    return {
        'isa': 'type',
        'kind': 'bad',
        'generic': False,
        'att': [],
        'classes': [],
        'ti': ti
    }


def hlir_type_unit():
    return {
        'isa': 'type',
        'kind': 'unit',
        'id': {'str': 'Unit', 'ti': None},
        'generic': False,
        'c_alias': 'void',
        'llvm_alias': 'void',
        'size': 0,
        'align': 0,
        'power': 0,
        'imm': {},
        'att': [],
        'classes': [],
        'ti': None
    }


def hlir_type_integer(id_str, power, generic=False, ti=None):
    size = nbytes_for_bits(power)
    return {
        'isa': 'type',
        'kind': 'int',
        'id': {'str': id_str, 'ti': None},
        'generic': generic,
        'att': [],
        'classes': ['numeric', 'comparable', 'ordered'],
        'power': power,
        'signed': False,
        'unsigned': False,
        'size': size,
        'align': size,
        'ti': ti
    }


def hlir_type_bool(ti):
    return {
        'isa': 'type',
        'kind': 'Bool',
        'id': {'str': 'Bool', 'ti': None},
        'generic': False,
        'att': [],
        'classes': ['comparable'],
        'power': 1,
        'size': 1,
        'align': 1,
        'c_alias': 'uint8_t',
        'llvm_alias': 'i1',
        'cm_alias': 'Bool',
        'ti': None
    }



def hlir_type_generic_char(power, ti=None):
    size = nbytes_for_bits(power)
    return {
        'isa': 'type',
        'kind': 'char',
        'id': {'str': 'Char', 'ti': None},
        'generic': True,
        'att': [],
        'classes': ['comparable'],
        'power': power,
        'cm_alias': 'Char',
        'c_alias': 'uint32_t',
        'llvm_alias': 'i8',
        'size': size,
        'align': size,
        'ti': ti
    }


def hlir_type_char(id_str, power, generic=False, ti=None):
    size = nbytes_for_bits(power)
    return {
        'isa': 'type',
        'kind': 'char',
        'id': {'str': id_str, 'ti': None},
        'generic': generic,
        'att': [],
        'classes': ['comparable'],
        'power': power,
        'size': size,
        'align': size,
        'ti': ti
    }


def hlir_type_float(id_str, power, ti):
    size = nbytes_for_bits(power)
    return {
        'isa': 'type',
        'kind': 'float',
        'id': {'str': id_str, 'ti': None},
        'generic': False,
        'att': [],
        'classes': ['numeric', 'comparable', 'ordered'],
        'power': power,
        'size': size,
        'align': size,
        'c_alias': 'double',
        'ti': ti
    }


def hlir_type_pointer(to, ti=None):
    size = nbytes_for_bits(ptr_width)
    return {
        'isa': 'type',
        'kind': 'pointer',
        'generic': False,
        'to': to,
        'size': size,
        'align': size,
        'power': ptr_width,
        'att': [],
        'classes': ['comparable'],
        'ti': ti
    }


# FreePointer - особый тип, он приводится неявно CM (но не в C!)
def hlir_type_free_pointer(ti):
    size = nbytes_for_bits(ptr_width)
    return {
        'isa': 'type',
        'kind': 'FreePointer',
        'generic': False,
        'to': type.typeUnit,
        'size': size,
        'align': size,
        'power': ptr_width,
        'att': [],
        'classes': ['comparable'],
        'ti': ti
    }


# Nil - особый тип, он приводится неявно как в CM так и в C
def hlir_type_nil(ti):
    size = nbytes_for_bits(ptr_width)
    return {
        'isa': 'type',
        'kind': 'Nil',
        'generic': True,
        'to': type.typeUnit,
        'size': size,
        'align': size,
        'power': ptr_width,
        'att': [],
        'classes': ['comparable'],
        'ti': ti
    }


# size - always hlir_value (!)
def hlir_type_array(of, volume=None, generic=False, ti=None):
    item_size = 0
    item_align = 0
    if of != None:
        item_size = type.type_get_size(of)
        item_align = type.type_get_align(of)

    array_size = 0
    if volume != None:
        array_size = item_size * volume['imm']

    return {
        'isa': 'type',
        'generic': generic,
        'kind': 'array',
        'volume': volume,
        'size': array_size,
        'align': item_align,
        'of': of,
        'att': [],
        'classes': [],
        'ti': ti
    }


def hlir_type_generic_str(ti=None):
    return {
        'isa': 'type',
        'kind': 'String',
        'id': {'str': 'String', 'ti': None},
        'generic': True,
        'att': [],
        'classes': [],
        'ti': ti
    }


# used in shifts
def hlir_type_generic_int_bits(nbits, ti=None):
    return hlir_type_integer('Integer', power=nbits, generic=True, ti=ti)


def hlir_type_generic_int_for(num, unsigned=False, ti=None):
    nbits = nbits_for_num(num)
    return hlir_type_generic_int_bits(nbits, ti=ti)


def hlir_field(id, type, pos=0, offset=0, ti=None):
    return {
        'isa': 'field',
        'id': id,
        'type': type,
        'pos': pos,
        'offset': offset,
        'nl': 0,
        'ti': ti
    }


def hlir_type_record(fields, size=0, align=0, ti=None):
    return {
        'isa': 'type',
        'kind': 'record',
        'generic': False,
        'fields': fields,
        'size': size,
        'align': align,
        'att': [],
        'classes': [],
        'ti': ti
    }


# дефолт аргумент не работает!!!!
def hlir_type_func(params, to, ti=None):
    return {
        'isa': 'type',
        'generic': False,
        'kind': 'func',
        'params': params,
        'to': to,
        'att': [],
        'classes': [],
        'ti': ti
    }




def hlir_value_bad(ti=None):
    return {
        'isa': 'value',
        'kind': 'bad',
        'type': hlir_type_bad(),
        'att': [],
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
    return hlir_value_literal(t, None, ti)


def hlir_value_int(num, typ=None, ti=None):
    if typ == None:
        typ = hlir_type_generic_int_for(num, unsigned=False, ti=ti)
    else:
        nbits = nbits_for_num(num)

        if nbits > typ['power']:
            from error import error
            error("value size not corresponded type size", ti)
            1 / 0
            #print("nbits = %d" % nbits)
            #print("typ['power'] = %d" % typ['power'])
            return hlir_value_bad(ti)

    return hlir_value_literal(typ, num, ti)



def hlir_value_char(char_code, type=None, ti=None):

    if type == None:
        # Generic CHar
        char_width = nbits_for_num(char_code)
        type = hlir_type_generic_char(char_width, ti)

    return hlir_value_literal(type, char_code, ti)



def hlir_value_float(num, ti=None):
    typ = hlir_type_float('Float', power=flt_width, ti=ti)
    typ['generic'] = True
    return hlir_value_literal(typ, num, ti)



def hlir_string_imm(string):
    # imm of string - it just list of UTF-32 codes
    items = []
    for ch in string:
        code = ord(ch)
        items.append(code)

    return items



def hlir_value_array(items, type=None, is_generic=False, ti=None):

    if type == None:
        length = len(items)

        of = None
        if length > 0:
            of = items[0]['type']

        array_volume = hlir_value_int(length)
        type = hlir_type_array(of, volume=array_volume, ti=ti)


    if is_generic:
        type['generic'] = True

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
        'classes': [],
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


def hlir_value_index_array_by_ptr(ptr, index, ti=None):
    return {
        'isa': 'value',
        'kind': 'index_ptr',
        'pointer': ptr,
        'index': index,
        'type': ptr['type']['to']['of'],
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


def hlir_value_access_record_by_ptr(record, field, ti=None):
    return {
        'isa': 'value',
        'kind': 'access_ptr',
        'pointer': record,
        'field': field,
        'record_type': record['type']['to'],
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





def hlir_decl_type(type):
    return {'isa': 'decl_type', 'type': type}


def hlir_def_type(type, already_declared=False):
    return {'isa': 'def_type', 'type': type, 'afterdef': already_declared}


def hlir_def_const(value_const):
    return {'isa': 'def_const', 'value': value_const}


def hlir_def_var(value_var):
    return {'isa': 'def_var', 'value': value_var}


def hlir_decl_func(value_func):
    return {'isa': 'decl_func', 'value': value_func}


def hlir_def_func(value_func):
    return {'isa': 'def_func', 'value': value_func}


