

from error import *
from parser import Parser
from ctx import ContextStack
import type

enumUid = 0


parser = None

ctx = None  # context

cfunc = None  # current function


typeSizeEnum = 2

def get_value(id):
  if cfunc != None:
    v = cfunc['ctx'].get_value(id)
    if v != None:
      return v
  return ctx.get_value(id)


def get_type(id):
  if cfunc != None:
    t = cfunc['ctx'].get_type(id)
    if t != None:
      return t
  return ctx.get_type(id)



def init():
  global parser
  parser = Parser()
  global ctx
  ctx = ContextStack()
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
  ctx.add_type('Str', type.typeStr)



def do_field(x):
  if x == None:
    return None

  t = do_type(x['type'])

  if t == None:
    return None

  return {
    'isa': 'field',
    'id': x['id'],
    'type': t,
    'ti': x['ti']
  }


#
# Do Type
#

def do_type(t):
  k = t['kind']
  
  if k == 'id':
    tx = get_type(t['id']['str'])
    if tx == None:
      error("undeclared type %s" % t['id']['str'], t['ti'])
      return None #{'isa': 'type', 'kind': 'bad', 'ti': t['ti']}
    return tx #{'isa': 'type', 'kind': 'id', 'id': t['id'], 'type': tx}
  
  elif k == 'pointer':
    to = do_type(t['to'])
    return type.typePointer(to, ti=t['ti'])
  
  elif k == 'array':
    tx = {'isa': 'type', 'kind': 'array', 'size': None, 'meta': [], 'ti': t['ti']}
    tx['of'] = do_type(t['of'])

    if t['size'] != None:
      tx['size'] = do_value(t['size'])['num']
    return tx
  
  elif k == 'record':
    fields = []
    record = {
      'isa': 'type',
      'kind': 'record',
      'fields': fields,
      'size': 0,
      'meta': [],
      'ti': t['ti']
    }
    i = 0
    while i < len(t['fields']):
      f = do_field(t['fields'][i])
      if f != None:
        f_exist = type.record_field_get(record, f['id']['str'])
        if f_exist != None:
          error("redefinition of '%s'" % f['id']['str'], f['ti'])
          f = None
        if f != None:
          f['no'] = i
          fields.append(f)
      i = i + 1
    return record
  
  elif k == 'enum':
    global enumUid
    items = []
    i = 0
    while i < len(t['items']):
      identifier = t['items'][i]
      items.append({'isa': 'item', 'id': identifier['id'], 'number': i, 'ti': identifier['ti']})
      i = i + 1
    enumUid = enumUid + 1
    return {
      'isa': 'type',
      'kind': 'enum',
      'items': items,
      'size': typeSizeEnum,
      'uid': enumUid,
      'meta': [],
      'ti': t['ti']
    }
  
  elif k == 'func':
    params = []
    i = 0
    while i < len(t['params']):
      param = do_field(t['params'][i])
      if param != None:
        params.append(param)
      i = i + 1
    to = do_type(t['to'])
    return {
      'isa': 'type',
      'kind': 'func',
      'params': params,
      'to': to,
      'meta': [],
      'ti': t['ti']
    }
  
  return None #{'isa': 'type', 'kind': 'bad', 'type': t, 'meta': []}




def cast_to_array(v, t, ti):
  if v['kind'] == 'array':
    #info('cast_arr_to_arr', ti)
    # приведение значения-массива с generic типом к конкретному типу
    # cast all items to target array item type
    items2 = []
    for item in v['items']:
      casted_item = cast(item, t['of'], item['ti'])
      type.check(t['of'], casted_item['type'], item['ti'])
      items2.append(casted_item)

    return {
      'isa': 'value',
      'kind': 'array',
      'items': items2,
      'type': t,
      'meta': [],
      'ti': ti
    }

  else:
    error("cannot cast '%s' to '%s'" % (v['type']['kind'], t['kind']), ti)


def do_cast_runtime(v, t, ti):
  return {
    'isa': 'value',
    'kind': 'to',
    'value': v,
    'type': t,
    'meta': [],
    'ti': ti
  }


