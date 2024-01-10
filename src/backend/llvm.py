
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

NL_INDENT = "\n%s" % INDENT_SYMBOL

cfunc = None

func_context = None

def is_global_context():
    return func_context == None


va_list = None

llvm_value_num_zero = None

def init():
    global LLVM_TARGET_TRIPLE, LLVM_TARGET_DATALAYOUT, llvm_value_num_zero
    LLVM_TARGET_TRIPLE = settings.get('target_triple')
    LLVM_TARGET_DATALAYOUT = settings.get('target_datalayout')

    llvm_value_num_zero = llvm_value_num(type.typeInt32, 0)
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


def llvm_operation(op, reg=None):
    if reg == None:
        reg = reg_get()
    lo("%%%s = %s " % (reg, op))
    return reg


def llvm_operation_with_type(op, t):
    reg = llvm_operation(op)
    print_type(t)
    return reg



def llvm_value_zero(type):
    return {
        'isa': 'll_value',
        'kind': 'zero',
        'type': type,
        'is_adr': False,
        'proto': None
    }


def llvm_value_num(type, num):
    return {
        'isa': 'll_value',
        'kind': 'num',
        'type': type,
        'imm': num,
        'is_adr': False,
        'proto': None
    }


def llvm_value_reg(vreg, type, proto=None):
    return {
        'isa': 'll_value',
        'kind': 'reg',
        'type': type,
        'reg': vreg,
        'is_adr': False,
        'proto': proto
    }


def llvm_value_mem(id, type, proto=None):
    return {
        'isa': 'll_value',
        'kind': 'mem',
        'type': type,
        'id': id,
        'is_adr': False,
        'proto': proto
    }


def llvm_value_stk(id, type, proto=None):
    return {
        'isa': 'll_value',
        'kind': 'stk',
        'type': type,
        'id': id,
        'is_adr': False,
        'proto': proto,
    }


def llvm_value_record(items, type, proto=None):
    return {
        'isa': 'll_value',
        'kind': 'record',
        'type': type,
        'items': items,
        'is_adr': False,
        'proto': proto
    }


def llvm_value_array(items, type, proto=None):
    return {
        'isa': 'll_value',
        'kind': 'array',
        'type': type,
        'items': items,
        'is_adr': False,
        'proto': proto
    }


def llvm_value_str(strid, _str, type, proto=None):
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



def llvm_print_type_value(x):
    assert(x['isa'] == 'll_value')

    print_type(x['type'])
    if x['is_adr']:
        out("* ")
    else:
        out(" ")
    llvm_print_value(x)



def insertvalue(x, v, pos):
    assert(x['isa'] == 'll_value')
    assert(v['isa'] == 'll_value')
    #%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
    reg = llvm_operation('insertvalue')
    llvm_print_type_value(x)
    out(", ")
    llvm_print_type_value(v)
    out(", %d" % pos)
    return llvm_value_reg(reg, x['type'], x)



#%44 = va_arg i8** %3, i32
def llvm_va_arg(va_list, typ):
    reg = llvm_operation('va_arg')
    llvm_print_type_value(va_list)
    out(", ")
    print_type(typ)
    return llvm_value_reg(reg, typ)


#"%16 = bitcast i8** %3 to i8*"
#"call void @llvm.va_start(i8* %16)"
def llvm_va_start(x):
    y = llvm_cast('bitcast', hlir_type_pointer(x['type']), type.typeFreePtr, x)
    lo("call void @llvm.va_start(i8* %%%s)" % y['reg'])


#"%96 = bitcast i8** %3 to i8*"
#"call void @llvm.va_end(i8* %96)"
def llvm_va_end(x):
    y = llvm_cast('bitcast', hlir_type_pointer(x['type']), type.typeFreePtr, x)
    lo("call void @llvm.va_end(i8* %%%s)" % y['reg'])



def llvm_inline_cast(op, to_type, val):
    assert(to_type['isa'] == 'type')
    assert(val['isa'] == 'll_value')
    out("%s (" % op)
    llvm_print_type_value(val)
    out(" to ")
    print_type(to_type)
    out(")")



def llvm_print_value_array(x):
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
        indent(); llvm_print_type_value(item);
        i = i + 1
    indent_down()
    out("\n"); indent(); out("]")



def llvm_print_value_record(x):
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
        indent(); llvm_print_type_value(item['value'])
        i = i + 1
    indent_down()
    out("\n"); indent(); out("}")



