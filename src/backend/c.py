
from opt import *
from error import info
from .common import *
import core.type as type
from core.value import value_attribute_check


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



def print_type_numeric(t):
  if 'c_alias' in t:
    o(t['c_alias'])
    return

  o(t['name'])


def print_type_array(t):
  print_type(t['of'])
  if t['volume'] != None:
    o("["); print_value(t['volume']); o("]")
  else:
    o("*")


def print_type_pointer(t):
  print_type(t['to'])
  if t['to']['kind'] != 'array':
    o("*")


def print_type_record(t, label=""):
  o("struct ")

  if label != "":
    o("%s " % label)

  o("{")
  indent_up()
  fields = t['fields']
  i = 0
  while i < len(fields):
    field = fields[i]
    o("\n")
    ind(); print_field(field)
    o(";")
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



def print_type(t, print_aka=True):
  k = t['kind']

  # hotfix for let generic value problem (let x = 1)
  if type.is_generic_integer(t):
    sz = t['size']
    if sz == 0:
      o("int")
    else:
      o("int%d_t" % (sz * 8))
    return

  if print_aka:
    if 'c_alias' in t:
      o(t['c_alias'])
      return

    if 'name' in t:
      o(t['name'])
      return

  if type.is_numeric(t): print_type_numeric(t)
  elif type.is_record(t): print_type_record(t)
  elif type.is_enum(t): print_type_enum(t)
  elif type.is_pointer(t): print_type_pointer(t)
  elif type.is_array(t): print_type_array(t)
  elif type.is_func(t): o("void")
  elif k == 'opaque': o("void")
  else: o("<type:" + str(t) + ">")




bin_ops = {
  'or': '|', 'xor': '^', 'and': '&', 'shl': '<<', 'shr': '>>',
  'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
  'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'mod': '%',
  'logic_and': '&&', 'logic_or': '||'
}


def print_value_expr_bin(v, ctx):
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
      op = 'logic_or'
    elif op == 'and':
      op = 'logic_and'

  print_value(left, need_wrap=need_wrap_left)
  o(' %s ' % bin_ops[op])
  print_value(right, need_wrap=need_wrap_right)



un_ops = {
  'ref': '&', 'deref': '*', 'plus': '+', 'minus': '-', 'not': '~', 'logic_not': '!'
}


def print_value_expr_un(v, ctx):
  op = v['kind']
  value = v['value']

  p0 = precedence(op)
  pv = precedence(value['kind'])

  if op == 'not':
    if type.eq(value['type'], type.typeNat1):
      op = 'logic_not'

  o(un_ops[op]); print_value(value, need_wrap=pv<p0)

  # указатель на массив в сях берем как &array[0]
  # поскольку у нас указатель на массив сейчас печатается как *<item_type>
  # а &array дает нам *array[n]
  if v['kind'] == 'ref':
    if value['type']['kind'] == 'array':
      o("[0]")


def print_value_expr_call(v, ctx):
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
    o("))")
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



def print_value_expr_index(v, ctx):
  array = v['array']
  index = v['index']
  need_wrap = precedence(array['kind']) < precedence('index')
  print_value(array, need_wrap)
  o("["); print_value(index); o("]")


def print_value_expr_index_ptr(v, ctx):
  array = v['pointer']
  index = v['index']
  need_wrap = precedence(array['kind']) < precedence('index')
  print_value(array, need_wrap)
  o("["); print_value(index); o("]")



def print_value_expr_access(v, ctx):
  left = v['record']
  need_wrap = precedence(left['kind']) < precedence('access')
  print_value(left, need_wrap); o('.'); o(v['field']['id']['str'])


def print_value_expr_access_ptr(v, ctx):
  left = v['pointer']
  need_wrap = precedence(left['kind']) < precedence('access')
  print_value(left, need_wrap); o("->"); o(v['field']['id']['str'])



