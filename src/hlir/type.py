
import copy
from error import info, warning, error, fatal
import settings


ptr_width = 0
flt_width = 0

def hlir_type_init():
    global ptr_width, flt_width
    ptr_width = int(settings.get('pointer_width'))
    flt_width = int(settings.get('float_width'))


from .id import hlir_id
from util import get_item_with_id, nbits_for_num, nbytes_for_bits


######################################################################
#                            HLIR TYPE                               #
######################################################################


CONS_OP = ['cast']
EQ_OPS = ['eq', 'ne']
RELATIONAL_OPS = ['lt', 'gt', 'le', 'ge']
ARITHMETICAL_OPS = ['add', 'sub', 'mul', 'div', 'rem', 'minus']
LOGICAL_OPS = ['or', 'xor', 'and', 'not']

INT_OPS = CONS_OP + EQ_OPS + RELATIONAL_OPS + ARITHMETICAL_OPS + LOGICAL_OPS
FLOAT_OPS = CONS_OP + EQ_OPS + RELATIONAL_OPS + ARITHMETICAL_OPS
BOOL_OPS = CONS_OP + EQ_OPS + LOGICAL_OPS
BYTE_OPS = CONS_OP + EQ_OPS + LOGICAL_OPS
CHAR_OPS = CONS_OP + EQ_OPS
ENUM_OPS = CONS_OP + EQ_OPS
PTR_OPS = CONS_OP + EQ_OPS + ['deref']
ARR_OPS = CONS_OP + EQ_OPS + ['add', 'index']
REC_OPS = CONS_OP + EQ_OPS + ['access']


def hlir_type_bad(ti=None):
    return {
        'isa': 'type',
        'kind': 'bad',
        'perfect': False,
        'width': 0,
        'size': 0,
        'align': 0,
        'declaration': None,
        'definition': None,
        'ops': [],
        'att': [],
        'ti': ti
    }


def hlir_type_unit():
    return {
        'isa': 'type',
        'kind': 'unit',
        'perfect': False,
        'width': 0,
        'size': 0,
        'align': 0,
        'declaration': None,
        'definition': None,
        'ops': CONS_OP,
        'att': [],
        'ti': None
    }


def hlir_type_bool():
    return {
        'isa': 'type',
        'kind': 'bool',
        'perfect': False,
        'width': 1,
        'size': 1,
        'align': 1,
        'declaration': None,
        'definition': None,
        'ops': BOOL_OPS,
        'att': [],
        'ti': None
    }



def hlir_type_char(width, ti=None):
    size = nbytes_for_bits(width)

    return {
        'isa': 'type',
        'kind': 'char',
        'perfect': False,
        'width': width,
        'size': size,
        'align': size,
        'declaration': None,
        'definition': None,
        'ops': CHAR_OPS,
        'att': [],
        'ti': ti
    }


def hlir_type_integer(width, signed=True, ti=None):
    size = nbytes_for_bits(width)
    return {
        'isa': 'type',
        'kind': 'int',
        'perfect': False,
        'width': width,
        'size': size,
        'align': size,
        'signed': signed,
        'declaration': None,
        'definition': None,
        'ops': INT_OPS,
        'att': [],
        'ti': ti
    }


def hlir_type_float(width, ti=None):
    size = nbytes_for_bits(width)
    return {
        'isa': 'type',
        'kind': 'float',
        'perfect': False,
        'width': width,
        'size': size,
        'align': size,
        'declaration': None,
        'definition': None,
        'ops': FLOAT_OPS,
        'att': [],
        'ti': ti
    }


def hlir_type_pointer(to, ti=None):
    size = nbytes_for_bits(ptr_width)
    return {
        'isa': 'type',
        'kind': 'pointer',
        'perfect': False,
        'width': ptr_width,
        'size': size,
        'align': size,
        'to': to,
        'declaration': None,
        'definition': None,
        'ops': PTR_OPS,
        'att': [],
        'ti': ti
    }


# size - always hlir_value (!)
def hlir_type_array(of, volume=None, ti=None):
    item_size = 0
    item_align = 0
    if of != None:
        item_size = type_get_size(of)
        item_align = type_get_align(of)

    array_size = 0
    if volume != None:
        array_size = item_size * volume['asset']

    return {
        'isa': 'type',
        'kind': 'array',
        'perfect': False,
        'width': 0, #'width': array_size * 8,
        'size': array_size,
        'align': item_align,
        'of': of,
        'volume': volume,
        'declaration': None,
        'definition': None,
        'ops': ARR_OPS,
        'att': [],
        'ti': ti
    }


