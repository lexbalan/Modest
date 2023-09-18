
from opt import *
import core.type as type
from core.type import type_print
from .trans import is_local_context
from error import error, warning, info
from .hlir import *
from util import get_item_with_id


def cp_immediate(nv, v):

  if 'immediate' in v['att']:
    nv['att'].append('immediate')

  # для generic приведения констант (!)
  if 'id' in v:
    nv['id'] = v['id']


  if 'imm_num' in v:
    nv['imm_num'] = v['imm_num']

    if value_attribute_check(v, 'hexadecimal'):
      nv['att'].append('hexadecimal')

  elif 'imm_items' in v:
    nv['imm_items'] = v['imm_items']

  elif 'initializers' in v:
    nv['initializers'] = v['initializers']

  elif 'str' in v:
    nv['str'] = v['str']
    nv['len'] = v['len']

  else:
    error("fatal: unknown immediate", v['ti'])
    #for f in v:
    #  print(f)



def do_cast_generic(v, t, ti):
  nv = hlir_value_cast(v, t, ti)

  cp_immediate(nv, v)

  if 'nl_end' in v:
    nv['nl_end'] = v['nl_end']

  nv['att'].append('is-generic-cast')

  return nv



#TODO: value #kind=zero
def value_create_zero(t):
  if type.is_numeric(t):
    return hlir_value_int(0, t)

  # stub (!)
  # todo: struct, array
  return hlir_value_int(0, t)




valueNil = hlir_value_int(0, typ=type.typeNil)
valueTrue = hlir_value_int(1, typ=type.typeNat1)
valueFalse = hlir_value_int(0, typ=type.typeNat1)




def value_is_bad(x):
  assert x != None
  return x['kind'] == 'bad'



def value_attribute_add(v, a):
  v['att'].append(a)

def value_attribute_check(v, a):
  return a in v['att']



def value_is_mutable(x):
  if 'immutable' in x['att']:
    return False

  if value_is_immediate(x):
    return False

  return x['kind'] in [
    'var', 'access', 'access_ptr', 'index', 'index_ptr', 'deref'
  ]


def value_is_immutable(x):
  if 'readonly' in x['type']['att']:
    return True
  return not value_is_mutable(x)


# то что определено директивой let
def value_is_const_imm(x):
  if x['kind'] == 'const':
    if 'imm_num' in x:
      return True
  return False


def value_is_immediate(x):
  if 'immediate' in x['att']:
    return True

  return value_is_const_imm(x)



def value_generic_char(c, ti=None):
  return hlir_value_int(ord(c), typ=type.typeChar, ti=ti)



def value_load(x):
  return x



# TODO: массив может НЕЯВНО быть построен только из
# полного или из пустого дженерик массива
def value_cons_array_from_generic_array(v, t, ti, method):
  #print("value_cons_array_from_generic_array")
  if len(v['imm_items']) > hlir_value_num_get(t['volume']):
    info("too many items", v['ti'])
    return None

  casted_items = []
  for item in v['imm_items']:
    casted_item = value_cast_implicit(item, t['of'], item['ti'])
    type.check(t['of'], casted_item['type'], item['ti'])
    casted_items.append(casted_item)

  vx = {
    'isa': 'value',
    'kind': 'literal',
    'imm_items': casted_items,
    'type': t,
    'att': [],
    'nl_end': v['nl_end'],
    'ti': ti
  }

  # 'generic-casted' - нужен для принтера C
  # чтобы он добавил явное приведение к Локальному (!) массиву
  # (uint32_t[3]){0, 1, 2}
  if is_local_context():
    vx['att'].append('generic-casted')

  # если это не сделать то принтер C не сможет сослаться
  # на именованную константу и станет печатать ее по месту
  if 'id' in v:
    vx['id'] = v['id']


  if 'immediate' in v['att']:
    vx['att'].append('immediate')

  return vx


# TODO: only for immediate array (!)
def value_cons_array_from_array(v, t, ti, method):

  # нельзя построить массив из массива другого типа
  if not type.eq(v['type']['of'], t['of']):
    return None

  # нельзя построить меньший массив из большего
  n_from = hlir_value_num_get(v['type']['volume'])
  n_to = hlir_value_num_get(t['volume'])
  if n_from > n_to:
    return None

  # если массив идет как непосредственное значение
  if value_is_immediate(v):
    n = n_to - n_from

    nv = do_cast_generic(v, t, ti)

    # extend array with zero items
    padding = [hlir_value_zero(t['of'], ti=None)] * n
    nv['imm_items'].extend(padding)

    return nv

  return None