def print_cast(t, v, ctx=[]):
  o("("); print_type(t); o(")")
  need_wrap = precedence(v['kind']) < precedence('cast')
  print_value(v, ctx=ctx, need_wrap=need_wrap)


def print_value_expr_cast(v, ctx):
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


  # Чтобы не приводить тип в выражениях типа ((int32_t)0), etc.
  if type.is_numeric(to_type):
    if type.is_generic(from_type):
      if type.is_numeric(from_type):
        print_value(v['value'])
        return

  # не приводим тип строки к uint8_t * тк в си это куча ворнингов
  if value_attribute_check(v, 'string'):
    if type.eq(type.typeStr, to_type):
      print_value(v['value'])
      return

  print_cast(to_type, v['value'], ctx)



def print_value_array(v, ctx):
  o("{")
  i = 0
  while i < len(v['items']):
    if i > 0: o(", ")
    print_value(v['items'][i])
    i = i + 1
  o("}")


def print_value_record(v, ctx):
  multiline = not 'oneline' in ctx

  o("{")
  i = 0
  if multiline:
    o("\n")
    indent_up()
  nitems = len(v['items'])
  while i < nitems:
    item = v['items'][i]

    if multiline:
      ind()

    o(".%s=" % item['id']['str'])
    print_value(item['value'])
    if i < (nitems - 1):
      o(",")
      if not multiline:
        o(" ")
    if multiline:
      o("\n")

    i = i + 1
  if multiline:
    indent_down()
    ind()
  o("}")



def print_value_str(x, ctx):
  o("\"")
  for sym in x['str']:
    if sym == '\n': o("\\n")
    elif sym == '\r': o("\\r")
    elif sym == '\a': o("\\a")
    else: o(sym)
  o("\"")


def print_value_expr_num(x, ctx):
  if value_attribute_check(x, 'hexadecimal'):
    o("0x%X" % x['num'])
  elif type.is_pointer(x['type']):
    if x['num'] == 0:
      o("NULL")
      return
  else:
    o(str(x['num']))


def print_value_expr_enum(x, ctx):
  o("%s" % (x['id']['str']))


def print_value_by_id(x, ctx):
  o("%s" % x['id']['str'])


def print_value(x, ctx=[], need_wrap=False, print_just_id=True):
  # если у значения есть свойство 'id' то печатаем просто id
  # (используется для печати имени констант а не просто их значения)
  # в LLVM перчаем просто значение

  need_cast = value_attribute_check(x, 'generic-casted')
  if need_cast:
    o("(("); print_type(x['type']); o(")")

  if print_just_id:
    if 'id' in x:
      print_value_by_id(x, ctx)
      if need_cast:
        o(")")
      return

  if need_wrap:
    o("(")

  k = x['kind']

  if k in bin_ops: print_value_expr_bin(x, ctx)
  elif k in un_ops: print_value_expr_un(x, ctx)
  elif k == 'num': print_value_expr_num(x, ctx)
  elif k in ['func', 'var']: print_value_by_id(x, ctx)
  elif k == 'str': print_value_str(x, ctx)
  elif k == 'record': print_value_record(x, ctx)
  elif k == 'array': print_value_array(x, ctx)
  elif k == 'enum': print_value_expr_enum(x, ctx)
  else:
    if k == 'call': print_value_expr_call(x, ctx)
    elif k == 'index': print_value_expr_index(x, ctx)
    elif k == 'index_ptr': print_value_expr_index_ptr(x, ctx)
    elif k == 'access': print_value_expr_access(x, ctx)
    elif k == 'access_ptr': print_value_expr_access_ptr(x, ctx)
    elif k == 'cast': print_value_expr_cast(x, ctx)
    elif k == 'sizeof': o("sizeof("); print_type(x['of']); o(")")
    else: o("<%s>" % k)

  if need_wrap:
    o(")")

  if need_cast:
    o(")")





def print_stmt_if(x):
  o("if("); print_value(x['cond']); o(") ")
  print_stmt_block(x['then'])

  e = x['else']
  if e != None:
    if e['kind'] == 'if':
      o(" else ")
      print_stmt_if(e)
    else:
      o(" else ")
      print_stmt_block(e)



