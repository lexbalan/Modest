
import copy
from .common import *
from error import info, warning, error
import hlir.type as hlir_type
from hlir.type import type_print
from value.value import value_attribute_check, value_print, value_is_immediate
from hlir.value import hlir_is_value, hlir_value_int
from hlir.type import hlir_type_pointer
import settings

import foundation

LLVM_TARGET_TRIPLE = ""
LLVM_TARGET_DATALAYOUT = ""


# LLVM не умеет нативно возвращать большие значения
# Для этого есть механизм sret;
# когда первым параметром идет указатель на возвращаемое значение (ABI)
RET_SIZE_MAX = 16
def need_sret(return_type):
    return return_type['size'] > RET_SIZE_MAX


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

    llvm_value_num_zero = llvm_value_num(foundation.typeInt32, 0)


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
        'asset': num,
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
    y = llvm_cast('bitcast', hlir_type_pointer(x['type']), foundation.typeFreePointer, x)
    lo("call void @llvm.va_start(i8* %%%s)" % y['reg'])


#"%96 = bitcast i8** %3 to i8*"
#"call void @llvm.va_end(i8* %96)"
def llvm_va_end(x):
    y = llvm_cast('bitcast', hlir_type_pointer(x['type']), foundation.typeFreePointer, x)
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
    char_width = string_of['width']
    str_len = x['len']
    out("bitcast ([%d x i%d]* @%s to [0 x i%d]*)" % (str_len, char_width, x['id'], char_width))



def llvm_print_value_num(x):
    num = x['asset']
    if not hlir_type.type_is_pointer(x['type']):
        # integer, float, bool, char
        out(str(num))

    else:
        if x['asset'] == 0:
            out("null")
        else:
            v = llvm_value_num(foundation.typeNat64, x['asset'])
            llvm_inline_cast('inttoptr', x['type'], v)



def llvm_print_value_inlinecast(x):
    llvm_inline_cast('bitcast', x['type'], x['value'])


def llvm_print_value_zero(x):
    if hlir_type.type_is_record(x['type']): out("zeroinitializer")
    elif hlir_type.type_is_array(x['type']): out("zeroinitializer")
    elif hlir_type.type_is_pointer(x['type']): out("null")
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

    result_type = None
    if x['is_adr']:
        result_type = x['type'] # if it just 'is_adr' ll_value
    else:
        result_type = x['type']['to'] # if it's real pointer
    assert(result_type != None)

    return llvm_value_reg(reg, result_type, x)


# сохр простых значений
def llvm_store(l, r):
    assert(l['isa'] == 'll_value')
    assert(r['isa'] == 'll_value')
    lo("store ")
    llvm_print_type_value(r)
    out(", ")
    llvm_print_type_value(l)



# получает два указателя, и размер
def llvm_memcpy_immsize(dst, src, size, volatile=False):
    #"@llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)"
    dst2 = llvm_cast('bitcast', dst['type'], foundation.typeFreePointer, dst)
    src2 = llvm_cast('bitcast', src['type'], foundation.typeFreePointer, src)
    out(NL_INDENT)
    out("call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(")
    llvm_print_type_value(dst2)
    out(", "); llvm_print_type_value(src2)
    out(", i32 %d" % size);
    out(", i1 %d)" % volatile)


# получает два указателя, и размер
def llvm_memcpy(dst, src, size, volatile=False):
    #"@llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)"
    dst2 = llvm_cast('bitcast', dst['type'], foundation.typeFreePointer, dst)
    src2 = llvm_cast('bitcast', src['type'], foundation.typeFreePointer, src)
    out(NL_INDENT)
    out("call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(")
    llvm_print_type_value(dst2)
    out(", "); llvm_print_type_value(src2)
    out(", "); llvm_print_type_value(size)
    out(", i1 %d)" % volatile)


