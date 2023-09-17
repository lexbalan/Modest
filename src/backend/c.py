
from opt import *
from error import info, error
from .common import *
import core.type as type
from core.value import value_attribute_check, value_is_immediate
from core.hlir import hlir_field, hlir_value_num_get, hlir_stmt_block, hlir_value_var
from util import nbits_for_num, get_item_with_id

puffy = False

INDENT_SYMBOL = " " * 4

FUNC_EMPTY_PARAMLIST = "(void)"
SPACE_AFTER_IF_WHILE = True

ARRAYS_MULTILINE_ALWAYS = False
ARRAYS_MULTILINE_FROM = 8

RECORDS_MULTILINE_ALWAYS = False
RECORDS_MULTILINE_FROM = 4

NO_TYPEDEF_STRUCTS = False
NO_TYPEDEF_OTHERS = False

USE_BOOLEAN = True
USE_STDBOOL = True

USE_UCHAR = False

USE_STATIC_VARIABLES = True
USE_CONST_LET_VARIABLES = True


EMPTY_BLOCK_COMMENT = "// TODO: pay attention here"


# for integer literals printing
CC_INT_SIZE_BITS = 32
CC_LONG_SIZE_BITS = 64
CC_LONG_LONG_SIZE_BITS = 64


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


def indent_if(x):
  if x: indent()


def nl_indent():
  out("\n")
  indent()



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
  ['logic_or'], #0
  ['logic_and'], #1
  ['or'], #2
  ['xor'], #3
  ['and'], #4
  ['eq', 'ne'], #5
  ['lt', 'le', 'gt', 'ge'], #6
  ['shl', 'shr'], #7
  ['add', 'sub'], #8
  ['mul', 'div', 'rem'], #9
  ['plus', 'minus', 'not', 'cast', 'ref', 'deref', 'sizeof'], #10
  ['call', 'index', 'access'], #11
  ['num', 'var', 'func', 'str', 'enum', 'record', 'array'] #12
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



def print_type_array(t, print_as_pointer, need_space_after):
  print_type(t['of'], need_space_after=True)

  if print_as_pointer:
    if 'const' in t['att']:
      out("*const")
      if need_space_after:
        out(" ")
    else:
      out("*")
    return


  if t['volume'] != None:
    out("["); print_value(t['volume']); out("]")
  else:
    out("*")

  """if need_space_after:
      out(" ")"""



def print_type_pointer(t, need_space_after):
  # array was printed as *, we dont need to place another *
  if type.is_array(t['to']):
    print_type(t['to']['of'], need_space_after=True)
    if 'const' in t['att']:
      out("*const")
      if need_space_after:
        out(" ")
    else:
      out("*")
    return

  if type.is_free_pointer(t):
    out("void ")
  else:
    print_type(t['to'], need_space_after=True)

  if 'const' in t['att']:
    out("*const")
    if need_space_after:
      out(" ")
  else:
    out("*")







def print_fields(fields, before, after, between):
  i = 0
  n = len(fields)
  while i < n:
    param = fields[i]
    out(before)
    print_field(param)
    #if 'const' in param['type']['att']:
    #  info("const in att", param['ti'])
    #  exit(1)

    out(after)
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

  for field in t['fields']:
    # print comments
    if 'comments' in field:
      for comment in field['comments']:
        out("\n" * comment['nl'])
        print_comment(comment)

    out("\n" * field['nl'])
    indent();
    print_field(field)
    out(";")

  indent_down()
  nl_indent()
  out("}")



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


def print_array_asis(t):
  print_type(t['of'], need_space_after=True)
  out("[")
  print_value(t['volume'])
  out("]")


# Возвращает False если НЕ нужно отделять пробелом после типа
# (только указатели *)
# блядские аргументы по умолчанию - нихера с ними не работает!
def print_type(t, need_space_after, _print_array_asis=False):
  rc = print_type2(t, print_aka=True, need_space_after=need_space_after, _print_array_asis=_print_array_asis)