def print_stmt_while(x):
  o("while("); print_value(x['cond']); o(") ")
  print_stmt_block(x['stmt'])


def print_stmt_return(x):
  o("return")
  if x['value'] != None:
    o(" ")
    print_value(x['value'])
  o(";")


def print_stmt_defvar(x):
  print_field({'isa': 'field', 'id': x['id'], 'type': x['type']})
  if x['value'] != None:
    o(" = ")
    print_value(x['value'])
  o(";")


def print_stmt_let(x):
  f = {'isa': 'field', 'id': x['id'], 'type': x['value']['type']}
  print_field(f, const=True); o(" = "); print_value(x['value']); o(";")


def print_stmt_assign(x):
  # в си нельзя просто так присвоить массив
  if type.is_array(x['right']['type']):
    o("// array assignation")
    for i in range(x['right']['type']['size']):
      o("\n")
      ind()
      print_value(x['left']);
      o("[%s] = " % i)
      print_value(x['right']);
      o("[%s];" % i)
      i = i + 1
    return

  # в си нельзя просто так присвоить запись
  if type.is_record(x['right']['type']):
    o("// record assignation")
    for f in x['right']['type']['fields']:
      o("\n")
      ind()
      print_value(x['left']);
      o(".%s = " % f['id']['str'])
      print_value(x['right']);
      o(".%s;" % f['id']['str'])
    return

  print_value(x['left'])
  o(" = ")
  # В си можно просто присвоить литерал структуры глоб переменной
  # но вот локальной - нельзя, нужно явно привести его е треб типу
  if (type.is_record(x['right']['type'])):
    print_cast(x['right']['type'], x['right'])
  else:
    print_value(x['right'])

  o(";")


def print_stmt_value(x):
  print_value(x['value']); o(";")


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
  elif k == 'break': o('break;')
  elif k == 'again': o('continue;')
  else: o("<stmt %s>" % str(x))


# not works
def print_arrays(arrays):
  for array in arrays:
    o("\n"); ind()
    array['value'] = None
    print_stmt_defvar(array)
    o("\n"); ind()
    dst = array['id']['str']
    src = array['id']['str']
    len = type.get_size(array['type'])
    o("memcpy(%s, _%s, %d);" % (dst, src, len))



def print_stmt_block(s, arrays=None):
  o("{")
  indent_up()
  if arrays != None:
    print_arrays(arrays)
  for stmt in s['stmts']:
    print_stmt(stmt)
  indent_down()
  o("\n")
  ind()
  o("}")


def print_func_signature(id, typ):
  params = typ['params']
  to = typ['to']
  t = to

  # возвращает список аргументов с типом массив (!)
  # для того чтобы print_stmt мог их пропечатать как локаоьные
  # и скопировать
  arrays = []

  # возврат является масссивом?
  #is_array = t['kind'] == 'array'
  #array_dims = None
  #if is_array:
    #array_dims = t['size']
    #t = t['of']

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

    field_prefix = ""
    if type.is_array(param['type']):
      arrays.append(param)
      field_prefix = "_"

    print_field(param, prefix=field_prefix)
    i = i + 1
    if i < len(params):
      o(", ")


  if 'arghack' in typ:
    if typ['arghack']:
      o(", ...")

  o(")")

  return arrays



def print_decl_func(x):
  if 'extern' in x['att']:
    o("extern ")
  func = x['func']
  if 'c_prefix' in func:
    o("%s " % func['c_prefix'])
  print_func_signature(func['id']['str'], func['type'])
  o(";")


def print_def_func(x):
  if not was_separated_by_new_line:
    o("\n")

  func = x['func']
  if 'comment' in func:
    if func['comment'] != '':
      o("// %s\n" % func['comment'])

  if 'c_prefix' in func:
    o("%s " % func['c_prefix'])

  arrays = print_func_signature(func['id']['str'], func['type'])
  o("\n")
  print_stmt_block(func['stmt'], arrays=arrays)



