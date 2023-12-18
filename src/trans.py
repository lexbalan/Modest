
import os

from error import *
from util import get_item_with_id, align_to
from main import settings


def is_local_context():
    global cfunc
    return cfunc != None


from value.value import *
from value.cons import value_cons_implicit, value_cons_explicit, cons_default

from frontend.parser import Parser
from symtab import Symtab
import type
from util import nbits_for_num, nbytes_for_bits
from hlir import *



# current file directory
env_current_file_abspath = ""
env_current_file_dir = ""

parser = Parser()

cfunc = None    # current function

root_context = None

module = None



# тепреь вызывается только из конструктора строки (value)
def module_strings_add(v):
    module['strings'].append(v)



def module_type_get(m, id_str):
    #print("SEARCH_TYPE %s in %s" % (id_str, cm['path']))
    t = m['context'].type_get(id_str)
    if t != None:
        return t

    for imported_module in m['imports']:
        t = module_type_get(imported_module, id_str)
        if t != None:
            return t


def module_value_get(m, id_str):
    v = m['context'].value_get(id_str)
    if v != None:
        return v

    for imported_module in m['imports']:
        v = module_value_get(imported_module, id_str)
        if v != None:
            return v


def type_get(id_str):
    return module_type_get(module, id_str)


def value_get(id_str):
    return module_value_get(module, id_str)
    #return module['context'].value_get(id_str, recursive=True)


# искать только внутри текущего контекста (блока)
def value_get_here(id_str):
    return module['context'].value_get(id_str, recursive=False)


def pragma(cmd, args):
    exec("%s(%s)" % (cmd, str(args)))


# used in metadirs
def c_include(s):
    #print("c_include %s" % s)
    global module
    local = s[0:2] == './'
    inc = {
        'isa': 'directive',
        'kind': 'c_include',
        'str': s,
        'local': local,
        'att': [],
        'nl': 1,
        'ti': None
    }
    module['text'].append(inc)


properties = {}


# used in metadirs
# add 'properties' to entity descriptor
def property(id, value):
    global properties
    properties[id] = value



attributes = []

def attribute(at):
    global attributes
    if isinstance(at, list):
        attributes.extend(at)
    else:
        attributes.append(at)


def attributes_get():
    global attributes
    attributes2 = attributes
    attributes = []
    return attributes2



def insert(s):
    global module

    ins = {
        'isa': 'directive',
        'kind': 'insert',
        'str': s,
        'att': [],
        'nl': 1,
        'ti': None
    }
    module['text'].append(ins)



def stmt_is_bad(x):
    assert x != None
    return x['kind'] == 'bad'



typeSysInt = None
typeSysNat = None
typeSysStr = None
typeSysChar = None
typeSysFloat = None

# for target arch
char_width = 0
int_width = 0
ptr_width = 0
flt_width = 0
lib_path = ""


valueNil = None
valueTrue = None
valueFalse = None


def init():
    global char_width, int_width, ptr_width, flt_width, lib_path
    int_width = int(settings.get('integer_width'))
    ptr_width = int(settings.get('pointer_width'))
    flt_width = int(settings.get('float_width'))
    char_width = int(settings.get('char_width'))
    lib_path = settings.get('lib')

    hlir_init()
    type.type_init()


    valueNil = hlir_value_int(0, typ=type.typeNil)
    valueTrue = hlir_value_int(1, typ=type.typeBool)
    valueFalse = hlir_value_int(0, typ=type.typeBool)



    global root_context
    # init main context
    root_context = Symtab()

    root_context.type_add('Unit', type.typeUnit)

    root_context.type_add('Int8', type.typeInt8)
    root_context.type_add('Int16', type.typeInt16)
    root_context.type_add('Int32', type.typeInt32)
    root_context.type_add('Int64', type.typeInt64)
    root_context.type_add('Int128', type.typeInt128)

    root_context.type_add('Bool', type.typeBool)
    root_context.type_add('Nat8', type.typeNat8)
    root_context.type_add('Nat16', type.typeNat16)
    root_context.type_add('Nat32', type.typeNat32)
    root_context.type_add('Nat64', type.typeNat64)
    root_context.type_add('Nat128', type.typeNat128)

    root_context.type_add('Float16', type.typeFloat16)
    root_context.type_add('Float32', type.typeFloat32)
    root_context.type_add('Float64', type.typeFloat64)

    #root_context.type_add('Decimal32', type.typeDecimal32)
    #root_context.type_add('Decimal64', type.typeDecimal64)
    #root_context.type_add('Decimal128', type.typeDecimal128)

    root_context.type_add('Char8', type.typeChar8)
    root_context.type_add('Char16', type.typeChar16)
    root_context.type_add('Char32', type.typeChar32)

    root_context.type_add('Str8', type.typeStr8)
    root_context.type_add('Str16', type.typeStr16)
    root_context.type_add('Str32', type.typeStr32)

    #root_context.type_add('Str', type.typeStr8)

    root_context.type_add('Pointer', type.typeFreePtr)

    root_context.type_add('Bool', type.typeBool)


    root_context.value_add('nil', valueNil)
    root_context.value_add('true', valueTrue)
    root_context.value_add('false', valueFalse)


    # Set taget depended Int & Nat types
    # (used in index, extra agrs & generic numeric var definitions)

    global typeSysInt, typeSysNat, typeSysFloat, typeSysChar, typeSysStr

    typeSysInt = type.type_copy(type.select_int(int_width))
    typeSysInt['c_alias'] = 'int'

    typeSysNat = type.type_copy(type.select_nat(int_width))
    typeSysNat['c_alias'] = 'unsigned int'

    typeSysChar

    if char_width == 8: typeSysChar = type.typeChar8
    elif char_width == 16: typeSysChar = type.typeChar16
    elif char_width == 32: typeSysChar = type.typeChar32

    typeSysStr = hlir_type_pointer(hlir_type_array(typeSysChar, volume=None))

    typeSysFloat = type.typeFloat64



