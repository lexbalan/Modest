
import copy
from .common import *
from error import info
import core.type as type
from core.type import type_attribute_check
from core.value import value_attribute_check, value_print, value_is_immediate
from core.hlir import hlir_type_pointer, hlir_value_int, hlir_value_num_get


LLVM_TARGET_TRIPLE = os.popen("llvm-config --host-target").read()[:-1]


INDENT_SYMBOL = " " * 2


func_context = None



def init():
    pass


def indent():
    ind(INDENT_SYMBOL)


def locals_push():
    func_context['locals'].append({})

def locals_pop():
    func_context['locals'].pop()

def locals_add(id, llval):
    func_context['locals'][-1][id] = llval

def locals_get(id):
    # идем по стеку контекстов вглубь в поиске id
    i = len(func_context['locals'])
    while i > 0:
        c = func_context['locals'][i - 1]
        if id in c:
            return c[id]
        i = i - 1
    return None





TYPE_BOOL = 'i1'


free_reg = 0

def reg_get():
    global func_context
    reg = func_context['free_reg']
    func_context['free_reg'] = func_context['free_reg'] + 1
    return str(reg)


def operation (op):
    reg = reg_get ()
    out("\n    %%%s = %s " % (reg, op))
    return reg


def operation_with_type(op, t):
    reg = operation(op)
    print_type(t)
    return reg



def ll_create_value_num(t, num):
    return {
        'isa': 'llvm_value',
        'class': 'num',
        'level': 'value',
        'imm': {'num': num},
        'type': t,
        'proto': None
    }

def ll_create_value_zero(t):
    return {
        'isa': 'llvm_value',
        'class': 'zero',
        'level': 'value',
        'type': t,
        'proto': None
    }

def ll_create_value_null(t):
    return {
        'isa': 'llvm_value',
        'class': 'null',
        'level': 'value',
        'type': t,
        'proto': None
    }

ll_value_zero = ll_create_value_num(type.typeInt32, 0)




def print_type_value(llvm_value):
    print_type(llvm_value['type'])
    out(" ")
    print_value(llvm_value)


def print_type_value_param(llvm_value):
    print_type(llvm_value['type'], arr_as_ptr_to_arr=True)
    out(" ")
    print_value(llvm_value)



def insertvalue(v, x, pos):
    #%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
    reg = operation('insertvalue')
    print_type_value(v)
    out(", ")
    print_type_value(x)
    out(", ")
    out('%d' % pos)
    return {
        'isa': 'llvm_value',
        'class': 'reg',
        'level': 'value',
        'reg': reg,
        'type': v['type'],
        'proto': v
    }



# from here:
# https://stackoverflow.com/questions/23624212/how-to-convert-a-float-into-hex
import struct

def float_to_hex(f):
        return hex(struct.unpack('<I', struct.pack('<f', f))[0])

def double_to_hex(f):
        return hex(struct.unpack('<Q', struct.pack('<d', f))[0])



def inline_cast(op, from_type, to_type, val):
    out("%s (" % op)
    print_type(from_type)
    out(" ")
    print_value(val)
    out(" to ")
    print_type(to_type)
    out(")")


def print_value_array(x):
    if len(x['items']) > 0:
        out("[\n")
        indent_up()
        n = len(x['items'])
        i = 0
        while i < n:
            item = x['items'][i]
            if i > 0:
                out(",\n")
            indent(); print_type_value(item);
            i = i + 1
        indent_down()
        out("\n"); indent(); out("]")
    else:
        out("zeroinitializer")


def print_value_record(x):
    #def print_type_value_value(llvm_value):
    #    print_type_value(llvm_value['value'])
    if len(x['items']) > 0:
        #o("{"); print_list_by(x['items'], print_type_value_value); out("}")
        out("{\n")
        indent_up()
        n = len(x['items'])
        i = 0
        while i < n:
            item = x['items'][i]
            if i > 0:
                out(",\n")
            indent(); print_type_value(item['value']);
            i = i + 1
        indent_down()
        out("\n"); indent(); out("}")
    else:
        out("zeroinitializer")

def print_value(x):
    c = x['class']
    if c == 'reg':
        out('%%%s' % x['reg'])
    elif c == 'stk':
        out('%%%s' % x['id'])
    elif c == 'mem':
        out('@%s' % x['id'])
    elif c == 'num':
        num = hlir_value_num_get(x)
        if type.is_integer(x['type']):
            out(str(num))

        elif type.is_pointer(x['type']):
            if hlir_value_num_get(x) == 0:
                out("null")
                return

            v = ll_create_value_num(type.typeNat64, hlir_value_num_get(x))
            inline_cast('inttoptr', v['type'], x['type'], v)

        else:
            #o(str(f'{num:f}'))
            out(str(double_to_hex(num)))

    elif c == 'str':
        out("@%s" % x['id'])

    elif c == 'array':
        print_value_array(x)

    elif c == 'record':
        print_value_record(x)

    elif c == 'cast':
        #o("bitcast ([%d x i8]* @%s to %%Str)" % (x['len'], x['id']))
        v = x['value']
        from_type = v['type']
        to_type = x['type']
        inline_cast('bitcast', from_type, to_type, v)

    elif c == 'zero':
        if type.is_numeric(x['type']):
            out("0")
        else:
            out("zeroinitializer")

    elif c == 'null':
        out("null")

    else:
        out("<unknown_value::%s>" % c)
        info("???", x['ti'])



