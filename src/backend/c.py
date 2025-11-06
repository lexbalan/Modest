# Есть проблема с массивом generic int когда индексируешь и приводишь к инту
# но индексируешь переменной (в цикле например)

import copy

from hlir import *
from .common import *
from error import info, warning, error, fatal
from type import select_common_type, type_print


import re

def camel_to_snake(name: str) -> str:
    # Вставляем подчёркивание перед заглавной буквой, если перед ней — строчная или цифра
    s = re.sub(r'(?<=[a-z0-9])([A-Z])', r'_\1', name)
    return s.upper()



cmodule = None

NO_TYPEDEF_STRUCTS = False
DONT_PRINT_UNUSED = True


# идетнифиаторы декларированных (или определенных) сущностей
declared = []


func_undef_list = []
module_undef_list = []

legacy_style = {
	'LINE_BREAK_BEFORE_STRUCT_BRACE': False,
	'LINE_BREAK_BEFORE_FUNC_BRACE': False,
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
	'Allman': modern_style,
}


# default style is legacy
styleguide = legacy_style

EMPTY_ARRAY_LITERAL = "{0}"
EMPTY_RECORD_LITERAL = "{0}"

EMPTY_FUNC_PARAM = "void"

cfunc = None


def newline(n=1):
	out(str_newline(n))


def nl_indent(nl=1):
	out(str_nl_indent(nl))


def is_local_context():
	global cfunc
	return cfunc != None


def is_global_context():
	global cfunc
	return cfunc == None


csettings = {}
def init(settings):
	global styleguide, csettings
	csettings = settings
	stylename = settings['output_style']
	if stylename != None:
		if stylename in styles:
			styleguide = styles[stylename]




CONS_PRECEDENCE = 10
aprecedence = [
	[HLIR_VALUE_OP_LOGIC_OR], #0
	[HLIR_VALUE_OP_LOGIC_AND], #1
	[HLIR_VALUE_OP_OR], #2
	[HLIR_VALUE_OP_XOR], #3
	[HLIR_VALUE_OP_AND], #4
	[HLIR_VALUE_OP_EQ, HLIR_VALUE_OP_NE], #5
	[HLIR_VALUE_OP_LT, HLIR_VALUE_OP_LE, HLIR_VALUE_OP_GT, HLIR_VALUE_OP_GE], #6
	[HLIR_VALUE_OP_SHL, HLIR_VALUE_OP_SHR], #7
	[HLIR_VALUE_OP_ADD, HLIR_VALUE_OP_SUB], #8
	[HLIR_VALUE_OP_MUL, HLIR_VALUE_OP_DIV, HLIR_VALUE_OP_REM], #9
	[HLIR_VALUE_OP_POS, HLIR_VALUE_OP_NEG, HLIR_VALUE_OP_NOT, HLIR_VALUE_OP_LOGIC_NOT, HLIR_VALUE_OP_CONS, HLIR_VALUE_OP_REF, HLIR_VALUE_OP_DEREF, HLIR_VALUE_OP_SIZEOF, HLIR_VALUE_OP_ALIGNOF, HLIR_VALUE_OP_OFFSETOF, HLIR_VALUE_OP_LENGTHOF], #10
	[HLIR_VALUE_OP_CALL, HLIR_VALUE_OP_INDEX, HLIR_VALUE_OP_ACCESS, HLIR_VALUE_OP_ACCESS_MODULE], #11
	#['num', 'var', 'func', 'str', 'enum', 'record', 'array'] #12
]

precedenceMax = len(aprecedence) - 1


# приоритет операции
def precedence(x):
	i = 0
	if x.isValueBin():
		k = x.op
		if x.op == HLIR_VALUE_OP_ADD and x.type.is_array():
			return 12
		while i < precedenceMax + 1:
			if k in aprecedence[i]:
				break
			i += 1
	else:
		if x.isValueCons(): i = 10
		elif x.isValueSizeofValue(): i = 10
		elif x.isValueRef(): i = 10
		elif x.isValueCall(): i = 11
		elif x.isValueIndex(): i = 11
		elif x.isValueAccessRecord(): i = 11
		elif x.isValueShl(): i = 7
		elif x.isValueShr(): i = 7
		elif x.isValuePos(): i = 10
		elif x.isValueNeg(): i = 10
		elif x.isValueNot(): i = 10
		else: i = 12

	return i





def value_is_generic_immediate(v):
	return v.isValueImmediate() and v.type.is_generic()


# такое значение определено как макрос
def value_is_generic_immediate_const(v):
	return v.isValueConst() and v.isValueImmediate() and v.type.is_generic()




def is_global_public(x):
	if hasattr(x, 'definition'):
		if x.definition != None:
			if x.definition.access_level == HLIR_ACCESS_LEVEL_PUBLIC:
				return True
	return False



def get_id_str(x):
	if not hasattr(x, 'id'):
		return None

	id = x.id
	if id == None:
		return None
	id_str = id.c

	if id.prefix != None:
		id_str = id.prefix + id_str

	if x.id.hasAttribute('nodecorate'):
		return id_str

	if not is_global_public(x):
		return id_str

	module = x.getModule()
	if module != None:
		if not module.hasAttribute('nodecorate'):
			#if x.access_level != HLIR_ACCESS_LEVEL_PRIVATE:
			return "%s_%s" % (module.prefix, id_str)

	return id_str



def get_type_id(t):
	s = get_id_str(t)
	if s != None:
		return s

	if t.is_number():
		s = 'int%d_t' % t.width
		if t.is_unsigned():
			s = 'u' + s
		return s

	if hasattr(t, 'c_anon_id'):
		return 'struct ' + t.c_anon_id

	return None



def str_type_record(t, tag=''):
	s = "struct"

	if t.hasAttribute2('packed'):
		s += " __attribute__((packed))"

	if tag != "":
		s += (" %s" % tag)

	if styleguide['LINE_BREAK_BEFORE_STRUCT_BRACE']:
		s += str_newline(1)
	else:
		s += " "

	s += "{"
	indent_up()

	prev_nl = 1
	for field in t.fields:

		if prev_nl == 0:
			s += " "

		if field.comments:
			for comment in field.comments:
				s += str_nl_indent(comment.nl)
				s += str_stmt_comment(comment)

		s += str_nl_indent(field.nl)
		prev_nl = field.nl

		s += str_var(field.type, id_str=get_id_str(field))
		s += ";"

		if field.line_comment:
			s += '  ' + str_stmt_comment(field.line_comment)


	indent_down()
	s += str_nl_indent(1)
	s += "}"
	return s



"""
def print_type_enum(t):
	out("enum {")
	indent_up()
	items = t.asset
	i = 0
	while i < len(items):
		if i > 0: out(',')
		item = items[i]
		nl_indent()
		get_id_str(item)
		i = i + 1
	indent_down()
	nl_indent()
	out("}")
"""


def is_type_named(t):
	return get_type_id(t) != None


def str_type_array(t, core='', need_close=False):
	# handle array of array .. case
	right = ''
	i = 0
	t2 = t
	while True:
		right += '['
		if t2.volume:
			if t2.volume.isValueUndef():
				# В Си не можем печатать такое a[][], или такое a[][10], etc.
				# А печатаем просто a[] (пропускаем все после пустых скобок)
				while t2.of.is_array():
					t2 = t2.of
			else:
				right += str_value(t2.volume)

		right += ']'
		t2 = t2.of
		if not t2.is_array():
			break
		i += 1

	if need_close:
		core += ')'

	return str_type(t2, core=core+right)



def strFuncParamlist(params, va_arg):
	s = '('
	i = 0
	while i < len(params):
		param = params[i]
		if i > 0:
			s += ', '

		ptype = param.type

		pstr = get_id_str(param)
		if pstr == None:
			pstr = ''
		else:
			# HACK
			# В C параметр не может быть массивом, а у нас - может
			# но реализован как указатель на массив
			if ptype.is_array():
				ptype = TypePointer(ptype)
				pstr = '_' + pstr

		s += str_var(ptype, id_str=pstr)

		if param.init_value != None:
			# BUG: None прилетает в случае когда функция возвращает массив,
			# У него нет init_value - это какой то косяк но непросто разобраться
			if not param.init_value.isValueUndef():
				s += " /* default=" + str_value(param.init_value) + " */"

		i += 1

	if va_arg:
		if i > 0:
			s += ', '
		s += '...'

	if len(params) == 0:
		s += EMPTY_FUNC_PARAM

	s += ')'
	return s


def str_type_func(t, core='', need_close=False):
	fparams = t.params
	fto = t.to
	if t.to.is_array():
		# (!) HACK (!)
		# C не умеет возвращать массивы по значению,
		# поэтому если возвращаем массив вернем void
		# а сам массив пойдет через указатель sret_
		# который функция получит своим самым последним параметром
		# (sret = structure return)
		sret_param = Field(Id('sret_'), TypePointer(t.to), init_value=ValueUndef(t.to))

		fparams = t.params + [sret_param]
		fto = typeUnit

	paramlist = strFuncParamlist(fparams, t.extra_args)

	if need_close:
		core += ')'

	return str_type(fto, core=core+paramlist)



def str_pointer_chain(t):
	s = '*'
	if t.hasAttribute2('const'):
		s += 'const '
	if t.hasAttribute2('volatile'):
		s += 'volatile '
	if t.hasAttribute2('restrict'):
		s += 'restrict '

	if t.to.is_pointer():
		s = str_pointer_chain(t.to) + s

	return s