# last fiels of record can be zero size array (!)
# (only with -funsafe key)
# pos - position #
# offset - real offset (address inside container struct)
def do_field(x, pos=0, offset=0, is_last=False):
    t = do_type(x['type'])

    if type.is_bad(t):
        t = hlir_type_bad(x['type']['ti'])

    # get aligned field offset
    offset = align_to(offset, type.type_get_align(t))

    if type.is_forbidden_var(t, zero_array_forbidden=not is_last):
        error("unsuitable type", x['type'])

    f = hlir_field(x['id'], t, pos=pos, offset=offset, ti=x['ti'])
    if 'nl' in x:
        f['nl'] = x['nl']
    else:
        f['nl'] = 0
    return f





#
# Do Type
#

def do_type_id(t):
    id_str = t['id']['str']
    tx = type_get(id_str)
    if tx == None:
        error("undeclared type %s" % id_str, t)
        # create fake alias for unknown type
        tx = hlir_type_bad()
        nt = type.create_alias(id_str, tx, t['ti'])
        root_context.type_add(id_str, nt)
        return nt
    return tx


def do_type_pointer(t):
    to = do_type(t['to'])
    return hlir_type_pointer(to, ti=t['ti'])


def do_type_array(t):
    of = do_type(t['of'])

    volume_expr = None
    if t['size'] != None:
        volume_expr = do_value(t['size'])

    tx = hlir_type_array(of, volume=volume_expr, ti=t['ti'])

    return tx


def do_type_record(t):
    fields = []

    record_align = 0
    record_size = 0

    nfields = len(t['fields'])
    i = 0
    while i < nfields:
        fe = t['fields'][i]

        # новое поле получит смещение отталкиваясь от текущего (curr_offset)
        f = do_field(fe, pos=i, offset=record_size, is_last=i==(nfields-1))

        # двигаем смещение
        field_size = type.type_get_size(f['type'])
        record_size = f['offset'] + field_size

        # выравнивание структуры - макс выравнивание среди ее полей
        field_align = type.type_get_align(f['type'])
        if field_align > record_align:
            record_align = field_align

        i = i + 1

        field_id_str = f['id']['str']
        f_exist = get_item_with_id(fields, field_id_str)
        if f_exist != None:
            error("redefinition of '%s'" % field_id_str, f)
            continue

        if 'comments' in fe:
            f.update({'comments': fe['comments']})

        fields.append(f)


    # Afterall we need to align record_size to record_align (!)
    record_size = align_to(record_size, record_align)

    return hlir_type_record(fields, size=record_size, align=record_align, ti=t['ti'])



def do_type_enum(t):
    enum_type = {
        'isa': 'type',
        'kind': 'enum',
        'generic': False,
        'items': [],
        'size': 32,
        'att': [],
        'ti': t['ti']
    }

    i = 0
    while i < len(t['items']):
        id = t['items'][i]
        enum_type['items'].append({
            'isa': 'item',
            'id': id['id'],
            'number': i,
            'ti': id['ti']
        })

        # add enum item to global context
        item_val = hlir_value_int(i, typ=enum_type, ti=id['ti'])
        module['context'].value_add(id['id']['str'], item_val)

        i = i + 1

    return enum_type


def do_type_func(t):
    params = []

    for param in t['params']:
        param = do_field(param)
        if type.is_array(param['type']):
            error("function parameter cannot be an array", param)
        if param != None:
            params.append(param)

    to = None
    if t['to'] != None:
        to = do_type(t['to'])
    else:
        to = type.typeUnit

    return hlir_type_func(params, to, ti=t['ti'])



def do_type(t):
    k = t['kind']

    if k == 'id': return do_type_id(t)
    elif k == 'pointer': return do_type_pointer(t)
    elif k == 'array': return do_type_array(t)
    elif k == 'record': return do_type_record(t)
    elif k == 'enum': return do_type_enum(t)
    elif k == 'func': return do_type_func(t)

    return bad_type(t['ti'])



#
# Do Statement
#

def do_value_shift(x):
    op = x['kind']
    l = do_rvalue(x['left'])
    r = do_rvalue(x['right'])
    ti = x['ti']

    if not type.is_integer(l['type']):
        error("type error", l)

    if not type.is_integer(r['type']):
        error("type error", r)

    # const folding
    if value_is_immediate(l) and value_is_immediate(r):
        nl = l['imm']
        nr = r['imm']

        imm_result = 0

        if op == 'shl':
            # bits required for result storing
            #nbits_req = nbits_for_num(nl) + nr
            imm_result = nl << nr
            nbits = nbits_for_num(imm_result)

            # если тип Generic - расширим,
            # иначе - проверим влезает ли результат
            if type.is_generic(l['type']):
                # расширяем generic int тип чтобы в нем можно было сдвигать
                l['type']['power'] = nbits #!
                res_t = hlir_type_generic_int_bits(nbits, ti=ti)
            else:
                if nbits > l['type']['power']:
                    error("data loss left shift", ti)
                res_t = l['type']

            v = hlir_value_bin(op, l, r, res_t, ti=ti)
            v['imm'] = imm_result
            return v


        elif op == 'shr':
            imm_result = nl >> nr
            nbits = nbits_for_num(imm_result)

            # TODO: реализуй сдвиг вправо!

            t = l['type']
            if type.is_generic(l['type']):
                t = hlir_type_generic_int_bits(nbits, ti=ti)

            v = hlir_value_bin(op, l, r, t, ti=ti)
            v['imm'] = imm_result

            return v


    if type.is_generic(l['type']):
        error("required value with non-generic type", l)
        return hlir_value_bad(ti)


    return hlir_value_bin(op, l, r, l['type'], ti=ti)



# select result type of common binary operation
def bin_type_select(a, b):
    if type.is_generic_numeric(a) and type.is_generic_numeric(b):
        if a['power'] > b['power']:
            return a
        else:
            return b

    elif type.is_generic_numeric(a):
        return b

    elif type.is_generic_numeric(b):
        return a

    return a



