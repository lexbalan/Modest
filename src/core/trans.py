
import os
import copy

from opt import *
from error import *


def is_local_context():
  global cfunc
  return cfunc != None


from .value import *
from parser import Parser
from core.symtab import Symtab
import core.type as type
from core.type import type_attribute_check, type_print

from .hlir import *


# current file directory
env_current_file_abspath = ""
env_current_file_dir = ""

parser = Parser()

cfunc = None  # current function

root_context = None

module = None


def module_type_get(m, id_str):
  #print("SEARCH_TYPE %s in %s" % (id_str, cm['path']))
  t = m['context'].type_get(id_str)
  if t != None:
    return t

  for imported_module in m['imports']:
    t = module_type_get(imported_module, id_str)
    if t != None:
      return t


def module_value_get(m, id_str):
  #print("SEARCH_VALUE %s in %s" % (id_str, cm['path']))
  v = m['context'].value_get(id_str)
  if v != None:
    return v

  for imported_module in m['imports']:
    v = module_value_get(imported_module, id_str)
    if v != None:
      return v


def type_get(id_str):
  return module_type_get(module, id_str)



def value_get(id_str):
  return module_value_get(module, id_str)
  #return module['context'].value_get(id_str, recursive=True)


# искать только внутри текущего контекста (блока)
def value_get_here(id_str):
  return module['context'].value_get(id_str, recursive=False)




# used in metadirs
def c_include(s):
  #print("c_include %s" % s)
  global module
  local = s[0:2] == './'
  inc = {
    'isa': 'directive',
    'kind': 'c_include',
    'str': s,
    'local': local,
    'att': [],
  }
  module['text'].append(inc)


properties = {}


# used in metadirs
# add 'properties' to entity descriptor
def property(id, value):
  global properties
  properties[id] = value


attributes = []

def attribute(id):
  global attributes
  attributes.append(id)

"""def attribute_off(id):
  global attributes
  i = 0
  while i < len(attributes):
    if attributes[i] == id:
      del attributes[i]
    i = i + 1"""

def attributes_get():
  global attributes
  attributes2 = attributes
  attributes = []
  return attributes2

  """present = id in attributes
  if present:
    attribute_off(id)
  return present"""


# опциии компилятора, либо включена, либо выклчена
# впрочем может иметь и значение отлитчное от True
"""options = {}

def option(id, value=True):
  global options
  options[id] = value

def option_off(id):
  global options
  options[id] = False

def option_get(id):
  global options
  if not id in options:
    return None
  return options[id]
"""


def insert(s):
  global module

  inc = {
    'isa': 'directive',
    'kind': 'insert',
    'str': s,
    'att': [],
  }
  module['text'].append(inc)




def stmt_is_bad(x):
  assert x != None
  return x['kind'] == 'bad'




typeSysInt = None
typeSysNat = None

def select_int(sz):
  return {
    8: type.typeInt8,
    16: type.typeInt16,
    32: type.typeInt32,
    64: type.typeInt64,
  }[sz]

def select_nat(sz):
  return {
    8: type.typeNat8,
    16: type.typeNat16,
    32: type.typeNat32,
    64: type.typeNat64,
  }[sz]



int_size = 0  # sizeof(int)
ptr_size = 0  # sizeof(int *)


def init():
  global int_size, ptr_size, size_size
  int_size = int(settings_get('int'))
  ptr_size = int(settings_get('ptr'))

  global root_context
  # init main context
  root_context = Symtab()
  root_context.type_add('Unit', type.typeUnit)
  root_context.type_add('Int8', type.typeInt8)
  root_context.type_add('Int16', type.typeInt16)
  root_context.type_add('Int32', type.typeInt32)
  root_context.type_add('Int64', type.typeInt64)
  root_context.type_add('Nat1', type.typeNat1)
  root_context.type_add('Nat8', type.typeNat8)
  root_context.type_add('Nat16', type.typeNat16)
  root_context.type_add('Nat32', type.typeNat32)
  root_context.type_add('Nat64', type.typeNat64)
  root_context.type_add('Float16', type.typeFloat16)
  root_context.type_add('Float32', type.typeFloat32)
  root_context.type_add('Float64', type.typeFloat64)
  root_context.type_add('Str', type.typeStr)
  root_context.type_add('Pointer', type.typeFreePtr)

  root_context.type_add('Bool', type.typeNat1)
  root_context.value_add('nil', valueNil)
  root_context.value_add('true', valueTrue)
  root_context.value_add('false', valueFalse)


  # Set taget depended Int & Nat types
  # (used in index, extra agrs & generic numeric var definitions)

  global typeSysInt, typeSysNat

  typeSysInt = copy.copy(select_int(int_size))
  typeSysInt['c_alias'] = 'int'

  typeSysNat = copy.copy(select_nat(int_size))
  typeSysNat['c_alias'] = 'unsigned int'




