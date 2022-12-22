
from printer_common import *
import type


func_context = None


def locals_push():
  func_context['locals'].append({})

def locals_pop():
  func_context['locals'].pop()

def locals_add(id, llval):
  func_context['locals'][-1][id] = llval

def locals_get(id):
  # идем по стеку контекстов вглубь в поиске id
  i = len(func_context['locals'])
  while i > 0:
    c = func_context['locals'][i - 1]
    if id in c:
      return c[id]
    i = i - 1
  return None





TYPE_BOOL = 'i1'



def lot(x):
  lo("  " + x)

free_reg = 0

def reg_get():
  global func_context
  if func_context == None:
    print("reg_get outside function body")
    return 100
  reg = func_context['free_reg']
  func_context['free_reg'] = func_context['free_reg'] + 1
  return reg


def operation (op):
  reg = reg_get ()
  o("\n  %%%d = %s " % (reg, op))
  return reg


def operation_with_type(op, t):
  reg = operation(op)
  print_type(t)
  return reg



def print_value(x):
  if x == None:
    o("<None>")
  elif x['kind'] in ['reg', 'adr']:
    if 'id' in x:
      o(x['id'])
    else:
      o('%%%d' % x['reg'])
  elif x['kind'] in ['num']:
    o(str(x['num']))
  elif x['kind'] in ['id']:
    o(x['id'])
  elif x['kind'] in ['str']:
    o("%%Str bitcast ([%d x i8]* @%s to %%Str)" % (x['len'], x['id']))
  else:
    o("<unknown_value::%s>" % x['kind'])


def print_list_by(lst, method):
  i = 0
  while i < len(lst):
    if i > 0:
      comma()
    method(lst[i])
    i = i + 1


"""def ll_binary(op, a, b):
  regno = operation_with_type (op, a['type'])
  space (); do_eval (a); comma (); do_eval (b)
  return {'isa': 'llvm_value', 'kind': 'reg', 'reg': regno}

def ll_unary(op, v):
  regno = operation_with_type (op, a['type'])
  space (); do_eval (v);
  return {'isa': 'llvm_value', 'kind': 'reg', 'reg': regno}
"""

typealiases = {
  '<generic:int>': 'i64',
  'Unit': 'i1',
  'Int': 'int',
  'Int8': 'i8',
  'Int16': 'i16',
  'Int32': 'i32',
  'Int64': 'i64',
  'Nat8': 'i8',
  'Nat16': 'i16',
  'Nat32': 'i32',
  'Nat64': 'i64',
  'Nat1': 'i1',
}

def print_type(t, print_aka=True):
  k = t['kind']

  if print_aka:
    if 'aka' in t:
      id = t['aka']
      if id in typealiases:
        o(typealiases[id])
      else:
        o(id)
      return

  if k == 'record':
    o("type {")
    fields = t['fields']
    i = 0
    while i < len(fields):
      field = fields[i]
      o("\n")
      o("\t"); print_type(field['type'])
      o(";")
      i = i + 1
    o("\n}")

  elif k == 'enum':
    o("enum {")
    items = t['items']
    i = 0
    while i < len(items):
      item = items[i]
      o("\n")
      o("\t%s," % item['id']['str'])
      i = i + 1
    o("\n}")

  elif k == 'pointer':
    print_type(t['to']); o("*")

  elif k == 'array':
    o("[")
    array_size = t['size']
    if array_size != None:
      do_eval(array_size)
    else:
      o("0")
    o(" x ")
    print_type(t['of'])
    o("]")

  elif k == 'func':
    o("void")

  else:
    o("<type:%s>" % k)


# получает на вход llvm_value
# и если оно adr то загружает его в регистр
# в любом другом случае просто возвращает исходное значение
def do_ld(x):

  if x['kind'] == 'adr':
    regno = operation('load');
    print_type(x['type'])
    comma()
    print_type(x['type'])
    o("* ")
    print_value (x)
    return {'isa': 'llvm_value', 'kind': 'reg', 'reg': regno}

  return x


def do_eval_expr_bin(v):
  l = do_ld(do_eval(v['left']))
  r = do_ld(do_eval(v['right']))

  op = v['kind']

  if op in ['eq', 'ne', 'lt', 'gt', 'le', 'ge']:
    sign_prefix = 's' if 'signed' in v['left']['type']['meta'] else 'u'
    op = 'icmp ' + sign_prefix + op

  regno = operation_with_type (op, v['left']['type'])
  space (); print_value (l); comma(); print_value (r)
  return {'isa': 'llvm_value', 'kind': 'reg', 'reg': regno}


