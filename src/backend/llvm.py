
import copy
from .common import *
from error import info, warning, error
import type
from type import type_print
from value.value import value_attribute_check, value_print, value_is_immediate
from hlir import hlir_type_pointer, hlir_value_int
import settings


LLVM_TARGET_TRIPLE = ""
LLVM_TARGET_DATALAYOUT = ""


INDENT_SYMBOL = " " * 4


func_context = None

def is_global_context():
    return func_context == None


ll_value_num_zero = None

def init():
    global LLVM_TARGET_TRIPLE, LLVM_TARGET_DATALAYOUT, ll_value_num_zero
    LLVM_TARGET_TRIPLE = settings.get('target_triple')
    LLVM_TARGET_DATALAYOUT = settings.get('target_datalayout')

    ll_value_num_zero = ll_value_num(type.typeInt32, 0)
    pass


def indent():
    ind(INDENT_SYMBOL)



def lo(s):
    out('\n')
    indent()
    out(s)


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


def operation(op):
    reg = reg_get()
    lo("%%%s = %s " % (reg, op))
    return reg


def operation_with_type(op, t):
    reg = operation(op)
    print_type(t)
    return reg



def ll_value_zero(type):
    return {
        'isa': 'll_value',
        'kind': 'zero',
        'type': type,
        'is_adr': False,
        'proto': None
    }


def ll_value_num(type, num):
    return {
        'isa': 'll_value',
        'kind': 'num',
        'type': type,
        'imm': num,
        'is_adr': False,
        'proto': None
    }


def ll_value_reg(vreg, type, proto=None):
    return {
        'isa': 'll_value',
        'kind': 'reg',
        'type': type,
        'reg': vreg,
        'is_adr': False,
        'proto': proto
    }


def ll_value_mem(id, type, proto=None):
    return {
        'isa': 'll_value',
        'kind': 'mem',
        'type': type,
        'id': id,
        'is_adr': False,
        'proto': proto
    }


def ll_value_stk(id, type, proto=None):
    return {
        'isa': 'll_value',
        'kind': 'stk',
        'type': type,
        'id': id,
        'is_adr': False,
        'proto': proto,
    }


def ll_value_record(items, type, proto=None):
    return {
        'isa': 'll_value',
        'kind': 'record',
        'type': type,
        'items': items,
        'is_adr': False,
        'proto': proto
    }


def ll_value_array(items, type, proto=None):
    return {
        'isa': 'll_value',
        'kind': 'array',
        'type': type,
        'items': items,
        'is_adr': False,
        'proto': proto
    }


def ll_value_str(strid, _str, type, proto=None):
    return {
        'isa': 'll_value',
        'kind': 'str',
        'type': type,
        'id': strid,
        'len': len(_str),
        'str': _str,
        'is_adr': False,
        'proto': proto
    }



def print_type_value(llvm_value):
    print_type(llvm_value['type'])
    out(" ")
    ll_print_value(llvm_value)



def print_type_value_param(llvm_value):
    print_type(llvm_value['type'], arr_as_ptr_to_arr=True)
    out(" ")
    ll_print_value(llvm_value)



def insertvalue(v, x, pos):
    #%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
    reg = operation('insertvalue')
    print_type_value(v)
    out(", ")
    print_type_value(x)
    out(", ")
    out('%d' % pos)
    return ll_value_reg(reg, v['type'], v)



#%44 = va_arg i8** %3, i32
def llvm_va_arg(va_list, typ):
    reg = operation('va_arg')
    print_type_value(v)
    out(", ")
    print_type(typ)
    return ll_value_reg(reg, typ)


#"%16 = bitcast i8** %3 to i8*"
#"call void @llvm.va_start(i8* %16)"
def llvm_va_start(x):
    y = opcast('bitcast', x['type'], type.typeFreePtr, x)
    out("call void @llvm.va_start(i8* %d)" % y['reg'])


#"%96 = bitcast i8** %3 to i8*"
#"call void @llvm.va_end(i8* %96)"
def llvm_va_end(x):
    y = opcast('bitcast', x['type'], type.typeFreePtr, x)
    out("call void @llvm.va_end(i8* %d)" % y['reg'])



def llvm_inline_cast(op, from_type, to_type, val):
    out("%s (" % op)
    print_type(from_type)
    out(" ")
    ll_print_value(val)
    out(" to ")
    print_type(to_type)
    out(")")



