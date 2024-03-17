
import os

from error import *
from util import get_item_with_id
from main import settings
from frontend.parser import Parser

import foundation

from value.bool import value_bool
from value.integer import value_integer
from value.float import value_float
from value.array import value_array, value_string
from value.record import value_record


import decimal
# max number of signs after .
# decimal operation precision
decimal.getcontext().prec = settings.get('precision')


def is_local_context():
    global cfunc
    return cfunc != None


from value.value import *
from value.cons import value_cons_implicit, value_cons_explicit, value_cons_default

from symtab import Symtab
from util import nbits_for_num, nbytes_for_bits

#import hlir.type as hlir_type
from hlir.field import hlir_field
from hlir.stmt import *
from hlir.hlir import *



production = True
old_production = True


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


def module_append(definition):
    global module
    module['text'].append(definition)


# used in metadirs
def c_include(s):
    global module
    local = s[0:2] == './'
    inc = {
        'isa': 'directive',
        'kind': 'c_include',
        'c_name': s,
        'local': local,
        'att': [],
        'nl': 1,
        'ti': None
    }
    module_append(inc)


properties = {}


# used in metadirs
# add 'properties' to entity descriptor
def property(id, value):
    global properties
    properties[id] = value


def pragma(pg):
    #print("@pragma " +  pg)
    if pg == 'not_included':
        module['att'].append('not_included')



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
    module_append(directive_insert)


def feature(s):
    from main import features
    features.set(s)


lib_path = ""

typeSysChar = None
typeSysInt = None
typeSysNat = None
typeSysFloat = None
typeSysStr = None

valueNil = None
valueTrue = None
valueFalse = None

foundation_module = None

def init():
    global foundation_module, lib_path
    lib_path = settings.get('lib')

    hlir_init()

    foundation_module = foundation.init()

    valueNil = value_integer(0, typ=foundation.typeFreePointer)
    valueTrue = value_bool(1)
    valueFalse = value_bool(0)

    global root_context
    # init main context
    root_context = Symtab()

    root_context.type_add('Unit', foundation.typeUnit)
    root_context.type_add('Bool', foundation.typeBool)

    root_context.type_add('Byte', foundation.typeByte)

    root_context.type_add('Char8', foundation.typeChar8)
    root_context.type_add('Char16', foundation.typeChar16)
    root_context.type_add('Char32', foundation.typeChar32)

    root_context.type_add('Int8', foundation.typeInt8)
    root_context.type_add('Int16', foundation.typeInt16)
    root_context.type_add('Int32', foundation.typeInt32)
    root_context.type_add('Int64', foundation.typeInt64)
    root_context.type_add('Int128', foundation.typeInt128)

    root_context.type_add('Nat8', foundation.typeNat8)
    root_context.type_add('Nat16', foundation.typeNat16)
    root_context.type_add('Nat32', foundation.typeNat32)
    root_context.type_add('Nat64', foundation.typeNat64)
    root_context.type_add('Nat128', foundation.typeNat128)

    root_context.type_add('Float16', foundation.typeFloat16)
    root_context.type_add('Float32', foundation.typeFloat32)
    root_context.type_add('Float64', foundation.typeFloat64)

    #root_context.type_add('Decimal32', foundation.typeDecimal32)
    #root_context.type_add('Decimal64', foundation.typeDecimal64)
    #root_context.type_add('Decimal128', foundation.typeDecimal128)

    root_context.type_add('Str8', foundation.typeStr8)
    root_context.type_add('Str16', foundation.typeStr16)
    root_context.type_add('Str32', foundation.typeStr32)

    root_context.type_add('Pointer', foundation.typeFreePointer)

    root_context.type_add('VA_List', foundation.typeVA_List)


    compilerVersionMajor = value_integer(0, typ=foundation.typeNat32)
    root_context.value_add('__compilerVersionMajor', compilerVersionMajor)
    compilerVersionMinor = value_integer(7, typ=foundation.typeNat32)
    root_context.value_add('__compilerVersionMinor', compilerVersionMinor)

    import platform
    __platformSystem = value_string(platform.system())
    root_context.value_add('__platformSystem', __platformSystem)
    __platformRelease = value_string(platform.release())
    root_context.value_add('__platformRelease', __platformRelease)


    root_context.value_add('nil', valueNil)
    root_context.value_add('true', valueTrue)
    root_context.value_add('false', valueFalse)


    # Set taget depended Int & Nat types
    # (used in index, extra agrs & generic numeric var definitions)

    char_width = int(settings.get('char_width'))
    int_width = int(settings.get('integer_width'))
    flt_width = int(settings.get('float_width'))
    pointer_width = int(settings.get('pointer_width'))

    __systemCharWidth = value_integer(char_width, typ=foundation.typeNat32)
    root_context.value_add('__systemCharWidth', __systemCharWidth)
    __systemIntWidth = value_integer(int_width, typ=foundation.typeNat32)
    root_context.value_add('__systemIntWidth', __systemIntWidth)
    __systemFloatWidth = value_integer(flt_width, typ=foundation.typeNat32)
    root_context.value_add('__systemFloatWidth', __systemFloatWidth)
    __systemPointerWidth = value_integer(pointer_width, typ=foundation.typeNat32)
    root_context.value_add('__systemPointerWidth', __systemPointerWidth)

    #print("system_char_width  = %d" % char_width)
    #print("system_int_width  = %d" % int_width)
    #print("system_flt_width  = %d" % flt_width)

    global typeSysInt, typeSysNat, typeSysFloat, typeSysChar, typeSysStr

    typeSysChar = foundation.type_select_char(char_width)
    typeSysInt = foundation.type_select_int(int_width)
    typeSysNat = foundation.type_select_nat(int_width)
    typeSysFloat = foundation.typeFloat64
    typeSysStr = hlir_type.hlir_type_pointer(hlir_type.hlir_type_array(typeSysChar))