#declare void @llvm.memset.p0.i32(ptr <dest>, i8 <val>, i32 <len>, i1 <isvolatile>)
def llvm_memzero(dst, size, volatile=False):
    #"@llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)"
    dst2 = llvm_cast('bitcast', dst['type'], foundation.typeFreePointer, dst)
    out(NL_INDENT)
    out("call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(")
    llvm_print_type_value(dst2)
    out(", i8 0, i32 %d" % size); #llvm_print_type_value(size)
    out(", i1 %d)" % volatile)




def llvm_br(x, then_label, else_label):
    lo("br ")
    llvm_print_type_value(x)
    out(" , label %%%s, label %%%s" % (then_label, else_label))


def llvm_jump(label):
    lo("br label %%%s" % label)


def llvm_label(label):
    out("\n%s:" % label)


def llvm_alloca(typ, id_str=None):
    assert(typ['isa'] == 'type')
    reg = llvm_operation("alloca", reg=id_str)
    print_type(typ)
    val = llvm_value_stk(reg, typ)
    val['is_adr'] = True
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



# получает укзаатель на структуру x
# его тип
# носер поля (просто число)
# возвращает value:address для поля этой структуры
def llvm_eval_access_ptr(x, rec_type, field_no, result_type):
    field_index = llvm_value_num(foundation.typeInt32, field_no)
    return llvm_getelementptr(x, rec_type, (llvm_value_num_zero, field_index), result_type)


def llvm_eval_access(rec, field_no, result_type):
    rt = rec['type']
    # если это структура высичленная на ходу, у нее есть поле 'items'
    # там лежат записи вида {'id': ..., 'value': ...}
    # поле value ссылается при этом на уже вычисленное значение поля
    # ex: let p = {x=0, y=0};    p.x    // <--
    if 'items' in rec:
        return rec['items'][field_no]['value']

    # если сама запись находится в регистре: (let rec = get_rec())
    if not rec['is_adr']:
        return llvm_extract_item(rec, result_type, field_no)

    # если работаем через 'переменую-указатель'
    # сперва нужно загрузить ее в регистр тем самым получим 'указатель'
    if hlir_type.type_is_pointer(rt):
        # pointer to record needs additional load
        rec = llvm_dold(rec)  # загружаем указатель в регистр
        rt = rt['to']

    return llvm_eval_access_ptr(rec, rt, field_no, result_type)




def print_list_with(lst, method):
    i = 0
    while i < len(lst):
        if i > 0: out(", ")
        method(lst[i])
        i = i + 1



def print_type_enum(t):
    out('i%d' % t['width'])


def print_type_record(t):
    out("{")
    fields = t['fields']
    i = 0
    while i < len(fields):
        field = fields[i]

        if i > 0: out(',')
        if is_global_context():
            out("\n\t")
        else:
            out(" ")

        print_type(field['type'])

        i = i + 1

    if is_global_context():
        out("\n")

    out("}")


def print_type_array(t):
    out("[")
    array_size = t['volume']
    sz = 0
    if array_size != None:
        sz = array_size['asset']
    out("%d x " % sz)
    print_type(t['of'])
    out("]")


def print_type_func(t):
    if hlir_type.type_is_unit(t['to']):
        out("void")
    else:
        print_type(t['to'])

    out(" (")
    print_list_with(t['params'], lambda f: print_type(f['type']))
    if t['extra_args']:
        out(", ...")
    out(")")


def print_type_pointer(t):
    if hlir_type.type_is_free_pointer(t):
        out("i8*")
    else:
        print_type(t['to']); out("*")



def print_type_id(t):
    if t['definition'] != None:
        type_definition = t['definition']
        if 'llvm_alias' in type_definition:
            out(type_definition['llvm_alias'])
        else:
            out("%")
            out(type_definition['id']['str'])
        return True

    elif t['declaration'] != None:
        type_declaration = t['declaration']
        if 'llvm_alias' in type_declaration:
            out(type_declaration['llvm_alias'])
        else:
            out("%")
            out(type_declaration['id']['str'])
        return True

    return False

