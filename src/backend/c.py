
IMPORT_OBJECTS = False

from opt import *
from error import info
from .common import *
import core.type as type
from core.value import value_attribute_check
from core.hlir import hlir_value_num_get


puffy = False

INDENT_SYMBOL = " " * 4

VOID_PARAM_FUNCTIONS = True
SPACE_AFTER_IF_WHILE = True

ARRAYS_MULTILINE_ALWAYS = False
ARRAYS_MULTILINE_FROM = 8

RECORDS_MULTILINE_ALWAYS = False
RECORDS_MULTILINE_FROM = 4

PRINT_STRUCT_PREFIX_FOR_RECORDS = False


legacy_style = {
  'LINE_BREAK_BEFORE_STRUCT_BRACE': False,
  'LINE_BREAK_BEFORE_FUNC_BRACE': True,
  'LINE_BREAK_BEFORE_BLOCK_BRACE': False,
  'EXTRA_BLANK_LINES_BETWEEN_FUNCS': 0,
}

modern_style = {
  'LINE_BREAK_BEFORE_STRUCT_BRACE': True,
  'LINE_BREAK_BEFORE_FUNC_BRACE': True,
  'LINE_BREAK_BEFORE_BLOCK_BRACE': True,
  'EXTRA_BLANK_LINES_BETWEEN_FUNCS': 1,
}

styles = {
  'legacy': legacy_style,
  'KnR': legacy_style,
  'kernel': legacy_style,

  'modern': modern_style,
  'allman': modern_style,
}

styleguide = styles['legacy']


def indent():
  ind(INDENT_SYMBOL)


def init():
  global puffy
  puffy = features_get("puffy")
  global styleguide
  stylename = settings_get('style')
  if stylename != None:
    if stylename in styles:
      styleguide = styles[stylename]


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
  ['plus', 'minus', 'not', 'cast', 'to', 'ref', 'deref', 'sizeof'], #8
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
    out(t['c_alias'])
    return

  out(t['name'])


def print_type_array(t):
  print_type(t['of'])
  if t['volume'] != None:
    out("["); print_value(t['volume']); out("]")
  else:
    out("*")


def print_type_pointer(t):
  if type.is_free_pointer(t):
    out("void*")
    return

  print_type(t['to'])
  if t['to']['kind'] != 'array':
    out("*")




def print_fields(fields, before, after, between):
  i = 0
  n = len(fields)
  while i < n:
    param = fields[i]
    out(before); print_field(param); out(after)
    i = i + 1
    if i < n: out(between)



def print_type_record(t, tag=""):
  out("struct")

  if tag != "":
    out(" %s" % tag)

  if styleguide['LINE_BREAK_BEFORE_STRUCT_BRACE']:
    out("\n")
  else:
    out(" ")

  out("{")
  indent_up()

  print_fields(t['fields'], before=nl_indentation(INDENT_SYMBOL), after=";", between="")

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



def print_type(t, print_aka=True):
  k = t['kind']

  # hotfix for let generic value problem (let x = 1)
  if type.is_generic_integer(t):
    sz = t['size']
    if sz == 0:
      out("int")
    else:
      out("int%d_t" % (sz * 8))
    return

  if print_aka:

    if 'c_alias' in t:
      out(t['c_alias'])
      return

    if 'name' in t:
      if PRINT_STRUCT_PREFIX_FOR_RECORDS:
        if type.is_record(t):
          out("struct ")
      out(t['name'])
      return

  if type.is_numeric(t): print_type_numeric(t)
  elif type.is_record(t): print_type_record(t)
  elif type.is_enum(t): print_type_enum(t)
  elif type.is_pointer(t): print_type_pointer(t)
  elif type.is_array(t): print_type_array(t)
  elif type.is_func(t): out("void")
  elif k == 'opaque': out("void")
  else: out("<type:" + str(t) + ">")