def str_type_pointer(t, core='', as_ptr_to_array=False):

	left = ''
	left = str_pointer_chain(t)

	root_type = t
	while root_type.is_pointer():
		root_type = root_type.to

	# (!) Печатать указатель на массив как указатель на его элемент (!)
	if not as_ptr_to_array:
		if is_sim_sim(t):
			root_type = root_type.of

	need_close = not is_type_named(root_type) and (root_type.is_array() or root_type.is_func())
	if need_close:
		left = '(' + left
	else:
		left = ' ' + left

	# К идентификатору вначале прибавляется пробел слева
	# но в случае * он лишний, так уж повелось в СИ
	nc = left+core
	if len(core) > 0:
		if core[0] == ' ':
			nc = left+core[1:]

	return str_type(root_type, core=nc, need_close=need_close)



def is_sim_sim(t):
	if t.is_pointer_to_array():
		return is_type_named(t.to.of)
	return False


def str_named(t, core=''):
	aka = get_type_id(t)
	if aka == None:
		return None
	pre = ''
	if t.hasAttribute2('const'):
		pre += 'const '
	if t.hasAttribute2('volatile'):
		pre += 'volatile '
	return pre + aka + core


def str_type(t, core='', need_close=False):
	if is_type_named(t):
		return str_named(t, core)
	elif t.is_pointer():
		return str_type_pointer(t, core)
	elif t.is_func():
		return str_type_func(t, core, need_close=need_close)
	elif t.is_array():
		return str_type_array(t, core, need_close=need_close)
	elif t.is_record():
		return str_type_record(t) + core
	return str(t)



def str_var(t, id_str):
	#if is_type_named(t) or not t.is_pointer():
	id_str =  ' ' + id_str
	return str_type(t, core=id_str)


def print_type(t):
	out(str_type(t))


def print_type_record(t, tag):
	out(str_type_record(t, tag=tag))




def eee(item_type):
	to = TypePointer(item_type, ti=None)
	return "(%s)" % str_type(to)


# Дополнительная чисто сишная надстройка -
# проверяем если у нас тут указатель на массив приводим к указателю на его элемент
def incast(type, value):
	if value.type.is_pointer_to_closed_array():
		# Это аргумент с типом указатель на массив
		# приведем его по месту к указателю на элемент этого массива
		# тк C живет по своим правилам и выкидывает warning чаще там где не надо
		return eee(value.type.to.of) + str_value(value)

	return str_value(value)





bin_ops = {
	HLIR_VALUE_OP_OR: '|', HLIR_VALUE_OP_XOR: '^', HLIR_VALUE_OP_AND: '&', HLIR_VALUE_OP_SHL: '<<', HLIR_VALUE_OP_SHR: '>>',
	HLIR_VALUE_OP_EQ: '==', HLIR_VALUE_OP_NE: '!=', HLIR_VALUE_OP_LT: '<', HLIR_VALUE_OP_GT: '>', HLIR_VALUE_OP_LE: '<=', HLIR_VALUE_OP_GE: '>=',
	HLIR_VALUE_OP_ADD: '+', HLIR_VALUE_OP_SUB: '-', HLIR_VALUE_OP_MUL: '*', HLIR_VALUE_OP_DIV: '/', HLIR_VALUE_OP_REM: '%',
	HLIR_VALUE_OP_LOGIC_AND: '&&', HLIR_VALUE_OP_LOGIC_OR: '||'
}


def str_value_bin(x, ctx):
	sstr = ''
	op = x.op
	left = x.left
	right = x.right

	# получаем приоритеты операции и операндов
	p0 = precedence(x)
	pl = precedence(left)
	pr = precedence(right)
	need_wrap_left = pl < p0
	need_wrap_right = pr < p0

	# GCC выдает warning например в: 1 << 2 + 2, тк считает
	# Что юзер имел в виду (1 << 2) + 2, а у << приоритет тние
	# чтобы он не ругался, завернем такие выражения в скобки

	if op in [HLIR_VALUE_OP_EQ, HLIR_VALUE_OP_NE]:
		if left.type.is_record():
			return str_value_eq_record(x, ctx)
		elif left.type.is_array():
			return str_value_eq_array(x, ctx)
		elif left.type.is_string():
			return str_value_literal_bool(x.asset)

	lk = ''
	if hasattr(left, 'op'):
		lk = left.op

	rk = ''
	if hasattr(right, 'op'):
		rk = right.op

	if op == HLIR_VALUE_OP_ADD:
		if left.type.is_array():
			return str_value_literal(x, ctx)

		if left.type.is_string():
			if left.type.width != right.type.width:
				# для случаев вроде "Hello" + U"World!"
				# (печатаем сам литерал, тк C иначе не умеет)
				# (U"Hello World!")
				#str_value_string(x, ctx)
				return str_value_literal_string(x.asset, char_width=x.type.width)

			sstr += str_value(left, parent_expr=x)
			sstr += ' '
			sstr += str_value(right, parent_expr=x)
			return sstr

	sstr += str_value(left, parent_expr=x)
	sstr += ' %s ' % bin_ops[op]
	sstr += str_value(right, parent_expr=x)
	return sstr


def str_value_shl(x, ctx):
	sstr = ''
	sstr += str_value(x.left, parent_expr=x)
	sstr += ' << '
	need_wrap_right = not x.right.__class__ in [ValueLiteral, ValueConst, ValueVar]
	sstr += str_value(x.right, parent_expr=x, wrapped=need_wrap_right)
	return sstr


def str_value_shr(x, ctx):
	sstr = ''
	sstr += str_value(x.left, parent_expr=x)
	sstr += (' >> ')
	need_wrap_right = not x.right.__class__ in [ValueLiteral, ValueConst, ValueVar]
	sstr += str_value(x.right, parent_expr=x, wrapped=need_wrap_right)
	return sstr


def str_value_eq_record(x, ctx):
	return str_value_eq_composite(x, ctx)


def str_value_eq_array(x, ctx):
	return str_value_eq_composite(x, ctx)


def str_value_eq_composite(x, ctx):
	op = x.op
	left = x.left
	right = x.right

	if x.isValueImmediate():
		return str_value_literal_bool(x.asset)

	# если сравниваем строки (Str8, Str16, Str32)
	if left.type.is_str() and right.type.is_str():
		return eq_str_by_strcmp(left, right, op=op)

	return eq_by_memcmp(left, right, op=op)


un_ops = {
	HLIR_VALUE_OP_REF: '&', HLIR_VALUE_OP_DEREF: '*',
	HLIR_VALUE_OP_POS: '+', HLIR_VALUE_OP_NEG: '-',
	HLIR_VALUE_OP_NOT: '~', HLIR_VALUE_OP_LOGIC_NOT: '!'
}



def str_value_not(x, ctx):
	sstr = ''
	if x.value.type.is_bool():
		sstr += '!'
	else:
		sstr += '~'
	sstr += str_value(x.value, parent_expr=x)
	return sstr


def str_value_neg(x, ctx):
	sstr = '-'
	sstr += str_value(x.value, parent_expr=x)
	return sstr


def str_value_pos(x, ctx):
	sstr = '+'
	sstr += str_value(x.value, parent_expr=x)
	return sstr


def str_value_ref(x, ctx):
	sstr = ''
	# Если берем указатель на массив массивов, то приводим его к void *
	# Т.к. в C нет указателя на массив массивов
	if x.value.type.is_array_of_array():
		sstr += ("(void *)")

	sstr += ('&')
	sstr += str_value(x.value, parent_expr=x)
	return sstr


def str_value_deref(x, ctx):
	sstr = ''
	sstr += ('*')
	sstr += str_value(x.value, parent_expr=x)
	return sstr


def str_value_call(v, ctx, sret=None):
	sstr = ''

	if v.isValueImmediate():
		return str_value_literal(v, ctx)

	left = v.func

	sstr += str_value(left)

	ftype = left.type
	if ftype.is_pointer():
		ftype = ftype.to
	params = ftype.params
	args = v.args
	n = len(args)

	sstr += ("(")

	nl_after = False

	i = 0
	while i < n:
		arg = args[i]
		param = None
		if i < len(params):
			param = params[i]
		sk = arg.nl > 0

		if i > 0:
			sstr += ","

		if sk:
			nl_after = True
			sstr += '\n' #* arg.nl
			indent_up()
			sstr += str_indent()
			indent_down()
		elif i > 0:
			sstr += " "

		a = arg.value
		param_id = arg.id

		#if arg.named:
			#sstr += "/*%s=*/" % param_id.str

		p_type = a.type
		if param != None:
			p_type = param.type

		sstr += incast(p_type, a)

		i = i + 1


	if sret != None:
		if i > 0:
			sstr += (", ")

		# приводим указатель на массив к указателю на его элемент
		#to = TypePointer(sret.type.of, sret.ti)
		#sstr += "(%s)" % str_type(to)

		sstr += eee(sret.type.of)
		sstr += str_value_as_ptr(sret)

	if nl_after:
		sstr += str_nl_indent()

	sstr += (")")
	return sstr




def str_value_slice(x, ctx):
	y = ValueIndex(x.type, x.left, x.index_from, ti=None)
	return str_value_index(y, ctx)


def str_value_new(x, ctx):
	t_str = str_type(x.value.type)
	return '(%s *)calloc(1, sizeof(%s))' % (t_str, t_str)



def str_value_index(x, ctx):
	left = x.left

	left_str = ''

	if left.is_global_flag and left.type.is_generic_array():
		ts = str_type(left.type)
		vs = str_value(left, ctx=ctx, parent_expr=x)
		left_str = '((%s)%s)' % (ts, vs)
	elif value_is_generic_immediate_const(left):
		ts = str_type(left.type)
		vs = str_value(left, ctx=ctx, parent_expr=x)
		left_str = '((%s)%s)' % (ts, vs)
	else:
		left_str = str_value(left, ctx=ctx, parent_expr=x)


	if left.type.is_pointer() and not is_sim_sim(left.type):
		left_str = "(*%s)" % left_str


	return left_str + '[' + str_value(x.index) + ']'



