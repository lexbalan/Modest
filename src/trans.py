
import os

from error import *
from util import get_item_with_id, align_to
from main import settings
from frontend.parser import Parser


def is_local_context():
    global cfunc
    return cfunc != None


from value.value import *
from value.cons import value_cons_implicit, value_cons_explicit, value_cons_default

from symtab import Symtab
from util import nbits_for_num, nbytes_for_bits

import hlir.type as hlir_type
from hlir.field import hlir_field
from hlir.value import *
from hlir.stmt import *
from hlir.hlir import *


RET_SIZE_MAX = 16

# current file directory
env_current_file_abspath = ""
env_current_file_dir = ""

parser = Parser()

cfunc = None    # current function

root_context = None

module = None


# добавляет опцию в модуль ('use_extra_args', 'use_memcpy')
def module_option(option):
    global module
    if not option in module['options']:
        #print("module_option('%s')" % option)
        module['options'].append(option)


# тепреь вызывается только из конструктора строки (value)
def module_strings_add(v):
    module['strings'].append(v)



def module_type_get(m, id_str):
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
    directive_insert = {
        'isa': 'directive',
        'kind': 'insert',
        'str': s,
        'att': [],
        'nl': 1,
        'ti': None
    }
    module['text'].append(directive_insert)



lib_path = ""

typeSysChar = None
typeSysInt = None
typeSysNat = None
typeSysFloat = None
typeSysStr = None

valueNil = None
valueTrue = None
valueFalse = None


def init():
    global lib_path
    lib_path = settings.get('lib')

    hlir_init()

    hlir_type.type_init()

    valueNil = hlir_value_int(0, typ=hlir_type.typeFreePointer)
    valueTrue = hlir_value_int(1, typ=hlir_type.typeBool)
    valueFalse = hlir_value_int(0, typ=hlir_type.typeBool)

    global root_context
    # init main context
    root_context = Symtab()

    root_context.type_add('Unit', hlir_type.typeUnit)
    root_context.type_add('Bool', hlir_type.typeBool)

    root_context.type_add('Byte', hlir_type.typeByte)

    root_context.type_add('Char8', hlir_type.typeChar8)
    root_context.type_add('Char16', hlir_type.typeChar16)
    root_context.type_add('Char32', hlir_type.typeChar32)

    root_context.type_add('Int8', hlir_type.typeInt8)
    root_context.type_add('Int16', hlir_type.typeInt16)
    root_context.type_add('Int32', hlir_type.typeInt32)
    root_context.type_add('Int64', hlir_type.typeInt64)
    root_context.type_add('Int128', hlir_type.typeInt128)

    root_context.type_add('Nat8', hlir_type.typeNat8)
    root_context.type_add('Nat16', hlir_type.typeNat16)
    root_context.type_add('Nat32', hlir_type.typeNat32)
    root_context.type_add('Nat64', hlir_type.typeNat64)
    root_context.type_add('Nat128', hlir_type.typeNat128)

    root_context.type_add('Float16', hlir_type.typeFloat16)
    root_context.type_add('Float32', hlir_type.typeFloat32)
    root_context.type_add('Float64', hlir_type.typeFloat64)

    #root_context.type_add('Decimal32', hlir_type.typeDecimal32)
    #root_context.type_add('Decimal64', hlir_type.typeDecimal64)
    #root_context.type_add('Decimal128', hlir_type.typeDecimal128)

    root_context.type_add('Str8', hlir_type.typeStr8)
    root_context.type_add('Str16', hlir_type.typeStr16)
    root_context.type_add('Str32', hlir_type.typeStr32)

    root_context.type_add('Pointer', hlir_type.typeFreePointer)

    root_context.type_add('VA_List', hlir_type.typeVA_List)


    root_context.value_add('nil', valueNil)
    root_context.value_add('true', valueTrue)
    root_context.value_add('false', valueFalse)


    # Set taget depended Int & Nat types
    # (used in index, extra agrs & generic numeric var definitions)

    char_width = int(settings.get('char_width'))
    int_width = int(settings.get('integer_width'))
    flt_width = int(settings.get('float_width'))

    global typeSysInt, typeSysNat, typeSysFloat, typeSysChar, typeSysStr

    typeSysChar = hlir_type.type_select_char(char_width)
    typeSysInt = hlir_type.type_select_int(int_width)
    typeSysNat = hlir_type.type_select_nat(int_width)
    typeSysFloat = hlir_type.typeFloat64
    typeSysStr = hlir_type_pointer(hlir_type_array(typeSysChar))