# last fiels of record can be zero size array (!)
# (only with -funsafe key)
def do_field(x, is_last=False):
  t = do_type(x['type'])

  if type.is_bad(t):
    t = hlir_type_bad(x['type']['ti'])

  if type.is_forbidden_var(t, zero_array_forbidden=not is_last):
    error("unsuitable type", x['type'])

  return hlir_field(x['id'], t, ti=x['ti'])


#
# Do Type
#

def do_type_id(t):
  tx = type_get(t['id']['str'])
  if tx == None:
    id = t['id']['str']
    error("undeclared type %s" % id, t)
    # create fake alias for unknown type
    tx = hlir_type_bad()
    nt = type.create_alias(id, tx, t['ti'])
    root_context.type_add(id, nt)
    return nt
  return tx


def do_type_pointer(t):
  to = do_type(t['to'])
  return hlir_type_pointer(to, ti=t['ti'])


def do_type_array(t):
  of = do_type(t['of'])

  tx = hlir_type_array(of)

  if t['size'] != None:
    size_expr = do_value(t['size'])
    tx['volume'] = size_expr

  return tx


def do_type_record(t):
  fields = []

  nfields = len(t['fields'])
  i = 0
  while i < nfields:
    f = do_field(t['fields'][i], is_last=i==(nfields-1))
    f['no'] = i
    i = i + 1

    f_exist = None #TODO! type.record_field_get(record, f['id']['str'])
    if f_exist != None:
      error("redefinition of '%s'" % f['id']['str'], f)
      continue

    fields.append(f)

  return hlir_type_record(fields, ti=t['ti'])


def do_type_enum(t):

  enum_type = {
    'isa': 'type',
    'kind': 'enum',
    'items': [],
    'size': settings_get('enum_size'),
    'att': [],
    'ti': t['ti']
  }

  i = 0
  while i < len(t['items']):
    id = t['items'][i]
    enum_type['items'].append({
      'isa': 'item',
      'id': id['id'],
      'number': i,
      'ti': id['ti']
    })

    # add enum item to global context
    item_val = hlir_value_int(i, typ=enum_type, ti=id['ti'])
    module['context'].value_add(id['id']['str'], item_val)

    i = i + 1

  return enum_type


def do_type_func(t):
  params = []

  for param in t['params']:
    param = do_field(param)
    if type.is_array(param['type']):
      error("function parameter cannot be an array", param)
    if param != None:
      params.append(param)

  to = None
  if t['to'] != None:
    to = do_type(t['to'])
  else:
    to = type.typeUnit

  return hlir_type_func(params, to)



def do_type(t):
  k = t['kind']

  if k == 'id': return do_type_id(t)
  elif k == 'pointer': return do_type_pointer(t)
  elif k == 'array': return do_type_array(t)
  elif k == 'record': return do_type_record(t)
  elif k == 'enum': return do_type_enum(t)
  elif k == 'func': return do_type_func(t)

  return bad_type(t['ti'])



#
# Do Statement
#


def do_value_shift(op, l, r, ti):

  if not type.is_numeric(l['type']):
    error("type error", l)

  if not type.is_numeric(r['type']):
    error("type error", r)

  # const folding
  #if not settings_check('backend', 'c'):
  if value_is_immediate(l) and value_is_immediate(r):
    xv = 0
    if op == 'shl': xv = hlir_value_num_get(l) << hlir_value_num_get(r)
    elif op == 'shr': xv = hlir_value_num_get(l) >> hlir_value_num_get(r)

    v = hlir_value_bin(op, l, r, l['type'], ti=ti)
    v['att'].append('immediate')
    v['num'] = xv
    return v
    #return hlir_value_int(xv, typ=l['type'], ti=ti)


  if type.is_generic(l['type']):
    #if value.is_immediate(r['type']):
    error("required type", l)

  return hlir_value_bin(op, l, r, l['type'], ti=ti)




# const folding for binary operation
def value_bin_fold(op, l, r, t, ti):
    ops = {
      'or': lambda a, b: a or b,
      'and': lambda a, b: a and b,
      'xor': lambda a, b: (a and not b) or (not a and b),
      'eq': lambda a, b: 1 if a == b else 0,
      'ne': lambda a, b: 1 if a != b else 0,
      'lt': lambda a, b: 1 if a < b else 0,
      'gt': lambda a, b: 1 if a > b else 0,
      'le': lambda a, b: 1 if a <= b else 0,
      'ge': lambda a, b: 1 if a >= b else 0,
      'add': lambda a, b: a + b,
      'sub': lambda a, b: a - b,
      'mul': lambda a, b: a * b,
      'div': lambda a, b: int(a / b),
      'mod': lambda a, b: a % b,
    }

    num_val = ops[op](hlir_value_num_get(l), hlir_value_num_get(r))
    return hlir_value_int(num_val, typ=l['type'], ti=ti)


