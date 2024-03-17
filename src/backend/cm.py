
import hlir.type as hlir_type
from error import info
from .common import *
from value.value import value_is_zero, value_attribute_check, value_print
from util import get_item_with_id


INDENT_SYMBOL = " " * 4


def init():
    pass


def newline(n=1):
    nl_str = '\n'
    out(nl_str * n)


def indent():
    ind(INDENT_SYMBOL)


def nl_indent(nl=1):
    newline(nl)
    if nl > 0:
        indent()


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
    ['plus', 'minus', 'not', 'cast', 'cast_immediate', 'ref', 'deref', 'sizeof', 'alignof', 'offsetof', 'lengthof'], #10
    ['call', 'index', 'access'], #11
    ['num', 'var', 'func', 'str', 'enum', 'record', 'array'] #12
]

precedenceMax = len(aprecedence) - 1

# приоритет операции
def precedence(x):
    k = x['kind']

    # cast generic не является 'оператором'
    # его приоритет, это приоритет его содержимого (value)
    if k == 'cast_immediate':
        return precedence(x['value'])

    i = 0
    while i < precedenceMax + 1:
        if k in aprecedence[i]:
            break
        i = i + 1

    return i



def print_id(x):
    out(x['id']['str'])


def print_comment(x):
    k = x['kind']
    if k == 'line': print_comment_line(x)
    elif k == 'block': print_comment_block(x)


def print_comment_block(x):
    nl_indent(x['nl'])
    out("/*%s*/" % x['text'])


def print_comment_line(x):
    newline(x['nl'])
    lines = x['lines']
    i = 0
    n = len(lines)
    while i < n:
        line = lines[i]
        indent()
        out("//%s" % line['str'])
        i = i + 1
        if i < n:
            newline()



def print_type_integer(t):
    print_type_id(t)


def print_type_array(t):
    out("[")
    if t['volume'] != None:
        print_value(t['volume'])
    out("]")
    print_type(t['of'])


def print_type_pointer(t):
    if hlir_type.type_is_free_pointer(t):
        out("Pointer")
    else:
        out("*"); print_type(t['to'])




def print_field(x):
    print_id(x)
    out(": ")
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

    prev_nl = 1
    for field in t['fields']:

        if prev_nl == 0:
            out(", ")

        # print comments
        if 'comments' in field:
            for comment in field['comments']:
                newline(comment['nl'])
                print_comment(comment)

        nl_indent(field['nl'])
        prev_nl = field['nl']

        print_field(field)

    indent_down()
    nl_indent(t['end_nl'])
    out("}")



def print_type_enum(t):
    out("enum {")
    items = t['items']
    i = 0
    while i < len(items):
        item = items[i]
        out("\n\t")
        print_id(item)
        i = i + 1
    out("\n}")



def print_type_func(t, extra_args=False):
    out('(')
    print_fields(t['params'], before="", after="", separator=", ")
    if extra_args:
        out(", va_list: VA_List")
    out(') -> ')
    print_type(t['to'])


def print_type_id(t):
    if t['definition'] != None:
        out(t['definition']['id']['str'])
        return True

    elif t['declaration'] != None:
        out(t['declaration']['id']['str'])
        return True

    return False


def print_type(t):
    k = t['kind']

    res = print_type_id(t)
    if res: return

    if hlir_type.type_is_integer(t): print_type_integer(t)
    elif hlir_type.type_is_func(t): print_type_func(t)
    elif hlir_type.type_is_array(t): print_type_array(t)
    elif hlir_type.type_is_record(t): print_type_record(t)
    elif hlir_type.type_is_enum(t): print_type_enum(t)
    elif hlir_type.type_is_pointer(t): print_type_pointer(t)
    elif k == 'opaque': pass
    else: out("<type:" + str(t) + ">")



