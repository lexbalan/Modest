
import os

from opt import *
from error import *
from util import get_item_with_id


def is_local_context():
    global cfunc
    return cfunc != None


from value import *
from frontend.parser import Parser
from symtab import Symtab
import type
from type import type_attribute_check, select_int, select_nat, type_print
from util import nbits_for_num, nbytes_for_bits

from hlir import *



# current file directory
env_current_file_abspath = ""
env_current_file_dir = ""

parser = Parser()

cfunc = None    # current function

root_context = None

module = None


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
    #print("SEARCH_VALUE %s in %s" % (id_str, cm['path']))
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


# опциии компилятора, либо включена, либо выклчена
# впрочем может иметь и значение отлитчное от True
"""options = {}

def option(id, value=True):
    global options
    options[id] = value

def option_off(id):
    global options
    options[id] = False

def option_get(id):
    global options
    if not id in options:
        return None
    return options[id]
"""


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
typeSysFloat = None


int_size = 0    # sizeof(int)
ptr_size = 0    # sizeof(int *)


def init():
    global int_size, ptr_size, size_size
    int_size = int(settings_get('int'))
    ptr_size = int(settings_get('ptr'))

    global root_context
    # init main context
    root_context = Symtab()

    root_context.type_add('Unit', type.typeUnit)

    root_context.type_add('Int8', type.typeInt8)
    root_context.type_add('Int16', type.typeInt16)
    root_context.type_add('Int32', type.typeInt32)
    root_context.type_add('Int64', type.typeInt64)
    root_context.type_add('Int128', type.typeInt128)

    root_context.type_add('Nat1', type.typeNat1)
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

    root_context.type_add('Str', type.typeStr8)

    root_context.type_add('Str8', type.typeStr8)
    root_context.type_add('Str16', type.typeStr16)
    root_context.type_add('Str32', type.typeStr32)

    root_context.type_add('Pointer', type.typeFreePtr)

    root_context.type_add('Bool', type.typeNat1)


    root_context.value_add('nil', valueNil)
    root_context.value_add('true', valueTrue)
    root_context.value_add('false', valueFalse)


    # Set taget depended Int & Nat types
    # (used in index, extra agrs & generic numeric var definitions)

    global typeSysInt, typeSysNat, typeSysStr

    typeSysInt = type.type_copy(select_int(int_size))
    typeSysInt['c_alias'] = 'int'

    typeSysNat = type.type_copy(select_nat(int_size))
    typeSysNat['c_alias'] = 'unsigned int'

    sysCharSize = int(settings_get('char'))
    if sysCharSize == 8:
        typeSysStr = type.typeStr8
    elif sysCharSize == 16:
        typeSysStr = type.typeStr16
    elif sysCharSize == 32:
        typeSysStr = type.typeStr32

    typeSysFloat = type.typeFloat32




# last fiels of record can be zero size array (!)
# (only with -funsafe key)
def do_field(x, is_last=False):
    t = do_type(x['type'])

    if type.is_bad(t):
        t = hlir_type_bad(x['type']['ti'])

    if type.is_forbidden_var(t, zero_array_forbidden=not is_last):
        error("unsuitable type", x['type'])

    f = hlir_field(x['id'], t, ti=x['ti'])
    if 'nl' in x:
        f['nl'] = x['nl']
    else:
        f['nl'] = 0
    return f



def cons_default(x, ti):
    from_type = x['type']

    if not type.is_generic(from_type):
        return x

    if type.is_integer(from_type):
        # select type for default implementation of generic numeric
        req_sz = from_type['power']
        if req_sz < 32:
            req_sz = int(settings_get('int'))

        t = type.select_int(req_sz)
        return value_cast_implicit(x, t, ti)

    elif type.is_string(from_type):
        return value_cast_implicit(x, typeSysStr, ti)

    elif type.is_float(from_type):
        return value_cast_implicit(x, typeSysFloat, ti)

    else:
        fatal("unimplemented cons_default case")


    return hlir_value_bad(ti)




#
# Do Type
#

def do_type_id(t):
    tx = type_get(t['id']['str'])
    if tx == None:
        id = t['id']['str']
        error("undeclared type %s" % id, t)
        # create fake alias for unknown type
        tx = hlir_type_bad()
        nt = type.create_alias(id, tx, t['ti'])
        root_context.type_add(id, nt)
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

    nfields = len(t['fields'])
    i = 0
    while i < nfields:
        fe = t['fields'][i]
        f = do_field(fe, is_last=i==(nfields-1))
        f['no'] = i
        i = i + 1

        f_exist = get_item_with_id(fields, f['id']['str'])
        if f_exist != None:
            error("redefinition of '%s'" % f['id']['str'], f)
            continue

        if 'comments' in fe:
            f.update({'comments': fe['comments']})

        fields.append(f)

    return hlir_type_record(fields, ti=t['ti'])