def do_value_bin(x):
  k = x['kind']
  l = do_value(x['left'])
  r = do_value(x['right'])
  ti = x['ti']

  if value_is_bad(l) or value_is_bad(r):
    return hlir_value_bad(ti)

  if k in ['shl', 'shr']:
    return do_value_shift(k, l, r, ti)


  p_and_n = type.is_free_pointer(l['type']) and type.is_numeric(r['type'])
  n_and_p = type.is_numeric(l['type']) and type.is_free_pointer(r['type'])

  if k in ['add', 'sub']:
    if 'unsafe' in features:
      if p_and_n or n_and_p:
        if value_is_immediate(l) and value_is_immediate(r):
          typ = None
          if p_and_n:
            typ = l['type']
          elif n_and_p:
            typ = r['type']

          num = 0
          if k == 'add': num = hlir_value_num_get(l) + hlir_value_num_get(r)
          elif k == 'sub': num = hlir_value_num_get(l) - hlir_value_num_get(r)

          return hlir_value_int(num, typ=typ, ti=ti)

        pass


  # IR (LLVM)  ptr +/- num
  # для си это же смотри выше
  if p_and_n:
    lnat = do_cast_runtime(l, typeSysNat, ti)
    xr = value_cast_implicit(r, lnat['type'], ti)
    result = hlir_value_bin(x['kind'], lnat, xr, xr['type'], ti)
    return do_cast_runtime(result, l['type'], ti)

  if n_and_p:
    rnat = do_cast_runtime(r, typeSysNat, ti)
    xl = value_cast_implicit(l, rnat['type'], ti)
    result = hlir_value_bin(x['kind'], rnat, xl, xl['type'], ti)
    return do_cast_runtime(result, r['type'], ti)

  if type.is_free_pointer(l['type']) and type.is_pointer(r['type']):
    l = copy.copy(l)
    l['type'] = r['type']
  elif type.is_pointer(l['type']) and type.is_free_pointer(r['type']):
    r = copy.copy(r)
    r['type'] = l['type']

  l = value_cast_implicit(l, r['type'], l['ti'])
  r = value_cast_implicit(r, l['type'], r['ti'])

  if not k in ['eq', 'ne']:
    if not k in ['add', 'sub']:  # add, sub, for free pointers
      if not type_attribute_check(l['type'], 'numeric'):
        error("expected value with numeric type", x['left'])
        return hlir_value_bad(ti)
      if not type_attribute_check(r['type'], 'numeric'):
        error("expected value with numeric type", x['right'])
        return hlir_value_bad(ti)


  if not (p_and_n or n_and_p):
    if not type.check(l['type'], r['type'], x['ti']):
      return hlir_value_bad(x['ti'])

  # < > <= >= only for values with 'ordered' type
  if k in ['lt', 'gt', 'le', 'ge']:
    if not type_attribute_check(l['type'], 'ordered'):
      error("expected value with ordered type", l)
    if not type_attribute_check(r['type'], 'ordered'):
      error("expected value with ordered type", r)

  t = l['type']
  if k in ['eq', 'ne', 'lt', 'gt', 'le', 'ge']:
    t = type.typeNat1


  nv = hlir_value_bin(x['kind'], l, r, t, ti=ti)

  # if left & right are immediate, we can fold const
  # and append field 'num' to nv
  if value_is_immediate(l) and value_is_immediate(r):
    folded = value_bin_fold(k, l, r, t, ti)

    nv['type'] = folded['type']
    nv['num'] = folded['num']
    nv['att'].append('immediate')

  return nv



def do_value_not(val, t, ti):
  v = hlir_value_un('not', val, t, ti=ti)

  if value_is_immediate(val):
    v['num'] = ~hlir_value_num_get(val)
    v['att'].append('immediate')

  return v


def do_value_minus(val, t, ti):
  v = hlir_value_un('minus', val, t, ti=ti)

  if value_is_immediate(val):
    v['num'] = -hlir_value_num_get(val)
    v['att'].append('immediate')

  return v




# string literal dereference ` * "Hello World!" `
# returns array of chars
def do_value_deref_string(val, t, ti):
  # разыменование строки это особый случай
  # поскольку она хоть и числится указателем на массив,
  # но она в себе несет поля str и len
  # и после разыменования мы должны получить массив элементов
  items = []
  for c in val['str']:
    cc = hlir_value_int(ord(c), typ=type.typeChar, ti=None)
    items.append(cc)
  return hlir_value_array(t['to'], items, ti=ti)



def do_value_deref(val, t, ti):
  if not type.is_pointer(t):
    error("expected pointer", val)
    return hlir_value_bad(ti)

  to = t['to']
  # you can't deref pointer to function
  # and pointer to undefined array
  if type.is_func(to) or type.is_undefined_array(to):
    error("unsuitable type", val)


  # string literal dereference
  if value_is_immediate(val):
    if 'string' in val['att']:
      return do_value_deref_string(val, t, ti)

  return hlir_value_un('deref', val, to, ti=ti)



