
import hlir.type as type
from error import error, warning, info
from hlir.hlir import *
from .value import *



def value_cons_array_immediate(v, t, ti):
    info("value_cons_array_immediate", ti)
    return hlir_value_cast_immediate(v, t, ti)




# TODO: массив может НЕЯВНО быть построен только из
# полного или из пустого дженерик массива
def value_cons_array_from_generic_array(v, t, ti, method):
    #info("value_cons_array_from_generic_array", ti)

    pad = 0

    if t['volume'] == None:
        info("cons open array", ti)

    elif len(v['imm']) > t['volume']['imm']:
        info("too many items", v['ti'])
        return None

    elif len(v['imm']) < t['volume']['imm']:
        pad = t['volume']['imm'] - len(v['imm'])


    casted_items = []
    items = v['imm']
    for item in items:

        if type.is_string(v['type']):
            char_code = item
            item = hlir_value_char(char_code, type=None, ti=ti)

        from .cons import value_cons_implicit
        casted_item = value_cons_implicit(item, t['of'], item['ti'])
        type.check(t['of'], casted_item['type'], item['ti'])

        casted_item['nl'] = item['nl']
        casted_items.append(casted_item)


    casted_items = casted_items + [hlir_value_zero(t['of'])] * pad

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

        nv = value_cons_from_immediate(v, t, ti)

        # extend array with zero items
        padding = [hlir_value_zero(t['of'], ti=None)] * n
        nv['imm'].extend(padding)

        return nv

    return None


def value_cons_array(v, t, ti, method):
    from_type = v['type']
    to_type = t

    # GenericString -> Array
    if type.is_generic_string(from_type):
        return value_cons_array_from_generic_array(v, t, ti, method)

    # GenericArray -> Array
    elif type.is_array(from_type):
        if type.is_generic(from_type):
            return value_cons_array_from_generic_array(v, t, ti, method)
        return value_cons_array_from_array(v, t, ti, method)

    return None