# last fiels of record can be zero size array (!)
# (only with -funsafe key)
# pos - position #
# offset - real offset (address inside container struct)
def do_field(x):
    t = do_type(x['type'])

    if hlir_type.type_is_bad(t):
        t = hlir_type.hlir_type_bad(x['type']['ti'])

    f = hlir_field(x['id'], t, ti=x['ti'])

    if 'nl' in x:
        f['nl'] = x['nl']
    else:
        f['nl'] = 1

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
        tx = hlir_type.hlir_type_bad()
        root_context.type_add(id_str, tx)
    return tx



def do_type_pointer(t):
    to = do_type(t['to'])
    return hlir_type.hlir_type_pointer(to, ti=t['ti'])



def do_type_array(t):
    of = do_type(t['of'])
    volume_expr = None
    if t['size'] != None:
        volume_expr = do_value(t['size'])
        if value_is_bad(volume_expr):
            return hlir_type.hlir_type_bad(t['ti'])
    return hlir_type.hlir_type_array(of, volume=volume_expr, ti=t['ti'])



anon_rec_cnt = 0
def do_type_record(x):
    global anon_rec_cnt
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

    anon_rec_cnt = anon_rec_cnt + 1
    rec = hlir_type.hlir_type_record(fields, ti=x['ti'])
    rec['end_nl'] = x['end_nl']
    # add anon record (before)
    anon_tag = '__anonymous_struct_%d' % anon_rec_cnt
    rec['aka'] = anon_tag
    module['anon_recs'].append(rec)

    return rec



def do_type_enum(t):
    enum_type = hlir_type.hlir_type_enum(t['ti'])

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
        item_val = value_integer(i, typ=enum_type, ti=item['ti'])
        item_val['id'] = id
        module['context'].value_add(id['str'], item_val)

        i = i + 1

    return enum_type



def do_type_func(t, func_id="_"):
    # check params
    var_args = False
    va_list_id = None
    params = []
    for _param in t['params']:
        param = do_field(_param)

        if param == None:
            continue

        pt = param['type']

        if var_args:
            error("VA_List must be last paramter", _param)

        if hlir_type.type_is_va_list(pt):
            var_args = True
            va_list_id = param['id']
            continue

        if hlir_type.type_is_array(pt):
            #info("array as function parameter", _param)
            nt = hlir_type.type_copy(pt)
            pt['att'].append('wrapped_array_type')
            pt['wrapped_id'] = 'struct ' + func_id + '_' + param['id']['str']
            param['type'] = pt

        params.append(param)


    to = None
    if t['to'] != None:
        to = do_type(t['to'])

        if hlir_type.type_is_array(to):
            #info("array as function return value", t['to'])
            to = hlir_type.type_copy(to)
            to['att'].append('wrapped_array_type')
            to['wrapped_id'] = 'struct ' + func_id + '_' + 'retval'

    else:
        to = foundation.typeUnit

    return hlir_type.hlir_type_func(params, to, var_args, va_list_id, ti=t['ti'])



def do_type(t):
    k = t['kind']
    if k == 'id': return do_type_id(t)
    elif k == 'func': return do_type_func(t)
    elif k == 'pointer': return do_type_pointer(t)
    elif k == 'array': return do_type_array(t)
    elif k == 'record': return do_type_record(t)
    elif k == 'enum': return do_type_enum(t)
    return bad_type(t['ti'])



#
# Do Statement
#

def do_value_shift(x):
    op = x['kind']  # 'shl', 'shr'
    l = do_rvalue(x['left'])
    r = do_rvalue(x['right'])
    ti = x['ti']

    if not hlir_type.type_is_integer(l['type']):
        error("type error", x['left'])

    if not hlir_type.type_is_integer(r['type']):
        error("type error", x['right'])

    if value_is_immediate(l) and value_is_immediate(r):
        return bin_imm(op, l['type'], l, r, ti)

    if hlir_type.type_is_generic(l['type']):
        error("expected non-generic value", l)
        return value_bad(ti)

    return value_bin(op, l, r, l['type'], ti=ti)