def print_type_full(t, _print_array_asis=False):
  return print_type2(t, print_aka=False, need_space_after=False, _print_array_asis=_print_array_asis)


def print_type2(t, print_aka, need_space_after, _print_array_asis):
  k = t['kind']

  if 'const' in t['att']:
    if not type.is_pointer(t):
      out("const ")

  if NO_TYPEDEF_OTHERS:
    if type.is_alias(t):
      tt = t['aliasof']
      if not type.is_record(tt):
        print_type2(t['aliasof'], print_aka=True, need_space_after=need_space_after)

  if USE_BOOLEAN:
    if type.is_logical(t):
      out("bool")
      if need_space_after:
        out(" ")
      return

  # hotfix for let generic value problem (let x = 1)
  if type.is_generic_integer(t):
    # если пришел generic - подберем подходящий тип
    # ex: let x = 1; func(x)
    is_signed = not type.is_unsigned(t)
    t = type.select_numeric(t['power'], is_signed)

  if print_aka:
    if 'c_alias' in t:
      out(t['c_alias'])
      if need_space_after:
        out(" ")
      return

    if 'name' in t:
      if NO_TYPEDEF_STRUCTS:
        if type.is_record(t):
          out("struct ")
      out(t['name'])
      if need_space_after:
        out(" ")
      return

  if type.is_numeric(t):
    print_type_numeric(t)
    if need_space_after:
      out(" ")

  elif type.is_record(t):
    print_type_record(t)
    if need_space_after:
      out(" ")

  #elif type.is_enum(t): print_type_enum(t, need_space_after)
  elif type.is_pointer(t):
    print_type_pointer(t, need_space_after)

  elif type.is_array(t):
    if _print_array_asis:
      print_array_asis(t)
      return
    print_type_array(t, print_as_pointer=True, need_space_after=need_space_after)

  elif type.is_func(t):
    out("void")
    if need_space_after:
      out(" ")

  elif k == 'opaque':
    out("void")
    if need_space_after:
      out(" ")

  else: out("<type:" + str(t) + ">")





