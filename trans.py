
from parser import Parser
from printer import printx
from error import *
from ctx import ContextStack

import type

enumUid = 0

cfunc = None



ctx = ContextStack()


def init():
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
  f = {'isa': 'field'}
  f['id'] = x['id']
  f['type'] = do_type(x['type'])
  if f['type'] == None:
    return None
  return f



def do_type(t):
  k = t['kind']
  
  if k == 'id':
    tx = ctx.get_type(t['id'])
    if tx == None:
      error("undeclared type %s" % t['id'], t['ti'])
      return None #{'isa': 'type', 'kind': 'bad', 'ti': t['ti']}
    return tx #{'isa': 'type', 'kind': 'id', 'id': t['id'], 'type': tx}
  
  elif k == 'pointer':
    to = do_type(t['to'])
    return type.typePointer(to, ti=t['ti'])
  
  elif k == 'array':
    tx = {'isa': 'type', 'kind': 'array', 'size': None, 'ti': t['ti']}
    tx['of'] = do_type(t['of'])
    
    if not 'size' in t:
      print(t)
    if t['size'] != None:
      tx['size'] = do_value(t['size'])
    return tx
  
  elif k == 'record':
    fields = []
    i = 0
    while i < len(t['fields']):
      f = do_field(t['fields'][i])
      if f != None:
        fields.append(f)
      i = i + 1
    return {'isa': 'type', 'kind': 'record', 'att': [], 'fields': fields, 'ti': t['ti']}
  
  elif k == 'enum':
    global enumUid
    items = []
    i = 0
    while i < len(t['items']):
      identifier = t['items'][i]
      items.append({'isa': 'item', 'id': identifier['id'], 'number': i, 'ti': identifier['ti']})
      i = i + 1
    enumUid = enumUid + 1
    return {'isa': 'type', 'kind': 'enum', 'items': items, 'uid': enumUid, 'att': [], 'ti': t['ti']}
  
  elif k == 'func':
    params = []
    i = 0
    while i < len(t['params']):
      param = do_field(t['params'][i])
      if param != None:
        params.append(param)
      i = i + 1
    to = do_type(t['to'])
    return {'isa': 'type', 'kind': 'func', 'params': params, 'to': to, 'att': [], 'ti': t['ti']}
  
  return None #{'isa': 'type', 'kind': 'bad', 'type': t, 'att': []}
  


def cast(v, t):
  if v == None or t == None:
    return None
  
  #if not 'ti' in v:
  #  print("NOT TI: " + str(v))
  
  return {'isa': 'value', 'kind': 'to', 'value': v, 'type': t, 'att': [], 'ti': v['ti']}


def cast_implicit(v, t):
  if v == None or t == None:
    return None
  
  if not type.eq(v['type'], t):  #!
    if type.resolve(v['type'], t):
      return cast(v, t)
  return v


def cast_explicit(v, t):
  if v == None or t == None:
    return None
  
  return cast(v, t)




bin_ops = {
  'or': '|', 'xor': '^', 'and': '&', 'shl': '<<', 'shr': '>>',
  'eq': '==', 'ne': '!=',
  'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
  'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'mod': '%'
}

un_ops = {
  'ref': '&', 'deref': '*', 'plus': '+', 'minus': '-', 'not': '~'
}



def do_value_expr_bin(v):
  k = v['kind']
  l = do_value(v['left'])
  r = do_value(v['right'])
  
  if l == None or r == None:
    return None
  
  l = cast_implicit(l, r['type'])
  r = cast_implicit(r, l['type'])
  
  if not type.eq(l['type'], r['type']):
    error("type error2", v['ti'])
    return None
  
  t = l['type']
  if k in ['eq', 'ne', 'lt', 'gt', 'le', 'ge']:
    t = type.typeNat1
    
  # for generic
  if type.is_generic_numeric(l['type']) and type.is_generic_numeric(r['type']):
    if not 'num' in l:
      print(l)
    num = {
      'or': lambda a, b: a or b,
      'and': lambda a, b: a and b,
      'xor': lambda a, b: (a and not b) or (not a and b),
      'shl': lambda a, b: a << b,
      'shr': lambda a, b: a >> b,
      'eq': lambda a, b: a == b,
      'ne': lambda a, b: a != b,
      'lt': lambda a, b: a < b,
      'gt': lambda a, b: a > b,
      'le': lambda a, b: a <= b,
      'ge': lambda a, b: a >= b,
      'add': lambda a, b: a + b,
      'sub': lambda a, b: a - b,
      'mul': lambda a, b: a * b,
      'div': lambda a, b: int(a / b),
      'mod': lambda a, b: a % b,
    }[k](l['num'], r['num'])
    return {'isa': 'value', 'kind': 'num', 'type': t, 'num': num, 'att': []}
  
  
  return {'isa': 'value', 'kind': v['kind'], 'left': l, 'right': r, 'type': t, 'att': []}