# бинарные операции с указателями имеют особые правила
def do_bin_op_with_pointers(op, l, r , ti):
    # единственная безопасная операция для указателей - это сравнение
    if op in ['eq', 'ne']:
        # сравнивать можно только указатель с указателем
        if type.is_pointer(l['type']) and type.is_pointer(r['type']):

            # what about typeFreePointer?
            if type.is_nil(l['type']):
                l = value_cons_implicit(l, r['type'], ti)
            elif type.is_nil(r['type']):
                r = value_cons_implicit(r, l['type'], ti)

            return hlir_value_bin(op, l, r, type.typeBool, ti)

    from main import features
    if not features.get('unsafe'):
        error("illegal operation with pointers", ti)
        return hlir_value_bad(ti)


    # если включен unsafe режим
    if op in ['add', 'sub']:
        ptr_n_int = type.is_free_pointer(l['type']) and type.is_integer(r['type'])
        int_n_ptr = type.is_integer(l['type']) and type.is_free_pointer(r['type'])

        # если и указатель и число непосредственные
        if value_is_immediate(l) and value_is_immediate(r):
            typ = None
            if ptr_n_int:
                typ = l['type']
            else:
                typ = r['type']

            num = 0
            if op == 'add': num = l['imm'] + r['imm']
            elif op == 'sub': num = l['imm'] - r['imm']
            return hlir_value_int(num, typ=typ, ti=ti)

        # указатель или число в рантайме
        else:

            if ptr_n_int:
                lnat = do_cast_runtime(l, typeSysNat, ti)
                xr = value_cons_implicit(r, lnat['type'], ti)
                result = hlir_value_bin(x['kind'], lnat, xr, xr['type'], ti)
                return do_cast_runtime(result, l['type'], ti)

            if int_n_ptr:
                rnat = do_cast_runtime(r, typeSysNat, ti)
                xl = value_cons_implicit(l, rnat['type'], ti)
                result = hlir_value_bin(x['kind'], rnat, xl, xl['type'], ti)
                return do_cast_runtime(result, r['type'], ti)

        error("illegal operation with pointers", ti)
        return hlir_value_bad(ti)




def bin_imm(op, type_result, l, r, ti):
    ops = {
        'logic_or': lambda a, b: a | b,
        'logic_and': lambda a, b: a & b,
        'or': lambda a, b: a or b,
        'and': lambda a, b: a and b,
        'xor': lambda a, b: a ^ b,
        'eq': lambda a, b: 1 if a == b else 0,
        'ne': lambda a, b: 1 if a != b else 0,
        'lt': lambda a, b: 1 if a < b else 0,
        'gt': lambda a, b: 1 if a > b else 0,
        'le': lambda a, b: 1 if a <= b else 0,
        'ge': lambda a, b: 1 if a >= b else 0,
        'add': lambda a, b: a + b,
        'sub': lambda a, b: a - b,
        'mul': lambda a, b: a * b,
        'div': lambda a, b: a / b,
        'rem': lambda a, b: a % b,
    }

    num_val = ops[op](l['imm'], r['imm'])

    if type.is_generic(type_result):
        # пересматриваем generic тип для нового значения (!)
        type_result = hlir_type_generic_int_for(num_val, unsigned=True, ti=ti)

    if not type.is_float(l['type']):
        num_val = int(num_val)

    bin_value = hlir_value_bin(op, l, r, type_result, ti=ti)

    bin_value['imm'] = num_val

    return bin_value





def value_strings_concat(l, r, ti):
    string = ""
    for c in l['imm']:
        if c != 0:
            string = string + chr(c)

    for c in r['imm']:
        if c != 0:
            string = string + chr(c)

    length = len(string) + 1  #!
    imm_str = hlir_string_imm(string)

    vol = hlir_value_int(length)
    genStrType = hlir_type_array(type.typeGenericChar, volume=vol, generic=True, ti=ti)

    bin_value = hlir_value_bin('add_str', l, r, genStrType, ti=ti)
    bin_value['imm'] = imm_str
    return bin_value


# FIXIT: it is generic arrays EQ!
def value_string_eq(l, r):
    if l['type']['volume']['imm'] != r['type']['volume']['imm']:
        return 0

    for a, b in zip(l['imm'], r['imm']):
        if a != b:
            return 0

    return 1



def do_value_bin_str_eq(op, l, r, ti):
    bool_result = value_string_eq(l, r)

    if op == 'eq':
        op = 'eq_str'

    elif op == 'ne':
        op = 'ne_str'
        bool_result = not bool_result

    bin_value = hlir_value_bin(op, l, r, type.typeBool, ti=ti)
    bin_value['imm'] = bool_result
    return bin_value



def do_value_bin(x):
    op = x['kind']
    l = do_rvalue(x['left'])
    r = do_rvalue(x['right'])
    ti = x['ti']

    if value_is_bad(l) or value_is_bad(r):
        return hlir_value_bad(ti)


    if not op in l['type']['ops']:
        error("unsuitable type", x['left']['ti'])
    if not op in r['type']['ops']:
        error("unsuitable type", x['right']['ti'])


    if type.is_pointer(l['type']) or type.is_pointer(r['type']):
        return do_bin_op_with_pointers(op, l, r, ti)


    if type.is_generic_string(l['type']) and type.is_generic_string(r['type']):
        if op == 'add':
            return value_strings_concat(l, r, ti)
        elif op in ['eq', 'ne']:
            return do_value_bin_str_eq(op, l, r, ti)


    common_type = bin_type_select(l['type'], r['type'])

    l = value_cons_implicit(l, common_type, x['left']['ti'])
    r = value_cons_implicit(r, common_type, x['right']['ti'])

    # After implicit cast types must be equal
    if not type.check(l['type'], r['type'], x['ti']):
        return hlir_value_bad(x['ti'])

    type_result = common_type

    if op in (EQ_OPS + RELATIONAL_OPS):
        type_result = type.typeBool


    if type.eq(type_result, type.typeBool):
        if op == 'or': op = 'logic_or'
        elif op == 'and': op = 'logic_and'


    # if left & right are immediate, we can fold const
    # and append field ['imm'] to bin_value
    if value_is_immediate(l) and value_is_immediate(r):
        return bin_imm(op, type_result, l, r, ti)


    return hlir_value_bin(op, l, r, type_result, ti=ti)