def str_value_access_module(x, ctx):
	return str_value(x.value, ctx)
	#left = x.imp['str']
	#id_str = x.id['str']
	#return "%s_%s" % (left, id_str)


def str_value_access(x, ctx):
	sstr = ''
	left = x.left

	# если имеем дело c константной записью (глоб константа)
	# и результат операции доступа - константа которая уже тут
	#if left.type.is_generic():
	#	if x.isValueImmediate():
	if not left.isValueConst():
		if value_is_generic_immediate(left):
			return str_value_literal(x, [])

	if value_is_generic_immediate_const(left):
		ts = str_type(left.type)
		vs = str_value(left, ctx=ctx, parent_expr=x)
		sstr += '((%s)%s)' % (ts, vs)
	else:
		sstr += str_value(left, parent_expr=x)

	if left.type.is_pointer():
		sstr += ('->')
	else:
		sstr += ('.')

	sstr += get_id_str(x.field)
	return sstr



def str_cast(t, v, rawMode=False, ctx=[]):
	sstr = ''

	if rawMode:
		assert(is_local_context())
		sstr += "*(" + str_type(t) + "*)&"
	else:
		sstr += "(" + str_type(t) + ")"

	need_wrap = precedence(v) < CONS_PRECEDENCE
	sstr += str_value(v, ctx=ctx, wrapped=need_wrap)
	return sstr



def str_value_cons_record(x, ctx):
	sstr = ''
	to_type = x.type
	value = x.value
	from_type = value.type

	if from_type.is_generic_record():
		if is_local_context():
			return str_cast(to_type, value)
		else:
			return str_value(value, ctx=ctx)

	# RecordA -> RecordB
	#if to_type.is_record():
	if from_type.is_record():
		if to_type.uid == from_type.uid:
			# это реально одна и та же структура (просто возм ее копия)
			# и приведение не требуется
			return str_value(value, ctx=ctx)
		# C cannot cast struct to struct (!)
		return str_cast(to_type, value, rawMode=True)



def str_value_cons_array(x, ctx):
	sstr = ''
	to_type = x.type
	value = x.value
	from_type = value.type

	# Local:
	# В C мы не можем просто напечатать {0, 1, 2, 3} и получить массив
	# Но мы можем сделать так: (<item_type>[4]){0, 1, 2, 3}
	# But in Global:
	# печатаем как есть, иначе ошибка (о Боже C это нечто!):
	# {0, 1, 2, 3}
	#if is_global_context():
	if from_type.is_generic_array():
		# если это литеральная (и не глобальная) константа-массив
		# то мы должны ее привести к требуемому типу
		#is_const = value['kind'] in ['const', 'literal', HLIR_VALUE_OP_ADD]

		if is_global_context():
			if value.isValueRuntime() or value.isValueLinktime():
				return str_value(value, ctx=ctx)

		is_const = value.isValueLiteral() or value.isValueConst() or (value.isValueBin() and value.op == HLIR_VALUE_OP_ADD)

		if is_const:
			ctx=['array_as_array']

			if to_type.of.is_char():
				if from_type.of.is_string():
					chars = []
					for item in value.asset:
						ch = item.asset
						chars.append(ch)

					char_width = to_type.of.width
					return str_value_literal_string(chars, char_width=char_width)

			return str_cast(to_type, value, ctx=ctx)
		else:
			return str_value(value, ctx=ctx)
		return '<??>'


	if from_type.is_string():
		if to_type.of.is_char():
			# cast <string literal> to <array of chars>:
			if to_type.of.width == from_type.width:
				return str_value(value, ctx=ctx)
			else:
				return cstr(value, to_type.of.width)
			return '<???>'

	# for:
	#    var x: [10]Word8 = "0123456789"
	if value.type.is_string():
		return str_value(value, ctx=ctx)


	return str_cast(to_type, value, ctx)



# *[]Char8 -> *Char8
#def ptr2arr_to_ptr2item(x):
#	if x.type.is_pointer_to_array():
#	arr_item_type = x.type.to.of
#	t = TypePointer(arr_item_type, ti=x.ti)
#	from value.cons import value_cons
#	return value_cons(t, x, 'explicit', ti=x.ti)
#


# Выводит строковой литерал C.
# В случае когда размер символа больше 8 бит,
# оборачивает его макросом STR<X>()
def cstr(value, sz):
	if sz > 8:
		return "_STR%d(%s)" % (sz, str_value(value))
	return str_value(value)


# Выводит строковой литерал C и превращает его в char
# В случае когда размер символа больше 8 бит,
# оборачивает его макросом CHR<X>()
def cchr(value, sz):
	#if sz > 8:
	#	return "_CHR%d(%s)" % (sz, str_value(value))

	if value.isValueLiteral():
		if value.type.is_string():
			return str_value_literal_char(ord(value.asset[0]), sz)

	return "_CHR%d(%s)" % (sz, str_value(value))



def str_value_cons(x, ctx):
	type = x.type
	value = x.value
	from_type = value.type

	if type.is_array():
		return str_value_cons_array(x, ctx)

	if type.is_record():
		return str_value_cons_record(x, ctx)

	if type.is_distinct():
		return str_cast(type, value, ctx)

	if type.is_char() and from_type.is_string():
		return cchr(value, type.width)


	if value.isValueLiteral() and from_type.is_generic():
		if x.asset != None:
			as_hex = type.is_word() or value.hasAttribute2('hexadecimal')
			return str_value_literal_with_type(value, type, as_hex=as_hex)


	# *RecordA -> *RecordB
	# у нас типы структурные, а в си - номинальные
	# поэтому даже если структуры одинаковы, но имена разные
	# - их нужно жестко приводить
	if type.is_pointer_to_record() and from_type.is_pointer_to_record():
		if (from_type.to.definition != type.to.definition):
			return str_cast(type, value, ctx)

	elif type.is_pointer_to_array():
		if from_type.is_string():
			return cstr(value, type.to.of.width)


	elif type.is_xword() and from_type.is_xword():
		if from_type.is_generic():
			return str_value(value)
		if get_id_str(type) == get_id_str(from_type):
			return str_value(value)


	if x.method in ['implicit', 'default']:
		if value.isValueRef():
		#if value.type.is_pointer_to_array():
			# Для C явно приводим указатель на массив к указателю на его элемент
			# В случае когда происходит НЕЯВНОЕ приведение;
			if value.type.is_pointer_to_array():
				return str_cast(type, value, ctx)

		return str_value(value)


	if value.isValueLiteral():
		return str_value(value)

	# (!) WARNING (!)
	# - in C  int32(-1) -> uint64 => 0xffffffffffffffff
	# - in Cm Int32(-1) -> Word64 => 0x00000000ffffffff
	# - in Cm Int32(-1) -> Nat64 => 1
	# required: (uint64_t)((uint32)int32_value)
	#if type.is_int():
	if from_type.is_int() or from_type.is_number():
		if from_type.is_signed():
			if type.is_nat():
				if value.type.width <= 32:
					return "(" + str_type(type) + ")" + "abs((int)" + str_value(value) + ")"
				elif value.type.width <= 64:
					return "(" + str_type(type) + ")" + "llabs((long long int)" + str_value(value) + ")"
				else:
					return "(" + str_type(type) + ")" + "llabs(" + str_value(value) + ")"

			elif type.is_word():
				if from_type.size < type.size:
					nat_same_sz = type_select_nat(from_type.width)
					return "(" + str_type(type) + ")" + str_cast(nat_same_sz, value, ctx)

	# for: (uint32_t *)(void *)&i;
	# remove (void *)  ^^^^^^^^
	if value.isValueCons():
		if value.type.is_free_pointer():
			value = value.value

	return str_cast(type, value, rawMode=x.rawMode, ctx=ctx)



def is_zero_tail(values, i, n):
	# если это значание - zero, проверим все остальные справа
	# и если они тоже zero - их можно не печатать (zero tail)
	# ex: {'a', 'b', '\0', '\0', '\0'} -> {'a', 'b', '\0'}
	while i < n:
		v = values[i]
		if not v.isValueZero():
			return False
		i = i + 1
	return True



def print_literal_array_items(values, item_type):
	sstr = ''
	i = 0
	n = len(values)
	while i < n:
		a = values[i]

		nl = a.nl
		if nl > 0:
			sstr += str_nl_indent(nl=nl)
		else:
			if i > 0:
				sstr += " "

		if a.type.is_closed_array():
			sstr += '{' + print_literal_array_items(a.asset, item_type.of) + '}'
		else:
			sstr += str_value(a) #incast(item_type, a)

		i = i + 1

		# если это значание - zero, проверим все остальные справа
		# и если они тоже zero - их можно не печатать (zero tail)
		# ex: {'a', 'b', '\0', '\0', '\0'} -> {'a', 'b', '\0'}
		if a.isValueZero():
			if is_zero_tail(values, i, n):
				return sstr

		if i < n:
			sstr += (',')

	return sstr



def str_value_literal_string(chars, char_width):
	utf32_codes = []
	for ch in chars:
		cc = ord(ch)
		utf32_codes.append(cc)
	return print_utf32codes_as_string(utf32_codes, char_width)



def str_value_literal_char(cc, width):
	return string_literal_prefix(width) + print_utf32codes_as_string([cc], width, quote="'")