def llvm_print_value_str(x):
    string_of = x['type']['to']['of']
    char_width = string_of['power']
    str_len = x['len']
    out("bitcast ([%d x i%d]* @%s to [0 x i%d]*)" % (str_len, char_width, x['id'], char_width))



def llvm_print_value_num(x):
    num = x['imm']
    if not type.is_pointer(x['type']):
        # integer, float, bool, char
        out(str(num))

    else:
        if x['imm'] == 0:
            out("null")
        else:
            v = llvm_value_num(type.typeNat64, x['imm'])
            llvm_inline_cast('inttoptr', x['type'], v)



def llvm_print_value_inlinecast(x):
    llvm_inline_cast('bitcast', x['type'], x['value'])


def llvm_print_value_zero(x):
    if type.is_record(x['type']): out("zeroinitializer")
    elif type.is_array(x['type']): out("zeroinitializer")
    elif type.is_pointer(x['type']): out("null")
    else: out("0")



def llvm_print_value(x):
    assert(x['isa'] == 'll_value')
    k = x['kind']
    if k == 'reg': out('%%%s' % x['reg'])
    elif k == 'stk': out('%%%s' % x['id'])
    elif k == 'mem': out('@%s' % x['id'])
    elif k == 'num': llvm_print_value_num(x)
    elif k == 'str': llvm_print_value_str(x)
    elif k == 'array': llvm_print_value_array(x)
    elif k == 'record': llvm_print_value_record(x)
    elif k == 'cast': llvm_print_value_inlinecast(x)
    elif k == 'zero': llvm_print_value_zero(x)
    else:
        out("<unknown_value::%s>" % c)
        info("<llvm::unknown_value::%s>" % c, x['ti'])

    return




def llvm_eval_binary(op, l, r, x):
    assert(l['isa'] == 'll_value')
    assert(r['isa'] == 'll_value')
    reg = llvm_operation_with_type(op, l['type'])
    out(" "); llvm_print_value(l); out(", "); llvm_print_value(r)
    return llvm_value_reg(reg, x['type'], x)



def llvm_deref(x):
    assert(x['isa'] == 'll_value')
    nv = copy.copy(x)
    nv['is_adr'] = True
    return nv



# индекс не может быть i64 (!) (а только i32)
# t - тип самой записи или массива (без указателя)
def llvm_getelementptr(rec, rt, indexes, vt):
    # Прикол в том что индекс (i) структуры
    # не может быть i64 (!) (а только i32)
    reg = llvm_operation_with_type("getelementptr inbounds", rt)
    out(", ")
    llvm_print_type_value(rec)
    out(", ")
    print_list_with(indexes, llvm_print_type_value)
    rv = llvm_value_reg(reg, vt)
    rv['is_adr'] = True
    return rv


# возвращает значение поля из 'структуры по значению'
def llvm_extract_item(x, ft, field_no):
    reg = llvm_operation('extractvalue')
    llvm_print_type_value(x)
    out(', %d' % field_no)
    return llvm_value_reg(reg, ft)


def llvm_cast(kind, from_type, to_type, value):
    reg = llvm_operation(kind)
    llvm_print_type_value(value)
    out(" to ")
    print_type(to_type)
    return llvm_value_reg(reg, to_type, value)


def llvm_load(x):
    assert(x['isa'] == 'll_value')
    reg = llvm_operation('load')
    print_type(x['type'])
    out(", ")
    llvm_print_type_value(x)
    return llvm_value_reg(reg, x['type'], x)


# сохр простых значений
def llvm_store(l, r):
    assert(l['isa'] == 'll_value')
    assert(r['isa'] == 'll_value')
    lo("store ")
    llvm_print_type_value(r)
    out(", ")
    llvm_print_type_value(l)



# получает два указателя, и размер
def llvm_memcpy(dst, src, size, volatile=False):
    #"@llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)")
    dst2 = llvm_cast('bitcast', dst['type'], type.typeFreePtr, dst)
    src2 = llvm_cast('bitcast', src['type'], type.typeFreePtr, src)
    out(NL_INDENT)
    out("call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(")
    llvm_print_type_value(dst2)
    out(", ")
    llvm_print_type_value(src2)
    out(", ")
    llvm_print_type_value(size)
    out(", i1 %d)" % volatile)