def cast_to_integer(v, t, ti):
  if v['type']['kind'] == 'integer':
    if 'generic' in v['type']['meta']:
      v['type'] = t
      return v

    return do_cast_runtime(v, t, ti)

  # enum -> integer
  elif v['type']['kind'] == 'enum':
    return do_cast_runtime(v, t, ti)

  error("cast error", ti)
  return v


def cast_to_enum(v, t, ti):
  # integer -> enum
  if v['type']['kind'] == 'integer':
    return do_cast_runtime(v, t, ti)

  error("cast error", ti)
  return v


def cast_to_pointer(v, t, ti):
  if v['type']['kind'] != 'pointer':
    error("cast not #pointer to #pointer", ti)
    return v
  return do_cast_runtime(v, t, ti)


def cast(v, t, ti):
  if v == None or t == None:
    return None

  if type.eq(v['type'], t):
    #info("nocast", ti)
    return v

  if t['kind'] == 'integer':
    return cast_to_integer(v, t, ti)

  # cast generic array to array
  elif t['kind'] == 'array':
    return cast_to_array(v, t, ti)

  elif t['kind'] == 'record':
    #print("cast record")
    pass

  elif t['kind'] == 'pointer':
    return cast_to_pointer(v, t, ti)

  elif t['kind'] == 'enum':
    return cast_to_enum(v, t, ti)

  error('illegal type cast', ti)
  return v #do_cast_runtime(v, t, ti)



def cast_implicit(v, t, ti):
  if v == None or t == None:
    return None
  
  if not type.eq(v['type'], t):  #!
    if type.resolve(v['type'], t):
      return cast(v, t, ti)

  return v


def cast_explicit(v, t, ti):
  if v == None or t == None:
    return None
  return cast(v, t, ti)


#
# Do Statement
#


bin_ops = [
  'or', 'xor', 'and', 'shl', 'shr',
  'eq', 'ne', 'lt', 'gt', 'le', 'ge',
  'add', 'sub', 'mul', 'div', 'mod'
]

un_ops = ['ref', 'deref', 'plus', 'minus', 'not']


def do_value_expr_bin(x):
  k = x['kind']
  l = do_value(x['left'])
  r = do_value(x['right'])
  if l == None or r == None:
    return None
  
  l = cast_implicit(l, r['type'], l['ti'])
  r = cast_implicit(r, l['type'], r['ti'])
  
  if not type.eq(l['type'], r['type']):
    error("type error", x['ti'])
    return None
  
  t = l['type']
  if k in ['eq', 'ne', 'lt', 'gt', 'le', 'ge']:
    t = type.typeNat1

  # for generic
  if type.is_generic_numeric(l['type']) and type.is_generic_numeric(r['type']):
    ops = {
      'or': lambda a, b: a or b,
      'and': lambda a, b: a and b,
      'xor': lambda a, b: (a and not b) or (not a and b),
      'shl': lambda a, b: a << b,
      'shr': lambda a, b: a >> b,
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

    val = ops[k](l['num'], r['num'])

    return {
      'isa': 'value',
      'kind': 'num',
      'type': t,
      'num': val,
      'meta': [],
      'ti': x['ti']
    }

  return {
    'isa': 'value',
    'kind': x['kind'],
    'left': l,
    'right': r,
    'type': t,
    'meta': [],
    'ti': x['ti']
  }


def do_value_expr_un(x):
  val = do_value(x['value'])
  if val == None:
    return None
  t = val['type']

  if x['kind'] == 'deref':
    if not type.is_pointer(t):
      error("expected pointer", val['ti'])
      return None

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
      'meta': ['adr'],
      'ti': x['ti']
    }


  if x['kind'] == 'ref':
    t = type.typePointer(t, ti=x['ti'])

  if type.is_generic_numeric(val['type']):
    num = {
      'minus': lambda a: -a,
      'not': lambda a: not a,
    }[k](val['num'])
    return {
      'isa': 'value',
      'kind': 'num',
      'type': t,
      'num': num,
      'meta': [],
      'ti': x['ti']
    }
  
  return {
    'isa': 'value',
    'kind': x['kind'],
    'value': val,
    'type': t,
    'meta': [],
    'ti': x['ti']
  }


