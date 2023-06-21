
import copy
import core.type as type
from .mgmt import features_get
from .type import nbits_for_int, nbytes_for_bits
from error import error, info



def value_create_zero(t):
  if type.is_numeric(t):
    return value_create_int(0, t)

  # stub (!)
  # todo: struct, array
  return value_create_int(0, t)



def value_create_int(num, typ=None, ti=None):

  nbits = nbits_for_int(num)

  if typ == None:
    typ = type.type_generic_int_for_bits(nbits)
  

  if nbytes_for_bits(nbits) > typ['size']:
    # extend if generic or error
    if type.is_generic(typ):
      typ = type.typeInteger('Int', nbits, attributes=['generic'])
    else:
      error("integer oferflow", ti)

  return {
    'isa': 'value',
    'kind': 'num',
    'num': num,
    'type': typ,
    'attributes': ['immediate'],
    'properties': {},
    'ti': ti
  }


valueNil = value_create_int(0, typ=type.typeFreePtr)
valueTrue = value_create_int(1, typ=type.typeNat1)
valueFalse = value_create_int(0, typ=type.typeNat1)


def value_create_float(num, typ=type.genericFloat, ti=None):
  # вообще с флотом непонятно можно ли понять какого он Generic типа
  # тк есть числа которые вообще никак не запишешь
  return {
    'isa': 'value',
    'kind': 'num',
    'num': num,
    'type': typ,
    'attributes': ['immediate'],
    'properties': {},
    'ti': ti
  }


def value_create_bin(op, l, r, t, ti):
  return {
    'isa': 'value',
    'kind': op,
    'left': l,
    'right': r,
    'type': t,
    'attributes': [],
    'properties': {},
    'ti': ti
  }


def value_create_bad(ti=None):
  return {
    'isa': 'value',
    'kind': 'bad',
    'type': type.type_bad(),
    'attributes': [],
    'properties': {},
    'ti': ti
  }


def value_is_bad(x):
  assert x != None
  return x['kind'] == 'bad'



def value_attribute_add(v, a):
  v['attributes'].append(a)

def value_attribute_check(v, a):
  return a in v['attributes']



def value_is_immutable(x):
  return 'immutable' in x['attributes']

def value_is_immediate(x):
  return 'immediate' in x['attributes']


def value_num_get(x):
  return x['num']




def value_cons_array_from_generic_array(v, t, ti, method):
  if len(v['items']) > t['size']:
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
    'attributes': ['generic-casted'],
    'properties': {},
    'ti': ti
  }

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

  # 'generic-casted' - нужен для принтера C чтобы он
  vx = {
    'isa': 'value',
    'kind': 'record',
    'items': items,
    'type': t,
    'attributes': ['generic-casted'],
    'properties': {},
    'ti': ti
  }

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




def do_cast_runtime(v, t, ti):
  return {
    'isa': 'value',
    'kind': 'cast',
    'value': v,
    'type': t,
    'attributes': [],
    'properties': {},
    'ti': ti
  }




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
      if type.is_numeric(t):
        if v['type']['size'] > t['size']:
          return None

      return do_cast_generic(v, t, ti)

    # cast non-generic integer to integer
    if method == 'explicit':
      return do_cast_runtime(v, t, ti)

  elif type.is_float(v['type']):
    if method == 'explicit':
      return do_cast_runtime(v, t, ti)


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
        return do_cast_runtime(v, t, ti)

    elif type.is_float(vt):
      # Float -> Float
      if method == 'explicit':
        return do_cast_runtime(v, t, ti)

    return None



def value_cons_pointer(v, t, ti, method):

  from_type = v['type']

  #if method == 'explicit':
  if features_get('unsafe'):
    ### UNSAFE ###

    if method == 'explicit':
      # Int -> Ptr
      if type.is_generic_integer(from_type):
        return do_cast_runtime(v, t, ti) # @!!

      # Ptr -> Ptr
      if type.is_pointer(from_type):
        return do_cast_runtime(v, t, ti)

  # *[n]X -> *[]X  (например строковой литерал к типу Str)
  if type.is_pointer_to_defined_array(from_type):
    if type.is_pointer_to_undefined_array(t):
      if type.eq(from_type['to']['of'], t['to']['of']):
        y = do_cast_runtime(v, t, ti)

        # кароче это стаб - си хочет печатать runtime приведение строки
        # к char *, что излишне; по этому атрибуту он понимает
        # что делать так не надо; Это временное решение (!)
        if 'string' in v['attributes']:
          y['attributes'].append('string')

        return y

  # *Unit & AnyPtr, AnyPtr & *Unit
  if type.is_free_pointer(from_type) and type.is_pointer(t):
    return do_cast_runtime(v, t, ti)
  if type.is_free_pointer(t) and type.is_pointer(from_type):
    return do_cast_runtime(v, t, ti)

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

  # implisit cast possible only for:
  # 1. Generic -> NonGeneric  ('nil' are GenericPointer)
  # 2. *[n]T -> *[]T
  from_generic = type.is_generic(v['type'])
  from_ptr_def_arr_to_undef = type.is_pointer_to_defined_array(v['type']) and type.is_pointer_to_undefined_array(t)

  if not (from_generic or from_ptr_def_arr_to_undef):
    return v

  c = value_cons(v, t, ti, method='implicit')

  return v if c == None else c



def value_cast_explicit(v, t, ti):
  if value_is_bad(v) or type.is_bad(t):
    return value_create_bad(ti)

  c = value_cons(v, t, ti, method='explicit')
  if c == None:
    error("cast error", ti)
    return value_create_bad(ti)
  return c


