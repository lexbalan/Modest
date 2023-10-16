

import copy
from opt import *
from error import error, fatal
from hlir import *
from util import get_item_with_id


typeUnit = hlir_type_unit()

typeInt8    = hlir_type_integer("Int8", power=8, ti=None)
typeInt8['att'].extend(['signed'])
typeInt8['c_alias'] = 'int8_t'
typeInt8['llvm_alias'] = 'i8'

typeInt16 = hlir_type_integer("Int16", power=16, ti=None)
typeInt16['att'].extend(['signed'])
typeInt16['c_alias'] = 'int16_t'
typeInt16['llvm_alias'] = 'i16'

typeInt32 = hlir_type_integer("Int32", power=32, ti=None)
typeInt32['att'].extend(['signed'])
typeInt32['c_alias'] = 'int32_t'
typeInt32['llvm_alias'] = 'i32'

typeInt64 = hlir_type_integer("Int64", power=64, ti=None)
typeInt64['att'].extend(['signed'])
typeInt64['c_alias'] = 'int64_t'
typeInt64['llvm_alias'] = 'i64'

typeInt128 = hlir_type_integer("Int128", power=128, ti=None)
typeInt128['att'].extend(['signed'])
typeInt128['c_alias'] = '__int128'
typeInt128['llvm_alias'] = 'i128'


typeNat1 = hlir_type_integer("Nat1", power=1, ti=None)
typeNat1['att'].extend(['unsigned', 'logical'])
typeNat1['c_alias'] = 'uint8_t'
typeNat1['llvm_alias'] = 'i1'

typeNat8 = hlir_type_integer("Nat8", power=8, ti=None)

typeNat8['c_alias'] = 'uint8_t'
typeNat8['att'].extend(['unsigned'])
typeNat8['llvm_alias'] = 'i8'

typeNat16 = hlir_type_integer("Nat16", power=16, ti=None)
typeNat16['att'].extend(['unsigned'])
typeNat16['c_alias'] = 'uint16_t'
typeNat16['llvm_alias'] = 'i16'

typeNat32 = hlir_type_integer("Nat32", power=32, ti=None)
typeNat32['att'].extend(['unsigned'])
typeNat32['c_alias'] = 'uint32_t'
typeNat32['llvm_alias'] = 'i32'

typeNat64 = hlir_type_integer("Nat64", power=64, ti=None)
typeNat64['att'].extend(['unsigned'])
typeNat64['c_alias'] = 'uint64_t'
typeNat64['llvm_alias'] = 'i64'

typeNat128 = hlir_type_integer("Nat128", power=128, ti=None)
typeNat128['att'].extend(['unsigned'])
typeNat128['c_alias'] = 'unsigned __int128'
typeNat128['llvm_alias'] = 'i128'

typeFloat16 = hlir_type_float('Float16', power=16, ti=None)
#typeFloat16['att'].extend(['float'])
typeFloat16['c_alias'] = 'half'
typeFloat16['llvm_alias'] = 'half'

typeFloat32 = hlir_type_float('Float32', power=32, ti=None)
#typeFloat32['att'].extend(['float'])
typeFloat32['c_alias'] = 'float'
typeFloat32['llvm_alias'] = 'float'

typeFloat64 = hlir_type_float('Float64', power=64, ti=None)
#typeFloat64['att'].extend(['float'])
typeFloat64['c_alias'] = 'double'
typeFloat64['llvm_alias'] = 'double'


typeDecimal32 = hlir_type_float('Decimal32', power=32, ti=None)
typeDecimal32['att'].extend(['float', 'decimal'])
typeDecimal32['c_alias'] = '_Decimal32'
typeDecimal32['llvm_alias'] = 'float'

typeDecimal64 = hlir_type_float('Decimal64', power=64, ti=None)
typeDecimal64['att'].extend(['float', 'decimal'])
typeDecimal64['c_alias'] = '_Decimal64'
typeDecimal64['llvm_alias'] = 'double'

typeDecimal128 = hlir_type_float('Decimal128', power=128, ti=None)
typeDecimal128['att'].extend(['float', 'decimal'])
typeDecimal128['c_alias'] = '_Decimal128'
typeDecimal128['llvm_alias'] = 'double'



typeChar8 = hlir_type_char("Char8", power=8, ti=None)
typeChar8['c_alias'] = 'char' #'uint8_t'
typeChar8['llvm_alias'] = 'i8'

typeChar16 = hlir_type_char("Char16", power=16, ti=None)
typeChar16['c_alias'] = 'uint16_t'
typeChar16['llvm_alias'] = 'i16'

typeChar32 = hlir_type_char("Char32", power=32, ti=None)
typeChar32['c_alias'] = 'uint32_t'
typeChar32['llvm_alias'] = 'i32'


typeGenericString = hlir_type_generic_str(ti=None)
typeGenericString['cm_alias'] = 'String'
typeGenericString['c_alias'] = 'const char *'
typeGenericString['llvm_alias'] = 'i8*'


typeStr8 = hlir_type_pointer(hlir_type_array(of=typeChar8))
typeStr8['att'].append('string')
typeStr16 = hlir_type_pointer(hlir_type_array(of=typeChar16))
typeStr16['att'].append('string')
typeStr32 = hlir_type_pointer(hlir_type_array(of=typeChar32))
typeStr32['att'].append('string')


typeFreePtr = hlir_type_free_pointer(ti=None)
typeFreePtr['att'].append('generic')

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