def ll_print_value_array(x):
    if len(x['items']) == 0:
        out("zeroinitializer")
        return

    out("[\n")
    indent_up()
    n = len(x['items'])
    i = 0
    while i < n:
        item = x['items'][i]
        if i > 0: out(",\n")
        indent(); print_type_value(item);
        i = i + 1
    indent_down()
    out("\n"); indent(); out("]")



def ll_print_value_record(x):
    if len(x['items']) == 0:
        out("zeroinitializer")
        return

    out("{\n")
    indent_up()
    n = len(x['items'])
    i = 0
    while i < n:
        item = x['items'][i]
        if i > 0: out(",\n")
        indent(); print_type_value(item['value'])
        i = i + 1
    indent_down()
    out("\n"); indent(); out("}")



def ll_print_value_str(x):
    id = x['id']

    string_of = x['type']['to']['of']
    char_width = string_of['power']

    slen = x['len']

    out("bitcast ([%d x i%d]* @%s to [0 x i%d]*)" % (slen, char_width, id, char_width))



def ll_print_value_num(x):
    num = x['imm']
    if not type.is_pointer(x['type']):
        # integer, float, bool, char
        out(str(num))

    else:
        if x['imm'] == 0:
            out("null")
        else:
            v = ll_value_num(type.typeNat64, x['imm'])
            llvm_inline_cast('inttoptr', v['type'], x['type'], v)



def ll_print_value_inlinecast(x):
    #o("bitcast ([%d x i8]* @%s to %%Str)" % (x['len'], x['id']))
    v = x['value']
    from_type = v['type']
    to_type = x['type']
    llvm_inline_cast('bitcast', from_type, to_type, v)


def ll_print_value_zero(x):
    if type.is_numeric(x['type']): out("0")
    elif type.is_pointer(x['type']): out("null")
    else: out("zeroinitializer")



def ll_print_value(x):
    k = x['kind']
    if k == 'reg': out('%%%s' % x['reg'])
    elif k == 'stk': out('%%%s' % x['id'])
    elif k == 'mem': out('@%s' % x['id'])
    elif k == 'num': ll_print_value_num(x)
    elif k == 'str': ll_print_value_str(x)
    elif k == 'array': ll_print_value_array(x)
    elif k == 'record': ll_print_value_record(x)
    elif k == 'cast': ll_print_value_inlinecast(x)
    elif k == 'zero': ll_print_value_zero(x)
    else:
        out("<unknown_value::%s>" % c)
        info("???", x['ti'])



def print_list_by(lst, method):
    i = 0
    while i < len(lst):
        if i > 0: out(", ")
        method(lst[i])
        i = i + 1



def print_type_record(t):
    out("{")
    fields = t['fields']
    i = 0
    while i < len(fields):
        field = fields[i]
        if i > 0: out(',')
        out("\n\t"); print_type(field['type'])
        i = i + 1
    out("\n}")


def print_type_array(t, arr_as_ptr_to_arr):
    out("[")
    array_size = t['volume']
    sz = 0
    if array_size != None:
        sz = array_size['imm']

    out("%d x " % sz)
    print_type(t['of'])
    out("]")
    if arr_as_ptr_to_arr:
        out("*")


def print_type_func(t):
    print_type(t['to'])
    out("(")
    print_list_by(t['params'], lambda f: print_type(f['type'], arr_as_ptr_to_arr=True))
    out(")")


def print_type_pointer(t):
    if type.is_free_pointer(t) or type.is_nil(t):
        out("i8*")
    else:
        print_type(t['to']); out("*")


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

        if 'id' in t:
            out('%' + t['id']['str'])
            return

    #elif type.is_enum(t): out("i16")
    if type.is_func(t): print_type_func(t)
    elif type.is_record(t): print_type_record(t)
    elif type.is_pointer(t): print_type_pointer(t)
    elif type.is_array(t): print_type_array(t, arr_as_ptr_to_arr)

    elif type.is_integer(t) or type.is_float(t) or type.is_char(t):
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
    assert(x['isa'] == 'll_value')

    if not x['is_adr']:
        return x

    # It's address of the value, we need to load it
    reg = operation('load');
    typ = x['type']
    print_type(typ)
    out(", ")
    print_type(typ)
    out("* ")
    ll_print_value(x)

    return ll_value_reg(reg, x['type'], x)