def llvm_br(x, then_label, else_label):
    lo("br %s " % TYPE_BOOL)
    llvm_print_value(x)
    out(" , label %%%s, label %%%s" % (then_label, else_label))


def llvm_jump(label):
    lo("br label %%%s" % label)


def llvm_label(label):
    out("\n%s:" % label)


def llvm_alloca(typ, id_str=None, init_ll_value=None):
    assert(typ['isa'] == 'type')
    reg = llvm_operation("alloca", reg=id_str); print_type(typ)
    val = llvm_value_stk(reg, typ)
    val['is_adr'] = True

    if init_ll_value != None:
        assert(init_ll_value['isa'] == 'll_value')
        llvm_store(val, init_ll_value)

    return val




# получает на вход llvm_value
# и если оно adr то загружает его в регистр
# в любом другом случае просто возвращает исходное значение
def llvm_dold(x):
    assert(x['isa'] == 'll_value')

    if x['is_adr']:
        # It's address of the value, we need to load it
        return llvm_load(x)

    # It is "value by value"
    return x





def print_list_with(lst, method):
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


def print_type_array(t):
    out("[")
    array_size = t['volume']
    sz = 0
    if array_size != None:
        sz = array_size['imm']
    out("%d x " % sz)
    print_type(t['of'])
    out("]")


def print_type_func(t):
    arghack = 'arghack' in t['att']
    print_type(t['to'])
    out("(")
    print_list_with(t['params'], lambda f: print_type(f['type']))
    if arghack:
        out(", ...")
    out(")")


def print_type_pointer(t):
    if type.is_free_pointer(t) or type.is_nil(t):
        out("i8*")
    else:
        print_type(t['to']); out("*")


# функция может получать только указатель на массив
# если же в CM она получает массив то тут и в СИ она получает
# указатель на него, и потом копирует его во внутренний массив
def print_type(t, print_aka=True):
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
            out('%%%s' % t['id']['str'])
            return

    if type.is_func(t): print_type_func(t)
    elif type.is_record(t): print_type_record(t)
    elif type.is_pointer(t): print_type_pointer(t)
    elif type.is_array(t): print_type_array(t)

    elif type.is_integer(t) or type.is_float(t) or type.is_char(t):
        if 'llvm_alias' in t:
            out(t['llvm_alias'])

    elif type.is_opaque(t):
        out('opaque')

    elif type.is_va_list(t):
        out("i8*")

    else:
        out("<type:%s>" % k)



def do_reval(x):
    return llvm_dold(do_eval(x))


def do_eval_expr_bin(x):
    if 'imm' in x:
        return llvm_value_num(x['type'], x['imm'])

    op = get_bin_opcode(x['kind'], x['left']['type'])
    l = do_reval(x['left'])
    r = do_reval(x['right'])
    return llvm_eval_binary(op, l, r, x)



def do_eval_expr_deref(x):
    return llvm_deref(do_reval(x['value']))



def do_eval_expr_un(v):
    ve = do_eval(v['value'])

    if v['kind'] == 'ref':
        if is_global_context():
            if v['value']['kind'] == 'var':
                if 'global' in  v['value']['att']:
                    id = v['value']['id']['str']
                    return llvm_value_mem(id, v['type'], v)

        nv = copy.copy(ve)
        nv['is_adr'] = False
        nv['proto'] = v    # for type
        return nv


    vx = llvm_dold(ve) #!

    if v['kind'] == 'deref':
        return do_eval_expr_deref(v)

    reg = None
    if v['kind'] == 'not':
        #%10 = xor i32 %9, -1
        reg = llvm_operation('xor');
        llvm_print_type_value(vx)
        out(", -1")

    elif v['kind'] == 'minus':
        #%10 = sub i32 0, %9
        z = llvm_value_num(v['type'], 0)
        return llvm_eval_binary('sub', z, vx, v)

    else:
        reg = llvm_operation(v['kind']); out(" "); llvm_print_value(vx)

    return llvm_value_reg(reg, v['type'], v)



