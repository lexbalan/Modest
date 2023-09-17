

import copy
from opt import settings_get
import core.type as type
from util import nbits_for_num, nbytes_for_bits



def hlir_type_bad(ti=None):
  return {'isa': 'type', 'kind': 'bad', 'att': [], 'ti': ti}


def hlir_type_unit():
  return {
    'isa': 'type',
    'kind': 'unit',
    'name': 'Unit',
    'c_alias': 'void',
    'llvm_alias': 'void',
    'size': 0,
    'power': 0,
    'imm_items': [],
    'initializers': [],
    'att': [],
    'ti': None
  }


def hlir_type_integer(name, power, ti):
  return {
    'isa': 'type',
    'kind': 'int',
    'name': name,
    'att': ['numeric', 'comparable', 'ordered', 'integer'],
    'power': power,
    'size': nbytes_for_bits(power),
    'ti': ti
  }


def hlir_type_float(aka, power, ti):
  return {
    'isa': 'type',
    'kind': 'float',
    'name': aka,
    'att': ['numeric', 'comparable', 'ordered', 'float'],
    'power': power,
    'size': nbytes_for_bits(power),
    'ti': ti
  }


def hlir_type_pointer(to, ti):
  pointer_size = int(settings_get('ptr'))
  return {
    'isa': 'type',
    'kind': 'pointer',
    'to': to,
    'size': pointer_size / 8,
    'power': pointer_size,
    'att': ['comparable'],
    'ti': ti
  }

# FreePointer - особый тип, он приводится неявно CM (но не в C!)
def hlir_type_free_pointer(ti):
  pointer_size = int(settings_get('ptr'))
  return {
    'isa': 'type',
    'kind': 'FreePointer',
    'to': type.typeUnit,
    'size': pointer_size / 8,
    'power': pointer_size,
    'att': ['comparable'],
    'ti': ti
  }

# Nil - особый тип, он приводится неявно как в CM так и в C
def hlir_type_nil(ti):
  pointer_size = int(settings_get('ptr'))
  return {
    'isa': 'type',
    'kind': 'Nil',
    'to': type.typeUnit,
    'size': pointer_size / 8,
    'power': pointer_size,
    'att': ['comparable', 'generic'],
    'ti': ti
  }

# size - always hlir_value (!)
def hlir_type_array(of, volume, ti):
  return {
    'isa': 'type',
    'kind': 'array',
    'volume': volume,
    'of': of,
    'att': [],
    'ti': ti
  }


# used in shifts
def hlir_type_generic_int_bits(nbits, unsigned=False, ti=None):
  # get custom generic int type
  gen_int_type = hlir_type_integer('Integer', power=nbits, ti=ti)
  gen_int_type['kind'] = 'Integer'
  gen_int_type['att'].extend(['generic'])
  if unsigned:
    gen_int_type['att'].extend(['unsigned'])
  gen_int_type['power'] = nbits
  gen_int_type['size'] = nbytes_for_bits(nbits)
  return gen_int_type


def hlir_type_generic_int_for(num, unsigned=False, ti=None):
  nbits = nbits_for_num(num)
  return hlir_type_generic_int_bits(nbits, unsigned=unsigned, ti=ti)


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
    'fields': fields,
    'size': 0,
    'att': [],
    'ti': ti
  }


# дефолт аргумент не работает!!!!
def hlir_type_func(params, to, ti=None):
  tt = {
    'isa': 'type',
    'kind': 'func',
    'params': params,
    'to': to,
    'att': [],
    'ti': ti
  }

  return tt






def hlir_value_bad(ti=None):
  return {
    'isa': 'value',
    'kind': 'bad',
    'type': hlir_type_bad(),
    'att': [],
    'ti': ti
  }


def hlir_value_zero(t, ti=None):
  return {
    'isa': 'value',
    'kind': 'literal',
    'type': t,
    'imm_num': 0,
    'imm_items': [],
    'initializers': [],
    'att': ['immediate'],
    'ti': ti
  }


def hlir_value_int(num, typ=None, ti=None):

  if typ == None:
    typ = hlir_type_generic_int_for(num, unsigned=False, ti=ti)
  else:
    nbits = nbits_for_num(num)
    #print("nbits = %d" % nbits)
    #print("typ['power'] = %d" % typ['power'])
    assert(nbits <= typ['power'])
    """
    # extend if generic or error
    if type.is_generic(typ):
      typ = hlir_type_generic_int_bits(nbits, unsigned=False, ti=ti)
    else:
      error("integer oferflow", ti)
    """

  return {
    'isa': 'value',
    'kind': 'literal',
    'imm_num': num,
    'type': typ,
    'att': ['immediate'],
    'ti': ti
  }


def hlir_value_float(num, ti=None):
  # вообще с флотом непонятно можно ли понять какого он Generic типа
  # тк есть числа которые вообще никак не запишешь
  typ = hlir_type_float('Float', power=0, ti=ti)
  typ['att'].extend(['generic'])
  return {
    'isa': 'value',
    'kind': 'literal',
    'imm_num': num,
    'type': typ,
    'att': ['immediate'],
    'ti': ti
  }


def hlir_value_cstr(string, length, type, ti=None):
  return {
    'isa': 'value',
    'kind': 'literal',
    'str': string,
    'len': length,
    'type': type,
    'att': ['immediate', 'string'],
    'ti': ti
  }


def hlir_value_array(type, items, ti=None):
  return {
    'isa': 'value',
    'kind': 'literal',
    'type': type,
    'imm_items': items,
    'att': ['immediate'],
    'nl_end': 0,
    'ti': ti
  }


def hlir_value_record(typ, items={}, ti=None):
  return {
    'isa': 'value',
    'kind': 'literal',
    'type': typ,
    'initializers': items,
    'att': ['immediate'],
    'nl_end': 0,
    'ti': ti
  }


def hlir_value_num_get(x):
  return x['imm_num']




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
    'att': ['immediate'],
    'imm_num': size,
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
    'usecnt': 0,
    'att': [],
    'ti': ti
  }


def hlir_stmt_def_const(id, value, ti=None):
  return {
    'isa': 'stmt',
    'kind': 'def_let',
    'id': id,
    'value': value,
    'usecnt': 0,
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




def hlir_decl_type(type, ti=None):
  return {
    'isa': 'declaration',
    'kind': 'type',
    'type': type
  }


def hlir_def_type(id, type, already_declared=False, ti=None):
  return {
    'isa': 'definition',
    'kind': 'type',
    'id': id,
    'type': type,
    'afterdef': already_declared,
  }


def hlir_def_const(id, value, ti=None):
  return {
    'isa': 'definition',
    'kind': 'const',
    'value': value
  }


def hlir_def_var(var_value, init_value=None, ti=None):
  return {
    'isa': 'definition',
    'kind': 'var',
    'var': var_value
  }



def hlir_decl_func(func, ti=None):
  return {
    'isa': 'declaration',
    'kind': 'func',
    'func': func
  }


def hlir_def_func(func, ti=None):
  return {
    'isa': 'definition',
    'kind': 'func',
    'func': func
  }