# select result type of binary operation result
def bin_type_select(a, b):
    if not hlir_type.type_is_generic(a):
        return a

    if not hlir_type.type_is_generic(b):
        return b

    if a['width'] > b['width']:
        return a
    else:
        return b



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

            return value_bin(op, l, r, foundation.typeBool, ti)

    from main import features
    if not features.get('unsafe'):
        error("unsafe operation", ti)
        return value_bad(ti)


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
            if op == 'add': num = l['asset'] + r['asset']
            elif op == 'sub': num = l['asset'] - r['asset']
            return value_integer(num, typ=typ, ti=ti)

        # указатель или число в рантайме
        else:

            if ptr_n_int:
                lnat = do_cast_runtime(l, typeSysNat, ti)
                xr = value_cons_implicit(r, lnat['type'], ti)
                result = value_bin(x['kind'], lnat, xr, xr['type'], ti)
                return do_cast_runtime(result, l['type'], ti)

            if int_n_ptr:
                rnat = do_cast_runtime(r, typeSysNat, ti)
                xl = value_cons_implicit(l, rnat['type'], ti)
                result = value_bin(x['kind'], rnat, xl, xl['type'], ti)
                return do_cast_runtime(result, r['type'], ti)

        error("invalid operation", ti)
        return value_bad(ti)



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
        'shl': lambda a, b: a << b,
        'shr': lambda a, b: a >> b,
    }

    num_val = ops[op](l['asset'], r['asset'])

    if hlir_type.type_is_generic(type_result):
        # пересматриваем generic тип для нового значения (!)
        type_result = hlir_type.hlir_type_generic_int_for(num_val, unsigned=True, ti=ti)

    if not hlir_type.type_is_float(l['type']):
        num_val = int(num_val)

    bin_value = value_bin(op, l, r, type_result, ti=ti)
    bin_value['asset'] = num_val
    return bin_value



def value_concat_arrays(l, r, ti):
    imm_str = l['asset'] + r['asset']
    length = len(imm_str) + 1  #!

    str_array_volume = value_integer(length)
    generic = True  # не факт, анализируй a и b
    item_type = l['type']['of'] #foundation.typeChar32
    genStrType = hlir_type.hlir_type_array(item_type, volume=str_array_volume, ti=ti)
    genStrType['generic'] = True

    bin_value = value_bin('add_str', l, r, genStrType, ti=ti)
    bin_value['asset'] = imm_str
    bin_value['nl_end'] = r['nl_end']
    return bin_value


# FIXIT: it is generic arrays EQ!
def value_eq_arrays(l, r, ti):
    lvolume = l['type']['volume']
    rvolume = r['type']['volume']
    if value_is_immediate(lvolume) and value_is_immediate(rvolume):
        if lvolume['asset'] != rvolume['asset']:
            return False
    else:
        fatal("dynamic immediate array volume", ti)

    for a, b in zip(l['asset'], r['asset']):
        if a != b:
            return False

    return True



def do_value_bin_str_eq(op, l, r, ti):
    bool_result = value_eq_arrays(l, r, ti)

    if op == 'eq':
        op = 'eq_str'

    elif op == 'ne':
        op = 'ne_str'
        bool_result = not bool_result

    bin_value = value_bin(op, l, r, foundation.typeBool, ti=ti)
    bin_value['asset'] = int(bool_result)
    return bin_value



def do_value_bin(x):
    op = x['kind']
    l = do_rvalue(x['left'])
    r = do_rvalue(x['right'])
    ti = x['ti']

    if value_is_bad(l) or value_is_bad(r):
        return value_bad(ti)


    if not op in l['type']['ops']:
        error("unsuitable type1", x['left']['ti'])
        return value_bad(x['ti'])

    if not op in r['type']['ops']:
        error("unsuitable type2", x['right']['ti'])
        return value_bad(x['ti'])


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
        return value_bad(x['ti'])

    type_result = common_type

    if op in (hlir_type.EQ_OPS + hlir_type.RELATIONAL_OPS):
        type_result = foundation.typeBool


    if hlir_type.type_eq(type_result, foundation.typeBool):
        if op == 'or': op = 'logic_or'
        elif op == 'and': op = 'logic_and'

    return _bin(op, type_result, l, r, ti)



def _bin(op, type_result, l, r, ti=None):
    # if left & right are immediate, we can fold const
    # and append field ['asset'] to bin_value
    if value_is_immediate(l) and value_is_immediate(r):
        return bin_imm(op, type_result, l, r, ti)

    return value_bin(op, l, r, type_result, ti=ti)




def do_value_un(x):
    v = do_value(x['value'])
    ti = x['ti']

    if value_is_bad(v):
        return v

    op = x['kind']
    vtype = v['type']

    if op == 'ref': #return do_value_ref(val, ti)
        if value_is_immutable(v):
            if not hlir_type.type_is_func(vtype):
                error("expected mutable value or function", x['value']['ti'])
                return value_bad(ti)
        vt = hlir_type.hlir_type_pointer(vtype, ti=ti)
        return value_un('ref', v, vt, ti=ti)

    else:

        if not op in v['type']['ops']:
            error("unsuitable type", x['value']['ti'])
            return value_bad(ti)

        v = value_load(v)


        if op == 'not':
            nv = value_un('not', v, vtype, ti=ti)

            if value_is_immediate(v):
                nv['asset'] = ~v['asset']

            return nv

        elif op == 'minus':
            if not hlir_type.type_is_signed(vtype):
                error("expected value with signed type", x['value']['ti'])

            nv = value_un('minus', v, vtype, ti=ti)

            if value_is_immediate(v):
                nv['asset'] = -v['asset']

                if hlir_type.type_is_generic(nv['type']):
                    nv['type'] = hlir_type.hlir_type_generic_int_for(v['asset'], unsigned=False, ti=ti)

            return nv

        elif op == 'deref':
            to = vtype['to']

            # you can't deref:
            #   - pointer to Unit
            #   - pointer to function
            #   - pointer to open array
            is_func_ptr = hlir_type.type_is_func(to)
            is_free_ptr = hlir_type.type_is_free_pointer(to)
            is_open_array_ptr =  hlir_type.type_is_open_array(to)
            if is_func_ptr or is_free_ptr or is_open_array_ptr:
                error("unsuitable type", x['value']['ti'])

            nv = value_un('deref', v, to, ti=ti)
            nv['immutable'] = False
            return nv