def do_value_not(val, t, ti):
    v = hlir_value_un('not', val, t, ti=ti)

    if value_is_immediate(val):
        num = ~val['imm']
        v['imm'] = num

    return v



def do_value_minus(val, t, ti):
    v = hlir_value_un('minus', val, t, ti=ti)

    if value_is_immediate(val):
        num = -val['imm']
        v['imm'] = num

    if type.is_generic(v['type']):
        if not type.is_signed(v['type']):
            #type.set_signed()
            v['type']['signed'] = True

    return v



def do_value_deref(val, t, ti):
    if not type.is_pointer(t):
        error("expected pointer", val)
        return hlir_value_bad(ti)

    to = t['to']
    # you can't deref pointer to function
    # and pointer to undefined array
    if type.is_func(to) or type.is_undefined_array(to):
        error("unsuitable type", val)

    return hlir_value_un('deref', val, to, ti=ti)



def do_value_ref(val, t, ti):
    if value_is_immutable(val):
        if not type.is_func(t):
            error("cannot get pointer to immutable value", ti)
    vt = hlir_type_pointer(t, ti=ti)
    return hlir_value_un('ref', val, vt, ti=ti)



def do_value_un(x):
    val = do_rvalue(x['value'])
    ti = x['ti']

    if value_is_bad(val):
        return val

    op = x['kind']


    if op != 'ref':
        if not op in val['type']['ops']:
            error("unsuitable type", x['value']['ti'])


    t = val['type']

    if op == 'not': return do_value_not(val, t, ti)
    elif op == 'minus': return do_value_minus(val, t, ti)
    elif op == 'deref': return do_value_deref(val, t, ti)
    elif op == 'ref': return do_value_ref(val, t, ti)



def do_value_call(x):
    f = do_rvalue(x['left'])

    if value_is_bad(f):
        return hlir_value_bad(x['ti'])

    ftype = f['type']

    # pointer to function?
    if type.is_pointer(ftype):
        ftype = ftype['to']

    if not type.is_func(ftype):
        error("expected function", x)

    params = ftype['params']
    args = x['args']

    npars = len(params)
    nargs = len(args)

    if nargs < npars:
        error("not enough args", x)
        return hlir_value_bad(x['ti'])

    if nargs > npars:
        if not 'arghack' in f['att']:
            error("too many args", x)
            return hlir_value_bad(x['ti'])

    args = []

    # normal args
    i = 0
    while i < npars:
        param = params[i]
        aa = x['args'][i]
        arg = do_rvalue(aa)

        if not value_is_bad(arg):
            arg = value_cons_implicit(arg, param['type'], aa['ti'])
            type.check(param['type'], arg['type'], aa['ti'])
            args.append(arg)

        i = i + 1


    # arghack rest args
    while i < nargs:
        aa = x['args'][i]
        arg = do_rvalue(aa)

        if not value_is_bad(arg):
            if type.is_generic(arg['type']):
                warning("value with non-generic type as extra argument", aa['ti'])
                arg = cons_default(arg, aa['ti'])
            args.append(arg)

        i = i + 1


    rv = hlir_value_call(f, ftype['to'], args, ti=x['ti'])

    if 'dispensable' in f['att']:
        rv['att'].append('dispensable')

    return rv


def do_value_index(x):
    a = do_rvalue(x['left'])

    if value_is_bad(a):
        return hlir_value_bad(x['ti'])

    typ = a['type']

    ptr_access = type.is_pointer(typ)
    if ptr_access:
        typ = typ['to']


    item_type = typ['of']

    # check if left type is valid
    if not (type.is_array(typ) or type.is_pointer(typ) or type.is_ptr_to_string(typ)):
        error("expected array or pointer to array", x)
        return hlir_value_bad(x['left']['ti'])

    i = do_rvalue(x['index'])

    if value_is_bad(i):
        return hlir_value_bad(x['index']['ti'])

    if not type.is_integer(i['type']):
        error("expected integer value", x['index'])


    i = value_cons_implicit(i, typeSysInt, i['ti'])

    v = None

    if ptr_access:
        v = hlir_value_index_array_by_ptr(a, i, ti=x['ti'])

#    elif type.is_generic_string(typ):
#        pass

    else:
        v = hlir_value_index_array(a, i, ti=x['ti'])
        if value_is_immutable(a):
            v['att'].append('immutable')


    # immediate index (!)
    if value_is_immediate(a) and not ptr_access:
        if value_is_immediate(i):
            index = i['imm']

            if index >= typ['volume']['imm']:
                error("array index out of bounds", x['index'])

            items = a['imm']
            item = items[index]

            if type.is_char(item_type):
                char_code = item
                char = hlir_value_char(char_code, type=None, ti=x['ti'])
                return char

            v['imm'] = item['imm']



    return v



