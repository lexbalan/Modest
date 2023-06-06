
import os
import copy

from error import *
from .mgmt import *
from .value import *
from .stmt import *
import core.ctx as ctx
import core.type as type
from core.type import type_attribute_check, type_print
from parser import Parser




parser = None

cfunc = None  # current function


output = []




def init():
  global parser
  parser = Parser()

  # init built-in context
  ctx.add_type('Unit', type.typeUnit)
  ctx.add_type('Int', type.typeInt)
  ctx.add_type('Nat', type.typeNat)
  ctx.add_type('Int8', type.typeInt8)
  ctx.add_type('Int16', type.typeInt16)
  ctx.add_type('Int32', type.typeInt32)
  ctx.add_type('Int64', type.typeInt64)
  ctx.add_type('Nat1', type.typeNat1)
  ctx.add_type('Nat8', type.typeNat8)
  ctx.add_type('Nat16', type.typeNat16)
  ctx.add_type('Nat32', type.typeNat32)
  ctx.add_type('Nat64', type.typeNat64)
  ctx.add_type('Float16', type.typeFloat16)
  ctx.add_type('Float32', type.typeFloat32)
  ctx.add_type('Float64', type.typeFloat64)
  ctx.add_type('Str', type.typeStr)



def do_field(x):
  t = do_type(x['type'])

  if type.is_bad(t):
    t = type.type_bad(x['type']['ti'])

  if type.is_forbidden(t):
    error("unsuitable type", x['type']['ti'])

  return {
    'isa': 'field',
    'id': x['id'],
    'type': t,
    'ti': x['ti']
  }



#
# Do Type
#

def do_type_id(t):
  tx = ctx.get_type(t['id']['str'])
  if tx == None:
    error("undeclared type %s" % t['id']['str'], t['ti'])
    return type.type_bad()
  return tx #{'isa': 'type', 'kind': 'id', 'id': t['id'], 'type': tx}



def do_type_pointer(t):
  to = do_type(t['to'])
  return type.typePointer(to, ti=t['ti'])



def do_type_array(t):
  tx = {
    'isa': 'type',
    'kind': 'array',
    'size': None,
    'attributes': [],
    'ti': t['ti']
  }
  tx['of'] = do_type(t['of'])

  if t['size'] != None:
    size_expr = do_value(t['size'])
    tx['size_expr'] = size_expr
    tx['size'] = value_num_get(size_expr)

  return tx



def do_type_record(t):
  fields = []
  record = {
    'isa': 'type',
    'kind': 'record',
    'fields': fields,
    'size': 0,
    'attributes': [],
    'ti': t['ti']
  }

  i = 0
  while i < len(t['fields']):
    f = do_field(t['fields'][i])
    f['no'] = i
    i = i + 1

    f_exist = type.record_field_get(record, f['id']['str'])
    if f_exist != None:
      error("redefinition of '%s'" % f['id']['str'], f['ti'])
      continue

    fields.append(f)

  return record



