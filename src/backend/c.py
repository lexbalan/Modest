#Есть проблема с массивом generic int когда индексируешь и приводишь к инту
#но индексируешь переменной (в цикле например)


from error import info, error, fatal
from .common import *
import type
from type import type_print
from value.value import value_attribute_check, value_is_zero, value_print, value_is_immediate_integer
from util import nbits_for_num, get_item_with_id, utf8_cc_arr_to_utf32_cc_arr, utf16_cc_arr_to_utf32_cc_arr
from main import settings

INDENT_SYMBOL = " " * 4

FUNC_EMPTY_PARAMLIST = "(void)"

NO_TYPEDEF_STRUCTS = False
NO_TYPEDEF_OTHERS = False

USE_BOOLEAN = True
USE_STDBOOL = True

USE_STATIC_VARIABLES = True


# for integer literals printing
CC_INT_SIZE_BITS = 32
CC_LONG_SIZE_BITS = 32
CC_LONG_LONG_SIZE_BITS = 64


legacy_style = {
    'LINE_BREAK_BEFORE_STRUCT_BRACE': False,
    'LINE_BREAK_BEFORE_FUNC_BRACE': True,
    'LINE_BREAK_BEFORE_BLOCK_BRACE': False,
}

modern_style = {
    'LINE_BREAK_BEFORE_STRUCT_BRACE': True,
    'LINE_BREAK_BEFORE_FUNC_BRACE': True,
    'LINE_BREAK_BEFORE_BLOCK_BRACE': True,
}

styles = {
    'legacy': legacy_style,
    'modern': modern_style,

    'KnR': legacy_style,
    'kernel': legacy_style,
    'allman': modern_style,
}

styleguide = styles['legacy']


nl_str = "\n"


def newline(n=1):
    out(nl_str * n)


def indent():
    ind(INDENT_SYMBOL)


def indent_if(x):
    if x: indent()


def nl_indent():
    newline()
    indent()



def init():
    global styleguide
    stylename = settings.get('style')
    if stylename != None:
        if stylename in styles:
            styleguide = styles[stylename]

    global CC_INT_SIZE_BITS, CC_LONG_SIZE_BITS, CC_LONG_LONG_SIZE_BITS
    CC_INT_SIZE_BITS = 32
    CC_LONG_SIZE_BITS = 32
    CC_LONG_LONG_SIZE_BITS = 64



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
    ['plus', 'minus', 'not', 'cast', 'cast_immediate', 'ref', 'deref', 'sizeof', 'alignof', 'offsetof'], #10
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



def print_type_numeric(t):
    if 'c_alias' in t:
        out(t['c_alias'])
        return

    out(t['id']['str'])



def print_type_array(t, print_as_pointer, need_space_after):
    print_type(t['of'], need_space_after=True)

    if print_as_pointer:
        if 'const' in t['att']:
            out("*const")
            if need_space_after:
                out(" ")
        else:
            out("*")
        return


    if t['volume'] != None:
        out("["); print_value(t['volume']); out("]")
    else:
        out("*")



def print_type_pointer(t, need_space_after):
    # array was printed as *, we dont need to place another *
    if type.is_array(t['to']):
        print_type(t['to']['of'], need_space_after=True)
        if 'const' in t['att']:
            out("*const")
            if need_space_after:
                out(" ")
        else:
            out("*")
        return

    if type.is_free_pointer(t):
        out("void ")

    else:
        print_type(t['to'], need_space_after=True)

    if 'const' in t['att']:
        out("*const")
        if need_space_after:
            out(" ")

    else:
        out("*")



def print_type_record(t, tag=""):
    out("struct")

    if tag != "":
        out(" %s" % tag)

    if styleguide['LINE_BREAK_BEFORE_STRUCT_BRACE']:
        newline()
    else:
        out(" ")

    out("{")
    indent_up()

    for field in t['fields']:
        if 'comments' in field:
            for comment in field['comments']:
                newline(n=comment['nl'])
                print_comment(comment)

        newline(n=field['nl'])
        indent();
        print_field(field)
        out(";")

    indent_down()
    nl_indent()
    out("}")



def print_type_enum(t):
    out("enum {")
    items = t['items']
    i = 0
    while i < len(items):
        item = items[i]
        newline()
        out("\t%s," % (item['id']['str']))
        i = i + 1
    newline()
    out("}")


def print_array_asis(t):
    print_type(t['of'], need_space_after=True)
    out("[")
    print_value(t['volume'])

    out("]")