REL_OPS = ['eq', 'ne', 'lt', 'gt', 'le', 'ge']


def get_bin_opcode(op, t):
    opcode = "<unknown opcode '%s'>" % op
    if op in ['eq', 'ne']:
        opcode = select_bin_opcode_f('icmp ' + op, 'fcmp o' + op, t)
    elif op in ['add', 'sub', 'mul']:
        opcode = select_bin_opcode_f(op, 'f' + op, t)
    elif op in ['and', 'or', 'xor', 'shl']:
        opcode = op
    elif op in ['div', 'rem']:
        opcode = select_bin_opcode_suf('s' + op, 'u' + op, 'f' + op, t)
    elif op in ['lt', 'gt', 'le', 'ge']:
        opcode = select_bin_opcode_suf('icmp s' + op, 'icmp u' + op, 'fcmp o' + op, t)
    elif op == 'shr':
        opcode = 'lshr'
        if type.is_signed(t):
            opcode = 'ashr'
    elif op == 'logic_or':
        opcode = 'or'
    elif op == 'logic_and':
        opcode = 'and'

    return opcode


def select_bin_opcode_f(op, fop, t): # ["sdiv", "udiv", "fdiv", x]
    if type.is_float(t):
        return fop
    return op


def select_bin_opcode_su(sop, uop, t): # ["icmp slt", "icmp ult", x]
    if type.is_unsigned(t):
        return uop
    return sop


def select_bin_opcode_suf(sop, uop, fop, t): # ["sdiv", "udiv", "fdiv", x]
    if type.is_float(t):
        return fop
    return select_bin_opcode_su(sop, uop, t)




def ll_eval_binary(op, l, r, x):
    reg = operation_with_type (op, l['type'])
    out(" "); ll_print_value(l); out(", "); ll_print_value(r)
    return ll_value_reg(reg, x['type'], x)



def do_eval_expr_bin(x):
    if 'imm' in x:
        return ll_value_num(x['type'], x['imm'])

    opcode = get_bin_opcode(x['kind'], x['left']['type'])
    l = do_ld(do_eval(x['left']))
    r = do_ld(do_eval(x['right']))
    return ll_eval_binary(opcode, l, r, x)



def deref(x):
    vx = do_ld(do_eval(x['value']))
    return llvm_deref(vx)


def llvm_deref(x):
    nv = copy.copy(x)
    nv['is_adr'] = True
    return nv


def do_eval_expr_un(v):
    ve = do_eval(v['value'])

    if v['kind'] == 'ref':
        if is_global_context():
            if v['value']['kind'] == 'var':
                if 'global' in  v['value']['att']:
                    id = v['value']['id']['str']
                    return ll_value_mem(id, v['type'], v)

        nv = copy.copy(ve)
        nv['is_adr'] = False
        nv['proto'] = v    # for type
        return nv


    vx = do_ld(ve)    #!

    if v['kind'] == 'deref':
        return deref(v)

    reg = None
    if v['kind'] == 'not':
        #%10 = xor i32 %9, -1
        reg = operation('xor');
        out(" ");
        print_type(v['type'])
        out(" ");
        ll_print_value(vx)
        out(", -1")

    elif v['kind'] == 'minus':
        #%10 = sub i32 0, %9
        z = ll_value_num(v['type'], 0)
        return ll_eval_binary('sub', z, vx, v)

    else:
        reg = operation(v['kind']); out(" "); ll_print_value(vx)

    return ll_value_reg(reg, v['type'], v)



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
        lo("call ")
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

    ll_print_value(f)
    out(" (")
    print_list_by(args, print_type_value_param)
    out(")")
    return ll_value_reg(reg, v['type'], v)



# индекс не может быть i64 (!) (а только i32)
# t - тип самой записи или массива (без указателя)
def llvm_getelementptr(rec, rt, indexes, vt):
    # Прикол в том что индекс (i) структуры
    # не может быть i64 (!) (а только i32)
    reg = operation_with_type("getelementptr inbounds", rt)
    out(", ")
    print_type(rt)
    out("* ")
    ll_print_value(rec)
    out(", ")
    print_list_by(indexes, print_type_value)
    rv = ll_value_reg(reg, vt)
    rv['is_adr'] = True
    return rv