def print_list_by(lst, method):
    i = 0
    while i < len(lst):
        if i > 0:
            out(", ")
        method(lst[i])
        i = i + 1


# функция может получать только указатель на массив
# если же в CM она получает массив то тут и в СИ она получает
# указатель на него, и потом копирует его во внутренний массив
def print_type(t, print_aka=True, arr_as_ptr_to_arr=False):
    k = t['kind']

    if print_aka:
        if 'llvm_alias' in t:
            out(t['llvm_alias'])
            return

        # иногда сюда залетают дженерики например в to левое:
        # let p = 0x12345678 to *Nat32
        if type.is_generic_integer(t):
            out("i%d" % t['power'])
            return

        if 'name' in t:
            out('%' + t['name'])
            return

    if type.is_record(t):
        out("{")
        fields = t['fields']
        i = 0
        while i < len(fields):
            field = fields[i]
            if i > 0: out(',')
            out("\n\t"); print_type(field['type'])
            i = i + 1
        out("\n}")

    elif type.is_enum(t):
        out("i16")

    elif type.is_pointer(t):
        if type.is_free_pointer(t) or type.is_nil(t):
            out("i8*")
        else:
            print_type(t['to']); out("*")


    elif type.is_array(t):
        out("[")
        array_size = t['volume']
        sz = 0
        if array_size != None:
            sz = hlir_value_num_get(array_size)

        out("%d x " % sz)
        print_type(t['of'])
        out("]")
        if arr_as_ptr_to_arr:
            out("*")

    elif type.is_func(t):
        print_type(t['to'])
        out("(")
        print_list_by(t['params'], lambda f: print_type(f['type'], arr_as_ptr_to_arr=True))
        out(")")

    elif type.is_integer(t):
        if 'llvm_alias' in t:
            out(t['llvm_alias'])
        #    return
        #o('%' + t['aka'])

    elif type.is_float(t):
        if 'llvm_alias' in t:
            out(t['llvm_alias'])


    elif type.is_opaque(t):
        out('opaque')



    else:
        out("<type:%s>" % k)




# получает на вход llvm_value
# и если оно adr то загружает его в регистр
# в любом другом случае просто возвращает исходное значение
def do_ld(x):
    if x['level'] != 'adr':
        return x

    # load when value#level == #adr
    reg = operation('load');
    typ = x['type']
    print_type(typ)
    out(", ")
    print_type(typ)
    out("* ")
    print_value (x)
    return {
        'isa': 'llvm_value',
        'class': 'reg',
        'level': 'value',
        'reg': reg,
        'type': x['type'],
        'proto': x
    }




REL_OPS = ['eq', 'ne', 'lt', 'gt', 'le', 'ge']


def get_bin_opcode(op, t):
    opcode = "<unknown opcode '%s'>" % op
    if op in ['eq', 'ne']:
        opcode = get_bin_opcode_f('icmp ' + op, 'fcmp o' + op, t)
    elif op in ['add', 'sub', 'mul']:
        opcode = get_bin_opcode_f(op, 'f' + op, t)
    elif op in ['and', 'or', 'xor', 'shl']:
        opcode = op
    elif op in ['div', 'rem']:
        opcode = get_bin_opcode_suf('s' + op, 'u' + op, 'f' + op, t)
    elif op in ['lt', 'gt', 'le', 'ge']:
        opcode = get_bin_opcode_suf('icmp s' + op, 'icmp u' + op, 'fcmp o' + op, t)
    elif op == 'shr':
        opcode = 'lshr'
        if type.is_signed(t):
            opcode = 'ashr'
    elif op == 'logic_or':
        opcode = 'or'
    elif op == 'logic_and':
        opcode = 'and'


    return opcode


def get_bin_opcode_f (op, fop, t): # ["sdiv", "udiv", "fdiv", x]
    if type.is_float(t):
        return fop
    return op


def get_bin_opcode_su (sop, uop, t): # ["icmp slt", "icmp ult", x]
    if type.is_unsigned(t):
        return uop
    return sop


def get_bin_opcode_suf (sop, uop, fop, t): # ["sdiv", "udiv", "fdiv", x]
    if type.is_float(t):
        return fop
    return get_bin_opcode_su(sop, uop, t)




def do_eval_binary (op, l, r, x): # ["add", "fadd", x]


    reg = operation_with_type (op, l['type'])
    out(" "); print_value (l); out(", "); print_value (r)

    return {
        'isa': 'llvm_value',
        'class': 'reg',
        'level': 'value',
        'reg': reg,
        'type': x['type'],
        'proto': x
    }


