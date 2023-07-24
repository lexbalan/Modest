
from opt import *
import core.type as type
from error import info
from .common import *
from core.type import type_attribute_check
from core.value import value_attribute_check
from core.hlir import hlir_value_num_get

# красивости
# если сущность была уже отделена новой строкой
# (typedef struct & def func должны всегда отделяться пустой строкой)
was_separated_by_new_line = True


aprecedence = [
  ['or'], #0
  ['xor'], #1
  ['and'], #2
  ['eq', 'ne'], #3
  ['lt', 'le', 'gt', 'ge'], #4
  ['shl', 'shr'], #5
  ['add', 'sub'], #6
  ['mul', 'div', 'mod'], #7
  ['plus', 'minus', 'not', 'cast', 'ref', 'deref', 'sizeof'], #8
  ['call', 'index', 'access'], #9
  ['num', 'var', 'func', 'str', 'enum', 'record', 'array'] #10
]

precedenceMax = len(aprecedence) - 1

# приоритет операции
def precedence(x):
  i = 0
  while i < precedenceMax + 1:
    if x in aprecedence[i]:
      break
    i = i + 1
  return i



def print_type_integer(t):
  if 'id' in t:
    o(t['id']['str'])
    return

  o(t['name'])


def print_type_array(t):
  o("[")
  if t['volume'] != None:
    print_value(t['volume'])
  o("]")
  print_type(t['of'])


def print_type_pointer(t):
  if type.is_free_pointer(t):
    o("Pointer")
    return
  o("*"); print_type(t['to'])


def print_type_record(t):
  o("record {")
  indent_up()
  fields = t['fields']
  i = 0
  while i < len(fields):
    field = fields[i]
    o("\n")
    ind(); print_field(field)
    i = i + 1
  indent_down()
  o("\n"); ind(); o("}")


def print_type_enum(t):
  o("enum {")
  items = t['items']
  i = 0
  while i < len(items):
    item = items[i]
    o("\n")
    #o("\t%s_%s," % (t['aka'], item['id']['str']))
    o("\t%s," % (item['id']['str']))
    i = i + 1
  o("\n}")



def print_type_func(t):
  params = t['params']
  to = t['to']

  o('(')
  i = 0
  while i < len(params):
    param = params[i]
    print_field(param)
    i = i + 1
    if i < len(params):
      o(", ")
  o(') -> ')
  print_type(to)



def print_type(t, print_aka=True):
  k = t['kind']

  if print_aka:
    """if 'id' in t:
      o(t['id']['str'])
      return"""

    if 'name' in t:
      o(t['name'])
      return

  if type.is_integer(t): print_type_integer(t)
  elif type.is_func(t): print_type_func(t)
  elif type.is_array(t): print_type_array(t)
  elif type.is_record(t): print_type_record(t)
  elif type.is_enum(t): print_type_enum(t)
  elif type.is_pointer(t): print_type_pointer(t)
  elif k == 'opaque': pass
  else: o("<type:" + str(t) + ">")



bin_ops = {
  'or': 'or', 'xor': 'xor', 'and': 'and', 'shl': '<<', 'shr': '>>',
  'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
  'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'mod': '%',
  'logic_and': 'and', 'logic_or': 'or'
}

def print_value_bin(v, ctx):
  op = v['kind']
  left = v['left']
  right = v['right']

  # получаем приоритеты операции и операндов
  p0 = precedence(op)
  pl = precedence(left['kind'])
  pr = precedence(right['kind'])
  need_wrap_left = pl < p0
  need_wrap_right = pr < p0

  # GCC выдает warning например в: 1 << 2 + 2, тк считает
  # Что юзер имел в виду (1 << 2) + 2, а у << приоритет тние
  # чтобы он не ругался, завернем такие выражения в скобки
  if op in ['shl', 'shr']:
    need_wrap_left = precedence(left['kind']) < precedenceMax
    need_wrap_right = precedence(right['kind']) < precedenceMax

  # if logic operation
  if type.eq(left['type'], type.typeNat1):
    if op == 'or':
      op = 'or'
    elif op == 'and':
      op = 'and'

  print_value(left, need_wrap=need_wrap_left)
  o(' %s ' % bin_ops[op])
  print_value(right, need_wrap=need_wrap_right)



un_ops = {
  'ref': '&', 'deref': '*', 'plus': '+', 'minus': '-', 'not': 'not', 'logic_not': 'not'
}


def print_value_un(v, ctx):
  op = v['kind']
  value = v['value']

  p0 = precedence(op)
  pv = precedence(value['kind'])

  if op == 'not':
    if type.eq(value['type'], type.typeNat1):
      op = 'logic_not'

  o(un_ops[op]); print_value(value, need_wrap=pv<p0)