# функция может получать только указатель на массив
# если же в CM она получает массив то тут и в СИ она получает
# указатель на него, и потом копирует его во внутренний массив
def print_type(t):
    print_aka=True
    k = t['kind']

    if print_aka:


        # тупой LLVM не умеет делать алиасы структур
        # он типа делает, но потом к переменной с таким типом
        # хрен обратишься... дерьмо
        if hlir_type.type_is_record(t):
            root_id = hlir_type.get_type_root_id(t)
            if root_id != None:
                out("%" + root_id['str'])
                return

        res = print_type_id(t)
        if res:
            return

        # иногда сюда залетают дженерики например в to левое:
        # let p = 0x12345678 to *Nat32
        if hlir_type.type_is_perfect_integer(t):
            out("i%d" % t['width'])
            return

        #if t['id'] != None:
        #    out('%%%s' % t['id']['str'])
        #    return

    if hlir_type.type_is_func(t): print_type_func(t)
    elif hlir_type.type_is_record(t): print_type_record(t)
    elif hlir_type.type_is_pointer(t): print_type_pointer(t)
    elif hlir_type.type_is_array(t): print_type_array(t)
    elif hlir_type.type_is_enum(t): print_type_enum(t)

    elif hlir_type.type_is_integer(t):
        out("i%d" % t['width'])

    elif hlir_type.type_is_float(t):
        print_type_id(t)

    elif hlir_type.type_is_char(t):
        out("i%d" % t['width'])

    elif hlir_type.type_is_opaque(t):
        out('opaque')

    elif hlir_type.type_is_va_list(t):
        out("i8*")

    else:
        out("<type:%s>" % k)



def do_reval(x):
    return llvm_dold(do_eval(x))


def do_eval_expr_bin(x):
    if value_is_immediate(x):
        return llvm_value_num(x['type'], x['asset'])

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
                if 'global' in v['value']['att']:
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

    sret = need_sret(ftype['to'])

    # если просто вызвали и не забирают retval
    # сгенерим фейковый retval
    if sret:
        if retval == None:
            retval = llvm_alloca(ftype['to'])

    # eval func
    f = do_eval(func)

    if hlir_type.type_is_pointer(ftype):
        # pointer to array needs additional load
        f = llvm_dold(f)
        ftype = ftype['to']

    to_unit = hlir_type.type_eq(ftype['to'], foundation.typeUnit)


    # do call
    reg = None
    if to_unit or sret:
        lo("call ")
    else:
        reg = llvm_operation("call")

    print_type_func(ftype)
    out(" ")
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

        return llvm_extract_item(array, result_type, index['asset'])

    return llvm_getelementptr(array, array_type, (llvm_value_num_zero, index), result_type)


def do_eval_expr_index_ptr(v):
    pointer = do_reval(v['pointer'])
    array_type = pointer['type']['to']
    index = do_reval(v['index'])
    result_type = v['type']
    return llvm_getelementptr(pointer, array_type, (llvm_value_num_zero, index), result_type)


def do_eval_expr_access(v):
    rec = do_eval(v['record'])
    pos = v['field']['field_no']
    result_type = v['type']
    return llvm_eval_access(rec, pos, result_type)


def do_eval_expr_access_ptr(v):
    ptr = do_reval(v['pointer'])
    rt = ptr['type']['to']
    pos = v['field']['field_no']
    result_type = v['type']
    return llvm_eval_access_ptr(ptr, rt, pos, result_type)



'trunc .. to'
'zext .. to'
'sext .. to'
'fptrunc .. to'
'fpext .. to'
'fptoui .. to'
'fptosi .. to'
'uitofp .. to'
'sitofp .. to'
'ptrtoint .. to'
'inttoptr .. to'
'bitcast .. to'
'addrspacecast .. to'