# for check printf/scanf params
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

    # for lengthof()
    if x['left']['kind'] == 'id':
        if x['left']['id']['str'] == 'lengthof':
            arg = do_rvalue(x['args'][0])
            if hlir_type.type_is_array(arg['type']):
                return value_lengthof(arg, ti=x['ti'])
            else:
                error("expected array value", x['args'][0]['ti'])
                return value_bad(x['ti'])



    f = do_rvalue(x['left'])

    if value_is_bad(f):
        return value_bad(x['ti'])

    func_id_str = None
    if 'id' in f:
        func_id_str = f['id']['str']

    ftype = f['type']

    # pointer to function?
    if hlir_type.type_is_pointer(ftype):
        ftype = ftype['to']

    if not hlir_type.type_is_func(ftype):
        error("expected function or pointer to function", x)

    params = ftype['params']
    args = x['args']

    npars = len(params)
    nargs = len(args)

    if nargs < npars:
        error("not enough args", x)
        return value_bad(x['ti'])

    if nargs > npars:
        if not ftype['extra_args']:
            error("too many args", x)
            return value_bad(x['ti'])

    args = []

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


    #
    # extra args
    #

    # список спецификаторов для проверки расширеных аргументов
    forms = get_forms(func_id_str, x['args'])

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
                    if form in ['i', 'd']:
                        if hlir_type.type_is_integer(arg_type):
                            if not hlir_type.type_is_signed(arg_type):
                                warning("expected signed integer value", a['ti'])
                        else:
                            warning("expected integer value", a['ti'])

                    elif form == 'x':
                        if not hlir_type.type_is_integer(arg_type):
                            warning("expected integer value", a['ti'])

                    elif form == 'u':
                        if hlir_type.type_is_integer(arg_type):
                            if hlir_type.type_is_signed(arg_type):
                                warning("expected unsigned integer value", a['ti'])
                        else:
                            warning("expected integer value", a['ti'])

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
                warning("extra argument with generic type", a['ti'])
                arg = value_cons_default(arg, a['ti'])

            args.append(arg)

        i = i + 1
        j = j + 1


    rv = value_call(f, ftype['to'], args, ti=x['ti'])

    if hlir_type.type_is_closed_array(f['type']['to']):
        rv['att'].append('wrapped_array_value')

    return rv



def do_value_index(x):
    left = do_rvalue(x['left'])

    if value_is_bad(left):
        return value_bad(x['ti'])

    left_typ = left['type']

    via_pointer = hlir_type.type_is_pointer(left_typ)

    array_typ = left_typ
    if via_pointer:
        array_typ = left_typ['to']


    if not hlir_type.type_is_array(array_typ):
        error("expected array or pointer to array", x['left']['ti'])
        return value_bad(x['ti'])


    index = do_rvalue(x['index'])

    if value_is_bad(index):
        return value_bad(x['ti'])

    if not hlir_type.type_is_integer(index['type']):
        error("expected integer value", x['index'])
        return value_bad(x['ti'])

    if hlir_type.type_is_generic(index['type']):
        index = value_cons_implicit(index, typeSysInt, index['ti'])

    v = None

    if via_pointer:
        v = value_index_array_by_ptr(left, index, ti=x['ti'])
    else:

        # error: cannot index generic array by variable
        #if hlir_type.type_is_generic(left['type']):
        #    if not value_is_immediate(index):
        #        error("cannot index generic array by variable", x['ti'])
        #        return value_bad(x['ti'])

        v = value_index_array(left, index, ti=x['ti'])

        if value_is_immutable(left):
            v['immutable'] = True


        if value_is_immediate(left):
            if value_is_immediate(index):
                index_imm = index['asset']

                if index_imm >= array_typ['volume']['asset']:
                    error("array index out of bounds", x['index'])
                    return value_bad(x['ti'])

                item = left['asset'][index_imm]

                #return item

                v['asset'] = item['asset']

    return v



def do_value_access(x):
    left = do_rvalue(x['left'])

    if value_is_bad(left):
        return value_bad(x['ti'])

    field_id = x['field']

    # доступ через переменную-указатель
    via_pointer = hlir_type.type_is_pointer(left['type'])

    record_type = left['type']
    if via_pointer:
        record_type = left['type']['to']

    # check if is record
    if not hlir_type.type_is_record(record_type):
        error("expected record or pointer to record", x)
        return value_bad(x['left']['ti'])

    field = hlir_type.record_field_get(record_type, field_id['str'])

    # if field not found
    if field == None:
        error("undefined field '%s'" % field_id['str'], x)
        return value_bad(x['field']['ti'])

    if hlir_type.type_is_bad(field['type']):
        return value_bad(x['field']['ti'])

    if via_pointer:
        v = value_access_record_by_ptr(left, field, ti=x['ti'])
    else:
        v = value_access_record(left, field, ti=x['ti'])
        if value_is_immutable(left):
            v['immutable'] = True

    # access to immediate object
    if value_is_immediate(left) and not via_pointer:
        initializers = left['asset']
        initializer = get_item_with_id(initializers, field_id['str'])
        v['asset'] = initializer['value']['asset']

    return v



