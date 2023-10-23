
import type
from error import info
from .common import *
from value.value import value_attribute_check
from util import get_item_with_id


INDENT_SYMBOL = " " * 4


def init():
    pass


def indent():
    ind(INDENT_SYMBOL)


aprecedence = [
    ['logic_or'], #0
    ['logic_and'], #1
    ['or'], #2
    ['xor'], #3
    ['and'], #4
    ['eq', 'ne'], #5
    ['lt', 'le', 'gt', 'ge'], #6
    ['shl', 'shr'], #7
    ['add', 'sub'], #8
    ['mul', 'div', 'rem'], #9
    ['plus', 'minus', 'not', 'cast', 'ref', 'deref', 'sizeof'], #10
    ['call', 'index', 'access'], #11
    ['num', 'var', 'func', 'str', 'enum', 'record', 'array'] #12
]

precedenceMax = len(aprecedence) - 1

# приоритет операции
def precedence(x):
    i = 0
    while i < precedenceMax + 1:
        if x in aprecedence[i]:
            break
        i = i + 1
    return i



def print_comment(x):
    k = x['kind']
    if k == 'line':
        print_comment_line(x)
    elif k == 'block':
        print_comment_block(x)
    else:
        pass


def print_comment_block(x):
    indent()
    out("/*%s*/" % x['text'])


def print_comment_line(x):
    lines = x['lines']
    n = len(lines)
    i = 0
    while i < n:
        line = lines[i]
        indent(); out("//%s" % line['str'])
        i = i + 1
        if i < n:
            out("\n")




def print_type_integer(t):
    if 'id' in t:
        out(t['id']['str'])
        return

    out(t['name'])


def print_type_array(t):
    out("[")
    if t['volume'] != None:
        print_value(t['volume'])
    out("]")
    print_type(t['of'])


def print_type_pointer(t):
    if type.is_free_pointer(t):
        out("Pointer")
    else:
        out("*"); print_type(t['to'])




def print_field(x):
    out("%s : " % x['id']['str'])
    print_type(x['type'])


def print_fields(fields, before, after, separator):
    i = 0
    n = len(fields)
    while i < n:
        param = fields[i]
        out(before); print_field(param); out(after)
        i = i + 1
        if i < n: out(separator)


def print_type_record(t):
    out("record {")

    indent_up()

    for field in t['fields']:
        # print comments
        if 'comments' in field:
            for comment in field['comments']:
                out("\n" * comment['nl'])
                print_comment(comment)

        out("\n" * field['nl'])
        indent();
        print_field(field)

    indent_down()

    out("\n")
    indent()
    out("}")



def print_type_enum(t):
    out("enum {")
    items = t['items']
    i = 0
    while i < len(items):
        item = items[i]
        out("\n")
        #o("\t%s_%s," % (t['aka'], item['id']['str']))
        out("\t%s," % (item['id']['str']))
        i = i + 1
    out("\n}")





def print_type_func(t):
    out('(')
    print_fields(t['params'], before="",    after="", separator=", ")
    out(') -> ')
    print_type(t['to'])



def print_type(t, print_aka=True):
    k = t['kind']

    if print_aka:
        """if 'id' in t:
            out(t['id']['str'])
            return"""

        if 'name' in t:
            out(t['name'])
            return

    if type.is_integer(t): print_type_integer(t)
    elif type.is_func(t): print_type_func(t)
    elif type.is_array(t): print_type_array(t)
    elif type.is_record(t): print_type_record(t)
    elif type.is_enum(t): print_type_enum(t)
    elif type.is_pointer(t): print_type_pointer(t)
    elif k == 'opaque': pass
    else: out("<type:" + str(t) + ">")



bin_ops = {
    'or': 'or', 'xor': 'xor', 'and': 'and', 'shl': '<<', 'shr': '>>',
    'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
    'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'rem': '%',
    'logic_and': 'and', 'logic_or': 'or',
    'add_str': '+', 'eq_str': '==', 'ne_str': '!='
}