# cast type a to type b
def select_cast_operator(a, b):
    if hlir_type.type_is_integer(a) or hlir_type.type_is_char(a) or hlir_type.type_is_bool(a) or hlir_type.type_is_byte(a):
        if hlir_type.type_is_integer(b) or hlir_type.type_is_char(b) or hlir_type.type_is_bool(b) or hlir_type.type_is_byte(b):
            signed = hlir_type.type_is_signed(b)

            if a['width'] < b['width']:
                return 'sext' if signed else 'zext'

            elif a['width'] > b['width']:
                return 'trunc'

            else:
                return 'bitcast'

        elif hlir_type.type_is_pointer(b):
            return 'inttoptr'

        elif hlir_type.type_is_float(b):
            return 'sitofp' if hlir_type.type_is_signed(a) else 'uitofp'

    elif hlir_type.type_is_pointer(a):
        if hlir_type.type_is_pointer(b): return 'bitcast'
        elif hlir_type.type_is_integer(b): return 'ptrtoint'

    elif hlir_type.type_is_float(a):
        # Float -> Integer
        if hlir_type.type_is_integer(b):
            return 'fptosi' if hlir_type.type_is_signed(b) else 'fptoui'

        # Float -> Float
        elif hlir_type.type_is_float(b):
            if a['width'] < b['width']: return 'fpext'
            elif a['width'] > b['width']: return 'fptrunc'
            else: return 'bitcast'


    return 'cast <%s -> %s>' % (a['kind'], b['kind'])



def do_eval_expr_cast_immediate(x):
    value = x['value']
    from_type = value['type']
    to_type = x['type']

    # строки печатаются ТОЛЬКО отсюда!
    if hlir_type.type_is_pointer_to_array_of_char(to_type):
        if hlir_type.type_is_array_of_char(from_type):
            string_of = to_type['to']['of']
            char_pow = string_of['width']
            return llvm_value_str(x['strid'], x['asset'], x['type'], value)

    return do_eval_literal(x)



# перепаковываем структуру в такую же структуру
# (просто с другим именем, изза чего LLVM ее считает "другой")
def cast_record_to_record(to_type, value, ti):
    #info("cast_record_to_record", ti)
    #out("\n;cast_record_to_record")
    from_type = value['type']
    # создаем переменную под структуру A
    iv = do_reval(value)
    struct = llvm_alloca(from_type)
    llvm_store(struct, iv)
    # приводим указатель на нее к указателю на структуру B
    new_struct_ptr = llvm_cast("bitcast", hlir_type_pointer(from_type), hlir_type_pointer(to_type), struct)
    # загружаем структуру B и возвращаем ее
    new_struct = llvm_deref(new_struct_ptr)
    return new_struct


def do_eval_expr_cast(x):
    value = x['value']
    from_type = value['type']
    to_type = x['type']

    if hlir_type.type_is_perfect_array_of_char(from_type):
        if hlir_type.type_is_pointer_to_array_of_char(to_type):
            error("strings need to be printed through do_eval_expr_cast_immediate", x)
            exit(1)

    # cast any type to Unit type
    if hlir_type.type_is_unit(to_type):
        return llvm_value_zero(to_type)

    # (STUB?) nil -> zeroinitializer
    if hlir_type.type_is_free_pointer(from_type):
        if value_is_immediate(value):
            return llvm_value_num(to_type, value['asset'])

    # Cm имеет структурную систему типов, тогда как llvm - номинативную
    # приведение структуры к структуре по значению не поддерживается LLVM
    # поэтому делаем его отдельно
    if hlir_type.type_is_record(from_type):
        if hlir_type.type_is_record(to_type):
            return cast_record_to_record(to_type, value, x['ti'])

    if hlir_type.type_is_va_list(from_type):
        # приведение объекта типа va_list особенное
        # оно дает доступ к следующему элементу списка
        rv = do_eval(value)
        return llvm_va_arg(rv, to_type)


    v = do_reval(value)


    # AnyNonZeroValue to Bool  ==  true  (!)
    # the same as in C
    if hlir_type.type_is_bool(to_type):
        z = llvm_value_num(v['type'], 0)
        return llvm_eval_binary('icmp ne', v, z, x)


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
    for item in v['asset']:
        iv = do_reval(item)
        items.append(iv)

    # теперь добавим паддинг нулевыми значениями
    fulllen = v['type']['volume']['asset']

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

    if True:
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
    initializers = v['asset']

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
        field = hlir_type.record_field_get(rec_type, initializer['id']['str'])
        xv = insertvalue(xv, iv, field['field_no'])

    return xv