def do_value_to(x):
    v = do_rvalue(x['value'])
    t = do_type(x['type'])
    if value_is_bad(v) or hlir_type.type_is_bad(t):
        return value_bad(x['ti'])
    return value_cons_explicit(v, t, x['ti'])



def do_value_id(x):
    id_str = x['id']['str']
    vx = value_get(id_str)

    if vx == None:
        error("undeclared value '%s'" % id_str, x)

        # чтобы не генерил ошибки дальше
        # создадим bad value и пропишем его глобально
        v = value_bad(x['ti'])
        value_attribute_add(v, 'unknown')
        module['context'].value_add(id_str, v)
        return value_bad(x['ti'])

    if 'usecnt' in vx:
        vx['usecnt'] = vx['usecnt'] + 1

    return vx




def do_value_str(x):
    return value_string(x['str'], length=x['len'], ti=x['ti'])



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

    v = value_array(items, ti=x['ti'])
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

    generic_record_type = hlir_type.hlir_type_record(fields, ti=x['ti'])
    generic_record_type['generic'] = True
    v = value_record(generic_record_type, initializers, ti=x['ti'])
    v['nl_end'] = x['nl_end']
    return v



def do_value_number(x):
    if '.' in x['numstr']:
        return do_value_float(x)
    else:
        return do_value_integer(x)



def do_value_integer(x):
    num_string_len = len(x['numstr'])
    base = 10
    if num_string_len > 2:
        if x['numstr'][0] == '0':
            if x['numstr'][1] == 'x':
                num_string_len = num_string_len - 2
                base = 16

    num = int(x['numstr'], base)
    v = value_integer(num, ti=x['ti'])
    v['nsigns'] = num_string_len

    if base == 16:
        value_attribute_add(v, 'hexadecimal')

    return v



def do_value_float(x):
    # in compile time floats stores as decimal (!)
    fval = decimal.Decimal(x['numstr'])
    fv = value_float(fval, ti=x['ti'])
    return fv


def do_value_sizeof(x):
    of = do_type(x['type'])
    return value_sizeof(of, ti=x['ti'])


def do_value_alignof(x):
    of = do_type(x['type'])
    return value_alignof(of, ti=x['ti'])


def do_value_offsetof(x):
    of = do_type(x['type'])
    field_id = x['field']
    return value_offsetof(of, field_id, ti=x['ti'])



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
        if k == 'number': rv = do_value_number(x)
        elif k == 'id': rv = do_value_id(x)
        elif k == 'str': rv = do_value_str(x)
        elif k == 'record': rv = do_value_record(x)
        elif k == 'array': rv = do_value_array(x)
        else:
            if k == 'call': rv = do_value_call(x)
            elif k == 'index': rv = do_value_index(x)
            elif k == 'access': rv = do_value_access(x)
            elif k == 'cast': rv = do_value_to(x)
            elif k == 'cons': rv = do_value_to(x)
            elif k == 'sizeof': rv = do_value_sizeof(x)
            elif k == 'alignof': rv = do_value_alignof(x)
            elif k == 'offsetof': rv = do_value_offsetof(x)
            elif k == 'shl': rv = do_value_shift(x)
            elif k == 'shr': rv = do_value_shift(x)

    if rv == None:
        rv = value_bad(x['ti'])

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

    if not hlir_type.type_is_bool(c['type']):
        error("expected bool value", x['cond']['ti'])
        return hlir_stmt_bad()

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

    if not hlir_type.type_is_bool(c['type']):
        error("expected bool value", x['cond']['ti'])
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
    var_id = x['id']

    t = None
    v = None

    if x['type'] != None:
        t = do_type(x['type'])

    v = None
    if x['value'] != None:
        v = do_value(x['value'])
        if value_is_bad(v):
            v = None

    # error: no type, no init value
    if t == None and v == None:
        module['context'].value_add(var_id['str'], value_bad())
        return hlir_stmt_bad()

    if t != None:
        if hlir_type.type_is_bad(t):
            module['context'].value_add(var_id['str'], value_bad())
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
    already = value_get_here(var_id['str'])
    if already != None:
        error("local id redefinition", x['id']['ti'])
        return hlir_stmt_bad()

    var_value = add_local_var(var_id, t, x['ti'])
    return hlir_stmt_def_var(var_value, v, ti=x['ti'])



def add_local_var(id, typ, ti):
    var_value = value_var(id, typ, ti)
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
        module['context'].value_add(id['str'], value_bad())
        return hlir_stmt_bad()


    if hlir_type.type_is_composite(v['type']):
        module_option('use_memcpy')


    # add 'const' attribute to type
    # (used by C printer)
    typ = v['type']


    const_value = value_const(id, v['type'], value=None, ti=x['id']['ti'])
    const_value['att'].append('local') # need for LLVM printer (!)
    if value_is_immediate(v):
        const_value['asset'] = v['asset']

    if 'nl_end' in v:
        const_value['nl_end'] = v['nl_end']

    if value_is_immediate(v):
        const_value['asset'] = v['asset']

    module['context'].value_add(id['str'], const_value)

    return hlir_stmt_let(id, v, const_value, ti=x['ti'])



def do_stmt_assign(x):
    l = do_value(x['left'])
    r = do_value(x['right'])

    if value_is_bad(l) or value_is_bad(r):
        return hlir_stmt_bad()

    if value_is_immutable(l):
        error("expected mutable value", x['left']['ti'])
        return hlir_stmt_bad()

    # type check
    r = value_cons_implicit(r, l['type'], x['right']['ti'])
    hlir_type.check(l['type'], r['type'], x['ti'])

    if hlir_type.type_is_composite(l['type']):
        module_option('use_memcpy')

    return hlir_stmt_assign(l, r, ti=x['ti'])