def print_value_bin(v, ctx):
    op = v['kind']
    left = v['left']
    right = v['right']

    # получаем приоритеты операции и операндов
    p0 = precedence(op)
    pl = precedence(left['kind'])
    pr = precedence(right['kind'])
    need_wrap_left = pl < p0
    need_wrap_right = pr < p0

    # GCC выдает warning например в: 1 << 2 + 2, тк считает
    # Что юзер имел в виду (1 << 2) + 2, а у << приоритет тние
    # чтобы он не ругался, завернем такие выражения в скобки
    if op in ['shl', 'shr']:
        need_wrap_left = precedence(left['kind']) < precedenceMax
        need_wrap_right = precedence(right['kind']) < precedenceMax

    print_value(left, need_wrap=need_wrap_left)
    out(' %s ' % bin_ops[op])
    print_value(right, need_wrap=need_wrap_right)



un_ops = {
    'ref': '&', 'deref': '*',
    'plus': '+', 'minus': '-',
    'not': 'not', 'logic_not': 'not'
}


def print_value_un(v, ctx):
    op = v['kind']
    value = v['value']
    p0 = precedence(op)
    pv = precedence(value['kind'])
    out(un_ops[op]); print_value(value, need_wrap=pv<p0)


def print_values(values, before, after, separator):
    i = 0
    n = len(values)
    while i < n:
        a = values[i]
        out(before)
        print_value(a)
        out(after)
        i = i + 1
        if i < n:
            out(separator)


def print_value_call(v, ctx):
    print_value(v['func'])
    out("(")
    print_values(v['args'], before="", after="", separator=", ")
    out(")")


def print_value_index(v, ctx):
    array = v['array']
    index = v['index']
    need_wrap = precedence(array['kind']) < precedence('index')
    print_value(array, need_wrap=need_wrap)
    out("["); print_value(index); out("]")


def print_value_index_ptr(v, ctx):
    array = v['pointer']
    index = v['index']
    need_wrap = precedence(array['kind']) < precedence('index')
    print_value(array, need_wrap=need_wrap)
    out("["); print_value(index); out("]")


def print_value_access(v, ctx):
    left = v['record']
    need_wrap = precedence(left['kind']) < precedence('access')
    print_value(left, need_wrap=need_wrap); out("."); out(v['field']['id']['str'])


def print_value_access_ptr(v, ctx):
    left = v['pointer']
    need_wrap = precedence(left['kind']) < precedence('access')
    print_value(left, need_wrap=need_wrap); out("."); out(v['field']['id']['str'])


def print_cast(t, v, ctx=[]):
    print_value(v, ctx=ctx)
    out(' to ')
    print_type(t)



def print_value_cast_generic(v, ctx):
    # дженерик каст не печатаю, печатаю просто значение
    need_wrap = precedence(v['value']['kind']) < precedenceMax
    print_value(v['value'], ctx, need_wrap=need_wrap)
    return


def print_value_cast(v, ctx):
    value = v['value']
    from_type = value['type']
    to_type = v['type']


    # NO need cast ptr to *void
    if type.is_pointer(from_type):
        if type.is_free_pointer(to_type):
            print_value(v['value'])
            return

    # NO need cast *void to ptr
    if type.is_free_pointer(from_type):
        if type.is_pointer(to_type):
            print_value(v['value'])
            return

    print_cast(v['type'], v['value'], ctx)



def print_value_literal_arr(v, ctx):

    value = v
    if type.is_generic_string(value['type']):
        #print("LIT_CM")
        print_value_literal_str(value, ctx=[])
        return


    out("[")
    indent_up()
    #print_values(v['imm'], before=nl_indentation(INDENT_SYMBOL), after="", separator="")

    values = v['imm']
    i = 0
    n = len(values)
    while i < n:
        a = values[i]

        nl = 0
        if 'nl' in a:
            nl = a['nl']

        if nl > 0:
            out("\n" * nl)
            indent()
        else:
            if i > 0:
                out(" ")

        print_value(a, ctx=ctx)

        i = i + 1

        if nl == 0:
            if i < n:
                out(',')


    indent_down()

    if v['nl_end'] > 0:
        out("\n" * v['nl_end'])
        indent()

    out("]")