def do_eval_func_const_var(x):
    k = x['kind']

    if value_attribute_check(x, 'local'):
        localname = x['id']['str']
        y = locals_get(localname)
        return y

    if k == 'const':
        if value_is_immediate(x): # TODO: wtf? (see begining of do_eval)
            if hlir_type.type_is_integer(x['type']) or hlir_type.type_is_float(x['type']):
                return llvm_value_num(x['type'], x['asset'])

        return do_eval(x['value'])

    elif k == 'var':
        rv = llvm_value_mem(x['id']['str'], x['type'], x)
        rv['is_adr'] = True
        return rv

    return llvm_value_mem(x['id']['str'], x['type'], x)



def do_eval_literal(x):
    xt = x['type']
    if hlir_type.type_is_integer(xt): return llvm_value_num(xt, x['asset'])
    elif hlir_type.type_is_float(xt): return llvm_value_num(xt, x['asset'])
    elif hlir_type.type_is_record(xt): return do_eval_record(x)
    elif hlir_type.type_is_array(xt): return do_eval_array(x)
    elif hlir_type.type_is_bool(xt): return llvm_value_num(xt, x['asset'])
    elif hlir_type.type_is_free_pointer(xt): return llvm_value_num(xt, x['asset'])
    elif hlir_type.type_is_pointer(xt): return llvm_value_num(xt, x['asset'])
    elif hlir_type.type_is_char(xt): return llvm_value_num(xt, x['asset'])
    elif hlir_type.type_is_enum(xt): return llvm_value_num(xt, x['asset'])
    elif hlir_type.type_is_byte(xt): return llvm_value_num(xt, x['asset'])
    else:
        value_print(x)
        error("do_eval_literal: unknown literal", x['ti'])
        exit(1)



def do_eval(x):
    assert(x != None)
    assert(hlir_is_value(x))

    if value_is_immediate(x):
        # сюда попадают литералы,
        # и любые другие значения с immediate полем
        if hlir_type.type_is_free_pointer(x['type']):
            return do_eval_literal(x)

        if not hlir_type.type_is_pointer(x['type']):
            return do_eval_literal(x)

    k = x['kind']
    if k in bin_ops: y = do_eval_expr_bin(x)
    elif k in un_ops: y = do_eval_expr_un(x)
    elif k in ['func', 'const', 'var']: y = do_eval_func_const_var(x)
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

    if y != None:
        y['type'] = x['type']  # TODO: wtf?

    else:
        print("do_eval_x cannot eval value")
        value_print(x)
        return llvm_value_zero(x['type'])

    return y


#
#
#

# WARNING:
# param l must be #ll_value
# param rx must be #value (!)
def _do_assign(l, rx):
    #print("_do_assign")
    assert(l['isa'] == 'll_value')
    assert(rx['isa'] == 'value')

    zero_rest = 0
    to_copy = 0
    if rx['kind'] == 'cast':
        # for case:
        # var x: [10]Int32
        # var y: [5]Int32
        # x = y to [10]Int32
        if hlir_type.type_is_array(rx['type']):
            rx = rx['value']

            # <??>
            l_vol = l['type']['size']
            r_vol = rx['type']['size']
            if l_vol > r_vol:
                zero_rest = l_vol - r_vol
                to_copy = r_vol
            else:
                to_copy = l_vol

            #print("REST ====== %d" % zero_rest)
            #print("TO_COPY ====== %d" % to_copy)


    r = do_eval(rx)
    # если правое является адресом а не самим значением
    # то его можно сохранить с помощью memcpy
    if r['is_adr']:

        """if hlir_type.type_is_array(l['type']):

            # если значение слева равно (memcpy)
            # если значение слева больше (memcpy + memset)
            l_vol = left['type']['volume']['asset']
            r_vol = right['type']['volume']['asset']
            if l_vol > r_vol:
            """

        # TODO!
        if zero_rest > 0:
            sz = l['type']['size']
            llvm_memzero(l, sz)

        sz = r['type']['size']
        llvm_memcpy_immsize(l, r, sz, volatile=False)

    else:
        llvm_store(l, llvm_dold(r))