def do_stmt_incdec(x, op='add'):
    v = do_value(x['value'])

    if value_is_bad(v):
        return hlir_stmt_bad()

    if value_is_immutable(v):
        error("expected mutable value", x['left']['ti'])
        return hlir_stmt_bad()

    if not hlir_type.type_is_integer(v['type']):
        error("expected integer value", x['value']['ti'])
        return hlir_stmt_bad()

    one = value_integer(1, typ=v['type'], ti=x['ti'])
    v_plus = _bin(op, v['type'], v, one, x['ti'])

    return hlir_stmt_assign(v, v_plus, ti=x['ti'])



def do_stmt_value(x):
    v = do_rvalue(x['value'])

    if value_is_bad(v):
        return hlir_stmt_bad()

    if not hlir_type.type_is_unit(v['type']):
        if not 'dispensable' in v['type']['att']:
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
    import_expr = do_value(x['expr'])

    if not value_is_immediate(import_expr):
        error("expected immediate value", x['expr']['ti'])
        return None

    if not hlir_type.type_is_generic_array_of_char(import_expr['type']):
        error("expected string value", x['expr']['ti'])
        return None

    # Literal string to python string
    impline = ''
    for char in import_expr['asset']:
        impline = impline + chr(char['asset'])

    log('import "%s"' % impline)

    # (!) right here, before calling "do_import" (!)
    att = attributes_get()
    # (!) ^^

    abspath = import_abspath(impline)
    if abspath == None:
        error("module %s not found" % impline, x['expr']['ti'])
        fatal("cannot import module")
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
            error("attempt to include module twice", x['expr']['ti'])

    if m != None:
        module['imports'].append(m)

    # 2. А в нашем модуле добавляем директиву инклуда
    directive = {
        'isa': 'directive',
        'kind': 'import',
        'str': impline,            # ex: "libc/stdio"
        'c_name': impline + '.h',  # ex: "libc/stdio.h"
        'att': att,
        'module': m, # ссылка на сам модуль (для not_included)
        'local': True
    }

    #do_attributes(directive) @^^
    return directive



def def_const(x):
    id = x['id']

    log("def_const %s" % id['str'])

    # check if identifier is free
    pre_exist = value_get(id['str'])
    if pre_exist != None:
        error("redefinition of '%s'" % id['str'], id['ti'])

    if id['str'][0].isupper():
        error("constant id must starts with small letter", id['ti'])
        pass

    iv = do_value(x['value'])

    if value_is_bad(iv):
        return hlir_def_const(id, iv, iv, id['ti'])

    if not value_is_immediate(iv):
        if not type_is_pointer_to_array_of_char(iv['type']):
            error("expected immediate value", x['value'])

    const_value = value_const(id, iv['type'], iv, id['ti'])
    const_value['att'].append('global')


    if value_is_immediate(iv):
        const_value['asset'] = iv['asset']

    if 'nl_end' in iv:
        const_value['nl_end'] = iv['nl_end']

    module['context'].value_add(id['str'], const_value)
    return hlir_def_const(id, iv, const_value, x['ti'])



# удаляет hlir_node по isa & id_str
def module_remove_node(m, isa, id_str):
    #print(f"module_remove_node: {id_str}")

    for submodule in m['imports']:
        module_remove_node(submodule, isa, id_str)

    for x in m['text']:
        if x['isa'] == isa:
            if 'id' in x:
                if x['id']['str'] == id_str:
                    #print("REMOVE: " + id_str)
                    m['text'].remove(x)
                    break



def decl_type(x):
    id = x['id']
    log("decl_type %s" % id['str'])

    nt = hlir_type.hlir_type_opaque(id, id['ti'])
    module['context'].type_add(id['str'], nt)

    # С не печатает opaque, но LLVM печатает (!)
    obj = hlir_decl_type(id, nt, x['ti'])
    nt['declaration'] = obj
    return obj



def def_type(x):
    id = x['id']
    log("def_type %s" % id['str'])

    if id['str'][0].islower():
        error("type id must starts with big letter", id['ti'])

    pre_exist = type_get(id['str'])

    # check if identifier is free
    if pre_exist != None:
        if pre_exist['definition'] != None:
            error("redefinition of '%s'" % x['id']['str'], x['id']['ti'])


    already_declared = pre_exist != None

    _def = {
        'isa': 'def_type',
        'id': id,
        'type': None,
        'type': None,
        'afterdef': False,
        'att': [],
        'ti': x['ti']
    }


    if already_declared:
        # сохр ссылку на объявление в определении (пока просто на всякий)
        _def['declaration'] = pre_exist['declaration']
        # сохр в типе ссылку на определение (пока просто на всякий)
        pre_exist['definition'] = _def


    # только теперь обрабатываем поля,
    # тк там могут быть указатели на саму себя
    # а мы к этому заранее подготовлись
    ty = do_type(x['type'])

    if 'aka' in ty:
        del ty['aka']
        if ty in module['anon_recs']:
            module['anon_recs'].remove(ty)

    if hlir_type.type_is_bad(ty):
        return None

    _def['original_type'] = ty

    nt = hlir_type.type_copy(ty)
    nt['ti'] = id['ti']

    _def['type'] = nt
    nt['definition'] = _def


    if already_declared:
        _def['afterdef'] = True
        # just overwrite existed 'opaque' type (for records)
        pre_exist.update(nt)
        # and find and remove declaration instruction
        if settings.check('backend', 'llvm'):
            # LLVM не допускает переопределения типа
            # (после его декларации (как opaque))
            # поэтому удаляем
            module_remove_node(module, 'decl_type', id['str'])

        # (на всякий)
        nt['declaration'] = pre_exist['declaration']

    else:
        module['context'].type_add(id['str'], nt)

    return _def
    #return hlir_def_type(id, nt, ty, already_declared, ti=x['ti'])