def do_value_ref(val, t, ti):
  if value_is_immutable(val):
    if not type.is_func(t):
      error("cannot get pointer to immutable value", ti)
  vt = hlir_type_pointer(t, ti=ti)
  return hlir_value_un('ref', val, vt, ti=ti)



def do_value_un(x):
  val = do_value(x['value'])
  ti = x['ti']

  if value_is_bad(val):
    return val

  t = val['type']

  if x['kind'] == 'not': return do_value_not(val, t, ti)
  elif x['kind'] == 'minus': return do_value_minus(val, t, ti)
  elif x['kind'] == 'deref': return do_value_deref(val, t, ti)
  elif x['kind'] == 'ref': return do_value_ref(val, t, ti)



def do_value_call(x):
  f = do_value(x['left'])

  if value_is_bad(f):
    return hlir_value_bad(x['ti'])

  ftype = f['type']

  # pointer to function?
  if type.is_pointer(ftype):
    ftype = ftype['to']

  if not type.is_func(ftype):
    error("expected function", x)

  params = ftype['params']
  args = x['args']

  npars = len(params)
  nargs = len(args)

  if nargs < npars:
    error("not enough args", x)
    return hlir_value_bad(x['ti'])

  if nargs > npars:
    if not type_attribute_check(ftype, 'arghack'):
      error("too many args", x)
      return hlir_value_bad(x['ti'])

  args = []

  # normal args
  i = 0
  while i < npars:
    param = params[i]
    arg = do_value(x['args'][i])

    if not value_is_bad(arg):
      arg = value_cast_implicit(arg, param['type'], arg['ti'])
      type.check(param['type'], arg['type'], arg['ti'])
      args.append(arg)

    i = i + 1


  # arghack rest args
  while i < nargs:
    arg = do_value(x['args'][i])

    if not value_is_bad(arg):
      arg = value_cast_implicit(arg, typeSysInt, arg['ti'])
      args.append(arg)

    i = i + 1

  return hlir_value_call(f, args, ti=x['ti'])



def do_value_index(x):
  a = do_value(x['left'])

  if value_is_bad(a):
    return hlir_value_bad(x['ti'])

  typ = a['type']

  ptr_access = type.is_pointer(typ)
  if ptr_access:
    typ = typ['to']

  # check if is record
  if not type.is_array(typ):
    error("expected array or pointer to array", x)
    return hlir_value_bad(x['left']['ti'])

  i = do_value(x['index'])

  if value_is_bad(i):
    return hlir_value_bad(x['index']['ti'])

  if not type.is_integer(i['type']):
    error("expected integer value", x['index'])

  # check if index out-of-bounds
  if i['kind'] == 'int':
    if typ['size'] != None:
      if hlir_value_num_get(i) >= typ['size']:
        error("array index out of bounds", x['index'])

  i = value_cast_implicit(i, typeSysInt, i['ti'])

  # immediate index (!)
  if value_is_immediate(a):
    if value_is_immediate(i):
      return a['items'][i['num']]

  if ptr_access:
    v = hlir_value_index_array_by_ptr(a, i, ti=x['ti'])
  else:
    v = hlir_value_index_array(a, i, ti=x['ti'])
    if value_is_immutable(a):
      v['att'].append('immutable')

  return v



def do_value_access(x):
  r = do_value(x['left'])

  if value_is_bad(r):
    return hlir_value_bad(x['ti'])

  field_id = x['field']

  # доступ через переменную-указатель
  ptr_access = type.is_pointer(r['type'])

  record_type = r['type']
  if ptr_access:
    record_type = r['type']['to']

  # check if is record
  if not type.is_record(record_type):
    error("expected record or pointer to record", x)
    return hlir_value_bad(x['left']['ti'])

  field = type.record_field_get(record_type, field_id['str'])

  # if field not found
  if field == None:
    error("undefined field '%s'" % field_id['str'], x)
    return hlir_value_bad(x['field']['ti'])

  if type.is_bad(field['type']):
    return hlir_value_bad(x['field']['ti'])

  # immediate access (!)
  if value_is_immediate(r):
    field_id_str = field_id['str']
    v = r['items'][field_id_str]
    nv = copy.copy(v)
    nv['value'] = hlir_value_access_record(r, field, ti=x['ti'])
    return nv


  if ptr_access:
    v = hlir_value_access_record_by_ptr(r, field, ti=x['ti'])
  else:
    v = hlir_value_access_record(r, field, ti=x['ti'])
    if value_is_immutable(r):
      v['att'].append('immutable')

  return v



def do_value_to(x):
  t = do_type(x['type'])
  v = do_value(x['value'])
  if value_is_bad(v) or type.is_bad(t):
    return hlir_value_bad(x['ti'])
  return value_cast_explicit(v, t, x['ti'])