# last fiels of record can be zero size array (!)
# (only with -funsafe key)
# pos - position #
# offset - real offset (address inside container struct)
def do_field(x):
    t = do_type(x['type'])

    if hlir_type.type_is_bad(t):
        t = hlir_type_bad(x['type']['ti'])

    f = hlir_field(x['id'], t, ti=x['ti'])

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
        nt = hlir_type.create_alias(id_str, tx, t['ti'])
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
        if value_is_bad(volume_expr):
            return hlir_type_bad(t['ti'])
    return hlir_type_array(of, volume=volume_expr, ti=t['ti'])



def do_type_record(x):
    fields = []

    for field in x['fields']:
        f = do_field(field)

        # redefinition?
        field_id_str = f['id']['str']
        field_already_exist = get_item_with_id(fields, field_id_str)
        if field_already_exist != None:
            error("redefinition of '%s' field" % field_id_str, f)
            continue


        if 'comments' in field:
            f.update({'comments': field['comments']})

        fields.append(f)

    return hlir_type_record(fields, ti=x['ti'])



def do_type_enum(t):
    enum_type = hlir_type_enum(t['ti'])

    i = 0
    for item in t['items']:
        id = item['id']
        enum_type['items'].append({
            'isa': 'enum_item',
            'id': id,
            'number': i,
            'ti': item['ti']
        })

        # add enum item to global context
        item_val = hlir_value_int(i, typ=enum_type, ti=item['ti'])
        item_val['id'] = id
        module['context'].value_add(id['str'], item_val)

        i = i + 1

    return enum_type



def do_type_func(t, func_id="_"):
    params = []

    for _param in t['params']:
        param = do_field(_param)
        pt = param['type']
        if hlir_type.type_is_array(pt):
            #info("array as function parameter", _param)
            nt = type_copy(pt)
            pt['att'].append('wrapped_array_type')
            pt['wrapped_id'] = 'struct ' + func_id + '_' + param['id']['str']
            param['type'] = pt

        if param != None:
            params.append(param)

    to = None
    if t['to'] != None:
        to = do_type(t['to'])

        if hlir_type.type_is_array(to):
            #info("array as function return value", t['to'])
            to = type_copy(to)
            to['att'].append('wrapped_array_type')
            to['wrapped_id'] = 'struct ' + func_id + '_' + 'retval'

    else:
        to = hlir_type.typeUnit

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

    if not hlir_type.type_is_integer(l['type']):
        error("type error", l)

    if not hlir_type.type_is_integer(r['type']):
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
            if hlir_type.type_is_generic(l['type']):
                # расширяем generic int тип чтобы в нем можно было сдвигать
                l['type']['width'] = nbits #!
                res_t = hlir_type_integer("Integer", width=nbits, ti=ti)
                res_t['generic'] = True
            else:
                if nbits > l['type']['width']:
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
            if hlir_type.type_is_generic(l['type']):
                t = hlir_type_integer("Integer", width=nbits, ti=ti)
                t['generic'] = True

            v = hlir_value_bin(op, l, r, t, ti=ti)
            v['imm'] = imm_result

            return v


    if hlir_type.type_is_generic(l['type']):
        error("required value with non-generic type", l)
        return hlir_value_bad(ti)


    return hlir_value_bin(op, l, r, l['type'], ti=ti)



# select result type of common binary operation
def bin_type_select(a, b):
    if hlir_type.type_is_generic(a) and hlir_type.type_is_generic(b):
        if a['width'] > b['width']:
            return a
        else:
            return b

    elif hlir_type.type_is_generic(a):
        return b

    elif hlir_type.type_is_generic(b):
        return a

    return a