def do_eval_expr_index(v):
    array = do_eval(v['array'])
    array_type = array['type']
    result_type = v['type']
    index = do_ld(do_eval(v['index']))
    return llvm_getelementptr(array, array_type, (ll_value_num_zero, index), result_type)


def do_eval_expr_index_ptr(v):
    pointer = do_eval(v['pointer'])
    array_type = pointer['type']['to']
    result_type = v['type']
    array = do_ld(pointer)
    index = do_ld(do_eval(v['index']))
    return llvm_getelementptr(array, array_type, (ll_value_num_zero, index), result_type)


# получает укзаатель на структуру x
# его тип
# носер поля (просто число)
# возвращает value:address для поля этой структуры
def do_eval_access_ptr(x, xt, field_no, vt):
    field_index = ll_value_num(type.typeInt32, field_no)
    return llvm_getelementptr(x, xt, (ll_value_num_zero, field_index), vt)


# возвращает значение поля из 'структуры по значению'
def extract_record_field(x, ft, field_no):
    reg = operation('extractvalue')
    print_type_value(x)
    out(', %d' % field_no)
    return ll_value_reg(reg, ft)



def do_eval_access(rec, rt, pos, vt):
    # если это структура высичленная на ходу, у нее есть поле 'items'
    # там лежат записи вида {'id': ..., 'value': ...}
    # поле value ссылается при этом на уже вычисленное значение поля
    # ex: let p = {x=0, y=0};    p.x    // <--
    if 'items' in rec:
        return rec['items'][pos]['value']


    # если сама запись находится в регистре: (let rec = get_rec())
    if type.is_record(rec['type']) and not rec['is_adr']:
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
    pos = v['field']['pos']
    return do_eval_access(rec, rt, pos, v['type'])



def do_eval_expr_access_ptr(v):
    ptr = do_ld(do_eval(v['pointer']))
    rt = ptr['type']['to']
    pos = v['field']['pos']
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
    if type.is_integer(a) or type.is_char(a) or type.is_bool(a):
        if type.is_integer(b) or type.is_char(b) or type.is_bool(b):
            signed = False
            if type.is_integer(b):
                signed = type.is_signed(b)

            if a['power'] < b['power']:
                if signed:
                    return 'sext'
                else:
                    return 'zext'

            elif a['power'] > b['power']:
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
        if type.is_pointer(b): return 'bitcast'
        elif type.is_integer(b): return 'ptrtoint'

    elif type.is_float(a):
        # Float -> Integer
        if type.is_integer(b):
            if type.is_signed(b):
                return 'fptosi'
            else:
                return 'fptoui'

        # Float -> Float
        elif type.is_float(b):
            if a['power'] < b['power']: return 'fpext'
            elif a['power'] > b['power']: return 'fptrunc'
            else: return 'bitcast'

    return 'uncast<%s -> %s>' % (a['kind'], b['kind'])




def do_eval_expr_cast_immediate(x):
    value = x['value']
    from_type = value['type']
    to_type = x['type']

    # строки печатаются ТОЛЬКО отсюда!
    if type.is_ptr_to_string(to_type):
        string_of = to_type['to']['of']
        char_pow = string_of['power']
        return ll_value_str(x['strid'], x['imm'], x['type'], value)

    return do_eval_literal(x)



# перепаковываем структуру в такую же структуру
# (просто с другим именем, изза чего LLVM ее считает "другой")
def cast_record_to_record(to_type, value, ti):
    #info("cast_record_to_record", ti)
    from_type = value['type']
    # создаем переменную под структуру A
    y = do_ld(do_eval(value))
    reg = reg_get()
    struct = ll_alloca(reg, value['type'], y)
    # приводим указатель на нее к указателю на структуру B
    new_struct_ptr = opcast("bitcast", hlir_type_pointer(from_type), hlir_type_pointer(to_type), struct)
    # загружаем структуру B и возвращаем ее
    new_struct = llvm_deref(new_struct_ptr)
    return new_struct



def opcast(opcode, from_type, to_type, value):
    reg = operation(opcode)
    print_type(from_type)
    out(" ")
    ll_print_value(value)
    out(" to ")
    print_type(to_type)
    return ll_value_reg(reg, to_type, value)