enum_uid = 0
def hlir_type_enum(ti=None):
    enum_width = 32
    enum_size = nbytes_for_bits(enum_width)

    global enum_uid
    enum_uid = enum_uid + 1

    return {
        'isa': 'type',
        'kind': 'enum',
        'perfect': False,
        'width': enum_width,
        'size': enum_size,
        'align': enum_size,
        'items': [],
        'uid': enum_uid,
        'declaration': None,
        'definition': None,
        'ops': ENUM_OPS,
        'att': [],
        'ti': ti
    }


from util import align_to
def hlir_type_record(fields, ti=None):
    record_size = 0
    record_align = 0

    if fields != []:
        field_no = 0
        field_offset = 0
        for field in fields:
            field['field_no'] = field_no
            field['offset'] = record_size

            field_size = type_get_size(field['type'])
            field_align = type_get_align(field['type'])

            record_size = record_size + field_size
            record_align = max(record_align, field_align)

            field_no = field_no + 1

        # Afterall we need to align record_size to record_align (!)
        record_size = align_to(record_size, record_align)

    return {
        'isa': 'type',
        'kind': 'record',
        'perfect': False,
        'width': 0, #'width': record_size * 8,
        'size': record_size,
        'align': record_align,
        'fields': fields,
        'declaration': None,
        'definition': None,
        'ops': REC_OPS,
        'att': [],
        'ti': ti
    }


def hlir_type_func(params, to, var_args, va_list_id, ti=None):
    return {
        'isa': 'type',
        'kind': 'func',
        'perfect': False,
        'width': 0,
        'size': 0,
        'align': 0,

        'params': params,
        'to': to,

        'extra_args': var_args,
        'va_list_id': va_list_id,

        'declaration': None,
        'definition': None,
        'ops': [],
        'att': [],
        'ti': ti
    }


def hlir_type_opaque(id, ti=None):
    return {
        'isa': 'type',
        'kind': 'opaque',
        'perfect': False,
        'declaration': None,
        'definition': None,
        'ops': [],
        'att': [],
        'ti': ti
    }


def hlir_type_perfect_int_for(num, unsigned=False, ti=None):
    required_width = nbits_for_num(num)
    t = hlir_type_integer(width=required_width, ti=ti)
    t['perfect'] = True
    return t



def type_eq_integer(a, b, opt):
    if a['width'] != b['width']:
        return False

    if a['signed'] != b['signed']:
        return False

    return True



def type_eq_char(a, b, opt):
    if a['width'] != b['width']:
        return False

    return True


def type_eq_pointer(a, b, opt):
    return type_eq(a['to'], b['to'], opt)


def type_eq_array(a, b, opt):
    if a['volume'] == None or b['volume'] == None:
        if a['volume'] == None and b['volume'] == None:
            return type_eq(a['of'], b['of'], opt)
        return False

    if a['volume']['asset'] != b['volume']['asset']:
        return False

    if a['of'] == None or b['of'] == None:
        return a['of'] == None and b['of'] == None

    return type_eq(a['of'], b['of'], opt)


def type_eq_fields(a, b, opt):
    if len(a) != len(b): return False
    for ax, bx in zip(a, b):
        if ax['id']['str'] != bx['id']['str']: return False
        if not type_eq(ax['type'], bx['type'], opt): return False
    return True


def type_eq_func(a, b, opt):
    if not type_eq(a['to'], b['to'], opt): return False
    return type_eq_fields(a['params'], b['params'], opt)



def get_type_root_id(t):
    if t['definition'] != None:
        _def = t['definition']
        rd = get_type_root_id(_def['original_type'])

        if rd != None:
            return rd
        else:
            return _def['id']


    elif t['declaration'] != None:
        _decl = t['declaration']
        rd = get_type_root_id(_def['original_type'])

        if rd != None:
            return rd
        else:
            return _decl['id']

    else:
        return None


def type_eq_record(a, b, opt, nominative=False):
    if nominative:
        a_root_id = get_type_root_id(a)
        b_root_id = get_type_root_id(b)
        #print("A_ROOT: " + str(a_root_id))
        #print("B_ROOT: " + str(b_root_id))
        if a_root_id != None and b_root_id != None:
            if a_root_id['str'] != b_root_id['str']:
                return False
        elif a_root_id != None or b_root_id != None:
            return False

    if len(a['fields']) != len(b['fields']): return False
    return type_eq_fields(a['fields'], b['fields'], opt)