def str_value_literal_array(x, type, items, nl_end=1):
	sstr = ''

	#if not x.isValueImmediate():
	#	sstr += '(%s)' % str_type(type)

	if type.is_array_of_char() and x.isValueImmediate():
		char_type = type.of
		char_width = char_type.width

		# массивы чаров в конце которых только один терминальный ноль
		# печатаем в виде строковых литералов C
		n = len(items)
		if n > 0:
			utf32_codes = []
			i = 0
			while i < n:
				cc = items[i].asset
				utf32_codes.append(cc)
				if cc == 0:
					if is_zero_tail(items, i, n):
						break

				i = i + 1
			return print_utf32codes_as_string(utf32_codes, width=char_width)

	nl_end_e = 0
	for item in items:
		if item.nl > 0:
			nl_end_e = 1

	if len(items) == 0:
		return EMPTY_ARRAY_LITERAL

	sstr += "{"
	indent_up()
	sstr += print_literal_array_items(items, type.of)
	indent_down()
	if nl_end_e > 0:
		sstr += str_nl_indent(nl=nl_end_e)
	sstr += "}"
	return sstr



def str_value_literal_record(type, items):
	nitems = len(items)
	if nitems == 0:
		return EMPTY_RECORD_LITERAL

	sstr = "{"

	nl_end = 0
	# for situation when firat item is ValueZero
	# without it, forst value will be printed with space before it.
	item_printed = False

	indent_up()

	i = 0
	while i < nitems:
		item = type.fields[i]
		field_id_str = get_id_str(item)
		ini = get_item_by_id(items, field_id_str)

		nl = ini.nl
		if nl > 0:
			nl_end = 1
			sstr += str_nl_indent(nl=nl)
		else:
			if item_printed:
				sstr += " "

		sstr += ".%s = %s" % (field_id_str, str_value(ini.value))

		if i < (nitems - 1):
			sstr += ","

		item_printed = True
		i = i + 1

	indent_down()

	if nl_end > 0:
		sstr += str_nl_indent(nl=nl_end)
	sstr += "}"

	#if cast_req:
	#	out(")")
	return sstr


def string_literal_prefix(width):
	if width > 16: return "U"
	if width > 8: return "u"
	return ""


def code_to_char(cc):
	if cc < 0x20:
		if cc == 0x07: return "\\a"    # bell
		elif cc == 0x08: return "\\b"  # backspace
		elif cc == 0x09: return "\\t"  # horizontal tab
		elif cc == 0x0A: return "\\n"  # line feed
		elif cc == 0x0B: return "\\v"  # vertical tab
		elif cc == 0x0C: return "\\f"  # form feed
		elif cc == 0x0D: return "\\r"  # carriage return
		elif cc == 0x1B: return "\\e"  # escape
		else: return "\\x%X" % cc

	elif cc <= 0x7E :
		sym = chr(cc)
		if sym == '\\': return '\\\\'
		elif sym == '"': return '\\"'
		else: return sym

	elif cc != 0:
		return chr(cc)


def print_utf32codes_as_string(utf32_codes, width=8, quote='"'):
	sstr = ''
	prefix = ''#string_literal_prefix(width)
	sstr = prefix
	sstr += quote
	for cc in utf32_codes:
		sstr += code_to_char(cc)
	sstr += quote
	return sstr



def str_value_literal_bool(num):
	#print("str_value_literal_bool")
	if num:
		return csettings['true_literal']
	else:
		return csettings['false_literal']


def str_value_enum(x, ctx):
	return get_id_str(x)



def str_value_literal_suffix(to_type, num):
	req_bits = nbits_for_num(num)

	if req_bits < csettings['int_width']:
		return ""

	sstr = ''
	if not to_type.is_signed():
		sstr = "U"

	if req_bits <= csettings['long_width']:
		sstr += "L"   # long int
	elif req_bits <= csettings['long_long_width']:
		sstr += "LL"  # long long int
	else:
		sstr += "XL"  # extra long int (not defined in C)

	return sstr


def str_value_literal_number(type, num, nsigns=0, is_big=False, is_hex=False):
	global need_big_int
	sstr = ''
	# Big Number?
	if type.width > 64:
		# print Big Numbers
		a1 = (num >> 64) & 0xFFFFFFFFFFFFFFFF
		a0 = (num >>  0) & 0xFFFFFFFFFFFFFFFF
		if type.width == 128:
			return "BIG_INT128(0x%XULL, 0x%XULL)" % (a1, a0)
		elif type.width == 256:
			a3 = (num >> 192) & 0xFFFFFFFFFFFFFFFF
			a2 = (num >> 128) & 0xFFFFFFFFFFFFFFFF
			return "BIG_INT256(0x%XULL, 0x%XULL, 0x%XULL, 0x%XULL)" % (a3, a2, a1, a0)

	if is_hex:
		fmt = "0x%%0%dX" % nsigns
		sstr += (fmt % num)
	else:
		sstr += str(num)

	sstr += str_value_literal_suffix(type, num)

	return sstr



def str_value_literal_float(num):
	return '{0:f}'.format(num)


def str_value_literal_pointer(type, num):
	if num == 0:
		return "NULL"
	return "((" + str_type(type) + ")0x%08X)" % num


def str_value_literal(x, ctx):
	return str_value_literal_with_type(x, x.type)


def str_value_literal_with_type(x, t, as_hex=False):
	asset = x.asset

	if t.is_arithmetical() or t.is_number() or t.is_word():
		as_hex = as_hex or x.type.is_word() or x.hasAttribute2('hexadecimal')
		return str_value_literal_number(t, asset, is_hex=as_hex)

	elif t.is_float(): return str_value_literal_float(asset)
	elif t.is_string(): return str_value_literal_string(asset, char_width=t.width)
	elif t.is_record(): return str_value_literal_record(t, asset)
	elif t.is_array(): return str_value_literal_array(x, t, asset)
	elif t.is_bool(): return str_value_literal_bool(asset)
	elif t.is_char(): return str_value_literal_char(asset, t.width)
	elif t.is_pointer(): return str_value_literal_pointer(t, asset)
	else: error("str_value_literal not implemented for %s" % str(t), x.ti)

	return "<ValueLiteral>"



def str_value_const(x, ctx):
	#if value_is_generic_immediate(x):
	#	return str_value_literal(x, ctx)
	id_str = get_id_str(x)
	if x.is_global_flag and not x.id.hasAttribute('nodecorate'):
		return camel_to_snake(id_str)
	return id_str


def str_value_var(x, ctx):
	return get_id_str(x)

def str_value_func(x, ctx):
	return get_id_str(x)


def str_value_sizeof_value(x, ctx):
	sstr = "sizeof "
	sstr += str_value(x.of)
	return sstr


def str_value_sizeof_type(x, ctx):
	sstr = "sizeof("
	sstr += str_type(x.of)
	sstr += ")"
	return sstr


def str_value_alignof(x, ctx):
	sstr = "__alignof("
	sstr += str_type(x.of)
	sstr += ")"
	return sstr


def str_value_offsetof(x, ctx):
	sstr = "__offsetof("
	sstr += str_type(x.of)
	sstr += ", "
	sstr += x.field.str
	sstr += ")"


def str_value_lengthof(x, ctx):
	if value_is_generic_immediate_const(x.value):
		if not x.value.type.is_string():
			return str(x.value.type.volume.asset)

	# generic array в си это просто макрос вида {1, 2, 3}
	# и его нельзя подставить в LENGTHOF (!)
	if x.value.isValueDeref() or x.type.is_generic_array():
		# решает проблему когда массив представлен указателем на элемент
		return str_value(x.value.type.volume)

	value = x.value
	sstr = ""
	if value.type.is_generic_array():
		ts = str_type(value.type)
		vs = str_value(value, ctx=ctx, parent_expr=x)
		sstr = '((%s)%s)' % (ts, vs)
	else:
		sstr += str_value(value)
	return "LENGTHOF(%s)" % sstr



def str_value_va_start(x, ctx):
	sstr = "va_start("
	sstr += str_value(x.va_list)
	sstr += ", "
	sstr += str_value(x.last_param)
	sstr += ")"
	return sstr


def str_value_va_arg(x, ctx):
	sstr = "va_arg("
	sstr += str_value(x.va_list)
	sstr += ", "
	sstr += str_type(x.type)
	sstr += ")"
	return sstr


def str_value_va_end(x, ctx):
	sstr = "va_end("
	sstr += str_value(x.va_list)
	sstr += ")"
	return sstr


def str_value_va_copy(x, ctx):
	sstr = "va_copy("
	sstr += str_value(x.dst)
	sstr += ", "
	sstr += str_value(x.src)
	sstr += ")"
	return sstr


def str_value_subexpr(x, ctx):
	sstr = "("
	sstr += str_value(x.value)
	sstr += ")"
	return sstr