def print_stmt_assign(x):
    l = do_eval(x['left'])
    _do_assign(l, x['right'])



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


def print_stmt_again(x):
    global func_context
    cur_while_id = func_context['cur_while_id']
    llvm_jump('again_%d' % cur_while_id)
    reg_get()  # for LLVM


def print_stmt_break(x):
    global func_context
    cur_while_id = func_context['cur_while_id']
    llvm_jump('break_%d' % cur_while_id)
    reg_get()  # for LLVM


def print_stmt_return(x):
    global cfunc
    if va_list != None:
        llvm_va_end(va_list)


    if x['value'] != None:
        if not need_sret(cfunc['type']['to']):
            v = do_eval(x['value'])
            xv = llvm_dold(v)
            lo("ret ")
            llvm_print_type_value(xv)
            reg_get()  # for LLVM
            return None

        # return via sret
        to = cfunc['type']['to']
        p2retval = llvm_value_reg("0", hlir_type_pointer(to))
        _do_assign(p2retval, x['value'])


    out("ret void")
    reg_get()  # for LLVM
    return None



def print_stmt_def_var(x):
    id_str = x['var']['id']['str']
    val = llvm_alloca(x['var']['type'])
    locals_add(id_str, val)

    if x['default_value'] != None:
        _do_assign(val, x['default_value'])

    return None



def print_stmt_let(x):
    id_str = x['id']['str']
    val = x['value']

    if val['kind'] == 'call':
        if need_sret(val['func']['type']['to']):
            v = llvm_alloca(val['type'])
            do_eval_expr_call(val, retval=v)
            locals_add(id_str, v)
            return None

    v = do_reval(val)

    # для let-массивов выделяем память
    # поскольку их могут индексировать переменной
    # а массив-значение в "регистре" невозможно индексировать переменной
    if hlir_type.type_is_defined_array(val['type']):
        nv = llvm_alloca(val['type'])
        llvm_store(nv, v)
        v = nv

    locals_add(id_str, v)
    return None


def print_stmt_block(s):
    locals_push()

    for stmt in s['stmts']:
        print_stmt(stmt)

    locals_pop()


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
    elif k == 'break': print_stmt_break(x)
    elif k == 'again': print_stmt_again(x)
    elif k == 'comment-line': print_comment_line(x)
    elif k == 'comment-block': print_comment_block(x)
    else: lo("<stmt %s>" % str(x))




def print_func_paramlist(func, only_types=False, with_attributes=True):
    sret = need_sret(func['type']['to'])

    ftype = func['type']

    # here can be a pointer to function
    if hlir_type.type_is_pointer(ftype):
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

    if func['type']['extra_args']:
        out(", ...")


def print_func_signature(func):
    sret = need_sret(func['type']['to'])

    ftype = func['type']
    params = ftype['params']
    to = ftype['to']

    if not sret:
        if hlir_type.type_is_unit(to):
            out("void")
        else:
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

    sret = need_sret(func['type']['to'])
    ftype = func['type']

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

    if ftype['extra_args']:
        global va_list
        id_str = ftype['va_list_id']['str'] # 'va_list'
        va_list = llvm_alloca(foundation.typeFreePointer)
        locals_add(id_str, va_list)
        llvm_va_start(va_list)

    print_stmt_block(func['stmt'])

    if hlir_type.type_eq(ftype['to'], foundation.typeUnit):
        if va_list != None:
            llvm_va_end(va_list)
        lo("ret void")

    indent_down()

    lo("}\n")

    va_list = None

    func_context = old_func_context

    cfunc = None



def print_decl_type(x):
    out("\n%%%s = type opaque" % x['id']['str'])