def do_eval_expr_bin(x):
    # if folded bin
    if 'num' in x['imm']:
        return ll_create_value_num(x['type'], hlir_value_num_get(x))

    opcode = get_bin_opcode(x['kind'], x['left']['type'])
    l = do_ld(do_eval(x['left']))
    r = do_ld(do_eval(x['right']))
    return do_eval_binary(opcode, l, r, x)




def do_eval_expr_un(v):

    ve = do_eval(v['value'])

    if v['kind'] == 'ref':
        nv = copy.copy(ve)
        nv['level'] = 'value'
        nv['proto'] = v    # for type
        return nv


    vx = do_ld(ve)    #!

    if v['kind'] == 'deref':
        nv = copy.copy(vx)
        nv['level'] = 'adr'
        nv['proto'] = v    # for type
        return nv

    reg = None
    if v['kind'] == 'not':
        #%10 = xor i32 %9, -1
        reg = operation('xor');
        out(" ");
        print_type(v['type'])
        out(" ");
        print_value(vx)
        out(", -1")


    elif v['kind'] == 'minus':

        #%10 = sub i32 0, %9

        z = ll_create_value_zero(v['type'])
        return do_eval_binary('sub', z, vx, v)

    else:
        reg = operation(v['kind']); out(" "); print_value(vx)

    return {
        'isa': 'llvm_value',
        'class': 'reg',
        'level': 'value',
        'reg': reg,
        'type': v['type'],
        'proto': v
    }


def do_eval_expr_call(v):
    # eval all args
    args = []
    for a in v['args']:
        arg = do_eval(a)
        # do not load arrays (because arrays passed by pointer inside)
        if not type.is_array(arg['type']):
            arg = do_ld(arg)
        args.append(arg)

    ftype = v['func']['type']

    # eval func
    f = do_eval(v['func'])

    if type.is_pointer(ftype):
        # pointer to array needs additional load
        f = do_ld(f)
        ftype = ftype['to']

    to_unit = type.eq(ftype['to'], type.typeUnit)

    # do call
    reg = 0
    if to_unit:
        lo("    call ")
    else:
        reg = operation("call")

    #%Int32(%Str, ...)
    print_type(ftype['to'])
    out("(")
    params = ftype['params']
    print_list_by(params, lambda par: print_type(par['type'], arr_as_ptr_to_arr=True))
    if 'arghack' in v['func']['att']:
        out(", ...")
    out(") ")

    print_value(f)
    out(" (")
    print_list_by(args, print_type_value_param)
    out(")")
    return {
        'isa': 'llvm_value',
        'class': 'reg',
        'level': 'value',
        'reg': reg,
        'type': v['type'],
        'proto': v
    }



# индекс не может быть i64 (!) (а только i32)
# t - тип самой записи или массива (без указателя)
def llvm_getelementptr(rec, rt, indexes, vt):
    # Прикол в том что индекс (i) структуры
    # не может быть i64 (!) (а только i32)
    reg = operation_with_type("getelementptr inbounds", rt)
    out(", ")
    print_type(rt)
    out("* ")
    print_value(rec)
    out(", ")
    print_list_by(indexes, print_type_value)

    return {
        'isa': 'llvm_value',
        'class': 'reg',
        'level': 'adr',
        'reg': reg,
        'type': vt,
        #'proto': v
    }



def do_eval_expr_index(v):
    array = do_eval(v['array'])
    array_type = array['type']
    result_type = v['type']
    index = do_ld(do_eval(v['index']))
    return llvm_getelementptr(array, array_type, (ll_value_zero, index), result_type)


def do_eval_expr_index_ptr(v):
    pointer = do_eval(v['pointer'])
    array_type = pointer['type']['to']
    result_type = v['type']
    index = do_ld(do_eval(v['index']))
    return llvm_getelementptr(pointer, array_type, (ll_value_zero, index), result_type)


# получает укзаатель на структуру x
# его тип
# носер поля (просто число)
# возвращает value:address для поля этой структуры
def do_eval_access_ptr(x, xt, field_no, vt):
    field_index = ll_create_value_num(type.typeInt32, field_no)
    return llvm_getelementptr(x, xt, (ll_value_zero, field_index), vt)


# возвращает значение поля из 'структуры по значению'
def extract_record_field(x, ft, field_no):
    reg = operation('extractvalue')
    print_type_value(x)
    out(', %d' % field_no)
    return {
        'isa': 'llvm_value',
        'class': 'reg',
        'level': 'value',
        'reg': reg,
        'type': ft,
        'proto': None
    }


def do_eval_access(rec, rt, pos, vt):
    # если это структура высичленная на ходу, у нее есть поле 'items'
    # там лежат записи вида {'id': ..., 'value': ...}
    # поле value ссылается при этом на уже вычисленное значение поля
    # ex: let p = {x=0, y=0};    p.x    // <--
    if 'items' in rec:
        try:
            return rec['items'][pos]['value']
        except:
            # если это например пустая структура ({})
            # вернем пустышку
            # это опасное решение, но пока не знаю другого
            # (если структура из которой конструировали была пуста)
            return ll_create_value_zero(vt)


    # если сама запись находится в регистре: (let rec = get_rec())
    if type.is_record(rec['type']) and rec['level'] == 'value':
        return extract_record_field(rec, vt, pos)


    # если работаем через 'переменую-указатель'
    # сперва нужно загрузить ее в регистр тем самым получим 'указатель'
    if type.is_pointer(rt):
        # pointer to record needs additional load
        rec = do_ld(rec)    # загружаем сам указатель
        rt = rt['to']

    return do_eval_access_ptr(rec, rt, pos, vt)


