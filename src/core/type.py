

import copy
from opt import *
from error import error

from .hlir import *


typeUnit = hlir_type_unit()

typeInt8  = hlir_type_integer("Int8", 8)
typeInt8['att'].extend(['signed'])
typeInt8['c_alias'] = 'int8_t'
typeInt8['llvm_alias'] = 'i8'

typeInt16 = hlir_type_integer("Int16", 16)
typeInt16['att'].extend(['signed'])
typeInt16['c_alias'] = 'int16_t'
typeInt16['llvm_alias'] = 'i16'

typeInt32 = hlir_type_integer("Int32", 32)
typeInt32['att'].extend(['signed'])
typeInt32['c_alias'] = 'int32_t'
typeInt32['llvm_alias'] = 'i32'

typeInt64 = hlir_type_integer("Int64", 64)
typeInt64['att'].extend(['signed'])
typeInt64['c_alias'] = 'int64_t'
typeInt64['llvm_alias'] = 'i64'


typeNat1 = hlir_type_integer("Nat1", 1)
typeNat1['att'].extend(['unsigned'])
typeNat1['c_alias'] = 'uint8_t'
typeNat1['llvm_alias'] = 'i1'

typeNat8 = hlir_type_integer("Nat8", 8)

typeNat8['c_alias'] = 'uint8_t'
typeNat8['att'].extend(['unsigned'])
typeNat8['llvm_alias'] = 'i8'

typeNat16 = hlir_type_integer("Nat16", 16)
typeNat16['att'].extend(['unsigned'])
typeNat16['c_alias'] = 'uint16_t'
typeNat16['llvm_alias'] = 'i16'

typeNat32 = hlir_type_integer("Nat32", 32)
typeNat32['att'].extend(['unsigned'])
typeNat32['c_alias'] = 'uint32_t'
typeNat32['llvm_alias'] = 'i32'

typeNat64 = hlir_type_integer("Nat64", 64)
typeNat64['att'].extend(['unsigned'])
typeNat64['c_alias'] = 'uint64_t'
typeNat64['llvm_alias'] = 'i64'

typeFloat16 = hlir_type_float('Float16', 16)
typeFloat16['att'].extend(['float'])
typeFloat16['c_alias'] = 'half'
typeFloat16['llvm_alias'] = 'half'

typeFloat32 = hlir_type_float('Float32', 32)
typeFloat32['att'].extend(['float'])
typeFloat32['c_alias'] = 'float'
typeFloat32['llvm_alias'] = 'float'

typeFloat64 = hlir_type_float('Float64', 64)
typeFloat64['att'].extend(['float'])
typeFloat64['c_alias'] = 'double'
typeFloat64['llvm_alias'] = 'double'


typeChar = hlir_type_integer("Nat8", 8)
typeChar['att'].extend(['unsigned'])
typeChar['c_alias'] = 'char'
typeChar['llvm_alias'] = 'i8'

typeStr = hlir_type_pointer(hlir_type_array(typeChar))
typeStr['att'].append('str')
typeStr['c_alias'] = 'char *'
genericStr = typeStr


typeFreePtr = hlir_type_free_pointer()
typeFreePtr['att'].append('generic')

typeNil = hlir_type_nil()


"""typeCharacter = hlir_type_integer("Character", 32)
typeCharacter['att'].extend(['generic', 'unsigned'])

typeString = hlir_type_pointer(hlir_type_array(typeCharacter))
typeStr['att'].append('str')
typeStr['c_alias'] = 'char *'
genericStr = typeStr
"""

def eq_integer(a, b):
  if a['power'] != b['power']:
    return False
  if is_signed(a) != is_signed(b):
    return False
  return True


def eq_pointer(a, b):
  return eq(a['to'], b['to'])


def eq_array(a, b):

  if a['volume'] == None and b['volume'] == None:
    return eq(a['of'], b['of'])

  if a['volume'] == None or b['volume'] == None:
    return False

  if hlir_value_num_get(a['volume']) != hlir_value_num_get(b['volume']):
    return False

  if a['of'] == None and b['of'] == None:
    return True

  if a['of'] == None or b['of'] == None:
    return False

  return eq(a['of'], b['of'])




def eq_func(a, b):
  if not eq(a['to'], b['to']): return False
  if len(a['params']) != len(b['params']): return False

  for ax, bx in zip(a['params'], b['params']):
    if ax['id']['str'] != bx['id']['str']: return False
    if not eq(ax['type'], bx['type']): return False

  return True


def eq_record(a, b):
  if len(a['fields']) != len(b['fields']): return False

  for ax, bx in zip(a['fields'], b['fields']):
    if ax['id'] != bx['id']: return False
    if not eq(ax['type'], bx['type']): return False

  return True


def eq_float(a, b):
  if 'power' in a and 'power' in b:
    return a['power'] == b['power']

  return False


def eq_opaque(a, b):
  return a['name'] == b['name']  # maybe by UID?


def eq_alias(a, b):
  if a['att'] != b['att']:
    return False

  return eq(a['of'], b['of'])


def eq(a, b):
  # fast checking
  if a == b: return True
  if a['kind'] == 'bad': return True
  if b['kind'] == 'bad': return True
  if a['kind'] != b['kind']: return False

  # normal checking
  k = a['kind']
  if k == 'int': return eq_integer(a, b)
  elif k == 'unit': return True
  elif k == 'func': return eq_func(a, b)
  elif k == 'record': return eq_record(a, b)
  elif k == 'pointer': return eq_pointer(a, b)
  elif k == 'array': return eq_array(a, b)
  elif k == 'float': return eq_float(a, b)
  elif k == 'opaque': return eq_opaque(a, b)

  return False