def def_var(x):
    f = do_field(x['field'])
    id = f['id']

    log("def_var %s" % id['str'])

    if id['str'][0].isupper():
        error("variable id must starts with small letter", id['ti'])

    # already defined?
    already = value_get(id['str'])
    if already != None:
        error("redefinition of '%s'" % id['str'], x['field']['ti'])

    var_type = f['type']

    if hlir_type.type_is_bad(var_type):
        return None

    # если размер массива не указан
    # получим его из инициализатора
    arr_without_length = False
    if hlir_type.type_is_array(var_type):
        if var_type['volume'] == None:
            arr_without_length = True

    if not arr_without_length:
        if hlir_type.type_is_forbidden_var(var_type):
            error("unsuitable type", x['type'])

    init_value = None

    if x['init'] != None:
        iv = do_value(x['init'])
        if not value_is_bad(iv):

            # если размер массива не указан
            # получаем его из инициализатора
            if arr_without_length:
                init_arr_sz = iv['type']['volume']['asset']
                var_type['volume'] = value_integer(init_arr_sz)
                #print(init_arr_sz)

            init_value = value_cons_implicit(iv, var_type, x['init']['ti'])
            hlir_type.check(var_type, init_value['type'], x['init']['ti'])


    var = value_var(id, var_type)
    module['context'].value_add(x['field']['id']['str'], var)
    return hlir_def_var(id, init_value, var, x['ti'])




def check_unuse(v):
    if v == None:
        return

    if not 'usecnt' in v:
        return

    if v['usecnt'] > 0:
        return

    id_str = v['id']['str']
    info("value '%s' defined but not used" % id_str, v['ti'])



# check block for unused vars
def check_block(block):
    for stmt in block['stmts']:
        check_stmt(stmt)



def check_stmt(stmt):
    k = stmt['kind']
    if k == 'let':
        check_unuse(stmt['init_value'])
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

    if func_id['str'][0].isupper():
        error("function id must starts with small letter", func_id['ti'])

    func_ti = func_id['ti']

    func_type = do_type_func(x['type'], func_id=func_id['str'])
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
            error("redefinition of '%s'" % x['id']['str'], x['id']['ti'])
        else:
            # already declared function
            if not hlir_type.type_eq(already['type'], func_type):
                error("definition not correspond to declatartion", x['ti'])
                info("firstly declared here", already['type']['ti'])

    else:
        # function already not declared & defined
        # create new function definition
        fn = value_func(func_id, func_type, ti=func_ti)


    cfunc = fn

    fn['ti'] = func_ti

    # create params context
    module['context'] = module['context'].branch(domain='local')


    if already:
        fn['att'].append('declared')

    params = func_type['params']
    i = 0
    while i < len(params):
        param = params[i]
        param_type = param['type']
        param_id = param['id']

        param_value = value_const(param_id, param_type, ti=param['ti'])
        param_value['att'].append('local')

        if hlir_type.type_is_closed_array(param_type):
            param_value['att'].append('wrapped_array_value')

        module['context'].value_add(param_id['str'], param_value)
        i = i + 1


    if func_type['extra_args']:
        va_id = func_type['va_list_id']
        add_local_var(va_id, foundation.typeVA_List, va_id['ti'])
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
        module_remove_node(module, 'decl_func', func_id['str'])

    return hlir_def_func(func_id, fn, x['ti'])



def decl_func(x):
    id = x['id']
    func_type = do_type_func(x['type'], func_id=id['str'])

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
        if not hlir_type.type_eq(already['type'], func_type):
            error("definition not correspond to function type", x['type']['ti'])
            info("firstly declared here", already['type']['ti'])

        return

    func = value_func(id, func_type, ti=id['ti'])
    module['context'].value_add(id['str'], func)
    return hlir_decl_func(id, func, x['ti'])



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



# пропускать остальные ветви (elseif & else) условной директивы
# тк основная ветвь была выполнена
skipp = False
old_skipp = False