def do_value_id(x):
  id_str = x['id']['str']
  vx = value_get(id_str)
  if vx == None:
    error("undeclared value '%s'" % x['id']['str'], x)

    # чтобы не генерил ошибки дальше
    # создадим bad value и пропишем его глобально
    v = hlir_value_bad(x['ti'])
    value_attribute_add(v, 'unknown')
    module['context'].value_add(id_str, v)
    return hlir_value_bad(x['ti'])

  # for TI чтобы не переписать у самого определения
  vx = copy.copy(vx)
  vx['ti'] = x['ti']
  return vx



"""def do_value_ns(x):
  ns_id = x['ids'][0]
  id = x['ids'][1]

  ns_id_str = ns_id['str']
  if not ns_id_str in module['imwports']:
    error("namespace nof found", ns_id)

  return hlir_value_bad(ns_id['ti'])"""



def do_value_str(x):
  string = x['str']
  length = x['len']

  # type of any C string is *[x]typeChar
  vol = hlir_value_int(length)
  ta = hlir_type_array(type.typeChar, volume=vol, ti=x['ti'])
  stype = hlir_type_pointer(ta)

  s =  hlir_value_cstr(string, length, stype, ti=x['ti'])
  module['strings'].append(s)
  return s



def do_value_array(x):
  items = []
  for i in x['items']:
    vi = do_value(i)
    items.append(vi)

  n = len(x['items'])

  of = None
  if n > 0:
    of = items[0]['type']

  # implicit cast array items to 'of' type
  items2 = items
  if of != None:
    items2 = []
    for item in items:
      i2 = value_cast_implicit(item, of, item['ti'])
      items2.append(i2)

  vol = hlir_value_int(n)
  type = hlir_type_array(of, volume=vol, ti=x['ti'])
  type['att'].extend(['generic'])
  return hlir_value_array(type, items2, ti=x['ti'])



def do_value_record(x):
  items = {}
  fields = []
  i = 0
  for item in x['items']:
    id = item['id']

    val = do_value(item['value'])
    items[id['str']] = val

    # создаем поле для типа generic записи
    field = hlir_field(id, val['type'], ti=val['ti'])
    field['no'] = i
    fields.append(field)
    i = i + 1

  typ = hlir_type_record(fields, ti=x['ti'])
  typ['att'].extend(['generic'])
  return hlir_value_record(typ, items, ti=x['ti'])



def do_value_int(x):
  rv = hlir_value_int(x['num'], ti=x['ti'])

  if 'hexadecimal' in x['att']:
    value_attribute_add(rv, 'hexadecimal')

  return rv


def do_value_float(x):
  return hlir_value_float(x['num'], ti=x['ti'])


def do_value_sizeof(x):
  of = do_type(x['type'])
  return hlir_value_sizeof(of, ti=x['ti'])



bin_ops = [
  'or', 'xor', 'and', 'shl', 'shr',
  'eq', 'ne', 'lt', 'gt', 'le', 'ge',
  'add', 'sub', 'mul', 'div', 'mod'
]

un_ops = ['ref', 'deref', 'plus', 'minus', 'not']


def do_value(x):
  k = x['kind']

  rv = None

  if k in bin_ops: rv = do_value_bin(x)
  elif k in un_ops: rv = do_value_un(x)
  else:
    if k == 'int': rv = do_value_int(x)
    elif k == 'float': rv = do_value_float(x)
    elif k == 'id': rv = do_value_id(x)
#    elif k == 'ns': rv = do_value_ns(x)
    elif k == 'str': rv = do_value_str(x)
    elif k == 'record': rv = do_value_record(x)
    elif k == 'array': rv = do_value_array(x)
    else:
      if k == 'call': rv = do_value_call(x)
      elif k == 'index': rv = do_value_index(x)
      elif k == 'access': rv = do_value_access(x)
      elif k == 'cast': rv = do_value_to(x)
      elif k == 'sizeof': rv = do_value_sizeof(x)

  if rv == None:
    rv = hlir_value_bad(x['ti'])

  assert('ti' in rv)

  return rv



#
# Do Statement
#

def do_stmt_if(x):
  c = do_value(x['cond'])
  t = do_stmt(x['then'])

  if value_is_bad(c) or stmt_is_bad(t):
    return hlir_stmt_bad()

  c = value_cast_implicit(c, type.typeNat1, c['ti'])
  type.check(c['type'], type.typeNat1, x['cond']['ti'])

  e = None
  if x['else'] != None:
    e = do_stmt(x['else'])
    if stmt_is_bad(e):
      return hlir_stmt_bad()

  return hlir_stmt_if(c, t, e, ti=x['ti'])



def do_stmt_while(x):
  c = do_value(x['cond'])
  s = do_stmt(x['stmt'])
  if value_is_bad(c) or stmt_is_bad(s):
    return hlir_stmt_bad()

  c = value_cast_implicit(c, type.typeNat1, c['ti'])
  if not type.check(c['type'], type.typeNat1, x['cond']['ti']):
    return hlir_stmt_bad()

  return hlir_stmt_while(c, s, ti=x['ti'])



