
import type
from error import error, warning, info
from hlir import *
from util import get_item_with_id
from .value import *



def value_cons_record_immediate(v, t, ti):
    info("value_cons_record_immediate", ti)
    return hlir_value_cast_immediate(v, t, ti)



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

            from .cons import value_cons_implicit
            item_value2 = value_cons_implicit(item_value, field_type, ti=item_value['ti'])

            type.check(field_type, item_value2['type'], item_value2)

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
        'imm': items,
        'type': t,
        'att': [],
        'nl_end': v['nl_end'],
        'ti': ti
    }


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