def str_value(x, ctx=[], parent_expr=None, wrapped=False):
	sstr = ''
	need_wrap = False
	if wrapped:
		need_wrap = True
	if parent_expr != None:
		need_wrap = precedence(x) < precedence(parent_expr)

	if need_wrap:
		sstr += "("

	#if hasattr(x, 'id'):
	#if x.id != None:
	#	print(x)
	#	sstr += get_id_str(x)
	if x.isValueLiteral():
		sstr += str_value_literal(x, ctx)
	elif x.isValueBin():
		sstr += str_value_bin(x, ctx)
	elif x.isValueShl():
		sstr += str_value_shl(x, ctx)
	elif x.isValueShr():
		sstr += str_value_shr(x, ctx)
	elif x.isValueRef():
		sstr += str_value_ref(x, ctx)
	elif x.isValueDeref():
		sstr += str_value_deref(x, ctx)
	elif x.isValueCons():
		sstr += str_value_cons(x, ctx)
	elif x.isValueFunc():
		sstr += str_value_func(x, ctx)
	elif x.isValueVar():
		sstr += str_value_var(x, ctx)
	elif x.isValueConst():
		sstr += str_value_const(x, ctx)
	elif x.isValueCall():
		sstr += str_value_call(x, ctx)
	elif x.isValueIndex():
		sstr += str_value_index(x, ctx)
	elif x.isValueAccessModule():
		return str_value_access_module(x, ctx)
	elif x.isValueAccessRecord():
		sstr += str_value_access(x, ctx)
	elif x.isValueSlice():
		sstr += str_value_slice(x, ctx)
	elif x.isValueSubexpr():
		sstr += str_value_subexpr(x, ctx)
	elif x.isValueNot():
		sstr += str_value_not(x, ctx)
	elif x.isValueNeg():
		sstr += str_value_neg(x, ctx)
	elif x.isValuePos():
		sstr += str_value_pos(x, ctx)
	elif x.isValueNew():
		sstr += str_value_new(x, ctx)
	elif x.isValueSizeofValue():
		sstr += str_value_sizeof_value(x, ctx)
	elif x.isValueSizeofType():
		sstr += str_value_sizeof_type(x, ctx)
	elif x.isValueAlignof():
		sstr += str_value_alignof(x, ctx)
	elif x.isValueOffsetof():
		sstr += str_value_offsetof(x, ctx)
	elif x.isValueLengthof():
		sstr += str_value_lengthof(x, ctx)
	elif x.isValueVaArg():
		sstr += str_value_va_arg(x, ctx)
	elif x.isValueVaStart():
		sstr += str_value_va_start(x, ctx)
	elif x.isValueVaEnd():
		sstr += str_value_va_end(x, ctx)
	elif x.isValueVaCopy():
		sstr += str_value_va_copy(x, ctx)
	else:
		sstr += str(x)

	if need_wrap:
		sstr += ")"

	return sstr


def print_value(x, ctx=[], parent_expr=None):
	out(str_value(x, ctx=ctx, parent_expr=parent_expr))


#
# Stmt
#


def print_stmt_if(x, need_else_branch):
	out("if (")
	print_value(x.cond)
	out(")")

	if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
		nl_indent()
	else:
		out(" ")

	print_stmt_block(x.then)

	e = x.els
	if e != None:
		if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
			nl_indent()
		else:
			out(" ")

		if e.is_stmt_if():
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
	out("while (")
	print_value(x.cond)
	out(")")

	if styleguide['LINE_BREAK_BEFORE_BLOCK_BRACE']:
		nl_indent()
	else:
		out(" ")

	print_stmt_block(x.stmt)



def print_stmt_return(x):
	global cfunc

	if isSretFunc(cfunc.type):
		out("memcpy(sret_, ")
		out(str_value_as_ptr(x.value))
		out(", sizeof(")
		print_type(x.value.type)
		out("));")
		return

	out("return")

	if x.value != None:
		out(" ")
		out(incast(cfunc.type.to, x.value))

	out(";")



def print_stmt_var(x):
	var_value = x.value
	init_value = x.init_value

	print_variable(get_id_str(var_value), var_value.type)

	if init_value.isValueUndef():
		# инициализация неопределенным значением
		# (отсутствие явной инициализации)
		out(";")
		return

	if var_value.type.is_array():
		if init_value.isValueRuntime() or var_value.type.is_vla():
			# нельзя присваивать VLA значение при создании...
			# только после можно уже что то туда загрузить
			out(";")
			nl_indent()
			assign_array(var_value, init_value, x.ti)
			out(";")
			return

	out(" = ")
	if init_value.type.is_closed_array():
		out(str_static_initializer(init_value))
	else:
		print_value(init_value)
	out(";")
	return



def print_macro_definition(id_str, value, val_ctx=[], prefix=''):
	global nl_str
	out("#define %s%s  " % (prefix, id_str))

	# нельзя оборачивать круглыми скобками литерал массива или структуры
	# иначе при его прведении по месту к конкретному типу си сойдет с ума
	need_wrap = False

	# Не берем в скобки литералы, композитные значения и строки
	is_func = value.isValueFunc()
	is_var = value.isValueVar()
	is_const = value.isValueConst()
	is_literal = value.isValueLiteral()
	is_comp = value.type.is_composite()

	is_str = value.type.is_string()

	if not (is_literal or is_comp or is_str or is_const or is_var or is_func):
		need_wrap = precedence(value) < precedenceMax

	set_nl_symbol(" \\\n")
	out(str_value(value, wrapped=need_wrap))

	#out("/*%s*/" % str_type(value.type))
	set_nl_symbol("\n")


def undef(identifier):
	out("\n#undef %s" % identifier)


def print_stmt_const(x):
	id = x.id
	const_value = x.value
	init_value = x.init_value

	# print generic constant as C macro
	if value_is_generic_immediate(const_value):
		#if const_value.type.is_composite() or const_value.type.is_string():
		id_str = get_id_str(const_value)
		# если точный тип константы неизвестен - печатаем ее как макро
		print_macro_definition(id_str, init_value)
		global func_undef_list
		func_undef_list.append(id_str)
		return

	# print constant as 'variable'
	# литерал массива включающий в себя переменные печатаем отдельно
	if init_value.type.is_array():
		runtimeLiteral = init_value.isValueLiteral() and init_value.isValueRuntime()
		if not runtimeLiteral:
			print_variable(get_id_str(x), const_value.type)
			out(";")
			nl_indent()
			do_assign(const_value, init_value, x.ti)
			return

	# Локальные константы (втч. композитные) печатаем как переменные
	# ПОТОМУ ЧТО: они должны "заморозить" свои значения по месту
	print_variable(get_id_str(x), const_value.type)
	out(" = ")
	out(incast(const_value.type, init_value))
	#print_value(init_value)
	out(";")
	return



# prints pair: <specifier> (<value>)
def print_asm_pair(pair):
	print_value(pair[0])
	out(' (')
	print_value(pair[1])
	out(')')


def print_stmt_asm(x):
	out('__asm__ volatile (')
	indent_up()
	nl_indent(1)
	out(str_value_literal_string(x.text.asset, char_width=x.text.type.width))

	# print 'out' pairs
	args1 = x.outputs
	if len(args1) > 0:
		nl_indent(1)
		out(': ')
		print_list_by(args1, print_asm_pair)
	else:
		out(':')

	# print 'in' pairs
	args2 = x.inputs
	if len(args2) > 0:
		nl_indent(1)
		out(': ')
		print_list_by(args2, print_asm_pair)
	else:
		out(':')

	# print clobber list
	if len(x.clobbers) > 0:
		nl_indent(1)
		out(': ')
		print_list_by(x.clobbers, print_value)


	indent_down()
	nl_indent(1)
	out(");")
	return



def str_array_len(array_value):
	slen = "<slen>"
	if array_value.isValueImmediate():
		slen = str(array_value.type.volume.asset)
	elif array_value.isValueSlice():
		slen = str_value(array_value.type.volume)
	else:
		slen = "LENGTHOF(" + str_value(array_value) + ')'
	return slen



def assign_array(left, right, ti):
	# если справа 'обернутое' значение
	# (для того чтобы в C вернуть массив из функции
	# его нужно 'обернуть' в структуру)
	if right.isValueCall():
		out(str_value_call(right, [], sret=left))
		return

	rv = get_root_value(right)
	if rv.isValueZero():
		memzero(left)
		return

	if right.isValueCons():
		# Если справа приведенный к левому массив (более короткий? Generic)
		right = get_root_value(right)


	sleft = str_value_as_ptr(left)
	sright = str_value_as_ptr(right)


	slen = None
	if left.isValueVar() or left.isValueConst():
		slen = str_array_len(left)
	else:
		slen = str_value(left.type.volume)

	l_root = get_root_value(left)
	r_root = get_root_value(right)

	#if Type.eq(l_root.type, r_root.type):
	if l_root.type.of.size == r_root.type.of.size:
		assign_by_memcopy(left, right)
		return

#	if right.isValueConst():
#		out("/*CONST*/")
#		assign_by_memcopy(left, right)
#		return

	out("ARRCPY(%s, %s, %s)" % (sleft, sright, slen))
	return


def do_assign(left, right, ti):
	if right.type.is_array():
		assign_array(left, right, ti)
	else:
		print_value(left)
		out(" = ")
		print_value(right)
	out(";")
	return


def print_stmt_assign(x):
	do_assign(x.left, x.right, x.ti)


def print_stmt_value(x):
	print_value(x.value); out(";")


def print_stmt(x):
	assert(isinstance(x, Stmt))
	nl_indent(x.nl)
	if x.is_stmt_block(): print_stmt_block(x)
	elif x.is_stmt_value_expr(): print_stmt_value(x)
	elif x.is_stmt_assign(): print_stmt_assign(x)
	elif x.is_stmt_return(): print_stmt_return(x)
	elif x.is_stmt_if(): print_stmt_if(x, need_else_branch=False)
	elif x.is_stmt_while(): print_stmt_while(x)
	elif x.is_stmt_def_var(): print_stmt_var(x)
	elif x.is_stmt_def_const(): print_stmt_const(x)
	elif x.is_stmt_break(): print_stmt_break(x)
	elif x.is_stmt_again(): print_stmt_again(x)
	elif x.is_stmt_comment(): print_comment(x)
	elif x.is_stmt_def_type(): print_def_type(x)
	elif x.is_stmt_asm(): print_stmt_asm(x)
	else: lo("<stmt %s>" % str(x))


