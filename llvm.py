
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



def ll_create_value_imm(t, imm):
  return {
  'isa': 'llvm_value',
  'class': 'imm',
  'level': 'value',
  'imm': imm,
  'type': t,
  'proto': None
}


ll_value_zero = ll_create_value_imm(type.typeInt32, 0)




def print_type_value(llvm_value):
  print_type(llvm_value['type'])
  o(" ")
  print_value(llvm_value)


def insertvalue(v, x, pos):
  #%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
  reg = operation('insertvalue')
  print_type_value(v)
  comma()
  print_type_value(x)
  comma()
  o('%d' % pos)
  return {
    'isa': 'llvm_value',
    'class': 'reg',
    'level': 'value',
    'reg': reg,
    'type': v['type'],
    'proto': v['proto']
  }


def print_value(x):
  c = x['class']
  if c == 'reg':
    o('%%%d' % x['reg'])
  elif c == 'stk':
    o('%%%s' % x['id'])
  elif c == 'mem':
    o('@%s' % x['id'])
  elif c == 'imm':
    o(str(x['imm']))
  elif c == 'str':
    o("bitcast ([%d x i8]* @%s to %%Str)" % (x['len'], x['id']))
  elif c == 'array':
    o("[")
    print_list_by(x['items'], print_type_value)
    o("]")


  elif c == 'zero':
    o("zeroinitializer")
  else:
    o("<unknown_value::%s>" % c)



def print_list_by(lst, method):
  i = 0
  while i < len(lst):
    if i > 0:
      comma()
    method(lst[i])
    i = i + 1


def print_type(t, print_aka=True):
  k = t['kind']

  if print_aka:
    if 'aka' in t:
      id = t['aka']

      if id == '<generic:int>':
        id = 'Int'

      if id == 'Void':
        o("void")
        return

      o('%' + id)
      return

  if k == 'record':
    o("{")
    fields = t['fields']
    i = 0
    while i < len(fields):
      field = fields[i]
      if i > 0:
        o(',')
      o("\n\t"); print_type(field['type'])

      i = i + 1
    o("\n}")

  elif k == 'enum':
    o("i16")

  elif k == 'pointer':
    if t['to']['kind'] == 'enum':
      if t['to']['aka'] == 'Void':
        o("i8*")
        return
    print_type(t['to']); o("*")

  elif k == 'array':
    o("[")
    array_size = t['size']
    sz = 0
    if array_size != None:
      sz = array_size

    o("%d x " % sz)
    print_type(t['of'])
    o("]")

  elif k == 'func':
    print_type(t['to'])
    o("(")
    print_list_by(t['params'], lambda f: print_type(f['type']))
    o(")")

  elif k == 'base':
    o('%' + t['aka'])

  elif k == 'opaque':
    o('opaque')

  else:
    o("<type:%s>" % k)


# получает на вход llvm_value
# и если оно adr то загружает его в регистр
# в любом другом случае просто возвращает исходное значение
def do_ld(x):

  if x['level'] == 'adr':
    regno = operation('load');
    typ = x['type']
    print_type(typ)
    comma()
    print_type(typ)
    o("* ")
    print_value (x)
    return {
      'isa': 'llvm_value',
      'class': 'reg',
      'level': 'value',
      'reg': regno,
      'type': x['type'],
      'proto': x
    }

  return x


REL_OPS = ['eq', 'ne', 'lt', 'gt', 'le', 'ge']


def get_bin_opcode(op, t):
  opcode = "<unknown opcode '%s'>" % op
  if op in ['eq', 'ne']:
    opcode = get_bin_opcode_f('icmp ' + op, 'fcmp ' + op, t)
  elif op in ['add', 'sub', 'mul']:
    opcode = get_bin_opcode_f(op, 'f' + op, t)
  elif op in ['and', 'or', 'xor', 'shl']:
    opcode = do_eval_binary(k, t)
  elif op in ['div', 'mod']:
    if op == 'mod':
      op = 'rem'
    opcode = get_bin_opcode_suf('s' + op, 'u' + op, 'f' + op, t)
  elif op in ['lt', 'gt', 'le', 'ge']:
    opcode = get_bin_opcode_suf('icmp s' + op, 'icmp u' + op, 'fcmp u' + op, t)

  return opcode


