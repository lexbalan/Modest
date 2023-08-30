
import copy
from opt import *
import core.type as type
from core.type import type_print
from .trans import is_local_context
from error import error, warning, info
from .hlir import *




def value_copy(x):
  nv = copy.copy(x)
  nv['att'] = []
  nv['att'].extend(x['att'])
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
  #if x['kind'] == 'literal':
  #  return True

  return value_is_const_imm(x)



# TODO: массив может НЕЯВНО быть построен только из
# полного или из пустого дженерик массива
def value_cons_array_from_generic_array(v, t, ti, method):
  #print("value_cons_array_from_generic_array")
  if len(v['imm_items']) > hlir_value_num_get(t['volume']):
    info("too many items", v['ti'])
    return None

  #cast_method = value_cast_implicit
  #if method == 'explicit':
  #  cast_method = value_cast_explicit

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
    # будем менять значение (его тип) потому неглубоко копируем значение
    nv = copy.copy(v)
    # будем менять тип (его размер) потому неглубоко копируем тип
    nv['type'] = copy.copy(nv['type'])

    nv['type']['volume'] = t['volume']
    nv['att'] = []

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

  #print(v['kind'])  # exp kind == 'literal'

  # 1. проходим по порядку определения по всем полям типа t (целевого)
  # 2. если поля с таким именеи нет в v:
    # 2.1 конструируем нулевое значение соотв типа
    # 2.2 if method == 'implicit' - это ошибка (!)
  # 3. делаем implicit_cast() для поля из v к соотв полю из t
  # 4. проверяем тип
  # 5. пакуем
  items = {}
  for field in t['fields']:
    field_name = field['id']['str']
    field_type = field['type']

    assert('imm_items' in v)

    # получаем элемент с соотв именем из исходного значения
    item_value = None
    if field_name in v['imm_items']:
      item_value = v['imm_items'][field_name]


    if item_value == None:
      # no field, create zero value stub
      item_value = hlir_value_zero(field_type, ti=None)
      if method == 'implicit':
        # implicit cast требует наличия всех полей
        error("expected field '%s'" % field_name, v['ti'])
        return None  # это cast, а cast не выдает ошибки


    item_value = value_cast_implicit(item_value, field_type, ti=None)

    type.check(field_type, item_value['type'], item_value)

    items[field_name] = item_value

  vx = {
    'isa': 'value',
    'kind': 'literal',
    'imm_items': items,
    'type': t,
    'att': ['generic-casted'],
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




def do_cast_generic(v, t, ti):
  x = copy.deepcopy(v)
  x['type'] = t
  x['ti'] = ti
  return x



def value_cons_integer(v, t, ti, method):
  if type.is_integer(v['type']):
    # Int -> Int
    if type.is_generic(v['type']):
      # GenericInt -> Int
      # check size
      if type.is_numeric(t):
        if v['type']['power'] > t['power']:
          return None

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



def value_change_type(v, t):
    nv = copy.copy(v)
    nv['type'] = t
    return nv


def value_cons_pointer(v, t, ti, method):

  from_type = v['type']

  #if method == 'explicit':
  if 'unsafe' in features:
    ### UNSAFE ###

    if method == 'explicit':

      # Imm Int -> Pointer
      if value_is_immediate(v):
        if type.is_numeric(v['type']):
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
        y = hlir_value_cast(v, t, ti=ti)

        # кароче это стаб - си хочет печатать runtime приведение строки
        # к char *, что излишне; по этому атрибуту он понимает
        # что делать так не надо; Это временное решение (!)
#        if 'string' in v['att']:
#          y['att'].append('casted_string_literal')

        return y

  # Nil -> *X
  if type.is_nil(from_type) and type.is_pointer(t):
    return value_change_type(v, t)

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



def value_cast_implicit(v, t, ti):
  if value_is_bad(v) or type.is_bad(t):
    return hlir_value_bad(ti)

  from_type = v['type']

  """if type.is_generic_integer(t):
    if type.is_generic_integer(from_type):
      nv = value_change_type(v, t)
      nv['att'].append('implicit-casted')
      return nv"""

  # TODO: нужно ли приводить generics?
  # казалось бы для binary нужно но там тип расширяется
  # а не просто выбирается наибольший...
  """if type.is_generic(from_type) and type.is_integer(from_type):
    if t['power'] > v['type']['power']:
      return value_change_type(v, t)"""

  if type.eq(from_type, t):
    return v

  # Nil -> *X
  if type.is_nil(from_type) and type.is_pointer(t):
    return value_change_type(v, t)

  # FreePointer -> *X
  if type.is_free_pointer(from_type) and type.is_pointer(t):
    return hlir_value_cast(v, t, ti=ti)

  # *X -> FreePointer
  if type.is_pointer(from_type) and type.is_free_pointer(t):
    return hlir_value_cast(v, t, ti=ti)


  # implisit cast possible only for:
  # 1. Generic -> NonGeneric
  # 2. *[n]T -> *[]T
  cons_from_generic = type.is_generic(from_type)

  ptr_def_arr_to_undef_arr = type.is_pointer_to_defined_array(from_type) and type.is_pointer_to_undefined_array(t)

  if not (cons_from_generic or ptr_def_arr_to_undef_arr):
    return v

  c = value_cons(v, t, ti, method='implicit')

  return v if c == None else c



def value_cast_explicit(v, t, ti):
  if value_is_bad(v) or type.is_bad(t):
    return hlir_value_bad(ti)

  if type.eq(v['type'], t):
    info("explicit cast to same type", ti)
    return v

  c = value_cons(v, t, ti, method='explicit')
  if c == None:
    error("cast error", ti)
    return hlir_value_bad(ti)
  return c