def print_stmt_break(x):
	out('break;')


def print_stmt_again(x):
	out('continue;')


def print_stmts(stmts):
	for stmt in stmts:
		print_stmt(stmt)


def print_stmt_block(s):
	out("{")
	nl_end_e = 1
	indent_up()
	print_stmts(s.stmts)
	indent_down()

	nl_indent(nl=nl_end_e)
	#newline(n=nl_end_e)
	#if nl_end_e > 0:
	#	indent()
	out("}")



# Функция возвращает массив по значению?
def isSretFunc(ftype):
	return ftype.to.is_closed_array()


def print_func_return_type(ftype):
	if not isSretFunc(ftype):
		print_type(ftype.to)
		return

	out("void")
	return


def print_func_paramlist(ftype):
	params = ftype.params
	extra_args = ftype.extra_args

	out("(")

	if isSretFunc(ftype):
		print_variable("sret_", ftype.to)
		if len(params) > 0:
			out(", ")

	i = 0
	for param in params:
		if i > 0: out(", ")

		paramId = get_id_str(param)
		if param.type.is_closed_array():
			paramId = '_' + paramId
		print_variable(paramId, param.type)
		i = i + 1

	if extra_args:
		out(", ...")

	out(")")
	return


def print_func_signature(id_str, ftype):
	out(str_var(ftype, id_str=id_str))




def print_decl_func(x):
	#if 'gnu_att' in x:
	#	out('__attribute__((%s))\n' % x['gnu_att'])

	if not x.hasAttribute2('extern'):
		if x.access_level == HLIR_ACCESS_LEVEL_PRIVATE:
			out("static ")

	if x.hasAttribute2('inline'):
		out("inline ")

	ftype = x.value.type
	id_str = get_id_str(x.value)
	print_func_signature(id_str, ftype)
	out(";")




def print_def_func(x):
	global declared

	func = x.value

	global cfunc
	cfunc = func

	if x.getAnnotation('conditional') != None:
		a = x.getAnnotation('conditional')
		out("#if (%s)\n" % str_value(a))

	if x.hasAttribute2('inline'):
		out("__attribute__((always_inline))\n")

	if x.hasAttribute2('noinline'):
		out("__attribute__((noinline))\n")

	#if 'gnu_att' in x:
	#	out('__attribute__((%s))\n' % x['gnu_att'])

	if not x.hasAttribute2('extern'):
		if x.access_level == HLIR_ACCESS_LEVEL_PRIVATE:
			out("static ")

	if x.hasAttribute2('inline') or x.hasAttribute2('inlinehint'):
		out("inline ")

	if x.hasAttribute2('extern'):
		out("extern ")

	ftype = func.type

	# если функция уже была определена, то обертки над ее типами
	# уже были напечатаны (если они были), и их нельзя печатать еще раз
	#print_wrappers = not 'declared' in func['att']
	print_func_signature(get_id_str(func), ftype)

	if x.stmt == None:
		cfunc = None
		out(";")
		return

	if styleguide['LINE_BREAK_BEFORE_FUNC_BRACE']:
		newline()
	else:
		out(" ")

	out("{")
	indent_up()


	# for any array parameter print local holder value
	for param in ftype.params:
		if param.type.is_closed_array():
			nl_indent(1)
			paramId = get_id_str(param)
			print_variable(paramId, param.type)
			out(";")
			nl_indent(1)
			out("memcpy(%s, %s" % (paramId, '_' + paramId))
			out(", sizeof(")
			print_type(param.type)
			out("));")


	stmts = x.stmt.stmts
	print_stmts(stmts)

	indent_down()

	global func_undef_list
	if len(func_undef_list) > 0:
		newline()
		for id_str in func_undef_list:
			undef(id_str)

	func_undef_list = []
	out("\n}\n")

	if x.getAnnotation('conditional') != None:
		a = x.getAnnotation('conditional')
		out("\n#endif /* %s */" % str_value(a))

	if not func.id.str in declared:
		declared.append(func.id.str)

	cfunc = None



def print_decl_type(x):
	id_str = get_id_str(x.type)
	out("struct %s;" % id_str)
	if not NO_TYPEDEF_STRUCTS:
		out("\ntypedef struct %s %s;" % (id_str, id_str))


def print_def_type(x):
	global declared

	id_str = get_id_str(x.type)
	otype = x.original_type

	if otype.is_record() and otype.is_anonymous():
		print_type_record(otype, tag=id_str)
		out(";")
		if not id_str in declared:
			nl_indent()
			out("typedef struct %s %s;" % (id_str, id_str))
		return

	out("typedef ")
	out(str_var(otype, id_str=id_str))
	out(";")



# Указатель, массив и функция образуют пиздецовый заговор
def print_variable(id_str, t, init_value=None, prefix=''):
	assert (t != None)
	out(str_var(t, id_str=(prefix + id_str)))
	if init_value != None:
		out(" = ")
		print_value(init_value)


def print_def_var(x, isdecl=False, as_extern=False):
	#if 'gnu_att' in x:
	#	out('__attribute__((%s))\n' % x['gnu_att'])

	if x.hasAttribute2('used'):
		out("__attribute__((used))\n")

	if x.hasAttribute2('unused'):
		out("__attribute__((unused))\n")

	if x.hasAttribute2('section'):
		section = x.getAnnotation('section')
		out("__attribute__((section(\"%s\")))\n" % section.asset)

	if x.hasAttribute2('alignment'):
		alignment = x.getAnnotation('alignment')
		out("__attribute__((aligned(%d)))\n" % alignment.asset)

	# TODO: Почему-то атрибут 'extern' не работает, и накостылил через as_extern
	is_extern = x.hasAttribute2('extern') or as_extern

	var = x.value

	if x.access_level == HLIR_ACCESS_LEVEL_PRIVATE:
		if not (is_extern or x.hasAttribute2('nonstatic')):
			out("static ")

	if is_extern:
		out("extern ")

	print_variable(get_id_str(x.value), var.type)

	init_value = x.init_value

	if not (init_value.isValueUndef() or is_extern):
		out(" = ")
		out(str_static_initializer(init_value))
	out(";")




# В C нельзя присвоить глобальной переменной/константе композитное значение
# но можно присвоить литерал композитного значения который не приведен к конкр. типу:
# .arr = (uint8_t [3]){1, 2, 3}  // not worked
# .arr = {1, 2, 3}  // worked
def str_static_initializer(v):
	#mass
	if v.type.is_char():
		return str_value(v, [])
	if v.type.is_pointer_to_str():
		return str_value(v, [])

	if v.isValueCons():
		root = get_root_value(v)
		if root.type.is_string():
			# just string literal
			return str_value(v, [])

	root = get_root_value(v)

	if value_is_generic_immediate_const(root):
		return str_value(root, [])

	if root.isValueImmediate():
		if v.type.is_composite():
			s = str_value_literal(root, [])
			if root.type.is_string():
				left_char_width = 0
				if v.type.is_array():
					left_char_width = v.type.of.width
				elif v.type.is_str():
					left_char_width = v.type.width

				if not s[0] in ['u', 'U']:
					s = string_literal_prefix(left_char_width) + s
			return s

	return str_value(v)


def print_def_const(x):
	id_str = camel_to_snake(get_id_str(x.value))
	print_macro_definition(id_str, x.init_value, val_ctx=[])
	module_undef_list.append(id_str)
	return


already_included = []
def include(path, local=True):
	if path in already_included:
		return

	if local:
		include_text = "\n#include \"%s\"" % path
	else:
		include_text = "\n#include <%s>" % path

	already_included.append(path)
	out(include_text)



def print_insert(x):
	out(x['str'])


def print_comment(x):
	out(str_stmt_comment(x))


def str_stmt_comment(x):
	if isinstance(x, StmtCommentLine):
		return str_comment_line(x)
	elif isinstance(x, StmtCommentBlock):
		return str_comment_block(x)
	return None


def str_comment_block(x):
	return "/*%s*/" % x.text


def str_comment_line(x):
	lines = x.lines
	i = 0
	n = len(lines)
	s = ''
	while i < n:
		line = lines[i]
		s += "//%s" % line
		i = i + 1
		if i < n:
			s += str_nl_indent()
	return s


def print_cdecl_type(x):
	newline(n=x.nl)

	id_str = get_id_str(x.type)
	out("struct %s;" % id_str)
	if not NO_TYPEDEF_STRUCTS:
		out("\ntypedef struct %s %s;" % (id_str, id_str))


def print_cdecl_func(x):
	newline(n=x.nl)

	#if 'gnu_att' in x:
	#	out('__attribute__((%s))\n' % x['gnu_att'])

	if x.access_level == HLIR_ACCESS_LEVEL_PRIVATE:
		out("static ")

	print_func_signature(get_id_str(sym), x['symbol']['type'])
	out(";")



def print_directive(x):
	if isinstance(x, StmtDirectiveInsert):
		out(x.text)
		newline()



def is_private(x):
	if isinstance(x, StmtDef):
		return x.access_level == HLIR_ACCESS_LEVEL_PRIVATE
	return False


def print_deps(deps):
	global declared
	if len(deps) == 0:
		return

	# печатаем декларации для типов от которых зависит этот тип
	for dep in deps:
		if dep.id == None:
			error("undefined", dep.ti)
			return

		out("\n")
		id_str = get_id_str(dep)
		if not id_str in declared:
			declared.append(id_str)

			if isinstance(dep, Value):
				print_decl_func(dep.definition)
			else:
				print_decl_type(dep.definition)

	out("\n")