def do_value_expr_call(x):
  f = do_value(x['left'])
  if f == None:
    return None
  
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
    return None
  
  if nargs > npars:
    if not 'arghack' in ftype['meta']:
      error("too many args", x['ti'])
      return None
  
  args = []
  
  # normal args
  i = 0
  while i < npars:
    p = params[i]
    a = do_value(x['args'][i])
    a = cast_implicit(a, p['type'], a['ti'])
    if a == None:
      i = i + 1
      continue
    type.check(p['type'], a['type'], x['args'][i]['ti'])
    args.append(a)
    i = i + 1
  
  # arghack rest args
  while i < nargs:
    a = do_value(x['args'][i])
    if a == None:
      i = i + 1
      continue

    a = cast_implicit(a, type.typeInt, a['ti'])
    args.append(a)
    i = i + 1
  
  return {
    'isa': 'value',
    'kind': 'call',
    'left': f,
    'args': args,
    'type': ftype['to'],
    'meta': [],
    'ti': x['ti']
  }


def do_value_expr_index(x):
  a = do_value(x['left'])
  if a == None:
    return None
  typ = a['type']
  
  ptr_access = typ['kind'] == 'pointer'
  if ptr_access:
    typ = typ['to']
  
  # check if is record
  if not type.is_array(typ):
    error("expected array or pointer to array", x['ti'])
    return None
  
  i = do_value(x['index'])
  
  if i == None:
    return None
  
  i = cast_implicit(i, type.typeInt, i['ti'])
  
  return {
    'isa': 'value',
    'kind': 'index',
    'array': a,
    'index': i,
    'type': typ['of'],
    'meta': ['adr'],
    'ti': x['ti']
  }


def do_value_expr_access(x):
  r = do_value(x['left'])
  if r == None:
    return None
  
  field_id = x['field']
  
  typ = r['type']
  k = 'access'
  ptr_access = typ['kind'] == 'pointer'
  if ptr_access:
    k = 'access'
    typ = r['type']['to']
  
  # check if is record 
  if not type.is_record(typ):
    error("expected record or pointer to record", x['ti'])
    return None
  
  field = type.record_field_get(typ, field_id['str'])
  
  # field not found
  if field == None:
    error("field '%s' not exist" % field_id['str'], x['ti'])
    return None
  
  meta = ['adr']
  if not ptr_access:
    if 'immutable' in r['meta']:
      meta.append('immutable')

  return {
    'isa': 'value',
    'kind': k,
    'record': r,
    'field': field,
    'type': field['type'],
    'meta': meta,
    'ti': x['ti']
  }


def do_value_expr_to(x):
  t = do_type(x['type'])
  v = do_value(x['value'])
  if v == None or t == None:
    return None
  return cast_explicit(v, t, x['ti'])


def create_value_num(num, type=type.genericInt, ti=None):
  return {
    'isa': 'value',
    'kind': 'num',
    'num': num,
    'type': type,
    'meta': [],
    'ti': ti
  }




def do_value_expr_id(x):
  vx = get_value(x['id']['str'])
  if vx == None:
    error("undeclared value '%s'" % x['id']['str'], x['ti'])
    return None
  return vx


def do_value_expr_ns(x):
  tx = get_type(x['ids'][0]['str'])
  if tx != None:
    if tx['kind'] == 'enum':
      items = tx['items']
      for item in items:
        if x['ids'][1]['str'] == item['id']['str']:
          enum_uid = tx['uid']
          num = item['number']
          #print("ENUM_ITEM %d %d" % (enum_uid, num))
          return {
            'isa': 'value',
            'kind': 'num',
            'num': num,
            'type': tx,
            'meta': [],
            'ti': x['ids'][1]['ti']
          }

  if tx == None:
    error("undeclared value '%s'" % x['id']['str'], x['ti'])
    return None
  return vx


strno = 0
strpool = {}

def str_sym(x):
  if x == 'n':
    return '\n'
  return 0


def do_value_expr_str(x):
  global strno
  strid = 'str_%d' % strno
  strno = strno + 1
  string = x['str']
  str_len = x['len']
  strpool[strid] = {'str': string, 'len': str_len}

  return {
    'isa': 'value',
    'kind': 'str',
    'str': string,
    'id': strid,
    'len': str_len,
    'type': type.genericStr,
    'meta': [],
    'ti': x['ti']
  }