def value_cons_array(v, t, ti, method):
  #print("value_cons_array")
  # GenericArray -> Array
  if type.is_array(v['type']):
    if type.is_generic(v['type']):
      return value_cons_array_from_generic_array(v, t, ti, method)
    return value_cons_array_from_array(v, t, ti, method)

  return None



def value_cons_record_from_generic_record(v, t, ti, method):
  if v['kind'] == 'const':
    # TODO: тут нужно проверить чтобы при implicit методе
    # все поля присутствовали (!)
    return hlir_value_cast(v, t, ti=ti)

  # 1. проходим по порядку определения по всем полям типа t (целевого)
  # 2. если поля с таким именеи нет в v:
    # 2.1 конструируем нулевое значение соотв типа
    # 2.2 if method == 'implicit' - это ошибка (!)
  # 3. делаем implicit_cast() для поля из v к соотв полю из t
  # 4. проверяем тип
  # 5. пакуем
  items = []
  prev_nl = 1 # nl для неявных инициализаторов (zero)
  for field in t['fields']:
    field_name = field['id']['str']
    field_type = field['type']

    # получаем элемент с соотв именем из исходного значения
    item_value = None
    nl = 0
    xti = None

    ini = get_item_with_id(v['initializers'], field_name)

    if ini == None:
      # no field, create zero value stub
      item_value = hlir_value_zero(field_type, ti=None)
      if method == 'implicit':
        # implicit cast требует наличия всех полей
        error("expected field '%s'" % field_name, v['ti'])
        return None  # это cast, а cast не выдает ошибки
      nl = prev_nl
      ti = None
    else:
      item_value = ini['value']
      nl = ini['nl']
      ti = ini['ti']

    prev_nl = nl

    item_value2 = value_cast_implicit(item_value, field_type, ti=None)

    type.check(field_type, item_value2['type'], item_value2)

    #items[field_name] = item_value2
    items.append({
      'isa': 'initizlizer',
      'id': field['id'],
      'value': item_value2,
      'att': [],
      'nl': nl,
      'ti': ti
    })

  vx = {
    'isa': 'value',
    'kind': 'literal',
    'initializers': items,
    'type': t,
    'att': ['generic-casted'],
    'nl_end': v['nl_end'],
    'ti': ti
  }

  # 'generic-casted' - нужен для принтера C
  # чтобы он добавил явное приведение к типу
  # example: (Point){.x=0, .y=0}
#  if is_local_context():
#    vx['att'].append('generic-casted')

  # если это не сделать то принтер C не сможет сослаться
  # на именованную константу и станет печатать ее по месту
  if 'id' in v:
    vx['id'] = v['id']

  if 'nl' in v:
    vx['nl'] = v['nl']


  if 'immediate' in v['att']:
    vx['att'].append('immediate')

  return vx


def is_bad_struct(x):
  if type.is_record(x):
    for field in x['fields']:
      if field['type'] == None:
        return True
  return False


def value_cons_record(v, t, ti, method):
  # GenericRecord -> Record
  if type.is_generic(v['type']) and type.is_record(v['type']):
    return value_cons_record_from_generic_record(v, t, ti, method)

  return None



def value_cons_integer(v, t, ti, method):
  if type.is_integer(v['type']):
    # Int -> Int
    if type.is_generic(v['type']):
      # GenericInt -> Int
      # check size
      if v['type']['power'] > t['power']:
        warning("casting with data loss", ti)
        return hlir_value_cast(v, t, ti)

      return do_cast_generic(v, t, ti)

    # cast non-generic integer to integer
    if method == 'explicit':
      return hlir_value_cast(v, t, ti=ti)

  elif type.is_float(v['type']):
    if method == 'explicit':
      return hlir_value_cast(v, t, ti=ti)

  return None



def value_cons_float(v, t, ti, method):
    vt = v['type']

    if type.is_generic(vt):
      # GenericFloat -> Float
      # GenericInt -> Float
      if type.is_integer(vt) or type.is_float(vt):

        if v['type']['size'] > t['size']:
          return None

        y = do_cast_generic(v, t, ti)
        y['imm_num'] = float(y['imm_num'])  # 0 -> 0.0, need for printer (!)
        return y

    elif type.is_integer(vt):
      # Int -> Float
      if method == 'explicit':
        return hlir_value_cast(v, t, ti=ti)

    elif type.is_float(vt):
      # Float -> Float
      if method == 'explicit':
        return hlir_value_cast(v, t, ti=ti)

    return None