def print_value_call(v, ctx):
  left = v['func']
  if left['type']['kind'] == 'pointer':
    t = left['type']['to']
    # вызов через указатель
    # поскольку у нас указатели на функции это *void
    # при вызове приводим левое к указателю на функцию
    o("((")
    print_type(t['to'])
    o("(*)(")
    i = 0
    n = len(t['params'])
    while i < n:
      p = t['params'][i]
      print_field(p)
      i = i + 1
      if i < n:
        o(", ")
    o(")")
    o(")")
    print_value(left)
    o(")")

  else:
    print_value(left)

  o("(")
  i = 0
  while i < len(v['args']):
    a = v['args'][i]
    print_value(a)
    i = i + 1
    if i < len(v['args']):
      o(", ")
  o(")")


def print_value_index(v, ctx):
  array = v['array']
  index = v['index']
  need_wrap = precedence(array['kind']) < precedence('index')
  print_value(array, need_wrap)
  o("["); print_value(index); o("]")


def print_value_index_ptr(v, ctx):
  array = v['pointer']
  index = v['index']
  need_wrap = precedence(array['kind']) < precedence('index')
  print_value(array, need_wrap)
  o("["); print_value(index); o("]")


def print_value_access(v, ctx):
  left = v['record']
  need_wrap = precedence(left['kind']) < precedence('access')
  print_value(left, need_wrap); o("."); o(v['field']['id']['str'])


def print_value_access_ptr(v, ctx):
  left = v['pointer']
  need_wrap = precedence(left['kind']) < precedence('access')
  print_value(left, need_wrap); o("."); o(v['field']['id']['str'])


def print_cast(t, v, ctx=[]):
  print_value(v, ctx=ctx)
  o(' to ')
  print_type(t)


def print_value_cast(v, ctx):

  #need_wrap = precedence(v['value']['kind']) > precedence('to')

  #if need_wrap:
  #  o('(')

  # не печатаем операции неявного приведения (!)
  if value_attribute_check(v, 'implicit-casted'):
    print_value(v['value'])
    return

  print_cast(v['type'], v['value'], ctx)

  #if need_wrap:
  #  o(')')



def print_value_imm_array(v, ctx):
  o("[")
  i = 0
  while i < len(v['items']):
    if i > 0: o(", ")
    print_value(v['items'][i])
    i = i + 1
  o("]")


def print_value_imm_record(v, ctx):
  multiline = not 'oneline' in ctx

  o("{")
  i = 0
  if multiline:
    o("\n")
    indent_up()
  nitems = len(v['items'])
  #while i < nitems:
  for k in v['items']:
    item = v['items'][k]

    if multiline: ind()

    o("%s=" % k)
    print_value(item, ctx)
    if i < (nitems - 1):
      o(",")
      if not multiline: o(" ")
    if multiline: o("\n")

    i = i + 1
  if multiline:
    indent_down()
    ind()
  o("}")



def print_value_imm_str(x, ctx):
  o("\"")
  for sym in x['str']:
    if sym == '\n': o("\\n")
    elif sym == '\r': o("\\r")
    elif sym == '\a': o("\\a")
    else: o(sym)
  o("\"")


def print_value_imm_num(x, ctx):
  if value_attribute_check(x, 'hexadecimal'):
    o("0x%X" % hlir_value_num_get(x))
  elif type.is_pointer(x['type']):
    if hlir_value_num_get(x) == 0:
      o("nil")
      return
  else:
    o(str(hlir_value_num_get(x)))


def print_value_zero(x, ctx):
  t = x['type']
  if type.is_array(t): o("[]")
  elif type.is_record(t): o("{}")
  else: o("0")


def print_value_enum(x, ctx):
  o("%s" % (x['id']['str']))


def print_value_by_id(x, ctx):
  o("%s" % x['id']['str'])


def print_value_imm(x, ctx):
  t = x['type']
  if type.is_integer(t): print_value_imm_num(x, ctx)
  elif type.is_float(t): print_value_imm_num(x, ctx)
  elif type.is_record(t): print_value_imm_record(x, ctx)
  elif type.is_array(t): print_value_imm_array(x, ctx)
  elif type.is_string(t): print_value_imm_str(x, ctx)
  elif type.is_free_pointer(t): o("nil")
  elif type.is_pointer(t): print_value_imm_num(x, ctx)


def print_value(x, ctx=[], need_wrap=False, print_just_id=True):
  # если у значения есть свойство 'id' то печатаем просто id
  # (используется для печати имени констант а не просто их значения)
  # в LLVM перчаем просто значение

  if print_just_id:
    if 'id' in x:
      print_value_by_id(x, ctx)

      # ??
      #need_cast = value_attribute_check(x, 'explicit-casted')
      #if need_cast:
      #  o(" to "); print_type(x['type'])
      return

  if need_wrap:
    o("(")

  k = x['kind']

  if k == 'immediate': print_value_imm(x, ctx)
  elif k in bin_ops: print_value_bin(x, ctx)
  elif k in un_ops: print_value_un(x, ctx)
  elif k in ['func', 'var']: print_value_by_id(x, ctx)
  elif k == 'call': print_value_call(x, ctx)
  elif k == 'index': print_value_index(x, ctx)
  elif k == 'index_ptr': print_value_index_ptr(x, ctx)
  elif k == 'access': print_value_access(x, ctx)
  elif k == 'access_ptr': print_value_access_ptr(x, ctx)
  elif k == 'cast': print_value_cast(x, ctx)
  elif k == 'sizeof': o("sizeof("); print_type(x['of']); o(")")
  else: o("<%s>" % k)

  if need_wrap:
    o(")")

  # ??
  #need_cast = value_attribute_check(x, 'explicit-casted')
  #if need_cast:
  #  o(" to "); print_type(x['type'])



