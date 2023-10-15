
from opt import *
import type
from type import type_print
from trans import is_local_context
from error import error, warning, info
from hlir import *
from util import get_item_with_id


no_warning_cast_data_loss = False


def value_print(x):
    print("print_value:")
    print("isa: " + str(x['isa']))
    print("kind: " + str(x['kind']))
    print("type: ", end=""); type.type_print(x['type']); print()
    print("att: " + str(x['att']))
    print("additional properties:")
    for prop in x:
        if not prop in ['isa', 'kind', 'type', 'att', 'ti']:
            print(" - %s" % prop)
    info("here", x['ti'])




def do_cast_generic(v, t, ti):
    #info("do_cast_generic", ti)

    nv = hlir_value_cast(v, t, ti)
    nv['kind'] = 'cast_generic'

    hlir_value_set_imm(nv, v['imm'])

    if 'nl_end' in v:
        nv['nl_end'] = v['nl_end']

    # для generic приведения констант (!)
    if 'id' in v:
        nv['id'] = v['id']

    return nv



"""#TODO: value #kind=zero
def value_create_zero(t):
    if type.is_numeric(t):
        return hlir_value_int(0, t)

    # stub (!)
    # todo: struct, array
    return hlir_value_int(0, t)"""




valueNil = hlir_value_int(0, typ=type.typeNil)
valueTrue = hlir_value_int(1, typ=type.typeNat1)
valueFalse = hlir_value_int(0, typ=type.typeNat1)





def value_attribute_add(v, a):
    v['att'].append(a)


def value_attribute_check(v, a):
    return a in v['att']




def value_is_bad(x):
    assert x != None
    return x['kind'] == 'bad'


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
        if 'imm' in x:
            return 'num' in x
        #return value_is_immediate()
    return False


def value_is_immediate(x):
    if 'immediate' in x['att']:
        return True

    return value_is_const_imm(x)



def value_is_string_literal(x):
    return x['type']['kind'] == 'String'


def value_generic_char(c, ti=None):
    char_code = ord(c)
    typ = hlir_type_char(nbits_for_num(char_code), ti=ti)
    return hlir_value_int(char_code, typ=typ, ti=ti)



def value_load(x):
    return x



# TODO: массив может НЕЯВНО быть построен только из
# полного или из пустого дженерик массива
def value_cons_array_from_generic_array(v, t, ti, method):
    #info("value_cons_array_from_generic_array", ti)
    if len(v['imm']) > hlir_value_imm_get(t['volume']):
        info("too many items", v['ti'])
        return None

    casted_items = []
    items = v['imm']
    for item in items:
        casted_item = value_cast_implicit(item, t['of'], item['ti'])
        type.check(t['of'], casted_item['type'], item['ti'])

        casted_item['nl'] = item['nl']
        casted_items.append(casted_item)

    vx = {
        'isa': 'value',
        'kind': 'literal',
        'imm': None,
        'type': t,
        'att': [],
        'nl_end': v['nl_end'],
        'ti': ti
    }

    hlir_value_set_imm(vx, casted_items)

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
    n_from = hlir_value_imm_get(v['type']['volume'])
    n_to = hlir_value_imm_get(t['volume'])
    if n_from > n_to:
        return None

    # если массив идет как непосредственное значение
    if value_is_immediate(v):
        n = n_to - n_from

        nv = do_cast_generic(v, t, ti)

        # extend array with zero items
        padding = [hlir_value_zero(t['of'], ti=None)] * n
        nv['imm'].extend(padding)

        return nv

    return None


def str_used_as(string_value, typ):
    if typ['power'] == 8: string_value['imm']['used_char8'] = True
    elif typ['power'] == 16: string_value['imm']['used_char16'] = True
    elif typ['power'] == 32: string_value['imm']['used_char32'] = True



def value_cons_array_from_string(v, t, ti, method):
    from_type = v['type']
    to_type = t

    if not type.is_char(to_type['of']):
        return None

    #info("cast generic string to array", ti)

    # Check to:array volume vs string len
    # "xxx" to []X | "xxx" to [n]X
    if to_type['volume'] != None:
        to_arr_volume = hlir_value_imm_get(to_type['volume'])
        # v['len'] учитывает '\0'
        if v['imm']['len'] > to_arr_volume:
            error("too big", ti)
            return None
        if method == 'implicit':
            if v['imm']['len'] < to_arr_volume:
                print("v['imm']['len'] = " + str(v['imm']['len']))
                print("to_arr_volume = " + str(to_arr_volume))
                error("too short", ti)
                return None

    items = []
    for c in v['imm']['str']:
        ccode = ord(c) # get character code in utf-32
        item = hlir_value_int(ccode, typ=to_type['of'], ti=ti)
        items.append(item)

    items.append(hlir_value_int(0, typ=to_type['of']))

    str_used_as(string_value=v, typ=to_type['of'])

    a = hlir_value_array(items, type=to_type, ti=None)
    a['att'].append('no-cast-literal-array')
    return a