def check(a, b, ti):
  res = eq(a, b)
  if not res:
    error("type error", ti)
    type_print(a)
    print(" & ", end='')
    type_print(b)
    print()
  return res



def type_attribute_add(t, a):
  t['att'].append(a)


def type_attribute_check(t, a):
  return a in t['att']


"""def type_class_check(t, a):
  absent = ''
  for c in a:
    if not type_attribute_check(t, c):
      absent = c
      break

  if absent != '':
    error("expected %s type" % (a), x['left'])
  return result"""




def is_bad(t):
  assert t != None
  return t['kind'] == 'bad'


def is_numeric(t):
  return 'numeric' in t['att']


def is_integer(t):
  return t['kind'] == 'int' or t['kind'] == 'Integer'


def is_float(t):
  return t['kind'] == 'float'


def is_string(t):
  if 'str' in t['att']:
    return True
  #!
  if t['kind'] == 'pointer':
    if t['to']['kind'] == 'array':
      if eq(t['to']['of'], typeChar):
        return True

  return False


def is_generic_numeric(t):
  return 'generic' in t['att'] and 'numeric' in t['att']


def is_generic_integer(t):
  return 'generic' in t['att'] and 'integer' in t['att']


def is_generic_record(t):
  if t['kind'] == 'record':
    return 'generic' in t['att']
  return False



def is_unit(t):
  return t['kind'] == 'unit'


def is_enum(t):
  return t['kind'] == 'enum'


def is_pointer(t):
  return t['kind'] in ['pointer', 'FreePointer', 'Nil']


def is_free_pointer(t):
  return t['kind'] == 'FreePointer'


def is_nil(t):
  return t['kind'] == 'Nil'


def is_array(t):
  return t['kind'] == 'array'


def is_func(t):
  return t['kind'] == 'func'


def is_opaque(t):
  return t['kind'] == 'opaque'


def is_defined_array(t):
  if t['kind'] == 'array':
    return t['volume'] != None
  return False


def is_undefined_array(t):
  if t['kind'] == 'array':
    return t['volume'] == None
  return False


def is_pointer_to_defined_array(t):
  if t['kind'] != 'pointer':
    return False
  return is_defined_array(t['to'])


def is_pointer_to_undefined_array(t):
  if t['kind'] != 'pointer':
    return False
  return is_undefined_array(t['to'])


def is_record(t):
  return t['kind'] == 'record'


def is_generic(t):
  return 'generic' in t['att']


def is_signed(t):
  return 'signed' in t['att']


def is_unsigned(t):
  return 'unsigned' in t['att']



# cannot create variable with type
def is_forbidden_var(t, zero_array_forbidden=True):
  if is_opaque(t) or is_unit(t):
    return True

  # [0]Int, []Int, [n]<Forbidden>
  if is_array(t):
    # is undefined array?
    if t['volume'] == None:
      return True

    # is defined array;
    # It can't be 0 sized (can only with 'unsafe' compiler flag)
    if zero_array_forbidden or not features_get('unsafe'):
      if t['volume'] == 0:
        return True

    return is_forbidden_var(t['of'])

  if is_func(t):
    return True


  return False






# ищем поле с таким id в типе record
def record_field_get(t, id):
  for field in t['fields']:
    if field['id']['str'] == id:
      return field
  return None





def create_alias(id, t, ti):
  #print('type.create_alias ' + id)
  nt = copy.copy(t)

  #if not 'name' in nt:
  nt['name'] = id

  if 'c_alias' in nt:
    del nt['c_alias']

  # именно так!  иначе добавим в att t тк это ссылка на лист!
  nt['att'] = []
  nt['att'].extend(t['att'])
  nt['att'].append('alias')

  nt['aliasof'] = t
  nt['ti'] = ti

  return nt



def get_size(t):
  if is_integer(t):
    return t['size']
  elif is_array(t):
    return t['volume']['num'] * get_size(t['of'])


def print_list_by(lst, method):
  i = 0
  while i < len(lst):
    if i > 0:
      print(", ")
    method(lst[i])
    i = i + 1

def type_print(t, print_aka=True):
  k = t['kind']

  if print_aka:
    if 'name' in t:
      id = t['name']

      if id == '<generic:int>':
        id = 'Int'

      if is_generic(t):
        print('Generic', end='')

      print(id, end='')

      if is_generic(t):
        print('%d' % (t['power']), end='')

      return

  if is_record(t):
    if is_generic_record(t):
      print("GenericRecord")
      return

    print("record {")
    fields = t['fields']
    i = 0
    while i < len(fields):
      field = fields[i]
      if i > 0:
        print(',')
      print("\n\t"); type_print(field['type'])

      i = i + 1
    print("\n}")

  elif is_enum(t):
    print("enum", end='')

  elif is_pointer(t):
    print("*", end=''); type_print(t['to'])

  elif is_array(t):
    if t['of'] == None:
      print("EmptyArray")
      return


    print("[", end='')
    array_size = t['volume']

    if array_size != None:
      sz = hlir_value_num_get(array_size)
      print("%d" % sz, end='')

    print("]", end='')
    type_print(t['of'])

  elif is_func(t):
    print("(", end='')
    print_list_by(t['params'], lambda f: type_print(f['type']))
    print(")", end='')
    print(" -> ", end='')
    type_print(t['to'])

  elif is_integer(t):
    print('%' + t['name'], end='')
    if is_generic(t):
      print('%d' % t['power'], end='')

  elif is_opaque(t):
    print('opaque', end='')

  else:
    print("<type:%s>" % k, end='')