def do_eval_expr_un(v):
  #if v['kind'] == 'ref':

  y = do_ld(do_eval(v['value']))
  reg = operation(v['kind']); space(); print_value(y)
  return {'isa': 'llvm_value', 'kind': 'reg', 'reg': reg}


def do_eval_expr_call(v):
  # eval all args
  args = []
  for a in v['args']:
    args.append(do_ld(do_eval(a)))

  # eval func
  f = do_eval(v['left'])

  to_unit = type.eq(v['left']['type']['to'], type.typeUnit)

  # do call
  reg = 0
  if to_unit:
    lot("call ")
  else:
    reg = operation("call")

  #%Int32(%Str, ...)
  print_type(v['left']['type']['to'])
  o("(")
  params = v['left']['type']['params']
  print_list_by(params, lambda par: print_type(par['type']))
  o(") ")

  print_value(f)
  o(" ("); print_list_by(args, print_value); o(")")
  return {'isa': 'llvm_value', 'kind': 'reg', 'reg': reg}


def do_eval_expr_index(v):
  a = do_ld(do_eval(v['array']))
  i = do_ld(do_eval(v['index']))
  reg = operation("index")
  print_value(a); comma(); print_value(i);
  return {'isa': 'llvm_value', 'kind': 'adr', 'reg': reg}


def do_eval_expr_access(v):
  rec = do_ld(do_eval(v['record']))
  reg = operation("access"); print_value(rec)
  o(" .%s" % v['field']['id']['str'])
  return {'isa': 'llvm_value', 'kind': 'adr', 'reg': reg}


def do_eval_expr_access2(v):
  rec = do_ld(do_eval(v['record']))
  reg = operation("access"); print_value(rec)
  o(" .%s" % v['field']['id']['str'])
  return {'isa': 'llvm_value', 'kind': 'adr', 'reg': reg}


def do_eval_expr_to(v):
  y = do_ld(do_eval(v['value']))
  # = bitcast %Nat8* %4 to %Void*
  reg = operation("bitcast")
  print_type(v['value']['type'])
  o(" ")
  print_value(y)
  o(" to ")
  print_type(v['type'])
  return {'isa': 'llvm_value', 'kind': 'reg', 'reg': reg}


def do_eval_array(v):
  o("{")
  i = 0
  while i < len(v['items']):
    if i > 0:
      comma()
    print_value(do_eval(v['items'][i]))
    i = i + 1
  o("}")


def do_eval_record(v):
  o("{")
  i = 0
  while i < len(v['items']):
    if i > 0:
      comma()
    o(".%s=" % v['items'][i]['id']['str'])
    do_eval(v['items'][i]['value'])
    i = i + 1
  o("}")



bin_ops = [
  'or', 'xor', 'and', 'shl', 'shr',
  'eq', 'ne', 'lt', 'gt', 'le', 'ge',
  'add', 'sub', 'mul', 'div', 'mod'
]

un_ops = ['ref', 'deref', 'plus', 'minus', 'not']

def do_eval(v):
  # bad value
  if v == None:
    return

  k = v['kind']

  if k in bin_ops:
    return do_eval_expr_bin(v)

  elif k in un_ops:
    return do_eval_expr_un(v)

  elif k == 'num':
    return {'isa': 'llvm_value', 'kind': 'num', 'num': v['num']}

  elif k in ['func', 'const', 'var']:
    if 'local' in v['meta']:
      localname = v['id']['str']
      return locals_get(localname) # func_context['locals'][localname]

    if k == 'var':
      return {
        'isa': 'llvm_value',
        'kind': 'adr',
        'type': v['type'],  # need for load/store, because it is 'adr'
        'id': '@' + v['id']['str'],
      }

    return {'isa': 'llvm_value', 'kind': 'id', 'id': '@' + v['id']['str']}

  elif k == 'str':
    return {'isa': 'llvm_value', 'kind': 'str', 'len': v['len'], 'id': v['id']}

  elif k == 'record':
    return {'isa': 'llvm_value', 'kind': 'record'}
    #do_eval_record(v)

  elif k == 'array':
    return {'isa': 'llvm_value', 'kind': 'array'}
    #do_eval_array(v)

  else:
    if k == 'call':
      return do_eval_expr_call(v)
    elif k == 'index':
      return do_eval_expr_index(v)
    elif k == 'access':
      return do_eval_expr_access(v)
    elif k == 'access2':
      return do_eval_expr_access2(v)
    elif k == 'to':
      return do_eval_expr_to(v)
    elif k == 'sizeof':
      return {'isa': 'llvm_value', 'kind': 'num', 'num': 0}
    else:
      o("<%s>" % k)
      return {'isa': 'llvm_value', 'kind': 'num', 'num': 0}

#
#
#


