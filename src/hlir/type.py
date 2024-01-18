

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
BOOL_OPS = CONS_OP + EQ_OPS + LOGICAL_OPS
FLOAT_OPS = CONS_OP + EQ_OPS + RELATIONAL_OPS + ARITHMETICAL_OPS
CHAR_OPS = CONS_OP + EQ_OPS
PTR_OPS = CONS_OP + EQ_OPS + ['deref']
ARR_OPS = CONS_OP + EQ_OPS + ['add', 'index']
REC_OPS = CONS_OP + EQ_OPS + ['access']



def hlir_type_bad(ti=None):
    return {
        'isa': 'type',
        'kind': 'bad',
        'id': None,
        'generic': False,
        'width': 0,
        'size': 0,
        'align': 0,
        'att': [],
        'ops': [],
        'ti': ti
    }


def hlir_type_unit():
    return {
        'isa': 'type',
        'kind': 'unit',
        'id': hlir_id('Unit'),
        'generic': False,
        'width': 0,
        'size': 0,
        'align': 0,
        'c_alias': 'void',
        'llvm_alias': 'void',
        'att': [],
        'ops': CONS_OP,
        'ti': None
    }



def hlir_type_bool():
    return {
        'isa': 'type',
        'kind': 'bool',
        'id': hlir_id('Bool'),
        'generic': False,
        'width': 1,
        'size': 1,
        'align': 1,
        'c_alias': 'uint8_t',
        'llvm_alias': 'i1',
        'cm_alias': 'Bool',
        'ops': BOOL_OPS,
        'att': [],
        'ti': None
    }



def hlir_type_char(id_str, width, generic=False, ti=None):
    size = nbytes_for_bits(width)

    id = None
    if id_str != None:
        id = hlir_id(id_str)

    return {
        'isa': 'type',
        'kind': 'char',
        'id': id,
        'generic': generic,
        'width': width,
        'size': size,
        'align': size,
        'ops': CHAR_OPS,
        'att': [],
        'ti': ti
    }


def hlir_type_integer(id_str, width, generic=False, signed=True, ti=None):
    size = nbytes_for_bits(width)
    return {
        'isa': 'type',
        'kind': 'int',
        'id': hlir_id(id_str),
        'generic': generic,
        'width': width,
        'size': size,
        'align': size,
        'signed': signed,
        'ops': INT_OPS,
        'att': [],
        'ti': ti
    }



def hlir_type_float(id_str, width, ti=None):
    size = nbytes_for_bits(width)
    return {
        'isa': 'type',
        'kind': 'float',
        'id': hlir_id(id_str),
        'generic': False,
        'width': width,
        'size': size,
        'align': size,
        'c_alias': 'double',
        'ops': FLOAT_OPS,
        'att': [],
        'ti': ti
    }


def hlir_type_pointer(to, ti=None):
    size = nbytes_for_bits(ptr_width)
    return {
        'isa': 'type',
        'kind': 'pointer',
        'id': None,
        'generic': False,
        'width': ptr_width,
        'size': size,
        'align': size,
        'to': to,
        'ops': PTR_OPS,
        'att': [],
        'ti': ti
    }


# size - always hlir_value (!)
def hlir_type_array(of, volume=None, generic=False, ti=None):
    item_size = 0
    item_align = 0
    if of != None:
        item_size = type_get_size(of)
        item_align = type_get_align(of)

    array_size = 0
    if volume != None:
        array_size = item_size * volume['imm']

    return {
        'isa': 'type',
        'kind': 'array',
        'id': None,
        'generic': generic,
        'width': 0, #'width': array_size * 8,
        'size': array_size,
        'align': item_align,
        'of': of,
        'volume': volume,
        'ops': ARR_OPS,
        'att': [],
        'ti': ti
    }


from util import align_to
def hlir_type_record(fields, generic=False, ti=None):
    record_size = 0
    record_align = 0

    if not generic:
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
        'id': None,
        'generic': generic,
        'width': 0, #'width': record_size * 8,
        'size': record_size,
        'align': record_align,
        'fields': fields,
        'ops': REC_OPS,
        'att': [],
        'ti': ti
    }