def do_type_enum(t):

    enum_type = {
        'isa': 'type',
        'kind': 'enum',
        'items': [],
        'size': settings_get('enum_size'),
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
        nl = hlir_value_num_get(l)
        nr = hlir_value_num_get(r)

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
                res_t = hlir_type_generic_int_bits(nbits, unsigned=False, ti=ti)
            else:
                if nbits > l['type']['power']:
                    error("data loss left shift", ti)
                res_t = l['type']

            v = hlir_value_bin(op, l, r, res_t, ti=ti)
            value_set_imm(v, imm_result)
            return v


        elif op == 'shr':
            imm_result = nl >> nr

            # TODO: реализуй сдвиг влево!

            if type.is_generic(l['type']):
                # select new generic type for left (!)

                #print("NBITS = " + str(nbits))
                t = hlir_type_generic_int_bits(nbits, unsigned=False, ti=ti)
                l = do_cast_generic(l, t, x['left']['ti'])

            v = hlir_value_bin(op, l, r, l['type'], ti=ti)
            value_set_imm(v, imm_result)
            return v

    if type.is_generic(l['type']):
        error("required value with non-generic type", l)
        return hlir_value_bad(ti)

    return hlir_value_bin(op, l, r, l['type'], ti=ti)




# const folding for binary operation
def value_bin_fold(op, l, r, t, ti):
        pass


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



"""if not (p_and_n or n_and_p):
        if not type.check(l['type'], r['type'], x['ti']):
            return hlir_value_bad(x['ti'])"""

"""
    if not k in ['eq', 'ne']:
        if not k in ['add', 'sub']:    # add, sub, for free pointers
            if not type_attribute_check(l['type'], 'numeric'):
                error("expected value with numeric type", x['left'])
                return hlir_value_bad(ti)
            if not type_attribute_check(r['type'], 'numeric'):
                error("expected value with numeric type", x['right'])
                return hlir_value_bad(ti)"""

# бинарные операции с указателями имеют особые правила
def do_bin_op_with_pointers(k, l, r , ti):
    # единственная безопасная операция для указателей - это сравнение
    if k in ['eq', 'ne']:
        # сравнивать можно только указатель с указателем
        if type.is_pointer(l['type']) and type.is_pointer(r['type']):

            # what about typeFreePointer?
            if type.is_nil(l['type']):
                l = value_cast_implicit(l, r['type'], ti)
            elif type.is_nil(r['type']):
                r = value_cast_implicit(r, l['type'], ti)

            return hlir_value_bin(k, l, r, type.typeNat1, ti)


    if not 'unsafe' in features:
        error("illegal operation with pointers", ti)
        return hlir_value_bad(ti)


    # если включен unsafe режим
    if k in ['add', 'sub']:
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
            if k == 'add': num = hlir_value_num_get(l) + hlir_value_num_get(r)
            elif k == 'sub': num = hlir_value_num_get(l) - hlir_value_num_get(r)
            return hlir_value_int(num, typ=typ, ti=ti)

        # указатель или число в рантайме
        else:

            if ptr_n_int:
                lnat = do_cast_runtime(l, typeSysNat, ti)
                xr = value_cast_implicit(r, lnat['type'], ti)
                result = hlir_value_bin(x['kind'], lnat, xr, xr['type'], ti)
                return do_cast_runtime(result, l['type'], ti)

            if int_n_ptr:
                rnat = do_cast_runtime(r, typeSysNat, ti)
                xl = value_cast_implicit(l, rnat['type'], ti)
                result = hlir_value_bin(x['kind'], rnat, xl, xl['type'], ti)
                return do_cast_runtime(result, r['type'], ti)

        error("illegal operation with pointers", ti)
        return hlir_value_bad(ti)




def do_value_bin(x):
    k = x['kind']

    if k in ['shl', 'shr']:
        return do_value_shift(x)

    l = do_rvalue(x['left'])
    r = do_rvalue(x['right'])
    ti = x['ti']

    if value_is_bad(l) or value_is_bad(r):
        return hlir_value_bad(ti)



    if type.is_pointer(l['type']) or type.is_pointer(r['type']):
        return do_bin_op_with_pointers(k, l, r , ti)


    common_type = bin_type_select(l['type'], r['type'])

    l = value_cast_implicit(l, common_type, x['left']['ti'])
    r = value_cast_implicit(r, common_type, x['right']['ti'])

    if not type.check(l['type'], r['type'], x['ti']):
        return hlir_value_bad(x['ti'])

    type_result = common_type


    if k in ['eq', 'ne']:
        type_result = type.typeNat1

        if not type_attribute_check(l['type'], 'comparable'):
            error("expected value with comparable type", l['ti'])

        if not type_attribute_check(r['type'], 'comparable'):
            error("expected value with comparable type", r['ti'])

    # < > <= >= only for values with 'ordered' type
    elif k in ['lt', 'gt', 'le', 'ge']:
        type_result = type.typeNat1

        if not type_attribute_check(l['type'], 'ordered'):
            error("expected value with ordered type", l['ti'])

        if not type_attribute_check(r['type'], 'ordered'):
            error("expected value with ordered type", r['ti'])


    if type.eq(type_result, type.typeNat1):
        if k == 'or': k = 'logic_or'
        elif k == 'and': k = 'logic_and'

    bin_value = hlir_value_bin(k, l, r, type_result, ti=ti)

    # if left & right are immediate, we can fold const
    # and append field ['imm'] to bin_value
    if value_is_immediate(l) and value_is_immediate(r):
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

        num_val = ops[k](hlir_value_num_get(l), hlir_value_num_get(r))

        if not type.is_float(l['type']):
            num_val = int(num_val)

        value_set_imm(bin_value, num_val)

    return bin_value





def do_value_not(val, t, ti):
    v = hlir_value_un('not', val, t, ti=ti)

    if value_is_immediate(val):
        num = ~hlir_value_num_get(val)
        value_set_imm(v, num)

    return v


def do_value_minus(val, t, ti):
    v = hlir_value_un('minus', val, t, ti=ti)

    if value_is_immediate(val):
        num = -hlir_value_num_get(val)
        value_set_imm(v, num)

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

    t = val['type']

    if x['kind'] == 'not': return do_value_not(val, t, ti)
    elif x['kind'] == 'minus': return do_value_minus(val, t, ti)
    elif x['kind'] == 'deref': return do_value_deref(val, t, ti)
    elif x['kind'] == 'ref': return do_value_ref(val, t, ti)



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
        a = x['args'][i]
        arg = do_rvalue(a)

        if not value_is_bad(arg):
            arg = value_cast_implicit(arg, param['type'], a['ti'])
            type.check(param['type'], arg['type'], a['ti'])
            args.append(arg)

        i = i + 1


    # arghack rest args
    while i < nargs:
        arg = do_rvalue(x['args'][i])

        if not value_is_bad(arg):
            if type.is_generic(arg['type']):
                arg = cons_default(arg, arg['ti'])
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


    # check if left type is valid
    if not (type.is_array(typ) or type.is_pointer(typ) or type.is_string(typ)):
        error("expected array or pointer to array", x)
        return hlir_value_bad(x['left']['ti'])

    i = do_rvalue(x['index'])

    if value_is_bad(i):
        return hlir_value_bad(x['index']['ti'])

    if not type.is_integer(i['type']):
        error("expected integer value", x['index'])


    i = value_cast_implicit(i, typeSysInt, i['ti'])

    if ptr_access:
        v = hlir_value_index_array_by_ptr(a, i, ti=x['ti'])

    elif type.is_generic_string(typ):
        pass

    else:
        v = hlir_value_index_array(a, i, ti=x['ti'])
        if value_is_immutable(a):
            v['att'].append('immutable')


    # immediate index (!)
    if value_is_immediate(a) and not ptr_access:
        if value_is_immediate(i):
            index = hlir_value_num_get(i)

            #if index >= hlir_value_num_get(typ['volume']):
            #    error("array index out of bounds", x['index'])

            if type.is_generic_string(a['type']):
                # is generic string
                c = a['imm']['str'][index]
                return value_generic_char(c, ti=x['ti'])

            else:
                # is an array
                items = a['imm']
                v_imm = items[index]
                value_set_imm(v, v_imm['imm'])


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
        value_set_imm(v, initializer['value']['imm'])

    return v



def do_value_to(x):
    v = do_rvalue(x['value'])
    t = do_type(x['type'])
    if value_is_bad(v) or type.is_bad(t):
        return hlir_value_bad(x['ti'])
    return value_cast_explicit(v, t, x['ti'])



def do_value_id(x):
    id_str = x['id']['str']
    vx = value_get(id_str)
    if vx == None:
        error("undeclared value '%s'" % x['id']['str'], x)

        # чтобы не генерил ошибки дальше
        # создадим bad value и пропишем его глобально
        v = hlir_value_bad(x['ti'])
        value_attribute_add(v, 'unknown')
        module['context'].value_add(id_str, v)
        return hlir_value_bad(x['ti'])

    if 'usecnt' in vx:
        vx['usecnt'] = vx['usecnt'] + 1
    return vx


"""def do_value_ns(x):
    ns_id = x['ids'][0]
    id = x['ids'][1]

    ns_id_str = ns_id['str']
    if not ns_id_str in module['imwports']:
        error("namespace nof found", ns_id)

    return hlir_value_bad(ns_id['ti'])"""



# type of Cm generic string
def value_gstr(string, length, ti):
    s = hlir_value_cstr(string, length, type.typeGenericString, ti=ti)
    module['strings'].append(s)
    return s


def do_value_str(x):
    return value_gstr(string=x['str'], length=x['len'], ti=x['ti'])




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
        field = hlir_field(id, val['type'], ti=val['ti'])
        field['no'] = i
        fields.append(field)
        i = i + 1

    typ = hlir_type_record(fields, ti=x['ti'])
    typ['att'].extend(['generic'])

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



bin_ops = [
    'or', 'xor', 'and', 'shl', 'shr',
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

    c = value_cast_implicit(c, type.typeNat1, c['ti'])
    type.check(c['type'], type.typeNat1, x['cond']['ti'])

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

    c = value_cast_implicit(c, type.typeNat1, c['ti'])
    if not type.check(c['type'], type.typeNat1, x['cond']['ti']):
        return hlir_stmt_bad()

    return hlir_stmt_while(c, s, ti=x['ti'])



def do_stmt_return(x):
    global cfunc

    no_ret_func = type.eq(cfunc['type']['to'], type.typeUnit)

    if x['value'] == None:
        if not no_ret_func:
            error("expected return value", x)
        return hlir_stmt_return(ti=x['ti'])

    if no_ret_func:
        error("unexpected return value", x)

    v = do_value(x['value'])
    if value_is_bad(v):
        return hlir_stmt_bad()

    v = value_cast_implicit(v, cfunc['type']['to'], v['ti'])
    type.check(v['type'], cfunc['type']['to'], x['value']['ti'])

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
        v = value_cast_implicit(v, t, x['value']['ti'])
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

    if value_is_immediate(v):
        value_set_imm(const_value, v['imm'])

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
    r = value_cast_implicit(r, l['type'], x['right']['ti'])
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
        return hlir_def_const(id, v, ti=x['ti'])

    if not value_is_immediate(v):
        error("expected immediate value", v)

    const_value = hlir_value_const(id, v['type'], v, x['ti'])

    value_set_imm(const_value, v['imm'])

    atts = attributes_get()
    const_value['att'].extend(atts)

    extend_props(const_value)

    module['context'].value_add(id['str'], const_value)

    return hlir_def_const(const_value)



# удаляет ?? по имени
def module_remove_node(m, isa, id_str):
    for submodule in m['imports']:
        module_remove_node(submodule, isa, id_str)

    for x in m['text']:
        if isa in x:
            if 'id' in x[isa]:
                if x[isa]['id']['str'] == id_str:
                    #print("REMOVE: " + id_str)
                    m['text'].remove(x)
                    break
            else:
                # вот этот name убери к херам!! Сделай id как везде! FIXIT
                if x[isa]['name'] == id_str:
                    #print("REMOVE: " + id_str)
                    m['text'].remove(x)
                    break


def def_type(x):
    id = x['id']
    #print("@type " + id['str'])

    ty = do_type(x['type'])
    if type.is_bad(ty):
        return def_bad()

    exist = type_get(id['str'])
    already_declared = exist != None

    nt = type.create_alias(id['str'], ty, id['ti'])
    extend_props(nt)
    nt['att'].extend(attributes_get())

    if already_declared:
        # just overwrite existed 'opaque' type (for records)
        exist.update(nt)
        # and find and remove declaration instruction
        if settings_check('backend', 'llvm'):
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
            init_value = value_cast_implicit(iv, f['type'], x['init']['ti'])
            type.check(f['type'], init_value['type'], x['init']['ti'])

    var = hlir_value_var(f['id'], f['type'], init=init_value)

    var['att'].extend(attributes_get())

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

    vid = v['id']['str']
    warning("value '%s' defined but not used" % (BOLD + vid + ENDC), v['ti'])



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

# check block for unused vars
def check_block(block):
    for stmt in block['stmts']:
        check_stmt(stmt)



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
    if settings_check('backend', 'llvm'):
        module_remove_node(module, 'value', func_id['str'])

    return hlir_def_func(fn)



def decl_type(x):
    id = x['id']
    #print("decl_type " + id['str'])

    nt = {
        'isa': 'type',
        'kind': 'opaque',
        'name': id['str'],
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

    module = {
        'isa': 'module',
        'id': id,
        'source_info': source_info,
        'imports': [],
        'strings': [],
        'context': root_context.branch(),
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
        path_lib = settings_get('lib')
        f = path_lib + '/' + s

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
        'name':srcname,
    }


    ast = parser.parse(source_info)

    if ast == None:
        return None

    m = proc(ast, source_info)

    env_current_file_abspath = old_env_current_file_abspath
    env_current_file_dir = old_env_current_file_dir

    return m



