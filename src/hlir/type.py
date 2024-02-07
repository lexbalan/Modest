

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
        #'id': None,
        'generic': False,
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
        #'id': hlir_id('Unit'),
        'generic': False,
        'width': 0,
        'size': 0,
        'align': 0,
        #'c_alias': 'void',
        #'llvm_alias': 'void',
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
        #'id': hlir_id('Bool'),
        'generic': False,
        'width': 1,
        'size': 1,
        'align': 1,
        #'c_alias': 'bool',
        #'llvm_alias': 'i1',
        'cm_alias': 'Bool',
        'declaration': None,
        'definition': None,
        'ops': BOOL_OPS,
        'att': [],
        'ti': None
    }



def hlir_type_char(id_str, width, ti=None):
    size = nbytes_for_bits(width)

    id = None
    if id_str != None:
        id = hlir_id(id_str)

    return {
        'isa': 'type',
        'kind': 'char',
        #'id': id,
        'generic': False,
        'width': width,
        'size': size,
        'align': size,
        'declaration': None,
        'definition': None,
        'ops': CHAR_OPS,
        'att': [],
        'ti': ti
    }


def hlir_type_integer(id_str, width, signed=True, ti=None):
    size = nbytes_for_bits(width)
    return {
        'isa': 'type',
        'kind': 'int',
        #'id': hlir_id(id_str),
        'generic': False,
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



def hlir_type_float(id_str, width, ti=None):
    size = nbytes_for_bits(width)
    return {
        'isa': 'type',
        'kind': 'float',
        #'id': hlir_id(id_str),
        'generic': False,
        'width': width,
        'size': size,
        'align': size,
        #'c_alias': 'double',
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
        #'id': None,
        'generic': False,
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
        #'id': None,
        'generic': False,
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
        #'id': None,
        'generic': False,
        'items': [],
        'width': enum_width,
        'size': enum_size,
        'align': enum_size,
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
        #'id': None,
        'generic': False,
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


# дефолт аргумент не работает!!!!
def hlir_type_func(params, to, ti=None):
    return {
        'isa': 'type',
        'kind': 'func',
        #'id': None,
        'generic': False,
        'width': 0,
        'size': 0,
        'align': 0,
        'params': params,
        'extra_args': False,
        'to': to,
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
        #'id': id,
        'generic': False,
        'declaration': None,
        'definition': None,
        'att': [],
        'ti': ti
    }


def hlir_type_generic_int_for(num, unsigned=False, ti=None):
    required_width = nbits_for_num(num)
    t = hlir_type_integer("Integer", width=required_width, ti=ti)
    t['generic'] = True
    return t



typeUnit = None
typeBool = None
typeByte = None
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


foundation = []

def type_init():
    global typeUnit
    global typeBool
    global typeByte
    global typeChar8, typeChar16, typeChar32
    global typeInt8, typeInt16, typeInt32, typeInt64, typeInt128
    global typeNat8, typeNat16, typeNat32, typeNat64, typeNat128
    global typeFloat16, typeFloat32, typeFloat64
    global typeDecimal32, typeDecimal64, typeDecimal128
    global typeStr8, typeStr16, typeStr32
    global typeFreePointer
    global typeVA_List

    from .hlir import hlir_decl_type
    #from .id import hlir_id

    typeUnit = hlir_type_unit()
    unit_decl = hlir_decl_type(hlir_id('Unit'), typeUnit, ti=None)
    unit_decl['c_alias'] = 'void'
    unit_decl['llvm_alias'] = 'void'
    foundation.append(unit_decl)

    typeBool = hlir_type_bool()
    bool_decl = hlir_decl_type(hlir_id('Bool'), typeBool, ti=None)
    bool_decl['c_alias'] = 'bool'
    bool_decl['llvm_alias'] = 'i1'
    foundation.append(bool_decl)

    typeByte = hlir_type_integer("Byte", width=8, signed=False)
    typeByte['kind'] = 'byte'
    typeByte['ops'] = BYTE_OPS
    byte_decl = hlir_decl_type(hlir_id('Byte'), typeByte, ti=None)
    byte_decl['c_alias'] = 'uint8_t'
    byte_decl['llvm_alias'] = 'i8'
    foundation.append(byte_decl)

    #
    typeChar8 = hlir_type_char("Char8", width=8)
    char8_decl = hlir_decl_type(hlir_id('Char8'), typeChar8, ti=None)
    char8_decl['c_alias'] = 'char'
    char8_decl['llvm_alias'] = 'i8'
    foundation.append(char8_decl)

    typeChar16 = hlir_type_char("Char16", width=16)
    char16_decl = hlir_decl_type(hlir_id('Char16'), typeChar16, ti=None)
    char16_decl['c_alias'] = 'uint16_t'
    char16_decl['llvm_alias'] = 'i16'
    foundation.append(typeChar16)

    typeChar32 = hlir_type_char("Char32", width=32)
    char32_decl = hlir_decl_type(hlir_id('Char32'), typeChar32, ti=None)
    char32_decl['c_alias'] = 'uint32_t'
    char32_decl['llvm_alias'] = 'i32'
    foundation.append(char32_decl)

    #
    typeInt8 = hlir_type_integer("Int8", width=8)
    int8_decl = hlir_decl_type(hlir_id('Int8'), typeInt8, ti=None)
    int8_decl['c_alias'] = 'int8_t'
    int8_decl['llvm_alias'] = 'i8'
    foundation.append(int8_decl)

    typeInt16 = hlir_type_integer("Int16", width=16)
    int16_decl = hlir_decl_type(hlir_id('Int16'), typeInt16, ti=None)
    int16_decl['c_alias'] = 'int16_t'
    int16_decl['llvm_alias'] = 'i16'
    foundation.append(int16_decl)

    typeInt32 = hlir_type_integer("Int32", width=32)
    int32_decl = hlir_decl_type(hlir_id('Int32'), typeInt32, ti=None)
    int32_decl['c_alias'] = 'int32_t'
    int32_decl['llvm_alias'] = 'i32'
    foundation.append(int32_decl)

    typeInt64 = hlir_type_integer("Int64", width=64)
    int64_decl = hlir_decl_type(hlir_id('Int64'), typeInt64, ti=None)
    int64_decl['c_alias'] = 'int64_t'
    int64_decl['llvm_alias'] = 'i64'
    foundation.append(int64_decl)

    typeInt128 = hlir_type_integer("Int128", width=128)
    int128_decl = hlir_decl_type(hlir_id('Int128'), typeInt128, ti=None)
    int128_decl['c_alias'] = '__int128'
    int128_decl['llvm_alias'] = 'i128'
    foundation.append(typeInt128)

    #
    typeNat8 = hlir_type_integer("Nat8", width=8, signed=False)
    nat8_decl = hlir_decl_type(hlir_id('Nat8'), typeNat8, ti=None)
    nat8_decl['c_alias'] = 'uint8_t'
    nat8_decl['llvm_alias'] = 'i8'
    foundation.append(nat8_decl)

    typeNat16 = hlir_type_integer("Nat16", width=16, signed=False)
    nat16_decl = hlir_decl_type(hlir_id('Nat16'), typeNat16, ti=None)
    nat16_decl['c_alias'] = 'uint16_t'
    nat16_decl['llvm_alias'] = 'i16'
    foundation.append(nat16_decl)

    typeNat32 = hlir_type_integer("Nat32", width=32, signed=False)
    nat32_decl = hlir_decl_type(hlir_id('Nat32'), typeNat32, ti=None)
    nat32_decl['c_alias'] = 'uint32_t'
    nat32_decl['llvm_alias'] = 'i32'
    foundation.append(nat32_decl)

    typeNat64 = hlir_type_integer("Nat64", width=64, signed=False)
    nat64_decl = hlir_decl_type(hlir_id('Nat64'), typeNat64, ti=None)
    nat64_decl['c_alias'] = 'uint64_t'
    nat64_decl['llvm_alias'] = 'i64'
    foundation.append(nat64_decl)

    typeNat128 = hlir_type_integer("Nat128", width=128, signed=False)
    nat128_decl = hlir_decl_type(hlir_id('Nat128'), typeNat128, ti=None)
    nat128_decl['c_alias'] = 'unsigned __int128'
    nat128_decl['llvm_alias'] = 'i128'
    foundation.append(nat128_decl)

    #
    typeFloat16 = hlir_type_float('Float16', width=16)
    float16_decl = hlir_decl_type(hlir_id('Float16'), typeFloat16, ti=None)
    float16_decl['c_alias'] = 'half'
    float16_decl['llvm_alias'] = 'half'
    foundation.append(float16_decl)

    typeFloat32 = hlir_type_float('Float32', width=32)
    float32_decl = hlir_decl_type(hlir_id('Float32'), typeFloat32, ti=None)
    float32_decl['c_alias'] = 'float'
    float32_decl['llvm_alias'] = 'float'
    foundation.append(float32_decl)

    typeFloat64 = hlir_type_float('Float64', width=64)
    float64_decl = hlir_decl_type(hlir_id('Float64'), typeFloat64, ti=None)
    float64_decl['c_alias'] = 'double'
    float64_decl['llvm_alias'] = 'double'
    foundation.append(float64_decl)

    #
    typeDecimal32 = hlir_type_float('Decimal32', width=32)
    decimal32_decl = hlir_decl_type(hlir_id('Decimal32'), typeDecimal32, ti=None)
    decimal32_decl['c_alias'] = '_Decimal32'
    decimal32_decl['llvm_alias'] = 'float'
    foundation.append(decimal32_decl)

    typeDecimal64 = hlir_type_float('Decimal64', width=64)
    decimal64_decl = hlir_decl_type(hlir_id('Decimal64'), typeDecimal64, ti=None)
    decimal64_decl['c_alias'] = '_Decimal64'
    decimal64_decl['llvm_alias'] = 'double'
    foundation.append(decimal64_decl)

    typeDecimal128 = hlir_type_float('Decimal128', width=128)
    decimal128_decl = hlir_decl_type(hlir_id('Decimal128'), typeDecimal128, ti=None)
    decimal128_decl['c_alias'] = '_Decimal128'
    decimal128_decl['llvm_alias'] = 'double'
    foundation.append(decimal128_decl)


    typeFreePointer = hlir_type_pointer(to=typeUnit)
    free_pointer_decl = hlir_decl_type(hlir_id('Pointer'), typeFreePointer, ti=None)
    free_pointer_decl['c_alias'] = 'void *'
    free_pointer_decl['llvm_alias'] = 'i8*'
    foundation.append(free_pointer_decl)


    typeStr8 = hlir_type_array(of=typeChar8)
    typeStr8_decl = hlir_decl_type(hlir_id('Str8'), typeStr8, ti=None)
    foundation.append(typeStr8_decl)

    typeStr16 = hlir_type_array(of=typeChar16)
    typeStr16_decl = hlir_decl_type(hlir_id('Str16'), typeStr16, ti=None)
    foundation.append(typeStr16_decl)

    typeStr32 = hlir_type_array(of=typeChar32)
    typeStr32_decl = hlir_decl_type(hlir_id('Str32'), typeStr32, ti=None)
    foundation.append(typeStr32_decl)


    typeVA_List = {
        'isa': 'type',
        'kind': 'va_list',
        #'id': None,
        'generic': False,
        'size': 0,
        'align': 1,
        'width': 0,
        'declaration': None,
        'definition': None,
        'att': [],
        'ops': [],
        'ti': None
    }

    type_va_list_decl = hlir_decl_type(hlir_id('VA_List'), typeVA_List, ti=None)
    foundation.append(type_va_list_decl)

    return



def type_select_char(sz):
    t = None
    if sz <= 8: t = typeChar8
    elif sz <= 16: t = typeChar16
    elif sz <= 32: t = typeChar32
    assert(t != None)
    return t


def type_select_int(sz):
    t = None
    if sz <= 8: t = typeInt8
    elif sz <= 16: t = typeInt16
    elif sz <= 32: t = typeInt32
    elif sz <= 64: t = typeInt64
    elif sz <= 128: t = typeInt128
    assert(t != None)
    return t


def type_select_nat(sz):
    t = None
    if sz <= 8: t = typeNat8
    elif sz <= 16: t = typeNat16
    elif sz <= 32: t = typeNat32
    elif sz <= 64: t = typeNat64
    elif sz <= 128: t = typeNat128
    assert(t != None)
    return t


def type_select_integer(sz, is_signed):
    if is_signed:
        if sz < 128: return type_select_int(sz + 1)
        else: return type_select_int(sz)
    return type_select_nat(sz)



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


def type_eq_record(a, b, opt, nominative=False):
    if nominative:
        if ('id' in a) and ('id' in b):
            if a['id']['str'] != b['id']['str']:
                return False
        elif ('id' in a) or ('id' in b):
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
    if type_is_generic(a) != type_is_generic(b):
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



def type_is_generic(t):
    return t['generic']


def type_is_alias(t):
    return 'aliasof' in t


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


def create_alias(id_str, t, ti):
    #info('type.create_alias ' + id, ti)
    nt = type_copy(t)

    nt['id'] = hlir_id(id_str, ti=ti)

    if 'c_alias' in nt:
        del nt['c_alias']

    nt['aliasof'] = t
    nt['ti'] = ti

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

        elif t['id'] != None:
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
        if t['id'] != None:
            print(t['id'], end='')
        print("enum_%s" % str(t['uid']), end='')

    elif type_is_pointer(t):
        print("*", end=''); type_print(t['to'])

    elif type_is_array(t):
        if t['of'] == None:
            print("GenericEmptyArray", end='')
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
        print('%' + t['id']['str'], end='')
        if type_is_generic(t):
            print('%d' % t['width'], end='')

    elif type_is_opaque(t):
        print('opaque', end='')

    else:
        print("<type:%s>" % k, end='')