def value_cons_array(v, t, ti, method):
    from_type = v['type']
    to_type = t

    # GenericArray -> Array
    if type.is_array(from_type):
        if type.is_generic(from_type):
            return value_cons_array_from_generic_array(v, t, ti, method)
        return value_cons_array_from_array(v, t, ti, method)

    # GenericString -> Array
    if type.is_generic_string(from_type):
        return value_cons_array_from_string(v, t, ti, method)

    return None



def value_cons_record_from_generic_record(v, t, ti, method):

    if v['kind'] == 'const':
        # TODO: тут нужно проверить чтобы при implicit методе
        # все поля присутствовали (!)
        return hlir_value_cast(v, t, ti=ti)

    items = []
    if len(v['type']['fields']) > 0:
        # 1. проходим по порядку определения по всем полям типа t (целевого)
        # 2. если поля с таким именеи нет в v:
            # 2.1 конструируем нулевое значение соотв типа
            # 2.2 if method == 'implicit' - это ошибка (!)
        # 3. делаем implicit_cast() для поля из v к соотв полю из t
        # 4. проверяем тип
        # 5. пакуем
        prev_nl = 1 # nl для неявных инициализаторов (zeroinitializers)
        for field in t['fields']:
            field_name = field['id']['str']
            field_type = field['type']

            # получаем элемент с соотв именем из исходного значения
            item_value = None
            nl = 0

            initializers = v['imm']
            ini = get_item_with_id(initializers, field_name)

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

            item_value2 = value_cast_implicit(item_value, field_type, ti=item_value['ti'])

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
        'imm': None,
        'type': t,
        'att': [],
        'nl_end': v['nl_end'],
        'ti': ti
    }

    hlir_value_set_imm(vx, items)

    # если это не сделать то принтер C не сможет сослаться
    # на именованную константу и станет печатать ее по месту
    if 'id' in v:
        vx['id'] = v['id']

    if 'nl' in v:
        vx['nl'] = v['nl']


    return vx



def value_cons_record(v, t, ti, method):
    from_type = v['type']

    # GenericRecord -> Record
    if type.is_record(from_type):
        if type.is_generic(from_type):
            return value_cons_record_from_generic_record(v, t, ti, method)
        return value_cons_record_from_record(v, t, ti, method)

    return None



def value_cons_char(v, t, ti, method):
    # implicit casts
    if type.is_generic_char(v['type']):
        return do_cast_generic(v, t, ti)


    # explicit casts
    if method != 'explicit':
        info("cannot implicit cons Char value", ti)
        return None


    if type.is_char(v['type']) or type.is_integer(v['type']):
        return hlir_value_cast(v, t, ti)


    return None



def check_power(vtype, t, method, ti):
    rv = True

    if vtype['power'] > t['power']:
        if method == 'explicit':
            if not no_warning_cast_data_loss:
                warning("casting with data loss", ti)

        else:
            error("casting with data loss", ti)
            rv = False

    if not rv:
        type_print(vtype)
        print(" -> ", end="")
        type_print(t)
        print()

    return rv



def value_cons_integer(v, t, ti, method):
    vtype = v['type']

    if type.is_generic_integer(vtype):
        # GenericInt -> Int
        check_power(vtype, t, method, ti)
        return do_cast_generic(v, t, ti)


    if method != 'explicit':
        info("cannot implicit cons Integer value", ti)
        return None


    if type.is_integer(vtype) or type.is_char(vtype):
        # (Int or Char) -> Int
        check_power(vtype, t, method, ti)
        return hlir_value_cast(v, t, ti)

    if type.is_float(vtype):
        # Float -> Int
        nv = hlir_value_cast(v, t, ti=ti)
        # need float imm int part check
        if value_is_immediate(v):
            imm_fltval = hlir_value_imm_get(v)
            imm_intval = int(imm_fltval)
            typ = hlir_type_generic_int_for(imm_intval, unsigned=True, ti=ti)
            check_power(typ, t, method, ti)
            hlir_value_set_imm(nv, imm_intval)

        return nv


    return None




def value_cons_float(v, t, ti, method):
    vt = v['type']

    if type.is_generic(vt):
        if type.is_integer(vt) or type.is_float(vt):
            # (GenericInt or GenericFloat) -> Float
            y = do_cast_generic(v, t, ti)
            num = hlir_value_imm_get(y)

            import struct

            z = 0
            if t['power'] == 32:
                z = struct.unpack('<f', struct.pack('<f', num))[0]
            elif t['power'] == 64:
                z = struct.unpack('<d', struct.pack('<d', num))[0]
            else:
                fatal("too big float, not implemented")

            hlir_value_set_imm(y, z)

            return y


    if method != 'explicit':
        info("cannot implicit cons Float value", ti)


    if type.is_integer(vt):
        # Int -> Float
        return hlir_value_cast(v, t, ti=ti)

    if type.is_float(vt):
        # Float -> Float
        return hlir_value_cast(v, t, ti=ti)


    return None




