

import copy


typePointerSize = 4


def nbytes_for_bits(x):
  aligned_bits = 8
  while aligned_bits < x:
    aligned_bits = aligned_bits * 2
  return aligned_bits // 8




def hlir_type_bad(att=[], ti=None):
  return {'isa': 'type', 'kind': 'bad', 'att': [], 'ti': ti}


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
  return {
    'isa': 'type',
    'kind': 'pointer',
    'to': to,
    'size': typePointerSize,
    'power': typePointerSize * 8,
    'att': att,
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

  #if 'arghack' in att:
  #  print("OOPOOPOOPP22")
  return tt


def hlir_type_record(fields=[], att=[], ti=None):
  return {
    'isa': 'type',
    'kind': 'record',
    'fields': fields,
    'size': 0,
    'att': att,
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
    'att': ['adr', 'var'] + att,
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
    'att': ['adr'] + att,
    'ti': ti
  }


def hlir_value_index_ptr_array(ptr2arr, index, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'index',
    'array': ptr2arr,
    'index': index,
    'type': ptr2arr['type']['to']['of'],
    'att': ['adr'] + att,
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
    'att': ['adr'] + att,
    'ti': ti
  }


def hlir_value_access_ptr_record(record, field, att=[], ti=None):
  return {
    'isa': 'value',
    'kind': 'access_ptr',
    'pointer': record,
    'field': field,
    'record_type': record['type']['to'],
    'type': field['type'],
    'att': ['adr'] + att,
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