def nnl(nl):
	if nl == 1:
		newline(1)
	elif nl >= 2:
		newline(2)


def print_header(module, outname):
	outname = outname + '.h'
	output_open(outname)

	defs = module.defs

	# Печатаем первые комментарии
	if len(defs) > 0:
		def0 = defs[0]
		if def0.is_stmt_comment():
			nnl(def0.nl)
			print_comment(def0)
			newline()
			defs = module.defs[1:]

	#guardsymbol = outname.split("/")[-1]
	#guardsymbol = guardsymbol[:-2].upper() + '_H'
	guardsymbol = module.prefix.upper() + '_H'
	newline()
	out("#ifndef %s\n" % guardsymbol)
	out("#define %s\n" % guardsymbol)

	global already_included
	already_included = []
	include("stddef.h", local=False)
	include("stdint.h", local=False)
	include("stdbool.h", local=False)

	nl_after_incs = False
	if defs != []:
		newline()
		for x in defs:
			if x.is_stmt_directive():
				if isinstance(x, StmtDirectiveCInclude):
					include(x.c_name, local=x.is_local)
					nl_after_incs = True

	# print C `#include ""` directive for included modules
	for inc in module.included_modules:
		if not inc.hasAttribute('do_not_include'):
			include(inc.id + '.h', local=True)
			nl_after_incs = True

	for x in defs:
		if x.is_stmt_import():
			#nnl(x.nl)
			if not x.module.hasAttribute('do_not_include'):
				s = os.path.basename(x.impline)
				include(s + '.h', local=True)
				nl_after_incs = True

	if nl_after_incs:
		newline()

	for use in module.att:
		if use in h_helpers:
			newline()
			h_helpers[use]()

	if module.hasAttribute('use_unicode'):
		out("\n#ifndef __STR_UNICODE__")
		out("\n#if __has_include(<uchar.h>)")
		include("uchar.h")
		out("\n#else")
		out("\ntypedef uint16_t char16_t;")
		out("\ntypedef uint32_t char32_t;")
		out("\n#endif")
		out("\n#define __STR_UNICODE__")
		out("\n#define __STR8(x)  x")
		out("\n#define __STR16(x) u##x")
		out("\n#define __STR32(x) U##x")
		out("\n#define _STR8(x)  __STR8(x)")
		out("\n#define _STR16(x) __STR16(x)")
		out("\n#define _STR32(x) __STR32(x)")
		out("\n#define _CHR8(x)  (__STR8(x)[0])")
		out("\n#define _CHR16(x) (__STR16(x)[0])")
		out("\n#define _CHR32(x) (__STR32(x)[0])")
		out("\n#endif /* __STR_UNICODE__ */")
		out("\n")

	for x in defs:
		if is_private(x):
			continue

		if x.hasAttribute2('c_no_print') or x.hasAttribute2('no_print'):
			continue

		#if x.is_stmt_directive():
		#	if isinstance(x, StmtDirectiveCInclude):
		#		continue


		if x.is_stmt_def_func():
			#nnl(x.nl)
			nnl(1)
			if x.access_level == HLIR_ACCESS_LEVEL_PUBLIC and x.hasAttribute2('inline'):
				out("static ")
				print_def_func(x)
				continue
			print_decl_func(x)
		elif x.is_stmt_def_var():
			nnl(x.nl)
			print_def_var(x, as_extern=True)
		elif x.is_stmt_def_type():
			nnl(x.nl)
			print_deps(x.deps)
			print_def_type(x)
		elif x.is_stmt_def_const():
			nnl(x.nl)
			print_deps(x.deps)
			print_def_const(x)
		#elif x.is_stmt_comment():
		#	nnl(x.nl)
		#	print_comment(x)

	newline(2)
	out("#endif /* %s */" % guardsymbol)
	newline()
	output_close()
	return



def helper_use_abs():
	include("stdlib.h", local=False)


def helper_use_va_arg():
	include("stdarg.h", local=False)


def helper_use_lengthof():
	out("\n#ifndef LENGTHOF")
	out("\n#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))")
	out("\n#endif /* LENGTHOF */")
	module_undef_list.append("LENGTHOF")


def helper_use_bigint():
	out("\n#ifndef __BIG_INT128__")
	out("\n#define BIG_INT128(hi64, lo64) (((__int128)(hi64) << 64) | ((__int128)(lo64)))")
	out("\n#endif  /* __BIG_INT128__ */")
	out("\n")
	out("\n#ifndef __BIG_INT256__")
	out("\n#define BIG_INT256(a, b, c, d)")
	out("\n#endif  /* __BIG_INT256__ */")
	module_undef_list.append("__BIG_INT128__")
	module_undef_list.append("__BIG_INT256__")


def helper_use_arrcpy():
	out("\n#define ARRCPY(dst, src, len) \\")
	out("\n	do { \\")
	out("\n		uint32_t _len = (uint32_t)(len); \\")
	out("\n		for (uint32_t _i = 0; _i < _len; _i++) { \\")
	out("\n			(*(dst))[_i] = (*(src))[_i]; \\")
	out("\n		} \\")
	out("\n	} while (0)")
	module_undef_list.append("ARRCPY")



h_helpers = {
	'use_bigint': helper_use_bigint,
}

c_helpers = {
	'use_abs': helper_use_abs,
	'use_lengthof': helper_use_lengthof,
	'use_arrcpy': helper_use_arrcpy,
	'use_va_arg': helper_use_va_arg,
}

c_include_helpers = {
	'use_abs': helper_use_abs,
	'use_va_arg': helper_use_va_arg,
}


def print_cfile(module, _outname):
	outname = _outname + '.c'

	output_open(outname)

	if module.hasAttribute('c_no_print'):
		output_close()
		return


	defs = module.defs


	# Печатаем первые комментарии
	if len(defs) > 0:
		def0 = defs[0]
		if def0.is_stmt_comment():
			nnl(def0.nl)
			print_comment(def0)
			newline()
			defs = defs[1:]


	global already_included
	already_included = []
	include(module.id + '.h')
	newline()


	dirs = [
		StmtDirectiveCInclude("stddef.h"),
		StmtDirectiveCInclude("stdint.h"),
		StmtDirectiveCInclude("stdbool.h"),
		StmtDirectiveCInclude("string.h"),
	]
	defs = dirs + defs

	for x in defs:
		if isinstance(x, StmtDirectiveCInclude):
			if not x.is_local and x.c_name in STD_HEADERS:
				include(x.c_name, local=x.is_local)


	xx2 = False
	for x in defs:
		if isinstance(x, StmtDirectiveCInclude):
			include(x.c_name, local=x.is_local)
			xx2 = True

	if xx2:
		newline()

	for use in module.att:
		if use in c_helpers:
			c_helpers[use]()

	newline()

	if len(module.anon_recs) > 0:
		out("\n\n/* anonymous records */")
		for anon_rec in module.anon_recs:
			nl_indent()
			print_type_record(anon_rec, tag=anon_rec.c_anon_id)
			out(";")

	for x in defs:
		if x.hasAttribute('c_no_print') or x.hasAttribute('no_print'):
			continue

		if isinstance(x, StmtDirectiveCInclude):
			continue

		if x.is_stmt_def_const() and is_private(x):
			nnl(x.nl)
			print_deps(x.deps)
			print_def_const(x)
		elif x.is_stmt_def_type() and is_private(x):
			nnl(x.nl)
			print_deps(x.deps)
			print_def_type(x)
		elif x.is_stmt_def_var():
			nnl(x.nl)
			print_deps(x.deps)
			print_def_var(x)
		elif x.is_stmt_def_func():
			if x.access_level == HLIR_ACCESS_LEVEL_PUBLIC and x.hasAttribute2('inline'):
				continue
			nnl(x.nl)
			print_deps(x.deps)
			if x.deps != []:
				newline()
			print_def_func(x)
		elif x.is_stmt_comment():
			nnl(x.nl)
			if x.nl == 0:
				out("  ")
			print_comment(x)
		elif x.is_stmt_directive():
			print_directive(x)

	#if len(module_undef_list) > 0:
	#	newline(1)
	#	for u in module_undef_list:
	#		undef(u)

	newline(2)
	output_close()



def run(module, _outname):
	global cmodule, csettings
	cmodule = module

	hpath = _outname
	if 'include_dir' in csettings:
		inc_dir = csettings['include_dir']
		hname = os.path.basename(_outname)
		hpath = inc_dir + '/' + hname

	print_header(module, hpath)
	print_cfile(module, _outname)
	return



# возвращает корневое значение из цепочки ValueCons
def get_root_value(x):
	if x.isValueCons():
		return get_root_value(x.value)
	return x



def cons_vla_from_literal_array(x):
	if x.isValueCons():
		if x.type.is_vla():
			#return x['value']['kind'] in ['literal', HLIR_VALUE_OP_ADD]
			if x.isValueBin():
				return x.op in ['literal', HLIR_VALUE_OP_ADD]
	return False