def print_stmt_assign(x):
  r = do_eval(x['right'])
  l = do_eval(x['left'])
  lot("store ");
  print_type(x['right']['type'])
  o(" ")
  print_value(r)
  comma()
  print_type(x['right']['type'])
  o("* ")
  print_value(l);


def print_base_block():
  o("<base block>")



def ll_br(x, then_label, else_label):
  o("\n  br %s" % TYPE_BOOL)
  print_value(x)
  o(" , label %%%s, label %%%s" % (then_label, else_label))

def op_goto(label):
  o("\n  br label %%%s" % label)

def set_label(label):
  o("\n%s:" % label)


def print_stmt_if(x):
  global func_context
  if_id = func_context['if_no']
  func_context['if_no'] = func_context['if_no'] + 1
  cv = do_ld(do_eval(x['cond']))

  then_label = 'then_%d' % if_id
  else_label = 'else_%d' % if_id
  endif_label = 'endif_%d' % if_id

  if x['else'] == None:
    else_label = endif_label

  ll_br(cv, then_label, else_label)

  # then block
  set_label(then_label)
  print_stmt(x['then'])
  op_goto(endif_label)

  # else block
  if x['else'] != None:
    set_label(else_label)
    print_stmt(x['else'])
    op_goto(endif_label)

  # endif label
  set_label(endif_label)


def print_stmt_while(x):
  global func_context
  old_while_id = func_context['cur_while_id']
  func_context['while_no'] = func_context['while_no'] + 1
  cur_while_id = func_context['while_no']
  func_context['cur_while_id'] = cur_while_id

  again_label = 'again_%d' % cur_while_id
  break_label = 'break_%d' % cur_while_id
  body_label = 'body_%d' % cur_while_id

  op_goto(again_label)
  set_label(again_label)
  cv = do_ld(do_eval(x['cond']))
  ll_br(cv, body_label, break_label)
  set_label(body_label)
  print_stmt(x['stmt'])
  op_goto(again_label)
  set_label(break_label)
  func_context['cur_while_id'] = old_while_id


def print_stmt_again():
  global func_context
  cur_while_id = func_context['cur_while_id']
  op_goto('again_%d' % cur_while_id)
  reg_get()  # for LLVM


def print_stmt_break():
  global func_context
  cur_while_id = func_context['cur_while_id']
  op_goto('break_%d' % cur_while_id)
  reg_get()  # for LLVM


def print_stmt_return(x):
  v = None
  if x['value'] != None:
    v = do_ld(do_eval(x['value']))

  lot("ret ")

  if v != None:
    print_type(x['value']['type'])
    o(" ")
    print_value(v)
  else:
    o("void")

  reg_get()  # for LLVM



def print_stmt_vardef(x):
  global func_context

  id = '%' + x['id']['str']
  #reg = reg_get()
  lo("  %s = alloca " % id)

  print_type(x['type'])
  val = {'isa': 'llvm_value', 'kind': 'adr', 'type': x['type'], 'id': id}

  if x['value'] != None:
    r = do_ld(do_eval(x['value']))
    lot("st "); print_value(val); comma(); print_value(r);

  locals_add(x['id']['str'], val)
  return None


def print_stmt_let(x):
  global func_context
  v = do_ld(do_eval(x['value']))
  locals_add(x['id']['str'], v)
  return None


def print_stmt(x):
  global indent

  k = x['kind']
  if k == 'block':
    print_stmt_block(x)
  elif k == 'value':
    do_eval(x['value'])
  elif k == 'assign':
    print_stmt_assign(x)
  elif k == 'return':
    print_stmt_return(x)
  elif k == 'if':
    print_stmt_if(x)
  elif k == 'while':
    print_stmt_while(x)
  elif k == 'asg_stmt_def_var':
    print_stmt_vardef(x)
  elif k == 'asg_stmt_def_let':
    print_stmt_let(x)
  elif k == 'break':
    print_stmt_break()
  elif k == 'again':
    print_stmt_again()
  else:
    lo("<stmt %s>" % str(x))


def print_stmt_block(s):
  locals_push()
  for stmt in s['stmts']:
    print_stmt(stmt)
  locals_pop()


def print_func_signature(id, typ):
  params = typ['params']
  to = typ['to']
  t = to

  # возврат является масссивом?
  is_array = t['kind'] == 'array'
  array_size = None
  if is_array:
    array_size = t['size']
    t = t['of']

  # поле является указателем?
  ptr_level = 0
  while t['kind'] == 'pointer':
    ptr_level = ptr_level + 1
    t = t['to']
    # *[] or *[n] -> just *
    if t['kind'] == 'array':
      t = t['of']

  print_type(t)
  o(" " + "*" * ptr_level)
  o("%s(" % id)

  print_list_by(params, print_field)
  """i = 0
  while i < len(params):
    param = params[i]
    print_field(param)
    i = i + 1
    if i < len(params):
      o(", ")"""

  if 'arghack' in typ:
    if typ['arghack']:
      o(", ...")

  o(")")