# бинарные операции с указателями имеют особые правила
def do_bin_op_with_pointers(op, l, r , ti):
    # единственная безопасная операция для указателей - это сравнение
    if op in ['eq', 'ne']:
        # сравнивать можно только указатель с указателем
        if hlir_type.type_is_pointer(l['type']) and hlir_type.type_is_pointer(r['type']):

            # what about typeFreePointer?
            if hlir_type.type_is_free_pointer(l['type']):
                l = value_cons_implicit(l, r['type'], ti)
            elif hlir_type.type_is_free_pointer(r['type']):
                r = value_cons_implicit(r, l['type'], ti)

            return hlir_value_bin(op, l, r, hlir_type.typeBool, ti)

    from main import features
    if not features.get('unsafe'):
        error("illegal operation with pointers", ti)
        return hlir_value_bad(ti)


    # если включен unsafe режим
    if op in ['add', 'sub']:
        ptr_n_int = hlir_type.type_is_free_pointer(l['type']) and hlir_type.type_is_integer(r['type'])
        int_n_ptr = hlir_type.type_is_integer(l['type']) and hlir_type.type_is_free_pointer(r['type'])

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
        'logic_or': lambda a, b: a or b,
        'logic_and': lambda a, b: a and b,
        'or': lambda a, b: a | b,
        'and': lambda a, b: a & b,
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

    if hlir_type.type_is_generic(type_result):
        # пересматриваем generic тип для нового значения (!)
        type_result = hlir_type_generic_int_for(num_val, unsigned=True, ti=ti)

    if not hlir_type.type_is_float(l['type']):
        num_val = int(num_val)

    bin_value = hlir_value_bin(op, l, r, type_result, ti=ti)
    bin_value['imm'] = num_val
    return bin_value



def value_concat_arrays(l, r, ti):
    imm_str = l['imm'] + r['imm']
    length = len(imm_str) + 1  #!

    str_array_volume = hlir_value_int(length)
    generic = True  # не факт, анализируй a и b
    item_type = l['type']['of'] #hlir_type.typeChar32
    genStrType = hlir_type_array(item_type, volume=str_array_volume, ti=ti)
    genStrType['generic'] = True

    bin_value = hlir_value_bin('add_str', l, r, genStrType, ti=ti)
    bin_value['imm'] = imm_str
    bin_value['nl_end'] = r['nl_end']
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

    bin_value = hlir_value_bin(op, l, r, hlir_type.typeBool, ti=ti)
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
        return hlir_value_bad(x['ti'])

    if not op in r['type']['ops']:
        error("unsuitable type", x['right']['ti'])
        return hlir_value_bad(x['ti'])


    if hlir_type.type_is_pointer(l['type']) or hlir_type.type_is_pointer(r['type']):
        return do_bin_op_with_pointers(op, l, r, ti)


    if hlir_type.type_is_generic_array(l['type']) and hlir_type.type_is_generic_array(r['type']):
        if op == 'add':
            return value_concat_arrays(l, r, ti)
        elif op in ['eq', 'ne']:
            return do_value_bin_str_eq(op, l, r, ti)


    common_type = bin_type_select(l['type'], r['type'])

    l = value_cons_implicit(l, common_type, x['left']['ti'])
    r = value_cons_implicit(r, common_type, x['right']['ti'])

    # After implicit cast types must be equal
    if not hlir_type.check(l['type'], r['type'], x['ti']):
        return hlir_value_bad(x['ti'])

    type_result = common_type

    if op in (EQ_OPS + RELATIONAL_OPS):
        type_result = hlir_type.typeBool


    if hlir_type.type_eq(type_result, hlir_type.typeBool):
        if op == 'or': op = 'logic_or'
        elif op == 'and': op = 'logic_and'

    return _bin(op, type_result, l, r, ti)



def _bin(op, type_result, l, r, ti=None):
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

    if hlir_type.type_is_generic(v['type']):
        if hlir_type.type_is_unsigned(v['type']):
            #hlir_type.set_signed()
            v['type']['signed'] = True

    return v



def do_value_deref(val, t, ti):
    if not hlir_type.type_is_pointer(t):
        error("expected pointer", val)
        return hlir_value_bad(ti)

    to = t['to']
    # you can't deref pointer to function
    # and pointer to undefined array
    if hlir_type.type_is_func(to) or hlir_type.type_is_undefined_array(to):
        error("unsuitable type", val)

    return hlir_value_un('deref', val, to, ti=ti)



def do_value_ref(val, t, ti):
    if value_is_immutable(val):
        if not hlir_type.type_is_func(t):
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