def do_value_access(x):
    obj = do_rvalue(x['left'])

    if value_is_bad(obj):
        return hlir_value_bad(x['ti'])

    field_id = x['field']

    # доступ через переменную-указатель
    ptr_access = type.is_pointer(obj['type'])

    record_type = obj['type']
    if ptr_access:
        record_type = obj['type']['to']

    # check if is record
    if not type.is_record(record_type):
        error("expected record or pointer to record", x)
        return hlir_value_bad(x['left']['ti'])

    field = type.record_field_get(record_type, field_id['str'])

    # if field not found
    if field == None:
        error("undefined field '%s'" % field_id['str'], x)
        return hlir_value_bad(x['field']['ti'])

    if type.is_bad(field['type']):
        return hlir_value_bad(x['field']['ti'])



    if ptr_access:
        v = hlir_value_access_record_by_ptr(obj, field, ti=x['ti'])
    else:
        v = hlir_value_access_record(obj, field, ti=x['ti'])
        if value_is_immutable(obj):
            v['att'].append('immutable')


    # access to immediate object
    if value_is_immediate(obj) and not ptr_access:
        initializers = obj['imm']
        initializer = get_item_with_id(initializers, field_id['str'])
        v['imm'] = initializer['value']['imm']

    return v



def do_value_to(x):
    v = do_rvalue(x['value'])
    t = do_type(x['type'])
    if value_is_bad(v) or type.is_bad(t):
        return hlir_value_bad(x['ti'])
    return value_cons_explicit(v, t, x['ti'])



def do_value_id(x):
    id_str = x['id']['str']
    vx = value_get(id_str)
    if vx == None:
        error("undeclared value '%s'" % id_str, x)

        # чтобы не генерил ошибки дальше
        # создадим bad value и пропишем его глобально
        v = hlir_value_bad(x['ti'])
        value_attribute_add(v, 'unknown')
        module['context'].value_add(id_str, v)
        return hlir_value_bad(x['ti'])

    if 'usecnt' in vx:
        vx['usecnt'] = vx['usecnt'] + 1
    return vx


def do_value_str(x):
    string=x['str']
    length=x['len']
    ti=x['ti']

    vol = hlir_value_int(len(string) + 1)
    genStrType = hlir_type_array(type.typeGenericChar, volume=vol, generic=True, ti=ti)

    imm = hlir_string_imm(string)
    return hlir_value_literal(genStrType, imm, ti)



# было решено не пытаться приводить generic элементы массива
# к общему знаменателю, а оставить как есть;
# потом, когда массив будет приводиться к конкретному типу
# всплывут ошибки типизации если они есть.
# Сейчас не знаю правильно ли, но вроде так хоть работает

def do_value_array(x):
    items = []
    for item in x['items']:
        vi = do_value(item)
        vi['nl'] = item['nl']
        items.append(vi)

    length = len(x['items'])

    of = None
    if length > 0:
        of = items[0]['type']

    y = hlir_value_array(items, is_generic=True, ti=x['ti'])
    y['nl_end'] = x['nl_end']
    return y



def do_value_record(x):
    items = []
    fields = []
    i = 0
    for item in x['items']:
        id = item['id']

        val = do_value(item['value'])
        items.append({
            'isa': 'initializer',
            'id': id,
            'value': val,
            'nl': item['nl'],
            'att': [],
            'ti': item['ti']
        })

        # создаем поле для типа generic записи
        field = hlir_field(id, val['type'], pos=i, ti=val['ti'])
        fields.append(field)
        i = i + 1

    typ = hlir_type_record(fields, ti=x['ti'])
    typ['generic'] = True

    y = hlir_value_record(typ, items, ti=x['ti'])
    y['nl_end'] = x['nl_end']
    return y



def do_value_int(x):
    rv = hlir_value_int(x['num'], ti=x['ti'])

    rv['nsigns'] = x['nsigns']

    if 'hexadecimal' in x['att']:
        value_attribute_add(rv, 'hexadecimal')

    return rv


def do_value_float(x):
    return hlir_value_float(x['num'], ti=x['ti'])


def do_value_sizeof(x):
    of = do_type(x['type'])
    return hlir_value_sizeof(of, ti=x['ti'])


def do_value_alignof(x):
    of = do_type(x['type'])
    return hlir_value_alignof(of, ti=x['ti'])


def do_value_offsetof(x):
    of = do_type(x['type'])
    field_id = x['field']
    return hlir_value_offsetof(of, field_id, ti=x['ti'])


bin_ops = [
    'or', 'xor', 'and',
    'eq', 'ne', 'lt', 'gt', 'le', 'ge',
    'add', 'sub', 'mul', 'div', 'rem'
]

un_ops = ['ref', 'deref', 'plus', 'minus', 'not']



def do_rvalue(x):
    v = do_value(x)

    if 'writeonly' in v['type']['att']:
        error("attempt to read writeonly value", x['ti'])
        return hlir_value_bad(x['ti'])

    return value_load(v)



def do_value(x):
    k = x['kind']

    rv = None

    if k in bin_ops: rv = do_value_bin(x)
    elif k in un_ops: rv = do_value_un(x)
    else:
        if k == 'int': rv = do_value_int(x)
        elif k == 'float': rv = do_value_float(x)
        elif k == 'id': rv = do_value_id(x)
        elif k == 'str': rv = do_value_str(x)
        elif k == 'record': rv = do_value_record(x)
        elif k == 'array': rv = do_value_array(x)
        else:
            if k == 'call': rv = do_value_call(x)
            elif k == 'index': rv = do_value_index(x)
            elif k == 'access': rv = do_value_access(x)
            elif k == 'cast': rv = do_value_to(x)
            elif k == 'sizeof': rv = do_value_sizeof(x)
            elif k == 'alignof': rv = do_value_alignof(x)
            elif k == 'offsetof': rv = do_value_offsetof(x)
            elif k == 'shl': rv = do_value_shift(x)
            elif k == 'shr': rv = do_value_shift(x)

    if rv == None:
        rv = hlir_value_bad(x['ti'])

    assert('ti' in rv)

    return rv



#
# Do Statement
#

def do_stmt_if(x):
    c = do_value(x['cond'])
    t = do_stmt(x['then'])

    if value_is_bad(c) or stmt_is_bad(t):
        return hlir_stmt_bad()

    c = value_cons_implicit(c, type.typeBool, c['ti'])
    type.check(c['type'], type.typeBool, x['cond']['ti'])

    e = None
    if x['else'] != None:
        e = do_stmt(x['else'])
        if stmt_is_bad(e):
            return hlir_stmt_bad()

    return hlir_stmt_if(c, t, e, ti=x['ti'])



