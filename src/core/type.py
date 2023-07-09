

import copy
from opt import *
from error import error

typePointerSize = 4



def nbits_for_int(x):
  n = 1
  y = 1
  while x > y:
    y = (y << 1) | 1
    n = n + 1
  return n


def nbytes_for_bits(x):
  aligned_bits = 8
  while aligned_bits < x:
    aligned_bits = aligned_bits * 2
  return aligned_bits // 8


"""def nbytes_for_bits(bits, signed=True):
  nn = bits

  if signed:
    if num < 0:
      nn = nn + 1

  y = nbytes_for_bits(nn)
  #print("nbytes_for_int %d -> %d (%d)" % (num, nn, y))
  return y"""


def typeInteger(aka, power, attributes=[]):
  return {
    'isa': 'type',
    'kind': 'integer',
    'name': aka,
    'attributes': ['numeric', 'integer', 'ordered'] + attributes,
    'power': power,
    'size': nbytes_for_bits(power),
    'ti': None
  }


def typeFloat(aka, size, attributes=[]):
  return {
    'isa': 'type',
    'kind': 'float',
    'name': aka,
    'attributes': ['numeric', 'float', 'ordered'] + attributes,
    'size': size,
    'ti': None
  }


def typePointer(to, attributes=[], ti=None):
  return {
    'isa': 'type',
    'kind': 'pointer',
    'to': to,
    'size': typePointerSize,
    'power': typePointerSize * 8,
    'attributes': attributes,
    'ti': ti
  }


def typeArray(of, size=None, attributes=[], ti=None):
  return {
    'isa': 'type',
    'kind': 'array',
    'of': of,
    'size': size,  #TODO: not 'size', use 'volume' or something better (!)
    'attributes': attributes,
    'ti': ti
  }


def typeBad(ti):
  return {'isa': 'type', 'kind': 'bad', 'attributes': [], 'ti': ti}


typeUnit = {
  'isa': 'type',
  'kind': 'unit',
  'name': 'Unit',
  'c_alias': 'void',
  'llvm_alias': 'void',
  'size': 0,
  'power': 0,
  'items': [],
  'attributes': [],
  'ti': None
}

typeInt8  = typeInteger("Int8", 8, attributes=['signed'])
typeInt8['c_alias'] = 'int8_t'
typeInt8['llvm_alias'] = 'i8'
typeInt16 = typeInteger("Int16", 16, attributes=['signed'])
typeInt16['c_alias'] = 'int16_t'
typeInt16['llvm_alias'] = 'i16'
typeInt32 = typeInteger("Int32", 32, attributes=['signed'])
typeInt32['c_alias'] = 'int32_t'
typeInt32['llvm_alias'] = 'i32'
typeInt64 = typeInteger("Int64", 64, attributes=['signed'])
typeInt64['c_alias'] = 'int64_t'
typeInt64['llvm_alias'] = 'i64'

typeNat1 = typeInteger("Nat1", 1, attributes=['unsigned'])
typeNat1['c_alias'] = 'uint8_t'
typeNat1['llvm_alias'] = 'i1'
typeNat8  = typeInteger("Nat8", 8, attributes=['unsigned'])
typeNat8['c_alias'] = 'uint8_t'
typeNat8['llvm_alias'] = 'i8'
typeNat16 = typeInteger("Nat16", 16, attributes=['unsigned'])
typeNat16['c_alias'] = 'uint16_t'
typeNat16['llvm_alias'] = 'i16'
typeNat32 = typeInteger("Nat32", 32, attributes=['unsigned'])
typeNat32['c_alias'] = 'uint32_t'
typeNat32['llvm_alias'] = 'i32'
typeNat64 = typeInteger("Nat64", 64, attributes=['unsigned'])
typeNat64['c_alias'] = 'uint64_t'
typeNat64['llvm_alias'] = 'i64'