# дефолт аргумент не работает!!!!
def hlir_type_func(params, to, ti=None):
    return {
        'isa': 'type',
        'kind': 'func',
        'id': None,
        'generic': False,
        'width': 0,
        'size': 0,
        'align': 0,
        'params': params,
        'to': to,
        'ops': [],
        'att': [],
        'ti': ti
    }


def hlir_type_opaque(id, ti=None):
    return {
        'isa': 'type',
        'kind': 'opaque',
        'id': id,
        'generic': False,
        'att': [],
        'ti': ti
    }





def hlir_type_generic_int_for(num, unsigned=False, ti=None):
    nbits = nbits_for_num(num)
    return hlir_type_integer(None, width=nbits, generic=True, ti=ti)




typeUnit = None
typeBool = None
typeChar8 = None
typeChar16 = None
typeChar32 = None
typeInt8 = None
typeInt16 = None
typeInt32 = None
typeInt64 = None
typeInt128 = None
typeNat8 = None
typeNat16 = None
typeNat32 = None
typeNat64 = None
typeNat128 = None
typeFloat16 = None
typeFloat32 = None
typeFloat64 = None
typeDecimal32 = None
typeDecimal64 = None
typeDecimal128 = None
typeStr8 = None
typeStr16 = None
typeStr32 = None
typeFreePointer = None
typeVA_List = None


def type_init():
    global typeUnit
    global typeBool
    global typeChar8, typeChar16, typeChar32
    global typeInt8, typeInt16, typeInt32, typeInt64, typeInt128
    global typeNat8, typeNat16, typeNat32, typeNat64, typeNat128
    global typeFloat16, typeFloat32, typeFloat64
    global typeDecimal32, typeDecimal64, typeDecimal128
    global typeStr8, typeStr16, typeStr32
    global typeFreePointer
    global typeVA_List


    typeUnit = hlir_type_unit()

    typeBool = hlir_type_bool()
    typeBool['c_alias'] = 'uint8_t'
    typeBool['llvm_alias'] = 'i1'

    #
    typeChar8 = hlir_type_char("Char8", width=8)
    typeChar8['c_alias'] = 'char'
    typeChar8['llvm_alias'] = 'i8'

    typeChar16 = hlir_type_char("Char16", width=16)
    typeChar16['c_alias'] = 'uint16_t'
    typeChar16['llvm_alias'] = 'i16'

    typeChar32 = hlir_type_char("Char32", width=32)
    typeChar32['c_alias'] = 'uint32_t'
    typeChar32['llvm_alias'] = 'i32'

    #
    typeInt8 = hlir_type_integer("Int8", width=8)
    typeInt8['c_alias'] = 'int8_t'
    typeInt8['llvm_alias'] = 'i8'

    typeInt16 = hlir_type_integer("Int16", width=16)
    typeInt16['c_alias'] = 'int16_t'
    typeInt16['llvm_alias'] = 'i16'

    typeInt32 = hlir_type_integer("Int32", width=32)
    typeInt32['c_alias'] = 'int32_t'
    typeInt32['llvm_alias'] = 'i32'

    typeInt64 = hlir_type_integer("Int64", width=64)
    typeInt64['c_alias'] = 'int64_t'
    typeInt64['llvm_alias'] = 'i64'

    typeInt128 = hlir_type_integer("Int128", width=128)
    typeInt128['c_alias'] = '__int128'
    typeInt128['llvm_alias'] = 'i128'

    #
    typeNat8 = hlir_type_integer("Nat8", width=8, signed=False)
    typeNat8['c_alias'] = 'uint8_t'
    typeNat8['llvm_alias'] = 'i8'

    typeNat16 = hlir_type_integer("Nat16", width=16, signed=False)
    typeNat16['c_alias'] = 'uint16_t'
    typeNat16['llvm_alias'] = 'i16'

    typeNat32 = hlir_type_integer("Nat32", width=32, signed=False)
    typeNat32['c_alias'] = 'uint32_t'
    typeNat32['llvm_alias'] = 'i32'

    typeNat64 = hlir_type_integer("Nat64", width=64, signed=False)
    typeNat64['c_alias'] = 'uint64_t'
    typeNat64['llvm_alias'] = 'i64'

    typeNat128 = hlir_type_integer("Nat128", width=128, signed=False)
    typeNat128['c_alias'] = 'unsigned __int128'
    typeNat128['llvm_alias'] = 'i128'

    #
    typeFloat16 = hlir_type_float('Float16', width=16)
    typeFloat16['c_alias'] = 'half'
    typeFloat16['llvm_alias'] = 'half'

    typeFloat32 = hlir_type_float('Float32', width=32)
    typeFloat32['c_alias'] = 'float'
    typeFloat32['llvm_alias'] = 'float'

    typeFloat64 = hlir_type_float('Float64', width=64)
    typeFloat64['c_alias'] = 'double'
    typeFloat64['llvm_alias'] = 'double'

    #
    typeDecimal32 = hlir_type_float('Decimal32', width=32)
    typeDecimal32['c_alias'] = '_Decimal32'
    typeDecimal32['llvm_alias'] = 'float'

    typeDecimal64 = hlir_type_float('Decimal64', width=64)
    typeDecimal64['c_alias'] = '_Decimal64'
    typeDecimal64['llvm_alias'] = 'double'

    typeDecimal128 = hlir_type_float('Decimal128', width=128)
    typeDecimal128['c_alias'] = '_Decimal128'
    typeDecimal128['llvm_alias'] = 'double'


    typeFreePointer = hlir_type_pointer(to=typeUnit)

    typeStr8 = hlir_type_array(of=typeChar8)
    typeStr16 = hlir_type_array(of=typeChar16)
    typeStr32 = hlir_type_array(of=typeChar32)


    typeVA_List = {
        'isa': 'type',
        'kind': 'VA_List',
        'id': None,
        'generic': False,
        'size': 0,
        'align': 1,
        'width': 0,
        'att': [],
        'ops': [],
        'ti': None
    }