def get_forms(func_id_str, args):
    forms = None
    # check format
    if func_id_str != None:
        if func_id_str == 'printf':
            forms = []
            aa = args[0]
            if aa['kind'] != 'str':
                warning("expected string literal", aa['ti'])
            else:
                s = aa['str']
                i = 0
                while i < len(s):
                    c = s[i]
                    if c == '%':
                        i = i + 1
                        c = s[i]
                        forms.append(c)

                    i = i + 1

        #print("printf forms = %s" % str(forms))
    return forms



def do_value_call(x):
    f = do_rvalue(x['left'])

    if value_is_bad(f):
        return hlir_value_bad(x['ti'])

    func_id_str = None
    if 'id' in f:
        func_id_str = f['id']['str']


    ftype = f['type']

    # pointer to function?
    if hlir_type.type_is_pointer(ftype):
        ftype = ftype['to']

    if not hlir_type.type_is_func(ftype):
        error("expected function", x)

    params = ftype['params']
    args = x['args']

    npars = len(params)
    nargs = len(args)

    if nargs < npars:
        error("not enough args", x)
        return hlir_value_bad(x['ti'])

    if nargs > npars:
        if not ftype['extra_args']:
            error("too many args", x)
            return hlir_value_bad(x['ti'])

    args = []

    # список спецификаторов для проверки расширеных аргументов
    forms = get_forms(func_id_str, x['args'])

    # normal args
    i = 0
    while i < npars:
        param = params[i]
        aa = x['args'][i]
        arg = do_rvalue(aa)

        if not value_is_bad(arg):
            arg = value_cons_implicit(arg, param['type'], aa['ti'])
            hlir_type.check(param['type'], arg['type'], aa['ti'])
            args.append(arg)

        i = i + 1


    j = 0
    # extra_args rest args
    while i < nargs:
        a = x['args'][i]
        arg = do_rvalue(a)
        arg_type = arg['type']

        if not value_is_bad(arg):

            # check extra args
            if forms != None:
                if forms != []:
                    form = forms[j]
                    if form in ['i', 'd', 'x']:
                        if not hlir_type.type_is_integer(arg_type):
                            warning("expected numeric value", a['ti'])
                    elif form == 's':
                        if not hlir_type.type_is_pointer_to_array_of_char(arg_type):
                            warning("expected pointer to string", a['ti'])
                    elif form == 'f':
                        if not hlir_type.type_is_float(arg_type):
                            warning("expected float value", a['ti'])
                    elif form == 'c':
                        if not hlir_type.type_is_char(arg_type):
                            warning("expected char value", a['ti'])
                    elif form == 'p':
                        if not hlir_type.type_is_pointer(arg_type):
                            warning("expected pointer value", a['ti'])



            if hlir_type.type_is_generic(arg_type):
                warning("value with generic type as extra argument", a['ti'])
                arg = value_cons_default(arg, a['ti'])

            args.append(arg)

        i = i + 1
        j = j + 1


    rv = hlir_value_call(f, ftype['to'], args, ti=x['ti'])

    if 'dispensable' in f['att']:
        rv['att'].append('dispensable')

    if hlir_type.type_is_defined_array(f['type']['to']):
        rv['att'].append('wrapped_array_value')

    return rv