bin_ops = {
  'or': '|', 'xor': '^', 'and': '&', 'shl': '<<', 'shr': '>>',
  'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
  'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'rem': '%',
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
  if op in ['shl', 'shr', 'logic_or', 'logic_and']:
    need_wrap_left = precedence(left['kind']) < 10 #precedenceMax
    need_wrap_right = precedence(right['kind']) < 10 #precedenceMax

  print_value(left, need_wrap=need_wrap_left)
  out(' %s ' % bin_ops[op])
  print_value(right, need_wrap=need_wrap_right)



un_ops = {
  'ref': '&', 'deref': '*',
  'plus': '+', 'minus': '-',
  'not': '~', 'logic_not': '!'
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
  if len(parms) == 0:
    out(FUNC_EMPTY_PARAMLIST)

  else:
    out("(")
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
    out("(("); print_type(t['to'], need_space_after=False); out("(*)")
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
  out("("); print_type(t, need_space_after=False); out(")")
  huhu(v_id, fields)


def print_cast(t, v, ctx=[]):
  from_type = v['type']
  # в C мы не можем привести одну структуру к другой
  # поэтому вынуждены будем построить новую структуру
  # на основе другой (пусть и с таким же внутренним устройством)
  if type.is_generic_record(from_type):
    return print_cast_gen_rec_to_rec(t, v, ctx=ctx)


  # because
  # - in C  int32(-1) -> uint64 => 0xffffffffffffffff
  # - in CM int32(-1) -> uint64 => 0x00000000ffffffff
  # require: (uint64_t)((uint32)int32_value)
  need_pre = False
  if type.is_integer(from_type):
    if type.is_integer(t):
      if type.is_signed(from_type):
        if type.is_unsigned(t):
          if from_type['size'] < t['size']:
            need_pre = True


  out("("); print_type(t, need_space_after=False); out(")")
  need_wrap = precedence(v['kind']) < precedence('cast')

  if need_pre:
    out("((")
    nat_same_sz = type.select_nat(a['size'])
    print_type(nat_same_sz, need_space_after=False)
    out(")")

  print_value(v, ctx=ctx, need_wrap=need_wrap)

  if need_pre:
    out(")")




def print_value_cast(v, ctx):

  if 'is-generic-cast' in v['att']:
    print_value_literal(v, ctx)
    return

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


  # ! Вырубил тк мешает; Непонятно нужно ли вообще но похоже что нет
  # Чтобы не приводить тип в выражениях типа ((int32_t)0), etc.
  """if type.is_numeric(to_type):
    if type.is_generic(from_type):
      if type.is_numeric(from_type):
        print_value(v['value'], ctx)
        return"""

  # не печатаем приведение литерала строки "string" к Str
  if type.eq(type.typeStr, to_type):
    if value_attribute_check(v['value'], 'string'):
      print_value(v['value'], ctx)
      return

  print_cast(to_type, v['value'], ctx)



def print_value_literal_array(v, ctx):
  screening = 'screening' in ctx

  if ARRAYS_MULTILINE_ALWAYS:
    multiline = True
  else:
    multiline = hlir_value_num_get(v['type']['volume']) > ARRAYS_MULTILINE_FROM


  out("{")
  indent_up()

  if multiline and screening: out("\\")

  values = v['imm_items']
  i = 0
  n = len(values)
  while i < n:
    a = values[i]

    nl = 0
    if 'nl' in a:
      nl = a['nl']


    if nl > 0:
      out("\n" * nl)
      indent()
    else:
      if i > 0:
        out(" ")

    print_value(a, ctx=ctx)

    i = i + 1
    if i < n:
      out(',')


  indent_down()

  if v['nl_end'] > 0:
    out("\n" * v['nl_end'])
    indent()

  out("}")



def print_value_literal_record(v, ctx):
  screening = 'screening' in ctx

  if RECORDS_MULTILINE_ALWAYS:
    multiline = True
  else:
    multiline = len(v['type']['fields']) > RECORDS_MULTILINE_FROM

  out("{")
  i = 0
  """if multiline:
    if screening:
      out("\\")
    out("\n")"""
  indent_up()


  nitems = len(v['initializers'])
  while i < nitems:
    item = v['type']['fields'][i]
    field_str = item['id']['str']

    ini = get_item_with_id(v['initializers'], field_str)

    nl = 0
    if 'nl' in ini:
      nl = ini['nl']

    if nl > 0:
      out("\n" * nl)
      indent()
    else:
      if i > 0:
        out(" ")

    out(".%s = " % field_str)

    print_value(ini['value'], ctx)
    if i < (nitems - 1):
      out(",")

    i = i + 1

  indent_down()

  if v['nl_end'] > 0:
    out("\n" * v['nl_end'])
    indent()

  out("}")



def print_value_literal_str(x, ctx, prefix=""):
  out("%s\"" % prefix)
  for sym in x['str']:
    if sym == '\n': out("\\n")
    elif sym == '\r': out("\\r")
    elif sym == '\a': out("\\a")
    else: out(sym)
  out("\"")





def print_value_literal_int(x, ctx):

  num = hlir_value_num_get(x)

  # Big Number?
  if x['type']['power'] > 64:
    if nbits_for_num(num):
      # print Big Numbers
      high64 = (num >> 64) & 0xFFFFFFFFFFFFFFFF
      low64 = num & 0xFFFFFFFFFFFFFFFF

      out("(((__int128)0x%X << 64) | ((__int128)0x%X))" % (high64, low64))
      return


  if USE_BOOLEAN:
    if type.is_logical(x['type']):
      if num: out("true")
      else: out("false")
      return

  if type.type_attribute_check(x['type'], 'char'):
    out("'%c'" % num)
  elif value_attribute_check(x, 'hexadecimal'):
    out("0x%X" % num)
  else:
    out(str(num))


  nbits = nbits_for_num(num)

  if nbits == x['type']['power']:
    if type.is_unsigned(x['type']):
      out("U")

  if nbits > CC_INT_SIZE_BITS:
    if nbits <= CC_LONG_SIZE_BITS:
      out("L")
    else:
      out("LL")


def print_value_literal_flt(x, ctx):
  out(str(hlir_value_num_get(x)))



def print_value_literal_ptr(x, ctx):
  if type.is_free_pointer(x['type']):
    out("NULL")
  else:
    if hlir_value_num_get(x) == 0:
      out("NULL")
    else:
      out("0x%X" % hlir_value_num_get(x))


def print_value_literal(x, ctx):
  t = x['type']
  if type.is_integer(t): print_value_literal_int(x, ctx)
  elif type.is_float(t): print_value_literal_flt(x, ctx)
  elif type.is_record(t): print_value_literal_record(x, ctx)
  elif type.is_array(t): print_value_literal_array(x, ctx)
  elif type.is_string(t): print_value_literal_str(x, ctx)
  elif type.is_pointer(t): print_value_literal_ptr(x, ctx)



def print_value_by_id(x, ctx):
  out("%s" % x['id']['str'])



def print_value(x, ctx=[], need_wrap=False, print_just_id=True):
  # если у значения есть свойство 'id' то печатаем просто id
  # (используется для печати имени констант а не просто их значения)
  # в LLVM перчаем просто значение

  need_cast = value_attribute_check(x, 'generic-casted')
  if need_cast:
    out("("); print_type(x['type'], need_space_after=False); out(")")

  if print_just_id:
    if 'id' in x:
      print_value_by_id(x, ctx)
      return

  if need_wrap:
    out("(")

  k = x['kind']

  if k == 'literal': print_value_literal(x, ctx)
  elif k in bin_ops: print_value_bin(x, ctx)
  elif k in un_ops: print_value_un(x, ctx)
  elif k in ['func', 'var', 'const']: print_value_by_id(x, ctx)
  elif k == 'call': print_value_call(x, ctx)
  elif k == 'index': print_value_index(x, ctx)
  elif k == 'index_ptr': print_value_index_ptr(x, ctx)
  elif k == 'access': print_value_access(x, ctx)
  elif k == 'access_ptr': print_value_access_ptr(x, ctx)
  elif k == 'cast': print_value_cast(x, ctx)
  elif k == 'sizeof': out("sizeof("); print_type(x['of'], need_space_after=False, _print_array_asis=True); out(")")
  else:
    out("<%s>" % k)
    print(x)
    exit(1)

  if need_wrap:
    out(")")


def print_stmt_if(x, need_else_branch):
  out("if")
  if SPACE_AFTER_IF_WHILE: out(" ")
  out("("); print_value(x['cond']); out(")")

  if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
    nl_indent()
  else:
    out(" ")

  print_stmt_block(x['then'])

  e = x['else']
  if e != None:
    if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
      nl_indent()
    else:
      out(" ")

    if e['kind'] == 'if':
      out("else ")
      print_stmt_if(e, need_else_branch=True)
    else:
      out("else")
      if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
        nl_indent()
      else:
        out(" ")
      print_stmt_block(e)



def print_stmt_while(x):
  out("while")
  if SPACE_AFTER_IF_WHILE: out(" ")
  out("("); print_value(x['cond']); out(")")

  if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
    nl_indent()
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
  print_field(x['var'])

  init_value = x['init_value']
  if init_value != None:
    out(" = ")
    print_value(init_value)

  out(";")



# в C не существует литерала для 128 бит
# поэтому приходится рачком-бочком
def assign_big_int_immediate(left, right):
  n = hlir_value_num_get(right)

  high64 = (n >> 64) & 0xFFFFFFFFFFFFFFFF
  low64 = n & 0xFFFFFFFFFFFFFFFF

  print_value(left); out(" = 0x%X;" % (high64))
  nl_indent(); print_value(left); out(" <<= 64;")
  nl_indent(); print_value(left); out(" |= 0x%X;" % (low64))



def print_stmt_let(x):
  v = x['value']
  print_field2(x['id'], v['type'])
  out(" = ")
  print_value(v)
  out(";")



def assign_array_by_items(x):
  out("// array assignation")
  for i in range(x['right']['type']['size']):
    nl_indent()
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
    nl_indent()
    print_value(x['left']);
    out(".%s = " % f['id']['str'])
    print_value(x['right']);
    out(".%s;" % f['id']['str'])


def assign(left, right):

  # в си нельзя просто так присвоить массив // или структуру
  if right['kind'] == 'var':
    if type.is_array(right['type']):
      assign_array_by_items(x)
      return

    #if type.is_record(x['right']['type']):
      #assign_record_by_fields(x)
      #return

  print_value(left)
  out(" = ")
  print_value(right)
  out(";")



def print_stmt_assign(x):
  assign(x['left'], x['right'])


def print_stmt_value(x):
  print_value(x['value']); out(";")



def print_stmt(x):
  k = x['kind']

  nl = x['nl']
  out("\n" * nl)

  if k == 'block': print_stmt_block(x)
  elif k == 'value': indent_if(nl > 0); print_stmt_value(x)
  elif k == 'assign': indent_if(nl > 0); print_stmt_assign(x)
  elif k == 'return': indent_if(nl > 0); print_stmt_return(x)
  elif k == 'if': indent_if(nl > 0); print_stmt_if(x, need_else_branch=False)
  elif k == 'while': indent_if(nl > 0); print_stmt_while(x)
  elif k == 'def_var': indent_if(nl > 0); print_stmt_defvar(x)
  elif k == 'def_let': indent_if(nl > 0); print_stmt_let(x)
  elif k == 'break': indent_if(nl > 0); out('break;')
  elif k == 'again': indent_if(nl > 0); out('continue;')
  elif k == 'comment-line': print_comment_line(x)
  elif k == 'comment-block': print_comment_block(x)
  else: out("<stmt %s>" % str(x))


# not works
def print_arrays(arrays):
  for array in arrays:
    nl_indent()
    array['value'] = None
    print_stmt_defvar(array)
    nl_indent()
    dst = array['id']['str']
    src = array['id']['str']
    len = type.get_size(array['type'])
    out("memcpy(%s, _%s, %d);" % (dst, src, len))



def print_stmt_block(s, arrays=None, empty_comment=""):
  out("{")

  indent_up()

  #if arrays != None:
  #  print_arrays(arrays)

  for stmt in s['stmts']:
    print_stmt(stmt)

  #elif empty_comment != "":
    #nl_indent()
    #out(empty_comment)

  indent_down()

  endnl = s['end_nl']
  out("\n" * endnl)
  if endnl:
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

  print_type(t, need_space_after=False)
  out(" " + "*" * ptr_level)
  out("%s" % id)
  arghack = 'arghack' in t['att']
  print_paramlist(typ['params'], arghack)

  return arrays




def print_decl_func(x):
  func = x['func']

  if 'extern' in func['att']:
    out("extern ")

  if 'static' in func['att']:
    out("static ")

  if 'inline' in func['att']:
    out("inline ")

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

  if 'static' in func['att']:
    out("static ")

  if 'inline' in func['att']:
    out("inline ")

  arrays = print_func_signature(func['id']['str'], func['type'])

  if styleguide['LINE_BREAK_BEFORE_FUNC_BRACE']:
    out("\n")
  else:
    out(" ")

  #empty_comment="// TODO: function %s implementation" % func['id']['str']
  print_stmt_block(func['stmt'], arrays=arrays)

#  if styleguide['EXTRA_BLANK_LINES_BETWEEN_FUNCS'] > 0:
#    out("\n" * styleguide['EXTRA_BLANK_LINES_BETWEEN_FUNCS'])



def print_decl_type(x):
  name = x['id']['str']
  out("struct %s;" % name)
  if not NO_TYPEDEF_STRUCTS:
    out("\ntypedef struct %s %s;" % (name, name))


def print_def_type(x):
  id = x['id']['str']
  t = x['type']

  if not was_separated_by_new_line:
    if t['kind'] in ['record', 'enum']:
      out("\n")

  # !
  if x['afterdef']:
    if type.is_record(t):
      print_type_record(t, tag=x['id']['str'])
      out(";")
      return;


  if NO_TYPEDEF_STRUCTS:
    if type.is_record(t):
      print_type_record(t, tag=x['id']['str'])
      out(";")
      return

  if NO_TYPEDEF_OTHERS:
    if not type.is_record(t):
      return

  is_defined_array = type.is_defined_array(t)
  out("typedef ")

  if 'volatile' in x['att']:
    out("volatile ")

  if is_defined_array:
    print_type_full(t['of'])#, print_aka=False)
  else:
    print_type_full(t)#, print_aka=False)
  out(" %s" % x['id']['str'])
  if is_defined_array:
    out("["); print_value(t['volume']); out("]")
  out(";")



def print_field_regular(t, id):
  print_type(t, need_space_after=True)
  out("%s" % id)


def print_field_pointer(t, id):
  print_type(t, need_space_after=True)
  out("%s" % id)



def print_field_array(t, id):
  # get list element type
  root_type = t
  while root_type['kind'] == 'array':
    root_type = root_type['of']

  print_type(root_type, need_space_after=True)

  out("%s" % id)

  # print arrays dimensions
  array_type = t
  while type.is_array(array_type):
    out("["); print_value(array_type['volume']); out("]")
    array_type = array_type['of']


# из за того что с C типы записваются через жопу
# приходится печатать типы ptr, arr & func вместе с именем поля
def print_field(x):
  print_field2(x['id'], x['type'])


def print_field2(_id, typ):
  assert (typ != None)

  id_str = _id['str']
  assert (id_str != "")


  if 'c_alias' in typ or 'name' in typ:
    print_field_regular(typ, id_str)
    return

  if type.is_pointer(typ): print_field_pointer(typ, id_str)
  elif type.is_array(typ): print_field_array(typ, id_str)
  else: print_field_regular(typ, id_str)




def print_def_var(x):
  if USE_STATIC_VARIABLES:
    if not 'global' in x['var']['att']:
      if not 'extern' in x['var']['att']:
        out("static ")

    if 'extern' in x['var']['att']:
      out("extern ")

    if 'volatile' in x['var']['att']:
      out("volatile ")


  if 'c_prefix' in x['var']:
    out("%s " % x['var']['c_prefix'])

  print_field(x['var'])

  init_value = x['init_value']
  if init_value != None:
    out(" = "); print_value(init_value)

  out(";")


def print_def_const(x):
  #print("print_def_const " + str(x['id']['str']))
  out("#define %s  " % x['id']['str'])

  v = x['value']['value']
  need_wrap = precedence(v['kind']) < precedenceMax
  print_value(v, ctx=['screening'], need_wrap=need_wrap, print_just_id=True)


def print_include(x):
  if x['local']:
    impline = "#include \"%s\"" % x['str']
  else:
    impline = "#include <%s>" % x['str']
  out(impline)


def print_insert(x):
  out(x['str'])


def print_comment(x):
  k = x['kind']
  if k == 'line': print_comment_line(x)
  elif k == 'block': print_comment_block(x)


def print_comment_block(x):
  out("/*%s*/" % x['text'])


def print_comment_line(x):
  lines = x['lines']
  i = 0
  n = len(lines)
  while i < n:
    line = lines[i]
    #if need_indent:
    indent()
    out("//%s" % line['str'])
    i = i + 1
    if i < n:
      out("\n")





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
  lo("#include <string.h>")

  if USE_STDBOOL:
    lo("#include <stdbool.h>")

  if USE_UCHAR:
    lo("#include <uchar.h>")

  out("\n\n")


  for x in module['text']:
    if 'c-no-print' in x['att']:
      continue

    isa = x['isa']
    k = x['kind']

    if 'nl' in x:
      out("\n" * x['nl'])
    else:
      out("\n")
      print('not NL in ' + str(x))

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
      print_comment(x)



  out("\n")
  if is_header:
    lo("#endif  /* %s */" % guardname)
  out("\n")

  output_close()