def do_value_expr_un(v):
  val = do_value(v['value'])
  if val == None:
    return None
  
  t = val['type']
  if v['kind'] == 'deref':
    t = t['to']
    
  if v['kind'] == 'ref':
    t = type.typePointer(t, ti=v['ti'])
  
  
  if type.is_generic_numeric(val['type']):
    num = {
      'minus': lambda a: -a,
      'not': lambda a: not a,
    }[k](val['num'])
    return {'isa': 'value', 'kind': 'num', 'type': t, 'num': num, 'att': []}
  
  return {
    'isa': 'value',
    'kind': v['kind'],
    'value': val,
    'type': t,
    'att': [],
    'ti': v['ti']
  }


def do_value_expr_call(v):
  f = do_value(v['left'])
  if f == None:
    return None
  
  ftype = f['type']
  
  # pointer to function?
  if ftype['kind'] == 'pointer':
    ftype = ftype['to']
  
  if ftype['kind'] != 'func':
    error("expected function", v['ti'])
  
  params = ftype['params']
  
  npars = len(params)
  nargs = len(v['args'])
  
  if nargs < npars:
    error("not enough args", v['ti'])
    return None
  
  if nargs > npars:
    if not ftype['arghack']:
      error("too many args", v['ti'])
      return None
  
  args = []
  
  # normal args
  i = 0
  while i < npars:
    p = params[i]
    a = do_value(v['args'][i])
    a = cast_implicit(a, p['type'])
    if a == None:
      i = i + 1
      continue
    type.check(p['type'], a['type'], v['args'][i]['ti'])
    args.append(a)
    i = i + 1
  
  # arghack rest args
  while i < nargs:
    a = do_value(v['args'][i])
    if a == None:
      i = i + 1
      continue
      
    a = cast_implicit(a, type.typeInt)
    args.append(a)
    i = i + 1
  
  return {
    'isa': 'value',
    'kind': 'call',
    'left': f,
    'args': args,
    'type': ftype['to'],
    'att': [],
    'ti': v['ti']
  }


def do_value_expr_index(v):
  a = do_value(v['left'])
  if a == None:
    return None
  typ = a['type']
  
  ptr_access = typ['kind'] == 'pointer'
  if ptr_access:
    typ = typ['to']
  
  # check if is record
  if typ['kind'] != 'array':
    error("expected array or pointer to array", v['ti'])
    return None
  
  i = do_value(v['index'])
  
  if i == None:
    return None
  
  i = cast_implicit(i, type.typeInt)
  
  return {
    'isa': 'value',
    'kind': 'index',
    'array': a,
    'index': i,
    'type': typ['of'],
    'att': [],
    'ti': v['ti']
  }


def do_value_expr_access(v):
  r = do_value(v['left'])
  if r == None:
    return None
  
  field_id = v['field']
  
  typ = r['type']
  k = 'access'
  ptr_access = typ['kind'] == 'pointer'
  if ptr_access:
    k = 'access2'
    typ = r['type']['to']
  
  # check if is record 
  if typ['kind'] != 'record':
    error("expected record or pointer to record", v['ti'])
    return None
  
  field = type.record_field_get(typ, field_id)
  
  # field not found
  if field == None:
    error("field %s not exist" % field_id, v['ti'])
    return None
  
  return {'isa': 'value', 'kind': k, 'record': r, 'field': field, 'type': field['type'], 'att': [], 'ti': v['ti']}

  
