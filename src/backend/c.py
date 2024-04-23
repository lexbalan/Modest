# Есть проблема с массивом generic int когда индексируешь и приводишь к инту
# но индексируешь переменной (в цикле например)


from error import info, error, fatal
from .common import *
import hlir.type as hlir_type
from hlir.type import type_print
from value.value import value_is_immediate, value_is_zero, value_attribute_check, value_print
from util import align_bits_up, nbits_for_num, get_item_with_id, align_to
from unicode import utfx_chars_to_utf32_chars, utf32_chars_to_string
from main import settings
import foundation

import copy

INDENT_SYMBOL = " " * 4


NO_TYPEDEF_STRUCTS = False

USE_STDBOOL = True
BOOL_TRUE_LITERAL = 'true'
BOOL_FALSE_LITERAL = 'false'
DONT_PRINT_UNUSED = True

USE_STATIC_VARIABLES = True

VA_ARG_CHAR_AS_INT = True

# for integer literals printing
CC_INT_SIZE_BITS = 32
CC_LONG_SIZE_BITS = 32
CC_LONG_LONG_SIZE_BITS = 64


func_undef_list = []

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


va_id = None

cfunc = None


def newline(n=1):
    out(nl_str * n)


def indent():
    ind(INDENT_SYMBOL)


def nl_indent(nl=1):
    newline(nl)
    if nl > 0:
        indent()


def is_local_context():
    global cfunc
    return cfunc != None


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
    ['positive', 'negative', 'not', 'cons', 'ref', 'deref', 'sizeof', 'alignof', 'offsetof', 'lengthof'], #10
    ['call', 'index', 'access'], #11
    ['num', 'var', 'func', 'str', 'enum', 'record', 'array'] #12
]

precedenceMax = len(aprecedence) - 1


# приоритет операции
def precedence(x):
    k = x['kind']

    i = 0
    while i < precedenceMax + 1:
        if k in aprecedence[i]:
            break
        i = i + 1

    return i



def print_id(x, prefix=''):
    if 'c_alias' in x:
        out(x['c_alias'])
        return

    out(prefix + x['id']['str'])



def print_type_id(t):
    print_id(t)



def print_array_volume(t):
    out("[")

    # многомерные массивы в C не существуют, поэтому печатаем один массив
    # размер которого будет произведением всех измерений
    if hlir_type.type_is_closed_array(t['of']):

        # if it is array of arrays, print volume as:
        # [n * m * ...]
        t2 = t
        while True:
            print_value(t2['volume'])
            if not hlir_type.type_is_closed_array(t2['of']):
                break
            t2 = t2['of']
            out(" * ")

    else:
        print_value(t['volume'])

    out("]")



def _print_type_pointer_to(to, as_const, space_after):
    print_type(to, space_after=True)
    out("*")
    if as_const:
        out("const")
        if space_after:
            out(" ")



def print_type_array(t, as_pointer, space_after):
    if as_pointer:
        _print_type_pointer_to(t['of'], as_const='const' in t['att'], space_after=space_after)
        return

    assert(t['volume'] != None)
    print_type(t['of'], space_after=space_after)
    print_array_volume(t)



def print_type_pointer(t, space_after, as_const=False):
    # array was printed as *, we dont need to place another *
    if hlir_type.type_is_array(t['to']):
        _print_type_pointer_to(t['to']['of'], as_const=as_const, space_after=space_after)
        return

    _print_type_pointer_to(t['to'], as_const=as_const, space_after=space_after)



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


    prev_nl = 1
    for field in t['fields']:

        if prev_nl == 0:
            out(" ")

        if 'comments' in field:
            for comment in field['comments']:
                #newline(n=comment['nl'])
                print_comment(comment)


        nl_indent(field['nl'])
        prev_nl = field['nl']

        print_variable(field['id'], field['type'])
        out(";")

    indent_down()
    nl_indent(t['end_nl'])
    out("}")



def print_type_enum(t):
    out("enum {")
    indent_up()
    items = t['items']
    i = 0
    while i < len(items):
        if i > 0: out(',')
        item = items[i]
        nl_indent()
        print_id(item)
        i = i + 1
    indent_down()
    nl_indent()
    out("}")