def do_type_enum(t):

  enum_type = {
    'isa': 'type',
    'kind': 'enum',
    'items': [],
    'size': settings_get('enum_size'),
    'attributes': [],
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
    item_val = value_create_int(i, typ=enum_type, ti=id['ti'])
    ctx.add_value(id['id']['str'], item_val)

    i = i + 1

  return enum_type



def do_type_func(t):
  params = []

  for param in t['params']:
    param = do_field(param)
    if param != None:
      params.append(param)

  to = do_type(t['to'])

  return {
    'isa': 'type',
    'kind': 'func',
    'params': params,
    'to': to,
    'attributes': [],
    'ti': t['ti']
  }


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


bin_ops = [
  'or', 'xor', 'and', 'shl', 'shr',
  'eq', 'ne', 'lt', 'gt', 'le', 'ge',
  'add', 'sub', 'mul', 'div', 'mod'
]

un_ops = ['ref', 'deref', 'plus', 'minus', 'not']




def type_select(n):
  """if n <= 8 : return type.typeNat8
  elif n <= 16 : return type.typeNat16
  elif n <= 32 : return type.typeNat32
  elif n <= 64 : return type.typeNat64
  else: return type.typeNat64"""
  return {
    'isa': 'type',
    'kind': 'integer',
    'name': '<generic:int>',
    'attributes': ['generic', 'numeric', 'ordered'],
    'size': n / 8,
    'ti': None
  }




def do_value_shift(op, l, r, ti):

  if not type.is_numeric(l['type']):
    error("type error", l['ti'])

  if not type.is_numeric(r['type']):
    error("type error", r['ti'])


  # const folding
  if not settings_check('backend', 'c'):
    if value_is_immediate(l) and value_is_immediate(r):
      xv = 0
      if op == 'shl': xv = value_num_get(l) << value_num_get(r)
      elif op == 'shr': xv = value_num_get(l) >> value_num_get(r)

      t = l['type']

      return value_create_int(xv, typ=t, ti=ti)


  if type.is_generic(l['type']):
    #if value.is_immediate(r['type']):
    error("required type", l['ti'])

  return value_create_bin(op, l, r, l['type'], ti)





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
    return value_create_int(num_val, typ=l['type'], ti=ti)

def do_value_expr_bin(x):
  k = x['kind']
  l = do_value(x['left'])
  r = do_value(x['right'])
  ti = x['ti']

  if value_is_bad(l) or value_is_bad(r):
    return value_create_bad(ti)

  if k in ['shl', 'shr']:
    return do_value_shift(k, l, r, ti)


  p_and_n = type.is_free_pointer(l['type']) and type.is_numeric(r['type'])
  n_and_p = type.is_numeric(l['type']) and type.is_free_pointer(r['type'])

  if k in ['add', 'sub']:
    if features_get('unsafe'):
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

          return value_create_int(num, typ=typ, ti=ti)

        pass


  # IR (LLVM)  ptr +/- num
  # для си это же смотри выше
  if p_and_n:
    lnat = do_cast_runtime(l, type.typeNat, ti)
    xr = value_cast_implicit(r, lnat['type'], ti)
    result = value_create_bin(x['kind'], lnat, xr, xr['type'], ti)
    return do_cast_runtime(result, l['type'], ti)

  if n_and_p:
    rnat = do_cast_runtime(r, type.typeNat, ti)
    xl = value_cast_implicit(l, rnat['type'], ti)
    result = value_create_bin(x['kind'], rnat, xl, xl['type'], ti)
    return do_cast_runtime(result, r['type'], ti)


  l = value_cast_implicit(l, r['type'], l['ti'])
  r = value_cast_implicit(r, l['type'], r['ti'])

  if not k in ['eq', 'ne']:
    if not k in ['add', 'sub']:  # add, sub, for *Unit pointers
      if not type_attribute_check(l['type'], 'numeric'):
        error("type error", x['left']['ti'])
      if not type_attribute_check(r['type'], 'numeric'):
        error("type error", x['right']['ti'])


  if not (p_and_n or n_and_p):
    if not type.check(l['type'], r['type'], x['ti']):
      return value_create_bad(x['ti'])

  # < > <= >= only for values with 'ordered' type
  if k in ['lt', 'gt', 'le', 'ge']:
    if not type_attribute_check(l['type'], 'ordered'):
      error("expected value with ordered type", l['ti'])
    if not type_attribute_check(r['type'], 'ordered'):
      error("expected value with ordered type", r['ti'])

  t = l['type']
  if k in ['eq', 'ne', 'lt', 'gt', 'le', 'ge']:
    t = type.typeNat1


  if value_is_immediate(l) and value_is_immediate(r):
    folded = value_bin_fold(k, l, r, t, ti)
    if settings_check('backend', 'llvm'):
      return folded
    else:
      vn = value_create_bin(x['kind'], l, r, t, ti)
      value_attribute_add(vn, 'immediate')
      vn['num'] = folded['num']
      return vn

  return value_create_bin(x['kind'], l, r, t, ti)



def do_value_expr_un(x):
  val = do_value(x['value'])

  if value_is_bad(val):
    return value_create_bad(x['ti'])

  t = val['type']

  # Immediate value
  if value_is_immediate(val):
    num = value_num_get(val)
    if x['kind'] == 'not':
      num = ~num
    elif x['kind'] == 'minus':
      num = -num
    return value_create_int(num, typ=t, ti=x['ti'])


  if x['kind'] == 'deref':
    if not type.is_pointer(t):
      error("expected pointer", val['ti'])
      return value_create_bad(x['ti'])

    to = t['to']
    # you can't deref pointer to function
    # and pointer to undefined array
    if type.is_func(to) or type.is_undefined_array(to):
      error("unsuitable type", val['ti'])

    t = to

    return {
      'isa': 'value',
      'kind': x['kind'],
      'value': val,
      'type': t,
      'attributes': ['adr'],
      'properties': {},
      'ti': x['ti']
    }

  if x['kind'] == 'ref':
    if value_is_immutable(val):
      error("cannot get pointer to immutable value", x['ti'])
    t = type.typePointer(t, ti=x['ti'])


  return {
    'isa': 'value',
    'kind': x['kind'],
    'value': val,
    'type': t,
    'attributes': [],
    'properties': {},
    'ti': x['ti']
  }



def do_value_expr_call(x):
  f = do_value(x['left'])

  if value_is_bad(f):
    return value_create_bad(x['ti'])

  ftype = f['type']

  # pointer to function?
  if type.is_pointer(ftype):
    ftype = ftype['to']

  if not type.is_func(ftype):
    error("expected function", x['ti'])

  params = ftype['params']

  npars = len(params)
  nargs = len(x['args'])

  if nargs < npars:
    error("not enough args", x['ti'])
    return value_create_bad(x['ti'])

  if nargs > npars:
    if not type_attribute_check(ftype, 'arghack'):
      error("too many args", x['ti'])
      return value_create_bad(x['ti'])

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


  return {
    'isa': 'value',
    'kind': 'call',
    'left': f,
    'args': args,
    'type': ftype['to'],
    'attributes': [],
    'properties': {},
    'ti': x['ti']
  }



def do_value_expr_index(x):
  a = do_value(x['left'])

  if value_is_bad(a):
    return value_create_bad(x['ti'])

  typ = a['type']

  ptr_access = type.is_pointer(typ)
  if ptr_access:
    typ = typ['to']

  # check if is record
  if not type.is_array(typ):
    error("expected array or pointer to array", x['ti'])
    return value_create_bad(x['left']['ti'])

  i = do_value(x['index'])

  if value_is_bad(i):
    return value_create_bad(x['right']['ti'])

  # check if index out-of-bounds
  if i['kind'] == 'int':
    if typ['size'] != None:
      if value_num_get(i) >= typ['size']:
        error("array index out of bounds", x['index']['ti'])

  i = value_cast_implicit(i, type.typeInt, i['ti'])

  return {
    'isa': 'value',
    'kind': 'index',
    'array': a,
    'index': i,
    'type': typ['of'],
    'attributes': ['adr'],
    'properties': {},
    'ti': x['ti']
  }



def do_value_expr_access(x):
  r = do_value(x['left'])

  if value_is_bad(r):
    return value_create_bad(x['ti'])

  field_id = x['field']

  # доступ через переменную-указатель
  ptr_access = type.is_pointer(r['type'])

  record_type = r['type']
  if ptr_access:
    record_type = r['type']['to']

  # check if is record
  if not type.is_record(record_type):
    error("expected record or pointer to record", x['ti'])
    return value_create_bad(x['left']['ti'])

  field = type.record_field_get(record_type, field_id['str'])

  # if field not found
  if field == None:
    error("undefined field '%s'" % field_id['str'], x['ti'])
    return value_create_bad(x['right']['ti'])

  if type.is_bad(field['type']):
    return value_create_bad(x['right']['ti'])

  attributes = ['adr']
  if not ptr_access:
    if value_is_immutable(r):
      attributes.append('immutable')

  return {
    'isa': 'value',
    'kind': 'access',
    'record': r,
    'field': field,
    'record_type': record_type,
    'type': field['type'],
    'attributes': attributes,
    'properties': {},
    'ti': x['ti']
  }



def do_value_expr_to(x):
  t = do_type(x['type'])
  v = do_value(x['value'])
  if value_is_bad(v) or type.is_bad(t):
    return value_create_bad(x['ti'])
  return value_cast_explicit(v, t, x['ti'])



def do_value_expr_id(x):
  vx = ctx.get_value(x['id']['str'])
  if vx == None:
    error("undeclared value '%s'" % x['id']['str'], x['ti'])
    return value_create_bad(x['ti'])

  # for TI чтобы не переписать у самого определения
  vx = copy.copy(vx)
  vx['ti'] = x['ti']
  return vx



def do_value_expr_ns(x):
  ns_id = x['ids'][0]
  _id = x['ids'][1]

  ns_name = ns_id['str']
  tx = ctx.get_type(ns_name)

  if tx == None:
    error("unknown namespace '%s'" % ns_id['str'], ns_id['ti'])
    return value_create_bad(ns_id['ti'])

  """if tx['kind'] == 'enum':
    items = tx['items']
    for item in items:
      if x['ids'][1]['str'] == item['id']['str']:
        num = item['number']
        #print("ENUM_ITEM %d" % (num))
        return {
          'isa': 'value',
          'kind': 'num',
          'num': num,
          'type': tx,
          'attributes': ['immediate'],
          'ti': x['ids'][1]['ti']
        }"""


strno = 0
strpool = {}

def do_value_expr_str(x):
  global strno
  strid = 'str_%d' % strno
  strno = strno + 1
  string = x['str']
  str_len = x['len']
  strpool[strid] = {'str': string, 'len': str_len}

  # type of any string is *[x]typeChar
  ta = type.typeArray(type.typeChar, size=str_len, attributes=[], ti=x['ti'])
  t = type.typePointer(ta)

  return {
    'isa': 'value',
    'kind': 'str',
    'str': string,
    'strid': strid,
    'len': str_len,
    'type': t,
    'attributes': ['string'],
    'properties': {},
    'ti': x['ti']
  }



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
  return {
    'isa': 'value',
    'kind': 'array',
    'type': {
      'isa': 'type',
      'kind': 'array',
      'size': size,
      'size_expr': value_create_int(size),
      'of': select_type(items[0]),
      'attributes': ['generic'],
      'ti': x['ti']
    },
    'items': items,
    'attributes': [],
    'properties': {},
    'ti': x['ti']
  }



def do_value_expr_record(x):
  items = []
  fields = []
  for item in x['items']:
    id = item['id']
    val = do_value(item['value'])
    items.append({'id': id, 'value': val})

    # создаем поле для типа generic записи
    field = {
      'isa': 'field',
      'id': id,
      'type': select_type(val),
      'ti': val['ti']
    }
    fields.append(field)

  return {
    'isa': 'value',
    'kind': 'record',
    'type': {
      'isa': 'type',
      'kind': 'record',
      # не создаем поля, тк мы не можем знать их реальной последовательности
      # в generic структуре
      # нет, создаем, но последовательность в generic не учитваем;
      'fields': fields,
      'attributes': ['generic'],
      'ti': x['ti']
    },
    'items': items,
    'attributes': [],
    'properties': {},
    'ti': x['ti']
  }


def do_value_expr_int(x):
  rv = value_create_int(x['num'], ti=x['ti'])

  if 'hexadecimal' in x['att']:
    value_attribute_add(rv, 'hexadecimal')

  return rv


def do_value_expr_float(x):
  return value_create_float(x['num'], ti=x['ti'])


def do_value_expr_sizeof(x):
  tx = do_type(x['type'])
  return {
    'isa': 'value',
    'kind': 'sizeof',
    'of': tx,
    'type': type.typeNat,
    'attributes': [],
    'properties': {},
    'ti': x['ti']
  }



def do_value(x):
  k = x['kind']

  rv = None

  if k in bin_ops: rv = do_value_expr_bin(x)
  elif k in un_ops: rv = do_value_expr_un(x)
  else:
    if k == 'int': rv = do_value_expr_int(x)
    elif k == 'float': rv = do_value_expr_float(x)
    elif k == 'id': rv = do_value_expr_id(x)
    elif k == 'ns': rv = do_value_expr_ns(x)
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
    rv = value_create_bad(x['ti'])

  assert('ti' in rv)

  return rv



#
# Do Statement
#

def do_stmt_if(x):
  c = do_value(x['cond'])
  t = do_stmt(x['then'])

  if value_is_bad(c) or stmt_is_bad(t):
    return stmt_create_bad()

  c = value_cast_implicit(c, type.typeNat1, c['ti'])
  type.check(c['type'], type.typeNat1, x['cond']['ti'])

  e = None
  if x['else'] != None:
    e = do_stmt(x['else'])
    if stmt_is_bad(e):
      return stmt_create_bad()

  return {
    'isa': 'stmt',
    'kind': 'if',
    'cond': c,
    'then': t,
    'else': e,
    'ti': x['ti']
  }



def do_stmt_while(x):
  c = do_value(x['cond'])
  s = do_stmt(x['stmt'])
  if value_is_bad(c) or stmt_is_bad(s):
    return stmt_create_bad()

  c = value_cast_implicit(c, type.typeNat1, c['ti'])
  if not type.check(c['type'], type.typeNat1, x['cond']['ti']):
    return stmt_create_bad()

  return {
    'isa': 'stmt',
    'kind': 'while',
    'cond': c,
    'stmt': s,
    'ti': x['ti']
  }



def do_stmt_return(x):
  global cfunc
  assert(cfunc != None)

  v = None  # если у return нет значения вернем Null в поле #value
  if x['value'] != None:
    v = do_value(x['value'])
    if value_is_bad(v):
      return stmt_create_bad()

    v = value_cast_implicit(v, cfunc['type']['to'], v['ti'])
    type.check(v['type'], cfunc['type']['to'], x['value']['ti'])
  else:
    if not type.eq(cfunc['type']['to'], type.typeUnit):
      error("expected return value", x['ti'])

  return {
    'isa': 'stmt',
    'kind': 'return',
    'value': v,
    'ti': x['ti']
  }


def do_stmt_again(x):
  return {'isa': 'stmt', 'kind': 'again', 'ti': x['ti']}


def do_stmt_break(x):
  return {'isa': 'stmt', 'kind': 'break', 'ti': x['ti']}


def do_stmt_var(x):
  id = x['id']

  t = None
  v = None

  if x['type'] != None:
    t = do_type(x['type'])

  if x['value'] != None:
    v = do_value(x['value'])

  if t == None and v == None:
    return stmt_create_bad()


  if type.is_bad(t):
    return stmt_create_bad()

  if type.is_forbidden(t):
    error("unsuitable type", x['type']['ti'])


  if t == None:
    t = v['type']

  var_value = {
    'isa': 'value',
    'kind': 'var',
    'id': id,
    'type': t,
    'attributes': ['adr', 'local'],
    'properties': {},
    'ti': x['ti']
  }
  ctx.add_value(id['str'], var_value)

  return {
    'isa': 'stmt',
    'kind': 'asg_stmt_def_var',
    'id': id,
    'type': t,
    'value': v,
    'ti': x['ti']
  }



def do_stmt_let(x):
  id = x['id']
  v = do_value(x['value'])
  if value_is_bad(v):
    return stmt_create_bad()

  vtype = v['type']

  # let это не всегда константа, чаще всего это immutable переменная
  # вычисляемая в runtime;
  # Композитные generic значения все же следует вычислять по месту
  # (по крайней мере те что не полностью константны)
  # А для compile-time let не нужно генерить стейтмент,
  # просто связываем константное значение с идентификатором
  if value_is_immediate(v):
    if not (type.is_record(vtype) or type.is_array(vtype)):
      ctx.add_value(id['str'], v)
      return stmt_create_bad()

  # runtime let
  const_value = {
    'isa': 'value',
    'kind': 'var',
    'id': id,
    'type': v['type'],
    'attributes': ['local', 'immutable'],
    'properties': {},
    'ti': x['ti']
  }
  ctx.add_value(id['str'], const_value)

  return {
    'isa': 'stmt',
    'kind': 'asg_stmt_def_let',
    'id': id,
    'value': v,
    'ti': x['ti']
  }



def do_stmt_assign(x):
  l = do_value(x['left'])
  r = do_value(x['right'])

  if value_is_bad(l) or value_is_bad(r):
    return stmt_create_bad()

  # left is var?
  if not value_attribute_check(l, 'adr'):
    error("illegal left", x['left']['ti'])
    return stmt_create_bad()

  if value_is_immutable(l):
    error("immutable value", l['ti'])
    return stmt_create_bad()

  # type check
  r = value_cast_implicit(r, l['type'], r['ti'])
  type.check(l['type'], r['type'], r['ti'])

  return {
    'isa': 'stmt',
    'kind': 'assign',
    'left': l,
    'right': r,
    'ti': x['ti']
  }



def do_stmt_value(x):
  v = do_value(x['value'])
  if value_is_bad(v):
    return stmt_create_bad()
  return {'isa': 'stmt', 'kind': 'value', 'value': v, 'ti': x['ti']}



def do_stmt(x):
  k = x['kind']

  s = stmt_create_bad()
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

  return s



def do_stmt_block(x):

  ctx.push()

  stmts = []
  for stmt in x['stmts']:
    s = do_stmt(stmt)
    if not stmt_is_bad(s):
      stmts.append(s)

  ctx.pop()

  return {
    'isa': 'stmt',
    'kind': 'block',
    'stmts': stmts,
    'ti': x['ti']
  }



import_guard_paths = []
def do_import(x):
  global import_guard_paths

  s = x['str']
  local = s[0:2] == './' or s[0:3] == '../'

  s2 = s
  if local:
    path = settings_get('path')
    s2 = path + '/' + s[1:]
  else:
    # GLOBAL
    path_lib = settings_get('library')
    f = path_lib + '/' + s
    #print("F = %s" % f)
    if os.path.exists(f):
      s2 = f

  # import guard
  abspath = os.path.abspath(s2)
  #print("abspath = " + abspath)
  if abspath in import_guard_paths:
    return None  # already imported
  import_guard_paths.append(abspath)


  ast = parser.parse(s2)

  asg = proc(ast)

  # если не нужно печатать сожержимое заголовка
  # а просто напечатать #include "someheader.h"
  if attribute_get('no-c-include'):
    attribute_off('no-c-include')
  else:
    return [
      {
        'isa': 'directive',
        'kind': 'include',
        'str': s[:-1],
        'local': True
      }
    ]

  return asg



def c_include(s):
  #print("c_include %s" % s)
  local = s[0:2] == './'
  return {'isa': 'directive', 'kind': 'include', 'str': s, 'local': local}



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
  ctx.add_value(id['str'], v)

  if attribute_get('no-c-print'):
    if settings_check('backend', 'c'):
      return None

  return {
    'isa': 'definition',
    'kind': 'const',
    'id': id,
    'value': v,
    'comment': ''
  }



def def_type(x):
  id = x['id']
  t = do_type(x['type'])
  if type.is_bad(t):
    return def_bad()

  already = ctx.get_type(id['str'])

  nt = type.create_alias(id['str'], t, id['ti'])
  nt2 = ctx.add_type(id['str'], nt)

  if attribute_get('no-c-print'):
    if settings_check('backend', 'c'):
      return None

  return {
    'isa': 'definition',
    'kind': 'type',
    'id': x['id'],
    'afterdef': already != None,
    'type': t,
    'comment': ''
  }



def def_var(x):
  f = do_field(x['field'])

  if f == None:
    return None

  if type.is_bad(f['type']):
    return None

  if f['type']['kind'] == 'opaque':
    error("cannot create variable with undefined type", x['type']['ti'])
    return None

  iv = None
  if x['init'] != None:
    iv = do_value(x['init'])
    iv = value_cast_implicit(iv, f['type'], iv['ti'])
    type.check(iv['type'], f['type'], x['init']['ti'])

  var_value = {
    'isa': 'value',
    'kind': 'var',
    'id': f['id'],
    'type': f['type'],
    'init': iv,
    'attributes': ['adr', 'var'],
    'properties': {},
    'ti': x['ti']
  }
  ctx.add_value(x['field']['id']['str'], var_value)

  return {
    'isa': 'definition',
    'kind': 'var',
    'field': f,
    'init': iv,
    'comment': '',
    'ti': x['ti']
  }



def def_func(x):
  func_ti = x['ti']
  func_id = x['id']
  func_type = do_type(x['type'])

  ctx.push()  # params context (!)

  global cfunc
  old_cfunc = cfunc
  cfunc = {
    'isa': 'value',
    'kind': 'func',
    'id': func_id,
    'type': func_type,
    'attributes': [],
    'properties': {},
    'ti': func_ti
  }

  i = 0
  while i < len(func_type['params']):
    param = func_type['params'][i]
    param_id = param['id']
    param_ti = param['ti']
    p = {
      'isa': 'value',
      'kind': 'var',
      'id': param_id,
      'type': param['type'],
      'attributes': ['param', 'local', 'immutable'],
      'properties': {},
      'ti': param_ti
    }
    ctx.add_value(param_id['str'], p)
    i = i + 1

  func_stmt = do_stmt_block(x['stmt'])
  cfunc['stmt'] = func_stmt

  ctx.pop()  # params context (!)

  ctx.add_value(func_id['str'], cfunc)


  funcdef = {
    'isa': 'definition',
    'kind': 'func',
    'id': func_id,
    'type': func_type,
    'stmt': func_stmt,
    'comment': '',
    'ti': func_ti
  }

  cfunc = old_cfunc

  return funcdef



def decl_type(x):
  id = x['id']

  nt = {
    'isa': 'type',
    'kind': 'opaque',
    'name': id['str'],
    'attributes': [],
    'ti': id['ti'],
  }
  nt = ctx.add_type(id['str'], nt)

  if attribute_get('no-c-print'):
    if settings_check('backend', 'c'):
      return None

  # С не печатает opaque, но LLVM печатает (!)
  return {
    'isa': 'declaration',
    'kind': 'type',
    'id': x['id'],
    'type': nt,
    'extern': x['extern'],
    'attributes': ['undefined'],
    'comment': '',
  }



def decl_func(x):
  global attributes
  id = x['id']
  ftyp = do_type(x['type'])

  if attribute_get('arghack'):
    type.type_attribute_add(ftyp, 'arghack')

  fval = {
    'isa': 'value',
    'kind': 'func',
    'id': id,
    'type': ftyp,
    'attributes': ['undefined'],
    'properties': {},
    'ti': x['ti']
  }
  ctx.add_value(id['str'], fval)

  if attribute_get('no-c-print'):
    if settings_check('backend', 'c'):
      return None

  return {
    'isa': 'declaration',
    'kind': 'func',
    'id': id,
    'type': ftyp,
    'stmt': None,
    'extern': x['extern'],
    'attributes': ['undefined'],
    'comment': '',
    'ti': x['ti']
  }



def proc(ast):
  global output, local_attributes

  old_output = output
  output = []

  for x in ast:
    isa = x['isa']
    kind = x['kind']

    y = None

    if isa == 'ast_definition':
      if kind == 'func':
        y = def_func(x)

        # в LLVM если делаем func definition нельзя писать func declaration
        # поэтому удалим все сделаные ранее декларации (если они есть)
        if settings_check('backend', 'llvm'):
          for x in output:
            if x['isa'] == 'declaration':
              if x['kind'] == 'func':
                if x['id']['str'] == y['id']['str']:
                  output.remove(x)
                  break

      elif kind == 'type': y = def_type(x)
      elif kind == 'const': y = def_const(x)
      elif kind == 'var': y = def_var(x)

    elif isa == 'ast_declaration':
      if kind == 'func': y = decl_func(x)
      elif kind == 'type': y = decl_type(x)

    elif isa == 'ast_directive':
      if kind == 'metadir':
        exec(x['text'])
        """print(o)
        if o != None:
          if isinstance(o, list):
            output.extend(o)
          else:
            output.append(o)"""
        continue

      # импорт изменяет контекст, и продуцирует аутпут
      elif kind == 'import':
        y = do_import(x)
        if y != None:
          output.extend(y)
        continue


    local_attributes = []

    if y == None:
      continue

    output.append(y)

  o = output
  output = old_output
  return o



def translate(srcname):
  ast = parser.parse(srcname)
  asg = proc(ast)
  return asg