def do_value_index(x):
    a = do_rvalue(x['left'])

    if value_is_bad(a):
        return hlir_value_bad(x['ti'])

    array_typ = a['type']

    # check if left type is valid
    ptr_access = False
    if hlir_type.type_is_array(array_typ):
        pass
    elif hlir_type.type_is_pointer_to_array(array_typ):
        ptr_access = True
        array_typ = array_typ['to']
    else:
        error("expected array or pointer to array", x)
        return hlir_value_bad(x['left']['ti'])


    i = do_rvalue(x['index'])

    if value_is_bad(i):
        return hlir_value_bad(x['index']['ti'])

    if not hlir_type.type_is_integer(i['type']):
        error("expected integer value", x['index'])


    i = value_cons_implicit(i, typeSysInt, i['ti'])

    v = None

    if ptr_access:
        v = hlir_value_index_array_by_ptr(a, i, ti=x['ti'])
    else:

        if type.type_is_generic(a['type']):
            if not value_is_immediate(i):
                error("cannot index generic array by variable", x['ti'])

        v = hlir_value_index_array(a, i, ti=x['ti'])

        if value_is_immutable(a):
            v['att'].append('immutable')

        if value_is_immediate(a):
            if value_is_immediate(i):
                index = i['imm']

                if index >= array_typ['volume']['imm']:
                    error("array index out of bounds", x['index'])

                items = a['imm']
                item = items[index]

                #if hlir_type.type_is_char(item_type):
                if hlir_type.type_is_char(array_typ['of']):
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
    ptr_access = hlir_type.type_is_pointer(obj['type'])

    record_type = obj['type']
    if ptr_access:
        record_type = obj['type']['to']

    # check if is record
    if not hlir_type.type_is_record(record_type):
        error("expected record or pointer to record", x)
        return hlir_value_bad(x['left']['ti'])

    field = hlir_type.record_field_get(record_type, field_id['str'])

    # if field not found
    if field == None:
        error("undefined field '%s'" % field_id['str'], x)
        return hlir_value_bad(x['field']['ti'])

    if hlir_type.type_is_bad(field['type']):
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
    if value_is_bad(v) or hlir_type.type_is_bad(t):
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
    ti=x['ti']

    vol = hlir_value_int(x['len'])  # <=> len(string) + 1
    genStrType = hlir_type_array(hlir_type.typeChar32, volume=vol, ti=ti)
    genStrType['generic'] = True

    imm = hlir_string_imm(x['str'])
    return hlir_value_literal(genStrType, imm, ti)



# было решено не пытаться приводить generic элементы массива
# к общему знаменателю, а оставить как есть;
# потом, когда массив будет приводиться к конкретному типу
# всплывут ошибки типизации если они есть.
# Сейчас не знаю правильно ли, но вроде так хоть работает

def do_value_array(x):
    items = []
    for item in x['items']:
        if item['isa'] == 'ast_comment':
            continue

        item_value = do_value(item)
        item_value['nl'] = item['nl']
        items.append(item_value)

    length = len(x['items'])

    of = None
    if length > 0:
        of = items[0]['type']

    v = hlir_value_array(items, ti=x['ti'])
    v['nl_end'] = x['nl_end']
    return v



def do_value_record(x):
    initializers = []
    fields = []
    for item in x['items']:
        if item['isa'] == 'ast_comment':
            continue

        item_id = item['id']
        item_value = do_value(item['value'])
        initializers.append({
            'isa': 'initializer',
            'id': item_id,
            'value': item_value,
            'nl': item['nl'],
            'att': [],
            'ti': item['ti']
        })

        # создаем поле для generic record
        field = hlir_field(item_id, item_value['type'], ti=item['ti'])
        fields.append(field)

    generic_record_type = hlir_type_record(fields, ti=x['ti'])
    generic_record_type['generic'] = True
    v = hlir_value_record(generic_record_type, initializers, ti=x['ti'])
    v['nl_end'] = x['nl_end']
    return v



def do_value_int(x):
    v = hlir_value_int(x['num'], ti=x['ti'])
    v['nsigns'] = x['nsigns']  # number of digits in literal (for printer)

    if 'hexadecimal' in x['att']:
        value_attribute_add(v, 'hexadecimal')

    return v


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

    if value_is_bad(c) or hlir_stmt_is_bad(t):
        return hlir_stmt_bad()

    c = value_cons_implicit(c, hlir_type.typeBool, c['ti'])
    hlir_type.check(c['type'], hlir_type.typeBool, x['cond']['ti'])

    e = None
    if x['else'] != None:
        e = do_stmt(x['else'])
        if hlir_stmt_is_bad(e):
            return hlir_stmt_bad()

    return hlir_stmt_if(c, t, e, ti=x['ti'])



def do_stmt_while(x):
    c = do_value(x['cond'])
    s = do_stmt(x['stmt'])

    if value_is_bad(c) or hlir_stmt_is_bad(s):
        return hlir_stmt_bad()

    c = value_cons_implicit(c, hlir_type.typeBool, c['ti'])
    if not hlir_type.check(c['type'], hlir_type.typeBool, x['cond']['ti']):
        return hlir_stmt_bad()

    return hlir_stmt_while(c, s, ti=x['ti'])