# Возвращает False если НЕ нужно отделять пробелом после типа
# (только указатели *)
# блядские аргументы по умолчанию - нихера с ними не работает!
def print_type(t, need_space_after, _print_array_asis=False):
    rc = print_type2(t, print_aka=True, need_space_after=need_space_after, _print_array_asis=_print_array_asis)


def print_type_full(t, _print_array_asis=False):
    return print_type2(t, print_aka=False, need_space_after=False, _print_array_asis=_print_array_asis)


def print_type2(t, print_aka, need_space_after, _print_array_asis):
    k = t['kind']

    if 'const' in t['att']:
        if not type.is_pointer(t):
            out("const ")

    if NO_TYPEDEF_OTHERS:
        if type.is_alias(t):
            tt = t['aliasof']
            if not type.is_record(tt):
                print_type2(t['aliasof'], print_aka=True, need_space_after=need_space_after)

    if USE_BOOLEAN:
        if type.is_bool(t):
            out("bool")
            if need_space_after:
                out(" ")
            return

    # hotfix for let generic value problem (let x = 1)
    if type.is_generic_integer(t):
        # если пришел generic - подберем подходящий тип
        # ex: let x = 1; func(x)
        power = t['power']
        nt = type.select_numeric(power, is_signed=type.is_signed(t))
        if nt == None:
            error("cannot select integer type for too big value", t['ti'])
            return
        else:
            t = nt


    if print_aka:
        if 'c_alias' in t:
            out(t['c_alias'])
            if need_space_after:
                out(" ")
            return

        if 'id' in t:
            if NO_TYPEDEF_STRUCTS:
                if type.is_record(t):
                    out("struct ")
            out(t['id']['str'])
            if need_space_after:
                out(" ")
            return

    if type.is_numeric(t):
        print_type_numeric(t)
        if need_space_after:
            out(" ")

    elif type.is_record(t):
        print_type_record(t)
        if need_space_after:
            out(" ")

    #elif type.is_enum(t): print_type_enum(t, need_space_after)
    elif type.is_pointer(t):
        print_type_pointer(t, need_space_after)

    elif type.is_array(t):
        if _print_array_asis:
            print_array_asis(t)
            return
        print_type_array(t, print_as_pointer=True, need_space_after=need_space_after)

    elif type.is_func(t):
        out("void")
        if need_space_after:
            out(" ")

    elif k == 'opaque':
        out("void")
        if need_space_after:
            out(" ")

    else: out("<type:" + str(t) + ">")




bin_ops = {
    'or': '|', 'xor': '^', 'and': '&', 'shl': '<<', 'shr': '>>',
    'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
    'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'rem': '%',
    'logic_and': '&&', 'logic_or': '||',
    'add_str': '', 'eq_str': '', 'ne_str': ''
}


def print_value_bin(v, ctx):
    op = v['kind']
    left = v['left']
    right = v['right']

    # получаем приоритеты операции и операндов
    p0 = precedence(v)
    pl = precedence(left)
    pr = precedence(right)
    need_wrap_left = pl < p0
    need_wrap_right = pr < p0

    # GCC выдает warning например в: 1 << 2 + 2, тк считает
    # Что юзер имел в виду (1 << 2) + 2, а у << приоритет тние
    # чтобы он не ругался, завернем такие выражения в скобки

    if op in ['shl', 'shr']:
        need_wrap_left = precedence(left) < 10 #precedenceMax
        need_wrap_right = precedence(right) < 10 #precedenceMax
    elif op == 'logic_or':
        if left['kind'] != 'logic_or':
            need_wrap_left = precedence(left) < 10 #precedenceMax
        if right['kind'] != 'logic_or':
            need_wrap_right = precedence(right) < 10 #precedenceMax
    elif op == 'logic_and':
        if left['kind'] != 'logic_and':
            need_wrap_left = precedence(left) < 10 #precedenceMax
        if right['kind'] != 'logic_and':
            need_wrap_right = precedence(right) < 10 #precedenceMax
    elif op in ['eq_str', 'ne_str']:
        print_value_literal_int(v, ctx)
        return

    print_value(left, need_wrap=need_wrap_left)
    out(' %s ' % bin_ops[op])
    print_value(right, need_wrap=need_wrap_right)



un_ops = {
    'ref': '&', 'deref': '*',
    'plus': '+', 'minus': '-',
    'not': '~', 'logic_not': '!'
}