def get_bin_opcode_f (op, fop, t): # ["sdiv", "udiv", "fdiv", x]
  if 'float' in t['meta']:
    return fop
  return op


def get_bin_opcode_su (sop, uop, t): # ["icmp slt", "icmp ult", x]
  if 'unsigned' in t['meta']:
    return uop
  return sop


def get_bin_opcode_suf (sop, uop, fop, t): # ["sdiv", "udiv", "fdiv", x]
  if 'float' in t['meta']:
    return fop
  return get_bin_opcode_su(sop, uop, t)




def do_eval_binary (op, x): # ["add", "fadd", x]
  l = do_ld(do_eval(x['left']))
  r = do_ld(do_eval(x['right']))
  regno = operation_with_type (op, x['left']['type'])
  space (); print_value (l); comma(); print_value (r)
  return {
    'isa': 'llvm_value',
    'class': 'reg',
    'level': 'value',
    'reg': regno,
    'type': x['type'],
    'proto': x
  }


def do_eval_expr_bin(x):
  opcode = get_bin_opcode(x['kind'], x['type'])
  return do_eval_binary(opcode, x)




def do_eval_expr_un(v):

  ve = do_eval(v['value'])

  if v['kind'] == 'ref':

    ve['level'] = 'value'
    ve['proto'] = v  # for type

    return ve


  vx = do_ld(ve)  #!


  if v['kind'] == 'deref':

    vx['level'] = 'adr'
    vx['proto'] = v  # for type

    return vx


  reg = operation(v['kind']); space(); print_value(vx)

  return {
    'isa': 'llvm_value',
    'class': 'reg',
    'level': 'value',
    'reg': reg,
    'type': v['type'],
    'proto': v
  }


def do_eval_expr_call(v):
  # eval all args
  args = []
  for a in v['args']:
    args.append(do_ld(do_eval(a)))

  ftype = v['left']['type']

  # eval func
  f = do_eval(v['left'])

  if ftype['kind'] == 'pointer':
    # pointer to array needs additional load
    f = do_ld(f)
    ftype = ftype['to']

  to_unit = type.eq(ftype['to'], type.typeUnit)

  # do call
  reg = 0
  if to_unit:
    lot("call ")
  else:
    reg = operation("call")

  #%Int32(%Str, ...)
  print_type(ftype['to'])
  o("(")
  params = ftype['params']
  print_list_by(params, lambda par: print_type(par['type']))
  if 'arghack' in ftype['meta']:
    o(", ...")
  o(") ")

  print_value(f)
  o(" (")
  print_list_by(args, print_type_value)
  o(")")
  return {
    'isa': 'llvm_value',
    'class': 'reg',
    'level': 'value',
    'reg': reg,
    'type': v['type'],
    'proto': v
  }







# индекс не может быть i64 (!) (а только i32)
# t - тип самой записи или массива (без указателя)
def llvm_getelementptr(rec, t, indexes):
  # Прикол в том что индекс (i) структуры
  # не может быть i64 (!) (а только i32)
  reg = operation_with_type ("getelementptr inbounds", t)
  comma()
  print_type(t)
  o("* ")
  print_value(rec)
  comma()
  print_list_by(indexes, print_type_value)

  return {
    'isa': 'llvm_value',
    'class': 'reg',
    'level': 'adr',
    'reg': reg,
    'type': t,
    #'proto': v
  }


# by var
def do_eval_expr_index(v):
  array = do_eval(v['array'])

  t = array['type']

  if t['kind'] == 'pointer':
    # pointer to array needs additional load
    array = do_ld(array)
    t = t['to']

  index = do_ld(do_eval(v['index']))
  return llvm_getelementptr(array, t, (ll_value_zero, index))