def print_funcdef(x):
  global func_context

  # create new func context
  old_func_context = func_context
  func_context = {
    'if_no': 0,
    'while_no': 0,
    'cur_while_id': 0,

    'free_reg': 0,

    # map for local lets & vars
    # <id> => <llvm_value>
    'locals': [{}]
  }

  o("\ndefine ")
  print_type(x['type']['to'])
  o(" @%s" % x['id']['str'])
  o("(")

  params = x['type']['params']
  params_len = len(params)
  i = 0
  while i < params_len:
    param = params[i]
    id = '%' + param['id']['str']
    if i > 0:
      o(", ")
    print_type(param['type'])
    space()
    o(id)

    #reg = reg_get()
    vv = {'isa': 'llvm_value', 'kind': 'reg', 'id': id}
    locals_add(param['id']['str'], vv)
    i = i + 1
  o(")")

  # 0, 1, 2 - params; 3 - entry label, 4 - first free register
  entry_label = reg_get()  # (!)

  #print_func_signature(x['id']['str'], x['type'])
  o(" {")
  print_stmt_block(x['stmt'])

  if type.eq(x['type']['to'], type.typeUnit):
    lo("  ret void")
  lo("}")

  func_context = old_func_context


def print_exist_extern(x, extern=False):
  f = x['field']
  if extern:
    o("extern ")
  if f['type']['kind'] == 'func':
    print_func_signature(f['id']['str'], f['type'])
  else:
    print_field(f)
  o(";")


def print_exist(x):
  print_exist_extern(x)


def print_extern(x):
  print_exist_extern(x, extern=True)


def print_typedef(x):
  if x['type']['kind'] in ['record', 'enum']:
    o("\n")

  o("typedef ")
  print_type(x['type'], print_aka=False)
  o(" %s;" % x['id']['str'])



# из за того что с C типы записваются через жопу
# приходится печатать типы ptr, arr & func вместе с именем поля
def print_field(x):
  t = x['type']

  # поле является масссивом?
  is_array = t['kind'] == 'array'
  array_size = None
  if is_array:
    array_size = t['size']
    t = t['of']

  # поле является указателем?
  ptr_level = 0
  while t['kind'] == 'pointer':
    t = t['to']

    if t == 'func':
      t = type.typeUnit
    else:
      ptr_level = ptr_level + 1
      # *[] or *[n] -> just *
      if t['kind'] == 'array':
        t = t['of']

  print_type(t)
  o(" ")
  o("*" * ptr_level)
  o("%s" % (x['id']['str']))
  if is_array:
    o("[")
    if array_size != None:
      do_eval(array_size)
    o("]")



"""def print_val_with_type(x):
  print_type(x['type'])
  o(" ")
  print_value(x['value'])"""


def print_vardef(x):
  mods = ['external', 'global', 'constant']
  mod = 'global'
  o("@")
  o(x['field']['id']['str'])
  o(" = %s " % mod)
  print_type(x['field']['type'])
  if x['init'] != None:
    o(" ")
    do_eval(x['init'])
  else:
    o(" zeroinitializer")


def print_constdef(x):
  o("#define %s  (" % x['id']['str'])
  do_eval(x['value'])
  o(")")


def print_import(x):
  s = x['str'] + '.h'
  if x['local']:
    s = '"' + s + '"'
  else:
    s = '<' + s + '>'
  o("#include %s" % s)



def printx(module, strs, outname):
  outname = outname + '.ll'
  printer_open(outname)

  lo("%Str = type [0 x i8]*")

  isa_prev = None

  #@str1 = constant [4 x i8] c"Hi!\00"
  for s in strs:
    lo("@%s = constant [%d x i8] c\"%s\\00\"" % (s, len(strs[s]) + 1, strs[s]))

  for x in module:
    o("\n")
    isa = x['isa']

    if isa_prev != isa:
      if not isa in ['asg_def_func', 'asg_def_type']:
        o("\n")
      isa_prev = isa

    if isa == 'import':
      print_import(x)
    elif isa == 'asg_def_var':
      print_vardef(x)
    elif isa == 'asg_def_const':
      print_constdef(x)
    elif isa == 'asg_def_func':
      print_funcdef(x)
    elif isa == 'asg_def_type':
      print_typedef(x)
    elif isa == 'asg_def_exist':
      print_exist(x)
    elif isa == 'asg_def_extern':
      print_extern(x)

  o("\n\n")
  printer_close()



