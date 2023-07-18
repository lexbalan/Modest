

import copy
from opt import settings_get


def nbytes_for_bits(x):
  aligned_bits = 8
  while aligned_bits < x:
    aligned_bits = aligned_bits * 2
  return aligned_bits // 8





def hlir_type_bad(att=[], ti=None):
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
    'items': [],
    'att': [],
    'ti': None
  }


def hlir_type_integer(name, power=0, att=[], ti=None):
  return {
    'isa': 'type',
    'kind': 'integer',
    'name': name,
    'att': ['numeric', 'ordered', 'integer'] + att,
    'power': power,
    'size': nbytes_for_bits(power),
    'ti': ti
  }


def hlir_type_float(aka, size=0, att=[], ti=None):
  return {
    'isa': 'type',
    'kind': 'float',
    'name': aka,
    'att': ['numeric', 'ordered', 'float'] + att,
    'size': size,
    'ti': ti
  }


def hlir_type_pointer(to, att=[], ti=None):
  pointer_size = settings_get('pointer_size')
  return {
    'isa': 'type',
    'kind': 'pointer',
    'to': to,
    'size': pointer_size,
    'power': pointer_size * 8,
    'att': att,
    'ti': ti
  }

def hlir_type_free_pointer(ti=None):
  pointer_size = settings_get('pointer_size')
  return {
    'isa': 'type',
    'kind': 'free_pointer',
    'size': pointer_size,
    'power': pointer_size * 8,
    'att': [],
    'ti': ti
  }

# size - always hlir_value (!)
def hlir_type_array(of, volume=None, att=[], ti=None):
  return {
    'isa': 'type',
    'kind': 'array',
    'volume': volume,
    'of': of,
    'att': att,
    'ti': ti
  }


def hlir_field(id, type, ti=None):
  return {
    'isa': 'field',
    'id': id,
    'type': type,
    'ti': ti
  }


def hlir_type_record(fields=[], att=[], ti=None):
  return {
    'isa': 'type',
    'kind': 'record',
    'fields': fields,
    'size': 0,
    'att': att,
    'ti': ti
  }