def do_value_expr_array(x):
  #print("do_value_expr_array")
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
      'of': items[0]['type'],
      'meta': ['generic'],
      'ti': x['ti']
    },
    'items': items,
    'meta': [],
    'ti': x['ti']
  }


def do_value_expr_record(x):
  #print("do_value_expr_record")

  record_fields = []
  items = []
  for item in x['items']:
    id = item['id']
    vi = do_value(item['value'])
    items.append({'id': id, 'value': vi})

    field = {
      'isa': 'field',
      'id': id,
      'type': vi['type'],
      'ti': item['ti'],
    }
    record_fields.append(field)

  return {
    'isa': 'value',
    'kind': 'record',
    'type': {
      'isa': 'type',
      'kind': 'record',
      'fields': record_fields,
      'meta': ['generic'],
      'ti': x['ti']
    },
    'items': items,
    'meta': [],
    'ti': x['ti']
  }


def do_value(x):
  k = x['kind']
  
  rv = None
  
  if k in bin_ops:
    rv = do_value_expr_bin(x)
  elif k in un_ops:
    rv = do_value_expr_un(x)
  else:
    if k == 'num':
      rv = create_value_num(x['num'], ti=x['ti'])
    elif k == 'id':
      rv = do_value_expr_id(x)
    elif k == 'ns':
      rv = do_value_expr_ns(x)
    elif k == 'str':
      rv = do_value_expr_str(x)
    elif k == 'record':
      rv = do_value_expr_record(x)
    elif k == 'array':
      rv = do_value_expr_array(x)
    else:
      if k == 'call':
        rv = do_value_expr_call(x)
      elif k == 'index':
        rv = do_value_expr_index(x)
      elif k == 'access':
        rv = do_value_expr_access(x)
      elif k == 'cast':
        rv = do_value_expr_to(x)
      elif k == 'sizeof':
        tx = do_type(x['type'])
        rv = {'isa': 'value', 'kind': 'sizeof', 'of': tx, 'type': type.typeNat, 'meta': [], 'ti': x['ti']}
      else:
        rv = None #{'isa': 'value', 'kind': 'bad', 'value': v, 'meta': []}
    
  if rv != None:
    rv['ti'] = x['ti']
  
  return rv


#
# Do Statement
#

def do_stmt_if(x):
  c = do_value(x['cond'])
  t = do_stmt(x['then'])
  if c == None or t == None:
    return None
  
  c = cast_implicit(c, type.typeNat1, c['ti'])
  type.check(c['type'], type.typeNat1, x['cond']['ti'])
  
  e = None
  if x['else'] != None:
    e = do_stmt(x['else'])
    if e == None:
      return None

  return {
    'isa': 'stmt',
    'kind': 'if',
    'cond': c,
    'then': t,
    'else': e
  }


def do_stmt_while(x):
  c = do_value(x['cond'])
  s = do_stmt(x['stmt'])
  if c == None or s == None:
    return None
  
  c = cast_implicit(c, type.typeNat1, c['ti'])
  if not type.check(c['type'], type.typeNat1, x['cond']['ti']):
    return None
  
  return {
    'isa': 'stmt',
    'kind': 'while',
    'cond': c,
    'stmt': s,
  }


def do_stmt_return(x):
  global cfunc
  
  v = None
  if x['value'] != None:
    v = do_value(x['value'])
    if v == None:
      return None
    v = cast_implicit(v, cfunc['type']['to'], v['ti'])
    type.check(v['type'], cfunc['type']['to'], x['value']['ti'])
  else:
    if not type.eq(cfunc['type']['to'], type.typeUnit):
      error("expected return value", x['ti'])

  return {
    'isa': 'stmt',
    'kind': 'return',
    'value': v
  }


def do_stmt_again(x):
  return {'isa': 'stmt', 'kind': 'again'}

def do_stmt_break(x):
  return {'isa': 'stmt', 'kind': 'break'}


def do_stmt_var(x):
  id = x['id']
  
  t = None
  v = None
  if x['type'] != None:
    t = do_type(x['type'])
  if x['value'] != None:
    v = do_value(x['value'])
  
  if t == None and v == None:
    return None
  
  if t == None:
    t = v['type']
  
  """if 'generic' in v['type']['meta']:
    error("value with unspecified type", v['ti'])
    return None"""
  
  vx = {
    'isa': 'value',
    'kind': 'var',
    'id': id,
    'type': t,
    'meta': ['adr', 'local'],
    'ti': x['ti']
  }
  cfunc['ctx'].add_value(id['str'], vx)

  return {
    'isa': 'stmt',
    'kind': 'asg_stmt_def_var',
    'id': id,
    'type': t,
    'value': v
  }