def print_value_un(v, ctx):
    op = v['kind']
    value = v['value']

    p0 = precedence(v)
    pv = precedence(value)

    if op == 'not':
        if type.eq(value['type'], type.typeBool):
            op = 'logic_not'

    out(un_ops[op]); print_value(value, need_wrap=pv<p0)

    # указатель на массив в сях берем как &array[0]
    # поскольку у нас указатель на массив сейчас печатается как *<item_type>
    # а &array дает нам *array[n]
    if v['kind'] == 'ref':
        if value['type']['kind'] == 'array':
            out("[0]")




def print_fields(fields, before, after, between):
    i = 0
    n = len(fields)
    while i < n:
        param = fields[i]
        out(before)
        print_field(param)
        out(after)
        i = i + 1
        if i < n: out(between)


def print_paramlist(parms, arghack=False):
    if len(parms) == 0:
        out(FUNC_EMPTY_PARAMLIST)

    else:
        out("(")
        print_fields(parms, before="", after="", between=", ")
        if arghack:
            out(", ...")
        out(")")




def print_value_call(v, ctx):
    left = v['func']
    ftype = left['type']

    if type.is_pointer(left['type']):
        ftype = left['type']['to']

        # вызов через указатель
        # поскольку у нас указатели на функции это *void
        # при вызове приводим левое к указателю на функцию
        out("(("); print_type(ftype['to'], need_space_after=False); out("(*)")
        arghack = 'arghack' in ftype['att']
        print_paramlist(ftype['params'], arghack)
        out(")")
        print_value(left)
        out(")")

    else:
        print_value(left)

    params = ftype['params']

    out("(")
    values = v['args']
    i = 0
    n = len(values)
    while i < n:
        a = values[i]

        try:
            # если тип аргумента отличается модификатором (const, volatile)
            # то явно приведем его к типу параметра, чтобы C не ругался
            # (try: проверяем только те аргументы, для которых есть параметры)
            p = params[i]
            if not type.eq(p['type'], a['type'], opt=['att_checking']):
                out("("); print_type(p['type'], need_space_after=False); out(")")
        except:
            pass


        print_value(a, ctx=ctx)
        i = i + 1
        if i < n:
            out(", ")

    out(")")



def print_value_index(v, ctx):
    array = v['array']
    index = v['index']
    need_wrap = precedence(array) < precedence(v)
    print_value(array, need_wrap=need_wrap)
    out("["); print_value(index); out("]")


def print_value_index_ptr(v, ctx):
    ptr2array = v['pointer']
    index = v['index']
    need_wrap = precedence(ptr2array) < precedence(v)
    print_value(ptr2array, need_wrap=need_wrap)
    out("["); print_value(index); out("]")


def print_value_access(v, ctx):
    left = v['record']
    need_wrap = precedence(left) < precedence(v)
    print_value(left, need_wrap=need_wrap); out('.'); out(v['field']['id']['str'])


def print_value_access_ptr(v, ctx):
    left = v['pointer']
    need_wrap = precedence(left) < precedence(v)
    print_value(left, need_wrap=need_wrap); out("->"); out(v['field']['id']['str'])




def print_cast(t, v, ctx=[]):
    from_type = v['type']
    to_type = t

    out("("); print_type(to_type, need_space_after=False); out(")")
    need_wrap = precedence(v) < precedence({'kind': 'cast'})
    print_value(v, ctx=ctx, need_wrap=need_wrap)



def print_value_cast_immediate(v, ctx):
    value = v['value']
    from_type = value['type']
    to_type = v['type']

    #out("/*^*/")

    if type.is_ptr_to_string(to_type):
        if type.is_string(from_type):
            char_power = to_type['to']['of']['power']
            print_value_literal_str(v, ctx=[], char_power=char_power)
            return

    # GenericChar -> vast_immediate -> Char
    elif type.is_char(to_type):
        if type.is_char(from_type):
            print_value_literal_char(v, ctx)
            return


    """if 'explicit_cast' in v['att']:
        # литералы явно не приводим
        if value['kind'] != 'literal':
            print_cast(to_type, value, ctx)
            return"""

    # implicit_cast of immediate value
    #need_wrap = precedence(value) < precedenceMax
    print_value(value, ctx)#, need_wrap=need_wrap)



