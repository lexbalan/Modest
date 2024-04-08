
import hlir.type as hlir_type
from hlir.type import select_common_type
from error import info, error
from .char import value_char
from .integer import value_integer
from .value import value_terminal, value_is_immediate, value_cons_node, value_cons_immediate, value_zero, value_bin, value_print



# TODO: переделай здесь все - тут все плохо...
# получает на вход список элементов
# конструирует и возвращает GenericArray value
def value_array_create(items, ti=None):
    length = len(items)
    if length == 0:
        return _create_value_array([], None, 0, True, ti)


    # Получаем наиболее подходящий общий тип элементов массива
    array_item_type = items[0]['type']

    is_immediate = True

    i = 0
    while i < length:
        item = items[i]

        if is_immediate:
            is_immediate = value_is_immediate(item)

        item_type = item['type']
        common_type = select_common_type(array_item_type, item_type)
        if common_type == None:
            error("value with unsuitable type", item['expr_ti'])
        else:
            array_item_type = common_type
        i = i + 1

#    info("ARR ITEM TYPE = ", ti)
#    hlir_type.type_print(array_item_type)

    # неявно приводим все элементы к этому типу
    casted_items = []

    from .cons import value_cons_implicit
    i = 0
    while i < length:
        item = items[i]
        casted_item = value_cons_implicit(item, array_item_type)

        if 'asset' in item:
            casted_item['asset'] = item['asset']

        if 'nl_end' in item:
            casted_item['nl_end'] = item['nl_end']

        casted_items.append(casted_item)
        i = i + 1


    v = _create_value_array(casted_items, array_item_type, length, True, ti)
    v['immediate'] = is_immediate  #TODO: need to implement 'immediate' flag
    return v


def value_cons_array_immediate(v, t, ti):
    info("value_cons_array_immediate", ti)
    # TODO
    return value_cons_immediate(v, t, ti)


# concatenation of two immediate arrays
def value_array_concat(l, r, ti):
    asset = l['asset'] + r['asset']
    length = len(asset) + 1  #!

    str_array_volume = value_integer_create(length)
    item_type = select_common_type(l['type']['of'], r['type']['of'])
    t = hlir_type.hlir_type_array(item_type, volume=str_array_volume, ti=ti)
    t['generic'] = True

    nv = value_bin('add_arr', l, r, t, ti=ti)
    nv['asset'] = asset
    nv['immediate'] = True
    nv['nl_end'] = r['nl_end']
    return nv



def value_string(string, length=0, ti=None):
    if length == 0:
        length = len(string) + 1

    max_char_width = 0
    chars = []
    for char in string:
        char_code = ord(char)
        char_value = value_char_create(char_code, _type=None, ti=ti)
        chars.append(char_value)

        # get max char width
        char_width = char_value['type']['width']
        max_char_width = max(char_width, max_char_width)


    # тип массива литерала строки
    # это наиболее широкий GenericChar в ней
    genericCharType = hlir_type.hlir_type_char(max_char_width, ti=ti)
    genericCharType['generic'] = True

    volume = value_integer_create(length)  # <=> len(string) + 1
    genStrType = hlir_type.hlir_type_array(genericCharType, volume=volume, ti=ti)
    genStrType['generic'] = True
    nv = value_terminal(genStrType, chars, ti)
    nv['immediate'] = True
    return nv




# TODO: массив может НЕЯВНО быть построен только из
# полного или из пустого дженерик массива
def value_cons_array_from_generic_array(v, t, ti, method):
    #info("value_cons_array_from_generic_array", ti)

    zero_pad = 0

    # проверяем длину
    if t['volume'] == None:
        info("cons open array", ti)


    elif len(v['asset']) > t['volume']['asset']:
        info("too many items", v['ti'])
        return None

    elif len(v['asset']) < t['volume']['asset']:
        zero_pad = t['volume']['asset'] - len(v['asset'])


    # in empty array literal type#of == None
    if v['type']['of'] != None:
        # check width
        if v['type']['of']['width'] > t['of']['width']:
            info("too big item width", ti)
            return None


    casted_items = []
    items = v['asset']
    for item in items:

#TODO: see: /test/sha256/src/main.cm:48:39:
# var sha256_tests: []*SHA256_TestCase = [&test0, &test1]
# Да не реализовано для локальных переменных, а в глоб контексте
# сейчас норм идут например указатели на глоб преременные
#        from value.value import value_is_immediate
#        if not value_is_immediate(item):
#            error("cons from not immediate item not implemented", ti)
#            return None

        if hlir_type.type_is_array_of_char(v['type']):
            char_code = item['asset']
            item = value_char_create(char_code, _type=None, ti=ti)

        from .cons import value_cons_implicit
        casted_item = value_cons_implicit(item, t['of'])
        if hlir_type.type_eq(t['of'], casted_item['type']):
            casted_item['nl'] = item['nl']
            casted_items.append(casted_item)
        else:
            if method == 'explicit':
                error("cannot construct value", ti)

        #hlir_type.check(t['of'], casted_item['type'], item['expr_ti'])

    casted_items = casted_items + [value_zero(t['of'])] * zero_pad

    nv = value_terminal(t, casted_items, ti)
    nv['nl_end'] = v['nl_end']

    if value_is_immediate(v):
        nv['immediate'] = True

    # если это не сделать то принтер C не сможет сослаться
    # на именованную константу и станет печатать ее по месту
    if 'id' in v:
        nv['id'] = v['id']

    return nv



# TODO: only for immediate array (!)
def value_cons_array_from_array(v, t, ti, method):
    # нельзя построить массив из массива другого типа
    if not hlir_type.type_eq(v['type']['of'], t['of']):
        return None


    # нельзя построить меньший массив из большего
    n_from = v['type']['volume']['asset']
    n_to = t['volume']['asset']
    if n_from > n_to:
        return None

    # если массив идет как непосредственное значение
    if 'asset' in v:
        n = n_to - n_from

        nv = value_cons_from_immediate(v, t, ti)

        # extend array with zero items
        padding = [value_zero(t['of'], ti=None)] * n
        nv['asset'].extend(padding)

        return nv

    # runtime cons
    return value_cons_node(v, t, ti=ti)



def value_cons_array(v, t, ti, method):
    #info("value_cons_array", ti)
    from_type = v['type']
    to_type = t


    if value_is_immediate(v):
        return value_cons_array_immediate(v, t, ti)

    # GenericArray -> Array
    if hlir_type.type_is_generic(from_type):
        return value_cons_array_from_generic_array(v, t, ti, method)

    if method != 'explicit':
        info("cannot implicitly cons Array value", ti)
        return None

    # Array -> Array
    if not hlir_type.type_eq(t['of'], v['type']['of']):
        error("cannot cons array from array with different item type", ti)
        return None

    return value_cons_array_from_array(v, t, ti, method)







def _create_value_array(items, item_type, length, is_generic, ti):
    array_volume = value_integer_create(length)
    array_type = hlir_type.hlir_type_array(item_type, volume=array_volume, ti=ti)
    array_type['generic'] = is_generic
    return value_terminal(array_type, items, ti)