# получает значение, печатает указатель на его корневое значение
def str_value_as_ptr(x):
	sstr = ''

	t = x.type
	root = get_root_value(x)

	#root.type.is_str() or
	if root.type.is_string():
		return "&" + str_value(root)


	if root.isValueImmediate():
		if x.type.is_composite() or value_is_generic_immediate_const(root):
			# generic immediate const is just a macro!
			vs = str_value(root)
			ts = str_type(x.type)
			return "&((%s)%s)" % (ts, vs)

	if x.isValueCons():
		# for *s == "Hi!"
		# string literal will be implicitly casted to StrX
		# and for getting pointer to this string
		# we need to print just string literal,
		# because in C string literal is pointer to c-string
		if x.value.type.is_string():
			return str_value(x.value)

	if root.isValueSlice():
		ptr2slice = TypePointer(x.type)
		sptr = str_type_pointer(ptr2slice, as_ptr_to_array=True)
		sstr += '(%s)' % sptr

	if root.isValueDeref():
		return str_value(root.value)

	if root.isValueLiteral():
		if root.type.is_string():
			return str_value(root)

	sstr += "&"

	if root.isValueBin() and root.op in ['literal', HLIR_VALUE_OP_ADD]:
		sstr += '(' + str_type(t) + ')'

	elif root.isValueLiteral() and (not root.isValueImmediate()):
		# for non immediate literals  {1, 2, var_a, var_b, ...}
		sstr += '(' + str_type(t) + ')'

	elif cons_vla_from_literal_array(root):
		# we need to print:
		#  &(uint32_t[]){1, 2, 3, 4, 5}
		# instead of:
		#  &(uint32_t[len]){1, 2, 3, 4, 5}
		sstr += '(' + str_type(t) + ')'
		sstr += str_value(x.value)
		return sstr

	sstr += str_value(root)
	return sstr



def assign_by_memcopy(left, right):
	rv = get_root_value(right)
	if rv.isValueZero():
		memzero(left)
		return

	out("memcpy(")
	out(str_value_as_ptr(left))
	out(", ")
	out(str_value_as_ptr(right))
	out(", sizeof(")
	print_type(left.type)
	out("))")


def memzero(value):
	out("memset(")
	out(str_value_as_ptr(value))
	out(", 0, sizeof(")
	print_type(value.type)
	out("))")


#def eq_by_memcmp(left, right, op=HLIR_VALUE_OP_EQ):
#	return eq_by_memcmp(left, right, op=op)


def eq_str_by_strcmp(left, right, op=HLIR_VALUE_OP_EQ):
	# не берем все в скобки все тк это eq операция
	# и ее приоритет не нарушается (!)
	sstr = 'strcmp('
	sstr += str_value_as_ptr(left)
	sstr += ', '
	sstr += str_value_as_ptr(right)
	if op == HLIR_VALUE_OP_EQ:
		sstr += ') == 0'
	else:
		sstr += ') != 0'
	return sstr


def eq_by_memcmp(left, right, op=HLIR_VALUE_OP_EQ):
	# не берем все в скобки все тк это eq операция
	# и ее приоритет не нарушается (!)
	sstr = 'memcmp('
	sstr += str_value_as_ptr(left)
	sstr += ', '
	sstr += str_value_as_ptr(right)
	sstr += ", sizeof("
	common_type = select_common_type(left.type, right.type)
	sstr += str_type(common_type)
	sstr += ")"
	if op == HLIR_VALUE_OP_EQ:
		sstr += ') == 0'
	else:
		sstr += ') != 0'
	return sstr




libc_headers = [
    "stdio.h",

    # Общие утилиты, память, сортировка, случайные числа
    "stdlib.h",

    # Строки и память
    "string.h",
    "strings.h",  # POSIX, не ISO, но часто включён в libc

    # Символьная классификация и преобразование
    "ctype.h",

    # Арифметика и математика
    "math.h",
    "fenv.h",
    "complex.h",

    # Время и даты
    "time.h",

    # Ограничения, типы, стандартные константы
    "limits.h",
    "float.h",
    "stdint.h",
    "inttypes.h",
    "stddef.h",
    "stdbool.h",
    "stdalign.h",
    "stdarg.h",
    "stdnoreturn.h",
    "stdatomic.h",
    "uchar.h",   # char16_t / char32_t

    # Локализация
    "locale.h",

    # Сигналы и ошибки
    "errno.h",
    "signal.h",
    "setjmp.h",

    # Юникод и широкий текст
    "wchar.h",
    "wctype.h",

    # Диагностика, утверждения
    "assert.h",

    # ISO/IEC TR 24731 (дополнения безопасных функций)
    "stdio_ext.h",  # GNU extension, опционально
]


iso_c_headers = [
    "assert.h",
    "complex.h",
    "ctype.h",
    "errno.h",
    "fenv.h",
    "float.h",
    "inttypes.h",
    "iso646.h",
    "limits.h",
    "locale.h",
    "math.h",
    "setjmp.h",
    "signal.h",
    "stdalign.h",
    "stdarg.h",
    "stdatomic.h",
    "stdbool.h",
    "stddef.h",
    "stdint.h",
    "stdio.h",
    "stdlib.h",
    "stdnoreturn.h",
    "string.h",
    "tgmath.h",
    "threads.h",
    "time.h",
    "uchar.h",
    "wchar.h",
    "wctype.h",
]


posix_headers = [
    # Базовые системные вызовы и типы
    "unistd.h",
    "sys/types.h",
    "sys/stat.h",
    "sys/time.h",
    "sys/times.h",
    "sys/wait.h",
    "sys/utsname.h",
    "sys/uio.h",
    "sys/resource.h",
    "sys/mman.h",
    "sys/ipc.h",
    "sys/msg.h",
    "sys/sem.h",
    "sys/shm.h",
    "sys/socket.h",
    "sys/select.h",
    "sys/statvfs.h",
    "syslog.h",

    # Потоки и синхронизация
    "pthread.h",
    "semaphore.h",
    "mqueue.h",
    "sched.h",
    "spawn.h",
    "time.h",        # POSIX расширяет ISO C time.h
    "utime.h",
    "utmpx.h",

    # Работа с файлами, каталогами и путями
    "fcntl.h",
    "dirent.h",
    "ftw.h",
    "glob.h",
    "fnmatch.h",
    "paths.h",
    "wordexp.h",

    # Работа с пользователями, группами и правами
    "pwd.h",
    "grp.h",
    "shadow.h",
    "getopt.h",
    "sys/file.h",
    "sys/statfs.h",
    "sys/mount.h",

    # Терминалы, сигналы, управление процессами
    "termios.h",
    "termio.h",
    "signal.h",      # POSIX расширяет ISO C signal.h
    "ucontext.h",
    "setjmp.h",      # тоже расширяется
    "sys/signal.h",
    "sys/ioctl.h",
    "sys/param.h",

    # Ввод-вывод, устройства, ресурсы
    "poll.h",
    "sys/poll.h",
    "sys/eventfd.h",
    "sys/epoll.h",
    "aio.h",

    # Сети и адреса
    "netdb.h",
    "netinet/in.h",
    "netinet/ip.h",
    "netinet/tcp.h",
    "arpa/inet.h",
    "net/if.h",

    # Локализация и строки
    "iconv.h",
    "nl_types.h",
    "langinfo.h",
    "regex.h",

    # Работа с паролями и авторизацией
    "crypt.h",
    "utmp.h",
    "sys/sysmacros.h",

    # Расширения POSIX и XSI
    "dlfcn.h",
    "sys/ptrace.h",
    "sys/un.h",
    "sys/syscall.h",
    "sys/klog.h",
    "sys/procfs.h",
]


network_headers = [
    # --- POSIX core networking ---
    "sys/socket.h",     # базовые сокеты (socket, bind, connect, send, recv)
    "netdb.h",          # getaddrinfo(), gethostbyname(), etc.

    # --- BSD networking extensions (стандарт де-факто) ---
    "arpa/inet.h",      # inet_ntoa(), inet_pton(), htons(), ntohl()
    "netinet/in.h",     # sockaddr_in, sockaddr_in6, IPPROTO_TCP, INADDR_ANY
    "netinet/ip.h",     # структура IP-заголовка (iphdr)
    "netinet/tcp.h",    # структура TCP-заголовка, флаги TH_SYN и др.
    "netinet/udp.h",    # структура UDP-заголовка
    "netinet/icmp.h",   # структура ICMP-заголовка
    "netinet/if_ether.h",  # Ethernet фреймы, ETH_P_IP, ETH_ALEN и т.д.
    "netinet/ether.h",     # функции для MAC-адресов (ether_ntoa, ether_aton)

    # --- сетевые интерфейсы и низкоуровневые протоколы ---
    "net/if.h",         # структура ifreq, ioctl для интерфейсов
    "net/if_arp.h",     # ARP протокол
    "net/route.h",      # таблицы маршрутизации
    "net/ethernet.h",   # Ethernet типы пакетов
    "netpacket/packet.h",  # Linux raw sockets (AF_PACKET)
    "net/ppp_defs.h",   # PPP протокол (опционально)
    "net/if_dl.h",      # BSD link-level адреса (MAC и т.п.)

    # --- протоколы верхнего уровня (иногда присутствуют) ---
    "arpa/nameser.h",   # DNS resolver API
    "arpa/tftp.h",      # TFTP
    "arpa/ftp.h",       # FTP
    "arpa/telnet.h",    # TELNET
    "arpa/rpc.h",       # RPC/XDR (устаревшее, но всё ещё в glibc)
    "rpc/xdr.h",        # XDR (External Data Representation)
    "rpc/rpc.h",        # старый SunRPC API

    # --- дополнительные / Linux-specific ---
    "linux/if_packet.h",   # Linux-specific raw socket API
    "linux/if_ether.h",
    "linux/if_link.h",
    "linux/if_tun.h",
    "linux/netlink.h",
    "linux/rtnetlink.h",
    "linux/icmpv6.h",
    "linux/tcp.h",
    "linux/udp.h",
    "linux/ipv6.h",
]

STD_HEADERS = libc_headers + iso_c_headers + posix_headers + network_headers