def select_char(sz):
    t = None
    if sz <= 8: t = typeChar8
    elif sz <= 16: t = typeChar16
    else: t = typeChar32
    assert(t != None)
    return t


def select_int(sz):
    t = None
    if sz <= 8: t = typeInt8
    elif sz <= 16: t = typeInt16
    elif sz <= 32: t = typeInt32
    elif sz <= 64: t = typeInt64
    elif sz <= 128: t = typeInt128
    assert(t != None)
    return t


def select_nat(sz):
    t = None
    if sz <= 8: t = typeNat8
    elif sz <= 16: t = typeNat16
    elif sz <= 32: t = typeNat32
    elif sz <= 64: t = typeNat64
    elif sz <= 128: t = typeNat128
    assert(t != None)
    return t


def select_integer_type(sz, is_signed):
    if is_signed:
        if sz < 128:
            return select_int(sz + 1)
        else:
            return select_int(sz)
    return select_nat(sz)



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

    if a['volume']['imm'] != b['volume']['imm']:
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


def type_eq_record(a, b, opt):
    if len(a['fields']) != len(b['fields']): return False
    return type_eq_fields(a['fields'], b['fields'], opt)


def type_eq_float(a, b, opt):
    return a['width'] == b['width']


def type_eq_opaque(a, b, opt):
    return a['id']['str'] == b['id']['str']  # maybe by UID?


def type_eq_alias(a, b, opt):
    return type_eq(a['of'], b['of'], opt)



def type_eq(a, b, opt=[]):
    # fast checking
    if a == b: return True
    if a['kind'] == 'bad': return True
    if b['kind'] == 'bad': return True
    if a['kind'] != b['kind']: return False

    # проверять аттрибуты (volatile, const)
    # использую для C чтобы можно было более строго проверить типы
    # напр для явного приведения в беканде C *volatile uint32_t -> uint32_t
    if 'att_checking' in opt:
        if a['att'] != b['att']:
            return False

    # дженерик и не дженерик типы не равны
    # это важно при конструировании записей из джененрков
    # в противном случае конструирование будет скипнуто (тк уже равны)
    if type_is_generic(a) != type_is_generic(b):
        return False

    # normal checking
    k = a['kind']
    if k == 'int': return type_eq_integer(a, b, opt)
    elif k == 'unit': return True
    elif k == 'bool': return True
    elif k == 'func': return type_eq_func(a, b, opt)
    elif k == 'record': return type_eq_record(a, b, opt)
    elif k == 'pointer': return type_eq_pointer(a, b, opt)
    elif k == 'array': return type_eq_array(a, b, opt)
    elif k == 'float': return type_eq_float(a, b, opt)
    elif k == 'char': return type_eq_char(a, b, opt)
    elif k == 'opaque': return type_eq_opaque(a, b, opt)
    elif k == 'VA_List': print("UU"); return b['kind'] == 'VA_List'
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