def print_value_literal_record(v, ctx):
    multiline = not 'oneline' in ctx

    out("{")

    indent_up()

    initializers = v['imm']
    nitems = len(initializers)
    i = 0
    while i < nitems:
        item = v['type']['fields'][i]
        field_str = item['id']['str']


        ini = get_item_with_id(initializers, field_str)

        nl = 0
        if 'nl' in ini:
            nl = ini['nl']

        if nl > 0:
            out("\n" * nl)
            indent()
        else:
            if i > 0:
                out(" ")

        out("%s = " % field_str)
        print_value(ini['value'], ctx)

        if nl == 0:
            if i < (nitems - 1):
                out(",")

        i = i + 1

    indent_down()

    if v['nl_end'] > 0:
        out("\n" * v['nl_end'])
        indent()

    out("}")



def print_value_literal_str(x, ctx):
    out("\"")
    for c in x['imm']:
        sym = chr(c['imm'])
        if sym == '\n': out("\\n")
        elif sym == '\r': out("\\r")
        elif sym == '\a': out("\\a")
        else: out(sym)
    out("\"")



def print_value_literal_char(x, ctx):
    num = x['imm']
    if num >= 0x20:
        out("\"%s\"[0]" % num)
    elif num == 0:
        out("\"\\x%x\"[0]" % num)
    else:
        out("\"\\x%x\"[0]" % num)


def print_value_literal_int(x, ctx):
    num = x['imm']

    if value_attribute_check(x, 'hexadecimal'):

        nsigns = 0
        if 'nsigns' in x:
            nsigns = x['nsigns']

        fmt = "0x%%0%dX" % nsigns
        out(fmt % num)

    elif type.is_pointer(x['type']):
        if num == 0:
            out("nil")
            return

    else:
        out(str(num))


def print_value_literal_flt(x, ctx):
    out(str(float(x['imm'])))


def print_value_zero(x, ctx):
    t = x['type']
    if type.is_array(t): out("[]")
    elif type.is_record(t): out("{}")
    else: out("0")


def print_value_enum(x, ctx):
    out("%s" % (x['id']['str']))


def print_value_by_id(x, ctx):
    out("%s" % x['id']['str'])


def print_value_let(x, ctx):
    return print_value(x['value'])



def print_value_literal(x, ctx):
    t = x['type']
    if type.is_integer(t): print_value_literal_int(x, ctx)
    elif type.is_float(t): print_value_literal_flt(x, ctx)
    elif type.is_record(t): print_value_literal_record(x, ctx)
    elif type.is_array(t): print_value_literal_arr(x, ctx)
    #elif type.is_string(t): print_value_literal_str(x, ctx)
    elif type.is_free_pointer(t): out("nil")
    elif type.is_pointer(t): print_value_literal_int(x, ctx)
    elif type.is_bool(t): print_value_literal_int(x, ctx)
    elif type.is_char(t): print_value_literal_char(x, ctx)


def print_value(x, ctx=[], need_wrap=False, print_just_id=True):
    # если у значения есть свойство 'id' то печатаем просто id
    # (используется для печати имени констант а не просто их значения)
    # в LLVM перчаем просто значение

    if print_just_id:
        if 'id' in x:
            print_value_by_id(x, ctx)
            return

    if need_wrap:
        out("(")

    k = x['kind']

    if k == 'literal': print_value_literal(x, ctx)
    elif k in bin_ops: print_value_bin(x, ctx)
    elif k in un_ops: print_value_un(x, ctx)
    elif k == 'const': print_value_let(x, ctx)
    elif k in ['func', 'var']: print_value_by_id(x, ctx)
    elif k == 'call': print_value_call(x, ctx)
    elif k == 'index': print_value_index(x, ctx)
    elif k == 'index_ptr': print_value_index_ptr(x, ctx)
    elif k == 'access': print_value_access(x, ctx)
    elif k == 'access_ptr': print_value_access_ptr(x, ctx)
    elif k == 'cast_generic': print_value_cast_generic(x, ctx)
    elif k == 'cast': print_value_cast(x, ctx)
    elif k == 'sizeof': out("sizeof("); print_type(x['of']); out(")")
    else: out("<%s>" % k)

    if need_wrap:
        out(")")