bin_ops = {
    'or': 'or', 'xor': 'xor', 'and': 'and', 'shl': '<<', 'shr': '>>',
    'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
    'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'rem': '%',
    'logic_and': 'and', 'logic_or': 'or',
    'add_str': '+', 'eq_str': '==', 'ne_str': '!='
}

def print_value_bin(x, ctx):
    op = x['kind']
    left = x['left']
    right = x['right']

    # получаем приоритеты операции и операндов
    p0 = precedence(x)
    pl = precedence(left)
    pr = precedence(right)
    need_wrap_left = pl < p0
    need_wrap_right = pr < p0

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
    p0 = precedence({'kind': op})
    pv = precedence(value)
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
    need_wrap = precedence(array) < precedence({'kind': 'index'})
    print_value(array, need_wrap=need_wrap)
    out("["); print_value(index); out("]")


def print_value_index_ptr(v, ctx):
    array = v['pointer']
    index = v['index']
    need_wrap = precedence(array) < precedence({'kind': 'index'})
    print_value(array, need_wrap=need_wrap)
    out("["); print_value(index); out("]")


def print_value_access(v, ctx):
    left = v['record']
    need_wrap = precedence(left) < precedence({'kind': 'access'})
    print_value(left, need_wrap=need_wrap)
    out(".")
    print_id(v['field'])


def print_value_access_ptr(v, ctx):
    left = v['pointer']
    need_wrap = precedence(left) < precedence({'kind': 'access'})
    print_value(left, need_wrap=need_wrap)
    out(".")
    print_id(v['field'])


def print_cast(t, v, ctx=[]):
    need_wrap = precedence(v) < precedence({'kind': 'cast'})
    print_type(t)
    out(" ")
    print_value(v, ctx=ctx, need_wrap=need_wrap)

    """print_value(v, ctx=ctx, need_wrap=need_wrap)
    out(' to ')
    print_type(t)"""



def print_value_cast_immediate(x, ctx):

    if 'explicit_cast' in x['att']:
        print_cast(x['type'], x['value'], ctx=[])
        return

    # imm каст не печатаю, печатаю просто значение
    need_wrap = precedence(x['value']) < precedenceMax
    print_value(x['value'], ctx, need_wrap=need_wrap)
    return


def print_value_cast(v, ctx):
    value = v['value']
    from_type = value['type']
    to_type = v['type']


    if not 'explicit_cast' in v['att']:
        print_value(value)
        return


    # NO need cast ptr to *void
    if hlir_type.type_is_pointer(from_type):
        if hlir_type.type_is_free_pointer(to_type):
            print_value(v['value'])
            return

    # NO need cast *void to ptr
    if hlir_type.type_is_free_pointer(from_type):
        if hlir_type.type_is_pointer(to_type):
            print_value(v['value'])
            return

    print_cast(v['type'], v['value'], ctx)




def is_zero_tail(values, i, n):
    # если это значание - zero, проверим все остальные справа
    # и если они тоже zero - их можно не печатать (zero tail)
    # ex: {'a', 'b', '\0', '\0', '\0'} -> {'a', 'b', '\0'}
    while i < n:
        v = values[i]
        if not value_is_zero(v):
            return False
        i = i + 1
    return True


def print_value_array(v, ctx):

    # FIXIT: это вообще херня
    if hlir_type.type_is_array_of_char(v['type']):
        print_value_array_str(v, ctx=[])
        return

    out("[")
    indent_up()
    #print_values(v['asset'], before=nl_indentation(INDENT_SYMBOL), after="", separator="")

    values = v['asset']
    i = 0
    n = len(values)
    while i < n:
        a = values[i]

        if value_is_zero(a):
            if is_zero_tail(values, i, n):
                break

        nl = 0
        if 'nl' in a:
            nl = a['nl']

        if nl > 0:
            newline(nl)
            indent()
        else:
            if i > 0:
                out(', ')

        print_value(a, ctx=ctx)

        i = i + 1




    indent_down()

    if v['nl_end'] > 0:
        newline(v['nl_end'])
        indent()

    out("]")