bin_ops = {
  'or': '|', 'xor': '^', 'and': '&', 'shl': '<<', 'shr': '>>',
  'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
  'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'mod': '%',
  'logic_and': '&&', 'logic_or': '||'
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
      op = 'logic_or'
    elif op == 'and':
      op = 'logic_and'

  print_value(left, need_wrap=need_wrap_left)
  out(' %s ' % bin_ops[op])
  print_value(right, need_wrap=need_wrap_right)



un_ops = {
  'ref': '&', 'deref': '*', 'plus': '+', 'minus': '-', 'not': '~', 'logic_not': '!'
}


def print_value_un(v, ctx):
  op = v['kind']
  value = v['value']

  p0 = precedence(op)
  pv = precedence(value['kind'])

  if op == 'not':
    if type.eq(value['type'], type.typeNat1):
      op = 'logic_not'

  out(un_ops[op]); print_value(value, need_wrap=pv<p0)

  # указатель на массив в сях берем как &array[0]
  # поскольку у нас указатель на массив сейчас печатается как *<item_type>
  # а &array дает нам *array[n]
  if v['kind'] == 'ref':
    if value['type']['kind'] == 'array':
      out("[0]")




def print_paramlist(parms, arghack=False):
  out("(")

  if len(parms) == 0:
    if VOID_PARAM_FUNCTIONS:
      out("void")
  else:
    print_fields(parms, before="",  after="", between=", ")
    if arghack:
      out(", ...")

  out(")")


def print_values(values, before, between, after, ctx=[]):
  i = 0
  n = len(values)
  while i < n:
    a = values[i]
    out(before)
    print_value(a, ctx=ctx)
    i = i + 1
    if i < n:
      out(between)
    out(after)


def print_value_call(v, ctx):
  left = v['func']
  if type.is_pointer(left['type']):
    t = left['type']['to']
    # вызов через указатель
    # поскольку у нас указатели на функции это *void
    # при вызове приводим левое к указателю на функцию
    out("(("); print_type(t['to']); out("(*)")
    arghack = 'arghack' in t['att']
    print_paramlist(t['params'], arghack)
    out(")")
    print_value(left)
    out(")")

  else:
    print_value(left)

  out("(")
  print_values(v['args'], before="", between=", ", after="", ctx=[])
  out(")")



def print_value_index(v, ctx):
  array = v['array']
  index = v['index']
  need_wrap = precedence(array['kind']) < precedence('index')
  print_value(array, need_wrap=need_wrap)
  out("["); print_value(index); out("]")


def print_value_index_ptr(v, ctx):
  ptr2array = v['pointer']
  index = v['index']
  need_wrap = precedence(ptr2array['kind']) < precedence('index')
  print_value(ptr2array, need_wrap=need_wrap)
  out("["); print_value(index); out("]")


def print_value_access(v, ctx):
  left = v['record']
  need_wrap = precedence(left['kind']) < precedence('access')
  print_value(left, need_wrap=need_wrap); out('.'); out(v['field']['id']['str'])


def print_value_access_ptr(v, ctx):
  left = v['pointer']
  need_wrap = precedence(left['kind']) < precedence('access')
  print_value(left, need_wrap=need_wrap); out("->"); out(v['field']['id']['str'])



def huhu(v_id, fields):
  out("{")
  i = 0
  for field in fields:
    if (i > 0): out(", ")
    fid = field['id']['str']
    out(".%s = " % fid)

    if type.is_record(field['type']):
      huhu(v_id + '.' + field['id']['str'], field['type']['fields'])
    else:
      out("%s.%s" % (v_id, fid)) #; print_value(item, ctx)

    i = i + 1
  out("}")


def print_cast_gen_rec_to_rec(t, v, ctx=[]):
  #print("FROM GENERIC RECORD")
  v_id = v['id']['str']
  fields = v['type']['fields']
  out("("); print_type(t); out(")")
  huhu(v_id, fields)


def print_cast(t, v, ctx=[]):
  # в C мы не можем привести одну структуру к другой
  # поэтому вынуждены будем построить новую структуру
  # на основе другой (пусть и с таким же внутренним устройством)
  if type.is_generic_record(v['type']):
    return print_cast_gen_rec_to_rec(t, v, ctx=ctx)

  out("("); print_type(t); out(")")
  need_wrap = precedence(v['kind']) < precedence('cast')
  print_value(v, ctx=ctx, need_wrap=need_wrap)


def print_value_cast(v, ctx):
  from_type = v['value']['type']
  to_type = v['type']

  """
  # NO need cast ptr to *void
  if type.is_pointer(from_type):
    if type.is_free_pointer(to_type):
      print_value(v['value'], ctx)
      return

  # NO need cast *void to ptr
  if type.is_free_pointer(from_type):
    if type.is_pointer(to_type):
      print_value(v['value'], ctx)
      return
  """


  # Чтобы не приводить тип в выражениях типа ((int32_t)0), etc.
  if type.is_numeric(to_type):
    if type.is_generic(from_type):
      if type.is_numeric(from_type):
        print_value(v['value'], ctx)
        return

  # не печатаем приведение литерала строки "string" к Str
  if type.eq(type.typeStr, to_type):
    if value_attribute_check(v['value'], 'string'):
      print_value(v['value'], ctx)
      return

  print_cast(to_type, v['value'], ctx)



def print_value_imm_array(v, ctx):
  screening = 'screening' in ctx

  if ARRAYS_MULTILINE_ALWAYS:
    multiline = True
  else:
    multiline = hlir_value_num_get(v['type']['volume']) > ARRAYS_MULTILINE_FROM


  out("{")
  indent_up()

  if multiline and screening: out("\\")

  before = ""
  after = ""
  between = ", "
  if multiline:
    before = nl_indentation(INDENT_SYMBOL)
    between = ","
    if screening:
      after = "\\"

  print_values(v['items'], before=before, between=between, after=after, ctx=ctx)

  indent_down()

  if multiline:
    out("\n")
    indent()

  out("}")


def print_value_imm_record(v, ctx):
  screening = 'screening' in ctx

  if RECORDS_MULTILINE_ALWAYS:
    multiline = True
  else:
    multiline = len(v['type']['fields']) > RECORDS_MULTILINE_FROM

  out("{")
  i = 0
  if multiline:
    if screening:
      out("\\")
    out("\n")
    indent_up()

  nitems = len(v['items'])
  while i < nitems:
    item = v['type']['fields'][i]

    if multiline:
      indent()

    field_str = item['id']['str']
    out(".%s = " % field_str)
    print_value(v['items'][field_str], ctx)
    if i < (nitems - 1):
      out(",")
      if not multiline:
        out(" ")
    if multiline:
      if screening:
        out("\\")
      out("\n")

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


def print_value_imm_int(x, ctx):
  n = hlir_value_num_get(x)
  if value_attribute_check(x, 'hexadecimal'):
    out("0x%X" % n)
  else:
    out(str(n))

  #if type.is_numeric(x['type']):
  if 'explicit-casted' in x['att']:
    if 'unsigned' in x['type']['att']:
      out("U")

  if x['type']['size'] > 4:
    sz = x['type']['size']
    if sz == 8:
      out("LL")


def print_value_imm_flt(x, ctx):
  out(str(hlir_value_num_get(x)))


def print_value_imm_num(x, ctx):
  if value_attribute_check(x, 'hexadecimal'):
    out("0x%X" % hlir_value_num_get(x))
  elif type.is_pointer(x['type']):
    out("<print_value_imm_num::PTR>")
    fatal("print_value_imm_num: type.is_pointer")
  #  if hlir_value_num_get(x) == 0:
  #    out("NULL")
  #    return
  else:
    out(str(hlir_value_num_get(x)))



def print_value_imm_ptr(x, ctx):
  if type.is_free_pointer(x['type']):
    out("NULL")
  else:
    if hlir_value_num_get(x) == 0:
      out("NULL")
    else:
      out("0x%X" % hlir_value_num_get(x))


def print_value_imm(x, ctx):
  t = x['type']
  if type.is_integer(t): print_value_imm_int(x, ctx)
  elif type.is_float(t): print_value_imm_num(x, ctx)
  elif type.is_record(t): print_value_imm_record(x, ctx)
  elif type.is_array(t): print_value_imm_array(x, ctx)
  elif type.is_string(t): print_value_imm_str(x, ctx)
  elif type.is_pointer(t): print_value_imm_ptr(x, ctx)



def print_value_by_id(x, ctx):
  out("%s" % x['id']['str'])



def print_value(x, ctx=[], need_wrap=False, print_just_id=True):
  # если у значения есть свойство 'id' то печатаем просто id
  # (используется для печати имени констант а не просто их значения)
  # в LLVM перчаем просто значение

  need_cast = value_attribute_check(x, 'generic-casted')
  if need_cast:
    out("(("); print_type(x['type']); out(")")

  if print_just_id:
    if 'id' in x:
      print_value_by_id(x, ctx)
      if need_cast:
        out(")")

      return

  if need_wrap:
    out("(")


  k = x['kind']

  if k == 'literal': print_value_imm(x, ctx)
  elif k in bin_ops: print_value_bin(x, ctx)
  elif k in un_ops: print_value_un(x, ctx)
  elif k in ['func', 'var', 'const']: print_value_by_id(x, ctx)
  elif k == 'call': print_value_call(x, ctx)
  elif k == 'index': print_value_index(x, ctx)
  elif k == 'index_ptr': print_value_index_ptr(x, ctx)
  elif k == 'access': print_value_access(x, ctx)
  elif k == 'access_ptr': print_value_access_ptr(x, ctx)
  elif k == 'cast': print_value_cast(x, ctx)
  elif k == 'sizeof': out("sizeof("); print_type(x['of']); out(")")
  else:
    out("<%s>" % k)
    print(x)
    exit(1)

  if need_wrap:
    out(")")

  if need_cast:
    out(")")



def print_stmt_if(x):
  out("if")
  if SPACE_AFTER_IF_WHILE: out(" ")
  out("("); print_value(x['cond']); out(")")

  if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
    out("\n")
    indent()
  else:
    out(" ")

  print_stmt_block(x['then'])

  e = x['else']
  if e != None:
    if e['kind'] == 'if':
      out(" else ")
      print_stmt_if(e)
    else:
      out(" else ")
      print_stmt_block(e)



def print_stmt_while(x):
  out("while")
  if SPACE_AFTER_IF_WHILE: out(" ")
  out("("); print_value(x['cond']); out(")")

  if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
    out("\n")
    indent()
  else:
    out(" ")

  print_stmt_block(x['stmt'])


def print_stmt_return(x):
  out("return")
  if x['value'] != None:
    out(" ")
    print_value(x['value'])
  out(";")


def print_stmt_defvar(x):
  print_field({'isa': 'field', 'id': x['id'], 'type': x['type']})
  if x['value'] != None:
    out(" = ")
    print_value(x['value'])
  out(";")


def print_stmt_let(x):
  f = {'isa': 'field', 'id': x['id'], 'type': x['value']['type']}
  print_field(f, const=True); out(" = "); print_value(x['value']); out(";")



def assign_array_by_items(x):
  out("// array assignation")
  for i in range(x['right']['type']['size']):
    out("\n")
    indent()
    print_value(x['left']);
    out("[%s] = " % i)
    print_value(x['right']);
    out("[%s];" % i)
    i = i + 1


def assign_record_by_fields(x):
  # в си нельзя просто так присвоить запись
  #print("assign_record_by_fields " + x['right']['kind'])
  out("// record assignation")
  for f in x['right']['type']['fields']:
    out("\n")
    indent()
    print_value(x['left']);
    out(".%s = " % f['id']['str'])
    print_value(x['right']);
    out(".%s;" % f['id']['str'])


def print_stmt_assign(x):
  # в си нельзя просто так присвоить массив // или структуру
  if x['right']['kind'] == 'var':
    if type.is_array(x['right']['type']):
      assign_array_by_items(x)
      return

#  if x['right']['kind'] == 'var':
#    if type.is_record(x['right']['type']):
#      assign_record_by_fields(x)
#      return

  print_value(x['left'])
  out(" = ")
  # В си можно просто присвоить литерал структуры глоб переменной
  # но вот локальной - нельзя, нужно явно привести его е треб типу
#  if (type.is_record(x['right']['type'])):
#    print_cast(x['right']['type'], x['right'])
#  else:
  print_value(x['right'])

  out(";")


def print_stmt_value(x):
  print_value(x['value']); out(";")



k_prev = ""
def print_stmt(x):
  out("\n"); indent()

  global k_prev
  k = x['kind']

  if puffy:
    global block_starts
    if not block_starts:
      if k in ['if', 'while', 'return']:
        out("\n")
        indent()
      elif k != k_prev:
        out("\n")
        indent()
    else:
      block_starts = False

  if k == 'block': print_stmt_block(x)
  elif k == 'value': print_stmt_value(x)
  elif k == 'assign': print_stmt_assign(x)
  elif k == 'return': print_stmt_return(x)
  elif k == 'if': print_stmt_if(x)
  elif k == 'while': print_stmt_while(x)
  elif k == 'def_var': print_stmt_defvar(x)
  elif k == 'def_let': print_stmt_let(x)
  elif k == 'break': out('break;')
  elif k == 'again': out('continue;')
  else: out("<stmt %s>" % str(x))

  k_prev = k


# not works
def print_arrays(arrays):
  for array in arrays:
    out("\n"); indent()
    array['value'] = None
    print_stmt_defvar(array)
    out("\n"); indent()
    dst = array['id']['str']
    src = array['id']['str']
    len = type.get_size(array['type'])
    out("memcpy(%s, _%s, %d);" % (dst, src, len))


def print_stmts(stmts):
  k_prev = ""
  if len(stmts) > 0:
    k_prev = stmts[0]['kind']
  i = 0
  for stmt in stmts:

    """if puffy:
      #noneed0 = k_prev == 'value' and stmt['kind'] == 'assign'
      #noneed1 = k_prev == 'assign' and stmt['kind'] == 'value'
      noneed = False #noneed0 or noneed1
      need = k_prev != stmt['kind']
      need_nl = need or stmt['kind'] in ['if', 'while']

      if need_nl and i > 0 and not noneed:
        k_prev = stmt['kind']
        out("\n")"""

    print_stmt(stmt)
    i = i + 1


def print_stmts_flat(stmts):
  for stmt in stmts:
    print_stmt(stmt)


block_starts = False
def print_stmt_block(s, arrays=None):
  out("{")
  indent_up()
  global block_starts
  block_starts = True

  if arrays != None:
    print_arrays(arrays)

  print_stmts(s['stmts'])

  indent_down()
  out("\n")
  indent()
  out("}")


def print_func_signature(id, typ):

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
  while type.is_pointer(t):
    ptr_level = ptr_level + 1
    t = t['to']
    # *[] or *[n] -> just *
    if t['kind'] == 'array':
      t = t['of']

  print_type(t)
  out(" " + "*" * ptr_level)
  out("%s" % id)
  arghack = 'arghack' in t['att']
  print_paramlist(typ['params'], arghack)

  return arrays




def print_decl_func(x):
  if 'extern' in x['att']:
    out("extern ")
  func = x['func']
  if 'c_prefix' in func:
    out("%s " % func['c_prefix'])
  print_func_signature(func['id']['str'], func['type'])
  out(";")


def print_def_func(x):
  if not was_separated_by_new_line:
    out("\n")

  func = x['func']
  if 'comment' in func:
    if func['comment'] != '':
      out("// %s\n" % func['comment'])

  if 'c_prefix' in func:
    out("%s " % func['c_prefix'])

  arrays = print_func_signature(func['id']['str'], func['type'])

  if styleguide['LINE_BREAK_BEFORE_FUNC_BRACE']:
    out("\n")
  else:
    out(" ")

  print_stmt_block(func['stmt'], arrays=arrays)

  if styleguide['EXTRA_BLANK_LINES_BETWEEN_FUNCS'] > 0:
    out("\n" * styleguide['EXTRA_BLANK_LINES_BETWEEN_FUNCS'])



def print_decl_type(x):
  name = x['id']['str']
  #o("// type declaration %s\n" % name)
  out("struct %s;\n" % name)
  out("typedef struct %s %s;\n\n" % (name, name))


def print_def_type(x):
  if not was_separated_by_new_line:
    if x['type']['kind'] in ['record', 'enum']:
      out("\n")

  # !
  if x['afterdef']:
    if type.is_record(x['type']):
      print_type_record(x['type'], tag=x['id']['str'])
      out(";\n")
      return;


  if PRINT_STRUCT_PREFIX_FOR_RECORDS:
    if type.is_record(x['type']):
      print_type_record(x['type'], tag=x['id']['str'])
      out(";")
      return

  is_defined_array = type.is_defined_array(x['type'])
  out("typedef ")
  if is_defined_array:
    print_type(x['type']['of'])#, print_aka=False)
  else:
    print_type(x['type'])#, print_aka=False)
  out(" %s" % x['id']['str'])
  if is_defined_array:
    out("["); print_value(x['type']['volume']); out("]")
  out(";")
  if x['type']['kind'] in ['record', 'enum']:
    out("\n")



# из за того что с C типы записваются через жопу
# приходится печатать типы ptr, arr & func вместе с именем поля
def print_field(x, const=False, prefix=None):
  t = x['type']

  if 'aka' in x:
    print_type(t)
    out(" ")
    if prefix != None:
      out(prefix)
    out("%s" % (x['id']['str']))
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
  while type.is_pointer(t):
    t = t['to']

    if t == 'func':
      t = type.typeUnit
    else:
      ptr_level = ptr_level + 1
      # *[] or *[n] -> just *
      if t['kind'] == 'array':
        t = t['of']

  if ptr_level == 0 and const:
    out("const ")
  print_type(t)
  out(" ")
  out("*" * ptr_level)
  if ptr_level > 0 and const:
    out(" const ")

  if prefix != None:
    out(prefix)
  out("%s" % (x['id']['str']))
  if is_array:
    if array_dims != None:
      for dim in array_dims:
        out("["); print_value(dim); out("]")



def print_def_var(x):
  if 'c_prefix' in x['var']:
      out("%s " % x['var']['c_prefix'])
  print_field(x['var'])
  if x['init'] != None:
    out(" = "); print_value(x['init'])
  out(";")


def print_def_const(x):
  #print("print_def_const " + str(x['id']['str']))
  out("#define %s  " % x['id']['str'])
  need_wrap = precedence(x['value']['kind']) < precedenceMax
  print_value(x['value'], ctx=['screening'], need_wrap=need_wrap, print_just_id=True)


def print_include(x):
  if x['local']:
    impline = "#include \"%s\"" % x['str']
  else:
    impline = "#include <%s>" % x['str']
  out(impline)


def print_insert(x):
  out(x['str'])


def print_comment_line(x):
  for line in x['lines']:
    out("\n//%s" % line['str'])


def print_comment_block(x):
  lines = x['lines']

  out("/*\n")

  for line in lines:
    out("%s\n" % (line['str']))

  out(" */")



def cdirectives(module):
  for imported_module in module['imports']:
    for obj in imported_module['text']:
      if obj['kind'] == 'c_include':
        out("\n")
        print_include(obj)
  for obj in module['text']:
    if obj['kind'] == 'c_include':
      out("\n")
      print_include(obj)



def run(module, outname):
  is_header = 'header' in features

  if is_header:
    outname = outname + '.h'
  else:
    outname = outname + '.c'

  output_open(outname)

  # search for c_include
  cdirectives(module)

  guardname = ''
  if is_header:
    guardname = outname.split("/")[-1]
    guardname = guardname[:-2].upper() + '_H'
    lo("#ifndef %s" % guardname)
    lo("#define %s\n" % guardname)

  lo("#include <stdint.h>")
  lo("#include <string.h>")  # for memcpy

  prev_ik = ('', '')

  for x in module['text']:
    if 'c-no-print' in x['att']:
      continue

    out("\n")

    isa = x['isa']
    k = x['kind']

    # prettify output with empty lines
    ik = (isa, k)
    separation = prev_ik != ik
    if separation:
      prev_ik = ik
      out("\n")
    global was_separated_by_new_line
    was_separated_by_new_line = separation

    if 'comment' in x:
      if x['comment'] != '':
        out("// " + x['comment'])

    if isa == 'definition':
      if k == 'var': print_def_var(x)
      elif k == 'const': print_def_const(x)
      elif k == 'func': print_def_func(x)
      elif k == 'type': print_def_type(x)
    elif isa == 'declaration':
      if k == 'func': print_decl_func(x)
      elif k == 'type': print_decl_type(x)
    elif isa == 'directive':
      if k == 'import': print_include(x)
      elif k == 'insert': print_insert(x)
    elif isa == 'comment':
      if k == 'comment-line': print_comment_line(x)
      elif k == 'comment-block': print_comment_block(x)

  out("\n")
  if is_header:
    lo("#endif  /* %s */" % guardname)
  out("\n")

  output_close()