def print_value_cast(x, ctx):
    to_type = x['type']
    value = x['value']
    from_type = value['type']

    # в у нас типы структурные, в си - номинальные
    # поэтому даже если структуры одинаковы, но имена разные
    # их нужно приводить

    # cast pointer to struct to pointer to another struct
    if type.is_pointer_to_record(from_type):
        if type.is_pointer_to_record(to_type):
            print_cast(to_type, value, ctx)
            return

    # cast struct to another struct
    if type.is_record(to_type):
        if type.is_record(from_type):
            # *((RecordType *)&value)
            out("*((")
            print_type(to_type, need_space_after=False)
            out(" *)&")
            print_value(value, [], need_wrap=True)
            out(")")
            return


    if type.is_va_list(from_type):
        #rv = do_eval(value)
        #return llvm_va_arg(rv, to_type)
        out("va_arg(__vargs")

        #print_value(value, [], need_wrap=False)
        out(", ")
        print_type(to_type, need_space_after=False)
        out(")")
        return


    #if not 'explicit_cast' in x['att']:
    #if value_is_immediate_integer(value):
    if value['kind'] == 'literal':
        print_value(value)
        return


    # (!) because
    # - in Cm int32(-1) -> uint64 => 0x00000000ffffffff
    # - in C  int32(-1) -> uint64 => 0xffffffffffffffff
    # required: (uint64_t)((uint32)int32_value)
    if type.is_unsigned(to_type):
        #if type.is_signed(from_type): # is_signed (integers, chars)
        if from_type['size'] < to_type['size']:
            out("((")
            print_type(to_type, need_space_after=False)
            out(")")
            #out("/*?*/")
            nat_same_sz = type.select_nat(from_type['power'])
            print_cast(nat_same_sz, value, ctx)
            out(")")
            return


    print_cast(to_type, value, ctx)





def print_value_literal_arr(v, ctx):

    if type.is_generic_string(v['type']):
        char_power = v['type']['of']['power']
        # FIXIT: вообще нефиг печатать generic string (!)
        out('{} /*GENERIC-STRING*/')
        return


    #if not 'no-cast-literal-array' in v['att']:
    #if do_cast:
    if not 'no-literal-array-cast' in ctx:
        out("(")
        print_type(v['type'], need_space_after=False, _print_array_asis=True)
        out(")")

    out("{")
    indent_up()

    values = v['imm']

    if values == None:
        out("{0}")
        return

    i = 0
    n = len(values)
    while i < n:
        a = None
        try:
            a = values[i]
        except:
            print("N = " + str(n))
            value_print(v)
            print(values)

        nl = 0
        if 'nl' in a:
            nl = a['nl']


        if nl > 0:
            newline(n=nl)
            indent()
        else:
            if i > 0:
                out(" ")

        print_value(a, ctx=ctx)

        i = i + 1
        if i < n:
            out(',')


    indent_down()

    if v['nl_end'] > 0:
        newline(n=v['nl_end'])
        indent()

    out("}")

    #if cast_req:
    #    out(")")



def print_value_literal_record(v, ctx):
    out("(")
    print_type(v['type'], need_space_after=False)
    out(")")

    out("{")
    indent_up()

    initializers = v['imm']

    if initializers == None:
        out("{0}")
        return

    nitems = len(initializers)
    i = 0

    # for situation when firat item is value_zero
    # without it, forst value will be printed with space before it.
    item_printed = False

    while i < nitems:
        item = v['type']['fields'][i]
        field_id_str = item['id']['str']

        ini = get_item_with_id(initializers, field_id_str)

        if value_is_zero(ini['value']):
            i = i + 1
            continue

        nl = 0
        if 'nl' in ini:
            nl = ini['nl']

        if nl > 0:
            newline(n=nl)
            indent()
        else:
            if item_printed:
                out(" ")

        out(".%s = " % field_id_str)

        # 'no-literal-array-cast' - когда прописываем инициализаторы
        # литерал массива не нужно приводить к типу массива
        # тк C это не умеет:
        # .arr = (uint8_t [3]){1, 2, 3}  // not worked
        # .arr = {1, 2, 3}  // worked
        # вот такая вот херня
        print_value(ini['value'], ctx + ['no-literal-array-cast'])
        if i < (nitems - 1):
            out(",")

        item_printed = True
        i = i + 1

    indent_down()

    if v['nl_end'] > 0:
        newline(n=v['nl_end'])
        indent()

    out("}")

    #if cast_req:
    #    out(")")