def type_attribute_add(t, a):
    t['att'].append(a)



def type_is_bad(t):
    return t['kind'] == 'bad'


def type_is_generic(t):
    return t['generic']


def type_is_unit(t):
    return t['kind'] == 'unit'


def type_is_bool(t):
    return t['kind'] == 'bool'


def type_is_char(t):
    return t['kind'] == 'char'


def type_is_integer(t):
    return t['kind'] == 'int'


def type_is_float(t):
    return t['kind'] == 'float'


def type_is_func(t):
    return t['kind'] == 'func'


def type_is_record(t):
    return t['kind'] == 'record'


def type_is_array(t):
    return t['kind'] == 'array'


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


def type_is_enum(t):
    return t['kind'] == 'enum'


def type_is_pointer(t):
    return t['kind'] in ['pointer']


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


def type_is_opaque(t):
    return t['kind'] == 'opaque'


def type_is_generic_char(t):
    return type_is_generic(t) and type_is_char(t)


def type_is_generic_integer(t):
    return type_is_generic(t) and type_is_integer(t)


def type_is_generic_record(t):
    return type_is_generic(t) and type_is_record(t)


def type_is_generic_array(t):
    return type_is_generic(t) and type_is_array(t)


def type_is_generic_array_of_char(t):
    if type_is_generic_array(t):
        if t['of'] != None: #!
            return type_is_char(t['of'])

    return False



def type_is_alias(t):
    return 'alias' in t['att']


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
    if type_is_opaque(t) or type_is_unit(t):
        return True

    # [0]Int, []Int, [n]<Forbidden>
    if type_is_undefined_array(t):
        # is undefined array?
        if t['volume'] == None:
            return True

        # is defined array;
        # It can't be 0 sized (can only with 'unsafe' compiler flag)
        from main import features
        if zero_array_forbidden or not features.get('unsafe'):
            if t['volume']['imm'] == 0:
                return True

        return type_is_forbidden_var(t['of'])

    if type_is_func(t):
        return True


    return False



def type_is_va_list(t):
    return t['kind'] == 'VA_List'


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


def create_alias(id_str, t, ti):
    #info('type.create_alias ' + id, ti)
    nt = type_copy(t)

    nt['id'] = hlir_id(id_str, ti=ti)

    if 'c_alias' in nt:
        del nt['c_alias']

    nt['att'].append('alias')
    nt['aliasof'] = t
    nt['ti'] = ti

    return nt



def type_get_size(t):
    return t['size']


def type_get_align(t):
    return t['align']


def array_root_item_type(ta):
    array_of = ta['of']
    while type_is_array(array_of):
        array_of = array_of['of']
    return array_of



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
        if t['id'] != None:
            id_str = t['id']['str']

            if id_str == '<generic:int>':
                id_str = 'Int'

            if type_is_generic(t):
                print('Generic', end='')

            print(id_str, end='')

            if type_is_generic(t):
                if 'width' in t:
                    print('%d' % (t['width']), end='')

            return

    if type_is_record(t):
        if type_is_generic_record(t):
            print("GenericRecord {")
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
        print("enum", end='')

    elif type_is_pointer(t):
        print("*", end=''); type_print(t['to'])

    elif type_is_array(t):
        if t['of'] == None:
            print("GenericEmptyArray", end='')
            return


        print("[", end='')
        array_size = t['volume']

        if array_size != None:
            sz = array_size['imm']
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
        print('%' + t['id']['str'], end='')
        if type_is_generic(t):
            print('%d' % t['width'], end='')

    elif type_is_opaque(t):
        print('opaque', end='')

    else:
        print("<type:%s>" % k, end='')