def print_stmt_if(x):
    out("if ")
    print_value(x['cond'])
    print_stmt_block(x['then'])

    e = x['else']
    if e != None:
        if e['kind'] == 'if':
            out(" else ")
            print_stmt_if(e)
        else:
            out(" else")
            print_stmt_block(e)



def print_stmt_while(x):
    out("while ")
    print_value(x['cond'])
    print_stmt_block(x['stmt'])


def print_stmt_return(x):
    out("return")
    if x['value'] != None:
        out(" ")
        print_value(x['value'])


def print_stmt_defvar(x):
    out('var ')
    print_field(x['var'])

    init_value = x['var']['init']
    if init_value != None:
        out(" := ")
        print_value(init_value)


def print_stmt_let(x):
    out("let %s = " % x['id']['str'])
    print_value(x['value'], print_just_id=False)


def print_stmt_assign(x):
    print_value(x['left'])
    out(" := ")
    print_value(x['right'])



def print_stmt_value(x):
    print_value(x['value'])


def print_stmt(x):

    out("\n" * x['nl'])

    k = x['kind']
    if k == 'block': indent(); print_stmt_block(x)
    elif k == 'value': indent(); print_stmt_value(x)
    elif k == 'assign': indent(); print_stmt_assign(x)
    elif k == 'return': indent(); print_stmt_return(x)
    elif k == 'if': indent(); print_stmt_if(x)
    elif k == 'while': indent(); print_stmt_while(x)
    elif k == 'def_var': indent(); print_stmt_defvar(x)
    elif k == 'let': indent(); print_stmt_let(x)
    elif k == 'break': indent(); out('break')
    elif k == 'again': indent(); out('continue')
    elif k == 'comment-line': print_comment_line(x)
    elif k == 'comment-block': print_comment_block(x)
    else: out("<stmt %s>" % str(x))



def print_stmt_block(s):
    out(" {")

    indent_up()

    for stmt in s['stmts']:
        print_stmt(stmt)

    indent_down()

    endnl = s['end_nl']
    out("\n" * endnl)
    if endnl:
        indent()
    out("}")



def print_decl_func(x):
    func = x['value']
    if 'extern' in func['att']:
        out("extern ")
    out('func %s ' % func['id']['str'])
    print_type(func['type'])


def print_def_func(x):
    func = x['value']
    out('func %s ' % func['id']['str']); print_type(func['type'])
    print_stmt_block(func['stmt'])


def print_decl_type(x):
    out("type %s" % x['type']['id']['str'])


def print_def_type(x):
    out("type %s " % x['type']['name'])
    print_type(x['type'], print_aka=False)




def print_def_var(x):
    out("var ")
    var = x['value']
    print_field(var)
    iv = var['init']
    if iv != None:
        out(" := "); print_value(iv)


def print_def_const(x):
    v = x['value']

    out("const %s = " % v['id']['str'])

    # если есть оригинальное выражение, внутри, печатаем его
    if 'value' in v:
        v = v['value']

    print_value(v, ctx=['oneline'], print_just_id=False)


def print_import(x):
    s = x['str']
    out("import \"%s\"" % (s))



def run(module, outname):
    from main import features
    is_header = features.get('header')

    if is_header: outname = outname + '.hm'
    else: outname = outname + '.cm'

    output_open(outname)


    for x in module['text']:

        if 'nl' in x:
            out("\n" * x['nl'])

        isa = x['isa']


        if isa == 'def_var': print_def_var(x)
        elif isa == 'def_const': print_def_const(x)
        elif isa == 'def_func': print_def_func(x)
        elif isa == 'def_type': print_def_type(x)

        elif isa == 'decl_func': print_decl_func(x)
        elif isa == 'decl_type': print_decl_type(x)

        elif isa == 'directive':
            if x['kind'] == 'import': print_import(x)

        elif isa == 'comment':
            print_comment(x)

    out("\n\n")

    output_close()



