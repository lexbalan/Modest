

import copy
import type
from util import nbits_for_num, nbytes_for_bits


ptr_power = 0
flt_power = 0


def hlir_init():
    from main import config
    global ptr_power, flt_power
    ptr_power = int(config['ptr_size'])
    flt_power = int(config['flt_size'])
    #print(f"ptr_power = {ptr_power}")





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
        'name': 'Unit',
        'generic': False,
        'c_alias': 'void',
        'llvm_alias': 'void',
        'size': 0,
        'power': 0,
        'imm': {},
        'att': [],
        'classes': [],
        'ti': None
    }


def hlir_type_integer(name, power, generic=False, ti=None):
    return {
        'isa': 'type',
        'kind': 'int',
        'name': name,
        'generic': generic,
        'att': [],
        'classes': ['numeric', 'comparable', 'ordered'],
        'power': power,
        'signed': False,
        'unsigned': False,
        'size': nbytes_for_bits(power),
        'ti': ti
    }


def hlir_type_bool(ti):
    return {
        'isa': 'type',
        'kind': 'Bool',
        'name': 'Bool',
        'generic': False,
        'att': [],
        'classes': ['comparable'],
        'power': 1,
        'size': 1,
        # see types.py
        #'c_alias': 'uint8_t',
        #'llvm_alias': 'i1',
        'ti': None
    }



def hlir_type_generic_char(power, ti=None):
    return {
        'isa': 'type',
        'kind': 'char',
        'name': 'Char',
        'generic': True,
        'att': [],
        'classes': ['comparable'],
        'power': power,
        'c_alias': 'uint32_t',
        'llvm_alias': 'i32',
        'size': nbytes_for_bits(power),
        'ti': ti
    }


def hlir_type_char(name, power, generic=False, ti=None):
    return {
        'isa': 'type',
        'kind': 'char',
        'name': name,
        'generic': generic,
        'att': [],
        'classes': ['comparable'],
        'power': power,
        'size': nbytes_for_bits(power),
        'ti': ti
    }


def hlir_type_float(aka, power, ti):
    return {
        'isa': 'type',
        'kind': 'float',
        'name': aka,
        'generic': False,
        'att': [],
        'classes': ['numeric', 'comparable', 'ordered'],
        'power': power,
        'size': nbytes_for_bits(power),
        'c_alias': 'double',
        'ti': ti
    }


def hlir_type_pointer(to, ti=None):
    return {
        'isa': 'type',
        'kind': 'pointer',
        'generic': False,
        'to': to,
        'size': ptr_power / 8,
        'power': ptr_power,
        'att': [],
        'classes': ['comparable'],
        'ti': ti
    }


# FreePointer - особый тип, он приводится неявно CM (но не в C!)
def hlir_type_free_pointer(ti):
    return {
        'isa': 'type',
        'kind': 'FreePointer',
        'generic': False,
        'to': type.typeUnit,
        'size': ptr_power / 8,
        'power': ptr_power,
        'att': [],
        'classes': ['comparable'],
        'ti': ti
    }


# Nil - особый тип, он приводится неявно как в CM так и в C
def hlir_type_nil(ti):
    return {
        'isa': 'type',
        'kind': 'Nil',
        'generic': True,
        'to': type.typeUnit,
        'size': ptr_power / 8,
        'power': ptr_power,
        'att': [],
        'classes': ['comparable'],
        'ti': ti
    }


# size - always hlir_value (!)
def hlir_type_array(of, volume=None, generic=False, ti=None):
    return {
        'isa': 'type',
        'generic': generic,
        'kind': 'array',
        'volume': volume,
        'of': of,
        'att': [],
        'classes': [],
        'ti': ti
    }


def hlir_type_generic_str(ti=None):
    return {
        'isa': 'type',
        'kind': 'String',
        'name': 'String',
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


def hlir_field(id, type, ti=None):
    return {
        'isa': 'field',
        'id': id,
        'type': type,
        'nl': 0,
        'ti': ti
    }


def hlir_type_record(fields, ti=None):
    return {
        'isa': 'type',
        'kind': 'record',
        'generic': False,
        'fields': fields,
        'size': 0,
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




def hlir_value_float(num, ti=None):
    typ = hlir_type_float('Float', power=flt_power, ti=ti)
    typ['generic'] = True
    return hlir_value_literal(typ, num, ti)



def hlir_string_imm(string, length):
    return {
        'str': string,
        'len': length,
    }



def hlir_value_generic_str(string, length, ti=None):
    genStrType = hlir_type_array(type.typeGenericChar, volume=length, generic=True, ti=ti)

    imm = hlir_string_imm(string, length)
    items = imm

    return hlir_value_literal(genStrType, items, ti)




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


def hlir_value_sizeof(of, ti=None):
    size = type.get_size(of)
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