def do_eval_expr_call(v, retval=None):
    # eval all args
    args = []
    for a in v['args']:
        arg = do_reval(a)
        args.append(arg)

    func = v['func']
    ftype = func['type']
    sret = 'sret' in func['att']

    # если просто вызвали и не забирают retval
    # сгенерим фейковый retval
    if sret:
        if retval == None:
            retval = llvm_alloca(ftype['to'])

    # eval func
    f = do_eval(func)

    if type.is_pointer(ftype):
        # pointer to array needs additional load
        f = llvm_dold(f)
        ftype = ftype['to']

    to_unit = type.eq(ftype['to'], type.typeUnit)


    # do call
    reg = "0"
    if to_unit or sret:
        lo("call ")
    else:
        reg = llvm_operation("call")

    print_type_func(ftype)
    llvm_print_value(f)

    out("(")
    if sret:
        llvm_print_type_value(retval)
        if len(args) > 0:
            out(", ")

    print_list_with(args, llvm_print_type_value)
    out(")")

    return llvm_value_reg(reg, v['type'], v)



def do_eval_expr_index(v):
    array = do_eval(v['array'])
    array_type = array['type']
    result_type = v['type']
    index = do_reval(v['index'])

    # если сам массив находится в регистре: (let rec = get_rec())
    if not array['is_adr']:
        if not value_is_immediate(index):
            error("expected immediate index value", v['ti'])
            return llvm_value_zero(v['ti'])

        return llvm_extract_item(array, result_type, index['imm'])

    return llvm_getelementptr(array, array_type, (llvm_value_num_zero, index), result_type)


def do_eval_expr_index_ptr(v):
    pointer = do_eval(v['pointer'])
    array_type = pointer['type']['to']
    result_type = v['type']
    array = llvm_dold(pointer)
    index = do_reval(v['index'])
    return llvm_getelementptr(array, array_type, (llvm_value_num_zero, index), result_type)


# получает укзаатель на структуру x
# его тип
# носер поля (просто число)
# возвращает value:address для поля этой структуры
def do_eval_access_ptr(x, xt, field_no, vt):
    field_index = llvm_value_num(type.typeInt32, field_no)
    return llvm_getelementptr(x, xt, (llvm_value_num_zero, field_index), vt)


def do_eval_access(rec, rt, pos, vt):
    # если это структура высичленная на ходу, у нее есть поле 'items'
    # там лежат записи вида {'id': ..., 'value': ...}
    # поле value ссылается при этом на уже вычисленное значение поля
    # ex: let p = {x=0, y=0};    p.x    // <--
    if 'items' in rec:
        return rec['items'][pos]['value']

    # если сама запись находится в регистре: (let rec = get_rec())
    if not rec['is_adr']:
        return llvm_extract_item(rec, vt, pos)

    # если работаем через 'переменую-указатель'
    # сперва нужно загрузить ее в регистр тем самым получим 'указатель'
    if type.is_pointer(rt):
        # pointer to record needs additional load
        rec = llvm_dold(rec)  # загружаем сам указатель
        rt = rt['to']

    return do_eval_access_ptr(rec, rt, pos, vt)



def do_eval_expr_access(v):
    rec = do_eval(v['record'])
    rt = v['record']['type']
    pos = v['field']['field_no']
    return do_eval_access(rec, rt, pos, v['type'])



def do_eval_expr_access_ptr(v):
    ptr = do_reval(v['pointer'])
    rt = ptr['type']['to']
    pos = v['field']['field_no']
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

        #if not 'strid' in x:
        #    print("NOT_STRID_IN" + str(x))

        return llvm_value_str(x['strid'], x['imm'], x['type'], value)

    return do_eval_literal(x)