typeFloat16 = typeFloat('Float16', 2, attributes=[])
typeFloat16['c_alias'] = 'half'
typeFloat16['llvm_alias'] = 'half'
typeFloat32 = typeFloat('Float32', 4, attributes=[])
typeFloat32['c_alias'] = 'float'
typeFloat32['llvm_alias'] = 'float'
typeFloat64 = typeFloat('Float64', 8, attributes=[])
typeFloat64['c_alias'] = 'double'
typeFloat64['llvm_alias'] = 'double'


typeChar = copy.copy(typeNat8)
typeChar['c_alias'] = 'char'
typeChar['llvm_alias'] = 'i8'
typeStr = typePointer(typeArray(typeChar))
typeStr['attributes'].append('str')
genericStr = typeStr

genericInt = {
  'isa': 'type',
  'kind': 'integer',
  'name': 'Int',
  'attributes': ['generic', 'numeric', 'integer', 'ordered'],
  'size': 0,
  'power': 0,
  'ti': None
}

genericFloat = {
  'isa': 'type',
  'kind': 'float',
  'name': 'Float',
  'attributes': ['generic', 'numeric', 'ordered', 'float'],
  'size': 0,
  'power': 0,
  'ti': None
}

typeInt = copy.copy(typeInt64)
typeInt['c_alias'] = 'int'
typeNat = copy.copy(typeNat64)
typeFreePtr = typePointer(typeUnit)
typeFreePtr['attributes'].append('generic')  #!



def eq_integer(a, b):
  return a['name'] == b['name']


def eq_pointer(a, b):
  return eq(a['to'], b['to'])


def eq_array(a, b):
  if a['size'] == b['size']:
    return eq(a['of'], b['of'])
  return False


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


def eq_enum(a, b):
  aitems = a['items']
  bitems = b['items']
  if len(aitems) != len(bitems):
    return False
  for aitem, bitem in zip(aitems, bitems):
    if aitem['id']['str'] != bitem['id']['str']:
      return False
    if aitem['number'] != bitem['number']:
      return False
  return True


def eq_float(a, b):
  return a['name'] == b['name']


def eq_opaque(a, b):
  return a['name'] == b['name']  # maybe by UID?


def eq(a, b):
  # fast checking
  if a == b: return True
  if a['kind'] == 'bad': return True
  if b['kind'] == 'bad': return True
  if a['kind'] != b['kind']: return False

  # normal checking
  k = a['kind']
  if k == 'integer': return eq_integer(a, b)
  elif k == 'unit': return True
  elif k == 'pointer': return eq_pointer(a, b)
  elif k == 'array': return eq_array(a, b)
  elif k == 'func': return eq_func(a, b)
  elif k == 'record': return eq_record(a, b)
  elif k == 'enum': return eq_enum(a, b)
  elif k == 'float': return eq_float(a, b)
  elif k == 'opaque': return eq_opaque(a, b)

  return False



def type_attribute_add(t, a):
  t['attributes'].append(a)


def type_attribute_check(t, a):
  return a in t['attributes']



def is_bad(t):
  assert t != None
  return t['kind'] == 'bad'


def is_generic(t):
  return 'generic' in t['attributes']


def is_numeric(t):
  return 'numeric' in t['attributes']


def is_integer(t):
  return t['kind'] == 'integer'


def is_float(t):
  return t['kind'] == 'float'


def is_generic_numeric(t):
  return 'generic' in t['attributes'] and 'numeric' in t['attributes']


def is_generic_integer(t):
  return 'generic' in t['attributes'] and 'integer' in t['attributes']


def is_unit(t):
  return t['kind'] == 'unit'

def is_enum(t):
  return t['kind'] == 'enum'


def is_pointer(t):
  return t['kind'] == 'pointer'


def is_free_pointer(t):
  if t['kind'] != 'pointer':
    return False
  return eq(t['to'], typeUnit)


def is_array(t):
  return t['kind'] == 'array'


def is_func(t):
  return t['kind'] == 'func'


def is_opaque(t):
  return t['kind'] == 'opaque'


