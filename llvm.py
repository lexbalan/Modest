
from printer_common import *



func_context = None


TYPE_BOOL = 'i1'



def lot(x):
  lo("  " + x)

free_reg = 0

def reg_get():
  global free_reg
  free_reg = free_reg + 1
  reg = free_reg
  return reg


def operation (op):
  reg = reg_get ()
  o("\n  %%%d = %s " % (reg, op))
  return reg


def operation_with_type(op, t):
  reg = operation(op)
  print_type(t)
  return reg



def llvm_print_value(x):
  if x == None:
    o("<None>")
  elif x['kind'] in ['reg', 'adr']:
    o('%%%d' % x['reg'])
  elif x['kind'] in ['num']:
    o(str(x['num']))
  elif x['kind'] in ['id']:
    o(x['id'])
  elif x['kind'] in ['str']:
    o("\"%s\"" % x['str'])
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
    print_type(t['to'])
    if t['to']['kind'] != 'array':
      o("*")

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


def do_eval_expr_bin(v):
  l = do_eval(v['left'])
  r = do_eval(v['right'])
  regno = operation_with_type (v['kind'], v['left']['type'])
  space (); llvm_print_value (l); comma(); llvm_print_value (r)
  return {'isa': 'llvm_value', 'kind': 'reg', 'reg': regno}


def do_eval_expr_un(v):
  y = do_eval(v['value'])
  reg = operation(v['kind']); space(); llvm_print_value(y)
  return {'isa': 'llvm_value', 'kind': 'reg', 'reg': reg}


def do_eval_expr_call(v):
  # eval all args
  args = []
  for a in v['args']:
    args.append(do_eval(a))

  # eval func
  f = do_eval(v['left'])

  # do call
  reg = operation("call")
  llvm_print_value(f)
  o(" ("); print_list_by(args, llvm_print_value); o(")")
  return {'isa': 'llvm_value', 'kind': 'reg', 'reg': reg}


def do_eval_expr_index(v):
  a = do_eval(v['array'])
  i = do_eval(v['index'])
  reg = operation("index")
  llvm_print_value(a); comma(); llvm_print_value(i);
  return {'isa': 'llvm_value', 'kind': 'adr', 'reg': reg}


def do_eval_expr_access(v):
  rec = do_eval(v['record'])
  reg = operation("access"); llvm_print_value(rec)
  o(" .%s" % v['field']['id']['str'])
  return {'isa': 'llvm_value', 'kind': 'adr', 'reg': reg}


def do_eval_expr_access2(v):
  rec = do_eval(v['record'])
  reg = operation("access"); llvm_print_value(rec)
  o(" .%s" % v['field']['id']['str'])
  return {'isa': 'llvm_value', 'kind': 'adr', 'reg': reg}


def do_eval_expr_to(v):
  y = do_eval(v['value'])
  reg = operation("cast")
  o("(")
  llvm_print_value(y)
  o(" to ")
  print_type(v['type'])
  o(")")

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
      return func_context['locals'][localname]

    return {'isa': 'llvm_value', 'kind': 'id', 'id': v['id']['str']}

  elif k == 'str':
    return {'isa': 'llvm_value', 'kind': 'str', 'str': v['str']}

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
  lot("store "); llvm_print_value(l); comma(); llvm_print_value(r);


def print_base_block():
  o("<base block>")




def ll_br(x):
  o("\n  br %s " % TYPE_BOOL)
  #print_type(x['value']['type'])
  #o(" ")
  llvm_print_value(x)


def print_stmt_if(x):
  global func_context
  if_id = func_context['if_no']
  func_context['if_no'] = func_context['if_no'] + 1
  cv = do_eval(x['cond'])
  ll_br (cv)
  o(", label %%then_%d, label %%else_%d" % (if_id, if_id))
  o("\nthen_%d:" % if_id)
  print_stmt (x['then'])
  o("\n  br label %%endif_%d" % if_id)
  o("\nelse_%d:" % if_id)
  if x['else'] != None:
    print_stmt (x['else'])
  o("\n  br label %%endif_%d" % if_id)
  o("\nendif_%d:" % if_id)