def do_eval_expr_access(v):
    rec = do_eval(v['record'])
    rt = v['record']['type']
    pos = v['field']['no']
    return do_eval_access(rec, rt, pos, v['type'])


def do_eval_expr_access_ptr(v):
    ptr = do_ld(do_eval(v['pointer']))
    rt = ptr['type']['to']
    pos = v['field']['no']
    return do_eval_access_ptr(ptr, rt, pos, v['type'])



"""
‘trunc .. to’ Instruction
‘zext .. to’ Instruction
‘sext .. to’ Instruction
‘fptrunc .. to’ Instruction
‘fpext .. to’ Instruction
‘fptoui .. to’ Instruction
‘fptosi .. to’ Instruction
‘uitofp .. to’ Instruction
‘sitofp .. to’ Instruction
‘ptrtoint .. to’ Instruction
‘inttoptr .. to’ Instruction
‘bitcast .. to’ Instruction
‘addrspacecast .. to’ Instruction
"""

# cast type a to type b
def select_cast_operator(a, b):

    signed = type.is_signed(b)

    if type.is_integer(a):
        if type.is_integer(b):
            if a['size'] < b['size']:
                if signed:
                    return 'sext'

                else:
                    return 'zext'

            elif a['size'] > b['size']:
                return 'trunc'

            else:
                return 'bitcast'

        elif type.is_pointer(b):
            return 'inttoptr'

        elif type.is_float(b):
            if type.is_signed(a):
                return 'sitofp'

            else:
                return 'uitofp'

    elif type.is_pointer(a):
        if type.is_pointer(b):
            return 'bitcast'

        elif type.is_integer(b):
            return 'ptrtoint'


    elif type.is_float(a):
        # Float -> Integer
        if type.is_integer(b):
            if type.is_signed(b):
                return 'fptosi'
            else:
                return 'fptoui'

        # Float -> Float
        elif type.is_float(b):
            if a['size'] < b['size']:
                return 'fpext'
            elif a['size'] > b['size']:
                return 'fptrunc'

    return 'uncast'



def do_eval_expr_to(v):

    if 'is-generic-cast' in v['att']:
        return do_eval_literal(v)
        #info("??", v['ti'])
        return

    value = v['value']
    from_type = value['type']
    to_type = v['type']

    # (STUB?) nil -> zeroinitializer
    if type.is_free_pointer(from_type):
        if value['imm'] != None:
            if hlir_value_num_get(value) == 0:
                return ll_create_value_null(to_type)

    y = do_ld(do_eval(value))
    opcode = select_cast_operator(from_type, to_type)
    reg = operation(opcode)
    print_type(from_type)
    out(" ")
    print_value(y)
    out(" to ")
    print_type(to_type)
    return {
        'isa': 'llvm_value',
        'class': 'reg',
        'level': 'value',
        'reg': reg,
        'type': to_type,
        'proto': v
    }





def do_eval_sizeof(x):
    # thx:
    # stackoverflow.com/questions/14608250/how-can-i-find-the-size-of-a-type
    #%Size = getelementptr %T* null, i32 1
    #%SizeI = ptrtoint %T* %Size to i32
    t = x['of']
    r0 = operation("getelementptr ")
    print_type(t); out(", ")
    print_type(t); out("* null, i32 1")
    r1 = operation("ptrtoint ")
    print_type(t); out("* %%%s to i64" % r0)

    return {
        'isa': 'llvm_value',
        'class': 'reg',
        'level': 'value',
        'reg': r1,
        'type': type.typeInt32,
        'proto': x
    }


bin_ops = [
    'logic_or', 'logic_and',
    'or', 'xor', 'and', 'shl', 'shr',
    'eq', 'ne', 'lt', 'gt', 'le', 'ge',
    'add', 'sub', 'mul', 'div', 'rem',
]

un_ops = ['ref', 'deref', 'plus', 'minus', 'not']



def do_eval_zero(x):
    #print("do_eval_zero")
    return ll_create_value_zero(x['type'])


def do_eval_array(v):
    # сперва вычисляем все элементы массива в регистры
    # (кроме констант, они едут до последнего)
    items = []
    for item in v['imm']:
        iv = do_ld(do_eval(item))
        items.append(iv)


    # теперь добавим паддинг нулевыми значениями
    fulllen = hlir_value_num_get(v['type']['volume'])
    n_pad = fulllen - len(items)
    i = 0
    while i < n_pad:
        z = ll_create_value_zero(v['type']['of'])
        items.append(z)
        i = i + 1


    # global?
    # глобальный массив распечатает print_value как литерал
    if func_context == None:
        return {
            'isa': 'llvm_value',
            'class': 'array',
            'level': 'value',
            'items': items,
            'proto': v
        }

    # local.

    # если мы локальны то создадим иммутабельную структуру
    # с массивом (insertvalue)
    #%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
    xv = ll_create_value_zero(v['type'])

    # набиваем массив
    i = 0
    while i < len(items):
        xv = insertvalue(xv, items[i], i)
        i = i + 1

    return xv