def do_stmt_while(x):
    c = do_value(x['cond'])
    s = do_stmt(x['stmt'])
    if value_is_bad(c) or stmt_is_bad(s):
        return hlir_stmt_bad()

    c = value_cons_implicit(c, type.typeBool, c['ti'])
    if not type.check(c['type'], type.typeBool, x['cond']['ti']):
        return hlir_stmt_bad()

    return hlir_stmt_while(c, s, ti=x['ti'])



def do_stmt_return(x):
    global cfunc

    f_ret_type = cfunc['type']['to']

    no_ret_func = type.eq(f_ret_type, type.typeUnit)

    if x['value'] == None:
        if not no_ret_func:
            error("expected return value", x)
        return hlir_stmt_return(ti=x['ti'])

    if no_ret_func:
        error("unexpected return value", x)

    v = do_value(x['value'])
    if value_is_bad(v):
        return hlir_stmt_bad()

    v = value_cons_implicit(v, f_ret_type, v['ti'])
    type.check(v['type'], f_ret_type, x['value']['ti'])

    return hlir_stmt_return(v, ti=x['ti'])



def do_stmt_again(x):
    return hlir_stmt_again(x['ti'])


def do_stmt_break(x):
    return hlir_stmt_break(x['ti'])



def do_stmt_var(x):
    id = x['id']

    t = None
    v = None

    if x['type'] != None:
        t = do_type(x['type'])

    if x['value'] != None:
        v = do_value(x['value'])
        if value_is_bad(v):
            return hlir_stmt_bad()
            # TODO: создавай переменную с value_bad!
            #return hlir_stmt_def_var(hlir_value_bad(x['ti']), None, ti=x['ti'])

    # error: no type, no init value
    if t == None and v == None:
        module['context'].value_add(id['str'], hlir_value_bad())
        return hlir_stmt_bad()

    if t != None:
        if type.is_bad(t):
            module['context'].value_add(id['str'], hlir_value_bad())
            return hlir_stmt_bad()

        if type.is_forbidden_var(t):
            error("unsuitable type", x['type'])

    # type & init value present
    if t != None and v != None:
        # type check
        v = value_cons_implicit(v, t, x['value']['ti'])
        type.check(t, v['type'], x['value']['ti'])


    if t == None:
        if type.is_generic(v['type']):
            v = cons_default(v, x['value']['ti'])

        t = v['type']


    # check if identifier is free (in current block)
    already = value_get_here(id['str'])
    if already != None:
        error("local id redefinition", x['id']['ti'])
        return hlir_stmt_bad()

    #
    var_value = hlir_value_var(id, t, v, ti=x['ti'])
    var_value['att'].extend(['local'])
    module['context'].value_add(id['str'], var_value)

    return hlir_stmt_def_var(var_value, v, ti=x['ti'])



def do_stmt_let(x):
    id = x['id']

    # check if identifier is free (in current block)
    already = value_get_here(id['str'])
    if already != None:
        error("local id redefinition", x['id']['ti'])
        return hlir_stmt_bad()


    v = do_rvalue(x['value'])

    if value_is_bad(v):
        module['context'].value_add(id['str'], hlir_value_bad())
        return hlir_stmt_bad()


    # add 'const' attribute to type
    # (used by C printer)
    typ = type.type_copy(v['type'])
    typ['att'].append('const')
    v['type'] = typ

    const_value = hlir_value_const(id, v['type'], value=v, ti=x['id']['ti'])
    const_value['att'].extend(['local']) # need for LLVM printer (!)

    if 'nl_end' in v:
        const_value['nl_end'] = v['nl_end']

    if value_is_immediate(v):
        const_value['imm'] = v['imm']

    module['context'].value_add(id['str'], const_value)

    return hlir_stmt_let(id, const_value, ti=x['ti'])



def do_stmt_assign(x):
    l = do_value(x['left'])
    r = do_value(x['right'])

    if value_is_bad(l) or value_is_bad(r):
        return hlir_stmt_bad()

    if value_is_immutable(l):
        error("immutable left", x['left']['ti'])
        return hlir_stmt_bad()

    # type check
    r = value_cons_implicit(r, l['type'], x['right']['ti'])
    type.check(l['type'], r['type'], x['ti'])

    return hlir_stmt_assign(l, r, ti=x['ti'])



def do_stmt_value(x):
    v = do_rvalue(x['value'])

    if value_is_bad(v):
        return hlir_stmt_bad()

    if not type.is_unit(v['type']):
        if not 'dispensable' in v['att']:
            warning("expression result unused", v['ti'])

    return hlir_stmt_value(v, ti=x['ti'])



def do_stmt_comment_line(x):
    return {
        'isa': 'stmt',
        'kind': 'comment-line',
        'lines': x['lines'],
        'nl': x['nl'],
        'ti': x['ti']
    }


def do_stmt_comment_block(x):
    return {
        'isa': 'stmt',
        'kind': 'comment-block',
        'text': x['text'],
        'nl': x['nl'],
        'ti': x['ti']
    }


def do_stmt(x):
    k = x['kind']

    s = None
    if k == 'let': s = do_stmt_let(x)
    elif k == 'block': s = do_stmt_block(x)
    elif k == 'value': s = do_stmt_value(x)
    elif k == 'assign': s = do_stmt_assign(x)
    elif k == 'return': s = do_stmt_return(x)
    elif k == 'if': s = do_stmt_if(x)
    elif k == 'while': s = do_stmt_while(x)
    elif k == 'var': s = do_stmt_var(x)
    elif k == 'again': s = do_stmt_again(x)
    elif k == 'break': s = do_stmt_break(x)
    elif k == 'comment-line': s = do_stmt_comment_line(x)
    elif k == 'comment-block': s = do_stmt_comment_block(x)
    else: s = hlir_stmt_bad()

    if 'nl' in x:
        s['nl'] = x['nl']

    return s