# перепаковываем структуру в такую же структуру
# (просто с другим именем, изза чего LLVM ее считает "другой")
def cast_record_to_record(to_type, value, ti):
    #info("cast_record_to_record", ti)
    from_type = value['type']
    # создаем переменную под структуру A
    y = do_reval(value)
    struct = llvm_alloca(value['type'], init_ll_value=y)
    # приводим указатель на нее к указателю на структуру B
    new_struct_ptr = llvm_cast("bitcast", hlir_type_pointer(from_type), hlir_type_pointer(to_type), struct)
    # загружаем структуру B и возвращаем ее
    new_struct = llvm_deref(new_struct_ptr)
    return new_struct


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
        return llvm_value_zero(to_type)

    # (STUB?) nil -> zeroinitializer
    if type.is_free_pointer(from_type):
        if value_is_immediate(value):
            return llvm_value_num(to_type, value['imm'])

    # Cm имеет структурную систему типов, тогда как llvm - номинативную
    # приведение структуры к структуре по значению не поддерживается LLVM
    # поэтому делаем его отдельно
    if type.is_record(from_type):
        if type.is_record(to_type):
            return cast_record_to_record(to_type, value, x['ti'])


    if type.is_va_list(from_type):
        rv = do_eval(value)
        return llvm_va_arg(rv, to_type)


    v = do_reval(value)

    if is_global_context():
        return v

    opcode = select_cast_operator(from_type, to_type)

    return llvm_cast(opcode, from_type, to_type, v)



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
        iv = do_reval(item)
        items.append(iv)

    # теперь добавим паддинг нулевыми значениями
    fulllen = v['type']['volume']['imm']

    n_pad = fulllen - len(items)
    i = 0
    while i < n_pad:
        z = llvm_value_zero(v['type']['of'])
        items.append(z)
        i = i + 1

    # global?
    # глобальный массив распечатает print_value как литерал
    if is_global_context():
        return llvm_value_array(items, v['type'], v)

    # local.

    # если мы локальны то создадим иммутабельную структуру
    # с массивом (insertvalue)
    #%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
    xv = llvm_value_array([], v['type'])

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
    rec_type = v['type']
    initializers = v['imm']

    if is_global_context():
        items = []
        for initializer in initializers:
            iv = do_reval(initializer['value'])
            items.append({'id': initializer['id'], 'value': iv})
        return llvm_value_record(items, rec_type, v)


    # local context

    xv = llvm_value_record([], rec_type)

    # набиваем структуру
    for initializer in initializers:
        iv = do_reval(initializer['value'])
        iid = initializer['id']
        field = type.record_field_get(rec_type, iid['str'])
        xv = insertvalue(xv, iv, field['field_no'])

    return xv







def do_eval(x):
    assert(x != None)
    assert(x['isa'] == 'value')

    # WRONG WAY! remove this shit!
    # Way for IMMEDIATE values
    if value_is_immediate(x):
        xtype = x['type']

        if type.is_integer(xtype): return llvm_value_num(xtype, x['imm'])
        elif type.is_char(xtype): return llvm_value_num(xtype, x['imm'])
        elif type.is_record(xtype): return do_eval_record(x)
        elif type.is_array(xtype): return do_eval_array(x)
        elif type.is_float(xtype): return llvm_value_num(xtype, x['imm'])
        elif type.is_bool(xtype): return llvm_value_num(xtype, x['imm'])

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
    if type.is_integer(xt): return llvm_value_num(xt, x['imm'])
    elif type.is_float(xt): return llvm_value_num(xt, x['imm'])
    elif type.is_record(xt): return do_eval_record(x)
    elif type.is_array(xt): return do_eval_array(x)
    elif type.is_bool(xt): return llvm_value_num(xt, x['imm'])
    elif type.is_free_pointer(xt): return llvm_value_num(xt, x['imm'])
    elif type.is_pointer(xt): return llvm_value_num(xt, x['imm'])
    elif type.is_char(xt): return llvm_value_num(xt, x['imm'])
    elif type.is_bool(xt): return llvm_value_num(xt, x['imm'])
    else:
        value_print(x)
        error("do_eval_literal: unknown literal", x['ti'])
        exit(1)


def func_const_var(x):
    k = x['kind']

    if k == 'const':
        if 'imm' in x:
            if type.is_numeric(x['type']):
                return llvm_value_num(x['type'], x['imm'])

    if value_attribute_check(x, 'local'):
        localname = x['id']['str']
        y = locals_get(localname)
        return y

    if k == 'var':
        rv = llvm_value_mem(x['id']['str'], x['type'], x)
        rv['is_adr'] = True
        return rv

    if k == 'const':
        return do_eval(x['value'])

    return llvm_value_mem(x['id']['str'], ['type'], x)



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
        return llvm_value_zero(x['type'])

    return y


#
#
#

def print_stmt_assign(x):
    r = do_reval(x['right'])
    l = do_eval(x['left'])
    llvm_store(l, r)


def print_stmt_if(x):
    global func_context
    if_id = func_context['if_no']
    func_context['if_no'] = func_context['if_no'] + 1
    cv = do_reval(x['cond'])

    then_label = 'then_%d' % if_id
    else_label = 'else_%d' % if_id
    endif_label = 'endif_%d' % if_id

    if x['else'] == None:
        else_label = endif_label

    llvm_br(cv, then_label, else_label)

    # then block
    llvm_label(then_label)
    print_stmt(x['then'])
    llvm_jump(endif_label)

    # else block
    if x['else'] != None:
        llvm_label(else_label)
        print_stmt(x['else'])
        llvm_jump(endif_label)

    # endif label
    llvm_label(endif_label)