def do_directive(x):
    global skipp, old_skipp, production, old_production
    kind = x['kind']

    if kind == 'import':
        return do_import(x)

    elif kind == 'directive':
        #def pragma(cmd, args):
        #    exec("%s(%s)" % (cmd, str(args)))

        exec(x['text'])

    elif kind == 'if':
        old_production = production
        c = do_value(x['cond'])
        cond = False
        if not value_is_bad(c):
            if not value_is_immediate(c):
                error("expected immediate value", x['cond']['ti'])
            elif not hlir_type.type_is_bool(c['type']):
                error("expected bool value", x['cond']['ti'])
            else:
                cond = c['asset'] != 0

        #print("IF: " + str(cond))

        production = cond
        if cond:
            old_skipp = skipp
            skipp = True # skip another branches

    elif kind == 'elseif':
        production = False
        c = do_value(x['cond'])
        cond = False
        if not value_is_bad(c):
            if not value_is_immediate(c):
                error("expected immediate value", x['cond']['ti'])
            elif not hlir_type.type_is_bool(c['type']):
                error("expected bool value", x['cond']['ti'])
            else:
                cond = c['asset'] != 0

        #print("ELSEIF: " + str(cond))

        if not skipp:
            if cond:
                production = True
                skipp = True  # skip another branches

        #print("skipp after elseif = " + str(skipp))
    elif kind == 'else':
        #print("ELSE: " + str(skipp))
        production = not skipp

    elif kind == 'endif':
        skipp = old_skipp  # do not skip branches (for new if)
        production = old_production

    elif kind == 'info':
        v = do_value(x['value'])
        if not value_is_bad(v):
            if not hlir_type.type_is_array_of_char(v['type']):
                fatal("required value with Str type", x['ti'])
            elif not value_is_immediate(v):
                fatal("required immediate value", x['ti'])
            else:
                # (because v['asset'] is an array of UTF-32 codes)
                msg = str(bytes(v['asset']).decode())
                info(msg, x['ti'])

    elif kind == 'warning':
        v = do_value(x['value'])
        if not value_is_bad(v):
            if not hlir_type.type_is_array_of_char(v['type']):
                fatal("required value with Str type", x['ti'])
            elif not value_is_immediate(v):
                fatal("required immediate value", x['ti'])
            else:
                # (because v['asset'] is an array of UTF-32 codes)
                msg = str(bytes(v['asset']).decode())
                warning(msg, x['ti'])

    elif kind == 'error':
        v = do_value(x['value'])
        if not value_is_bad(v):
            if not hlir_type.type_is_array_of_char(v['type']):
                fatal("required value with Str type", x['ti'])
            elif not value_is_immediate(v):
                fatal("required immediate value", x['ti'])
            else:
                # (because v['asset'] is an array of UTF-32 codes)
                msg = str(bytes(v['asset']).decode())
                error(msg, x['ti'])
            exit(-1)

    return None



def proc(ast, source_info):
    global skipp, production, old_production

    global properties
    properties = {}
    global attributes
    attributes = []

    global module
    old_module = module


    new_context = root_context.branch()

    module = {
        'isa': 'module',
        'id': "id",
        'source_info': source_info,
        #'imports': [foundation_module],  #
        'imports': [],  #
        'strings': [],  # (used in LLVM backend)
        'context': new_context,
        'options': [],
        'anon_recs': [],  # anonymous records for C printer
        'att': [],
        'text': []
    }

    for x in ast:
        isa = x['isa']
        kind = x['kind']

        y = None

        if not production:
            if isa != 'ast_directive':
                continue
            elif not kind in ['elseif', 'else', 'endif']:
                continue

        if isa == 'ast_definition':
            if kind == 'func': y = def_func(x)
            elif kind == 'type': y = def_type(x)
            elif kind == 'const': y = def_const(x)
            elif kind == 'var': y = def_var(x)
            add_spices(y)

        elif isa == 'ast_declaration':
            if kind == 'func': y = decl_func(x)
            elif kind == 'type': y = decl_type(x)
            add_spices(y)

        elif isa == 'ast_comment':
            if kind == 'line': y = comm_line(x)
            elif kind == 'block': y = comm_block(x)

        elif isa == 'ast_directive':
            y = do_directive(x)


        if y == None:
            continue

        y['nl'] = x['nl']

        module_append(y)

    m = module
    module = old_module

    return m


imp_paths = []

# получает строку импорта (и неявно глобальный контекст)
# и возвращает полный путь к модулю
def import_abspath(s):
    s = s + ".hm"

    is_local = s[0:2] == './' or s[0:3] == '../'

    full_name = ''

    local_name = env_current_file_dir + '/' + s
    if is_local:
        full_name = local_name

    elif os.path.exists(local_name):
        full_name = local_name

    else:
        # imp_paths or lib_path

        # ищем в imp_paths
        for imp_path in imp_paths:
            p = imp_path + '/' + s
            if os.path.exists(p):
                full_name = p
                break

        if full_name == '':
            full_name = lib_path + '/' + s


    if not os.path.exists(full_name):
        print("%s not exist" % full_name)
        return None

    return os.path.abspath(full_name)



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
    if len(path) == 1:
        p = path[0]
        if p in obj:
            obj[p]['att'].append(att)
        else:
            error("attribute error: field '%s' not found" % p, obj['ti'])

    elif len(path) > 1:
        set_att(obj[path[0]], path[1:], att)

    else:
        assert(False)


# directive '@attribute'
def add_attributes(obj):
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
        f = path[0]
        obj[f] = val
        #print("-- SET %s %s" % (f, val))

    elif len(path) > 1:
        if path[0] in obj:
            set_prop(obj[path[0]], path[1:], val)
        else:
            error("property error: field '%s' not found" % path[0], obj['ti'])

    else:
        assert(False)


# directive '@property'
def add_properties(obj):
    global properties
    props = properties
    properties = {}

    for prop in props:
        k = prop
        v = props[prop]

        path_array = prop.split(".")
        set_prop(obj, path_array, v)



def add_spices(obj):
    if obj == None:
        global attributes
        attributes = []
        global properties
        properties = {}
        return

    add_properties(obj)
    add_attributes(obj)


