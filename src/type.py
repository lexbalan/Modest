

import copy
from error import info, warning, error, fatal
from hlir import *
from util import get_item_with_id


typeUnit = None
typeBool = None
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
typeGenericChar = None
typeChar8 = None
typeChar16 = None
typeChar32 = None
typeGenericString = None
typeStr8 = None
typeStr16 = None
typeStr32 = None
typeFreePtr = None
typeNil = None

def type_init():
    global typeUnit, typeBool
    global typeInt8, typeInt16, typeInt32, typeInt64, typeInt128
    global typeNat8, typeNat16, typeNat32, typeNat64, typeNat128
    global typeFloat16, typeFloat32, typeFloat64
    global typeDecimal32, typeDecimal64, typeDecimal128
    global typeGenericChar, typeChar8, typeChar16, typeChar32
    global typeGenericString, typeStr8, typeStr16, typeStr32
    global typeFreePtr, typeNil

    typeUnit = hlir_type_unit()

    typeInt8 = hlir_type_integer("Int8", power=8, ti=None)
    typeInt8['signed'] = True
    typeInt8['c_alias'] = 'int8_t'
    typeInt8['llvm_alias'] = 'i8'

    typeInt16 = hlir_type_integer("Int16", power=16, ti=None)
    typeInt16['signed'] = True
    typeInt16['c_alias'] = 'int16_t'
    typeInt16['llvm_alias'] = 'i16'

    typeInt32 = hlir_type_integer("Int32", power=32, ti=None)
    typeInt32['signed'] = True
    typeInt32['c_alias'] = 'int32_t'
    typeInt32['llvm_alias'] = 'i32'

    typeInt64 = hlir_type_integer("Int64", power=64, ti=None)
    typeInt64['signed'] = True
    typeInt64['c_alias'] = 'int64_t'
    typeInt64['llvm_alias'] = 'i64'

    typeInt128 = hlir_type_integer("Int128", power=128, ti=None)
    typeInt128['signed'] = True
    typeInt128['c_alias'] = '__int128'
    typeInt128['llvm_alias'] = 'i128'


    typeBool = hlir_type_bool(ti=None)
    typeBool['c_alias'] = 'uint8_t'
    typeBool['llvm_alias'] = 'i1'

    typeNat8 = hlir_type_integer("Nat8", power=8, ti=None)

    typeNat8['c_alias'] = 'uint8_t'
    typeNat8['unsigned'] = True
    typeNat8['llvm_alias'] = 'i8'

    typeNat16 = hlir_type_integer("Nat16", power=16, ti=None)
    typeNat16['unsigned'] = True
    typeNat16['c_alias'] = 'uint16_t'
    typeNat16['llvm_alias'] = 'i16'

    typeNat32 = hlir_type_integer("Nat32", power=32, ti=None)
    typeNat32['unsigned'] = True
    typeNat32['c_alias'] = 'uint32_t'
    typeNat32['llvm_alias'] = 'i32'

    typeNat64 = hlir_type_integer("Nat64", power=64, ti=None)
    typeNat64['unsigned'] = True
    typeNat64['c_alias'] = 'uint64_t'
    typeNat64['llvm_alias'] = 'i64'

    typeNat128 = hlir_type_integer("Nat128", power=128, ti=None)
    typeNat128['unsigned'] = True
    typeNat128['c_alias'] = 'unsigned __int128'
    typeNat128['llvm_alias'] = 'i128'


    typeFloat16 = hlir_type_float('Float16', power=16, ti=None)
    typeFloat16['c_alias'] = 'half'
    typeFloat16['llvm_alias'] = 'half'

    typeFloat32 = hlir_type_float('Float32', power=32, ti=None)
    typeFloat32['c_alias'] = 'float'
    typeFloat32['llvm_alias'] = 'float'

    typeFloat64 = hlir_type_float('Float64', power=64, ti=None)
    typeFloat64['c_alias'] = 'double'
    typeFloat64['llvm_alias'] = 'double'


    typeDecimal32 = hlir_type_float('Decimal32', power=32, ti=None)
    typeDecimal32['classes'].extend(['float', 'decimal'])
    typeDecimal32['c_alias'] = '_Decimal32'
    typeDecimal32['llvm_alias'] = 'float'

    typeDecimal64 = hlir_type_float('Decimal64', power=64, ti=None)
    typeDecimal64['classes'].extend(['float', 'decimal'])
    typeDecimal64['c_alias'] = '_Decimal64'
    typeDecimal64['llvm_alias'] = 'double'

    typeDecimal128 = hlir_type_float('Decimal128', power=128, ti=None)
    typeDecimal128['classes'].extend(['float', 'decimal'])
    typeDecimal128['c_alias'] = '_Decimal128'
    typeDecimal128['llvm_alias'] = 'double'


    typeGenericChar = hlir_type_generic_char(power=0, ti=None)


    typeChar8 = hlir_type_char("Char8", power=8, ti=None)
    typeChar8['c_alias'] = 'char' #'uint8_t'
    typeChar8['llvm_alias'] = 'i8'

    typeChar16 = hlir_type_char("Char16", power=16, ti=None)
    typeChar16['c_alias'] = 'uint16_t'
    typeChar16['llvm_alias'] = 'i16'

    typeChar32 = hlir_type_char("Char32", power=32, ti=None)
    typeChar32['c_alias'] = 'uint32_t'
    typeChar32['llvm_alias'] = 'i32'

    """typeGenericString = hlir_type_generic_str(ti=None)
    typeGenericString['cm_alias'] = 'String'
    typeGenericString['c_alias'] = 'const char *'
    typeGenericString['llvm_alias'] = 'i8*'"""

    typeStr8 = hlir_type_array(of=typeChar8)
    typeStr16 = hlir_type_array(of=typeChar16)
    typeStr32 = hlir_type_array(of=typeChar32)


    typeFreePtr = hlir_type_free_pointer(ti=None)
    typeFreePtr['generic'] = True

    typeNil = hlir_type_nil(ti=None)