def do_eval_expr_access(v):
  rec = do_eval(v['record'])
  t = v['record']['type']

  if t['kind'] == 'pointer':
    # pointer to record needs additional load
    rec = do_ld(rec)
    t = t['to']

  field_index = ll_create_value_imm(type.typeInt32, v['field']['no'])
  return llvm_getelementptr(rec, t, (ll_value_zero, field_index))



"""
‘trunc .. to’ Instruction
‘zext .. to’ Instruction
‘sext .. to’ Instruction
‘fptrunc .. to’ Instruction
‘fpext .. to’ Instruction
‘fptoui .. to’ Instruction
‘fptosi .. to’ Instruction
‘uitofp .. to’ Instruction
‘sitofp .. to’ Instruction
‘ptrtoint .. to’ Instruction
‘inttoptr .. to’ Instruction
‘bitcast .. to’ Instruction
‘addrspacecast .. to’ Instruction
"""

# cast type a to type b
def opcast(a, b):
  if not 'size' in a:
    print("a without size: " + str(a))
  if not 'size' in b:
    print("b without size: " + str(b))

  signed = 'signed' in b['meta']

  if a['kind'] == 'base':
    if b['kind'] == 'base':
      if a['size'] < b['size']:
        if signed:
          return 'sext'
        else:
          return 'zext'
      elif a['size'] > b['size']:
        return 'trunc'
      else:
        return 'bitcast'

  return 'uncast'



def do_eval_expr_to(v):
  y = do_ld(do_eval(v['value']))

  opcode = opcast(v['value']['type'], v['type'])

  reg = operation(opcode)
  try:
    print_type(v['value']['type'])
  except:
    print("EXC: " + str(v['value']['type']))
  o(" ")
  print_value(y)
  o(" to ")
  print_type(v['type'])
  return {
    'isa': 'llvm_value',
    'class': 'reg',
    'level': 'value',
    'reg': reg,
    'type': v['type'],
    'proto': v
  }


"""def do_eval_array(v):
  o("{")
  i = 0
  while i < len(v['items']):
    if i > 0:
      comma()
    print_value(do_eval(v['items'][i]))
    i = i + 1
  o("}")"""


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


def do_eval(x):
  # bad value
  if x == None:
    return None

  v = do_eval_x(x)
  v['type'] = x['type']

  return v


def do_eval_x(v):
  # bad value
  if v == None:
    return None

  k = v['kind']


  if k in bin_ops:
    return do_eval_expr_bin(v)

  elif k in un_ops:
    return do_eval_expr_un(v)

  elif k == 'num':
    return {
      'isa': 'llvm_value',
      'class': 'imm',
      'level': 'value',
      'imm': v['num'],
      'type': v['type'],
      'proto': v
    }

  elif k in ['func', 'const', 'var']:
    if 'local' in v['meta']:
      localname = v['id']['str']
      return locals_get(localname) # func_context['locals'][localname]

    if k == 'var':
      return {
        'isa': 'llvm_value',
        'class': 'mem',
        'level': 'adr',
        'id': v['id']['str'],
        'type': v['type'],
        'proto': v,  # need for load/store, because it is 'adr'
      }

    return {
      'isa': 'llvm_value',
      'class': 'mem',
      'level': 'value',
      'id': v['id']['str'],
      'type': v['type'],
      'proto': v
    }

  elif k == 'str':
    return {
      'isa': 'llvm_value',
      'class': 'str',
      'level': 'value',
      'len': v['len'],
      'id': v['id'],
      'type': v['type'],
      'proto': v
    }

  elif k == 'record':
    return {'isa': 'llvm_value', 'kind': 'record'}
    #do_eval_record(v)

  elif k == 'array':
    # сперва вычисляем все элементы массива в регистры
    # (кроме констант, они едут до последнего)
    llvalues = []
    for item in v['items']:
      iv = do_eval(item)
      i = do_ld(iv)
      llvalues.append(i)

    if func_context == None:  # global
      return {
        'isa': 'llvm_value',
        'class': 'array',
        'level': 'value',
        'items': llvalues,
        'proto': v
      }

    # local

    # если мы локальны то создадим иммутабельную структуру
    # с массивом (insertvalue)
    #%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
    xv = {
      'isa': 'llvm_value',
      'class': 'zero',
      'level': 'value',
      'type': v['type'],
      'proto': v,
    }

    # набиваем структуру
    i = 0
    while i < len(llvalues):
      xv = insertvalue(xv, llvalues[i], i)
      i = i + 1

    return xv



    #do_eval_array(v)

  else:
    if k == 'call':
      return do_eval_expr_call(v)
    elif k == 'index':
      return do_eval_expr_index(v)
    elif k == 'access':
      return do_eval_expr_access(v)
    elif k == 'to':
      return do_eval_expr_to(v)
    elif k == 'sizeof':
      return {
        'isa': 'llvm_value',
        'kind': 'imm',
        'imm': 0,
        'proto': v
      }
    else:
      o("<%s>" % k)
      return {
        'isa': 'llvm_value',
        'kind': 'imm',
        'imm': 0,
        'proto': v
      }