def print_value_literal_str(x, ctx, char_power=8):

    prefix = ""
    utf8_codes = None
    if char_power == 8:
        prefix = "" #"u8"
        utf8_codes = utf8_cc_arr_to_utf32_cc_arr(x['imm'])
    elif char_power == 16:
        prefix = "u"
        utf8_codes = utf16_cc_arr_to_utf32_cc_arr(x['imm'])
    elif char_power == 32:
        prefix = "U"
        utf8_codes = x['imm']


    out("%s\"" % prefix)

    for cc in utf8_codes:
        if cc == 0:
            break

        sym = chr(cc)

        if cc < 0x20:
            if cc == 0x07: out("\\a") # bell
            elif cc == 0x08: out("\\b") # backspace
            elif cc == 0x09: out("\\t") # horizontal tab
            elif cc == 0x0A: out("\\n") # line feed
            elif cc == 0x0B: out("\\v") # vertical tab
            elif cc == 0x0C: out("\\f") # form feed
            elif cc == 0x0D: out("\\r") # carriage return
            elif cc == 0x1B: out("\\e") # escape
            else: out("\\x%X" % cc)
        elif cc <= 0x7E :
            if sym == '\\': out('\\\\')
            elif sym == '"': out('\\"')
            else: out(sym)
        elif cc != 0: out(sym)

    out("\"")



def print_value_literal_char(x, ctx):
    num = x['imm']

    if num == None:
        out("'\0'")
        return

    power = x['type']['power']

    prefix = ""
    if power == 32 or num > 0xFFFF:
        prefix = "U"
    elif power == 16 or num > 0x7F:
        prefix = "u"

    out(prefix)
    if num >= 0x20 and num <= 0x7F:
        if num == 39:
            out("'\\''")
        else:
            out("'%c'" % (num))
    else:
        out("'\\x%X'" % (num))

    return



def print_value_literal_int(x, ctx):
    num = x['imm']

    # Big Number?
    if x['type']['power'] > 64:
        if nbits_for_num(num):
            # print Big Numbers
            high64 = (num >> 64) & 0xFFFFFFFFFFFFFFFF
            low64 = num & 0xFFFFFFFFFFFFFFFF

            out("(((__int128)0x%X << 64) | ((__int128)0x%X))" % (high64, low64))
            return


    if USE_BOOLEAN:
        if type.is_bool(x['type']):
            if num: out("true")
            else: out("false")
            return


    if value_attribute_check(x, 'hexadecimal'):
        nsigns = 0
        if 'nsigns' in x:
            nsigns = x['nsigns']
        fmt = "0x%%0%dX" % nsigns
        out(fmt % num)

    else:
        if num == None:
            out("0")
        else:
            out(str(num))


    nbits = x['type']['power']

    if type.is_unsigned(x['type']):
        out("U")

    if nbits > CC_INT_SIZE_BITS:
        if nbits <= CC_LONG_SIZE_BITS:
            out("L")
        else:
            out("LL")



def print_value_literal_flt(x, ctx):
    num = x['imm']
    if num == None: out("0")
    else: out(str(float(num)))



def print_value_literal_ptr(x, ctx):
    if type.is_free_pointer(x['type']):
        out("NULL")
    else:
        if x['imm'] in [0, None]:
            out("NULL")
        else:
            out("0x%X" % x['imm'])


def print_value_literal(x, ctx):
    t = x['type']
    if type.is_integer(t): print_value_literal_int(x, ctx)
    elif type.is_float(t): print_value_literal_flt(x, ctx)
    elif type.is_record(t): print_value_literal_record(x, ctx)
    elif type.is_array(t): print_value_literal_arr(x, ctx)
    elif type.is_pointer(t): print_value_literal_ptr(x, ctx)
    elif type.is_char(t): print_value_literal_char(x, ctx)
    elif type.is_bool(t): print_value_literal_int(x, ctx)
    else: error("print_value_literal not implemented", x['ti'])


def print_value_by_id(x):
    out("%s" % x['id']['str'])


def print_value_let(x, ctx):
    return print_value(x['value'])


def print_value_sizeof(x, ctx):
    out("sizeof(")
    print_type(x['of'], need_space_after=False, _print_array_asis=True)
    out(")")


def print_value_alignof(x, ctx):
    out("__alignof(")
    print_type(x['of'], need_space_after=False, _print_array_asis=True)
    out(")")


def print_value_offsetof(x, ctx):
    out("__offsetof(")
    print_type(x['of'], need_space_after=False, _print_array_asis=True)
    out(", ")
    out(x['field']['str'])
    out(")")



#def print_rvalue(x, ctx=[], need_wrap=False, print_just_id=True):
#    print_value(x, ctx, need_wrap, print_just_id)