def print_def_type(x):
    xtype = x['original_type']
    if hlir_type.type_is_record(xtype):
        root_id = hlir_type.get_type_root_id(xtype)
        if root_id != None:
            return

    out("\n%%%s = type " % x['id']['str'])
    print_type(xtype)
    if hlir_type.type_is_record(xtype):
        out("\n")


def print_def_var(x):
    #mods = ['external', 'global', 'constant']
    mod = 'global'
    out("\n@")
    var = x['value']
    out(var['id']['str'])
    out(" = %s " % mod)
    print_type(var['type'])
    if x['default_value'] != None:
        out(" ")
        llvm_print_value(do_eval(x['default_value']))
    else:
        out(" zeroinitializer")


def print_string_ascii(strid, string):
    ss = ""

    for c in string['asset']:
        ss = ss + chr(c['asset'])

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
    slen = len(string['asset'])
    lo("@%s = private constant [%d x i%d] [" % (strid, slen, char_width))
    i = 0
    for c in string['asset']:
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

        char_width = string['type']['to']['of']['width']

        string['strid'] = strid

        print_string_as_array(strid, string, char_width)



# список имен модулей распечатанных в текущей сброке
printed_modules = []

def print_module(m):

    if m['source_info']['path'] in printed_modules:
        return

    printed_modules.append(m['source_info']['path'])


    for imported_module in m['imports']:
        print_module(imported_module)


    out("\n; -- SOURCE: %s\n" % m['source_info']['name'])

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
        #elif isa == 'def_const': print_def_const(x)
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

    lo("%Unit = type i1")
    lo("%Bool = type i1")
    lo("%Byte = type i8")
    lo("%Char8 = type i8")
    lo("%Char16 = type i16")
    lo("%Char32 = type i32")
    lo("%Int8 = type i8")
    lo("%Int16 = type i16")
    lo("%Int32 = type i32")
    lo("%Int64 = type i64")
    lo("%Int128 = type i128")
    lo("%Nat8 = type i8")
    lo("%Nat16 = type i16")
    lo("%Nat32 = type i32")
    lo("%Nat64 = type i64")
    lo("%Nat128 = type i128")
    lo("%Float32 = type float")
    lo("%Float64 = type double")
    lo("%Pointer = type i8*")
    lo("%Str8 = type [0 x %Char8]")
    lo("%Str16 = type [0 x %Char16]")
    lo("%Str32 = type [0 x %Char32]")
    lo("%VA_List = type i8*")


    if module['options'] != []:
        if 'use_extra_args' in module['options']:
            lo("declare void @llvm.va_start(i8*)")
            lo("declare void @llvm.va_copy(i8*, i8*)")
            lo("declare void @llvm.va_end(i8*)")

        # llvm.memcpy intrinsic
        # <dest> <src> <len> <isvolatile>
#        if 'use_memcpy' in module['options']:
#            lo("declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)")
            #lo("declare void @llvm.memcpy.p0.p0.i64(ptr, ptr, i64, i1)")

        #lo("declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)")
        out("\n")

    lo("declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)")
    lo("declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)\n")

    print_module(module)
    output_close()



REL_OPS = ['eq', 'ne', 'lt', 'gt', 'le', 'ge']


def get_bin_opcode(op, t):

    def select_bin_opcode_su(sop, uop, t): # ["icmp slt", "icmp ult", x]
        if hlir_type.type_is_unsigned(t):
            return uop
        return sop

    def select_bin_opcode_f(op, fop, t): # ["sdiv", "udiv", "fdiv", x]
        if hlir_type.type_is_float(t):
            return fop
        return op

    def select_bin_opcode_suf(sop, uop, fop, t): # ["sdiv", "udiv", "fdiv", x]
        if hlir_type.type_is_float(t):
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
        opcode = 'ashr' if hlir_type.type_is_signed(t) else 'lshr'
    elif op == 'logic_or':
        opcode = 'or'
    elif op == 'logic_and':
        opcode = 'and'

    return opcode

