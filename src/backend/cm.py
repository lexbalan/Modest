
IMPORT_OBJECTS = False


from opt import *
import core.type as type
from error import info
from .common import *
from core.type import type_attribute_check
from core.value import value_attribute_check
from core.hlir import hlir_value_num_get


INDENT_SYMBOL = " " * 4

# если сущность была уже отделена новой строкой
# (typedef struct & def func должны всегда отделяться пустой строкой)
was_separated_by_new_line = True


def init():
  pass


def indent():
  ind(INDENT_SYMBOL)


aprecedence = [
  ['or'], #0
  ['xor'], #1
  ['and'], #2
  ['eq', 'ne'], #3
  ['lt', 'le', 'gt', 'ge'], #4
  ['shl', 'shr'], #5
  ['add', 'sub'], #6
  ['mul', 'div', 'rem'], #7
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



def print_comment(x):
  k = x['kind']
  if k == 'line':
    print_comment_line(x)
  elif k == 'block':
    print_comment_block(x)
  else:
    pass


def print_comment_block(x):
  out("/*%s*/" % x['text'])


def print_comment_line(x):
  lines = x['lines']
  n = len(lines)
  i = 0
  while i < n:
    line = lines[i]
    indent(); out("//%s" % line['str'])
    i = i + 1
    if i < n:
      out("\n")




def print_type_integer(t):
  if 'id' in t:
    out(t['id']['str'])
    return

  out(t['name'])


def print_type_array(t):
  out("[")
  if t['volume'] != None:
    print_value(t['volume'])
  out("]")
  print_type(t['of'])


def print_type_pointer(t):
  if type.is_free_pointer(t):
    out("Pointer")
    return
  out("*"); print_type(t['to'])




def print_field(x):
  out("%s : " % x['id']['str'])
  print_type(x['type'])


def print_fields(fields, before, after, separator):
  i = 0
  n = len(fields)
  while i < n:
    param = fields[i]
    out(before); print_field(param); out(after)
    i = i + 1
    if i < n: out(separator)


def print_type_record(t):
  out("record {")
  indent_up()

  for field in t['fields']:
    # print comments
    if 'comments' in field:
      for comment in field['comments']:
        out("\n" * comment['nl'])
        print_comment(comment)

    out("\n" * field['nl'])
    indent();
    print_field(field)

  indent_down()
  out("\n"); indent(); out("}")



def print_type_enum(t):
  out("enum {")
  items = t['items']
  i = 0
  while i < len(items):
    item = items[i]
    out("\n")
    #o("\t%s_%s," % (t['aka'], item['id']['str']))
    out("\t%s," % (item['id']['str']))
    i = i + 1
  out("\n}")





def print_type_func(t):
  out('(')
  print_fields(t['params'], before="",  after="", separator=", ")
  out(') -> ')
  print_type(t['to'])



def print_type(t, print_aka=True):
  k = t['kind']

  if print_aka:
    """if 'id' in t:
      out(t['id']['str'])
      return"""

    if 'name' in t:
      out(t['name'])
      return

  if type.is_integer(t): print_type_integer(t)
  elif type.is_func(t): print_type_func(t)
  elif type.is_array(t): print_type_array(t)
  elif type.is_record(t): print_type_record(t)
  elif type.is_enum(t): print_type_enum(t)
  elif type.is_pointer(t): print_type_pointer(t)
  elif k == 'opaque': pass
  else: out("<type:" + str(t) + ">")



bin_ops = {
  'or': 'or', 'xor': 'xor', 'and': 'and', 'shl': '<<', 'shr': '>>',
  'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
  'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'rem': '%',
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

  print_value(left, need_wrap=need_wrap_left)
  out(' %s ' % bin_ops[op])
  print_value(right, need_wrap=need_wrap_right)



un_ops = {
  'ref': '&', 'deref': '*', 'plus': '+', 'minus': '-', 'not': 'not'
}


def print_value_un(v, ctx):
  op = v['kind']
  value = v['value']
  p0 = precedence(op)
  pv = precedence(value['kind'])
  out(un_ops[op]); print_value(value, need_wrap=pv<p0)


def print_values(values, before, after, separator):
  i = 0
  n = len(values)
  while i < n:
    a = values[i]
    out(before)
    print_value(a)
    out(after)
    i = i + 1
    if i < n:
      out(separator)


def print_value_call(v, ctx):
  print_value(v['func'])
  out("(")
  print_values(v['args'], before="", after="", separator=", ")
  out(")")


def print_value_index(v, ctx):
  array = v['array']
  index = v['index']
  need_wrap = precedence(array['kind']) < precedence('index')
  print_value(array, need_wrap=need_wrap)
  out("["); print_value(index); out("]")


def print_value_index_ptr(v, ctx):
  array = v['pointer']
  index = v['index']
  need_wrap = precedence(array['kind']) < precedence('index')
  print_value(array, need_wrap=need_wrap)
  out("["); print_value(index); out("]")


def print_value_access(v, ctx):
  left = v['record']
  need_wrap = precedence(left['kind']) < precedence('access')
  print_value(left, need_wrap=need_wrap); out("."); out(v['field']['id']['str'])


def print_value_access_ptr(v, ctx):
  left = v['pointer']
  need_wrap = precedence(left['kind']) < precedence('access')
  print_value(left, need_wrap=need_wrap); out("."); out(v['field']['id']['str'])


def print_cast(t, v, ctx=[]):
  print_value(v, ctx=ctx)
  out(' to ')
  print_type(t)


def print_value_cast(v, ctx):


  # не печатаем операции неявного приведения (!)
  if value_attribute_check(v, 'implicit-casted'):
    print_value(v['value'])
    return

  from_type = v['value']['type']
  to_type = v['type']
  # NO need cast ptr to *void
  if type.is_pointer(from_type):
    if type.is_free_pointer(to_type):
      print_value(v['value'])
      return

  # NO need cast *void to ptr
  if type.is_free_pointer(from_type):
    if type.is_pointer(to_type):
      print_value(v['value'])
      return

  print_cast(v['type'], v['value'], ctx)



def print_value_imm_array(v, ctx):
  out("[")
  indent_up()
  print_values(v['imm_items'], before=nl_indentation(INDENT_SYMBOL), after="", separator="")
  indent_down()
  out("\n"); indent(); out("]")


def print_value_imm_record(v, ctx):
  multiline = not 'oneline' in ctx

  out("{")
  i = 0
  if multiline:
    out("\n")
    indent_up()
  nitems = len(v['imm_items'])
  #while i < nitems:
  for k in v['imm_items']:
    item = v['imm_items'][k]

    if multiline: indent()

    out("%s = " % k)
    print_value(item, ctx)
    if i < (nitems - 1):
      #o(",")
      if not multiline: out(" ")
    if multiline: out("\n")

    i = i + 1
  if multiline:
    indent_down()
    indent()
  out("}")



def print_value_imm_str(x, ctx):
  out("\"")
  for sym in x['str']:
    if sym == '\n': out("\\n")
    elif sym == '\r': out("\\r")
    elif sym == '\a': out("\\a")
    else: out(sym)
  out("\"")


def print_value_imm_num(x, ctx):
  if value_attribute_check(x, 'hexadecimal'):
    out("0x%X" % hlir_value_num_get(x))
  elif type.is_pointer(x['type']):
    if hlir_value_num_get(x) == 0:
      out("nil")
      return
  else:
    out(str(hlir_value_num_get(x)))


def print_value_zero(x, ctx):
  t = x['type']
  if type.is_array(t): out("[]")
  elif type.is_record(t): out("{}")
  else: out("0")


def print_value_enum(x, ctx):
  out("%s" % (x['id']['str']))


def print_value_by_id(x, ctx):
  out("%s" % x['id']['str'])


def print_value_imm(x, ctx):
  t = x['type']
  if type.is_integer(t): print_value_imm_num(x, ctx)
  elif type.is_float(t): print_value_imm_num(x, ctx)
  elif type.is_record(t): print_value_imm_record(x, ctx)
  elif type.is_array(t): print_value_imm_array(x, ctx)
  elif type.is_string(t): print_value_imm_str(x, ctx)
  elif type.is_free_pointer(t): out("nil")
  elif type.is_pointer(t): print_value_imm_num(x, ctx)


def print_value(x, ctx=[], need_wrap=False, print_just_id=True):
  # если у значения есть свойство 'id' то печатаем просто id
  # (используется для печати имени констант а не просто их значения)
  # в LLVM перчаем просто значение

  if print_just_id:
    if 'id' in x:
      print_value_by_id(x, ctx)
      return

  if need_wrap:
    out("(")

  k = x['kind']

  if k == 'literal': print_value_imm(x, ctx)
  elif k in bin_ops: print_value_bin(x, ctx)
  elif k in un_ops: print_value_un(x, ctx)
  elif k in ['func', 'var']: print_value_by_id(x, ctx)
  elif k == 'call': print_value_call(x, ctx)
  elif k == 'index': print_value_index(x, ctx)
  elif k == 'index_ptr': print_value_index_ptr(x, ctx)
  elif k == 'access': print_value_access(x, ctx)
  elif k == 'access_ptr': print_value_access_ptr(x, ctx)
  elif k == 'cast': print_value_cast(x, ctx)
  elif k == 'sizeof': out("sizeof("); print_type(x['of']); out(")")
  else: out("<%s>" % k)

  if need_wrap:
    out(")")



def print_stmt_if(x):
  out("if ")
  print_value(x['cond'])
  print_stmt_block(x['then'])

  e = x['else']
  if e != None:
    if e['kind'] == 'if':
      out(" else ")
      print_stmt_if(e)
    else:
      out(" else")
      print_stmt_block(e)



def print_stmt_while(x):
  out("while ")
  print_value(x['cond'])
  print_stmt_block(x['stmt'])


def print_stmt_return(x):
  out("return")
  if x['value'] != None:
    out(" ")
    print_value(x['value'])


def print_stmt_defvar(x):
  out('var ')
  print_field({'isa': 'field', 'id': x['id'], 'type': x['type']})
  if x['value'] != None:
    out(" := ")
    print_value(x['value'])


def print_stmt_let(x):
  out("let %s = " % x['id']['str'])
  print_value(x['value'])


def print_stmt_assign(x):
  print_value(x['left'])
  out(" := ")
  print_value(x['right'])



def print_stmt_value(x):
  print_value(x['value'])


def print_stmt(x):

  out("\n" * x['nl'])

  k = x['kind']
  if k == 'block': indent(); print_stmt_block(x)
  elif k == 'value': indent(); print_stmt_value(x)
  elif k == 'assign': indent(); print_stmt_assign(x)
  elif k == 'return': indent(); print_stmt_return(x)
  elif k == 'if': indent(); print_stmt_if(x)
  elif k == 'while': indent(); print_stmt_while(x)
  elif k == 'def_var': indent(); print_stmt_defvar(x)
  elif k == 'def_let': indent(); print_stmt_let(x)
  elif k == 'break': indent(); out('break')
  elif k == 'again': indent(); out('continue')
  elif k == 'comment-line': print_comment_line(x)
  elif k == 'comment-block': print_comment_block(x)
  else: out("<stmt %s>" % str(x))



def print_stmt_block(s):
  out(" {")
  indent_up()
  for stmt in s['stmts']:
    print_stmt(stmt)
  indent_down()
  out("\n")
  indent()
  out("}")



def print_decl_func(x):
  if 'extern' in x['att']:
    out("extern ")
  func = x['func']
  out('func %s ' % func['id']['str'])
  print_type(func['type'])


def print_def_func(x):
  #if not was_separated_by_new_line:
  #  out("\n")

  func = x['func']
  out('func %s ' % func['id']['str']); print_type(func['type'])
  print_stmt_block(func['stmt'])



def print_decl_type(x):
  out("type %s" % x['id']['str'])


def print_def_type(x):
  #if not was_separated_by_new_line:
  #  if x['type']['kind'] in ['record', 'enum']:
  #    out("\n")

  out("type %s " % x['id']['str'])
  print_type(x['type'])#, print_aka=False)





def print_def_var(x):
  out("var ")
  f = {'isa': 'field', 'id': x['var']['id'], 'type': x['var']['type']}
  print_field(f)
  if x['init'] != None:
    out(" := "); print_value(x['init'])


def print_def_const(x):
  out("const %s = " % x['id']['str'])
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
  out("%s %s" % (dirname, s))



def run(module, outname):
  is_header = 'header' in features

  if is_header: outname = outname + '.hm'
  else: outname = outname + '.cm'

  output_open(outname)


  for x in module['text']:

    if 'nl' in x:
      out("\n" * x['nl'])

    isa = x['isa']
    k = x['kind']

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
    elif isa == 'comment':
      print_comment(x)

  out("\n\n")

  output_close()