# вычисляем значение-запись по месту
# просто высичлим все его элементы и завернем все в 'llvm_value'/'record'
def do_eval_record(v):
    # сперва вычисляем все иницифлизаторы поелей структуры в регистры
    # (кроме констант, ведь они едут до последнего)

    items = []
    initializers = v['imm']
    for initializer in initializers:
        iv = do_ld(do_eval(initializer['value']))
        items.append({'id': initializer['id'], 'value': iv})

    return {
        'isa': 'llvm_value',
        'class': 'record',
        'level': 'value',
        'type': v['type'],
        'items': items,
        'proto': v
    }




def do_eval(x):
    assert(x != None)


    # compile time evaluation
    if 'immediate' in x['att']:
        if type.is_integer(x['type']):
            return ll_create_value_num(x['type'], hlir_value_num_get(x))


    # runtime evaluation
    v = do_eval_x(x)

    if v == None:
        print("do_eval_x(x) == None")
        print(x)
        exit(-1)

    assert(v != None)

    v['type'] = x['type']

    return v


def do_eval_str(x):
    # проблема строковых констант и strid
        if not 'strid' in x:
            if 'value' in x:
                return do_eval_x(x['value'])


        return {
            'isa': 'llvm_value',
            'class': 'mem',
            'level': 'value',
            'id': x['strid'],
            'type': x['type'],
            'proto': x
        }


def do_eval_literal(x):
    if type.is_integer(x['type']):
        return ll_create_value_num(x['type'], hlir_value_num_get(x))
    elif type.is_float(x['type']):
        return ll_create_value_num(x['type'], hlir_value_num_get(x))
    elif type.is_record(x['type']):
        return do_eval_record(x)
    elif type.is_array(x['type']):
        return do_eval_array(x)
    elif type.is_string(x['type']):
        return do_eval_str(x)
    elif type.is_free_pointer(x['type']):
        return ll_create_value_num(x['type'], hlir_value_num_get(x))
    elif type.is_pointer(x['type']):
        return ll_create_value_num(x['type'], hlir_value_num_get(x))


def func_const_var(x):
    k = x['kind']

    if k == 'const':
        if 'imm' in x:
            if type.is_numeric(x['type']):
                return ll_create_value_num(x['type'], hlir_value_num_get(x))

    if value_attribute_check(x, 'local'):
        localname = x['id']['str']
        y = locals_get(localname)
        return y

    if k == 'var':
        return {
            'isa': 'llvm_value',
            'class': 'mem',
            'level': 'adr',
            'id': x['id']['str'],
            'type': x['type'],
            'proto': x,    # need for load/store, because it is 'adr'
        }

    if k == 'const':
        return do_eval(x['value'])


    return {
        'isa': 'llvm_value',
        'class': 'mem',
        'level': 'value',
        'id': x['id']['str'],
        'type': x['type'],
        'proto': x
    }



def print_let_const(x):
    return func_const_var(x)



def do_eval_x(x):
    if x == None:
        return None

    k = x['kind']

    if k == 'literal': y = do_eval_literal(x)
    elif k in bin_ops: y = do_eval_expr_bin(x)
    elif k in un_ops: y = do_eval_expr_un(x)
    elif k == 'const': y = print_let_const(x)
    elif k in ['func', 'var']: y = func_const_var(x)
    elif k == 'call': y = do_eval_expr_call(x)
    elif k == 'index': y = do_eval_expr_index(x)
    elif k == 'index_ptr': y = do_eval_expr_index_ptr(x)
    elif k == 'access': y = do_eval_expr_access(x)
    elif k == 'access_ptr': y = do_eval_expr_access_ptr(x)
    elif k == 'cast': y = do_eval_expr_to(x)
    elif k == 'sizeof': y = do_eval_sizeof(x)
    else:
        out("<%s>" % k)
        y = None

    if y == None:
        print("do_eval_x cannot eval value")
        value_print(x)
        return ll_create_value_zero(x['type'])

    return y


#
#
#


# сохр простых значений
def ll_store(l, r):
    lo("    store ");
    print_type(r['type'])
    out(" ")
    print_value(r)
    out(", ")
    print_type(r['type'])
    out("* ")
    print_value(l)


# сохр структур (вот не может просто так сохранить, приходится по полю)
def ll_store_record(l, r):
    lo("\n; -- record assign")
    for field in l['type']['fields']:
        ft = field['type']

        # получаем указатель на поле левого (в которое будем сохранять)
        l_field_ptr = do_eval_access_ptr(l, l['type'], field['no'], ft)

        # получаем дескриптор правого поля
        #rfield = type.record_field_get(r['type'], field['id']['str'])

        # загружаем значение поля правого
        rv = do_ld(do_eval_access(r, r['type'], field['no'], ft))
        #rv = do_ld(do_eval_access(r, r['type'], rfield['no'], ft))

        # сохраняем
        ll_assign(l_field_ptr, rv)
    lo("; -- end record assign\n")



