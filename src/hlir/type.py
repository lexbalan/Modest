

import copy
from error import info, warning, error, fatal
from hlir.hlir import *
from util import get_item_with_id


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


    typeFreePointer = hlir_type_free_pointer()

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
    return copy.copy(t)


def select_int(sz):
    t = None
    if sz <= 8: t = typeInt8
    elif sz <= 16: t = typeInt16
    elif sz <= 32: t = typeInt32
    elif sz <= 64: t = typeInt64
    elif sz <= 128: t = typeInt128
    return copy.copy(t)


def select_nat(sz):
    t = None
    if sz <= 8: t = typeNat8
    elif sz <= 16: t = typeNat16
    elif sz <= 32: t = typeNat32
    elif sz <= 64: t = typeNat64
    elif sz <= 128: t = typeNat128
    return copy.copy(t)


def select_integer_type(sz, is_signed):
    if is_signed:
        if sz < 128:
            return select_int(sz + 1)
        else:
            return select_int(sz)
    return select_nat(sz)



def eq_integer(a, b, opt):
    if a['width'] != b['width']:
        return False

    if is_integer_signed(a) != is_integer_signed(b):
        return False

    return True



def eq_char(a, b, opt):
    if a['width'] != b['width']:
        return False

    return True


def eq_pointer(a, b, opt):
    return eq(a['to'], b['to'], opt)


def eq_array(a, b, opt):
    if a['volume'] == None or b['volume'] == None:
        if a['volume'] == None and b['volume'] == None:
            return eq(a['of'], b['of'], opt)
        return False

    if a['volume']['imm'] != b['volume']['imm']:
        return False

    if a['of'] == None or b['of'] == None:
        return a['of'] == None and b['of'] == None

    return eq(a['of'], b['of'], opt)


def eq_fields(a, b, opt):
    if len(a) != len(b): return False
    for ax, bx in zip(a, b):
        if ax['id']['str'] != bx['id']['str']: return False
        if not eq(ax['type'], bx['type'], opt): return False
    return True


def eq_func(a, b, opt):
    if not eq(a['to'], b['to'], opt): return False
    return eq_fields(a['params'], b['params'], opt)


def eq_record(a, b, opt):
    if len(a['fields']) != len(b['fields']): return False
    return eq_fields(a['fields'], b['fields'], opt)


def eq_float(a, b, opt):
    return a['width'] == b['width']


def eq_opaque(a, b, opt):
    return a['id']['str'] == b['id']['str']  # maybe by UID?


def eq_alias(a, b, opt):
    return eq(a['of'], b['of'], opt)



def eq(a, b, opt=[]):
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
    if is_generic(a) != is_generic(b):
        return False

    # normal checking
    k = a['kind']
    if k == 'int': return eq_integer(a, b, opt)
    elif k == 'unit': return True
    elif k == 'func': return eq_func(a, b, opt)
    elif k == 'record': return eq_record(a, b, opt)
    elif k == 'pointer': return eq_pointer(a, b, opt)
    elif k == 'bool': return True
    elif k == 'array': return eq_array(a, b, opt)
    elif k == 'float': return eq_float(a, b, opt)
    elif k == 'char': return eq_char(a, b, opt)
    elif k == 'opaque': return eq_opaque(a, b, opt)
    elif k == 'VA_List': print("UU"); return b['kind'] == 'VA_List'

    return False



def check(a, b, ti):
    res = eq(a, b)
    if not res:
        error("type error", ti)
        type_print(a)
        print(" & ", end='')
        type_print(b)
        print()
    return res



def type_attribute_add(t, a):
    t['att'].append(a)



def is_bad(t):
    assert t != None
    return t['kind'] == 'bad'


def is_generic(t):
    return t['generic']


def is_unit(t):
    return t['kind'] == 'unit'


def is_enum(t):
    return t['kind'] == 'enum'


def is_bool(t):
    return t['kind'] == 'bool'


def is_char(t):
    return t['kind'] == 'char'


def is_float(t):
    return t['kind'] == 'float'


def is_integer(t):
    return t['kind'] == 'int'