def print_type(t, space_after=False, array_as_ptr=True, as_const=False):
    k = t['kind']

    if 'wrapped_array_type' in t['att']:
        out(t['wrapped_id'])
        if space_after:
            out(" ")
        return

    if not hlir_type.type_is_pointer(t):
        if as_const:
            out("const ")

        if 'volatile' in t['att']:
            out("volatile ")

    # hotfix for let generic value problem (let x = 1)
    if hlir_type.type_is_generic_integer(t):
        # если пришел generic - подберем подходящий тип
        # ex: let x = 1; func(x)
        t = foundation.type_select_int(t['width'])


    if t['definition'] != None:
        type_definition = t['definition']
        if 'c_alias' in type_definition:
            out(type_definition['c_alias'])
        else:
            out(type_definition['id']['str'])

    elif t['declaration'] != None:
        type_declaration = t['declaration']
        if 'c_alias' in type_declaration:
            out(type_declaration['c_alias'])
        else:
            out(type_declaration['id']['str'])

    elif hlir_type.type_is_integer(t):
        if not t['signed']:
            out("u")
        out("int%d_t", align_to(t['width'], 8))

    elif hlir_type.type_is_float(t):
        if t['width'] <= 32:
            out("float")
        else:
            out("double")

    elif hlir_type.type_is_record(t):
        if 'aka' in t:
            out("struct %s" % t['aka'])
        else:
            print_type_record(t)

    elif hlir_type.type_is_pointer(t):
        print_type_pointer(t, space_after, as_const)
        return

    elif hlir_type.type_is_array(t):
        print_type_array(t, as_pointer=array_as_ptr, space_after=space_after)

    elif hlir_type.type_is_enum(t):
        print_type_enum(t)

    elif hlir_type.type_is_func(t):
        out("void")

    elif hlir_type.type_is_char(t):
        if t['width'] <= 8:
            out("char")
        elif t['width'] <= 16:
            out("int16_t")
        elif t['width'] <= 32:
            out("int32_t")

    elif k == 'opaque':
        out("void")

    else: out("<type:" + str(t) + ">")

    if space_after:
        out(" ")




