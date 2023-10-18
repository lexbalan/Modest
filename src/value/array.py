
import type
from error import error, warning, info
from hlir import *
from .value import *


# TODO: массив может НЕЯВНО быть построен только из
# полного или из пустого дженерик массива
def value_cons_array_from_generic_array(v, t, ti, method):
    #info("value_cons_array_from_generic_array", ti)
    if len(v['imm']) > t['volume']['imm']:
        info("too many items", v['ti'])
        return None

    casted_items = []
    items = v['imm']
    for item in items:
        from .cons import value_cons_implicit
        casted_item = value_cons_implicit(item, t['of'], item['ti'])
        type.check(t['of'], casted_item['type'], item['ti'])

        casted_item['nl'] = item['nl']
        casted_items.append(casted_item)

    vx = {
        'isa': 'value',
        'kind': 'literal',
        'imm': casted_items,
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
    if not type.eq(v['type']['of'], t['of']):
        return None

    # нельзя построить меньший массив из большего
    n_from = v['type']['volume']['imm']
    n_to = t['volume']['imm']
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



def value_cons_array_from_string(v, t, ti, method):
    from_type = v['type']
    to_type = t

    if not type.is_char(to_type['of']):
        return None

    #info("cast generic string to array", ti)

    # Check to:array volume vs string len
    # "xxx" to []X | "xxx" to [n]X
    if to_type['volume'] != None:
        to_arr_volume = to_type['volume']['imm']
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

    # GenericString -> Array
    if type.is_generic_string(from_type):
        return value_cons_array_from_string(v, t, ti, method)


    # GenericArray -> Array
    if type.is_array(from_type):
        if type.is_generic(from_type):
            return value_cons_array_from_generic_array(v, t, ti, method)
        return value_cons_array_from_array(v, t, ti, method)



    return None


