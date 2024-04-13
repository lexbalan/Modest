
from error import info, warning, error
import hlir.type as type
from hlir.hlir import *
from hlir.field import hlir_field
from hlir.type import record_field_get
from util import get_item_with_id
from .value import value_terminal, value_terminal, value_cons_node, value_zero, value_is_immediate, value_print, value_cons_immediate


# получает на вход список инициализаторов
# конструирует и возвращает GenericRecord value
def value_record_create(initializers=[], ti=None):
    # структура метится как immediate только когда все ее поля immediate
    is_immediate = True

    # сперва пройдемся по инициализаторам
    # и выясним какие поля у нас тут есть
    # (для того чтобы сконструировать тип записи)
    fields = []
    for initializer in initializers:
        field_id = initializer['id']
        init_value = initializer['value']
        field_type = init_value['type']
        field_ti = init_value['ti']

        if is_immediate:
            is_immediate = value_is_immediate(init_value)

        # создаем поле для generic record
        field = hlir_field(field_id, field_type, ti=field_ti)
        fields.append(field)


    record_type = type.hlir_type_record(fields, ti)
    record_type['generic'] = True

    v = value_terminal(record_type, initializers, ti)
    v['immediate'] = is_immediate
    return v





def cons_initializers(initializers, rec_type, method):
    from value.cons import value_cons, value_cons_implicit
    import copy

    initializers2 = []
    for initializer in initializers:
        field_id = initializer['id']
        init_value = initializer['value']
        # получаем поле с таким именем
        f = get_item_with_id(rec_type['fields'], field_id['str'])

        # приводим инициализатор к типу поля
        #iv = value_cons_implicit(init_value, f['type'])
        iv = value_cons(init_value, f['type'], init_value['expr_ti'], method)

        ni = copy.copy(initializer)
        ni['value'] = iv
        initializers2.append(ni)

    return initializers2



#def value_cons_record_immediate(v, t, ti, method):
#    info("value_cons_record_immediate", ti)

#    return value_cons_record_from_generic_record(v, t, ti, method)

    """# TODO
    #assets = []
    from value.cons import value_cons, value_cons_implicit
    import copy

    #initializers = cons_initializers(v['asset'], t, method)

    initializers = []
    for initializer in v['asset']:
        field_id = initializer['id']
        init_value = initializer['value']
        # получаем поле с таким именем
        f = get_item_with_id(t['fields'], field_id['str'])

        # приводим инициализатор к типу поля
        #iv = value_cons_implicit(init_value, f['type'])
        iv = value_cons(init_value, f['type'], init_value['expr_ti'], method)

        info("cons to", v['expr_ti'])
        type.type_print(f['type'])

        ni = copy.copy(initializer)
        ni['value'] = iv
        initializers.append(ni)

    nv = value_cons_immediate(v, t, ti)
    nv['asset'] = initializers

    #from hlir.type import type_print
    #type_print(nv['type'])

    return nv"""


def value_cons_record_from_generic_record(v, t, ti, method):
    #if v['kind'] == 'const':
        # TODO: тут нужно проверить чтобы при implicit методе
        # все поля присутствовали (!)

        #for field in t['fields']:
        #    print(field['id']['str'])

     #   return value_cons_node(v, t, ti=ti)


    warning("value_cons_record_from_generic_record", ti)

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

            #if not 'asset' in v:
            #    value_print(v)

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

            from .cons import value_cons
            item_value2 = value_cons(item_value, field_type, v['expr_ti'], method)

            type.check(field_type, item_value2['type'], item_value2)

            p = hlir_initializer(field['id'], item_value2, ti=ti, nl=nl)
            items.append(p)


    nv = value_terminal(t, items, ti)

    #items = cons_initializers(v['asset'], t, method)
    #nv['asset'] = initializers

    if 'nl_end' in v: #FIXIT: nl_end должен быть взде!
        nv['nl_end'] = v['nl_end']

    if value_is_immediate(v):
        nv['immediate'] = True

    # если это не сделать то принтер C не сможет сослаться
    # на именованную константу и станет печатать ее по месту
    if 'id' in v:
        nv['id'] = v['id']

    if 'nl' in v:
        nv['nl'] = v['nl']

    return nv




def value_cons_record_from_record(v, t, ti, method):
    return value_cons_node(v, t, ti=ti)



def value_cons_record(v, t, ti, method):
    from_type = v['type']

    #if value_is_immediate(v):
    #    return value_cons_record_immediate(v, t, ti, method)

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