def do_eval_expr_cast(x):
    value = x['value']
    from_type = value['type']
    to_type = x['type']

    if type.is_generic_string(from_type):
        if type.is_ptr_to_string(to_type):
            error("strings need to print through do_eval_expr_cast_immediate", x)
            exit(1)

    # cast any type to Unit type
    if type.is_unit(to_type):
        return ll_value_zero(to_type)

    # (STUB?) nil -> zeroinitializer
    if type.is_free_pointer(from_type):
        if value_is_immediate(value):
            return ll_value_num(to_type, value['imm'])

    # Cm имеет структурную систему типов, тогда как llvm - номинативную
    # приведение структуры к структуре по значению не поддерживается LLVM
    # поэтому делаем его отдельно
    if type.is_record(from_type):
        if type.is_record(to_type):
            return cast_record_to_record(to_type, value, x['ti'])


    v = do_ld(do_eval(value))

    if is_global_context():
        return v

    opcode = select_cast_operator(from_type, to_type)

    return opcast(opcode, from_type, to_type, v)



bin_ops = [
    'logic_or', 'logic_and',
    'or', 'xor', 'and', 'shl', 'shr',
    'eq', 'ne', 'lt', 'gt', 'le', 'ge',
    'add', 'sub', 'mul', 'div', 'rem',
]

un_ops = ['ref', 'deref', 'plus', 'minus', 'not']



def do_eval_array(v):
    # сперва вычисляем все элементы массива в регистры
    # (кроме констант, они едут до последнего)
    items = []
    for item in v['imm']:
        iv = do_ld(do_eval(item))
        items.append(iv)

    # теперь добавим паддинг нулевыми значениями
    fulllen = v['type']['volume']['imm']

    n_pad = fulllen - len(items)
    i = 0
    while i < n_pad:
        z = ll_value_zero(v['type']['of'])
        items.append(z)
        i = i + 1

    # global?
    # глобальный массив распечатает print_value как литерал
    if is_global_context():
        return ll_value_array(items, v['type'], v)

    # local.

    # если мы локальны то создадим иммутабельную структуру
    # с массивом (insertvalue)
    #%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
    xv = ll_value_array([], v['type'])

    # набиваем массив
    i = 0
    while i < len(items):
        xv = insertvalue(xv, items[i], i)
        i = i + 1

    return xv



# вычисляем значение-запись по месту
# просто высичлим все его элементы и завернем все в 'll_value'/'record'
def do_eval_record(v):
    # сперва вычисляем все иницифлизаторы поелей структуры в регистры
    # (кроме констант, ведь они едут до последнего)

    items = []
    initializers = v['imm']
    for initializer in initializers:
        iv = do_ld(do_eval(initializer['value']))
        items.append({'id': initializer['id'], 'value': iv})

    return ll_value_record(items, v['type'], v)




def do_eval(x):
    assert(x != None)
    assert(x['isa'] == 'value')

    # WRONG WAY! remove this shit!
    # Way for IMMEDIATE values
    if value_is_immediate(x):
        xtype = x['type']

        if type.is_integer(xtype): return ll_value_num(xtype, x['imm'])
        elif type.is_char(xtype): return ll_value_num(xtype, x['imm'])
        elif type.is_record(xtype): return do_eval_record(x)
        elif type.is_array(xtype): return do_eval_array(x)
        elif type.is_float(xtype): return ll_value_num(xtype, x['imm'])
        elif type.is_bool(xtype): return ll_value_num(xtype, x['imm'])

    # runtime evaluation
    v = do_eval_x(x)

    if v == None:
        print("do_eval_x(x) == None")
        print(x)
        exit(-1)

    assert(v != None)

    v['type'] = x['type']

    return v


def do_eval_literal(x):
    xt = x['type']
    if type.is_integer(xt): return ll_value_num(xt, x['imm'])
    elif type.is_float(xt): return ll_value_num(xt, x['imm'])
    elif type.is_record(xt): return do_eval_record(x)
    elif type.is_array(xt): return do_eval_array(x)
    elif type.is_bool(xt): return ll_value_num(xt, x['imm'])
    elif type.is_free_pointer(xt): return ll_value_num(xt, x['imm'])
    elif type.is_pointer(xt): return ll_value_num(xt, x['imm'])
    elif type.is_char(xt): return ll_value_num(xt, x['imm'])
    elif type.is_bool(xt): return ll_value_num(xt, x['imm'])
    else:
        value_print(x)
        error("do_eval_literal: unknown literal", x['ti'])
        exit(1)