bin_ops = {
    'or': '|', 'xor': '^', 'and': '&', 'shl': '<<', 'shr': '>>',
    'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
    'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'rem': '%',
    'logic_and': '&&', 'logic_or': '||',
    'add_arr': '', 'eq_str': '', 'ne_str': ''
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
        need_wrap_left = precedence(left) < 10
        need_wrap_right = precedence(right) < 10
    elif op == 'logic_or':
        if left['kind'] != 'logic_or':
            need_wrap_left = precedence(left) < 10
        if right['kind'] != 'logic_or':
            need_wrap_right = precedence(right) < 10
    elif op == 'logic_and':
        if left['kind'] != 'logic_and':
            need_wrap_left = precedence(left) < 10
        if right['kind'] != 'logic_and':
            need_wrap_right = precedence(right) < 10
    elif op in ['eq', 'ne']:
        if hlir_type.type_is_composite(left['type']):
            memcmp_by(left, right, by=left, op=op)
            return
    elif op in ['eq_str', 'ne_str']:
        print_value_bool_create(v, ctx)
        return
    elif op == 'add_arr':
        print_value_array(v, ctx)
        return

    print_value(left, need_wrap=need_wrap_left)
    out(' %s ' % bin_ops[op])
    print_value(right, need_wrap=need_wrap_right)



un_ops = {
    'ref': '&', 'deref': '*',
    'positive': '+', 'negative': '-',
    'not': '~', 'logic_not': '!'
}


def print_value_un(v, ctx):
    op = v['kind']
    value = v['value']

    p0 = precedence(v)
    pv = precedence(value)

    if op == 'not':
        if hlir_type.type_eq(value['type'], foundation.typeBool):
            op = 'logic_not'

    if v['kind'] == 'ref':
        if hlir_type.type_is_array(value['type']):
            out("(")
            print_type(v['type'])
            out(")")

    out(un_ops[op]); print_value(value, need_wrap=pv<p0)

    # указатель на массив в сях берем как &array[0]
    # поскольку у нас указатель на массив сейчас печатается как *<item_type>
    # а &array дает нам *array[n]
    #if v['kind'] == 'ref':
    #    if value['type']['kind'] == 'array':
    #        out("[0]")



def print_paramlist(params, extra_args=False):
    out("(")
    i = 0
    for param in params:
        if i > 0: out(", ")
        print_variable(param['id'], param['type'])
        i = i + 1

    if extra_args:
        out(", ...")
    out(")")



def ptr2func(ftype):
    print_type(ftype['to']);
    out(" (*) ")
    print_paramlist(ftype['params'], ftype['extra_args'])


def print_value_call(v, ctx):
    left = v['func']
    ftype = left['type']

    if hlir_type.type_is_pointer(ftype):
        # Вызов функции через указатель
        # поскольку у нас указатели на функции это *void
        # при вызове приводим левое к указателю на функцию
        ftype = ftype['to']
        out("((")
        ptr2func(ftype)
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

        # не всегда когда есть аргумент есть и соотв ему параметер (!)
        try:
            # если тип аргумента отличается модификатором (const, volatile)
            # то явно приведем его к типу параметра, чтобы C не ругался
            # (try: проверяем только те аргументы, для которых есть параметры)
            p = params[i]
            pt = p['type']

            if 'wrapped_array_type' in pt['att']:
                print_cast_hard(pt, a)

            elif not hlir_type.type_eq(pt, a['type'], opt=['att_checking']):
                print_cast(pt, a)

            else:
                print_value(a, ctx=ctx)

        except:
            print_value(a, ctx=ctx)

        i = i + 1
        if i < n:
            out(", ")

    out(")")



def print_value_index(x, ctx):
    array = x['array']

    indexes = []

    xx = x
    while xx['kind'] == 'index':
        a = xx['array']
        indexes.append(xx['index'])
        xx = a

    dims = []
    yy = xx['type']
    while hlir_type.type_is_closed_array(yy):
        dims.append(yy['volume'])
        yy = yy['of']

    # поскольку индексация идет в обратном порядке,
    # приведем список к прямому порядку (так как индексация записывается)
    indexes.reverse()


    # если имеем дело c дженерик массивом (глоб константа)
    if hlir_type.type_is_generic(array['type']):
        if value_is_immediate(x):
            print_value_terminal(x, ['print_immediate'])
            return


    need_wrap = precedence(xx) < precedence(x)
    print_value(xx, ctx=['do_unwrap', 'need_mangle'], need_wrap=need_wrap)

    out("[")

    # Окончательный индекс равен сумме произведений индексов
    # на произведение всех размерностей справа

    i = 0
    n = len(indexes)
    while i < n:
        index = indexes[i]
        print_value(index)

        j = i + 1
        while j < len(dims):
            out(" * ")
            print_value(dims[j])
            j = j + 1

        if i < (n - 1):
            out(" + ")

        i = i + 1

    out("]")



def print_value_index_ptr(x, ctx):
    ptr2array = x['pointer']
    need_wrap = precedence(ptr2array) < precedence(x)
    print_value(ptr2array, ctx=['do_unwrap', 'need_mangle'], need_wrap=need_wrap)
    out("["); print_value(x['index']); out("]")



def print_value_access(x, ctx):
    left = x['record']

    # если имеем дело c дженерик записью (глоб константа)
    if hlir_type.type_is_generic(left['type']):
        if value_is_immediate(x):
            print_value_terminal(x, ['print_immediate'])
            return

    need_wrap = precedence(left) < precedence(x)
    print_value(left, need_wrap=need_wrap)
    out('.')
    print_id(x['field'])



def print_value_access_ptr(x, ctx):
    left = x['pointer']
    need_wrap = precedence(left) < precedence(x)
    print_value(left, need_wrap=need_wrap)
    out("->")
    print_id(x['field'])



def print_cast_hard(t, v, ctx=[]):
    # hard cast is possible only in function body
    assert(is_local_context())
    out("*(")
    print_type(t, space_after=True)
    out("*)&")
    need_wrap = precedence(v) < precedence({'kind': 'cons'})
    print_value(v, ctx=ctx, need_wrap=need_wrap)



def print_cast(t, v, ctx=[]):
    # if id(A) == id(B) => do not cast
    """if 'c_alias' in v['type'] and 'c_alias' in t:
        if v['type']['c_alias'] == t['c_alias']:
            print_value(v, ctx)
            return"""

    out("("); print_type(t); out(")")
    need_wrap = precedence(v) < precedence({'kind': 'cons'})
    print_value(v, ctx=ctx, need_wrap=need_wrap)



def print_value_cons(x, ctx):
    to_type = x['type']
    value = x['value']
    from_type = value['type']


    # String construction ([]Char -> *[]Char) - just print literal string
    if hlir_type.type_is_pointer_to_array_of_char(to_type):
        if hlir_type.type_is_array_of_char(from_type):
            char_width = to_type['to']['of']['width']
            print_value_string_create(x, ctx=[], char_width=char_width)
            return

    """if hlir_type.type_is_generic(to_type):
        if hlir_type.type_is_generic(from_type):
            print_cast(to_type, value, ctx)"""
            #nv = copy.copy(x['value'])
            #nv['type'] = to_type

    # в у нас типы структурные, в си - номинальные
    # поэтому даже если структуры одинаковы, но имена разные
    # их нужно приводить

    # *RecordA -> *RecordB
    if hlir_type.type_is_pointer_to_record(from_type):
        if hlir_type.type_is_pointer_to_record(to_type):
            print_cast(to_type, value, ctx)
            return

    # RecordA -> RecordB
    if hlir_type.type_is_record(to_type):
        if hlir_type.type_is_record(from_type):
            # C cannot cast struct to struct (!)

            try:
                print_cast_hard(to_type, value)
            except:
                value_print(value, msg='cannot cast hard')
                """type_print(value['type'])
                print("TO")
                type_print(to_type)"""

            return

    # VA_List -> AnyType
    if hlir_type.type_is_va_list(from_type):
        global va_id
        out("va_arg(%s, " % va_id)

        if VA_ARG_CHAR_AS_INT:
            if hlir_type.type_is_char(to_type):
                out("int")
            else:
                print_type(to_type)
        else:
            print_type(to_type)

        out(")")
        return

    if value['kind'] == 'literal':
        print_value(value)
        return

    # (!) because
    # - in Cm int32(-1) -> uint64 => 0x00000000ffffffff
    # - in C  int32(-1) -> uint64 => 0xffffffffffffffff
    # required: (uint64_t)((uint32)int32_value)
    if hlir_type.type_is_integer(from_type) and hlir_type.type_is_integer(to_type):
        if hlir_type.type_is_signed(from_type) and hlir_type.type_is_unsigned(to_type):
            if from_type['size'] < to_type['size']:
                out("((")
                print_type(to_type)
                out(")")
                nat_same_sz = foundation.type_select_nat(from_type['width'])
                print_cast(nat_same_sz, value, ctx)
                out(")")
                return

    print_cast(to_type, value, ctx)



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


def print_array_values(values, ctx):
    i = 0
    n = len(values)
    while i < n:
        a = values[i]

        nl = 0
        if 'nl' in a:
            nl = a['nl']

        if nl > 0:
            newline(n=nl)
            indent()
        else:
            if i > 0:
                out(" ")

        if hlir_type.type_is_closed_array(a['type']):
            print_array_values(a['asset'], ctx)
        else:
            print_value(a, ctx)

        i = i + 1


        # если это значание - zero, проверим все остальные справа
        # и если они тоже zero - их можно не печатать (zero tail)
        # ex: {'a', 'b', '\0', '\0', '\0'} -> {'a', 'b', '\0'}
        if value_is_zero(a):
            if is_zero_tail(values, i, n):
                return

        if i < n:
            out(',')



def print_value_string(x, ctx):
    utf32_codes = []
    for c in x['asset']:
        utf32_codes.append(ord(c))
    _print_string_literal(utf32_codes, width=x['type']['width'])


def print_value_array(v, ctx):
    if hlir_type.type_is_array_of_char(v['type']):
        char_type = v['type']['of']
        char_width = char_type['width']

        """if hlir_type.type_is_generic_array_of_char(v['type']):
            # FIXIT: вообще нефиг печатать generic string (!)
            out('{} /*GENERIC-STRING*/')
            return"""

        # массивы чаров в конце которых только один терминальный ноль
        # печатаем в виде строковых литералов C
        values = v['asset']
        n = len(values)
        if n > 0:
            utf32_codes = []
            i = 0
            while i < n:
                cc = values[i]['asset']
                utf32_codes.append(cc)
                if cc == 0:
                    if is_zero_tail(values, i, n):
                        break

                i = i + 1

            _print_string_literal(utf32_codes, width=char_width)
            return

    if not 'no-literal-array-cast' in ctx:
        if is_local_context():
            # only for local record literals (!)
            out("(")
            print_type(v['type'], array_as_ptr=False)
            out(")")


    out("{")
    indent_up()
    values = v['asset']
    print_array_values(values, ctx)
    indent_down()
    if v['nl_end'] > 0:
        newline(n=v['nl_end'])
        indent()
    out("}")




def print_value_record(v, ctx):

    if is_local_context():
        # only for local record literals (!)
        out("(")
        print_type(v['type'])
        out(")")

    initializers = v['asset']


    out("{")
    indent_up()

    nitems = len(initializers)
    i = 0

    # for situation when firat item is value_zero
    # without it, forst value will be printed with space before it.
    item_printed = False

    while i < nitems:
        item = v['type']['fields'][i]
        field_id_str = item['id']['str']
        ini = get_item_with_id(initializers, field_id_str)

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

    if 'nl_end' in v:
        if v['nl_end'] > 0:
            newline(n=v['nl_end'])
            indent()

    out("}")

    #if cast_req:
    #    out(")")
    return



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


def _print_string_literal(utf32_codes, width=8):
    prefix = ""
    if width <= 8: prefix = ""
    elif width <= 16: prefix = "u"
    elif width <= 32: prefix = "U"

    out("%s\"" % prefix)

    for cc in utf32_codes:
        if cc == 0:
            break

        out(code_to_char(cc))

    out("\"")



def print_value_string_create(x, ctx, char_width=8):
    # получаем список кодов из списка char-значений
    # (формат строки может быть разным UTF-8, UTF-16, UTF-32)
    codes = []
    for char in x['asset']:
        codes.append(char['asset'])

    # (для распечатки нужны только UTF-32 коды)
    utf32_codes = utfx_chars_to_utf32_chars(codes, char_width)

    # распечатываем (для распечатки нужны только UTF-32 коды)
    assert(utf32_codes != None)
    _print_string_literal(utf32_codes, char_width)



def print_value_char_create(x, ctx):
    width = x['type']['width']

    prefix = ""
    if width <= 8: prefix = ""
    elif width <= 16: prefix = "u"
    elif width <= 32: prefix = "U"

    out(prefix)
    out("'")
    out(code_to_char(x['asset']))
    out("'")
    return




def print_value_bool_create(x, ctx):
    if x['asset']:
        out(BOOL_TRUE_LITERAL)
    else:
        out(BOOL_FALSE_LITERAL)


def print_value_enum(x, ctx):
    print_id(x)



def print_value_integer(x, ctx):
    num = x['asset']

    nsigns = 0
    if 'nsigns' in x:
        nsigns = x['nsigns']

    req_bits = nbits_for_num(num)
    # Big Number?
    if x['type']['width'] > 64:
        if True:
            # print Big Numbers
            high64 = (num >> 64) & 0xFFFFFFFFFFFFFFFF
            low64 = num & 0xFFFFFFFFFFFFFFFF

            out("(((__int128)0x%X << 64) | ((__int128)0x%X))" % (high64, low64))
            return


    if value_attribute_check(x, 'hexadecimal'):
        fmt = "0x%%0%dX" % nsigns
        out(fmt % num)
        return  #? 0xXXXXXXXXUL is normal?
    else:
        out(str(num))


    nbits = x['type']['width']

    if hlir_type.type_is_unsigned(x['type']):
        if req_bits >= (nbits - 1):
            out("U")

    if req_bits > CC_INT_SIZE_BITS:
        if req_bits <= CC_LONG_SIZE_BITS:
            out("L")
        else:
            out("LL")



def print_value_float(x, ctx):
    out('{0:f}'.format(x['asset']))


def print_value_ptr(x, ctx):
    if x['asset'] == 0:
        out("NULL")
    else:
        out("(("); print_type(x['type']); out(")")
        out("0x%08X)" % x['asset'])


def print_value_terminal(x, ctx):
    t = x['type']
    if hlir_type.type_is_integer(t): print_value_integer(x, ctx)
    elif hlir_type.type_is_float(t): print_value_float(x, ctx)
    elif hlir_type.type_is_string(t): print_value_string(x, ctx)
    elif hlir_type.type_is_record(t): print_value_record(x, ctx)
    elif hlir_type.type_is_array(t): print_value_array(x, ctx)
    elif hlir_type.type_is_bool(t): print_value_bool_create(x, ctx)
    elif hlir_type.type_is_char(t): print_value_char_create(x, ctx)
    elif hlir_type.type_is_pointer(t): print_value_ptr(x, ctx)
    elif hlir_type.type_is_enum(t): print_value_enum(x, ctx)
    elif hlir_type.type_is_byte(t): print_value_integer(x, ctx)
    else: error("print_value_terminal not implemented", x['ti'])


def print_value_by_id(x, ctx=[], prefix=''):
    if 'c_alias' in x:
        out(x['c_alias'])
    else:
        print_id(x, prefix)

    if 'do_unwrap' in ctx:
        if 'wrapped_array_value' in x['att']:
            out(".a")


# & let
def print_value_const(x, ctx):
    prefix=''

    if x['kind'] == 'const':
        if 'need_mangle' in ctx:
            if 'global_const' in x['att']: # <- костыль!
                if hlir_type.type_is_composite(x['type']):
                    prefix = '_'

    return print_value_by_id(x, ctx, prefix)


def print_value_func(x, ctx):
    return print_value_by_id(x, ctx, prefix='')


def print_value_var(x, ctx):
    return print_value_by_id(x, ctx, prefix='')


def print_value_sizeof(x, ctx):
    out("sizeof(")
    print_type(x['of'], array_as_ptr=False)
    out(")")


def print_value_alignof(x, ctx):
    out("__alignof(")
    print_type(x['of'], array_as_ptr=False)
    out(")")


def print_value_offsetof(x, ctx):
    out("__offsetof(")
    print_type(x['of'], array_as_ptr=False)
    out(", ")
    out(x['field']['str'])
    out(")")


def print_value_lengthof(x, ctx):
    # sizeof(array) / sizeof(array[0])
    v = x['of_value']
    out("(sizeof(")
    print_value(v)
    out(") / sizeof(")
    print_value(v)
    out("[0]))")
    return



def print_value(x, ctx=[], need_wrap=False):
    # если у значения есть свойство 'id' то печатаем просто id
    # (используется для печати имени констант а не просто их значения)
    # в LLVM печатаем просто значение

    # это нужно когда печатаем глобальные константы
    # чтобы одна на другую не ссылалась тк это в си невозможно
    # каждый раз печатаем литерал инициализвтора константы полностью
    if 'print_immediate' in ctx:
        if value_is_immediate(x):
            k = x['kind']
            if k == 'const':
                print_value_terminal(x['value'], ctx)
            else:
                print_value_terminal(x, ctx)
            return


    print_value2(x, ctx, need_wrap)



def print_value2(x, ctx=[], need_wrap=False):
    if need_wrap:
        out("(")

    k = x['kind']

    if k == 'literal': print_value_terminal(x, ctx)
    elif k in bin_ops: print_value_bin(x, ctx)
    elif k in un_ops: print_value_un(x, ctx)
    elif k == 'const': print_value_const(x, ctx)
    elif k == 'func': print_value_func(x, ctx)
    elif k == 'var': print_value_var(x, ctx)
    elif k == 'call': print_value_call(x, ctx)
    elif k == 'index': print_value_index(x, ctx)
    elif k == 'index_ptr': print_value_index_ptr(x, ctx)
    elif k == 'access': print_value_access(x, ctx)
    elif k == 'access_ptr': print_value_access_ptr(x, ctx)
    elif k == 'cons': print_value_cons(x, ctx)
    elif k == 'sizeof': print_value_sizeof(x, ctx)
    elif k == 'alignof': print_value_alignof(x, ctx)
    elif k == 'offsetof': y = print_value_offsetof(x, ctx)
    elif k == 'lengthof': y = print_value_lengthof(x, ctx)
    else:
        out("<%s>" % k)
        fatal("unknown opcode '%s'" % k)
        exit(-1)

    if need_wrap:
        out(")")



def print_stmt_if(x, need_else_branch):
    nl_indent(x['nl'])
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
    nl_indent(x['nl'])
    out("while ("); print_value(x['cond']); out(")")

    if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
        nl_indent()
    else:
        out(" ")

    print_stmt_block(x['stmt'])



def print_stmt_return(x):
    nl_indent(x['nl'])
    global va_id
    if va_id != None:
        out("va_end(%s);" % va_id)
        newline(); indent();

    out("return")

    if x['value'] != None:
        out(" ")

        global cfunc
        to = cfunc['type']['to']
        if hlir_type.type_is_closed_array(to):
            print_cast_hard(to, x['value'])
        else:
            print_value(x['value'])

    out(";")



def print_stmt_defvar(x):
    init_value = x['default_value']

    if DONT_PRINT_UNUSED:
        if x['var']['usecnt'] == 0:
            if init_value['kind'] != 'call':
                return

    nl_indent(x['nl'])

    print_variable(x['var']['id'], x['var']['type'])

    if init_value != None:
        out(";")
        nl_indent()
        assign(x['var'], init_value)
        return

    out(";")
    return



def print_macro_definition(id, value, prefix=''):
    global nl_str
    out("#define %s%s  " % (prefix, id['str']))
    need_wrap = precedence(value) < precedenceMax
    nl_str = " \\\n"
    print_value(value, need_wrap=need_wrap)
    nl_str = "\n"


def print_stmt_let(x):
    id = x['id']
    v = x['value']
    iv = x['init_value']

    if DONT_PRINT_UNUSED:
        if v['usecnt'] == 0:
            if iv['kind'] != 'call':
                return

    nl_indent(x['nl'])

    # массивы печатаем как переменные
    if hlir_type.type_is_closed_array(v['type']):
        print_variable_array(v['type'], id['str'], do_wrapped=False)
        out(";")
        newline()
        indent()
        assign_array(v, iv)
        return


    if hlir_type.type_is_generic(v['type']):
        print_macro_definition(id, iv)
        global func_undef_list
        func_undef_list.append(id['str'])

    else:
        print_variable(id, v['type'], as_const=True)
        out(" = ")
        print_value(iv)
        out(";")

    return



def print_stmt_asm(x):
    s0 = utf32_chars_to_string(x['args'][0]['asset'])
    nl_indent(x['nl'])
    out('asm("%s");' % s0)
    return



def assign_array(left, right):
    if 'wrapped_array_value' in right['att']:
        if right['kind'] == 'call':
            print_cast_hard(right['func']['type']['to'], left)
            out(" = ")
            print_value(right)
            out(";")
        else:
            # *(struct ret_str_retval *)&c = ret_str();
            print_cast_hard(right['type'], left)
            out(" = ")
            print_value2(right)
            out(";")
        return

    to_copy = 0
    zero_rest = 0
    l_size = left['type']['size']
    r_size = right['type']['size']
    if l_size > r_size:
        zero_rest = l_size - r_size
        to_copy = r_size
    else:
        to_copy = l_size


    memcopy_len(left, right, to_copy)

    if zero_rest > 0:
        nl_indent()
        memzero_off(left, to_copy, zero_rest)

    return



def assign(left, right):
    if right['kind'] == 'cons':
        # for case:
        # var x: [10]Int32
        # var y: [5]Int32
        # x = [10]Int32 y
        cast_v = right['value']
        if hlir_type.type_is_array(right['type']):
            right = cast_v
            return assign_array(left, right)

    if hlir_type.type_is_array(right['type']):
        return assign_array(left, right)


    print_value(left)
    out(" = ")
    print_value(right)
    out(";")

    return



def print_stmt_assign(x):
    nl_indent(x['nl'])
    assign(x['left'], x['right'])


def print_stmt_value(x):
    nl_indent(x['nl'])
    print_value(x['value']); out(";")




def print_stmt(x):
    k = x['kind']

    #nl = x['nl']
    #newline(n=nl)

    if k == 'block': print_stmt_block(x)
    elif k == 'value': print_stmt_value(x)
    elif k == 'assign': print_stmt_assign(x)
    elif k == 'return': print_stmt_return(x)
    elif k == 'if': print_stmt_if(x, need_else_branch=False)
    elif k == 'while': print_stmt_while(x)
    elif k == 'def_var': print_stmt_defvar(x)
    elif k == 'let': print_stmt_let(x)
    elif k == 'break': nl_indent(x['nl']); out('break;')
    elif k == 'again': nl_indent(x['nl']); out('continue;')
    elif k == 'comment-line': print_comment_line(x)
    elif k == 'comment-block': print_comment_block(x)
    elif k == 'asm': print_stmt_asm(x)
    else: out("<stmt %s>" % str(x))



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



def print_wrapped_array(_type):
    # -> struct ret_str_retval {char a[10];};
    out(_type['wrapped_id'])
    out (" {")
    item_type = hlir_type.array_root_item_type(_type)
    print_type(item_type, space_after=True)
    out("a");
    print_array_volume(_type)
    out(";};")
    newline()


def print_func_wrappers(ftype):
    # печатаем обернутые параметры-массивы и возврашаемые массивы
    # (обернуты тк C не позволяет принимать возвращать массив по значению)
    for param in ftype['params']:
        if hlir_type.type_is_closed_array(param['type']):
            print_wrapped_array(param['type'])
    if hlir_type.type_is_closed_array(ftype['to']):
        print_wrapped_array(ftype['to'])


def print_func_signature(id_str, ftype, atts, print_wrappers=True):
    if print_wrappers:
        print_func_wrappers(ftype)

    if 'static' in atts: out("static ")
    if 'inline' in atts: out("inline ")

    to = ftype['to']
    t = to

    # поле является указателем?
    ptr_level = 0
    while hlir_type.type_is_pointer(t):
        ptr_level = ptr_level + 1
        t = t['to']
        # *[] or *[n] -> just *
        if t['kind'] == 'array':
            t = t['of']

    print_type(t, space_after=True)
    out("*" * ptr_level)
    out("%s" % id_str)
    print_paramlist(ftype['params'], extra_args=ftype['extra_args'])



def print_decl_func(x):
    newline(n=x['nl'])
    if 'gnu_att' in x:
        out('__attribute__((%s))\n' % x['gnu_att'])
    print_func_signature(x['id']['str'], x['value']['type'], x['value']['att'])
    out(";")


def print_def_func(x):
    func = x['value']
    id = x['id']

    global va_id
    global cfunc
    cfunc = func

    newline(n=x['nl'])

    if 'gnu_att' in x:
        out('__attribute__((%s))\n' % x['gnu_att'])

    ftype = func['type']
    extra_args = ftype['extra_args']

    # если функция уже была определена, то обертки над ее типами
    # уже были напечатаны (если они были), и их нельзя печатать еще раз
    print_wrappers = not 'declared' in func['att']
    print_func_signature(func['id']['str'], ftype, func['att'], print_wrappers)

    if styleguide['LINE_BREAK_BEFORE_FUNC_BRACE']:
        newline()
    else:
        out(" ")

    out("{")
    indent_up()

    if extra_args:
        # add va_list & va_start()
        va_id = ftype['va_list_id']['str']
        newline(); indent(); out("va_list %s;" % va_id)
        last_param = ftype['params'][-1]
        newline(); indent(); out("va_start(%s, %s);" % (va_id, last_param['id']['str']))

    stmts = func['stmt']['stmts']
    print_statements(stmts)

    if extra_args:
        if stmts[-1]['kind'] != 'return':
            newline(); indent(); out("va_end(%s);" % va_id)

    indent_down()

    global func_undef_list
    for id_str in func_undef_list:
        out("\n#undef %s" % id_str)

    func_undef_list = []

    newline()
    out("}")

    va_id = None
    cfunc = None





def print_decl_type(x):
    newline(n=x['nl'])
    id = x['id']
    out("struct %s;" % id['str'])
    if not NO_TYPEDEF_STRUCTS:
        out("\ntypedef struct %s %s;" % (id['str'], id['str']))


def print_def_type(x):
    id = x['id']
    orig_type = x['original_type']

    newline(n=x['nl'])

    # !
    if x['afterdef']:
        if hlir_type.type_is_record(orig_type):
            print_type_record(orig_type, tag=id['str'])
            out(";")
            return


    if NO_TYPEDEF_STRUCTS:
        if hlir_type.type_is_record(orig_type):
            print_type_record(orig_type, tag=id['str'])
            out(";")
            return


    is_defined_array = hlir_type.type_is_closed_array(orig_type)
    out("typedef ")

    if 'volatile' in x['original_type']['att']:
        out("volatile ")

    t = orig_type
    if is_defined_array:
        t = orig_type['of']

    print_type(t, space_after=True)

    out(id['str'])

    if is_defined_array:
        print_array_volume(orig_type)

    out(";")



def print_variable_regular(t, id_str, as_const):
    print_type(t, space_after=True, as_const=as_const)
    out("%s" % id_str)


def print_variable_pointer(t, id_str, as_const):
    print_type(t, space_after=True, as_const=as_const)
    out("%s" % id_str)



def print_variable_array(t, id_str, do_wrapped=True, as_const=False):
    if do_wrapped:
        if 'wrapped_array_type' in t['att']:
            out("%s %s" % (t['wrapped_id'], id_str))
            return

    # get array item type (array_root_type)
    array_root_type = t
    while array_root_type['kind'] == 'array':
        array_root_type = array_root_type['of']

    print_type(array_root_type, space_after=True, as_const=as_const)
    out(id_str)
    print_array_volume(t)

    """# print arrays dimensions
    array_type = t
    while hlir_type.type_is_array(array_root_type):
        out("/*^^*/")
        print_array_volume(array_root_type)
        array_type = array_type['of']"""



# из за того что с C типы записваются через жопу
# приходится печатать типы ptr, arr & func вместе с именем поля
def print_variable(_id, typ, as_const=False, init_value=None, prefix=''):
    assert (typ != None)

    id_str = _id['str']
    assert (id_str != "")
    id_str = prefix + id_str

    if typ['declaration'] != None or typ['definition'] != None:
        print_variable_regular(typ, id_str, as_const)
        return

    if hlir_type.type_is_pointer(typ):
        print_variable_pointer(typ, id_str, as_const)

    elif hlir_type.type_is_array(typ):
        print_variable_array(typ, id_str, as_const=as_const)

    else:
        print_variable_regular(typ, id_str, as_const)


    if init_value != None:
        out(" = ")
        print_value(init_value)



def print_def_var(x):
    newline(n=x['nl'])

    if 'gnu_att' in x:
        out('__attribute__((%s))\n' % x['gnu_att'])

    id = x['id']
    var = x['value']
    if USE_STATIC_VARIABLES:
        if not 'global' in var['att']:
            if not 'extern' in var['att']:
                out("static ")

    #if 'static' in var['att']: out("static ")
    if 'extern' in var['att']: out("extern ")
    if 'volatile' in var['att']: out("volatile ")

    print_variable(id, var['type'])

    init_value = x['default_value']
    if init_value != None:
        out(" = ")

        if hlir_type.type_is_array(init_value['type']):
            print_value_array(init_value, ctx=[])#, ['print_immediate'])
        else:
            print_value(init_value, ctx=['no-literal-array-cast'])

    out(";")



def print_def_const(x):
    global nl_str
    const_value = x['value']
    init_value = x['init_value']

    #"""
    # Не печатаем GenericArray | GenericRecord константы
    # тк C не умеет в это дело; В value_print смотрим -
    # если пришла константа с вышеупомянутым типом - печатаем
    # просто imm значение. Некрасиво но пока так;
    # see value_print
    if hlir_type.type_is_generic_record(const_value['type']):
        return

    #???
    #if hlir_type.type_is_generic_array_of_char(const_value['type']):
    #    return

    #if hlir_type.type_is_string(const_value['type']):
    #    return

    #"""


    newline(n=x['nl'])

    _id = x['id']

    print_macro_definition(_id, init_value)

    if not hlir_type.type_is_composite(const_value['type']):
        return

    newline()
    print_variable(_id, const_value['type'], as_const=True, prefix='_')
    out(" = %s;" % _id['str'])

    """
    out(" = ")
    print_value_terminal(init_value, ctx=[])#, ['print_immediate'])
    out(";")
    #"""

    return


def print_include(x):
    # если в модуле включена опция not_included
    if 'module' in x:
        if x['module'] != None:
            if 'not_included' in x['module']['att']:
                return

    ss = x['c_name']

    if x['local']:
        include_text = "#include \"%s\"" % ss
    else:
        include_text = "#include <%s>" % ss
    out(include_text)


def print_insert(x):
    out(x['str'])


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
    newline(n=x['nl'])
    if k == 'import': print_include(x)
    elif k == 'insert': print_insert(x)



def run(module, outname):
    from main import features
    is_header = features.get('header')

    if is_header: outname = outname + '.h'
    else: outname = outname + '.c'

    output_open(outname)

    # before all print first comment (header) if present
    if len(module['text']) > 0:
        first = module['text'][0]
        if first['isa'] == 'comment':
            print_comment(first)
            module['text'] = module['text'][1:]
        else:
            out("// %s" % outname)
        newline()

    guardname = ''
    if is_header:
        guardname = outname.split("/")[-1]
        guardname = guardname[:-2].upper() + '_H'
        out("\n#ifndef %s\n" % guardname)
        out("#define %s\n" % guardname)

    out("\n#include <stdint.h>\n")
    if USE_STDBOOL:
        out("#include <stdbool.h>\n")
    out("#include <string.h>\n")

    if 'use_extra_args' in module['options']:
        out("#include <stdarg.h>\n")

    # search for @c_include("...")
    cdirectives(module)


    for anon_rec in module['anon_recs']:
        nl_indent()
        print_type_record(anon_rec, tag=anon_rec['aka'])
        out(";")

    for x in module['text']:
        if 'c-no-print' in x['att']:
            continue

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
    if is_header: out("\n#endif /* %s */" % guardname)
    newline()
    output_close()
    return



def memcopy_len(left, right, n):
    if n <= 0:
        return
    out("memcpy(&")
    print_value(left)
    out(", &")
    print_value(right)
    out(", %i);" % n)


def memcopy_by(left, right, by):
    out("memcpy(&")
    print_value(left)
    out(", &")
    print_value(right)
    out(", sizeof ")
    print_value(by)
    out(");")


def memcopy(left, right):
    out("memcpy(&")
    print_value(left)
    out(", &")
    print_value(right)
    out(", sizeof ")

    if left['kind'] == 'index':
        out("(")
        print_type(right['type'], array_as_ptr=False)
        out(")")
    else:
        print_value(left)

    out(");")



def memzero(left, sz):
    out("memset(&")
    print_value(left)
    out(", 0, %d);" % sz)


def memzero_off(left, offset, sz):
    out("memset((((void *)&")
    print_value(left)
    out(") + %i)" % offset)
    out(", 0, %d);" % sz)


def memzero_sizeof(left):
    out("memset(&")
    print_value(left)
    out(", 0, sizeof ")
    print_value(left)
    out(");")


def memcmp_by(left, right, by, op='eq'):
    out('memcmp(&')
    print_value(left)
    out(', &')
    print_value(right)
    out(', sizeof ')
    print_value(by)
    if op == 'eq':
        out(') == 0')
    else:
        out(') != 0')