def eq_integer(a, b):
    if a['power'] != b['power']:
        return False

    if is_signed(a) != is_signed(b):
        return False

    return True


def eq_char(a, b):
    return eq_integer(a, b)


def eq_pointer(a, b):
    return eq(a['to'], b['to'])


def eq_array(a, b):

    if a['volume'] == None and b['volume'] == None:
        return eq(a['of'], b['of'])

    if a['volume'] == None or b['volume'] == None:
        return False

    if a['volume']['imm'] != b['volume']['imm']:
        return False

    if a['of'] == None and b['of'] == None:
        return True

    if a['of'] == None or b['of'] == None:
        return False

    return eq(a['of'], b['of'])




def eq_func(a, b):
    if not eq(a['to'], b['to']): return False
    if len(a['params']) != len(b['params']): return False

    for ax, bx in zip(a['params'], b['params']):
        if ax['id']['str'] != bx['id']['str']: return False
        if not eq(ax['type'], bx['type']): return False

    return True


def eq_record(a, b):
    if len(a['fields']) != len(b['fields']): return False

    for ax, bx in zip(a['fields'], b['fields']):
        if ax['id']['str'] != bx['id']['str']: return False
        if not eq(ax['type'], bx['type']): return False

    return True


def eq_float(a, b):
    if 'power' in a and 'power' in b:
        return a['power'] == b['power']

    return False


def eq_opaque(a, b):
    return a['name'] == b['name']    # maybe by UID?


def eq_alias(a, b):
    if a['att'] != b['att']:
        return False

    return eq(a['of'], b['of'])


def eq(a, b):
    # fast checking
    if a == b: return True
    if a['kind'] == 'bad': return True
    if b['kind'] == 'bad': return True
    if a['kind'] != b['kind']: return False

    # дженерик и не дженерик типы не равны
    # это важно при конструировании записей из джененрков
    # в противном случае конструирование будет скипнуто (тк уже равны)
    if ('generic' in a['att']) != ('generic' in b['att']):
        return False

    # normal checking
    k = a['kind']
    if k == 'int': return eq_integer(a, b)
    elif k == 'unit': return True
    elif k == 'func': return eq_func(a, b)
    elif k == 'record': return eq_record(a, b)
    elif k == 'pointer': return eq_pointer(a, b)
    elif k == 'array': return eq_array(a, b)
    elif k == 'float': return eq_float(a, b)
    elif k == 'char': return eq_char(a, b)
    elif k == 'opaque': return eq_opaque(a, b)

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


def type_attribute_check(t, a):
    return a in t['att']


"""def type_class_check(t, a):
    absent = ''
    for c in a:
        if not type_attribute_check(t, c):
            absent = c
            break

    if absent != '':
        error("expected %s type" % (a), x['left'])
    return result"""




def is_bad(t):
    assert t != None
    return t['kind'] == 'bad'



def is_generic(t):
    return 'generic' in t['att']


def is_alias(t):
    return 'alias' in t['att']



def is_unit(t):
    return t['kind'] == 'unit'


def is_enum(t):
    return t['kind'] == 'enum'


def is_numeric(t):
    return 'numeric' in t['att']


def is_logical(t):
    return 'logical' in t['att']


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
    return 'string' in t['att']
    #return t['kind'] == 'String'


def is_generic_string(t):
    return t['kind'] == 'String'


# WARNING: Generic int type can be
# not signed and not unsigned at same time (!)
# (because we dont know how it will be used)
# example: let x = 0xFFFFFFFF  #it is signed or unsigned value?

def is_signed(t):
    return 'signed' in t['att']


def is_unsigned(t):
    return 'unsigned' in t['att']



def is_generic_numeric(t):
    return is_generic(t) and is_numeric(t)


def is_generic_integer(t):
    return is_generic(t) and is_integer(t)


def is_generic_record(t):
    return is_generic(t) and is_record(t)


def is_generic_string(t):
    return t['kind'] == 'String'


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


def is_ptr_to_char(t):
    if not is_pointer(t):
        return False

    if not is_char(t['to']):
        return False

    return True


def is_ptr_to_arr_of_char(t):
    if not is_pointer(t):
        return False

    if not is_array(t['to']):
        return False

    if not is_char(t['to']['of']):
        return False

    return True




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
        if zero_array_forbidden or not features_get('unsafe'):
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

    nt['att'].extend(t['att'])

    return nt


def create_alias(id, t, ti):
    #print('type.create_alias ' + id)
    nt = type_copy(t)

    nt['name'] = id

    if 'c_alias' in nt:
        del nt['c_alias']

    nt['att'].append('alias')

    nt['aliasof'] = t
    nt['ti'] = ti

    return nt



def get_size(t):
    if is_integer(t):
        return t['size']
    elif is_array(t):
        return t['volume']['imm'] * get_size(t['of'])

    #else:
    #    fatal("type.get_size() for '%s' not implemented" % t['kind'])

    return 0


def print_list_by(lst, method):
    i = 0
    while i < len(lst):
        if i > 0:
            print(", ")
        method(lst[i])
        i = i + 1


def type_print(t, print_aka=True):
    k = t['kind']

    if print_aka:
        if 'name' in t:
            id = t['name']

            if id == '<generic:int>':
                id = 'Int'

            if is_generic(t):
                print('Generic', end='')

            print(id, end='')

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
        print('%' + t['name'], end='')
        if is_generic(t):
            print('%d' % t['power'], end='')

    elif is_opaque(t):
        print('opaque', end='')

    else:
        print("<type:%s>" % k, end='')