def value_cons_pointer(v, t, ti, method):
    vtype = v['type']
    to_type = t

    # Nil -> *X
    if type.is_nil(vtype):
        return do_cast_generic(v, t, ti)

    # GenericString -> (*[]CharX | *CharX)
    if type.is_generic_string(vtype):
        if type.is_ptr_to_arr_of_char(to_type) or type.is_ptr_to_char(to_type):

            char_type = None
            if type.is_ptr_to_char(to_type):
                char_type = to_type['to']
            elif type.is_ptr_to_arr_of_char(to_type):
                char_type = to_type['to']['of']

            str_used_as(string_value=v, typ=char_type)
            cv = hlir_value_cast(v, t, ti=ti)
            cv['att'].append("string-cons")
            from trans import module_strings_add
            module_strings_add(cv)
            return cv
            #return do_cast_generic(v, t, ti=ti) #?!


    # *[n]X -> *[]X
    if type.is_pointer_to_defined_array(vtype):
        if type.is_pointer_to_undefined_array(t):
            if type.eq(vtype['to']['of'], t['to']['of']):
                return hlir_value_cast(v, t, ti=ti)

    # Pointer -> *X
    if type.is_free_pointer(vtype):
        return hlir_value_cast(v, t, ti=ti)

    # *X -> Pointer
    if type.is_pointer(vtype):
        return hlir_value_cast(v, t, ti=ti)


    if method != 'explicit':
        info("cannot implicit cast different pointers", ti)
        return None

    if not 'unsafe' in features:
        info("explicit typecast to pointer is forbidden in safe mode", ti)
        return None

    ### UNSAFE REGION ###

    # Imm Int -> Pointer
    if value_is_immediate(v):
        if type.is_integer(v['type']):
            # compile-time casting
            nv = hlir_value_cast(v, t, ti=ti)
            num = hlir_value_imm_get(v)
            hlir_value_set_imm(nv, num)
            return nv

    # Int -> Ptr
    if type.is_integer(vtype):
        from trans import ptr_size
        if vtype['power'] != ptr_size:
            error("cons pointer from integer with different size", ti)
        return hlir_value_cast(v, t, ti=ti)

    # Ptr -> Ptr
    if type.is_pointer(vtype):
        return hlir_value_cast(v, t, ti=ti)

    # GenericString -> *CharX
    if type.is_generic_string(vtype):
        if type.is_char(to_type['to']):
            # GenericString -> *CharX
            str_used_as(string_value=v, typ=to_type['to'])
            return hlir_value_cast(v, t, ti=ti) #?!

    return None



def value_cons_unit(v, t, ti, method):
    if method != 'explicit':
        return None

    return hlir_value_cast(v, t, ti=ti)


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
    elif type.is_char(t): cons = value_cons_char
    elif type.is_unit(t): cons = value_cons_unit

    nv = None

    if cons != None:
        nv = cons(v, t, ti, method)

    # if construct immediate value
    if nv != None:
        if (cons == value_cons_integer) or (cons == value_cons_float)  or (cons == value_cons_pointer):
            if value_is_immediate(v):
                hlir_value_set_imm(nv, v['imm'])

    return nv




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
    to_type = t

    # implisit cast possible only for:
    # 1. Generic -> NonGeneric
    # 2. Nil -> AnyPointer
    # 3. *[n]T -> *[]T
    # 4. AnyPointer -> FreePointer
    # 5. FreePointer -> AnyPointer

    #if not type.is_generic(from_type):
    #    return v


    # потому что в C номинальные типы, а у нас - структурные
    if type.is_record(t):
        if type.is_record(from_type):
            if 'name' in from_type and 'name' in t:
                if from_type['name'] != t['name']:
                    #info("impl cast record", ti)
                    return hlir_value_cast(v, t, ti=ti)



    if type.is_pointer_to_record(t):
        if type.is_pointer_to_record(from_type):
            #info("impl cast pointer to record", ti)
            return hlir_value_cast(v, t, ti=ti)


    if type.eq(from_type, t):
        return v


    if type.is_generic(from_type):
        return value_soft_cast(v, t, ti)


    if type.is_pointer(t):

        # cons *[]X from *[n]X
        if type.is_pointer_to_defined_array(from_type) and type.is_pointer_to_undefined_array(t):
            return value_soft_cast(v, t, ti)


        # cons *X from Nil
        if type.is_nil(from_type) and type.is_pointer(t):
            return do_cast_generic(v, t, ti)


        # cons *X from FreePointer
        if type.is_free_pointer(from_type) and type.is_pointer(t):
            return hlir_value_cast(v, t, ti=ti)


        # cons FreePointer from *X
        if type.is_pointer(from_type) and type.is_free_pointer(t):
            return hlir_value_cast(v, t, ti=ti)


    return v



def value_cast_explicit(v, t, ti):
    if value_is_bad(v) or type.is_bad(t):
        return hlir_value_bad(ti)

    if type.eq(v['type'], t):
        info("explicit cast to the same type", ti)
        return v

    return value_hard_cast(v, t, ti)