def func_const_var(x):
    k = x['kind']

    if k == 'const':
        if 'imm' in x:
            if type.is_numeric(x['type']):
                return ll_value_num(x['type'], x['imm'])

    if value_attribute_check(x, 'local'):
        localname = x['id']['str']
        y = locals_get(localname)
        return y

    if k == 'var':
        rv = ll_value_mem(x['id']['str'], x['type'], x)
        rv['is_adr'] = True
        return rv

    if k == 'const':
        return do_eval(x['value'])

    return ll_value_mem(x['id']['str'], ['type'], x)



def do_eval_x(x):
    if x == None:
        return None

    k = x['kind']

    if k == 'literal': y = do_eval_literal(x)
    elif k in bin_ops: y = do_eval_expr_bin(x)
    elif k in un_ops: y = do_eval_expr_un(x)
    elif k == 'const': y = func_const_var(x)
    elif k in ['func', 'var']: y = func_const_var(x)
    elif k == 'call': y = do_eval_expr_call(x)
    elif k == 'index': y = do_eval_expr_index(x)
    elif k == 'index_ptr': y = do_eval_expr_index_ptr(x)
    elif k == 'access': y = do_eval_expr_access(x)
    elif k == 'access_ptr': y = do_eval_expr_access_ptr(x)
    elif k == 'cast_immediate': y = do_eval_expr_cast_immediate(x)
    elif k == 'cast': y = do_eval_expr_cast(x)
    else:
        out("<%s>" % k)
        y = None

    if y == None:
        print("do_eval_x cannot eval value")
        value_print(x)
        return ll_value_zero(x['type'])

    return y


#
#
#

# сохр простых значений
def ll_store(l, r):
    lo("store ");
    print_type(r['type'])
    out(" ")
    ll_print_value(r)
    out(", ")
    print_type(r['type'])
    out("* ")
    ll_print_value(l)


# сохр структур (вот не может просто так сохранить, приходится по полю)
def ll_store_record(l, r):

    # if r is immediate value
    if 'items' in r:
        if len(r['items']) == 0:
            # если сохраняем пустую структуру
            # то просто сохраним в нее zeroinitializer
            ll_store(l, r)
            return

    lo("; -- record assign field by field")
    for field in l['type']['fields']:
        ft = field['type']

        # получаем указатель на поле левого (в которое будем сохранять)
        l_field_ptr = do_eval_access_ptr(l, l['type'], field['pos'], ft)

        rpos = field['pos']

        rv = do_ld(do_eval_access(r, r['type'], rpos, ft))

        # сохраняем
        ll_assign(l_field_ptr, rv)
    lo("; -- end record assign field by field\n")



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
    lo("br %s " % TYPE_BOOL)
    ll_print_value(x)
    out(" , label %%%s, label %%%s" % (then_label, else_label))


def op_goto(label):
    lo("br label %%%s" % label)


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

    lo("ret ")

    if v != None:
        print_type(x['value']['type'])
        out(" ")
        ll_print_value(v)
    else:
        out("void")

    reg_get()    # for LLVM



def ll_alloca(id, typ, init_value):
    val = ll_value_stk(id, typ)
    val['is_adr'] = True

    lo("%%%s = alloca " % id)
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
    v = do_ld(do_eval(val))
    locals_add(x['id']['str'], v)
    return None



def print_comment_block(x):
    #out("\n");
    #out("/*%s*/" % x['text'])
    pass


def print_comment_line(x):
    out("\n")
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
    elif k == 'comment-line': print_comment_line(x)
    elif k == 'comment-block': print_comment_block(x)
    else: lo("<stmt %s>" % str(x))



"""def print_arrays(arrays):
    for array in arrays:

        id = array['id']['str']
        iv = ll_value_zero(array['type'])
        val = ll_alloca(id, array['type'], None)
        locals_add('_' + id, val)

        #from trans import value_create_int

        memcpy_type = {
            'isa': 'type',
            'kind': 'func',
            'size': 0,
            'align': 0,
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
                'value': hlir_value_int(type.type_get_size(val['type'])),
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
"""