def is_defined_array(t):
  if t['kind'] == 'array':
    return t['size'] != None
  return False


def is_undefined_array(t):
  if t['kind'] == 'array':
    return t['size'] == None
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
  return 'generic' in t['attributes']


def is_numeric(t):
  return 'numeric' in t['attributes']


def is_signed(t):
  return 'signed' in t['attributes']

def is_unsigned(t):
  return 'unsigned' in t['attributes']



# cannot create variable with type
def is_forbidden_var(t, zero_array_forbidden=True):
  k = t['kind']
  if k == 'opaque' or k == 'unit':
    return True

  # [0]Int, []Int, [n]<Forbidden>
  if is_array(t):
    # is undefined array?
    if t['size'] == None:
      return True

    # is defined array;
    # It can't be 0 sized (can only with 'unsafe' compiler flag)
    if zero_array_forbidden or not features_get('unsafe'):
      if t['size'] == 0:
        return True

    return is_forbidden_var(t['of'])

  if is_func(t):
    return True


  return False


def is_alias(t):
  return 'alias' in t['attributes']


def check(a, b, ti):
  res = eq(a, b)
  if not res:
    error("type error", ti)
    type_print(a)
    print(" & ", end='')
    type_print(b)
    print()
  return res


def record_field_get(typ, field_id):
  # search field
  field = None
  i = 0
  while i < len(typ['fields']):
    f = typ['fields'][i]
    if f['id']['str'] == field_id:
      field = f
      break
    i = i + 1
  return field


def create_alias(id, t, ti):
  #print('type.create_alias ' + id)
  nt = copy.copy(t)

  nt['c_alias'] = id
  nt['llvm_alias'] = '%' + id

  if not 'name' in nt:
    nt['name'] = id

  nt['attributes'].append('alias')
  nt['aliasof'] = t
  nt['ti'] = ti
  return nt


newtypeID = 0
def create_newtype(id, t, ti):
  global newtypeID
  nt = copy.copy(t)
  nt['name'] = id

  newtypeID = newtypeID + 1
  nt['uid'] = newtypeID

  nt['attributes'].append('newtype')
  nt['derived'] = t
  nt['ti'] = ti
  return nt


# ищем поле с таким id в типе к которому приводим
def record_get_field_by_id(t, id):
  for field in t['fields']:
    if field['id']['str'] == id:
      return field
  return None


# create type bad
def type_bad(ti=None):
  return {
    'isa': 'type',
    'kind': 'bad',
    'attributes': [],
    'ti': ti
  }


def type_generic_int_for_bits(n):
  gen_int_type = copy.copy(genericInt)
  gen_int_type['power'] = n
  gen_int_type['size'] = nbytes_for_bits(n)
  return gen_int_type



def get_size(t):
  k = t['kind']
  if k == 'integer':
    return t['size']
  elif k == 'array':
    # t['volume] TODO!
    return t['size'] * get_size(t['of'])



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

  if k == 'record':
    print("{")
    fields = t['fields']
    i = 0
    while i < len(fields):
      field = fields[i]
      if i > 0:
        print(',')
      print("\n\t"); type_print(field['type'])

      i = i + 1
    print("\n}")

  elif k == 'enum':
    print("enum", end='')

  elif k == 'pointer':
    print("*", end=''); type_print(t['to'])

  elif k == 'array':
    print("[", end='')
    array_size = t['size']
    sz = 0
    if array_size != None:
      sz = array_size

    print("%d" % sz, end='')
    print("]", end='')
    type_print(t['of'])

  elif k == 'func':
    print("(", end='')
    print_list_by(t['params'], lambda f: type_print(f['type']))
    print(")", end='')
    print(" -> ", end='')
    type_print(t['to'])

  elif k == 'integer':
    print('%' + t['name'], end='')
    if is_generic(t):
      print('%d' % t['power'], end='')

  elif k == 'opaque':
    print('opaque', end='')

  else:
    print("<type:%s>" % k, end='')