def do_stmt_block(x):
    module['context'] = module['context'].branch(domain='local')

    stmts = []
    for stmt in x['stmts']:
        s = do_stmt(stmt)
        if not stmt_is_bad(s):
            stmts.append(s)

    module['context'] = module['context'].parent_get()

    return hlir_stmt_block(stmts, ti=x['ti'], end_nl=x['end_nl'])



included_modules = {}
def do_import(x):
    impline = x['str']
    impline = impline[1:]
    impline = impline[:-1]

    # (!) right here, before calling "do_import" (!)
    att = attributes_get()
    # (!) ^^

    #print("INCLUDE: %s" % (x['str']))

    # get abspath
    abspath = import_abspath(impline)
    if abspath == None:
        error("module not found", x)
        fatal("module not found")
        return None


    global included_modules
    if abspath in included_modules:
        # already imported
        m = included_modules[abspath]
    else:
        m = translate(abspath)
        included_modules[abspath] = m


    # 1. НЕ добавляем символы из модуля в текущий
    # тк поиск символа идет рекурсивно по всем импортам
    #module['context'].merge(m['context'])    #!

    # 1. добавляем проимпортированный модуль в список нашего импорта

    # но сперва проверим нет ли его уже среди импортированных модулей
    for imported_module in module['imports']:
        if imported_module['source_info']['path'] == m['source_info']['path']:
            error("attempt to include module twice", x['ti'])

    if m != None:
        module['imports'].append(m)

    # 2. А в нашем модуле добавляем директиву инклуда
    directive = {
        'isa': 'directive',
        'kind': 'import',
        'str': impline[:-1],    # .hm -> .h
        'att': att,
        'local': True
    }

    return directive




# form directive '@property'
def extend_props(x):
    global properties
    x.update(properties)
    properties = {}




def def_const(x):
    id = x['id']
    v = do_value(x['value'])

    if value_is_bad(v):
        return hlir_def_const(v)

    if not value_is_immediate(v):
        if not value_is_ptr_to_str(v):
            error("expected immediate value", v)

    const_value = hlir_value_const(id, v['type'], v, x['ti'])

    if value_is_immediate(v):
        const_value['imm'] = v['imm']

    if 'nl_end' in v:
        const_value['nl_end'] = v['nl_end']

    atts = attributes_get()
    const_value['att'].extend(atts)

    extend_props(const_value)

    module['context'].value_add(id['str'], const_value)

    return hlir_def_const(const_value)



# удаляет ?? по имени
def module_remove_node(m, isa, id_str):
    #print(f"module_remove_node: {id_str}")

    for submodule in m['imports']:
        module_remove_node(submodule, isa, id_str)

    for x in m['text']:
        if isa in x:
            #if 'id' in x[isa]:
            if x[isa]['id']['str'] == id_str:
               #print("REMOVE: " + id_str)
                m['text'].remove(x)
                break



def def_type(x):
    id = x['id']
    #print("@type " + id['str'])

    ty = do_type(x['type'])
    if type.is_bad(ty):
        return None

    exist = type_get(id['str'])
    already_declared = exist != None

    nt = type.create_alias(id['str'], ty, id['ti'])
    extend_props(nt)
    nt['att'].extend(attributes_get())

    if already_declared:
        # just overwrite existed 'opaque' type (for records)
        exist.update(nt)
        # and find and remove declaration instruction
        if settings.check('backend', 'llvm'):
            module_remove_node(module, 'type', id['str'])

    else:
        module['context'].type_add(id['str'], nt)

    return hlir_def_type(nt, already_declared)



def def_var(x):
    f = do_field(x['field'])

    if f == None:
        return None

    if type.is_bad(f['type']):
        return None

    already = value_get(f['id']['str'])
    if already != None:
        error("redefinition of '%s'" % f['id']['str'], x['field']['ti'])

    if type.is_opaque(f['type']):
        error("cannot create variable with undefined type", x['type'])
        return None

    init_value = None

    if x['init'] != None:
        iv = do_value(x['init'])

        if not value_is_bad(iv):
            init_value = value_cons_implicit(iv, f['type'], x['init']['ti'])
            type.check(f['type'], init_value['type'], x['init']['ti'])

    var = hlir_value_var(f['id'], f['type'], init=init_value)
    var['att'].extend(attributes_get())
    var['att'].append('global')
    extend_props(var)

    module['context'].value_add(x['field']['id']['str'], var)

    return hlir_def_var(var)




def check_unuse(v):
    if v == None:
        return

    if not 'usecnt' in v:
        return

    if v['usecnt'] > 0:
        return

    id_str = v['id']['str']
    warning("value '%s' defined but not used" % (BOLD + id_str + ENDC), v['ti'])



# check block for unused vars
def check_block(block):
    for stmt in block['stmts']:
        check_stmt(stmt)



def check_stmt(stmt):
    k = stmt['kind']
    if k == 'let':
        check_unuse(stmt['value'])
    elif k == 'def_var':
        check_unuse(stmt['var'])
    elif k == 'if':
        check_block(stmt['then'])
        if stmt['else'] != None:
            check_stmt(stmt['else'])
    elif k == 'while':
        check_block(stmt['stmt'])