def print_stmt_while(x):
    global func_context
    old_while_id = func_context['cur_while_id']
    func_context['while_no'] = func_context['while_no'] + 1
    cur_while_id = func_context['while_no']
    func_context['cur_while_id'] = cur_while_id

    again_label = 'again_%d' % cur_while_id
    break_label = 'break_%d' % cur_while_id
    body_label = 'body_%d' % cur_while_id

    llvm_jump(again_label)
    llvm_label(again_label)
    cv = do_reval(x['cond'])
    llvm_br(cv, body_label, break_label)
    llvm_label(body_label)
    print_stmt(x['stmt'])
    llvm_jump(again_label)
    llvm_label(break_label)
    func_context['cur_while_id'] = old_while_id



def print_stmt_again():
    global func_context
    cur_while_id = func_context['cur_while_id']
    llvm_jump('again_%d' % cur_while_id)
    reg_get()    # for LLVM



def print_stmt_break():
    global func_context
    cur_while_id = func_context['cur_while_id']
    llvm_jump('break_%d' % cur_while_id)
    reg_get()    # for LLVM




def print_stmt_return(x):
    if va_list != None:
        llvm_va_end(va_list)

    v = None
    if x['value'] != None:
        v = do_eval(x['value'])

    global cfunc
    if 'sret' in cfunc['att']:
        to = cfunc['type']['to']
        p2retval = llvm_value_reg("0", hlir_type_pointer(to))

        if v['is_adr']:
            # save value from local variable (by ptr)
            size = llvm_value_num(type.select_nat(32), to['size'])
            llvm_memcpy(p2retval, v, size)
        else:
            # save value from reg
            llvm_store(p2retval, v)

        lo("ret void")
        reg_get()  # for LLVM
        return


    if v != None:
        loaded_v = llvm_dold(v)
        lo("ret ")
        print_type(x['value']['type'])
        out(" ")
        llvm_print_value(loaded_v)
    else:
        out("ret void")

    reg_get()    # for LLVM



def print_stmt_def_var(x):
    id_str = x['var']['id']['str']
    iv = None
    if x['var']['init'] != None:
        iv = do_reval(x['var']['init'])
    val = llvm_alloca(x['var']['type'], id_str=id_str, init_ll_value=iv)
    locals_add(id_str, val)
    return None


def print_stmt_let(x):
    id_str = x['value']['id']['str']
    val = x['init_value']

    if val['kind'] == 'call':
        if 'sret' in val['func']['att']:
            #info("call from let", x)
            v = llvm_alloca(val['type'], id_str=id_str)
            do_eval_expr_call(val, retval=v)
            locals_add(id_str, v)
            return

    v = do_reval(val)

    # для let-массивов выделяем память
    # поскольку их могут индексировать переменной
    # а массив-значение в "регистре" невозможно индексировать переменной
    if type.is_defined_array(val['type']):
        v = llvm_alloca(val['type'], id_str=id_str, init_ll_value=v)

    locals_add(id_str, v)
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



def print_stmt_block(s):
    locals_push()

    for stmt in s['stmts']:
        print_stmt(stmt)

    locals_pop()



def print_func_paramlist(func, only_types=False, with_attributes=True):
    arghack = 'arghack' in func['type']['att']
    sret = 'sret' in func['att']

    ftype = func['type']

    # here can be a pointer to function
    if type.is_pointer(ftype):
        ftype = ftype['to']

    params = ftype['params']
    to = ftype['to']

    if sret:
        # %struct.Sre* noalias sret(%struct.Sre) align 1 %0
        print_type(to)

        if with_attributes:
            out("* noalias sret(")
        else:
            out("*")

        if with_attributes:
            print_type(to)
            out(")")

        if not only_types:
            out(" %0")

        if len(params) > 0:
            out(", ")


    def print_param_type(param):
        print_type(param['type'])

    def print_param_w_id(param):
        print_type(param['type']); out(" %%%s" % param['id']['str'])

    method = print_param_w_id
    if only_types:
        method = print_param_type

    print_list_with(params, lambda param: method(param))

    if arghack:
        out(", ...")