def do_stmt_return(x):
  global cfunc
  assert(cfunc != None)

  no_ret_func = type.eq(cfunc['type']['to'], type.typeUnit)

  if x['value'] == None:
    if not no_ret_func:
      error("expected return value", x)
    return hlir_stmt_return(ti=x['ti'])

  if no_ret_func:
    error("unexpected return value", x)

  v = do_value(x['value'])
  if value_is_bad(v):
    return hlir_stmt_bad()

  v = value_cast_implicit(v, cfunc['type']['to'], v['ti'])
  type.check(v['type'], cfunc['type']['to'], x['value']['ti'])

  return hlir_stmt_return(v, ti=x['ti'])



def do_stmt_again(x):
  return hlir_stmt_again(x['ti'])


def do_stmt_break(x):
  return hlir_stmt_break(x['ti'])


def do_stmt_var(x):
  id = x['id']

  t = None
  v = None

  if x['type'] != None:
    t = do_type(x['type'])

  if x['value'] != None:
    v = do_value(x['value'])

  # error: no type, no init value
  if t == None and v == None:
    module['context'].value_add(id['str'], hlir_value_bad())
    return hlir_stmt_bad()

  if t != None:
    if type.is_bad(t):
      module['context'].value_add(id['str'], hlir_value_bad())
      return hlir_stmt_bad()

    if type.is_forbidden_var(t):
      error("unsuitable type", x['type'])

  # type & init value present
  if t != None and v != None:
    # type check
    v = value_cast_implicit(v, t, v['ti'])
    type.check(t, v['type'], v['ti'])



  if t == None:
    if type.is_generic_integer(v['type']):
      # если тип не указан явно, а у значения тип generic_integer
      # приводим его к системному инту
      v = value_cast_implicit(v, typeSysInt, v['ti'])

    t = v['type']

  # check if identifier is free (in current block)
  already = value_get_here(id['str'])
  if already != None:
    error("local id redefinition", x['id']['ti'])
    return hlir_stmt_bad()

  #
  var_value = hlir_value_var(id, t, ti=x['ti'])
  var_value['att'].extend(['local'])
  module['context'].value_add(id['str'], var_value)

  return hlir_stmt_def_var(id, t, v, ti=x['ti'])



def do_stmt_let(x):
  id = x['id']
  v = do_value(x['value'])
  if value_is_bad(v):
    module['context'].value_add(id['str'], hlir_value_bad())
    return hlir_stmt_bad()

  const_value = hlir_value_const(id, v['type'], init=v, ti=x['ti'])
  const_value['att'].extend(['local'])


  if value_is_immediate(v):
    if 'num' in v:
      # for LLVM (!) e.g. array volume
      const_value['num'] = v['num']


  # check if identifier is free (in current block)
  already = value_get_here(id['str'])
  if already != None:
    error("local id redefinition", x['id']['ti'])
    return hlir_stmt_bad()

  module['context'].value_add(id['str'], const_value)

  return hlir_stmt_def_const(id, v, ti=x['ti'])





def do_stmt_assign(x):
  l = do_value(x['left'])
  r = do_value(x['right'])

  if value_is_bad(l) or value_is_bad(r):
    return hlir_stmt_bad()

  if value_is_immutable(l):
    error("immutable left", x['left'])
    print(l['att'])
    return hlir_stmt_bad()

  # type check
  r = value_cast_implicit(r, l['type'], r['ti'])
  type.check(l['type'], r['type'], r['ti'])

  return hlir_stmt_assign(l, r, ti=x['ti'])




def do_stmt_value(x):
  v = do_value(x['value'])
  if value_is_bad(v):
    return hlir_stmt_bad()
  return hlir_stmt_value(v, ti=x['ti'])



def do_stmt(x):
  k = x['kind']

  s = None
  if k == 'let': s = do_stmt_let(x)
  elif k == 'block': s = do_stmt_block(x)
  elif k == 'value': s = do_stmt_value(x)
  elif k == 'assign': s = do_stmt_assign(x)
  elif k == 'return': s = do_stmt_return(x)
  elif k == 'if': s = do_stmt_if(x)
  elif k == 'while': s = do_stmt_while(x)
  elif k == 'var': s = do_stmt_var(x)
  elif k == 'again': s = do_stmt_again(x)
  elif k == 'break': s = do_stmt_break(x)
  else: s = hlir_stmt_bad()

  return s



def do_stmt_block(x):
  module['context'] = module['context'].branch(domain='local')

  stmts = []
  for stmt in x['stmts']:
    s = do_stmt(stmt)
    if not stmt_is_bad(s):
      stmts.append(s)

  module['context'] = module['context'].parent_get()

  return hlir_stmt_block(stmts, ti=x['ti'])