def print_value(x, ctx=[], need_wrap=False, print_just_id=True):
    # если у значения есть свойство 'id' то печатаем просто id
    # (используется для печати имени констант а не просто их значения)
    # в LLVM перчаем просто значение

    #if 'need_cast' in v['att']:
    #    out("("); print_type(to_type, need_space_after=False); out(")")

    if print_just_id:
        if 'id' in x:
            print_value_by_id(x)
            return

    if need_wrap:
        out("(")

    k = x['kind']

    if k == 'literal': print_value_literal(x, ctx)
    elif k in bin_ops: print_value_bin(x, ctx)
    elif k in un_ops: print_value_un(x, ctx)
    elif k == 'const': print_value_let(x, ctx)
    elif k in ['func', 'var']: print_value_by_id(x)
    elif k == 'call': print_value_call(x, ctx)
    elif k == 'index': print_value_index(x, ctx)
    elif k == 'index_ptr': print_value_index_ptr(x, ctx)
    elif k == 'access': print_value_access(x, ctx)
    elif k == 'access_ptr': print_value_access_ptr(x, ctx)
    elif k == 'cast_immediate': print_value_cast_immediate(x, ctx)
    elif k == 'cast': print_value_cast(x, ctx)
    elif k == 'sizeof': print_value_sizeof(x, ctx)
    elif k == 'alignof': print_value_alignof(x, ctx)
    elif k == 'offsetof': y = print_value_offsetof(x, ctx)
    else:
        out("<%s>" % k)
        print(x)
        exit(1)

    if need_wrap:
        out(")")



def print_stmt_if(x, need_else_branch):
    out("if ("); print_value(x['cond']); out(")")

    if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
        nl_indent()
    else:
        out(" ")

    print_stmt_block(x['then'])

    e = x['else']
    if e != None:
        if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
            nl_indent()
        else:
            out(" ")

        if e['kind'] == 'if':
            out("else ")
            print_stmt_if(e, need_else_branch=True)
        else:
            out("else")
            if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
                nl_indent()
            else:
                out(" ")
            print_stmt_block(e)



def print_stmt_while(x):
    out("while ("); print_value(x['cond']); out(")")

    if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
        nl_indent()
    else:
        out(" ")

    print_stmt_block(x['stmt'])



def print_stmt_return(x):
    out("return")
    if x['value'] != None:
        out(" ")
        print_value(x['value'])
    out(";")



def print_stmt_defvar(x):
    print_field(x['var'])

    init_value = x['var']['init']
    if init_value != None:
        out(" = ")
        print_value(init_value)

    out(";")



def print_stmt_let(x):
    v = x['value']
    print_field2(x['id'], v['type'])
    out(" = ")
    print_value(v, print_just_id=False)
    out(";")



def assign_array_by_items(x):
    out("// array assignation")
    for i in range(x['right']['type']['size']):
        nl_indent()
        print_value(x['left']);
        out("[%s] = " % i)
        print_value(x['right']);
        out("[%s];" % i)
        i = i + 1


def assign_record_by_fields(x):
    # в си нельзя просто так присвоить запись
    #print("assign_record_by_fields " + x['right']['kind'])
    out("// record assignation")
    for f in x['right']['type']['fields']:
        f_id_str = f['id']['str']
        nl_indent()
        print_value(x['left']);
        out(".%s = " % f_id_str)
        print_value(x['right']);
        out(".%s;" % f_id_str)


def assign(left, right):

    # в си нельзя просто так присвоить массив // или структуру
    if right['kind'] == 'var':
        if type.is_array(right['type']):
            assign_array_by_items(x)
            return

        #elif type.is_record(x['right']['type']):
            #assign_record_by_fields(x)
            #return

    print_value(left)
    out(" = ")
    print_value(right)
    out(";")



def print_stmt_assign(x):
    assign(x['left'], x['right'])


def print_stmt_value(x):
    print_value(x['value']); out(";")


def print_stmt(x):
    k = x['kind']

    nl = x['nl']
    newline(n=nl)

    if k == 'block': print_stmt_block(x)
    elif k == 'value': indent_if(nl > 0); print_stmt_value(x)
    elif k == 'assign': indent_if(nl > 0); print_stmt_assign(x)
    elif k == 'return': indent_if(nl > 0); print_stmt_return(x)
    elif k == 'if': indent_if(nl > 0); print_stmt_if(x, need_else_branch=False)
    elif k == 'while': indent_if(nl > 0); print_stmt_while(x)
    elif k == 'def_var': indent_if(nl > 0); print_stmt_defvar(x)
    elif k == 'let': indent_if(nl > 0); print_stmt_let(x)
    elif k == 'break': indent_if(nl > 0); out('break;')
    elif k == 'again': indent_if(nl > 0); out('continue;')
    elif k == 'comment-line': print_comment_line(x)
    elif k == 'comment-block': print_comment_block(x)
    else: out("<stmt %s>" % str(x))