def print_func_signature(func):
    arghack = 'arghack' in func['type']['att']
    sret = 'sret' in func['att']

    ftype = func['type']
    params = ftype['params']
    to = ftype['to']

    if not sret:
        print_type(to)
    else:
        out("void")

    out(" @%s(" % func['id']['str'])
    print_func_paramlist(func)
    out(")")



def print_decl_func(x):
    out("\ndeclare ")
    print_func_signature(x['value'])


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
    global cfunc
    cfunc = func

    out("\ndefine ")
    print_func_signature(func)

    sret = 'sret' in func['att']
    ftype = func['type']
    arghack = 'arghack' in ftype['att']

    if sret:
        reg_get() # get %0 reg for retval


    params = ftype['params']
    for param in params:
        param_id = param['id']['str']
        vv = llvm_value_stk(param_id, param['type'], param)
        locals_add(param_id, vv)


    # 0, 1, 2 - params; 3 - entry label, 4 - first free register
    entry_label = reg_get()  # should be here (!)

    out(" {")

    if arghack:
        global va_list
        id_str = func['va_id']['str'] # 'va_list'
        va_list = llvm_alloca(type.typeFreePtr, id_str=id_str)
        locals_add(id_str, va_list)
        llvm_va_start(va_list)


    print_stmt_block(func['stmt'])


    if type.eq(ftype['to'], type.typeUnit):
        if va_list != None:
            llvm_va_end(va_list)
        lo("ret void")

    indent_down()

    lo("}\n")

    va_list = None

    func_context = old_func_context

    cfunc = None





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
        llvm_print_value(do_eval(var['init']))
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

    if module['options'] != []:
        if 'use_arghack' in module['options']:
            lo("declare void @llvm.va_start(i8*)")
            lo("declare void @llvm.va_copy(i8*, i8*)")
            lo("declare void @llvm.va_end(i8*)")

        # llvm.memcpy intrinsic
        # <dest> <src> <len> <isvolatile>
        if 'use_memcpy' in module['options']:
            lo("declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)")
            #lo("declare void @llvm.memcpy.p0.p0.i64(ptr, ptr, i64, i1)")

        out("\n")

    print_module(module)
    output_close()



"""
def create_local_srtuct(typ, llvalues):
    #%5 = insertvalue %Type24 zeroinitializer, %Int32 1, 0
    xv = llvm_value_record([], typ, proto=None)

    lo("\n; -- fill struct")
    # набиваем структуру
    i = 0
    while i < len(llvalues):
        llvalue = llvalues[i]
        # получаем позицию поля в структуре
        field_target = type.record_field_get(v['type'], llvalue['id']['str'])


        pos = field_target['field_no']
        # запаковываем значение в структуру
        xv = insertvalue(xv, llvalue['value'], pos)
        i = i + 1
    lo("; -- end fill struct")

    return xv

"""




REL_OPS = ['eq', 'ne', 'lt', 'gt', 'le', 'ge']


def get_bin_opcode(op, t):

    def select_bin_opcode_su(sop, uop, t): # ["icmp slt", "icmp ult", x]
        if type.is_unsigned(t):
            return uop
        return sop


    def select_bin_opcode_f(op, fop, t): # ["sdiv", "udiv", "fdiv", x]
        if type.is_float(t):
            return fop
        return op


    def select_bin_opcode_suf(sop, uop, fop, t): # ["sdiv", "udiv", "fdiv", x]
        if type.is_float(t):
            return fop
        return select_bin_opcode_su(sop, uop, t)


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





"""
# сохр структур (вот не может просто так сохранить, приходится по полю)
def llvm_store_record(l, r):

    # if r is immediate value
    if 'items' in r:
        if len(r['items']) == 0:
            # если сохраняем пустую структуру
            # то просто сохраним в нее zeroinitializer
            llvm_store(l, r)
            return

    lo("; -- record assign field by field")
    for field in l['type']['fields']:
        ft = field['type']

        # получаем указатель на поле левого (в которое будем сохранять)
        l_field_ptr = do_eval_access_ptr(l, l['type'], field['field_no'], ft)

        rpos = field['field_no']

        rv = llvm_dold(do_eval_access(r, r['type'], rpos, ft))

        # сохраняем
        llvm_assign(l_field_ptr, rv)
    lo("; -- end record assign field by field\n")
"""