def do_value_expr_to(v):
  t = do_type(v['type'])
  v = do_value(v['value'])
  
  if v == None or t == None:
    return None
  
  return cast_explicit(v, t)



def do_value_num(num, type=type.genericInt, ti=None):
  return {
    'isa': 'value',
    'kind': 'num',
    'num': num,
    'type': type,
    'att': [],
    'ti': ti
  }

def do_value_expr_id(v):
  vx = ctx.get_value(v['id'])
  if vx == None:
    error("undeclared value '%s'" % v['id'], v['ti'])
    return None # {'isa': 'value', 'kind': 'bad', 'value': v, 'type': type.typeBad(v['ti']), 'att': [], 'ti': v['ti']}

  return vx
  #return {'isa': 'value', 'kind': 'id', 'object': vx, 'type': vx['type'], 'ti': v['ti']}


def do_value_expr_str(v):
  str = v['str']
  return {'isa': 'value', 'kind': 'str', 'str': str, 'type': type.genericStr, 'att': [], 'ti': v['ti']}


def do_value_expr_composite(v):
  t = do_type(v['type'])
  items = []
  for i in v['items']:
    id = i['id']
    field = type.record_field_get(t, id)
    vi = do_value(i['value'])
    vi = cast_implicit(vi, field['type'])
    if vi != None:
      type.check(field['type'], vi['type'], i['ti'])
      items.append({'id': id, 'value': vi})
  return {
    'isa': 'value',
    'kind': 'composite',
    'type': t,
    'items': items,
    'att': [],
    'ti': v['ti']
  }


def do_value(v):
  k = v['kind']
  
  rv = None
  
  if k in bin_ops:
    rv = do_value_expr_bin(v)
  elif k in un_ops:
    rv = do_value_expr_un(v)
  else:
    if k == 'num':
      num = int(v['num'])
      rv = do_value_num(num, ti=v['ti'])
    elif k == 'id':
      rv = do_value_expr_id(v)
    elif k == 'str':
      rv = do_value_expr_str(v)
    elif k == 'composite':
      rv = do_value_expr_composite(v)
    else:
      if k == 'call':
        rv = do_value_expr_call(v)
      elif k == 'index':
        rv = do_value_expr_index(v)
      elif k == 'access':
        rv = do_value_expr_access(v)
      elif k == 'to':
        rv = do_value_expr_to(v)
      elif k == 'sizeof':
        tx = do_type(v['type'])
        rv = {'isa': 'value', 'kind': 'sizeof', 'of': tx, 'type': type.typeNat, 'att': []}
      else:
        rv = None #{'isa': 'value', 'kind': 'bad', 'value': v, 'att': []}
    
  if rv != None:
    rv['ti'] = v['ti']
  
  return rv
    
    


def do_stmt_if(x):
  c = do_value(x['cond'])
  t = do_stmt(x['then'])
  if c == None or t == None:
    return None
  
  c = cast_implicit(c, type.typeNat1)
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
  
  c = cast_implicit(c, type.typeNat1)
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
  if 'value' in x:
    v = do_value(x['value'])
    if v == None:
      return None
    v = cast_implicit(v, cfunc['type']['to'])
    type.check(v['type'], cfunc['type']['to'], x['value']['ti'])

  return {'isa': 'stmt', 'kind': 'return', 'value': v}


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
  
  """if 'generic' in v['type']['att']:
    error("value with unspecified type", v['ti'])
    return None"""
  
  vx = {'isa': 'value', 'kind': 'var', 'id': id, 'type': t}
  ctx.add_value(id, vx)
  return {'isa': 'stmt', 'kind': 'defvar', 'id': id, 'type': t, 'value': v}


def do_stmt_let(x):
  id = x['id']
  v = do_value(x['value'])
  
  if v == None:
    return None
  
  # let x = 10
  # не нужно генерить стейтмент, просто создаем константу тут
  if type.is_generic(v['type']):
    ctx.add_value(id, v)
    return None
  
  #
  vx = {'isa': 'value', 'kind': 'const', 'id': id, 'type': v['type']}
  ctx.add_value(id, vx)
  
  return {'isa': 'stmt', 'kind': 'let', 'id': id, 'value': v}