def ll_assign(l, r):
    if type.is_record(l['type']):
        return ll_store_record(l, r)

    ll_store(l, r)



def print_stmt_assign(x):
    r = do_ld(do_eval(x['right']))
    l = do_eval(x['left'])
    ll_assign(l, r)


def print_integer_block():
    out("<integer block>")



def ll_br(x, then_label, else_label):
    out("\n    br %s " % TYPE_BOOL)
    print_value(x)
    out(" , label %%%s, label %%%s" % (then_label, else_label))


def op_goto(label):
    out("\n    br label %%%s" % label)


def set_label(label):
    out("\n%s:" % label)


def print_stmt_if(x):
    global func_context
    if_id = func_context['if_no']
    func_context['if_no'] = func_context['if_no'] + 1
    cv = do_ld(do_eval(x['cond']))

    then_label = 'then_%d' % if_id
    else_label = 'else_%d' % if_id
    endif_label = 'endif_%d' % if_id

    if x['else'] == None:
        else_label = endif_label

    ll_br(cv, then_label, else_label)

    # then block
    set_label(then_label)
    print_stmt(x['then'])
    op_goto(endif_label)

    # else block
    if x['else'] != None:
        set_label(else_label)
        print_stmt(x['else'])
        op_goto(endif_label)

    # endif label
    set_label(endif_label)


def print_stmt_while(x):
    global func_context
    old_while_id = func_context['cur_while_id']
    func_context['while_no'] = func_context['while_no'] + 1
    cur_while_id = func_context['while_no']
    func_context['cur_while_id'] = cur_while_id

    again_label = 'again_%d' % cur_while_id
    break_label = 'break_%d' % cur_while_id
    body_label = 'body_%d' % cur_while_id

    op_goto(again_label)
    set_label(again_label)
    cv = do_ld(do_eval(x['cond']))
    ll_br(cv, body_label, break_label)
    set_label(body_label)
    print_stmt(x['stmt'])
    op_goto(again_label)
    set_label(break_label)
    func_context['cur_while_id'] = old_while_id


def print_stmt_again():
    global func_context
    cur_while_id = func_context['cur_while_id']
    op_goto('again_%d' % cur_while_id)
    reg_get()    # for LLVM


def print_stmt_break():
    global func_context
    cur_while_id = func_context['cur_while_id']
    op_goto('break_%d' % cur_while_id)
    reg_get()    # for LLVM


def print_stmt_return(x):
    v = None
    if x['value'] != None:
        v = do_ld(do_eval(x['value']))

    lo("    ret ")

    if v != None:
        print_type(x['value']['type'])
        out(" ")
        print_value(v)
    else:
        out("void")

    reg_get()    # for LLVM



def ll_alloca(id, typ, init_value):
    val = {
        'isa': 'llvm_value',
        'class': 'stk',
        'level': 'adr',
        'id': id,
        'type': typ,
        'proto': None,
    }

    lo("    %%%s = alloca " % id)
    print_type(typ)

    if init_value != None:
        r = do_ld(init_value)
        ll_assign(val, r)

    return val



def print_stmt_def_var(x):
    id = x['var']['id']['str']

    init_value = None
    if x['var']['init'] != None:
        init_value = do_eval(x['var']['init'])
    val = ll_alloca(id, x['var']['type'], init_value)
    locals_add(id, val)
    return None


def print_stmt_let(x):
    id = x['value']['id']
    val = x['value']['value']
    #value_print(val)
    v = do_ld(do_eval(val))
    locals_add(x['id']['str'], v)
    return None



def print_comment_block(x):
    #out("/*%s*/" % x['text'])
    pass


def print_comment_line(x):
    lines = x['lines']
    i = 0
    n = len(lines)
    while i < n:
        line = lines[i]
        #if need_indent:
        indent()
        out(";%s" % line['str'])
        i = i + 1
        if i < n:
            out("\n")


def print_stmt(x):
    k = x['kind']
    if k == 'block': print_stmt_block(x)
    elif k == 'value': do_eval(x['value'])
    elif k == 'assign': print_stmt_assign(x)
    elif k == 'return': print_stmt_return(x)
    elif k == 'if': print_stmt_if(x)
    elif k == 'while': print_stmt_while(x)
    elif k == 'def_var': print_stmt_def_var(x)
    elif k == 'let': print_stmt_let(x)
    elif k == 'break': print_stmt_break()
    elif k == 'again': print_stmt_again()
    elif k == 'comment-line': out("\n"); print_comment_line(x)
    elif k == 'comment-block': out("\n"); print_comment_block(x)
    else: lo("<stmt %s>" % str(x))