#
#
#


def ll_assign(l, r):
  lot("store ");
  print_type(r['type'])
  o(" ")
  print_value(r)
  comma()
  print_type(r['type'])
  o("* ")
  print_value(l)


def print_stmt_assign(x):
  r = do_ld(do_eval(x['right']))
  l = do_eval(x['left'])
  ll_assign(l, r)


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

  id = x['id']['str']
  lo("  %%%s = alloca " % id)

  print_type(x['type'])
  val = {
    'isa': 'llvm_value',
    'class': 'stk',
    'level': 'adr',
    'id': id,
    'type': x['type'],
    'proto': x,
  }

  if x['value'] != None:
    r = do_ld(do_eval(x['value']))
    ll_assign(val, r)

  locals_add(id, val)
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

  print_type(to)
  o(" @%s(" % id)

  print_list_by(params, lambda field: print_type(field['type']))

  if 'arghack' in typ['meta']:
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
    id = param['id']['str']
    if i > 0:
      o(", ")
    print_type(param['type'])
    space()
    o('%' + id)

    #reg = reg_get()
    vv = {
      'isa': 'llvm_value',
      'class': 'stk',
      'level': 'value',
      'id': id,
      'type': param['type'],
      'proto': param
    }
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
  #  if extern:
  #    o("extern ")
  if f['type']['kind'] == 'func':
    o("declare ")
    print_func_signature(f['id']['str'], f['type'])
    #declare %Int32 @printf (%Str, ...)
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

  o("%%%s = type " % x['id']['str'])
  print_type(x['type'], print_aka=False)



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
    print_value(do_eval(x['init']))
  else:
    o(" zeroinitializer")


def print_constdef(x):
  #o("#define %s  (" % x['id']['str'])
  #do_eval(x['value'])
  #o(")")
  pass


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

  lo("%Bool= type i1")
  #lo("%Void = type i1")
  lo("%Nil = type i1*")
  lo("%Unit = type i1")
  lo("%Str = type [0 x i8]*")

  lo("%Nat1 = type i1")

  lo("%Nat8 = type i8")
  lo("%Nat16 = type i16")
  lo("%Nat32 = type i32")
  lo("%Nat64 = type i64")

  lo("%Int = type i64")

  lo("%Int8 = type i8")
  lo("%Int16 = type i16")
  lo("%Int32 = type i32")
  lo("%Int64 = type i64")

  lo("%Float16 = type half")
  lo("%Float32 = type float")
  lo("%Float64 = type double")
  lo("%Float128 = type fp128")

  isa_prev = None

  #@str1 = constant [4 x i8] c"Hi!\00"
  for s in strs:
    string = strs[s]

    lo("@%s = constant [%d x i8] c\"%s\\00\"" % (s, string['len'], string['str']))

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