def value_cons_pointer(v, t, ti, method):

  from_type = v['type']

  if 'unsafe' in features:
    ### UNSAFE ###

    if method == 'explicit':

      # Imm Int -> Pointer
      if value_is_immediate(v):
        if type.is_integer(v['type']):
          # compile-time casting
          nv = hlir_value_cast(v, t, ti=ti)
          nv['imm_num'] = v['imm_num']
          nv['att'].append('immediate')
          return nv

      # Int -> Ptr
      if type.is_integer(from_type):
        from core.trans import ptr_size
        if from_type['power'] != ptr_size:
          error("cons pointer from integer with different size", ti)
        return hlir_value_cast(v, t, ti=ti)

      # Ptr -> Ptr
      if type.is_pointer(from_type):
        return hlir_value_cast(v, t, ti=ti)

  # *[n]X -> *[]X  (например строковой литерал к типу Str)
  if type.is_pointer_to_defined_array(from_type):
    if type.is_pointer_to_undefined_array(t):
      if type.eq(from_type['to']['of'], t['to']['of']):
        return hlir_value_cast(v, t, ti=ti)

  # Nil -> *X
  if type.is_nil(from_type) and type.is_pointer(t):
    return do_cast_generic(v, t, ti)

  # Pointer -> *X
  if type.is_free_pointer(from_type) and type.is_pointer(t):
    return hlir_value_cast(v, t, ti=ti)

  # *X -> Pointer
  if type.is_pointer(from_type) and type.is_free_pointer(t):
    return hlir_value_cast(v, t, ti=ti)

  return None


# возвращает None если не может привести (!)
# не принтует ошибку
# это НЕ нужно для удобства приведения полей структур
def value_cons(v, t, ti, method):
  if value_is_bad(v) or type.is_bad(t):
    return None

  if type.eq(v['type'], t):
    return v

  cons = None
  if type.is_integer(t): cons = value_cons_integer
  elif type.is_pointer(t): cons = value_cons_pointer
  elif type.is_array(t): cons = value_cons_array
  elif type.is_record(t): cons = value_cons_record
  elif type.is_float(t): cons = value_cons_float

  if cons != None:
    y = cons(v, t, ti, method)
    if y == None:
      return None

    value_attribute_add(y, '%s-casted' % method)
    return y

  return None




def value_soft_cast(v, t, ti):
  c = value_cons(v, t, ti, method='implicit')
  if c == None:
    return v
  return c


def value_hard_cast(v, t, ti):
  c = value_cons(v, t, ti, method='explicit')
  if c == None:
    error("cast error", ti)
    return hlir_value_bad(ti)
  return c



def value_cast_implicit(v, t, ti):
  if value_is_bad(v) or type.is_bad(t):
    return hlir_value_bad(ti)

  from_type = v['type']

  # implisit cast possible only for:
  # 1. Generic -> NonGeneric
  # 2. Nil -> AnyPointer
  # 3. *[n]T -> *[]T
  # 4. AnyPointer -> FreePointer
  # 5. FreePointer -> AnyPointer

  #if not type.is_generic(from_type):
  #  return v

  if type.eq(from_type, t):
    return v


  if type.is_generic(from_type):
    return value_soft_cast(v, t, ti)


  ptr_def_arr_to_undef_arr = type.is_pointer_to_defined_array(from_type) and type.is_pointer_to_undefined_array(t)

  if ptr_def_arr_to_undef_arr:
    return value_soft_cast(v, t, ti)


  # Nil -> *X
  if type.is_nil(from_type) and type.is_pointer(t):
    return do_cast_generic(v, t, ti)


  # FreePointer -> *X
  if type.is_free_pointer(from_type) and type.is_pointer(t):
    return hlir_value_cast(v, t, ti=ti)

  # *X -> FreePointer
  if type.is_pointer(from_type) and type.is_free_pointer(t):
    return hlir_value_cast(v, t, ti=ti)

  return v



def value_cast_explicit(v, t, ti):
  if value_is_bad(v) or type.is_bad(t):
    return hlir_value_bad(ti)

  if type.eq(v['type'], t):
    info("explicit cast to same type", ti)
    return v

  return value_hard_cast(v, t, ti)