def do_stmt_return(x):
    global cfunc

    f_ret_type = cfunc['type']['to']
    no_ret_func = hlir_type.type_is_unit(f_ret_type)

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
    hlir_type.check(v['type'], f_ret_type, x['value']['ti'])

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
        if hlir_type.type_is_bad(t):
            module['context'].value_add(id['str'], hlir_value_bad())
            return hlir_stmt_bad()

        if hlir_type.type_is_forbidden_var(t):
            error("unsuitable type", x['type'])

    # type & init value present
    if t != None and v != None:
        # type check
        v = value_cons_implicit(v, t, x['value']['ti'])
        hlir_type.check(t, v['type'], x['value']['ti'])


    if t == None:
        if hlir_type.type_is_generic(v['type']):
            v = value_cons_default(v, x['value']['ti'])

        t = v['type']


    # check if identifier is free (in current block)
    already = value_get_here(id['str'])
    if already != None:
        error("local id redefinition", x['id']['ti'])
        return hlir_stmt_bad()

    var_value = add_local_var(id, t, v, x['ti'])
    return hlir_stmt_def_var(var_value, v, ti=x['ti'])



def add_local_var(id, typ, init_value, ti):
    var_value = hlir_value_var(id, typ, init_value, ti)
    var_value['att'].extend(['local'])
    module['context'].value_add(id['str'], var_value)
    return var_value



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


    if hlir_type.type_is_record(v['type']) or hlir_type.type_is_array(v['type']):
        module_option('use_memcpy')


    # add 'const' attribute to type
    # (used by C printer)
    typ = v['type']


    const_value = hlir_value_const(id, v['type'], value=None, ti=x['id']['ti'])
    const_value['att'].append('local') # need for LLVM printer (!)
    if value_is_immediate(v):
        const_value['imm'] = v['imm']

    if 'nl_end' in v:
        const_value['nl_end'] = v['nl_end']

    if value_is_immediate(v):
        const_value['imm'] = v['imm']

    module['context'].value_add(id['str'], const_value)

    stmt_let = hlir_stmt_let(id, const_value, ti=x['ti'])
    stmt_let['init_value'] = v
    return stmt_let



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
    hlir_type.check(l['type'], r['type'], x['ti'])

    if hlir_type.type_is_record(l['type']) or hlir_type.type_is_array(l['type']):
        module_option('use_memcpy')

    return hlir_stmt_assign(l, r, ti=x['ti'])



def do_stmt_incdec(x, op='add'):
    v = do_value(x['value'])

    if value_is_bad(v):
        return hlir_stmt_bad()

    if value_is_immutable(v):
        error("immutable value", x['left']['ti'])
        return hlir_stmt_bad()

    if not hlir_type.type_is_integer(v['type']):
        error("expected value with integer type", x['value']['ti'])
        return hlir_stmt_bad()

    one = hlir_value_int(1, typ=v['type'], ti=x['ti'])
    v_plus = _bin(op, v['type'], v, one, x['ti'])

    return hlir_stmt_assign(v, v_plus, ti=x['ti'])



def do_stmt_value(x):
    v = do_rvalue(x['value'])

    if value_is_bad(v):
        return hlir_stmt_bad()

    if not hlir_type.type_is_unit(v['type']):
        if not 'dispensable' in v['att']:
            warning("unused result of %s expression" % x['value']['kind'], v['ti'])

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
    elif k == 'var': s = do_stmt_var(x)
    elif k == 'block': s = do_stmt_block(x)
    elif k == 'assign': s = do_stmt_assign(x)
    elif k == 'value': s = do_stmt_value(x)
    elif k == 'if': s = do_stmt_if(x)
    elif k == 'while': s = do_stmt_while(x)
    elif k == 'return': s = do_stmt_return(x)
    elif k == 'again': s = do_stmt_again(x)
    elif k == 'break': s = do_stmt_break(x)
    elif k == 'inc': s = do_stmt_incdec(x, 'add')
    elif k == 'dec': s = do_stmt_incdec(x, 'sub')
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
        if not hlir_stmt_is_bad(s):
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

    #do_attributes(directive) @^^
    return directive