def def_func(x):
    global cfunc

    func_ti = x['ti']
    func_id = x['id']
    func_type = do_type(x['type'])

    old_cfunc = cfunc

    fn = None

    # if function already declared/defined, check it
    already = value_get(func_id['str'])
    if already != None:
        # function already declared & defined (incomplete definition)
        fn = already

        fn['decl_ti'] = fn['ti']

        if 'stmt' in already:
            # already defined function
            error("redefinition of", x['ti'])
        else:
            # already declared function
            if not type.eq(already['type'], func_type):
                error("definition not correspond to declatartion", x['ti'])
                info("firstly declared here", already['type']['ti'])

    else:
        # function already not declared & defined
        # create new function definition
        fn = hlir_value_func(func_id, func_type, ti=func_ti)

    cfunc = fn

    fn['ti'] = func_ti

    # create params context
    module['context'] = module['context'].branch(domain='local')

    atts = attributes_get()
    fn['att'].extend(atts)

    extend_props(fn)

    ast_params = func_type['params']
    params = []
    i = 0
    while i < len(ast_params):
        p = ast_params[i]
        p_id = p['id']

        param = hlir_value_const(p_id, p['type'], ti=p['ti'])
        param['att'].extend(['local'])
        module['context'].value_add(p_id['str'], param)
        params.append(param)
        i = i + 1


    fn['stmt'] = do_stmt_block(x['stmt'])

    # check unuse
    for param in params:
        check_unuse(param)

    check_block(fn['stmt'])

    # check if return present
    if not type.is_unit(fn['type']['to']):
        stmts = fn['stmt']['stmts']
        if len(stmts) == 0:
            warning("expected return operator at end", fn['stmt']['ti'])
        elif stmts[-1]['kind'] != 'return':
            warning("expected return operator at end", fn['stmt']['ti'])


    # remove params context
    module['context'] = module['context'].parent_get()

    # add function to parent (global) context
    module['context'].value_add(func_id['str'], fn)


    cfunc = old_cfunc

    # в LLVM если делаем func definition нельзя писать func declaration
    # поэтому удалим все сделаные ранее декларации (если они есть)
    if settings.check('backend', 'llvm'):
        module_remove_node(module, 'value', func_id['str'])

    return hlir_def_func(fn)



def decl_type(x):
    id = x['id']

    #info("decl_type " + id['str'], x['ti'])

    nt = {
        'isa': 'type',
        'kind': 'opaque',
        'generic': False,
        'id': id,
        'att': [],
        'ti': id['ti'],
    }

    module['context'].type_add(id['str'], nt)

    # С не печатает opaque, но LLVM печатает (!)
    declaration = hlir_decl_type(nt)

    nt['declaration'] = declaration

    if x['extern']:
        declaration['att'].append('extern')

    return declaration



def decl_func(x):
    id = x['id']
    functype = do_type(x['type'])

    #
    # Check if function already declared/defined
    #
    already = value_get(id['str'])
    if already != None:
        if 'stmt' in already:
            # already defined function
            info("function declaration after definition", x['ti'])

        else:
            # already declared function
            info("repeated function declaration", x['ti'])

        # check type of already created function
        if not type.eq(already['type'], functype):
            error("definition not correspond to function type", x['ti'])
            info("firstly declared here", already['type']['ti'])

        return

    func = hlir_value_func(id, functype, ti=x['ti'])
    func['att'].extend(['undefined'])

    atts = attributes_get()
    func['att'].extend(atts)

    if x['extern']:
        func['att'].append('extern')

    extend_props(func)

    module['context'].value_add(id['str'], func)

    return hlir_decl_func(func)




def comm_line(x):
    #print("ast_comment-line")
    y = {
        'isa': 'comment',
        'kind': 'line',
        'lines': x['lines'],
        'att': []
    }

    #y['att'].extend(attributes_get())
    return y


def comm_block(x):
    #print("ast_comment-block")
    y = {
        'isa': 'comment',
        'kind': 'block',
        'text': x['text'],
        'att': []
    }

    #y['att'].extend(attributes_get())
    return y



def proc(ast, source_info):
    global module
    old_module = module

    #print("PROC: id = %s" % id)

    new_context = root_context.branch()

    module = {
        'isa': 'module',
        'id': id,
        'source_info': source_info,
        'imports': [],
        'strings': [],  # (only for LLVM IR backend)
        'context': new_context,
        'text': []
    }


    for x in ast:
        isa = x['isa']
        kind = x['kind']

        y = None

        if isa == 'ast_definition':
            if kind == 'func': y = def_func(x)
            elif kind == 'type': y = def_type(x)
            elif kind == 'const': y = def_const(x)
            elif kind == 'var': y = def_var(x)

        elif isa == 'ast_declaration':
            if kind == 'func': y = decl_func(x)
            elif kind == 'type': y = decl_type(x)

        elif isa == 'ast_comment':
            if kind == 'line': y = comm_line(x)
            elif kind == 'block': y = comm_block(x)

        elif isa == 'ast_directive':
            if kind == 'pragma':
                exec(x['text'])
                continue

            elif kind == 'import':
                y = do_import(x)


        if y == None:
            continue

        y['nl'] = x['nl']

        module['text'].append(y)

    m = module
    module = old_module

    return m




# получает строку импорта (и неявно глобальный контекст)
# и возвращает полный путь к модулю
def import_abspath(s):
    is_local = s[0:2] == './' or s[0:3] == '../'

    f = ''
    if is_local:
        f = env_current_file_dir + '/' + s #[1:]

    else: # (global)
        f = lib_path + '/' + s

    if not os.path.exists(f):
        print("%s not exist" % f)
        return None

    return os.path.abspath(f)



def translate(srcname):
    assert(srcname != None)
    assert(srcname != "")

    if not os.path.exists(srcname):
        return None

    global env_current_file_abspath
    global env_current_file_dir
    old_env_current_file_dir = env_current_file_dir
    old_env_current_file_abspath = env_current_file_abspath

    absp = os.path.abspath(srcname)
    fdir = os.path.dirname(absp)

    env_current_file_abspath = absp
    env_current_file_dir = fdir

    source_info = {
        'id': srcname,
        'path': absp,
        'dir': fdir,
        'name': srcname,
    }


    ast = parser.parse(source_info)

    if ast == None:
        return None

    m = proc(ast, source_info)

    env_current_file_abspath = old_env_current_file_abspath
    env_current_file_dir = old_env_current_file_dir

    return m