def print_decl_type(x):
  name = x['id']['str']
  #o("// type declaration %s\n" % name)
  o("struct %s;\n" % name)
  o("typedef struct %s %s;\n" % (name, name))


def print_def_type(x):
  if not was_separated_by_new_line:
    if x['type']['kind'] in ['record', 'enum']:
      o("\n")

  # !
  if x['afterdef']:
    #print('afterdef')
    if type.is_record(x['type']):
      print_type_record(x['type'], label=x['id']['str'])
      o(";\n")
      return;


  defined_array = type.is_defined_array(x['type'])
  o("typedef ")
  if defined_array:
    print_type(x['type']['of'])#, print_aka=False)
  else:
    print_type(x['type'])#, print_aka=False)
  o(" %s" % x['id']['str'])
  if defined_array:
    o("["); print_value(x['type']['volume']); o("]")
  o(";")
  if x['type']['kind'] in ['record', 'enum']:
    o("\n")



# из за того что с C типы записваются через жопу
# приходится печатать типы ptr, arr & func вместе с именем поля
def print_field(x, const=False, prefix=None):
  t = x['type']

  if 'aka' in x:
    print_type(t)
    o(" ")
    if prefix != None:
      o(prefix)
    o("%s" % (x['id']['str']))
    return

  # поле является масссивом?
  is_array = t['kind'] == 'array'
  array_dims = None
  if is_array:
    array_dims = []
    array_dims.append(t['volume'])
    t = t['of']
    while t['kind'] == 'array':
      array_dims.append(t['volume'])
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

  if ptr_level == 0 and const:
    o("const ")
  print_type(t)
  o(" ")
  o("*" * ptr_level)
  if ptr_level > 0 and const:
    o(" const ")

  if prefix != None:
    o(prefix)
  o("%s" % (x['id']['str']))
  if is_array:
    if array_dims != None:
      for dim in array_dims:
        o("["); print_value(dim); o("]")



def print_def_var(x):
  if 'c_prefix' in x['var']:
      o("%s " % x['var']['c_prefix'])
  print_field(x['var'])
  if x['init'] != None:
    o(" = "); print_value(x['init'])
  o(";")


def print_def_const(x):
  o("#define %s  " % x['id']['str'])
  need_wrap = precedence(x['value']['kind']) < precedenceMax
  print_value(x['value'], ctx=['oneline'], need_wrap=need_wrap, print_just_id=False)


def print_include(x):
  s = x['str']
  if x['local']:
    s = '"' + s + '"'
  else:
    s = '<' + s + '>'
  o("#include %s" % s)




def run(module, outname):

  text = module['text']
  strs = module['strings']

  is_header = 'header' in features

  if is_header:
    outname = outname + '.h'
  else:
    outname = outname + '.c'

  printer_open(outname)

  guardname = ''
  if is_header:
    guardname = outname.split("/")[-1]
    guardname = guardname[:-2].upper() + '_H'
    lo("#ifndef %s" % guardname)
    lo("#define %s\n" % guardname)

  lo("#include <stdint.h>")
  lo("#include <string.h>")  # for memcpy

  prev_ik = ('', '')

  for x in text:
    if 'c-no-print' in x['att']:
      continue

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

    if 'comment' in x:
      if x['comment'] != '':
        o("// " + x['comment'])

    if isa == 'definition':
      if k == 'var': print_def_var(x)
      elif k == 'const': print_def_const(x)
      elif k == 'func': print_def_func(x)
      elif k == 'type': print_def_type(x)
    elif isa == 'declaration':
      if k == 'func': print_decl_func(x)
      elif k == 'type': print_decl_type(x)
    elif isa == 'directive':
      if k == 'include': print_include(x)

  o("\n")
  if is_header:
    lo("#endif  /* %s */" % guardname)
  o("\n")

  printer_close()