# not works
def print_arrays(arrays):
    for array in arrays:
        nl_indent()
        array['value'] = None
        print_stmt_defvar(array)
        nl_indent()
        dst = array['id']['str']
        src = array['id']['str']
        len = type.type_get_size(array['type'])
        out("memcpy(%s, _%s, %d);" % (dst, src, len))



def print_statements(stmts):
    for stmt in stmts:
        print_stmt(stmt)



def print_stmt_block(s):
    out("{")

    indent_up()

    print_statements(s['stmts'])

    indent_down()

    endnl = s['end_nl']
    newline(n=endnl)
    if endnl:
        indent()

    out("}")


def print_func_signature(id, typ, arghack=False):

    to = typ['to']
    t = to

    # возвращает список аргументов с типом массив (!)
    # для того чтобы print_stmt мог их пропечатать как локаоьные
    # и скопировать
    arrays = []

    # возврат является масссивом?
    #is_array = t['kind'] == 'array'
    #array_dims = None
    #if is_array:
        #array_dims = t['size']
        #t = t['of']

    # поле является указателем?
    ptr_level = 0
    while type.is_pointer(t):
        ptr_level = ptr_level + 1
        t = t['to']
        # *[] or *[n] -> just *
        if t['kind'] == 'array':
            t = t['of']

    print_type(t, need_space_after=False)
    out(" " + "*" * ptr_level)
    out("%s" % id)
    #arghack = 'arghack' in t['att']
    print_paramlist(typ['params'], arghack)

    return arrays




def print_decl_func(x):
    func = x['value']

    if 'extern' in func['att']: out("extern ")
    if 'static' in func['att']: out("static ")
    if 'inline' in func['att']: out("inline ")
    if 'c_prefix' in func: out("%s " % func['c_prefix'])

    print_func_signature(func['id']['str'], func['type'])

    out(";")



def print_def_func(x):
    func = x['value']
    arghack = 'arghack' in func['att']

    if 'comment' in func:
        if func['comment'] != '':
            out("// %s" % func['comment'])
            newline()

    if 'c_prefix' in func:
        out("%s " % func['c_prefix'])

    if 'static' in func['att']: out("static ")
    if 'inline' in func['att']: out("inline ")

    print_func_signature(func['id']['str'], func['type'], arghack=arghack)

    if styleguide['LINE_BREAK_BEFORE_FUNC_BRACE']:
        newline()
    else:
        out(" ")


    out("{")

    indent_up()

    if arghack:
        newline(); indent(); out("va_list __vargs;")

        last_param = func['type']['params'][-1]

        newline(); indent(); out("va_start(__vargs, %s);" % last_param['id']['str'])

    print_statements(func['stmt']['stmts'])

    if arghack:
        newline(); indent(); out("va_end(__vargs);")

    indent_down()

    out("\n}")



def print_decl_type(x):
    id_str = x['type']['id']['str']
    out("struct %s;" % id_str)
    if not NO_TYPEDEF_STRUCTS:
        out("\ntypedef struct %s %s;" % (id_str, id_str))


def print_def_type(x):
    id_str = x['type']['id']['str']
    t = x['type']['aliasof']

    # !
    if x['afterdef']:
        if type.is_record(t):
            print_type_record(t, tag=id_str)
            out(";")
            return;


    if NO_TYPEDEF_STRUCTS:
        if type.is_record(t):
            print_type_record(t, tag=xid_str)
            out(";")
            return

    if NO_TYPEDEF_OTHERS:
        if not type.is_record(t):
            return

    is_defined_array = type.is_defined_array(t)
    out("typedef ")

    if 'volatile' in x['type']['att']:
        out("volatile ")

    if is_defined_array:
        print_type(t['of'], need_space_after=False)#, print_aka=False)
    else:
        print_type(t, need_space_after=False)#, print_aka=False)

    out(" %s" % id_str)
    if is_defined_array:
        out("["); print_value(t['volume']); out("]")
    out(";")



def print_field_regular(t, id):
    print_type(t, need_space_after=True)
    out("%s" % id)


def print_field_pointer(t, id):
    print_type(t, need_space_after=True)
    out("%s" % id)



