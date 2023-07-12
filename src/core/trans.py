
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
env_cfabs = ""
env_cfdir = ""

parser = Parser()

cfunc = None  # current function

root_context = None

module = None


# used in metadirs
def c_include(s):
  #print("c_include %s" % s)
  global module
  local = s[0:2] == './'
  inc = {
    'isa': 'directive',
    'kind': 'include',
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

def attribute_off(id):
  global attributes
  i = 0
  while i < len(attributes):
    if attributes[i] == id:
      del attributes[i]
    i = i + 1


# опциии компилятора, либо включена, либо выклчена
# впрочем может иметь и значение отлитчное от True
options = {}

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




def is_valid_lvalue(x):
  return x['kind'] in [
    'var', 'access', 'access_ptr', 'index', 'index_ptr', 'deref'
  ]


def stmt_is_bad(x):
  assert x != None
  return x['kind'] == 'bad'




def import_add(id, m):
  print("import_add: " + id)
  module['imports'].update({id: m})


def init():
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

  root_context.value_add('nil', valueNil)
  root_context.value_add('true', valueTrue)
  root_context.value_add('false', valueFalse)


# last fiels of record can be zero size array (!)
# (only with -funsafe key)
def do_field(x, is_last=False):
  t = do_type(x['type'])

  if type.is_bad(t):
    t = type.type_bad(x['type']['ti'])

  if type.is_forbidden_var(t, zero_array_forbidden=not is_last):
    error("unsuitable type", x['type'])

  return hlir_field(x['id'], t, ti=x['ti'])


#
# Do Type
#

def do_type_id(t):
  tx = module['context'].type_get(t['id']['str'])
  if tx == None:
    id = t['id']['str']
    error("undeclared type %s" % id, t)
    # create fake alias for unknown type
    tx = type.type_bad()
    nt = type.create_alias(id, tx, t['ti'])
    root_context.type_add(id, nt)
    return nt
  return tx #{'isa': 'type', 'kind': 'id', 'id': t['id'], 'type': tx}



def do_type_pointer(t):
  to = do_type(t['to'])
  return hlir_type_pointer(to, ti=t['ti'])



def do_type_array(t):
  of = do_type(t['of'])

  tx = hlir_type_array(of)

  if t['size'] != None:
    size_expr = do_value(t['size'])
    tx['volume'] = size_expr
    #tx['volume'] = value_num_get(size_expr)

  return tx



def do_type_record(t):
  fields = []

  nfields = len(t['fields'])
  i = 0
  while i < nfields:
    f = do_field(t['fields'][i], is_last=i==(nfields-1))
    f['no'] = i
    i = i + 1

    f_exist = None #TODO!/ type.record_field_get(record, f['id']['str'])
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

  to = do_type(t['to'])

  tx = hlir_type_func(params, to, att=[])
  #if 'arghack' in tx['att']:
  #  print("OOPOOPOOPP")
  return tx



def do_type(t):
  k = t['kind']
  if k == 'id': return do_type_id(t)
  elif k == 'pointer': return do_type_pointer(t)
  elif k == 'array': return do_type_array(t)
  elif k == 'record': return do_type_record(t)
  elif k == 'enum': return do_type_enum(t)
  elif k == 'func': return do_type_func(t)

  return bad_type()



#
# Do Statement
#


def do_value_shift(op, l, r, ti):

  if not type.is_numeric(l['type']):
    error("type error", l)

  if not type.is_numeric(r['type']):
    error("type error", r)


  # const folding
  if not settings_check('backend', 'c'):
    if value_is_immediate(l) and value_is_immediate(r):
      xv = 0
      if op == 'shl': xv = value_num_get(l) << value_num_get(r)
      elif op == 'shr': xv = value_num_get(l) >> value_num_get(r)

      t = l['type']

      return hlir_value_int(xv, typ=t, ti=ti)


  if type.is_generic(l['type']):
    #if value.is_immediate(r['type']):
    error("required type", l)

  return hlir_value_bin(op, l, r, l['type'], ti)





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

    num_val = ops[op](value_num_get(l), value_num_get(r))
    return hlir_value_int(num_val, typ=l['type'], ti=ti)


def do_value_expr_bin(x):
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
          if k == 'add':
            num = value_num_get(l) + value_num_get(r)
          elif k == 'sub':
            num = value_num_get(l) - value_num_get(r)

          return hlir_value_int(num, typ=typ, ti=ti)

        pass


  # IR (LLVM)  ptr +/- num
  # для си это же смотри выше
  if p_and_n:
    lnat = do_cast_runtime(l, type.typeNat, ti)
    xr = value_cast_implicit(r, lnat['type'], ti)
    result = hlir_value_bin(x['kind'], lnat, xr, xr['type'], ti)
    return do_cast_runtime(result, l['type'], ti)

  if n_and_p:
    rnat = do_cast_runtime(r, type.typeNat, ti)
    xl = value_cast_implicit(l, rnat['type'], ti)
    result = hlir_value_bin(x['kind'], rnat, xl, xl['type'], ti)
    return do_cast_runtime(result, r['type'], ti)


  l = value_cast_implicit(l, r['type'], l['ti'])
  r = value_cast_implicit(r, l['type'], r['ti'])

  if not k in ['eq', 'ne']:
    if not k in ['add', 'sub']:  # add, sub, for *Unit pointers
      if not type_attribute_check(l['type'], 'numeric'):
        error("type error", x['left'])
      if not type_attribute_check(r['type'], 'numeric'):
        error("type error", x['right'])


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


  nv = hlir_value_bin(x['kind'], l, r, t, ti)

  # if left & right are immediate, we can fold const
  # and append field 'num' to nv
  if value_is_immediate(l) and value_is_immediate(r):
    folded = value_bin_fold(k, l, r, t, ti)
    value_attribute_add(nv, 'immediate')
    nv['num'] = folded['num']
    return nv

  return nv



def do_value_expr_un(x):
  val = do_value(x['value'])

  if value_is_bad(val):
    return hlir_value_bad(x['ti'])

  t = val['type']

  # Immediate value
  if value_is_immediate(val):
    num = value_num_get(val)
    if x['kind'] == 'not':
      val['num'] = ~num
    elif x['kind'] == 'minus':
      val['num'] = -num
    return val


  if x['kind'] == 'deref':
    if not type.is_pointer(t):
      error("expected pointer", val)
      return hlir_value_bad(x['ti'])

    to = t['to']
    # you can't deref pointer to function
    # and pointer to undefined array
    if type.is_func(to) or type.is_undefined_array(to):
      error("unsuitable type", val)

    t = to

    return hlir_value_un(x['kind'], val, t, att=[], ti=x['ti'])


  if x['kind'] == 'ref':
    if value_is_immutable(val):
      error("cannot get pointer to immutable value", x)
    t = hlir_type_pointer(t, ti=x['ti'])


  return hlir_value_un(x['kind'], val, t, att=[], ti=x['ti'])



def do_value_expr_call(x):
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

  npars = len(params)
  nargs = len(x['args'])

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
    p = params[i]
    a = do_value(x['args'][i])

    if not value_is_bad(a):
      a = value_cast_implicit(a, p['type'], a['ti'])
      e = type.check(p['type'], a['type'], x['args'][i]['ti'])
      args.append(a)

    i = i + 1


  # arghack rest args
  while i < nargs:
    a = do_value(x['args'][i])

    if not value_is_bad(a):
      a = value_cast_implicit(a, type.typeInt, a['ti'])
      args.append(a)

    i = i + 1


  return hlir_value_call(f, args, ti=x['ti'])



def do_value_expr_index(x):
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

  # check if index out-of-bounds
  if i['kind'] == 'int':
    if typ['size'] != None:
      if value_num_get(i) >= typ['size']:
        error("array index out of bounds", x['index'])

  i = value_cast_implicit(i, type.typeInt, i['ti'])

  if ptr_access:
    return hlir_value_index_array_by_ptr(a, i, ti=x['ti'])
  else:
    return hlir_value_index_array(a, i, ti=x['ti'])



def do_value_expr_access(x):
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
    return hlir_value_bad(x['right']['ti'])

  if type.is_bad(field['type']):
    return hlir_value_bad(x['right']['ti'])

  attributes = []
  if not ptr_access:
    if value_is_immutable(r):
      attributes.append('immutable')

  if ptr_access:
    return hlir_value_access_record_by_ptr(r, field, ti=x['ti'])
  else:
    return hlir_value_access_record(r, field, ti=x['ti'])



def do_value_expr_to(x):
  t = do_type(x['type'])
  v = do_value(x['value'])
  if value_is_bad(v) or type.is_bad(t):
    return hlir_value_bad(x['ti'])
  return value_cast_explicit(v, t, x['ti'])



def do_value_expr_id(x):
  id_str = x['id']['str']
  vx = module['context'].value_get(id_str)
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



def do_value_expr_ns(x):
  ns_id = x['ids'][0]
  id = x['ids'][1]

  ns_id_str = ns_id['str']
  if not ns_id_str in module['imports']:
    error("namespace nof found", ns_id)

  return hlir_value_bad(ns_id['ti'])



def do_value_expr_str(x):
  string = x['str']
  length = x['len']

  # type of any C string is *[x]typeChar
  vol = hlir_value_int(length)
  ta = hlir_type_array(type.typeChar, volume=vol, ti=x['ti'])
  stype = hlir_type_pointer(ta)

  s =  hlir_value_cstr(string, length, stype, ti=x['ti'])
  module['strings'].append(s)
  return s


# select type for value x
# (generic type ~*> any suitable type)
def select_type(x):
  if type.is_generic(x['type']):
    return x['type']

  if type.is_integer(x['type']):
    return type.typeInt



def do_value_expr_array(x):
  items = []
  for i in x['items']:
    vi = do_value(i)
    items.append(vi)

  size = len(x['items'])

  of = select_type(items[0])
  vol = hlir_value_int(size)
  type = hlir_type_array(of, volume=vol, att=['generic'], ti=x['ti'])
  return hlir_value_array(type, items, ti=x['ti'])




def do_value_expr_record(x):
  items = []
  fields = []
  for item in x['items']:
    id = item['id']

    #print("K = " + item['value']['kind'])
    val = do_value(item['value'])

    """if isinstance(val['type'], list):
      for i in val['type']:
        print()
        print(i)"""

    items.append({'id': id, 'value': val})



    # создаем поле для типа generic записи
    field = hlir_field(id, select_type(val), ti=val['ti'])
    fields.append(field)

  typ = hlir_type_record(fields, att=['generic'], ti=x['ti'])
  return hlir_value_record(typ, items, ti=x['ti'])



def do_value_expr_int(x):
  rv = hlir_value_int(x['num'], ti=x['ti'])

  if 'hexadecimal' in x['att']:
    value_attribute_add(rv, 'hexadecimal')

  return rv


def do_value_expr_float(x):
  return hlir_value_float(x['num'], ti=x['ti'])


def do_value_expr_sizeof(x):
  of = do_type(x['type'])
  return hlir_value_sizeof(of, type.typeNat, ti=x['ti'])



bin_ops = [
  'or', 'xor', 'and', 'shl', 'shr',
  'eq', 'ne', 'lt', 'gt', 'le', 'ge',
  'add', 'sub', 'mul', 'div', 'mod'
]

un_ops = ['ref', 'deref', 'plus', 'minus', 'not']


def do_value(x):
  k = x['kind']

  rv = None

  if k in bin_ops: rv = do_value_expr_bin(x)
  elif k in un_ops: rv = do_value_expr_un(x)
  else:
    if k == 'int': rv = do_value_expr_int(x)
    elif k == 'float': rv = do_value_expr_float(x)
    elif k == 'id': rv = do_value_expr_id(x)
#    elif k == 'ns': rv = do_value_expr_ns(x)
    elif k == 'str': rv = do_value_expr_str(x)
    elif k == 'record': rv = do_value_expr_record(x)
    elif k == 'array': rv = do_value_expr_array(x)
    else:
      if k == 'call': rv = do_value_expr_call(x)
      elif k == 'index': rv = do_value_expr_index(x)
      elif k == 'access': rv = do_value_expr_access(x)
      elif k == 'cast': rv = do_value_expr_to(x)
      elif k == 'sizeof': rv = do_value_expr_sizeof(x)

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

  if t == None and v == None:
    module['context'].value_add(id['str'], hlir_value_bad())
    return hlir_stmt_bad()

  if t != None and v != None:
    # type check
    v = value_cast_implicit(v, t, v['ti'])
    type.check(t, v['type'], v['ti'])


  if t != None:
    if type.is_bad(t):
      module['context'].value_add(id['str'], hlir_value_bad())
      return hlir_stmt_bad()

    if type.is_forbidden_var(t):
      error("unsuitable type", x['type'])


  if t == None:
    t = v['type']

  # check if identifier is free (in current block)
  already = module['context'].value_get(id['str'], recursive=False)
  if already != None:
    error("local id redefinition", x['id']['ti'])
    return hlir_stmt_bad()

  #
  var_value = hlir_value_var(id, t, att=['local'], ti=x['ti'])
  module['context'].value_add(id['str'], var_value)

  return hlir_stmt_def_var(id, t, v, ti=x['ti'])



def do_stmt_let(x):
  id = x['id']
  v = do_value(x['value'])
  if value_is_bad(v):
    module['context'].value_add(id['str'], hlir_value_bad())
    return hlir_stmt_bad()

  vtype = v['type']

  # если это immediate константа, то она подставится принтером llvm
  # через механизм 'locals_' (!а здесь само значение не идет)
  const_value = hlir_value_var(id, v['type'], init=None, att=['local', 'immutable'], ti=x['ti'])

  # check if identifier is free (in current block)
  already = module['context'].value_get(id['str'], recursive=False)
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

  if not is_valid_lvalue(l):
    error("illegal left", x['left'])
    return hlir_stmt_bad()

  if value_is_immutable(l):
    error("immutable value", l)
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




# include аналог from xxx import *
included_modules = {}
def do_include(x):
  impline = x['str']
  #print("do_include: " + impline)

  # get abspath
  abspath = import_abspath(impline)
  if abspath == None:
    fatal("module not found", x)
    return None


  global included_modules
  if abspath in included_modules:
    m = included_modules[abspath]
    module['context'].merge(m['context'])  #!
    return None  # already imported


  m = translate(abspath)
  included_modules[abspath] = m

  #print("\nINCLUDE: " + impline)
  #m['context'].show_tables()

  # расширяем нашу таблицу символов таблицей импорта
  module['context'].merge(m['context'])


  # если не нужно печатать сожержимое заголовка
  # а просто напечатать #include "someheader.h"
  return_include_directive = False

  if settings_check('backend', 'cm'):
    return_include_directive = True

  if settings_check('backend', 'c'):
    if option_get('c-just-include'):
      option_off('c-just-include')
      return_include_directive = True


  if return_include_directive:
    directive = {
      'isa': 'directive',
      'kind': 'include',
      'str': impline[:-1],  # .hm -> .h
      'att': [],
      'local': True
    }

    directive['att'].extend(attributes)

    #if attribute_get('c-just-include'):
    # attribute_off('c-just-include')
    #  directive['att'].append('c-just-include')

    return [directive]

  return m['text']




def do_import(x):
  impline = x['str']
  #print("do_import " + impline)
  abspath = import_abspath(impline)

  if abspath == None:
    fatal("module not found", x)
    return None

  m = translate(abspath)

  print("\nIMPORT: " + impline)
  m['context'].show_tables()

  return m


# form directive '@property'
def extend_props(x):
  global properties
  x.update(properties)
  properties = {}


def def_const(x):
  id = x['id']
  v = do_value(x['value'])

  # (!) в дефиницию идет сам v;
  # а в контекст - значение-конатснта с id (нужно при C печати);
  # так же, в него идет поле value ссылающееся на v

  # идея: никаких объектов вида конст, просто само выражение,
  # но у него добавлено поле 'id' и атрибут 'const'
  # если оно сворачиваемое то может иметь поле num
  # так его сможет распечатать как LLVM так и C принтер

  v['id'] = id
  value_attribute_add(v, 'const')
  extend_props(v)

  module['context'].value_add(id['str'], v)

  global attributes
  v['att'].extend(attributes)

  definition = hlir_def_const(id, v, ti=x['ti'])
  v['definition'] = definition
  definition['att'].extend(attributes)

  return definition

# удаляет декларацию по имени
def module_text_remove_decl(kind, id_str):
  for x in module['text']:
    if x['isa'] == 'declaration':
      if x['kind'] == kind:
        if x[kind]['id']['str'] == id_str:
          #print("REMOVE: " + id_str)
          module['text'].remove(x)
          break


def def_type(x):
  id = x['id']
  t = do_type(x['type'])
  if type.is_bad(t):
    return def_bad()

  exist = module['context'].type_get(id['str'])
  already_declared = exist != None

  nt = type.create_alias(id['str'], t, id['ti'])

  extend_props(nt)

  global attributes
  nt['att'].extend(attributes)


  if already_declared:
    # just overwrite existed 'opaque' type (for records)
    exist.update(nt)
    # and find and remove declaration instruction
    module_text_remove_decl('type', id['str'])
  else:
    module['context'].type_add(id['str'], nt)


  if option_get("no_type_alias"):
    if option_get("no_type_alias") == 'once':
      option_off("no_type_alias")
    return None


  definition = hlir_def_type(x['id'], t, already_declared, ti=x['ti'])

  nt['definition'] = definition

  definition['att'].extend(attributes)

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

  global attributes
  var['att'].extend(attributes)

  extend_props(var)

  module['context'].value_add(x['field']['id']['str'], var)


  definition = hlir_def_var(var, init_value, ti=x['ti'])
  var['definition'] = definition

  return definition



def def_func(x):
  func_ti = x['ti']
  func_id = x['id']
  func_type = do_type(x['type'])

  # if function already declared/defined, check it
  already = module['context'].value_get(func_id['str'])
  if already != None:
    if not type.eq(already['type'], func_type):
      error("func redefinition", x['ti'])
      info("firstly declared here", already['ti'])

  # create params context
  module['context'] = module['context'].branch(domain='local')

  global cfunc
  old_cfunc = cfunc

  cfunc = hlir_value_func(func_id, func_type, att=[], ti=func_ti)

  global attributes
  cfunc['att'].extend(attributes)

  extend_props(cfunc)

  params = func_type['params']
  i = 0
  while i < len(params):
    p = params[i]
    p_id = p['id']
    param = hlir_value_var(p_id, p['type'], att=['param', 'local', 'immutable'])

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
    module_text_remove_decl('func', func_id['str'])

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

  declaration['att'].extend(attributes)

  return declaration



def decl_func(x):
  global attributes
  id = x['id']
  functype = do_type(x['type'])

  if option_get("arghack") == True:
    functype['att'].append('arghack')

  func = hlir_value_func(id, functype, att=['undefined'], ti=x['ti'])

  module['context'].value_add(id['str'], func)

  declaration = hlir_decl_func(func, ti=x['ti'])
  func['declaration'] = declaration
  declaration['att'].extend(attributes)

  if x['extern']:
    declaration['att'].append('extern')

  return declaration


def proc(ast):
  global local_attributes

  global module
  old_module = module


  module = {
    'isa': 'module',
    'id': "<>",
    #'path': srcname,
    'imports': {},
    'strings': [],
    'context': root_context.branch(),
    'text': []
  }


  for x in ast:
    isa = x['isa']
    kind = x['kind']

    y = None

    if isa == 'ast_definition':
      if   kind == 'func':  y = def_func(x)
      elif kind == 'type':  y = def_type(x)
      elif kind == 'const': y = def_const(x)
      elif kind == 'var':   y = def_var(x)

    elif isa == 'ast_declaration':
      if   kind == 'func': y = decl_func(x)
      elif kind == 'type': y = decl_type(x)

    elif isa == 'ast_directive2':
      exec(x['text'])
      continue

    elif isa == 'ast_directive':
      if kind == 'metadir':
        exec(x['text'])

      # импорт изменяет контекст, и продуцирует аутпут
      elif kind == 'import':
        m = do_import(x)
        import_add(x['str'], m)

      elif kind == 'include':
        y = do_include(x)
        if y != None:
          module['text'].extend(y)

      continue


    #local_attributes = []

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
    f = env_cfdir + '/' + s #[1:]

  else: # (global)
    path_lib = settings_get('library')
    f = path_lib + '/' + s

  if not os.path.exists(f):
    return None

  return os.path.abspath(f)



def translate(srcname):
  #print("translate!")
  #module['context'].show_tables()
  #root_context.show_tables()

  # выставляем директорию текущего файла
  # (будет использоваться в релативных инклудах)
  #global included_modules
  #old_included_modules = included_modules
  #included_modules = {}

  #srcname = import_abspath(srcname)
  if srcname == None:
    return None

  global env_cfabs
  global env_cfdir
  old_env_cfdir = env_cfdir
  old_env_cfabs = env_cfabs

  absp = os.path.abspath(srcname)
  env_cfabs = absp
  fdir = os.path.dirname(absp)
  env_cfdir = fdir
  #print("ABS: " + absp)
  #print("FDIR: " + fdir)

  if not os.path.exists(absp):
    return None

  ast = parser.parse(absp)
  #print("process %s" % absp)
  m = proc(ast)
  #print("end process %s" % absp)

  env_cfabs = old_env_cfabs
  env_cfdir = old_env_cfdir

  #included_modules = old_included_modules
  return m