def select_int(sz):
    if sz <= 8: return typeInt8
    elif sz <= 16: return typeInt16
    elif sz <= 32: return typeInt32
    elif sz <= 64: return typeInt64
    elif sz <= 128: return typeInt128
    else: return None


def select_nat(sz):
    if sz <= 8: return typeNat8
    elif sz <= 16: return typeNat16
    elif sz <= 32: return typeNat32
    elif sz <= 64: return typeNat64
    elif sz <= 128: return typeNat128
    else: return None


def select_numeric(sz, is_signed):
    if is_signed:
        return select_int(sz + 1)
    return select_nat(sz)



def eq_integer(a, b, opt):
    if a['power'] != b['power']:
        return False

    if is_signed(a) != is_signed(b):
        return False

    return True



def eq_char(a, b, opt):
    if a['power'] != b['power']:
        return False

    return True


def eq_pointer(a, b, opt):
    return eq(a['to'], b['to'], opt)


def eq_array(a, b, opt):

    if a['volume'] == None and b['volume'] == None:
        return eq(a['of'], b['of'], opt)

    if a['volume'] == None or b['volume'] == None:
        return False

    if a['volume']['imm'] != b['volume']['imm']:
        return False

    if a['of'] == None and b['of'] == None:
        return True

    if a['of'] == None or b['of'] == None:
        return False

    return eq(a['of'], b['of'], opt)




def eq_func(a, b, opt):
    if not eq(a['to'], b['to'], opt): return False
    if len(a['params']) != len(b['params']): return False

    for ax, bx in zip(a['params'], b['params']):
        if ax['id']['str'] != bx['id']['str']: return False
        if not eq(ax['type'], bx['type'], opt): return False

    return True


def eq_record(a, b, opt):
    if len(a['fields']) != len(b['fields']): return False

    for ax, bx in zip(a['fields'], b['fields']):
        if ax['id']['str'] != bx['id']['str']: return False
        if not eq(ax['type'], bx['type'], opt): return False

    return True


def eq_float(a, b, opt):
    if 'power' in a and 'power' in b:
        return a['power'] == b['power']

    return False


def eq_opaque(a, b, opt):
    return a['id']['str'] == b['id']['str']    # maybe by UID?


def eq_alias(a, b, opt):
    if a['att'] != b['att']:
        return False

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
    elif k == 'Bool': return True
    elif k == 'array': return eq_array(a, b, opt)
    elif k == 'float': return eq_float(a, b, opt)
    elif k == 'char': return eq_char(a, b, opt)
    elif k == 'opaque': return eq_opaque(a, b, opt)

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


def type_class_check(t, a):
    return a in t['classes']



def is_bad(t):
    assert t != None
    return t['kind'] == 'bad'


def is_generic(t):
    return t['generic']


def is_alias(t):
    return 'alias' in t['att']


def is_unit(t):
    return t['kind'] == 'unit'


def is_enum(t):
    return t['kind'] == 'enum'


def is_numeric(t):
    return type_class_check(t, 'numeric')


def is_bool(t):
    return t['kind'] == 'Bool'


def is_integer(t):
    return t['kind'] == 'int'