def print_arrays(arrays):
    for array in arrays:

        id = array['id']['str']
        iv = ll_create_value_zero(array['type'])
        val = ll_alloca(id, array['type'], None)
        locals_add('_' + id, val)

        #from core.trans import value_create_int

        memcpy_type = {
            'isa': 'type',
            'kind': 'func',
            'params': [
                {
                    'isa': 'field',
                    'id': {'isa': 'id', 'str': "dst", 'ti': None},
                    'type': type.typeFreePtr,
                    'ti': None
                },

                {
                    'isa': 'field',
                    'id': {'isa': 'id', 'str': "src", 'ti': None},
                    'type': type.typeFreePtr,
                    'ti': None
                },

                {
                    'isa': 'field',
                    'id': {'isa': 'id', 'str': "len", 'ti': None},
                    'type': type.typeInt64,
                    'ti': None
                },

            ],

            'to': type.typeFreePtr,
            'att': [],
            'ti': None
        }


        fmemcpy = {
            'isa': 'value',
            'kind': 'func',
            'id': {'isa': 'id', 'str': "memcpy", 'ti': None},
            'type': memcpy_type,
            'att': [],
            'ti': None
        }


        args = [
            {
                'isa': 'value',
                'kind': 'cast',

                'value': {
                    'isa': 'value',
                    'kind': 'var',
                    'id': {'isa': 'id', 'str': val['id'], 'ti': None},
                    'type': hlir_type_pointer(val['type']),
                    'att': ['local'],
                    'ti': None
                },

                'type': type.typeFreePtr,
            },

            {
                'isa': 'value',
                'kind': 'cast',

                'value': {
                    'isa': 'value',
                    'kind': 'var',
                    'id': {'isa': 'id', 'str': '_' + val['id'], 'ti': None},
                    'type': hlir_type_pointer(val['type']),
                    'att': ['local'],
                    'ti': None
                },

                'type': type.typeFreePtr,
            },

            {
                'isa': 'value',
                'kind': 'cast',
                'value': hlir_value_int(type.get_size(val['type'])),
                'type': type.typeInt64,
            }
        ]

        op = {
            'isa': 'value',
            'kind': 'call',
            'func': fmemcpy,
            'args': args,
            'type': memcpy_type['to'],
            'att': [],
            'ti': None
        }

        do_eval(op)




def print_stmt_block(s, arrays=None):
    locals_push()

    # arrays - arguments
    if arrays != None:
        print_arrays(arrays)

    for stmt in s['stmts']:
        print_stmt(stmt)
    locals_pop()


def print_func_signature(id, typ, arghack):
    params = typ['params']
    to = typ['to']

    print_type(to)
    out(" @%s(" % id)

    print_list_by(params, lambda field: print_type(field['type']))

    if arghack:
        out(", ...")

    out(")")



def print_decl_func(x):
    out("\ndeclare ")
    func = x['value']
    arghack = 'arghack' in func['att']
    print_func_signature(func['id']['str'], func['type'], arghack)


def print_def_func(x):
    global func_context

    # create new func context
    old_func_context = func_context
    func_context = {
        'if_no': 0,
        'while_no': 0,
        'cur_while_id': 0,

        'free_reg': 0,

        # map for local lets & vars
        # <id> => <llvm_value>
        'locals': [{}]
    }

    func = x['value']
    out("\ndefine ")
    print_type(func['type']['to'])
    out(" @%s" % func['id']['str'])
    out("(")

    # список параметров которые следует разместить на стеке
    # (массивы передаваемые по значению)
    reloc = []

    arrays = []    # параметры-массивы

    params = func['type']['params']
    params_len = len(params)
    i = 0
    while i < params_len:
        param = params[i]
        param_is_arr = type.is_array(param['type'])
        # array param gets _ prefix
        prefix = ""
        if param_is_arr:
            arrays.append(param)
            prefix = "_"

        id = param['id']['str']
        if i > 0:
            out(", ")
        print_type(param['type'])
        if param_is_arr:
            out("*")
        out(" ")
        out('%%%s%s' % (prefix, id))

        #reg = reg_get()
        vv = {
            'isa': 'llvm_value',
            'class': 'stk',
            'level': 'value',
            'id': id,
            'type': param['type'],
            'proto': param
        }

        if param_is_arr:
            vv['type'] = hlir_type_pointer(vv['type'])

        locals_add(id, vv)

        i = i + 1
    out(")")

    # 0, 1, 2 - params; 3 - entry label, 4 - first free register
    entry_label = reg_get()    # (!)

    out(" {")

    for r in reloc:
        print("    ; reloc %s " % (r['id']))
        lo("    ; reloc " + r['id'])
        ll_alloca(r['id'], r['type'], r)

    print_stmt_block(func['stmt'], arrays=arrays)

    if type.eq(func['type']['to'], type.typeUnit):
        lo("    ret void")
    lo("}\n")

    func_context = old_func_context




def print_decl_type(x):
    # LLVM не печатает, но C печатает (!)
    out("\n%%%s = type opaque" % x['type']['id']['str'])


def print_def_type(x):
    out("\n%%%s = type " % x['type']['name'])
    print_type(x['type'], print_aka=False)
    if type.is_record(x['type']):
        out("\n")