def print_stmt_block(s, arrays=None):
    locals_push()

    # arrays - arguments
    #if arrays != None:
    #    print_arrays(arrays)

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

    indent_up()

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

        param_id = param['id']['str']
        if i > 0:
            out(", ")
        print_type(param['type'])
        if param_is_arr:
            out("*")
        out(" ")
        out('%%%s%s' % (prefix, param_id))

        vv = ll_value_stk(param_id, param['type'], param)

        if param_is_arr:
            vv['type'] = hlir_type_pointer(vv['type'])

        locals_add(param_id, vv)

        i = i + 1
    out(")")

    # 0, 1, 2 - params; 3 - entry label, 4 - first free register
    entry_label = reg_get()    # (!)

    out(" {")

    for r in reloc:
        #print("    ; reloc %s " % (r['id']))
        lo("; reloc " + r['id'])
        ll_alloca(r['id'], r['type'], r)

    print_stmt_block(func['stmt'], arrays=arrays)

    if type.eq(func['type']['to'], type.typeUnit):
        lo("ret void")

    indent_down()

    lo("}\n")

    func_context = old_func_context





def print_decl_type(x):
    # LLVM не печатает, но C печатает (!)
    out("\n%%%s = type opaque" % x['type']['id']['str'])


def print_def_type(x):
    out("\n%%%s = type " % x['type']['id']['str'])
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
    #mods = ['external', 'global', 'constant']
    mod = 'global'
    out("\n@")
    var = x['value']
    out(var['id']['str'])
    out(" = %s " % mod)
    print_type(var['type'])
    if var['init'] != None:
        out(" ")
        ll_print_value(do_eval(var['init']))
    else:
        out(" zeroinitializer")



def print_def_const(x):
    pass # TODO



def print_string_ascii(strid, string):
    ss = "" #string['imm']['str']

    for c in string['imm']:
        ss = ss + chr(c['imm'])

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



def print_string_as_array(strid, string, char_width):
    slen = len(string['imm'])
    lo("@%s = private constant [%d x i%d] [" % (strid, slen, char_width))
    i = 0
    for c in string['imm']:
        if i > 0:
            out(", ")
        out("i%d %d" % (char_width, c))
        i = i + 1

    out("]")



def print_strings(strings):
    strno = 0
    for string in strings:

        strid = None
        if 'id' in string:
            # it is named constant
            strid = string['id']['str']
        else:
            # it is anonymous string
            strno = strno + 1
            strid = 'str%d' % strno

        char_power = string['type']['to']['of']['power']

        string['strid'] = strid

        print_string_as_array(strid, string, char_power)



# список имен модулей распечатанных в текущей сброке
printed_modules = []

def print_module(m):

    if m['source_info']['path'] in printed_modules:
        return

    printed_modules.append(m['source_info']['path'])


    for imported_module in m['imports']:
        print_module(imported_module)


    out("; -- SOURCE: %s\n" % m['source_info']['name'])

    print_strings(m['strings'])

    isa_prev = None

    for x in m['text']:
        isa = x['isa']

        if isa_prev != isa:
            out("\n")
            isa_prev = isa

        if isa == 'decl_func': print_decl_func(x)
        elif isa == 'decl_type': print_decl_type(x)
        elif isa == 'def_var': print_def_var(x)
        elif isa == 'def_const': print_def_const(x)
        elif isa == 'def_func': print_def_func(x)
        elif isa == 'def_type': print_def_type(x)
        elif isa == 'directive': pass
        elif isa == 'comment': pass

    out("\n\n")


def run(module, outname):
    outname = outname + '.ll'
    output_open(outname)

    out('\ntarget datalayout = "%s"' % LLVM_TARGET_DATALAYOUT)
    out('\ntarget triple = "%s"\n\n' % LLVM_TARGET_TRIPLE)

    print_module(module)
    output_close()



"""
def create_local_srtuct(typ, llvalues):
    #%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
    xv = ll_value_record([], typ, proto=None)

    lo("\n; -- fill struct")
    # набиваем структуру
    i = 0
    while i < len(llvalues):
        llvalue = llvalues[i]
        # получаем позицию поля в структуре
        field_target = type.record_field_get(v['type'], llvalue['id']['str'])


        pos = field_target['pos']
        # запаковываем значение в структуру
        xv = insertvalue(xv, llvalue['value'], pos)
        i = i + 1
    lo("; -- end fill struct")

    return xv

"""