def print_value_record(v, ctx):
    multiline = not 'oneline' in ctx

    out("{")

    indent_up()

    initializers = v['asset']
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
            newline(nl)
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
        newline(v['nl_end'])
        indent()

    out("}")



def code_to_char(cc):
    if cc < 0x20:
        if cc == 0x07: return "\\a" # bell
        elif cc == 0x08: return "\\b" # backspace
        elif cc == 0x09: return "\\t" # horizontal tab
        elif cc == 0x0A: return "\\n" # line feed
        elif cc == 0x0B: return "\\v" # vertical tab
        elif cc == 0x0C: return "\\f" # form feed
        elif cc == 0x0D: return "\\r" # carriage return
        elif cc == 0x1B: return "\\e" # escape
        else: return "\\x%X" % cc

    elif cc <= 0x7E :
        sym = chr(cc)
        if sym == '\\': return '\\\\'
        elif sym == '"': return '\\"'
        else: return sym

    elif cc != 0:
        return chr(cc)


# FIXIT: это вообще херня
def print_value_array_str(x, ctx):
    out("\"")
    asset = x['asset']
    i = 0
    while i < len(x['asset']):
        char_value = asset[i]

        cc = char_value['asset']

        # if cc is '0' - go to the end of string
        # and check if there is something (non-zero)
        # if not - just end string,
        # else - continue and print next
        if cc == 0:
            i_befor = i
            while i < len(x['asset']):
                _cc = asset[i]
                if _cc != 0:
                    i = i_befor
                    break
                i = i + 1
            out("\"")
            return

        out(code_to_char(cc))

        i = i + 1

    out("\"")



def print_value_bool(x, ctx):
    if x['asset'] != 0:
        out('true')
    else:
        out('false')


def print_value_char(x, ctx):
    num = x['asset']
    if num >= 0x20:
        out("\"%s\"[0]" % chr(num))
    elif num == 0:
        out("\"\\x%x\"[0]" % num)
    else:
        out("\"\\x%x\"[0]" % num)



def print_value_integer(x, ctx):
    num = x['asset']

    nsigns = 0
    if 'nsigns' in x:
        nsigns = x['nsigns']

    spec = 'd'
    pre = ''
    if value_attribute_check(x, 'hexadecimal'):
        spec = 'X'
        pre = '0x'

    fmt = "%s%%0%d%s" % (pre, nsigns, spec)
    out(fmt % num)



def print_value_float(x, ctx):
    out('{0:f}'.format(x['asset']))


def print_value_ptr(x, ctx):
    if x['asset'] == 0:
        out("nil")
    else:
        out("(0x%08X" % x['asset'])
        out(" to ")
        print_type(x['type'])
        out(")")


def print_value_zero(x, ctx):
    t = x['type']
    if hlir_type.type_is_array(t): out("[]")
    elif hlir_type.type_is_record(t): out("{}")
    else: out("0")


def print_value_enum(x, ctx):
    print_id(x)


def print_value_by_id(x, ctx):
    print_id(x)


def print_value_let(x, ctx):
    print_id(x)



def print_value_literal(x, ctx):
    t = x['type']
    if hlir_type.type_is_integer(t): print_value_integer(x, ctx)
    elif hlir_type.type_is_float(t): print_value_float(x, ctx)
    elif hlir_type.type_is_record(t): print_value_record(x, ctx)
    elif hlir_type.type_is_array(t): print_value_array(x, ctx)
    elif hlir_type.type_is_pointer(t): print_value_ptr(x, ctx)
    elif hlir_type.type_is_bool(t): print_value_bool(x, ctx)
    elif hlir_type.type_is_char(t): print_value_char(x, ctx)
    elif hlir_type.type_is_enum(t): print_value_integer(x, ctx)
    elif hlir_type.type_is_byte(t): print_value_integer(x, ctx)



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
    elif k == 'cast_immediate': print_value_cast_immediate(x, ctx)
    elif k == 'cast': print_value_cast(x, ctx)
    elif k == 'sizeof': out("sizeof("); print_type(x['of']); out(")")
    elif k == 'alignof': out("alignof("); print_type(x['of']); out(")")
    elif k == 'offsetof': out("offsetof("); print_type(x['of']); out('.%s' % x['field']['str']); out(")")
    elif k == 'lengthof': out("lengthof("); print_value(x['of_value']); out(")")
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
    init_value = x['default_value']
    out('var ')

    if init_value == None:
        print_field(x['var'])
        return

    if init_value['kind'] == 'cast':
        print_id(x['var'])
    else:
        print_field(x['var'])

    if init_value != None:
        out(" = ")
        print_value(init_value)