def type_eq_enum(a, b, opt, nominative=False):
    return a['uid'] == b['uid']


def type_eq_float(a, b, opt):
    return a['width'] == b['width']


def type_eq_opaque(a, b, opt):
    return a['id']['str'] == b['id']['str']  # maybe by UID?


def type_eq_alias(a, b, opt):
    return type_eq(a['of'], b['of'], opt)



def type_eq(a, b, opt=[]):
    # fast checking
    if a == b: return True
    if a['kind'] == 'bad' or b['kind'] == 'bad': return True
    if a['kind'] != b['kind']: return False

    #if a['definition'] != None and b['definition'] != None:

    # проверять аттрибуты (volatile, const)
    # использую для C чтобы можно было более строго проверить типы
    # напр для явного приведения в беканде C *volatile uint32_t -> uint32_t
    if 'att_checking' in opt:
        if a['att'] != b['att']:
            return False

    # дженерик и не дженерик типы не равны
    # это важно при конструировании записей из джененрков
    # в противном случае конструирование будет скипнуто (тк уже равны)
    if type_is_perfect(a) != type_is_perfect(b):
        return False

    # normal checking
    k = a['kind']
    if k == 'int': return type_eq_integer(a, b, opt)
    elif k == 'unit': return True
    elif k == 'bool': return True
    elif k == 'byte': return True
    elif k == 'func': return type_eq_func(a, b, opt)
    elif k == 'record': return type_eq_record(a, b, opt)
    elif k == 'pointer': return type_eq_pointer(a, b, opt)
    elif k == 'array': return type_eq_array(a, b, opt)
    elif k == 'enum': return type_eq_enum(a, b, opt)
    elif k == 'float': return type_eq_float(a, b, opt)
    elif k == 'char': return type_eq_char(a, b, opt)
    elif k == 'opaque': return type_eq_opaque(a, b, opt)
    elif k == 'va_list': print("UU"); return b['kind'] == 'va_list'
    return False



def check(a, b, ti):
    res = type_eq(a, b)
    if not res:
        error("type error", ti)
        type_print(a)
        print(" & ", end='')
        type_print(b)
        print()
    return res



def type_is_bad(t):
    return t['kind'] == 'bad'


def type_is_unit(t):
    return t['kind'] == 'unit'


def type_is_bool(t):
    return t['kind'] == 'bool'


def type_is_byte(t):
    return t['kind'] == 'byte'


def type_is_char(t):
    return t['kind'] == 'char'


def type_is_integer(t):
    return t['kind'] == 'int'


def type_is_float(t):
    return t['kind'] == 'float'


def type_is_func(t):
    return t['kind'] == 'func'


def type_is_enum(t):
    return t['kind'] == 'enum'


def type_is_record(t):
    return t['kind'] == 'record'


def type_is_array(t):
    return t['kind'] == 'array'


def type_is_pointer(t):
    return t['kind'] == 'pointer'


def type_is_opaque(t):
    return t['kind'] == 'opaque'


def type_is_va_list(t):
    return t['kind'] == 'va_list'



def type_is_perfect_char(t):
    return type_is_perfect(t) and type_is_char(t)


def type_is_perfect_integer(t):
    return type_is_perfect(t) and type_is_integer(t)


def type_is_perfect_record(t):
    return type_is_perfect(t) and type_is_record(t)


def type_is_perfect_array(t):
    return type_is_perfect(t) and type_is_array(t)


def type_is_perfect_array_of_char(t):
    if type_is_perfect_array(t):
        if t['of'] != None: # in case of empty array field #of == None
            return type_is_char(t['of'])

    return False



def type_is_defined_array(t):
    if type_is_array(t):
        return t['volume'] != None
    return False


def type_is_undefined_array(t):
    if type_is_array(t):
        return t['volume'] == None
    return False


def type_is_array_of_char(t):
    if type_is_array(t):
        return type_is_char(t['of'])
    return False


def type_is_free_pointer(t):
    if type_is_pointer(t):
        return type_is_unit(t['to'])
    return False


def type_is_pointer_to_record(t):
    if type_is_pointer(t):
        return type_is_record(t['to'])
    return False


def type_is_pointer_to_array(t):
    if type_is_pointer(t):
        return type_is_array(t['to'])
    return False