def do_stmt_let(x):
  id = x['id']
  v = do_value(x['value'])
  if v == None:
    return None

  # compile-time let
  # не нужно генерить стейтмент,
  # просто связываем константное значение с идентификатором
  if type.is_generic(v['type']):
    cfunc['ctx'].add_value(id['str'], v)
    return None
  
  # runtime let
  vx = {
    'isa': 'value',
    'kind': 'const',
    'id': id,
    'type': v['type'],
    'meta': ['local', 'immutable'],
    'ti': x['ti']
  }
  cfunc['ctx'].add_value(id['str'], vx)
  
  return {'isa': 'stmt', 'kind': 'asg_stmt_def_let', 'id': id, 'value': v}


def value_is_immutable(x):
  return 'immutable' in x['meta']


def do_stmt_assign(x):
  l = do_value(x['left'])
  r = do_value(x['right'])
  
  if l == None or r == None:
    return None
  
  # left is var?
  if 'adr' in l['meta']:
    if value_is_immutable(l):
      error("immutable value", l['ti'])
      return None
  else:
    error("illegal left", x['left']['ti'])
    return None

  
  # type check
  r = cast_implicit(r, l['type'], r['ti'])
  type.check(l['type'], r['type'], x['ti'])

  return {
    'isa': 'stmt',
    'kind': 'assign',
    'left': l,
    'right': r,
    'ti': x['ti']
  }


def do_stmt_value(x):
  v = do_value(x['value'])
  if v == None:
    return None
  return {'isa': 'stmt', 'kind': 'value', 'value': v}


def do_stmt(x):
  k = x['kind']
  
  s = None
  if k == 'let':
    s = do_stmt_let(x)
  elif k == 'block':
    s = do_stmt_block(x)
  elif k == 'value':
    s = do_stmt_value(x)
  elif k == 'assign':
    s = do_stmt_assign(x)
  elif k == 'return':
    s = do_stmt_return(x)
  elif k == 'if':
    s = do_stmt_if(x)
  elif k == 'while':
    s = do_stmt_while(x)
  elif k == 'var':
    s = do_stmt_var(x)
  elif k == 'again':
    s = do_stmt_again(x)
  elif k == 'break':
    s = do_stmt_break(x)
    
  return s
  


def do_stmt_block(s):
  global cfunc
  cfunc['ctx'].push()
  stmts = []
  for stmt in s['stmts']:
    s = do_stmt(stmt)
    if s != None:
      stmts.append(s)
  cfunc['ctx'].pop()
  return {'isa': 'stmt', 'kind': 'block', 'stmts': stmts}
  


def do_import(x):
  loc = x['local']
  s = x['str']
  ast = parser.parse(s + '.cm')
  asg = proc(ast)
  return asg #{'isa': 'import', 'str': s, 'local': loc}


def def_const(x):
  id = x['id']
  v = do_value(x['value'])
  ctx.add_value(id['str'], v)
  return {'isa': 'asg_def_const', 'id': id, 'value': v}



def def_type(x):
  id = x['id']
  t = do_type(x['type'])
  if t == None:
    return None

  nt = type.create_alias(id['str'], t, id['ti'])
  ctx.add_type(id['str'], nt)
  
  # ENUM
  if type.is_enum(t):
    for item in t['items']:
      id = item['id']
      if id == None:
        continue
      #print("ex enum item " + id)
      v = {
        'isa': 'value',
        'kind': 'const',
        'id': id,
        'type': t,
        'value': create_value_num(item['number']),
        'meta': [],
        'ti': item['ti']
      }
      ctx.add_value(id['str'], v)
  
  return {'isa': 'asg_def_type', 'id': x['id'], 'type': t}