def is_integer_signed(t):
    if is_integer(t):
        return t['signed']
    return False


def is_integer_unsigned(t):
    if is_integer(t):
        return not t['signed']
    return False


def is_func(t):
    return t['kind'] == 'func'


def is_record(t):
    return t['kind'] == 'record'


def is_array(t):
    return t['kind'] == 'array'


def is_defined_array(t):
    if is_array(t):
        return t['volume'] != None
    return False


def is_undefined_array(t):
    if is_array(t):
        return t['volume'] == None
    return False


def is_array_of_char(t):
    if not is_array(t):
        return False
    return is_char(t['of'])


def is_string(t):
    return is_array_of_char(t)


def is_pointer(t):
    return t['kind'] in ['pointer', 'FreePointer', 'Nil']


def is_free_pointer(t):
    return t['kind'] == 'FreePointer'


def is_pointer_to_record(t):
    if is_pointer(t):
        return is_record(t['to'])
    return False


def is_pointer_to_array(t):
    if is_pointer(t):
        return is_array(t['to'])
    return False


def is_pointer_to_defined_array(t):
    if is_pointer(t):
        return is_defined_array(t['to'])
    return False


def is_pointer_to_undefined_array(t):
    if is_pointer(t):
        return is_undefined_array(t['to'])
    return False


def is_pointer_to_string(t):
    if is_pointer(t):
        return is_string(t['to'])
    return False


def is_nil(t):
    return t['kind'] == 'Nil'


def is_opaque(t):
    return t['kind'] == 'opaque'



def is_generic_char(t):
    return is_generic(t) and is_char(t)


def is_generic_integer(t):
    return is_generic(t) and is_integer(t)


def is_generic_record(t):
    return is_generic(t) and is_record(t)


def is_generic_array(t):
    return is_generic(t) and is_array(t)


def is_generic_string(t):
    if is_generic_array(t):
        if t['of'] != None: #!
            return is_char(t['of'])

    return False



def is_alias(t):
    return 'alias' in t['att']



# cannot create variable with type
def is_forbidden_var(t, zero_array_forbidden=True):
    if is_opaque(t) or is_unit(t):
        return True

    # [0]Int, []Int, [n]<Forbidden>
    if is_undefined_array(t):
        # is undefined array?
        if t['volume'] == None:
            return True

        # is defined array;
        # It can't be 0 sized (can only with 'unsafe' compiler flag)
        from main import features
        if zero_array_forbidden or not features.get('unsafe'):
            if t['volume']['imm'] == 0:
                return True

        return is_forbidden_var(t['of'])

    if is_func(t):
        return True


    return False



def is_va_list(t):
    return t['kind'] == 'VA_List'


# ищем поле с таким id в типе record
def record_field_get(t, id):
    return get_item_with_id(t['fields'], id)



def type_copy(t):
    nt = copy.copy(t)

    # именно так!    иначе добавим в att t тк это ссылка на лист!
    # (!) создаем новый массив аттрибутов,
    # чтобы не испортить оригинальный (!)
    nt['att'] = []

    nt['att'].extend(t['att'])
    #nt['classes'].extend(t['classes'])

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


def defined_array_item_type(ta):
    array_of = ta['of']
    while is_array(array_of):
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

            if is_generic(t):
                print('Generic', end='')

            print(id_str, end='')

            if is_generic(t):
                if 'width' in t:
                    print('%d' % (t['width']), end='')

            return

    if is_record(t):
        if is_generic_record(t):
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

    elif is_enum(t):
        print("enum", end='')

    elif is_pointer(t):
        print("*", end=''); type_print(t['to'])

    elif is_array(t):
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

    elif is_func(t):
        print("(", end='')
        print_list_by(t['params'], lambda f: type_print(f['type']))
        print(")", end='')
        print(" -> ", end='')
        type_print(t['to'])

    elif is_integer(t):
        print('%' + t['id']['str'], end='')
        if is_generic(t):
            print('%d' % t['width'], end='')

    elif is_opaque(t):
        print('opaque', end='')

    else:
        print("<type:%s>" % k, end='')