# из за того что с C типы записваются через жопу
# приходится печатать типы ptr, arr & func вместе с именем поля
def print_field(x):
    t = x['type']

    # поле является масссивом?
    array_size = None
    if type.is_array(t):
        array_size = t['volume']
        t = t['of']

    # поле является указателем?
    ptr_level = 0
    while type.is_pointer(t):
        t = t['to']

        if t == 'func':
            t = type.typeUnit
        else:
            ptr_level = ptr_level + 1
            # *[] or *[n] -> just *
            if type.is_array(t):
                t = t['of']

    print_type(t)
    out(" ")
    out("*" * ptr_level)
    out("%s" % (x['id']['str']))
    if is_array:
        out("[")
        if array_size != None:
            do_eval(array_size)
        out("]")



def print_def_var(x):
    mods = ['external', 'global', 'constant']
    mod = 'global'
    out("\n@")
    var = x['value']
    out(var['id']['str'])
    out(" = %s " % mod)
    print_type(var['type'])
    if var['init'] != None:
        out(" ")
        print_value(do_eval(var['init']))
    else:
        out(" zeroinitializer")



def print_string_utf8(strid, string):
    ss = string['str']

    slen = len(bytes(ss, 'utf-8')) + 1 # +1 (zero)

    ss = ss.replace("\a", "\\07")
    ss = ss.replace("\b", "\\08")
    ss = ss.replace("\t", "\\09")
    ss = ss.replace("\n", "\\0A")
    ss = ss.replace("\v", "\\0B")
    ss = ss.replace("\r", "\\0D")
    ss = ss.replace("\e", "\\1B")
    ss = ss.replace("\"", "\\22")
    ss = ss.replace("\'", "\\27")

    #ex: @str_1 = private constant [4 x i8] c"Hi!\00"
    lo("@%s = private constant [%d x i8] c\"%s\\00\"" % (strid, slen, ss))



def print_string_utf16(strid, string):
    ss = string['str']

    bb = (ss.encode('utf-16')).decode("utf16")
    #bb = ss.decode('utf-8').encode('utf-16be')
    #bb = bytes(ss, 'utf-16')
    slen = len(bb) + 1 # +1 (zero)

    print(bb)

    lo("@%s = private constant [%d x i16] [" % (strid, slen))
    for b in bb:
        out("i16 %d, " % ord(b))

    out("i16 0]")



def print_string_utf32(strid, string):
    ss = string['str']

    bb = ss#ss.encode('utf-16')
    #bb = bytes(ss, 'utf-32')
    slen = len(bb) + 1 # +1 (zero)

    print(bb)

    lo("@%s = private constant [%d x i32] [" % (strid, slen))
    for b in bb:
        out("i32 %d, " % ord(b))

    out("i32 0]")




def print_strings(strings):
    strno = 0
    for string in strings:

        strno = strno + 1
        strid = 'str_%d' % strno
        string['strid'] = strid

        #print(string)

        if string['used_char8']:
            print("PRINT_STR8")
            print_string_utf8(strid, string)

        if string['used_char16']:
            print("PRINT_STR16")
            strid = strid + '_utf16'
            string['strid_16'] = strid
            print_string_utf16(strid, string)

        if string['used_char32']:
            print("PRINT_STR32")
            strid = strid + '_utf32'
            string['strid_32'] = strid
            print_string_utf32(strid, string)



# список имен модулей распечатанных в текущей сброке
printed_modules = []

def print_module(m):

    if m['path'] in printed_modules:
        return

    printed_modules.append(m['path'])


    for imported_module in m['imports']:
        print_module(imported_module)


    out("; -- MODULE: %s\n" % m['path'])

    print_strings(m['strings'])

    isa_prev = None

    for x in m['text']:
        isa = x['isa']

        if isa_prev != isa:
            out("\n")
            isa_prev = isa

        if isa == 'directive':
            pass

        if isa == 'decl_func': print_decl_func(x)
        elif isa == 'decl_type': print_decl_type(x)
        elif isa == 'def_var': print_def_var(x)
        elif isa == 'def_const': pass
        elif isa == 'def_func': print_def_func(x)
        elif isa == 'def_type': print_def_type(x)

    out("\n\n")


def run(module, outname):
    outname = outname + '.ll'
    output_open(outname)

    out('\ntarget triple = "%s"\n\n' % LLVM_TARGET_TRIPLE)

    print_module(module)
    output_close()






def create_local_srtuct(typ, llvalues):
    #^llvalues.append({'id': item['id'], 'value': i})
    #or xv = ll_create_value_zero(typ) ?
    #%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
    xv = {
        'isa': 'llvm_value',
        'kind': 'record',
        'class': 'zero',
        'level': 'value',
        'type': typ,
        'proto': None
    }

    lo("\n; -- fill struct")
    # набиваем структуру
    i = 0
    while i < len(llvalues):
        llvalue = llvalues[i]
        # получаем позицию поля в структуре
        field_target = type.record_field_get(v['type'], llvalue['id']['str'])


        pos = field_target['no']
        # запаковываем значение в структуру
        xv = insertvalue(xv, llvalue['value'], pos)
        i = i + 1
    lo("; -- end fill struct")

    return xv


