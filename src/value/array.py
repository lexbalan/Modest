
import hlir.type as hlir_type
from hlir.type import select_common_type
from error import info, error
from .char import value_char
from .integer import value_integer
from .value import value_literal, value_is_immediate, value_cast, value_cast_immediate, value_zero, value_bin


def _value_array(items, item_type, length, ti):
    array_volume = value_integer(length)
    array_type = hlir_type.hlir_type_array(item_type, volume=array_volume, ti=ti)
    array_type['generic'] = True
    return value_literal(array_type, items, ti)


# TODO: переделай здесь все - тут все плохо...
def value_array(items, ti=None):
    length = len(items)
    if length == 0:
        return _value_array([], None, 0, ti)


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
        casted_items.append(casted_item)
        i = i + 1


    v = _value_array(casted_items, array_item_type, length, ti)
    #v['immediate'] = is_immediate  #TODO: need to implement 'immediate' flag
    return v



# concatenation of two immediate arrays
def value_array_concat(l, r, ti):
    imm_str = l['asset'] + r['asset']
    length = len(imm_str) + 1  #!

    str_array_volume = value_integer(length)
    item_type = select_common_type(l['type']['of'], r['type']['of'])
    t = hlir_type.hlir_type_array(item_type, volume=str_array_volume, ti=ti)
    t['generic'] = True

    bin_value = value_bin('add_arr', l, r, t, ti=ti)
    bin_value['asset'] = imm_str
    bin_value['nl_end'] = r['nl_end']
    return bin_value



def value_string(string, length=0, ti=None):
    if length == 0:
        length = len(string) + 1

    max_char_width = 0
    chars = []
    for char in string:
        char_code = ord(char)
        char = value_char(char_code, _type=None, ti=ti)
        chars.append(char)

        # get max char width
        char_width = char['type']['width']
        max_char_width = max(char_width, max_char_width)


    # тип массива литерала строки
    # это наиболее широкий GenericChar в ней
    genericCharType = hlir_type.hlir_type_char(max_char_width, ti=ti)
    genericCharType['generic'] = True

    vol = value_integer(length)  # <=> len(string) + 1
    genStrType = hlir_type.hlir_type_array(genericCharType, volume=vol, ti=ti)
    genStrType['generic'] = True

    # #imm of string literal is array of chars
    return value_literal(genStrType, chars, ti)




# TODO: массив может НЕЯВНО быть построен только из
# полного или из пустого дженерик массива
def value_cons_array_from_generic_array(v, t, ti, method):
    #info("value_cons_array_from_generic_array", ti)
    assert(hlir_type.type_is_generic_array(v['type']))

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
            item = value_char(char_code, _type=None, ti=ti)

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

    vx = value_literal(t, casted_items, ti)
    vx['nl_end'] = v['nl_end']


    # если это не сделать то принтер C не сможет сослаться
    # на именованную константу и станет печатать ее по месту
    if 'id' in v:
        vx['id'] = v['id']

    return vx



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
    if value_is_immediate(v):
        n = n_to - n_from

        nv = value_cons_from_immediate(v, t, ti)

        # extend array with zero items
        padding = [value_zero(t['of'], ti=None)] * n
        nv['asset'].extend(padding)

        return nv

    # runtime cons
    return value_cast(v, t, ti=ti)

    return None



def value_cons_array(v, t, ti, method):
    from_type = v['type']
    to_type = t

    if hlir_type.type_is_array(from_type):

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

    return None