included_modules = {}
def do_import(x):
  impline = x['str']

  # right here, before calling "do_import" (!)
  att = attributes_get()

  #print("INCLUDE: %s" % (x['str']))

  # get abspath
  abspath = import_abspath(impline)
  if abspath == None:
    error("module not found", x)
    fatal("module not found")
    return None


  global included_modules
  if abspath in included_modules:
    # already imported
    m = included_modules[abspath]
  else:
    m = translate(abspath)
    included_modules[abspath] = m


  # 1. НЕ добавляем символы из модуля в текущий
  # тк поиск символа идет рекурсивно по всем импортам
  #module['context'].merge(m['context'])  #!

  # 1. добавляем проимпортированный модуль в список нашего импорта
  
  # но сперва проверим нет ли его уже среди импортированных модулей
  for imported_module in module['imports']:
    if imported_module['path'] == m['path']:
      error("attempt to include module twice", x['ti'])
  
  if m != None:
    module['imports'].append(m)

  # 2. А в нашем модуле добавляем директиву инклуда
  impline = x['str']
  directive = {
    'isa': 'directive',
    'kind': 'import',
    'str': impline[:-1],  # .hm -> .h
    'att': att,
    'local': True
  }

  module['text'].append(directive)




# form directive '@property'
def extend_props(x):
  global properties
  x.update(properties)
  properties = {}


def def_const(x):
  id = x['id']
  v = do_value(x['value'])

  if not value_is_immediate(v):
    error("expected immediate value", v)

  # (!) в дефиницию идет сам v;
  # а в контекст - значение-конатснта с id (нужно при C печати);
  # так же, в него идет поле value ссылающееся на v

  # идея: никаких объектов вида конст, просто само выражение,
  # но у него добавлено поле 'id' и атрибут 'const'
  # если оно сворачиваемое то может иметь поле num
  # так его сможет распечатать как LLVM так и C принтер

  nv = copy.copy(v)

  # выражение значения из которого он создан
  # юзается принтером при печати напр #define <id> <value>
  nv['value'] = v
  nv['id'] = id

  extend_props(nv)

  module['context'].value_add(id['str'], nv)

  definition = hlir_def_const(id, nv, v, ti=x['ti'])
  nv['definition'] = definition
  definition['att'].extend(attributes_get())

  # extern const для C принтера (не печатает)
  #if x['extern']:
  #  definition['att'].append('extern')

  return definition


# удаляет декларацию по имени
def module_remove_decl(m, kind, id_str):
  for submodule in m['imports']:
    module_remove_decl(submodule, kind, id_str)

  for x in m['text']:
    if x['isa'] == 'declaration':
      if x['kind'] == kind:
        if x[kind]['id']['str'] == id_str:
          #print("REMOVE: " + id_str)
          m['text'].remove(x)
          break


def def_type(x):
  id = x['id']
  t = do_type(x['type'])
  if type.is_bad(t):
    return def_bad()

  exist = type_get(id['str'])
  already_declared = exist != None

  nt = type.create_alias(id['str'], t, id['ti'])

  extend_props(nt)

  nt['att'].extend(attributes_get())


  if already_declared:
    # just overwrite existed 'opaque' type (for records)
    exist.update(nt)
    # and find and remove declaration instruction
    if settings_check('backend', 'llvm'):
      module_remove_decl(module, 'type', id['str'])
  else:
    module['context'].type_add(id['str'], nt)

  definition = hlir_def_type(x['id'], t, already_declared, ti=x['ti'])
  definition['att'].extend(attributes_get())
  nt['definition'] = definition

  return definition



def def_var(x):
  f = do_field(x['field'])

  if f == None:
    return None

  if type.is_bad(f['type']):
    return None

  if f['type']['kind'] == 'opaque':
    error("cannot create variable with undefined type", x['type'])
    return None

  init_value = None
  if x['init'] != None:
    iv = do_value(x['init'])
    init_value = value_cast_implicit(iv, f['type'], iv['ti'])
    type.check(init_value['type'], f['type'], x['init']['ti'])

  var = hlir_value_var(f['id'], f['type'], init=init_value)

  var['att'].extend(attributes_get())

  extend_props(var)

  module['context'].value_add(x['field']['id']['str'], var)

  definition = hlir_def_var(var, init_value, ti=x['ti'])
  definition['att'].extend(attributes_get())
  var['definition'] = definition

  return definition