def def_const(x):
    id = x['id']
    v = do_value(x['value'])

    if value_is_bad(v):
        return hlir_def_const(v, id['ti'])

    if not value_is_immediate(v):
        if not type_is_pointer_to_array_of_char(v['type']):
            error("expected immediate value", v)

    const_value = hlir_value_const(id, v['type'], v, id['ti'])
    const_value['att'].append('global')

    if value_is_immediate(v):
        const_value['imm'] = v['imm']

    if 'nl_end' in v:
        const_value['nl_end'] = v['nl_end']

    module['context'].value_add(id['str'], const_value)

    obj = hlir_def_const(id, const_value, x['ti'])
    do_extend(obj)
    return obj


# удаляет ?? по имени
def module_remove_node(m, isa, id_str):
    #print(f"module_remove_node: {id_str}")

    for submodule in m['imports']:
        module_remove_node(submodule, isa, id_str)

    for x in m['text']:
        if isa in x:
            if x[isa]['id']['str'] == id_str:
                #print("REMOVE: " + id_str)
                m['text'].remove(x)
                break



def def_type(x):
    id = x['id']
    #print("@type " + id['str'])

    ty = do_type(x['type'])
    if hlir_type.type_is_bad(ty):
        return None

    exist = type_get(id['str'])
    already_declared = exist != None

    nt = hlir_type.create_alias(id['str'], ty, id['ti'])

    if already_declared:
        # just overwrite existed 'opaque' type (for records)
        exist.update(nt)
        # and find and remove declaration instruction
        if settings.check('backend', 'llvm'):
            module_remove_node(module, 'newtype', id['str'])

    else:
        module['context'].type_add(id['str'], nt)

    obj = hlir_def_type(id, ty, nt, already_declared, ti=x['ti'])
    do_extend(obj)
    return obj


def def_var(x):
    f = do_field(x['field'])

    # already defined?
    already = value_get(f['id']['str'])
    if already != None:
        error("redefinition of '%s'" % f['id']['str'], x['field']['ti'])

    var_type = f['type']

    if hlir_type.type_is_bad(var_type):
        return None

    if hlir_type.type_is_forbidden_var(var_type):
        error("unsuitable type", x['type'])

    init_value = None

    if x['init'] != None:
        iv = do_value(x['init'])
        if not value_is_bad(iv):
            init_value = value_cons_implicit(iv, var_type, x['init']['ti'])
            hlir_type.check(var_type, init_value['type'], x['init']['ti'])

    var = hlir_value_var(f['id'], var_type, init=init_value)

    module['context'].value_add(x['field']['id']['str'], var)

    obj = hlir_def_var(id, var, x['ti'])
    do_extend(obj)
    return obj




def check_unuse(v):
    if v == None:
        return

    if not 'usecnt' in v:
        return

    if v['usecnt'] > 0:
        return

    id_str = v['id']['str']
    info("value '%s' defined but not used" % (BOLD + id_str + ENDC), v['ti'])



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

    func_id = x['id']
    func_ti = func_id['ti']

    func_type = do_type_func(x['type'], func_id=func_id['str'])

    params = func_type['params']
    extra_args = False
    va_id = ""
    if len(params) > 1:
        last_param = params[-1]
        extra_args = hlir_type.type_is_va_list(last_param['type'])
        if extra_args:
            va_id = last_param['id']
            params.pop()


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
            if not hlir_type.type_eq(already['type'], func_type):
                error("definition not correspond to declatartion", x['ti'])
                info("firstly declared here", already['type']['ti'])

    else:
        # function already not declared & defined
        # create new function definition
        fn = hlir_value_func(func_id, func_type, ti=func_ti)

    if already == None:
        if func_type['to']['size'] > RET_SIZE_MAX:
            fn['att'].append('sret')
            module_option('use_memcpy')

    cfunc = fn

    fn['ti'] = func_ti

    # create params context
    module['context'] = module['context'].branch(domain='local')


    if already:
        fn['att'].append('declared')

    i = 0
    while i < len(params):
        param = params[i]
        param_id = param['id']

        param_value = hlir_value_const(param_id, param['type'], ti=param['ti'])
        param_value['att'].append('local')

        if hlir_type.type_is_defined_array(param['type']):
            param_value['att'].append('wrapped_array_value')

        module['context'].value_add(param_id['str'], param_value)
        i = i + 1


    if extra_args:
        cfunc['va_id'] = va_id
        func_type['extra_args'] = True
        add_local_var(va_id, last_param['type'], None, va_id['ti'])
        module_option('use_extra_args')


    fn['stmt'] = do_stmt_block(x['stmt'])

    # check unuse
    for param in params:
        check_unuse(param)

    check_block(fn['stmt'])

    # check if return present
    if not hlir_type.type_is_unit(fn['type']['to']):
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

    obj = hlir_def_func(func_id, fn, x['ti'])
    do_extend(obj)
    return obj



