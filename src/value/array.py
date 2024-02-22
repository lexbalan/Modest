
import hlir.type as type
from error import error, warning, info
from hlir.value import hlir_value_cast, hlir_value_cast_immediate, hlir_value_char, hlir_value_zero

from .value import *



# TODO: массив может НЕЯВНО быть построен только из
# полного или из пустого дженерик массива
def value_cons_array_from_generic_array(v, t, ti, method):
    #info("value_cons_array_from_generic_array", ti)
    assert(type.type_is_generic_array(v['type']))

    zero_pad = 0

    # проверяем длину
    if t['volume'] == None:
        info("cons open array", ti)

    elif len(v['asset']) > t['volume']['asset']:
        info("too many items", v['ti'])
        return None

    elif len(v['asset']) < t['volume']['asset']:
        zero_pad = t['volume']['asset'] - len(v['asset'])


    # check width
    if v['type']['of']['width'] > t['of']['width']:
        info("too big item width", ti)
        return None


    casted_items = []
    items = v['asset']
    for item in items:

        from value.value import value_is_immediate
        if not value_is_immediate(item):
            error("cons from not immediate item not implemented", ti)
            return None

        if type.type_is_array_of_char(v['type']):
            char_code = item['asset']
            item = hlir_value_char(char_code, type=None, ti=ti)

        from .cons import value_cons_implicit
        casted_item = value_cons_implicit(item, t['of'], item['ti'])
        type.check(t['of'], casted_item['type'], item['ti'])

        casted_item['nl'] = item['nl']
        casted_items.append(casted_item)


    casted_items = casted_items + [hlir_value_zero(t['of'])] * zero_pad

    vx = {
        'isa': 'value',
        'kind': 'literal',
        'asset': casted_items,
        'type': t,
        'att': [],
        'nl_end': v['nl_end'],
        'ti': ti
    }

    # если это не сделать то принтер C не сможет сослаться
    # на именованную константу и станет печатать ее по месту
    if 'id' in v:
        vx['id'] = v['id']

    return vx



# TODO: only for immediate array (!)
def value_cons_array_from_array(v, t, ti, method):
    # нельзя построить массив из массива другого типа
    if not type.type_eq(v['type']['of'], t['of']):
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
        padding = [hlir_value_zero(t['of'], ti=None)] * n
        nv['asset'].extend(padding)

        return nv

    # runtime cons
    return hlir_value_cast(v, t, ti=ti)

    return None



def value_cons_array(v, t, ti, method):
    from_type = v['type']
    to_type = t

    if type.type_is_array(from_type):

        # GenericArray -> Array
        if type.type_is_generic(from_type):
            return value_cons_array_from_generic_array(v, t, ti, method)

        if method != 'explicit':
            info("cannot implicit cons Array value", ti)
            return None

        # Array -> Array
        if not type.type_eq(t['of'], v['type']['of']):
            error("cannot cons array from array with different item type", ti)
            return None

        return value_cons_array_from_array(v, t, ti, method)

    return None