def is_integer_signed(t):
    return is_integer(t) and is_signed(t)


def is_integer_unsigned(t):
    return is_integer(t) and is_unsigned(t)


def is_char(t):
    return t['kind'] == 'char'


def is_generic_char(t):
    if not is_generic(t):
        return False
    return is_char(t)


def is_float(t):
    return t['kind'] == 'float'


def is_record(t):
    return t['kind'] == 'record'



def is_string(t):
    return is_array_of_char(t)


def is_generic_string(t):
    if not is_generic(t):
        return False
    return is_array_of_char(t)


def is_ptr_to_string(t):
    if not is_pointer(t):
        return False

    return is_string(t['to'])


# WARNING: Generic int type can be
# not signed and not unsigned at same time (!)
# (because we dont know how it will be used)
# example: let x = 0xFFFFFFFF  #it is signed or unsigned value?

def is_signed(t):
    if t['kind'] == 'int':
        return t['signed']
    return False


def is_unsigned(t):
    if t['kind'] == 'int':
        return t['unsigned']

    if t['kind'] in ['char', 'pointer']:
        return True

    return False



def is_generic_numeric(t):
    return is_generic(t) and is_numeric(t)


def is_generic_integer(t):
    return is_generic(t) and is_integer(t)


def is_generic_record(t):
    return is_generic(t) and is_record(t)


def is_generic_array(t):
    return is_generic(t) and is_array(t)


def is_generic_string(t):
    if not is_generic_array(t):
        return False

    if t['of'] != None: #!
        return is_generic_char(t['of'])

    return False



def is_pointer(t):
    return t['kind'] in ['pointer', 'FreePointer', 'Nil']


def is_free_pointer(t):
    return t['kind'] == 'FreePointer'


def is_nil(t):
    return t['kind'] == 'Nil'


def is_array(t):
    return t['kind'] == 'array'


def is_func(t):
    return t['kind'] == 'func'


def is_opaque(t):
    return t['kind'] == 'opaque'


def is_defined_array(t):
    if is_array(t):
        return t['volume'] != None
    return False


def is_undefined_array(t):
    if is_array(t):
        return t['volume'] == None
    return False


def is_pointer_to_array(t):
    if not is_pointer(t):
        return False
    return is_array(t['to'])


def is_pointer_to_defined_array(t):
    if not is_pointer(t):
        return False
    return is_defined_array(t['to'])


def is_pointer_to_undefined_array(t):
    if not is_pointer(t):
        return False
    return is_undefined_array(t['to'])


def is_pointer_to_record(t):
    if not is_pointer(t):
        return False
    return is_record(t['to'])



def is_array_of_char(t):
    if not is_array(t):
        return False

    if not is_char(t['of']):
        return False

    return True


def is_ptr_to_arr_of_char(t):
    if not is_pointer(t):
        return False

    return is_array_of_char(t['to'])





# cannot create variable with type
def is_forbidden_var(t, zero_array_forbidden=True):
    if is_opaque(t) or is_unit(t):
        return True

    # [0]Int, []Int, [n]<Forbidden>
    if is_array(t):
        # is undefined array?
        if t['volume'] == None:
            return True

        # is defined array;
        # It can't be 0 sized (can only with 'unsafe' compiler flag)
        from main import features
        if zero_array_forbidden or not features.get('unsafe'):
            if t['volume'] == 0:
                return True

        return is_forbidden_var(t['of'])

    if is_func(t):
        return True


    return False




# ищем поле с таким id в типе record
def record_field_get(t, id):
    return get_item_with_id(t['fields'], id)



def type_copy(t):
    nt = copy.copy(t)

    # именно так!    иначе добавим в att t тк это ссылка на лист!
    # (!) создаем новый массив аттрибутов,
    # чтобы не испортить оригинальный (!)
    nt['att'] = []
    nt['classes'] = []

    nt['att'].extend(t['att'])
    nt['classes'].extend(t['classes'])

    return nt


def create_alias(id_str, t, ti):
    #print('type.create_alias ' + id)
    nt = type_copy(t)

    nt['id'] = {'str': id_str, 'ti': ti}

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
        if 'id' in t:
            id_str = t['id']['str']

            if id_str == '<generic:int>':
                id_str = 'Int'

            if is_generic(t):
                print('Generic', end='')

            print(id_str, end='')

            if is_generic(t):
                if 'power' in t:
                    print('%d' % (t['power']), end='')

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
            print('%d' % t['power'], end='')

    elif is_opaque(t):
        print('opaque', end='')

    else:
        print("<type:%s>" % k, end='')