def print_field_array(t, id):
    # get list element type
    root_type = t
    while root_type['kind'] == 'array':
        root_type = root_type['of']

    print_type(root_type, need_space_after=True)

    out("%s" % id)

    # print arrays dimensions
    array_type = t
    while type.is_array(array_type):
        out("["); print_value(array_type['volume']); out("]")
        array_type = array_type['of']


# из за того что с C типы записваются через жопу
# приходится печатать типы ptr, arr & func вместе с именем поля
def print_field(x):
    print_field2(x['id'], x['type'])


def print_field2(_id, typ):
    assert (typ != None)

    id_str = _id['str']
    assert (id_str != "")


    if 'c_alias' in typ or 'id' in typ:
        print_field_regular(typ, id_str)
        return

    if type.is_pointer(typ): print_field_pointer(typ, id_str)
    elif type.is_array(typ): print_field_array(typ, id_str)
    else: print_field_regular(typ, id_str)




def print_def_var(x):
    var = x['value']
    if USE_STATIC_VARIABLES:
        if not 'global' in var['att']:
            if not 'extern' in var['att']:
                out("static ")

        if 'extern' in var['att']:
            out("extern ")

        if 'volatile' in var['att']:
            out("volatile ")


    if 'c_prefix' in var:
        out("%s " % var['c_prefix'])

    print_field(var)

    init_value = var['init']
    if init_value != None:
        out(" = "); print_value(init_value, ctx=['no-literal-array-cast'])

    out(";")


def print_def_const(x):
    const_value = x['value']

    # не печатаем GenericString
    # печатаем только сконструированные (явно или неявно) строки
    # временно вырубил но в целом здравая идея
#    if type.is_generic_string(const_value['type']):
#        return

    id_str = const_value['id']['str']
    v = const_value['value']
    out("#define %s  " % id_str)

    need_wrap = precedence(v) < precedenceMax
    global nl_str
    nl_str = " \\\n"
    # ctx=['no-literal-array-cast'],
    print_value(v, need_wrap=need_wrap, print_just_id=True)
    nl_str = "\n"


def print_include(x):
    if x['local']:
        impline = "#include \"%s\"" % x['str']
    else:
        impline = "#include <%s>" % x['str']
    out(impline)


def print_insert(x):
    out(x['str'])


def print_comment(x):
    k = x['kind']
    if k == 'line': print_comment_line(x)
    elif k == 'block': print_comment_block(x)


def print_comment_block(x):
    indent()
    out("/*%s*/" % x['text'])


def print_comment_line(x):
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



def cdirectives(module):
    for imported_module in module['imports']:
        for obj in imported_module['text']:
            if obj['isa'] == 'directive':
                if obj['kind'] == 'c_include':
                    newline()
                    print_include(obj)

    for obj in module['text']:
        if obj['isa'] == 'directive':
            if obj['kind'] == 'c_include':
                newline()
                print_include(obj)



def print_directive(x):
    k = x['kind']
    if k == 'import': print_include(x)
    elif k == 'insert': print_insert(x)



def run(module, outname):
    from main import features
    is_header = features.get('header')

    if is_header: outname = outname + '.h'
    else: outname = outname + '.c'

    output_open(outname)

    out("\n#include <stdarg.h>")

    # search for @c_include("...")
    cdirectives(module)

    guardname = ''
    if is_header:
        guardname = outname.split("/")[-1]
        guardname = guardname[:-2].upper() + '_H'
        out("\n#ifndef %s" % guardname)
        out("\n#define %s" % guardname)
        newline()

    out("\n#include <stdint.h>")
    out("\n#include <string.h>")

    if USE_STDBOOL:
        out("\n#include <stdbool.h>")

    newline(n=2)

    for x in module['text']:
        if 'value' in x:
            if 'c-no-print' in x['value']['att']:
                continue

        elif 'type' in x:
            if 'c-no-print' in x['type']['att']:
                continue

        elif 'c-no-print' in x['att']:
            continue


        if 'nl' in x:
            newline(n=x['nl'])
        else:
            newline()
            print('not NL in ' + str(x))

        isa = x['isa']
        if isa == 'def_var': print_def_var(x)
        elif isa == 'def_const': print_def_const(x)
        elif isa == 'def_func': print_def_func(x)
        elif isa == 'def_type': print_def_type(x)
        elif isa == 'decl_func': print_decl_func(x)
        elif isa == 'decl_type': print_decl_type(x)
        elif isa == 'comment': print_comment(x)
        elif isa == 'directive': print_directive(x)

    newline()
    if is_header:
        out("\n#endif  /* %s */" % guardname)
    newline()

    output_close()