# дефолт аргумент не работает!!!!
def hlir_type_func(params, to, att=[], ti=None):
  tt = {
    'isa': 'type',
    'kind': 'func',
    'params': params,
    'to': to,
    'att': att,
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


def hlir_value_zero(type, ti=None):
  return {
    'isa': 'value',
    'kind': 'zero',
    'type': type,
    'att': [],
    'ti': ti
  }


def hlir_value_int(num, typ=None, att=[], ti=None):
  def nbits_for_int(x):
    n = 1
    y = 1
    while x > y:
      y = (y << 1) | 1
      n = n + 1
    return n

  nbits = nbits_for_int(num)

  if typ == None:
    # get custom generic int type
    gen_int_type = hlir_type_integer('Int', att=['generic'])
    gen_int_type['power'] = nbits
    gen_int_type['size'] = nbytes_for_bits(nbits)
    typ = gen_int_type


  if nbits > typ['power']:
    # extend if generic or error
    if type.is_generic(typ):
      typ = hlir_type_integer('Int', nbits, att=['generic'])
    else:
      error("integer oferflow", ti)

  return {
    'isa': 'value',
    'kind': 'num',
    'num': num,
    'type': typ,
    'att': ['immediate'] + att,
    'ti': ti
  }


def hlir_value_float(num, att=[], ti=None):
  # вообще с флотом непонятно можно ли понять какого он Generic типа
  # тк есть числа которые вообще никак не запишешь
  typ = hlir_type_float('Float', att=['generic'])
  return {
    'isa': 'value',
    'kind': 'num',
    'num': num,
    'type': typ,
    'att': ['immediate'] + att,
    'ti': ti
  }


def hlir_value_cstr(string, length, type, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'str',
    'str': string,
    'len': length,
    'type': type,
    'att': ['string'],
    'ti': ti
  }


def hlir_value_un(k, value, type, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': k,
    'value': value,
    'type': type,
    'att': att,
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

def hlir_value_func(id, type, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'func',
    'id': id,
    'type': type,
    'att': att,
    'ti': ti
  }


def hlir_value_var(id, type, init=None, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'var',
    'id': id,
    'type': type,
    'init': init,
    'att': att,
    'ti': ti
  }


# hlir_const is an immutable value
# (even if it is implemented as runtime variable)
def hlir_value_const(id, type, init=None, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'const',
    'id': id,
    'type': type,
    'init': init,
    'att': att,
    'ti': ti
  }


def hlir_value_array(type, items, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'array',
    'type': type,
    'items': items,
    'att': att,
    'ti': ti
  }



def hlir_value_record(typ, items=[], att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'record',
    'type': typ,
    'items': items,
    'att': [],
    'ti': ti
  }


def hlir_value_call(func, args, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'call',
    'func': func,
    'args': args,
    'type': func['type']['to'],
    'att': att,
    'ti': ti
  }


def hlir_value_index_array(array, index, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'index',
    'array': array,
    'index': index,
    'type': array['type']['of'],
    'att': att,
    'ti': ti
  }


def hlir_value_index_array_by_ptr(ptr, index, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'index_ptr',
    'pointer': ptr,
    'index': index,
    'type': ptr['type']['to']['of'],
    'att': att,
    'ti': ti
  }


def hlir_value_access_record(record, field, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'access',
    'record': record,
    'field': field,
    'record_type': record['type'],
    'type': field['type'],
    'att': att,
    'ti': ti
  }


def hlir_value_access_record_by_ptr(record, field, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'access_ptr',
    'pointer': record,
    'field': field,
    'record_type': record['type']['to'],
    'type': field['type'],
    'att': att,
    'ti': ti
  }


def hlir_value_cast(value, type, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'cast',
    'value': value,
    'type': type,
    'att': att,
    'ti': ti
  }


def hlir_value_sizeof(of, type, ti=None):
  return {
    'isa': 'value',
    'kind': 'sizeof',
    'of': of,
    'type': type,
    'att': [],
    'ti': ti
  }





def hlir_stmt_bad(ti=None):
  return {'isa': 'stmt', 'kind': 'bad', 'ti': ti}


def hlir_stmt_block(stmts, ti=None):
  return {
    'isa': 'stmt',
    'kind': 'block',
    'stmts': stmts,
    'ti': ti
  }


def hlir_stmt_def_var(id, type, init_value=None, ti=None):
  return {
    'isa': 'stmt',
    'kind': 'def_var',
    'id': id,
    'type': type,
    'value': init_value,
    'ti': ti
  }


def hlir_stmt_def_const(id, value, ti=None):
  return {
    'isa': 'stmt',
    'kind': 'def_let',
    'id': id,
    'value': value,
    'ti': ti
  }


def hlir_stmt_value(value, ti=None):
  return {
    'isa': 'stmt',
    'kind': 'value',
    'value': value,
    'ti': ti
  }


def hlir_stmt_assign(left, right, ti=None):
  return {
    'isa': 'stmt',
    'kind': 'assign',
    'left': left,
    'right': right,
    'ti': ti
  }


def hlir_stmt_if(cond, then, els=None, ti=None):
  return {
    'isa': 'stmt',
    'kind': 'if',
    'cond': cond,
    'then': then,
    'else': els,
    'ti': ti
  }


def hlir_stmt_while(cond, stmt, ti=None):
  return {
    'isa': 'stmt',
    'kind': 'while',
    'cond': cond,
    'stmt': stmt,
    'ti': ti
  }


def hlir_stmt_again(ti=None):
  return {'isa': 'stmt', 'kind': 'again', 'ti': ti}


def hlir_stmt_break(ti=None):
  return {'isa': 'stmt', 'kind': 'break', 'ti': ti}


def hlir_stmt_return(value=None, ti=None):
  return {
    'isa': 'stmt',
    'kind': 'return',
    'value': value,
    'ti': ti
  }






def hlir_decl_type(id, type, ti=None):
  return {
    'isa': 'declaration',
    'kind': 'type',
    'id': id,
    'type': type,
    'att': ['undefined'],
  }


def hlir_decl_func(func, ti=None):
  return {
    'isa': 'declaration',
    'kind': 'func',
    'func': func,
    'att': ['undefined'],
    'ti': ti
  }


def hlir_def_type(id, type, already_declared=False, ti=None):
  return {
    'isa': 'definition',
    'kind': 'type',
    'id': id,
    'type': type,  # именно t!
    'att': [],
    'afterdef': already_declared,
    'ti': ti
  }


def hlir_def_const(id, value, ti=None):
  return {
    'isa': 'definition',
    'kind': 'const',
    'const': value,
    'value': value,
    'id': id,
    'att': [],
  }


def hlir_def_var(var, init, ti=None):
  return {
    'isa': 'definition',
    'kind': 'var',
    'var': var,
    'init': init,
    'att': [],
    'ti': ti
  }


def hlir_def_func(func, ti=None):
  return {
    'isa': 'definition',
    'kind': 'func',
    'func': func,
    'att': [],
    'ti': ti
  }


