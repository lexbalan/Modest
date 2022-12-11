
from error import error


def typeInteger(aka, meta=[]):
  return {'isa': 'type', 'kind': 'base', 'aka': aka, 'meta': ['numeric'] + meta, 'ti': None}

def typePointer(to, meta=[], ti=None):
  return {'isa': 'type', 'kind': 'pointer', 'to': to, 'meta': meta, 'ti': ti}

def typeArray(of, size=None, meta=[], ti=None):
  return {'isa': 'type', 'kind': 'array', 'of': of, 'size': size, 'meta': meta, 'ti': ti}

def typeBad(ti):
  return {'isa': 'type', 'kind': 'bad', 'meta': [], 'ti': ti}

typeUnit = {
  'isa': 'type',
  'kind': 'enum',
  'aka': 'void',
  'items': [],
  'meta': [],
  'uid': 0,   #!
  'ti': None
}

typeInt8  = typeInteger("int8_t", meta=['signed'])
typeInt16 = typeInteger("int16_t", meta=['signed'])
typeInt32 = typeInteger("int32_t", meta=['signed'])
typeInt64 = typeInteger("int64_t", meta=['signed'])

typeNat8  = typeInteger("uint8_t", meta=['unsigned'])
typeNat16 = typeInteger("uint16_t", meta=['unsigned'])
typeNat32 = typeInteger("uint32_t", meta=['unsigned'])
typeNat64 = typeInteger("uint64_t", meta=['unsigned'])

typeChar = typeNat8
typeStr = typePointer(typeArray(typeChar))
genericStr = typeStr

genericInt = {
  'isa': 'type',
  'kind': 'base',
  'aka': '<generic:int>',
  'meta': ['generic', 'numeric'],
  'ti': None
}

typeNat1 = typeNat8
typeInt = typeInt64
typeNat = typeNat64
typeFreePtr = typePointer(typeUnit)


def eq(a, b):
  k = a['kind']
  
  if a['kind'] != b['kind']:
    return False
  
  if k == 'base':
    return a['aka'] == b['aka']
  
  elif k == 'pointer':
    return eq(a['to'], b['to'])
  
  elif k == 'array':
    if a['size'] == b['size']:
      return eq(a['of'], b['of'])
  
  elif k == 'func':
    if not eq(a['to'], b['to']):
      return False
    if len(a['params']) != len(b['params']):
      return False
    for ax, bx in zip(a['params'], b['params']):
      if ax['id'] != bx['id']:
        return False
      if not eq(ax['type'], bx['type']):
        return False
    return True
  
  elif k == 'record':
    if len(a['fields']) != len(b['fields']):
      return False
    for ax, bx in zip(a['fields'], b['fields']):
      if ax['id'] != bx['id']:
        return False
      if not eq(ax['type'], bx['type']):
        return False
    return True
  
  elif k == 'enum':
    return a['uid'] == b['uid']  # by UID?
  
  return False



def is_generic(t):
  return 'generic' in t['meta']

def is_numeric(t):
  return 'numeric' in t['meta']

def is_generic_numeric(t):
  return 'generic' in t['meta'] and 'numeric' in t['meta']


def is_pointer(t):
  return t['kind'] == 'pointer'

def is_array(t):
  return t['kind'] == 'array'

def is_func(t):
  return t['kind'] == 'func'

def is_defined_array(t):
  if t['kind'] == 'array':
    return t['size'] != None
  return False

def is_undefined_array(t):
  if t['kind'] == 'array':
    return t['size'] == None
  return False


def is_enum(t):
  return t['kind'] == 'enum'

def is_record(t):
  return t['kind'] == 'record'

def is_generic(t):
  return 'generic' in t['meta']

def is_numeric(t):
  return 'numeric' in t['meta']


# can implicit cast a -> b ?
def resolve(a, b):

  # Generic -> Specific
  if is_generic(a):

    #GenericNumeric -> Numeric
    if is_numeric(a):
      return is_numeric(b)

    # GenericArray -> Array
    if is_array(a):
      return is_array(b)

    # GenericRecord -> Record
    if is_record(a):
      return is_record(b)

  
  # *Type -> *Type
  if is_pointer(a) and is_pointer(b):
    # *Type -> *Uint
    if eq(b, typeFreePtr):
      return True
    
    # *Uint -> *Type
    if eq(a, typeFreePtr):
      return True
    
    # *[n]Any -> *[]Any
    if is_defined_array(a['to']) and is_undefined_array(b['to']):
      return True

  return False


def check(a, b, ti):
  res = eq(a, b)
  if not res:
    error("type error", ti)
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
  import copy
  nt = copy.copy(t)
  nt['aka'] = id
  nt['meta'].append('alias')
  nt['aliasof'] = t
  nt['ti'] = ti
  return nt


