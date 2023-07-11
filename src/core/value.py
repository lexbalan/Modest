
import copy
from opt import *
import core.type as type
from .trans import is_local_context
from error import error, warning, info
from .hlir import *


def value_create_zero(t):
  if type.is_numeric(t):
    return hlir_value_int(0, t)

  # stub (!)
  # todo: struct, array
  return hlir_value_int(0, t)




valueNil = hlir_value_int(0, typ=type.typeFreePtr)
valueTrue = hlir_value_int(1, typ=type.typeNat1)
valueFalse = hlir_value_int(0, typ=type.typeNat1)



def value_create_bin(op, l, r, t, ti):
  return {
    'isa': 'value',
    'kind': op,
    'left': l,
    'right': r,
    'type': t,
    'att': [],
    'ti': ti
  }


def value_create_bad(ti=None):
  return {
    'isa': 'value',
    'kind': 'bad',
    'type': type.type_bad(),
    'att': [],
    'ti': ti
  }


def value_is_bad(x):
  assert x != None
  return x['kind'] == 'bad'



def value_attribute_add(v, a):
  v['att'].append(a)

def value_attribute_check(v, a):
  return a in v['att']


def value_is_immutable(x):
  return 'immutable' in x['att']


def value_is_immediate(x):
  return 'immediate' in x['att']


def value_num_get(x):
  return x['num']




def value_cons_array_from_generic_array(v, t, ti, method):
  if len(v['items']) > t['volume']['num']:
    info("too many items", v['ti'])
    return None

  cast_method = value_cast_implicit
  if method == 'explicit':
    cast_method = value_cast_explicit

  casted_items = []
  for item in v['items']:
    casted_item = cast_method(item, t['of'], item['ti'])
    type.check(t['of'], casted_item['type'], item['ti'])
    casted_items.append(casted_item)

  vx = {
    'isa': 'value',
    'kind': 'array',
    'items': casted_items,
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


def value_cons_array(v, t, ti, method):
  # GenericArray -> Array
  if type.is_array(v['type']) and type.is_generic(v['type']):
    return value_cons_array_from_generic_array(v, t, ti, method)

  return None



def search_in_items_by_id(items, id):
  for item in items:
    if item['id']['str'] == id:
      return item
  return None


def value_cons_record_from_generic_record(v, t, ti, method):
  # 1. проходим по порядку определения по всем полям типа t (целевого)
  # 2. если поля с таким именеи нет в v:
    # 2.1 конструируем нулевое значение соотв типа
    # 2.2 if method == 'implicit' - это ошибка (!)
  # 3. делаем implicit_cast() для поля из v к соотв полю из t
  # 4. проверяем тип
  # 5. пакуем
  items = []
  for field in t['fields']:
    field_name = field['id']['str']
    field_type = field['type']

    # получаем элемент с соотв именем из исходного значения
    item_value = None
    item = search_in_items_by_id(v['items'], field_name)
    if item != None:
      item_value = item['value']
    else:
      # нет такого поля, создаем нулевую затычку
      item_value = value_create_zero(field_type)

      if method == 'implicit':
        info("expected field '%s'" % field_name, v['ti'])
        # это cast, а cast не выдает ошибки
        return None

    item_value = value_cast_implicit(item_value, field_type, ti=None)

    if not type.eq(item_value['type'], field_type):
      error("field type cast error", item_value)

    items.append({
      'isa': 'item',
      'id': {'isa': 'id', 'str': field_name, 'ti': None},
      'value': item_value,
    })

  vx = {
    'isa': 'value',
    'kind': 'record',
    'items': items,
    'type': t,
    'att': [],

    'ti': ti
  }


  # 'generic-casted' - нужен для принтера C
  # чтобы он добавил явное приведение к Локальной (!) структуре
  # (Point){.x=0, .y=0}
  if is_local_context():
    vx['att'].append('generic-casted')

  # если это не сделать то принтер C не сможет сослаться
  # на именованную константу и станет печатать ее по месту
  if 'id' in v:
    vx['id'] = v['id']

  return vx



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
        y['num'] = float(y['num'])  # 0 -> 0.0, need for printer (!)
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

  #if method == 'explicit':
  if 'unsafe' in features:
    ### UNSAFE ###

    if method == 'explicit':
      # Int -> Ptr
      if type.is_generic_integer(from_type):
        return hlir_value_cast(v, t, ti=ti) # @!!

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
        if 'string' in v['att']:
          y['att'].append('string')

        return y

  # *Unit & AnyPtr, AnyPtr & *Unit
  if type.is_free_pointer(from_type) and type.is_pointer(t):
    return hlir_value_cast(v, t, ti=ti)
  if type.is_free_pointer(t) and type.is_pointer(from_type):
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
    return value_create_bad(ti)

  from_type = v['type']

  # implisit cast possible only for:
  # 1. Generic -> NonGeneric  ('nil' are GenericPointer)
  # 2. *[n]T -> *[]T
  from_generic = type.is_generic(from_type)

  ptr_def_arr_to_undef_arr = type.is_pointer_to_defined_array(from_type) and type.is_pointer_to_undefined_array(t)

  if not (from_generic or ptr_def_arr_to_undef_arr):
    return v

  c = value_cons(v, t, ti, method='implicit')

  return v if c == None else c



def value_cast_explicit(v, t, ti):
  if value_is_bad(v) or type.is_bad(t):
    return value_create_bad(ti)

  if type.eq(v['type'], t):
    warning("explicit cast to same type", ti)
    return v

  c = value_cons(v, t, ti, method='explicit')
  if c == None:
    error("cast error", ti)
    return value_create_bad(ti)
  return c