def decl_type(x):
    id = x['id']
    nt = hlir_type_opaque(id, id['ti'])
    module['context'].type_add(id['str'], nt)

    # С не печатает opaque, но LLVM печатает (!)
    obj = hlir_decl_type(id, nt, x['ti'])
    nt['declaration'] = obj

    if x['extern']:
        obj['att'].append('extern')

    do_extend(obj)
    return obj



def decl_func(x):
    func_id = x['id']
    func_type = do_type_func(x['type'], func_id=func_id['str'])

    #
    # Check if function already declared/defined
    #
    already = value_get(func_id['str'])
    if already != None:
        if 'stmt' in already:
            # already defined function
            info("function declaration after definition", x['ti'])

        else:
            # already declared function
            info("repeated function declaration", x['ti'])

        # check type of already created function
        if not hlir_type.type_eq(already['type'], func_type):
            error("definition not correspond to function type", x['type']['ti'])
            info("firstly declared here", already['type']['ti'])

        return

    func = hlir_value_func(func_id, func_type, ti=func_id['ti'])

    if already == None:
        if func_type['to']['size'] > RET_SIZE_MAX:
            func['att'].append('sret')
            module_option('use_memcpy')

    # check if last arg is VA_List
    # (in this case set ['extra_args'] = True)
    params = func_type['params']
    if len(params) > 1:
        last_param = params[-1]
        if hlir_type.type_is_va_list(last_param['type']):
            va_id = last_param['id']
            func_type['extra_args'] = True
            params.pop()


    if x['extern']:
        func['att'].append('extern')

    module['context'].value_add(func_id['str'], func)

    obj = hlir_decl_func(func_id, func, x['ti'])
    do_extend(obj)
    return obj



def comm_line(x):
    return {
        'isa': 'comment',
        'kind': 'line',
        'lines': x['lines'],
        'att': []
    }


def comm_block(x):
    return {
        'isa': 'comment',
        'kind': 'block',
        'text': x['text'],
        'att': []
    }


def proc(ast, source_info):
    global module
    old_module = module

    new_context = root_context.branch()

    module = {
        'isa': 'module',
        'id': id,
        'source_info': source_info,
        'imports': [],  #
        'strings': [],  # (used in LLVM backend)
        'context': new_context,
        'options': [],
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









def set_att(obj, path, att):
    #print(path)
    if len(path) == 1:
        #for o in obj:
        #    print(o)

        p = path[0]
        if p in obj:
            obj[p]['att'].append(att)
        else:
            error("attribute error: field '%s' not found" % p, obj['ti'])

    elif len(path) > 1:
        set_att(obj[path[0]], path[1:], att)

    else:
        assert(False)


def do_attributes(obj):
    atts = attributes_get()
    for att in atts:
        lr = att.split(":")
        if len(lr) == 1:
            att = lr[0]
            obj['att'].append(att)
        elif len(lr) > 1:
            att = lr[1]
            path = lr[0].split(".")
            #print([path, att])
            set_att(obj, path, att)


def set_prop(obj, path, val):
    if len(path) == 1:
        p = path[0]
        obj[p] = val
    elif len(path) > 1:
        if path[0] in obj:
            set_prop(obj[path[0]], path[1:], val)
        else:
            error("property error: field '%s' not found" % path[0], obj['ti'])

    else:
        assert(False)


# form directive '@property'
def do_properties(obj):
    global properties
    props = properties
    properties = {}

    for prop in props:
        k = prop
        v = props[prop]

        path_array = prop.split(".")
        if len(path_array) == 1:
            obj[path_array[0]] = v

        elif len(path_array) > 1:
            set_prop(obj, path_array, v)


def do_extend(obj):
    do_properties(obj)
    do_attributes(obj)