def do_stmt_assign(x):
  l = do_value(x['left'])
  r = do_value(x['right'])
  
  if l == None or r == None:
    return None
  
  # left is var?
  #if l['kind'] != 'var':
  #  error("expected var", x['left']['ti'])
  
  # type check
  r = cast_implicit(r, l['type'])
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
    
  return s
  


def do_stmt_block(s):
  global ctx
  ctx.push()
  stmts = []
  for stmt in s['stmts']:
    s = do_stmt(stmt)
    if s != None:
      stmts.append(s)
  ctx.pop()
  return {'isa': 'stmt', 'kind': 'block', 'stmts': stmts}
  


def do_import(x):
  loc = x['local']
  s = x['str']
  return {'isa': 'import', 'str': s, 'local': loc}


def do_const(x):
  id = x['id']
  v = do_value(x['value'])
  if v == None:
    print("????")
    print(x['value'])
    exit(1)
    return None
  y = {'isa': 'value', 'kind': 'const', 'id': id, 'type': v['type'], 'att': [], 'ti': x['ti']}
  ctx.add_value(id, y)
  return {'isa': 'constdef', 'id': id, 'value': v}

def do_typedef(x):
  id = x['id']
  t = do_type(x['type'])
  if t == None:
    return None
  t['aka'] = id
  ctx.add_type(x['id'], t)
  
  # ENUM
  if t['kind'] == 'enum':
    for item in t['items']:
      id = item['id']
      if id == None:
        continue
      #print("ex enum item " + id)
      y = {'isa': 'value', 'kind': 'const', 'id': id, 'type': t, 'value': do_value_num(item['number']), 'att': [], 'ti': item['ti']}
      ctx.add_value(id, y)
  
  return {'isa': 'typedef', 'id': x['id'], 'type': t}
  


def do_var(x):
  f = do_field(x['field'])
  if f == None:
    return None
  v = {'isa': 'value', 'kind': 'var', 'id': f['id'], 'type': f['type']}
  ctx.add_value(x['field']['id'], v)
  return {'isa': 'vardef', 'field': f, 'ti': x['ti']}

def do_funcdef(x):
  global cfunc
  func_id = x['id']
  func_type = do_type(x['type'])
  
  cfunc = {
    'isa': 'value',
    'kind': 'func',
    'id': func_id,
    'type': func_type,
    'ti': x['ti']
  }
  
  ctx.push()  # params context (!)
  
  i = 0
  while i < len(func_type['params']):
    param = func_type['params'][i]
    param_id = param['id']
    y = {'isa': 'value', 'kind': 'const', 'id': param_id, 'type': param['type']}
    ctx.add_value(param_id, y)
    i = i + 1
  
  cfunc['stmt'] = do_stmt_block(x['stmt'])
  
  ctx.pop()  # params context (!)
  
  ctx.add_value(x['id'], cfunc)
  
  return {
    'isa': 'funcdef',
    'id': func_id,
    'type': func_type,
    'stmt': cfunc['stmt'],
    'ti': x['ti']
  }


def do_exist(x):
  f = do_field(x['field'])
  if f == None:
    return None
  f['type']['arghack'] = f['id'] == 'printf'
  
  ctx.add_value(f['id'], {'isa': 'value', 'kind': 'func', 'id': f['id'], 'type': f['type']})
  return None
  #return {'isa': 'exist', 'field': f}


def translate(srcname):
  p = Parser()
  xx = p.parse(srcname)

  module = []
  for x in xx:
    isa = x['isa']
    #print("DO: %s" % isa)
    if isa == 'import':
      y = do_import(x)
    elif isa == 'var':
      y = do_var(x)
    elif isa == 'const':
      y = do_const(x)
    elif isa == 'func':
      y = do_funcdef(x)
    elif isa == 'type':
      y = do_typedef(x)
    elif isa == 'exist':
      y = do_exist(x)
      
    """elif isa == 'extern':
      do_extern(x)"""
    
    if y != None:
      module.append(y)
  
  return module



"""
outname = "out.c"


module = translate("main2.cm")
if errcnt == 0:
  printx(module, outname)
else:
  print(OKCYAN + "[fatal error]" + ENDC)
  exit(1)
  """