def def_var(x):
  f = do_field(x['field'])

  if f == None:
    return None

  iv = None
  if x['init'] != None:
    iv = do_value(x['init'])
    iv = cast_implicit(iv, f['type'], iv['ti'])
    type.check(iv['type'], f['type'], x['init']['ti'])

  v = {
    'isa': 'value',
    'kind': 'var',
    'id': f['id'],
    'type': f['type'],
    'init': iv,
    'meta': ['adr', 'var'],
    'ti': x['ti']
  }
  ctx.add_value(x['field']['id']['str'], v)
  return {'isa': 'asg_def_var', 'field': f, 'init': iv, 'ti': x['ti']}


def def_func(x):
  global cfunc
  func_ti = x['ti']
  func_id = x['id']
  func_type = do_type(x['type'])
  

  local_ctx = ContextStack()

  old_cfunc = cfunc
  cfunc = {
    'isa': 'value',
    'kind': 'func',
    'id': func_id,
    'type': func_type,
    'ctx': local_ctx,
    'meta': [],
    'ti': func_ti
  }
  
  cfunc['ctx'].push()  # params context (!)
  
  i = 0
  while i < len(func_type['params']):
    param = func_type['params'][i]
    param_id = param['id']
    param_ti = param['ti']
    p = {
      'isa': 'value',
      'kind': 'const',
      'id': param_id,
      'type': param['type'],
      'meta': ['param', 'local', 'readonly'],
      'ti': param_ti
    }
    cfunc['ctx'].add_value(param_id['str'], p)
    i = i + 1
  
  func_stmt = do_stmt_block(x['stmt'])
  cfunc['stmt'] = func_stmt
  
  cfunc['ctx'].pop()  # params context (!)
  
  ctx.add_value(func_id['str'], cfunc)
  
  funcdef = {
    'isa': 'asg_def_func',
    'id': func_id,
    'type': func_type,
    'stmt': func_stmt,
    'ti': func_ti
  }

  cfunc = old_cfunc
  return funcdef


def def_exist_value(x):
  f = do_field(x['field'])
  if f == None:
    return None

  fval = {
    'isa': 'value',
    'kind': 'func',
    'id': f['id'],
    'type': f['type'],
    'meta': ['undefined'],
    'ti': x['field']['ti']
  }
  ctx.add_value(f['id']['str'], fval)
  return None



def def_exist_type(x):
  id = x['id']
  nt = {
    'isa': 'type',
    'kind': 'opaque',
    'aka': id['str'],
    'meta': [],
    'ti': id['ti'],
  }
  ctx.add_type(id['str'], nt)
  return {'isa': 'asg_def_type', 'id': x['id'], 'type': nt}



def def_extern(x):
  f = do_field(x['field'])
  if f == None:
    return None

  # TODO: add arghack pragma
  if f['id']['str'] == 'printf':
    f['type']['meta'].append('arghack')
  
  fval = {
    'isa': 'value',
    'kind': 'func',
    'id': f['id'],
    'type': f['type'],
    'meta': [],
    'ti': x['field']['ti']
  }
  ctx.add_value(f['id']['str'], fval)

  return {
    'isa': 'asg_def_extern',
    'field': f,
    #'id': f['id'],
    #'type': f['type'],
    'meta': [],
    'ti': x['field']['ti']
  }




# принимает на вход сущность верхнего уровня
# обрабатывает ее в соответствии с контекстом
# (который в свою очредь тоже может изменяться в процессе)
# возвращает сущность верхнего уровня для печати
def process(x):
  isa = x['isa']
  y = None

  if isa == 'ast_def_func':
    y = def_func(x)
  elif isa == 'ast_def_type':
    y = def_type(x)
  elif isa == 'ast_def_const':
    y = def_const(x)
  elif isa == 'ast_def_var':
    y = def_var(x)
  elif isa == 'ast_def_exist_value':
    y = def_exist_value(x)
  elif isa == 'ast_def_exist_type':
    y = def_exist_type(x)
  elif isa == 'ast_def_extern':
    y = def_extern(x)
  return y



def proc(ast):
  output = []

  for a in ast:
    if a['isa'] == 'import':
      y = do_import(a)
      output.extend(y)
      continue

    y = process(a)
    if y != None:
      output.append(y)

  return output


def translate(srcname):
  ast = parser.parse(srcname)
  ctx.push()
  asg = proc(ast)
  ctx.pop()
  return asg