def type_is_pointer_to_defined_array(t):
    if type_is_pointer(t):
        return type_is_defined_array(t['to'])
    return False


def type_is_pointer_to_undefined_array(t):
    if type_is_pointer(t):
        return type_is_undefined_array(t['to'])
    return False


def type_is_pointer_to_array_of_char(t):
    if type_is_pointer(t):
        return type_is_array_of_char(t['to'])
    return False



def type_is_perfect(t):
    return t['perfect']



def type_is_signed(t):
    if 'signed' in t:
        return t['signed']
    return False


def type_is_unsigned(t):
    if 'signed' in t:
        return not t['signed']
    return False



# cannot create variable with type
def type_is_forbidden_var(t, zero_array_forbidden=True):
    if type_is_opaque(t) or type_is_unit(t) or type_is_func(t):
        return True

    if type_is_array(t):
        # [_]<Forbidden>
        if type_is_forbidden_var(t['of']):
            return True

        # []Int
        if type_is_undefined_array(t):
            return True

        # [0]Int
        from main import features
        from value.value import value_is_immediate
        if zero_array_forbidden or not features.get('unsafe'):
            if value_is_immediate(t['volume']):
                if t['volume']['asset'] == 0:
                    return True

        return type_is_forbidden_var(t['of'])


    return False




# TODO!
def type_attribute_add(t, a):
    t['att'].append(a)



# ищем поле с таким id в типе record
def record_field_get(t, id):
    return get_item_with_id(t['fields'], id)


# копирование типов следует использовать только в случае
# необходимости изменения его аттрибутов.
def type_copy(t):
    nt = copy.copy(t)
    # именно так!    иначе добавим в att t тк это ссылка на лист!
    # (!) создаем новый массив аттрибутов,
    # чтобы не испортить оригинальный (!)
    nt['att'] = []
    nt['att'].extend(t['att'])
    return nt



def type_get_size(t):
    return t['size']


def type_get_align(t):
    return t['align']


def array_root_item_type(t):
    assert(type_is_array(t))
    of = t['of']
    while type_is_array(of):
        of = of['of']
    return of





def print_list_by(lst, method):
    i = 0
    while i < len(lst):
        if i > 0:
            print(", ")
        method(lst[i])
        i = i + 1


def type_print(t, print_aka=True):

    if 'volatile' in t['att']:
        print("volatile_", end='')
    if 'const' in t['att']:
        print("const_", end='')

    k = t['kind']

    if print_aka:

        if t['definition'] != None:
            print(t['definition']['id']['str'])
            return

        elif t['declaration'] != None:
            print(t['declaration']['id']['str'])
            return

        """elif t['id'] != None:
            id_str = t['id']['str']

            if id_str == '<perfect:int>':
                id_str = 'Int'

            if type_is_perfect(t):
                print('Perfect', end='')

            print(id_str, end='')

            if type_is_perfect(t):
                if 'width' in t:
                    print('%d' % (t['width']), end='')

            return"""



    if type_is_record(t):
        if type_is_perfect_record(t):
            print("PerfectRecord {")
            for f in t['fields']:
                print("\t%s : " % f['id']['str'], end='')
                type_print(f['type'])
                print()
            print("}")
            return

        print("record {")
        fields = t['fields']
        i = 0
        while i < len(fields):
            field = fields[i]
            if i > 0:
                print(',')
            print("\n\t"); type_print(field['type'])

            i = i + 1
        print("\n}")

    elif type_is_enum(t):
        if t['id'] != None:
            print(t['id'], end='')
        print("enum_%s" % str(t['uid']), end='')

    elif type_is_pointer(t):
        print("*", end=''); type_print(t['to'])

    elif type_is_array(t):
        if t['of'] == None:
            print("PerfectEmptyArray", end='')
            return


        print("[", end='')
        array_size = t['volume']

        if array_size != None:
            sz = array_size['asset']
            print("%d" % sz, end='')

        print("]", end='')
        type_print(t['of'])

    elif type_is_func(t):
        print("(", end='')
        print_list_by(t['params'], lambda f: type_print(f['type']))
        print(")", end='')
        print(" -> ", end='')
        type_print(t['to'])

    elif type_is_integer(t):
        #print('integer' + t['id']['str'], end='')
        #if type_is_perfect(t):
        print('Integer_%d' % t['width'], end='')

    elif type_is_opaque(t):
        print('opaque', end='')

    else:
        print("<type:%s>" % k, end='')