def print_stmt_while(x):
  global func_context
  old_while_id = func_context['cur_while_id']
  func_context['while_no'] = func_context['while_no'] + 1
  cur_while_id = func_context['while_no']
  func_context['cur_while_id'] = cur_while_id
  o("\n  br label %%again_%d" % cur_while_id)
  o("\nagain_%d:" % cur_while_id)
  cv = do_eval(x['cond'])
  ll_br (cv)
  o(", label %%body_%d, label %%break_%d" % (cur_while_id, cur_while_id))
  o("\nbody_%d:" % cur_while_id)
  print_stmt (x['stmt'])
  o("\n  br label %%again_%d" % cur_while_id)
  o("\nbreak_%d:" % cur_while_id)
  func_context['cur_while_id'] = old_while_id


def print_stmt_return(x):
  if x['value'] == None:
    o("ret")
    return

  v = do_eval(x['value'])
  lot("ret "); llvm_print_value(v)


def print_stmt_defvar(x):
  global func_context

  reg = operation("alloca")
  print_type(x['type'])
  val = {'isa': 'llvm_value', 'kind': 'adr', 'reg': reg}

  if x['value'] != None:
    r = do_eval(x['value'])
    lot("st "); llvm_print_value(val); comma(); llvm_print_value(r);

  func_context['locals'][x['id']['str']] = val
  return None


def print_stmt_let(x):
  global func_context
  lo("  ; let")
  v = do_eval(x['value'])
  func_context['locals'][x['id']['str']] = v
  return None


def print_stmt(x):
  global indent

  k = x['kind']
  if k == 'block':
    print_stmt_block(x)
  elif k == 'value':
    do_eval(x['value']); o(";")
  elif k == 'assign':
    print_stmt_assign(x)
  elif k == 'return':
    print_stmt_return(x)
  elif k == 'if':
    print_stmt_if(x)
  elif k == 'while':
    print_stmt_while(x)
  elif k == 'asg_stmt_def_var':
    print_stmt_defvar(x)
  elif k == 'asg_stmt_def_let':
    print_stmt_let(x)
  else:
    lo("<stmt %s>" % str(x))


def print_stmt_block(s):
  for stmt in s['stmts']:
    print_stmt(stmt)


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

  i = 0
  while i < len(params):
    param = params[i]
    print_field(param)
    i = i + 1
    if i < len(params):
      o(", ")

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

    # map for local lets & vars
    # <id> => <llvm_value>
    'locals': {}
  }

  o("\ndefine ")
  print_type(x['type']['to'])
  o(" @%s" % x['id']['str'])
  o("(")

  params = x['type']['params']
  params_len = len(params)
  i = 0
  while i < params_len:
    if i > 0:
      o(", ")
    print_type(params[i]['type'])
    space()
    o('%' + params[i]['id']['str'])
    i = i + 1
  o(")")

  #print_func_signature(x['id']['str'], x['type'])
  o(" {")
  print_stmt_block(x['stmt'])
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
  llvm_print_value(x['value'])"""


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



def printx(module, outname):

  printer_open(outname)

  lo("#include <stdint.h>")

  """lo("#ifndef __TYPE_STR__")
  lo("#define __TYPE_STR__")
  lo("typedef char * Str;")
  lo("#endif /* __TYPE_STR__ */\n")"""

  """
    guardname = outname[:-2].upper() + '_H'
    if is_header:
      lo("#ifndef %s" % guardname)
      lo("#define %s\n" % guardname)
  """

  isa_prev = None

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

  o("\n")
  """if is_header:
    lo("#endif /* %s */" % guardname)"""
  o("\n")
  printer_close()