def def_func(x):
  func_ti = x['ti']
  func_id = x['id']
  func_type = do_type(x['type'])

  # if function already declared/defined, check it
  already = value_get(func_id['str'])
  if already != None:
    if not type.eq(already['type'], func_type):
      error("func redefinition", x['ti'])
      info("firstly declared here", already['ti'])

  # create params context
  module['context'] = module['context'].branch(domain='local')

  global cfunc
  old_cfunc = cfunc

  cfunc = hlir_value_func(func_id, func_type, ti=func_ti)

  cfunc['att'].extend(attributes_get())

  extend_props(cfunc)

  params = func_type['params']
  i = 0
  while i < len(params):
    p = params[i]
    p_id = p['id']

    param = hlir_value_const(p_id, p['type'])
    param['att'].extend(['local'])
    module['context'].value_add(p_id['str'], param)

    i = i + 1


  cfunc['stmt'] = do_stmt_block(x['stmt'])

  # remove params context
  module['context'] = module['context'].parent_get()

  # add function to global context
  module['context'].value_add(func_id['str'], cfunc)

  definition = hlir_def_func(cfunc, ti=func_ti)
  cfunc['definition'] = definition

  cfunc = old_cfunc

  # в LLVM если делаем func definition нельзя писать func declaration
  # поэтому удалим все сделаные ранее декларации (если они есть)
  if settings_check('backend', 'llvm'):
    module_remove_decl(module, 'func', func_id['str'])

  return definition



def decl_type(x):
  id = x['id']
  #print("decl_type " + id['str'])

  nt = {
    'isa': 'type',
    'kind': 'opaque',
    'name': id['str'],
    'id': id,
    'att': [],
    'ti': id['ti'],
  }

  module['context'].type_add(id['str'], nt)

  # С не печатает opaque, но LLVM печатает (!)
  declaration = hlir_decl_type(x['id'], nt, ti=x['ti'])

  nt['declaration'] = declaration

  if x['extern']:
    declaration['att'].append('extern')

  declaration['att'].extend(attributes_get())

  return declaration



def decl_func(x):
  id = x['id']
  functype = do_type(x['type'])

  global attributes
  if "arghack" in attributes:
    functype['att'].append('arghack')

  func = hlir_value_func(id, functype, ti=x['ti'])
  func['att'].extend(['undefined'])

  extend_props(func)

  module['context'].value_add(id['str'], func)

  declaration = hlir_decl_func(func, ti=x['ti'])
  func['declaration'] = declaration
  declaration['att'].extend(attributes_get())

  if x['extern']:
    declaration['att'].append('extern')

  return declaration




def comm_line(x):
  #print("ast_comment-line")
  y = {
    'isa': 'comment',
    'kind': 'comment-line',
    'lines': x['lines'],
    'att': []
  }

  y['att'].extend(attributes_get())
  return y


def comm_block(x):
  #print("ast_comment-block")
  y = {
    'isa': 'comment',
    'kind': 'comment-block',
    'lines': x['lines'],
    'att': []
  }

  y['att'].extend(attributes_get())
  return y



def proc(ast, id="<MODULE_ID>", path="<MODULE_PATH>"):
  global module
  old_module = module

  #print("PROC: id = %s" % id)

  module = {
    'isa': 'module',
    'id': "<>",
    'path': path,
    'imports': [],
    'strings': [],
    'context': root_context.branch(),
    'text': []
  }

  for x in ast:
    isa = x['isa']
    kind = x['kind']

    y = None

    if isa == 'ast_definition':
      if kind == 'func':  y = def_func(x)
      elif kind == 'type':  y = def_type(x)
      elif kind == 'const': y = def_const(x)
      elif kind == 'var':   y = def_var(x)

    elif isa == 'ast_declaration':
      if kind == 'func': y = decl_func(x)
      elif kind == 'type': y = decl_type(x)

    elif isa == 'ast_comment':
      if kind == 'line': y = comm_line(x)
      elif kind == 'block': y = comm_block(x)

    elif isa == 'ast_directive':
      if kind == 'pragma':
        exec(x['text'])

      elif kind == 'import':
        do_import(x)

      elif kind == 'include':
        info("include instead import", x['ti'])
        do_import(x)

      continue


    if y == None:
      continue

    module['text'].append(y)

  m = module
  module = old_module

  return m




# получает строку импорта (и неявно глобальный контекст)
# и возвращает полный путь к модулю
def import_abspath(s):
  is_local = s[0:2] == './' or s[0:3] == '../'

  f = ''
  if is_local:
    f = env_current_file_dir + '/' + s #[1:]

  else: # (global)
    path_lib = settings_get('lib')
    f = path_lib + '/' + s

  if not os.path.exists(f):
    return None

  return os.path.abspath(f)



def translate(srcname):
  assert(srcname != None)
  assert(srcname != "")

  global env_current_file_abspath
  global env_current_file_dir
  old_env_current_file_dir = env_current_file_dir
  old_env_current_file_abspath = env_current_file_abspath

  absp = os.path.abspath(srcname)
  fdir = os.path.dirname(absp)

  env_current_file_abspath = absp
  env_current_file_dir = fdir
  #print("ABS: " + absp)
  #print("FDIR: " + fdir)

  #print("parse %s" % absp)
  ast = parser.parse(absp)

  if ast == None:
    return None

  #print("process %s" % absp)
  m = proc(ast, id=srcname, path=absp)
  #print("end %s" % absp)

  env_current_file_abspath = old_env_current_file_abspath
  env_current_file_dir = old_env_current_file_dir

  #included_modules = old_included_modules
  return m



