
from error import info, warning, error
import hlir.type as type
from hlir.hlir import *
from hlir.type import record_field_get
from util import get_item_with_id
from .value import value_literal, value_literal, value_cast, value_zero




def value_record(typ, initializers=[], ti=None):
    return value_literal(typ, initializers, ti)




def value_cons_record_from_generic_record(v, t, ti, method):
    if v['kind'] == 'const':
        # TODO: тут нужно проверить чтобы при implicit методе
        # все поля присутствовали (!)

        #for field in t['fields']:
        #    print(field['id']['str'])

        return value_cast(v, t, ti=ti)

    """
    if len(v['asset']) == 0:
        #info("cons record from empty record", ti)
        vx = value_literal(t, [], ti)
        vx['nl_end'] = v['nl_end']
        return vx
    """

    #warning("value_cons_record_from_generic_record", ti)

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

            initializers = v['asset']
            ini = get_item_with_id(initializers, field_name)

            if ini == None:
                # no field, create zero value stub
                item_value = value_zero(field_type, ti=None)
                if method == 'implicit':
                    # implicit cast требует наличия всех полей
                    error("required field '%s'" % field_name, v['ti'])
                    return None  # это cast, а cast не выдает ошибки
                nl = prev_nl
                ti = None
            else:
                item_value = ini['value']
                nl = ini['nl']
                ti = ini['ti']

            prev_nl = nl

            from .cons import value_cons_implicit
            item_value2 = value_cons_implicit(item_value, field_type)

            type.check(field_type, item_value2['type'], item_value2)

            items.append({
                'isa': 'initizlizer',
                'id': field['id'],
                'value': item_value2,
                'att': [],
                'nl': nl,
                'ti': ti
            })


    vx = value_literal(t, items, ti)
    vx['nl_end'] = v['nl_end']

    # если это не сделать то принтер C не сможет сослаться
    # на именованную константу и станет печатать ее по месту
    if 'id' in v:
        vx['id'] = v['id']

    if 'nl' in v:
        vx['nl'] = v['nl']

    return vx




def value_cons_record_from_record(v, t, ti, method):
    return value_cast(v, t, ti=ti)



def value_cons_record(v, t, ti, method):
    from_type = v['type']

    if type.type_is_record(from_type):
        # GenericRecord -> Record  (implicit)
        if type.type_is_generic(from_type):
            return value_cons_record_from_generic_record(v, t, ti, method)

        if method != 'explicit':
            info("cannot implicitly cons Record value", ti)
            return None


        # check if all fields in from_type present in t
        # and their types are equal (!)
        for field in from_type['fields']:
            field2 = record_field_get(t, field['id']['str'])
            if field2 == None:
                return None  # if no field with that name
            if not type.type_eq(field['type'], field2['type']):
                return None  # if field type not equal

            #print(field['id']['str'])


        # Record -> Record (explicit)
        return value_cons_record_from_record(v, t, ti, method)

    return None