def print_stmt_let(x):
    out("let ")
    print_id(x)
    out(" = ")
    print_value(x['init_value'], print_just_id=False)


def print_stmt_assign(x):
    print_value(x['left'])
    out(" = ")
    print_value(x['right'])


def print_stmt_value(x):
    print_value(x['value'])


def print_stmt_break(x):
    out("break")


def print_stmt_again(x):
    out("again")


def print_stmt(x):
    k = x['kind']

    if not k in ['block', 'comment-line', 'comment-block']:
        nl_indent(x['nl'])

    if k == 'block': print_stmt_block(x)
    elif k == 'value': print_stmt_value(x)
    elif k == 'assign': print_stmt_assign(x)
    elif k == 'return': print_stmt_return(x)
    elif k == 'if': print_stmt_if(x)
    elif k == 'while': print_stmt_while(x)
    elif k == 'def_var': print_stmt_defvar(x)
    elif k == 'let': print_stmt_let(x)
    elif k == 'break': print_stmt_break(x)
    elif k == 'again': print_stmt_again(x)
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
    newline(endnl)
    if endnl:
        indent()
    out("}")



def print_decl_func(x):
    func = x['value']
    #if 'extern' in func['att']:
    #    out("extern ")
    out('func ')
    print_id(func)
    print_type(func['type'])


def print_def_func(x):
    func = x['value']
    ft = func['type']
    out('func ')
    print_id(func)
    print_type_func(ft, extra_args=ft['extra_args'])
    print_stmt_block(func['stmt'])


def print_decl_type(x):
    out("type ")
    #print_id(x['type'])
    print_type(x['type'])

def print_def_type(x):
    out("type ")
    print_id(x)
    out(" ")
    print_type(x['original_type'])


def print_def_var(x):
    out("var ")
    var = x['value']
    print_field(var)
    iv = x['default_value']
    if iv != None:
        out(" = ")
        print_value(iv)


def print_def_const(x):
    out("const ")
    print_id(x)
    out(" = ")
    print_value(x['init_value'], ctx=['oneline'], print_just_id=False)


def print_import(x):
    s = x['str']
    if 'c-no-print' in x['att']:
        out("@attribute(\"c-no-print\")\n")
    out("import \"%s\"" % s)


def print_directive(x):
    if x['kind'] == 'import': print_import(x)
    elif x['kind'] == 'c_include': out("@c_include \"%s\"" % x['c_name'])


def run(module, outname):
    from main import features
    is_header = features.get('header')

    if is_header: outname = outname + '.hm'
    else: outname = outname + '.cm'

    output_open(outname)


    for x in module['text']:
        isa = x['isa']

        if isa != 'comment':
            newline(n=x['nl'])

        if isa == 'def_var': print_def_var(x)
        elif isa == 'def_const': print_def_const(x)
        elif isa == 'def_func': print_def_func(x)
        elif isa == 'def_type': print_def_type(x)
        elif isa == 'decl_func': print_decl_func(x)
        elif isa == 'decl_type': print_decl_type(x)
        elif isa == 'directive': print_directive(x)
        elif isa == 'comment': print_comment(x)

    out("\n\n")

    output_close()