def print_stmt_if(x):
  o("if ")
  print_value(x['cond'])
  print_stmt_block(x['then'])

  e = x['else']
  if e != None:
    if e['kind'] == 'if':
      o(" else ")
      print_stmt_if(e)
    else:
      o(" else")
      print_stmt_block(e)



def print_stmt_while(x):
  o("while ")
  print_value(x['cond'])
  print_stmt_block(x['stmt'])


def print_stmt_return(x):
  o("return")
  if x['value'] != None:
    o(" ")
    print_value(x['value'])


def print_stmt_defvar(x):
  o('var ')
  print_field({'isa': 'field', 'id': x['id'], 'type': x['type']})
  if x['value'] != None:
    o(" := ")
    print_value(x['value'])


def print_stmt_let(x):
  o("let %s = " % x['id']['str'])
  print_value(x['value'])


def print_stmt_assign(x):
  print_value(x['left'])
  o(" := ")
  print_value(x['right'])



def print_stmt_value(x):
  print_value(x['value'])


def print_stmt(x):

  o("\n"); ind()

  k = x['kind']
  if k == 'block': print_stmt_block(x)
  elif k == 'value': print_stmt_value(x)
  elif k == 'assign': print_stmt_assign(x)
  elif k == 'return': print_stmt_return(x)
  elif k == 'if': print_stmt_if(x)
  elif k == 'while': print_stmt_while(x)
  elif k == 'def_var': print_stmt_defvar(x)
  elif k == 'def_let': print_stmt_let(x)
  elif k == 'break': o('break')
  elif k == 'again': o('continue')
  else: o("<stmt %s>" % str(x))



def print_stmt_block(s):
  o(" {")
  indent_up()
  for stmt in s['stmts']:
    print_stmt(stmt)
  indent_down()
  o("\n")
  ind()
  o("}")



def print_decl_func(x):
  if 'extern' in x['att']:
    o("extern ")
  func = x['func']
  o('func %s ' % func['id']['str'])
  print_type(func['type'])


def print_def_func(x):
  if not was_separated_by_new_line:
    o("\n")

  func = x['func']
  o('\nfunc %s ' % func['id']['str']); print_type(func['type'])
  print_stmt_block(func['stmt'])



def print_decl_type(x):
  o("type %s" % x['id']['str'])


def print_def_type(x):
  if not was_separated_by_new_line:
    if x['type']['kind'] in ['record', 'enum']:
      o("\n")

  o("type %s " % x['id']['str'])
  print_type(x['type'])#, print_aka=False)



def print_field(x):
  o("%s : " % x['id']['str'])
  print_type(x['type'])



def print_def_var(x):
  o("var ")
  f = {'isa': 'field', 'id': x['var']['id'], 'type': x['var']['type']}
  print_field(f)
  if x['init'] != None:
    o(" := "); print_value(x['init'])


def print_def_const(x):
  o("const %s = " % x['id']['str'])
  v = x['value']

  # если есть оригинальное выражение, внутри, печатаем его
  if 'value' in v:
    v = v['value']

  print_value(v, ctx=['oneline'], print_just_id=False)


def print_import(dirname, x):
  s = x['str']
  if x['local']:
    s = '"' + s + '"'
  else:
    s = '<' + s + '>'
  o("%s %s" % (dirname, s))


def run(module, outname):

  text = module['text']
  strs = module['strings']

  is_header = 'header' in features

  if is_header:
    outname = outname + '.hm'
  else:
    outname = outname + '.cm'

  output_open(outname)


  prev_ik = ('', '')

  for x in text:
    o("\n")

    isa = x['isa']
    k = x['kind']

    # prettify output with empty lines
    ik = (isa, k)
    separation = prev_ik != ik
    if separation:
      prev_ik = ik
      o("\n")
    global was_separated_by_new_line
    was_separated_by_new_line = separation


    if isa == 'definition':
      if k == 'var': print_def_var(x)
      elif k == 'const': print_def_const(x)
      elif k == 'func': print_def_func(x)
      elif k == 'type': print_def_type(x)
    elif isa == 'declaration':
      if k == 'func': print_decl_func(x)
      elif k == 'type': print_decl_type(x)
    elif isa == 'directive':
      if k == 'include': print_import('include', x)
      if k == 'import': print_import('import', x)

  o("\n\n")

  output_close()



