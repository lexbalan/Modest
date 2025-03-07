# Есть проблема с массивом generic int когда индексируешь и приводишь к инту
# но индексируешь переменной (в цикле например)


from .common import *
from error import info, error, fatal
from hlir.hlir import *
from value.value import *
import type as htype
from type import select_common_type, type_print
from hlir.value import ValueIndex
from value.integer import value_integer_create
from util import align_bits_up, nbits_for_num, get_item_by_id, align_to
from main import settings
import foundation

import copy

INDENT_SYMBOL = "\t"

cmodule = None


NO_TYPEDEF_STRUCTS = False

BOOL_TRUE_LITERAL = 'true'
BOOL_FALSE_LITERAL = 'false'
DONT_PRINT_UNUSED = True

USE_STATIC_VARIABLES = True

VA_ARG_CHAR_AS_INT = True

# for integer literals printing
CC_INT_SIZE_BITS = 32
CC_LONG_SIZE_BITS = 32
CC_LONG_LONG_SIZE_BITS = 64

# идетнифиаторы декларированных (или определенных) сущностей
declared = []


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


cfunc = None


def newline_str(n):
	return nl_str * n

def newline(n=1):
	out(newline_str(n))



def indent():
	out(indent_str(INDENT_SYMBOL))


def str_nl_indent(nl=1):
	s = nl_str * nl
	if nl > 0:
		s += indentation(INDENT_SYMBOL)
	return s


def nl_indent(nl=1):
	out(str_nl_indent(nl))


def is_local_context():
	global cfunc
	return cfunc != None


def is_global_context():
	global cfunc
	return cfunc == None


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


def value_is_generic_immediate(x):
	return x.isImmediate() and x.type.is_generic()



CONS_PRECEDENCE = 10
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
	['pos', 'neg', 'not', 'logic_not', 'cons', 'ref', 'deref', 'sizeof', 'alignof', 'offsetof', 'lengthof'], #10
	['call', 'index', 'access', 'access_module'], #11
	['num', 'var', 'func', 'str', 'enum', 'record', 'array'] #12
]

precedenceMax = len(aprecedence) - 1


# приоритет операции
def precedence(x):
	i = 0
	if isinstance(x, ValueBin):
		k = x.op
		while i < precedenceMax + 1:
			if k in aprecedence[i]:
				break
			i = i + 1
	else:
		if isinstance(x, ValueCons): i = 10
		elif isinstance(x, ValueSizeofValue): i = 10
		elif isinstance(x, ValueRef): i = 10
		elif isinstance(x, ValueCall): i = 11
		elif isinstance(x, ValueIndex): i = 11
		elif isinstance(x, ValueAccessRecord): i = 11
		elif isinstance(x, ValueShl): i = 7
		elif isinstance(x, ValueShr): i = 7
		elif isinstance(x, ValuePos): i = 10
		elif isinstance(x, ValueNeg): i = 10
		elif isinstance(x, ValueNot): i = 10
		else: i = 12

	return i



def get_id_str(x):
	if not hasattr(x, 'id'):
		return None

	id = x.id

	if id.c != None:
		return id.c

	if not x.hasAttribute('nodecorate'):
		xmodule = x.getModule()
		if xmodule != None:
			if not 'nodecorate' in xmodule.att:
				#if x.access_level != 'private':
				if not x.hasAttribute('static'):
					return "%s_%s" % (xmodule.id, id.str)

	return id.str



def type_get_aka(t):
	s = get_id_str(t)
	if s != None:
		return s

	if t.is_numeric():
		s = 'int%d_t' % t.width
		if not t.signed:
			s = 'u' + s
		return s

	if hasattr(t, 'c_anon_id'):
		return 'struct ' + t.c_anon_id

	return None



def str_type_record(t, tag=''):
	s = "struct"

	if t.hasAttribute('packed'):
		s += " __attribute__((packed))"

	if tag != "":
		s += (" %s" % tag)

	if styleguide['LINE_BREAK_BEFORE_STRUCT_BRACE']:
		s += nl_str
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
				#s += str_nl_indent(comment['nl'])
				#print_comment(comment)
				pass

		s += str_nl_indent(field.nl)
		prev_nl = field.nl

		s+= str_type(field.type, core='', label=get_id_str(field))
		s += ";"

	indent_down()
	s += str_nl_indent(1)
	s += "}"
	return s



"""def print_type_enum(t):
	out("enum {")
	indent_up()
	items = t.items
	i = 0
	while i < len(items):
		if i > 0: out(',')
		item = items[i]
		nl_indent()
		get_id_str(item)
		i = i + 1
	indent_down()
	nl_indent()
	out("}")"""



def is_type_named(t):
	return type_get_aka(t) != None


def prespace(s):
	if s == '':
		return ''
	return ' ' + s


def str_type_array(t, label='', core=''):
	t0 = t

	# handle array of array .. case
	dims = ''
	i = 0
	while True:
		dims += '['
		if t.volume:
			if Value.isUndefined(t.volume):
				# В Си не можем печатать такое a[][], или такое a[][10], etc.
				# А печатаем просто a[] (пропускаем все после пустых скобок)
				while t.of.is_array():
					t = t.of
			else:
				dims += str_value(t.volume)

		dims += ']'
		if not t.of.is_array():
			break
		t = t.of
		i += 1

	if t.of.is_pointer():
		of = t.of
		if of.to.is_array():
			core = core + label + dims
			return str_type(of, core=core)

		elif of.to.is_func():
			core = core + label + dims
			return str_type(t.of, core=core)

		elif is_type_named(of.to):
			return str_type(of) + core + label + dims

	left = str_type(t.of)

	if not t.of.is_pointer():
		label = prespace(label)
	return left + core + label + dims



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

		s += str_type(ptype, label=pstr)
		i += 1

	if va_arg:
		if i > 0:
			s += ', '
		s += '...'

	s += ')'
	return s


def str_type_func(t, label='', core=''):
	fparams = t.params
	fto = t.to
	if t.to.is_array():
		# (!) HACK (!)
		# C не умеет возвращать массивы по значению,
		# поэтому если возвращаем массив вернем void
		# а сам массив пойдет через указатель sret_
		# который функция получит своим самым последним параметром
		# (sret = structure return)
		sret_param = Field(Id().fromStr('sret_'), TypePointer(t.to))

		fparams = t.params + [sret_param]
		fto = foundation.typeUnit

	params = strFuncParamlist(fparams, t.extra_args)

	if not is_type_named(fto):
		if fto.is_pointer():
			if fto.to.is_pointer() or fto.to.is_array() or fto.to.is_func():
				core = core + label + params
				return str_type(fto, core=core)

	left = str_type(fto)
	if not fto.is_pointer():
		label = prespace(label)
	return left + core + label + params



def str_type_pointer(t, label, core=''):
	tx = t

	c = ''
	while tx.is_pointer():
		tx = tx.to
		c += '*'

	if is_sim_sim(t):
		tx = tx.of

	if not is_type_named(tx):
		core = '(' + c + core + label + ')'
		return str_type(tx, core=core)

	return str_type(tx) + ' ' + c + core + label



def is_sim_sim(t):
	if t.is_pointer_to_array():
		if not t.to.hasAttribute('alias'):
			return is_type_named(t.to.of)



# label - used for variable/field definition form of type expr (variable id)
def str_type(t, core='', label='', as_const='', as_volatile=''):
	aka = type_get_aka(t)
	if aka != None:
		if as_const:
			out('const ')
		if as_volatile:
			out('volatile ')

		return aka + core + prespace(label)

	if t.is_pointer():
		if as_const:
			label = 'const ' + label
		if as_volatile:
			label = 'volatile ' + label
	else:
		if as_const:
			out('const ')
		if as_volatile:
			out('volatile ')

	if t.is_func():
		return str_type_func(t, label, core)
	elif t.is_pointer():
		return str_type_pointer(t, label, core)
	elif t.is_array():
		return str_type_array(t, label, core)
	elif t.is_record():
		return str_type_record(t) + prespace(label)
	return '<type:%s>' % str(t)



def print_type(t, label='', as_const='', as_volatile=''):
	out(str_type(t, core='', label=label, as_const=as_const, as_volatile=as_volatile))


def print_type_record(t, tag):
	out(str_type_record(t, tag=tag))



bin_ops = {
	'or': '|', 'xor': '^', 'and': '&', 'shl': '<<', 'shr': '>>',
	'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
	'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'rem': '%',
	'logic_and': '&&', 'logic_or': '||'
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

	if op in ['eq', 'ne']:
		if left.type.is_record():
			return str_value_eq_record(x, ctx)
		elif left.type.is_array():
			return str_value_eq_array(x, ctx)
		elif left.type.is_string():
			return str_literal_bool(x.asset)

	lk = ''
	if hasattr(left, 'op'):
		lk = left.op

	rk = ''
	if hasattr(right, 'op'):
		rk = right.op

#	if op in ['shl', 'shr']:
#		need_wrap_left = precedence(left) < 10
#		need_wrap_right = precedence(right) < 10
#	elif op == 'logic_or':
#		if lk != 'logic_or':
#			need_wrap_left = precedence(left) < 10
#		if rk != 'logic_or':
#			need_wrap_right = precedence(right) < 10
#	elif op == 'logic_and':
#		if lk != 'logic_and':
#			need_wrap_left = precedence(left) < 10
#		if rk != 'logic_and':
#			need_wrap_right = precedence(right) < 10
#

	if op == 'add':
		if left.type.is_array():
			return str_value_literal(x, ctx)

		if left.type.is_string():
			if left.type.width != right.type.width:
				# для случаев вроде "Hello" + U"World!"
				# (печатаем сам литерал, тк C иначе не умеет)
				# (U"Hello World!")
				#str_value_string(x, ctx)
				return str_literal_string(x.asset, char_width=x.type.width)

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
	if need_wrap_right:
		sstr += "("
	sstr += str_value(x.right, parent_expr=x)
	if need_wrap_right:
		sstr += ")"
	return sstr


def str_value_shr(x, ctx):
	sstr = ''
	sstr += str_value(x.left, parent_expr=x)
	sstr += (' >> ')
	need_wrap_right = not x.right.__class__ in [ValueLiteral, ValueConst, ValueVar]
	if need_wrap_right:
		sstr += ("(")
	sstr += str_value(x.right, parent_expr=x)
	if need_wrap_right:
		sstr += (")")
	return sstr


def str_value_eq_record(x, ctx):
	return str_value_eq_composite(x, ctx)


def str_value_eq_array(x, ctx):
	return str_value_eq_composite(x, ctx)


def str_value_eq_composite(x, ctx):
	op = x.op
	left = x.left
	right = x.right

	if x.isImmediate():
		return str_literal_bool(x.asset)

	# если сравниваем строки (Str8, Str16, Str32)
	if left.type.is_str() and right.type.is_str():
		return strcmp_str(left, right, op=op)

	return memcmp_eq_str(left, right, op=op)


un_ops = {
	'ref': '&', 'deref': '*',
	'pos': '+', 'neg': '-',
	'not': '~', 'logic_not': '!'
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
	left = v.func

	sstr += str_value(left)

	ftype = left.type
	if ftype.is_pointer():
		ftype = ftype.to
	params = ftype.params
	args = v.args
	n = len(args)

	sstr += ("(")

	i = 0
	while i < n:
		a = None
		if isinstance(args[i], Initializer):
			a = args[i].value
		else:
			a = args[i]

		# не всегда когда есть аргумент есть и соотв ему параметер (!)
		try:
			# если тип аргумента отличается модификатором (const, volatile)
			# то явно приведем его к типу параметра, чтобы C не ругался
			# (try: проверяем только те аргументы, для которых есть параметры)
			p = params[i]
			pt = p['type']

			if not Type.eq(pt, a['type'], opt=['att_checking']):
				sstr += print_cast(pt, a)
			else:
				sstr += str_value(a, ctx=ctx)

		except:
			sstr += str_value(a, ctx=ctx)

		i = i + 1
		if i < n:
			sstr += (", ")

	if sret != None:
		if i > 0:
			sstr += (", ")
		sstr += str_value_as_ptr(sret)

	sstr += (")")
	return sstr



def str_value_slice(x, ctx):
	y = ValueIndex(x.type, x.left, x.index_from, ti=None)
	return str_value_index(y, ctx)


def str_value_new(x, ctx):
	t_str = str_type(x.value.type)
	return '(%s *)calloc(1, sizeof(%s))' % (t_str, t_str)



def str_value_index(x, ctx):
	sstr = ''
	left = x.left

	if left.type.is_pointer():
		if not is_sim_sim(left.type):
			sstr += "(*"

	sstr += str_value(left, ctx=ctx, parent_expr=x)

	if left.type.is_pointer():
		if not is_sim_sim(left.type):
			sstr += (")")

	sstr += "["
	sstr += str_value(x.index)
	sstr += "]"
	return sstr



def str_value_access(x, ctx):
	sstr = ''
	left = x.left

	# если имеем дело c константной записью (глоб константа)
	# и результат операции доступа - константа которая уже тут
	#if left.type.is_generic():
	#	if x.isImmediate():
	if value_is_generic_immediate(left):
		return str_value_literal(x, ['print_immediate'])

	sstr += str_value(left, parent_expr=x)
	if left.type.is_pointer():
		sstr += ('->')
	else:
		sstr += ('.')
	sstr += get_id_str(x.field)
	return sstr




def print_cast_hard(t, v, ctx=[]):
	# hard cast is possible only in function body
	assert(is_local_context())
	sstr = ''
	sstr += "*("
	sstr += str_type(t)
	sstr += "*)&"
	need_wrap = precedence(v) < CONS_PRECEDENCE
	if need_wrap:
		sstr += "("
	sstr += str_value(v, ctx=ctx)
	if need_wrap:
		sstr += ")"
	return sstr


def print_cast(t, v, ctx=[]):
	#array_as_ptr = not 'array_as_array' in ctx
	sstr = "("
	sstr += str_type(t)
	sstr += ")"

	need_wrap = precedence(v) < CONS_PRECEDENCE

	# add for arrays add (!)
	if isinstance(v, ValueLiteral) or (isinstance(v, ValueBin) and v.op == 'add'):
		need_wrap = not v.type.is_composite()

	if need_wrap:
		sstr += ("(")
	sstr += str_value(v, ctx=ctx)
	if need_wrap:
		sstr += (")")

	return sstr



def str_value_cons_record(x, ctx):
	sstr = ''
	to_type = x.type
	value = x.value
	from_type = value.type

	if from_type.is_generic_record():
		if is_local_context():
			return print_cast(to_type, value)
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
		return print_cast_hard(to_type, value)



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
		#is_const = value['kind'] in ['const', 'literal', 'add']
		
		is_const = isinstance(value, ValueLiteral) or isinstance(value, ValueConst) or (isinstance(value, ValueBin) and value.op == 'add')
		
		if is_const and not value.hasAttribute('kostil'):
			ctx=['array_as_array']

			if to_type.of.is_char():
				if from_type.of.is_string():
					chars = []
					for item in value.items:
						ch = item.asset
						chars.append(ch)

					char_width = to_type.of.width
					return str_literal_string(chars, char_width=char_width)

			return print_cast(to_type, value, ctx=ctx)
		else:
			return str_value(value, ctx=ctx)
		return '<??>'


	if from_type.is_string():
		if to_type.of.is_char():
			# cast <string literal> to <array of chars>:
			if to_type.of.width == from_type.width:
				return str_value(value, ctx=ctx)
			else:
				return str_literal_string(value.asset, char_width=to_type.of.width)
			return '<???>'

	# for:
	#    var x: [10]Word8 = "0123456789"
	if value.type.is_string():
		return str_value(value, ctx=ctx)

	return print_cast(to_type, value, ctx)




def print_suffix(to_type, num):
	sstr = ''
	req_bits = nbits_for_num(num)

	# ! `not is_signed()`, because here can be Word (it nor signed, nor unsigned) !
	if not to_type.is_signed():
		if req_bits >= CC_INT_SIZE_BITS:
			sstr += ("U")

	if req_bits <= CC_INT_SIZE_BITS:
		pass  # int
	elif req_bits <= CC_LONG_SIZE_BITS:
		sstr += ("L")  # long int
	else:
		sstr += ("LL")  # long long int
	return sstr



def str_value_cons(x, ctx):
	sstr = ''
	type = x.type
	value = x.value
	from_type = value.type

	if type.is_array():
		return str_value_cons_array(x, ctx)

	elif type.is_record():
		return str_value_cons_record(x, ctx)

	elif type.is_pointer():
		if from_type.is_string():
		# cast <string literal> to <pointer to array of chars>:
			# let genericStringConst = "S-t-r-i-n-g-Ω 🐀🎉🦄"
			# let string8Const = *Str8 genericStringConst  // <-
			if type.to.of.width != from_type.width:
				return str_literal_string(value.asset, char_width=type.to.of.width)

		# в у нас типы структурные, в си - номинальные
		# поэтому даже если структуры одинаковы, но имена разные
		# их нужно приводить
		# *RecordA -> *RecordB
		if type.to.is_record():
			if from_type.is_pointer_to_record():
				# НО если это реально один и тот же тип, то приведение не нужно!
				if id(from_type) != id(type):
					return print_cast(type, value, ctx)

		if from_type.is_pointer():
			if from_type.to.is_array():
				if type.to.is_array():
					pass
					#sstr += ("\n// -- DIM --\n")
					#return do_eval_cons_pointer_to_array(x)


	elif type.is_float():
		if from_type.is_integer() or from_type.is_number():
			return print_cast(type, value, ctx)

	elif type.is_char():
		if from_type.is_string():
			return str_literal_char(x.asset, x.type.width)

	elif type.is_unsigned_integer() or type.is_word():
		if from_type.is_unsigned_integer() or from_type.is_word():
			return str_value(value)


	if x.method == 'implicit':

		if isinstance(value, ValueRef):
			# Приводим явно указатель на массив к указателю на его элемент
			# В случае когда происходит неявное приведение;
			if value.value.type.is_array():
				if value.value.type.of.is_simple():
					sstr += ("(")
					sstr += str_type(value.value.type.of)
					sstr += (" *)")

		# не печатаем обычный implicit_cast
		# (это не касается того что выше ^^)
		sstr += str_value(value)

		# print postfix ('u', 'U', 'L', 'LL', etc.)
		if isinstance(value, ValueLiteral):
			if from_type.is_number() or from_type.is_integer() or from_type.is_word():
				# up to 'long long'
				if type.width <= 64:
					sstr += print_suffix(type, value.asset)
		return sstr


	if isinstance(value, ValueLiteral):
		sstr += str_value(value)
		return sstr


	# (!) WARNING (!)
	# - in C  int32(-1) -> uint64 => 0xffffffffffffffff
	# - in Cm int32(-1) -> uint64 => 0x00000000ffffffff
	# required: (uint64_t)((uint32)int32_value)
	if type.is_integer():
		if from_type.is_integer() or from_type.is_number():
			if from_type.is_signed() and type.is_unsigned():
				if from_type.size < type.size:
					sstr += ("((")
					sstr += str_type(type)
					sstr += (")")
					nat_same_sz = foundation.type_select_nat(from_type.width)
					sstr += print_cast(nat_same_sz, value, ctx)
					sstr += (")")
					return sstr


	# for: (uint32_t *)(void *)&i;
	# remove (void *)
	if isinstance(value, ValueCons):
		if value.type.is_free_pointer():
			value = value.value

	return print_cast(type, value, ctx)



def is_zero_tail(values, i, n):
	# если это значание - zero, проверим все остальные справа
	# и если они тоже zero - их можно не печатать (zero tail)
	# ex: {'a', 'b', '\0', '\0', '\0'} -> {'a', 'b', '\0'}
	while i < n:
		v = values[i]
		if not v.isZero():
			return False
		i = i + 1
	return True


def print_array_values(values, ctx):
	sstr = ''
	i = 0
	n = len(values)
	while i < n:
		a = values[i]

		nl = a.nl
		if nl > 0:
			sstr += newline_str(n=nl)
			sstr += indent_str(INDENT_SYMBOL)
		else:
			if i > 0:
				sstr += " "

		if a.type.is_closed_array():
			sstr += print_array_values(a.items, ctx)
		else:
			sstr += str_value(a, ctx)

		i = i + 1

		# если это значание - zero, проверим все остальные справа
		# и если они тоже zero - их можно не печатать (zero tail)
		# ex: {'a', 'b', '\0', '\0', '\0'} -> {'a', 'b', '\0'}
		if a.isZero():
			if is_zero_tail(values, i, n):
				return sstr

		if i < n:
			sstr += (',')

	return sstr



def str_literal_string(chars, char_width):
	utf32_codes = []
	for ch in chars:
		cc = ord(ch)
		utf32_codes.append(cc)
	return print_utf32codes_as_string(utf32_codes, char_width)


def str_literal_char(cc, width):
	return print_utf32codes_as_string([cc], width, quote="'")



def str_literal_array(type, items, nl_end=1):
	sstr = ''
	if type.is_array_of_char():
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

	sstr += "{"
	indent_up()
	sstr += print_array_values(items, [])
	indent_down()
	sstr += newline_str(n=nl_end)
	sstr += indent_str(INDENT_SYMBOL)
	sstr += "}"
	return sstr




def str_literal_record(type, items, nl_end=1):
	sstr = "{"
	indent_up()

	nitems = len(items)
	i = 0

	# for situation when firat item is ValueZero
	# without it, forst value will be printed with space before it.
	item_printed = False

	while i < nitems:
		item = type.fields[i]
		field_id_str = get_id_str(item)
		ini = get_item_by_id(items, field_id_str)

		nl = ini.nl
		if nl > 0:
			sstr += newline_str(n=nl)
			sstr += indent_str(INDENT_SYMBOL)
		else:
			if item_printed:
				sstr += " "

		sstr += ".%s = " % field_id_str

		# 'no-literal-array-cast' - когда прописываем инициализаторы
		# литерал массива не нужно приводить к типу массива
		# тк C это не умеет:
		# .arr = (uint8_t [3]){1, 2, 3}  // not worked
		# .arr = {1, 2, 3}  // worked
		# вот такая вот херня
		sstr += str_value(ini.value, ['no-literal-array-cast'])
		if i < (nitems - 1):
			sstr += ","

		item_printed = True
		i = i + 1

	indent_down()

	sstr += newline_str(n=nl_end)
	sstr += indent_str(INDENT_SYMBOL)
	sstr += ("}")

	#if cast_req:
	#	out(")")
	return sstr



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
	prefix = ""
	if width <= 8: prefix = ""
	elif width <= 16: prefix = "u"
	elif width <= 32: prefix = "U"
	sstr += (prefix)
	sstr += (quote)
	for cc in utf32_codes:
		sstr += (code_to_char(cc))
	sstr += (quote)
	return sstr



def str_literal_bool(num):
	if num:
		return BOOL_TRUE_LITERAL
	else:
		return BOOL_FALSE_LITERAL


def str_value_enum(x, ctx):
	return get_id_str(x)



def str_literal_integer(type, num, nsigns=0, is_big=False, is_hex=False):
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
		return sstr
	else:
		sstr += (str(num))

	return sstr



def str_literal_float(num):
	return '{0:f}'.format(num)


def str_literal_pointer(type, num):
	sstr = ''
	if num == 0:
		sstr += "NULL"
	else:
		sstr += "(("
		sstr += str_type(type)
		sstr += ")"
		sstr += "0x%08X)" % num
	return sstr


def str_value_literal(x, ctx):
	sstr = ''
	t = x.type
	if t.is_integer() or t.is_number() or t.is_word():
		nsigns = 0
		if hasattr(x, 'nsigns'):
			nsigns = x.nsigns
		sstr += str_literal_integer(x.type, x.asset, nsigns=nsigns, is_hex=x.hasAttribute('hexadecimal'))

	elif t.is_float():
		sstr += str_literal_float(x.asset)
	elif t.is_string():
		sstr += str_literal_string(x.asset, char_width=x.type.width)
	elif t.is_record():
		sstr += str_literal_record(x.type, x.items, nl_end=x.nl_end)
	elif t.is_array():
		sstr += str_literal_array(x.type, x.items, nl_end=x.nl_end)
	elif t.is_bool():
		sstr += str_literal_bool(x.asset)
	elif t.is_char():
		sstr += str_literal_char(x.asset, x.type.width)
	elif t.is_pointer():
		sstr += str_literal_pointer(x.type, x.asset)
	else:
		error("str_value_literal not implemented", x.ti)

	return sstr



def str_value_const(x, ctx):
	sstr = ''

	if x.type.is_array() and is_global_context():
		sstr += ('_')

	sstr += get_id_str(x)
	return sstr



def str_value_func(x, ctx):
	return get_id_str(x)


def str_value_var(x, ctx):
	y = get_id_str(x)
	if y == None:
		print(":" + str(x))
	return y


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
	sstr = "__lengthof("
	sstr += str_value(x.value)
	sstr += ")"
	return sstr



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


def str_value(x, ctx=[], parent_expr=None):
	sstr = ''
	need_wrap = False
	if parent_expr != None:
		need_wrap = precedence(x) < precedence(parent_expr)

	if need_wrap:
		sstr += "("
	
	if isinstance(x, ValueLiteral):
		sstr += str_value_literal(x, ctx)
	elif isinstance(x, ValueBin):
		sstr += str_value_bin(x, ctx)
	elif isinstance(x, ValueShl):
		sstr += str_value_shl(x, ctx)
	elif isinstance(x, ValueShr):
		sstr += str_value_shr(x, ctx)
	elif isinstance(x, ValueRef):
		sstr += str_value_ref(x, ctx)
	elif isinstance(x, ValueDeref):
		sstr += str_value_deref(x, ctx)
	elif isinstance(x, ValueCons):
		sstr += str_value_cons(x, ctx)
	elif isinstance(x, ValueFunc):
		sstr += str_value_func(x, ctx)
	elif isinstance(x, ValueVar):
		sstr += str_value_var(x, ctx)
	elif isinstance(x, ValueConst):
		sstr += str_value_const(x, ctx)
	elif isinstance(x, ValueCall):
		sstr += str_value_call(x, ctx)
	elif isinstance(x, ValueIndex):
		sstr += str_value_index(x, ctx)
	elif isinstance(x, ValueAccessRecord):
		sstr += str_value_access(x, ctx)
	elif isinstance(x, ValueSlice):
		sstr += str_value_slice(x, ctx)
	elif isinstance(x, ValueSubexpr):
		sstr += str_value_subexpr(x, ctx)
	elif isinstance(x, ValueNot):
		sstr += str_value_not(x, ctx)
	elif isinstance(x, ValueNeg):
		sstr += str_value_neg(x, ctx)
	elif isinstance(x, ValuePos):
		sstr += str_value_pos(x, ctx)
	elif isinstance(x, ValueNew):
		sstr += str_value_new(x, ctx)
	elif isinstance(x, ValueSizeofValue):
		sstr += str_value_sizeof_value(x, ctx)
	elif isinstance(x, ValueSizeofType):
		sstr += str_value_sizeof_type(x, ctx)
	elif isinstance(x, ValueAlignof):
		sstr += str_value_alignof(x, ctx)
	elif isinstance(x, ValueOffsetof):
		sstr += str_value_offsetof(x, ctx)
	elif isinstance(x, ValueLengthof):
		sstr += str_value_lengthof(x, ctx)
	elif isinstance(x, ValueVaArg):
		sstr += str_value_va_arg(x, ctx)
	elif isinstance(x, ValueVaStart):
		sstr += str_value_va_start(x, ctx)
	elif isinstance(x, ValueVaEnd):
		sstr += str_value_va_end(x, ctx)
	elif isinstance(x, ValueVaCopy):
		sstr += str_value_va_copy(x, ctx)
	elif isinstance(x, ValueUndefined):
		sstr += "/*<ValueUndefined>*/"
		1/0
	else:
		sstr += "<%s>" % str(x)

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

		if isinstance(e, StmtIf):
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
		print_value(x.value)

	out(";")



def print_stmt_var(x):
	var_value = x.value
	init_value = x.init_value

	#if DONT_PRINT_UNUSED:
	#	if init_value != None:
	#		if var_value['usecnt'] == 0:
	#			if init_value['kind'] != 'call':
	#				return

	print_variable(get_id_str(var_value), var_value.type)

	v = var_value
	iv = init_value
	# если инициализирующее значение - это
	# литерал массива включающий в себя переменные
	# то печатаем это иначе (w/ memcpy)
	if iv.type.is_array():
		runtimeLiteral = isinstance(iv, ValueLiteral) and not iv.isImmediate()
		if not runtimeLiteral:
			out(";")
			nl_indent()
			do_assign(v, iv)
			return


	if var_value.type.is_array():
		if not init_value.isImmediate():
			# array assignation by non-immediate value
			out(";")
			nl_indent(1)

			if Value.isUndefined(init_value):
				memzero_sizeof(var_value)
			else:
				memcopy_assign(var_value, init_value)

			out(";")
			return

	if not Value.isUndefined(init_value):
		out(" = ")
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
	is_literal = isinstance(value, ValueLiteral)
	is_comp = value.type.is_composite()

	is_str = False
	if isinstance(value, ValueCons):
		is_str = value.value.type.is_string()

	if not (is_literal or is_comp or is_str):
		need_wrap = precedence(value) < precedenceMax

	nl_str = " \\\n"
	if need_wrap:
		out("(")
	print_value(value)
	if need_wrap:
		out(")")
	nl_str = "\n"


def print_stmt_const(x):
	id = x.id
	v = x.value
	iv = x.init_value

	#if DONT_PRINT_UNUSED:
	#	if v['usecnt'] == 0:
	#		if iv['kind'] != 'call':
	#			return

	# print generic constant as C macro
	if value_is_generic_immediate(v):
		id_str = get_id_str(v)
		# если точный тип константы неизвестен - печатаем ее как макро
		print_macro_definition(id_str, iv)
		global func_undef_list
		func_undef_list.append(id_str)
		return

	# print constant as 'variable'
	# литерал массива включающий в себя переменные печатаем отдельно
	if iv.type.is_array():
		runtimeLiteral = isinstance(iv, ValueLiteral) and not iv.isImmediate()
		if not runtimeLiteral:
			print_variable(get_id_str(x), v.type)
			out(";")
			nl_indent()
			do_assign(v, iv)
			return

	# Локальные константы (втч. композитные) печатаем как переменные
	# ПОТОМУ ЧТО: они должны "заморозить" свои значения по месту
	print_variable(get_id_str(x), v.type, as_const=True)
	out(" = ")
	print_value(iv)
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
	out(str_literal_string(x.text.asset, char_width=x.text.type.width))

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



def assign_array(left, right):
	# если справа 'обернутое' значение
	# (для того чтобы в C вернуть массив из функции
	# его нужно 'обернуть' в структуру)
	if isinstance(right, ValueCall):
		out(str_value_call(right, [], sret=left))
		return
	
	memcopy_assign(left, right)
	return


def do_assign(left, right):
	#out("/*%s*/" % right['kind'])

	if right.type.is_array():
		assign_array(left, right)

	else:
		print_value(left)
		out(" = ")
		print_value(right)

	out(";")
	return


def print_stmt_assign(x):
	do_assign(x.left, x.right)


def print_stmt_value(x):
	print_value(x.value); out(";")


def print_stmt(x):
	assert(isinstance(x, Stmt))
	nl_indent(x.nl)
	if isinstance(x, StmtBlock): print_stmt_block(x)
	elif isinstance(x, StmtValueExpression): print_stmt_value(x)
	elif isinstance(x, StmtAssign): print_stmt_assign(x)
	elif isinstance(x, StmtReturn): print_stmt_return(x)
	elif isinstance(x, StmtIf): print_stmt_if(x, need_else_branch=False)
	elif isinstance(x, StmtWhile): print_stmt_while(x)
	elif isinstance(x, StmtDefVar): print_stmt_var(x)
	elif isinstance(x, StmtDefConst): print_stmt_const(x)
	elif isinstance(x, StmtBreak): print_stmt_break(x)
	elif isinstance(x, StmtAgain): print_stmt_again(x)
	elif isinstance(x, StmtComment): print_comment(x)
	elif isinstance(x, StmtAsm): print_stmt_asm(x)
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
	indent_up()
	print_stmts(s.stmts)
	indent_down()
	endnl = s.nl_end
	newline(n=endnl)
	if endnl:
		indent()
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
	print_type(ftype, label=id_str)




def print_decl_func(x):
	#if 'gnu_att' in x:
	#	out('__attribute__((%s))\n' % x['gnu_att'])

	if not x.hasAttribute('extern'):
		if x.access_level == 'private':
			out("static ")

	if x.hasAttribute('inline'):
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

	#if 'gnu_att' in x:
	#	out('__attribute__((%s))\n' % x['gnu_att'])

	if not x.hasAttribute('extern'):
		if x.access_level == 'private':
			out("static ")

	if x.hasAttribute('inline'):
		out("inline ")

	ftype = func.type

	# если функция уже была определена, то обертки над ее типами
	# уже были напечатаны (если они были), и их нельзя печатать еще раз
	#print_wrappers = not 'declared' in func['att']
	print_func_signature(get_id_str(func), ftype)

	if x.stmt == None:
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
			out("\n#undef %s" % id_str)

	func_undef_list = []
	out("\n}")

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
			out("\ntypedef struct %s %s;" % (id_str, id_str))
		return

	out("typedef ")
	print_type(otype, label=id_str)
	out(";")



# Указатель, массив и функция образуют пиздецовый заговор
def print_variable(id_str, t, as_const=False, as_volatile=False, init_value=None, prefix=''):
	assert (t != None)
	print_type(t, label=(prefix + id_str), as_const=as_const, as_volatile=as_volatile)
	if init_value != None:
		out(" = ")
		print_value(init_value)


def print_def_var(x, isdecl=False):
	#if 'gnu_att' in x:
	#	out('__attribute__((%s))\n' % x['gnu_att'])

	#id = x['id']
	var = x.value
	if USE_STATIC_VARIABLES:
		if not var.hasAttribute('global'):
			if not var.hasAttribute('extern'):
				out("static ")

	if var.hasAttribute('extern'):
		out("extern ")

	as_volatile = x.hasAttribute('volatile')

	print_variable(get_id_str(x.value), var.type, as_volatile=as_volatile)

	init_value = x.init_value

	if not Value.isUndefined(init_value):
		out(" = ")
		print_value(init_value, ctx=['no-literal-array-cast'])

	out(";")



def print_def_const(x):
	global nl_str
	const_value = x.value
	init_value = x.init_value
	id = x.id
	id_str = get_id_str(const_value)

	# глобальные константы-массивы печатаем особенно
	# сперва печатаем его литерал как одноименный макрос с префиксом '_'
	# затем создаем одноименную переменную (инициализируем ее макроопределением).
	# обычно будем использовать сам макрос,
	# но в случае индексирования переменной - будем обращаться к переменной
	if const_value.type.is_array():
		print_macro_definition(id_str, init_value, val_ctx=[], prefix='_')
		newline()
		print_variable(id_str, const_value.type, as_const=True)
		out(" = _%s;" % id_str)
		const_value.addAttribute('kostil')
		return

	print_macro_definition(id_str, init_value, val_ctx=[])
	return



def include(string, local=True):
	if local:
		include_text = "#include \"%s\"" % string
	else:
		include_text = "#include <%s>" % string
	out(include_text)



def print_insert(x):
	out(x['str'])


def print_comment(x):
	if isinstance(x, StmtCommentLine):
		print_comment_line(x)
	elif isinstance(x, StmtCommentBlock):
		print_comment_block(x)


def print_comment_block(x):
	out("/*%s*/" % x.text)


def print_comment_line(x):
	lines = x.lines
	i = 0
	n = len(lines)
	while i < n:
		line = lines[i]
		out("//%s" % line['str'])
		i = i + 1
		if i < n:
			newline()
			indent()



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

	if x.access_level == 'private':
		out("static ")

	print_func_signature(get_id_str(sym), x['symbol']['type'])
	out(";")



def print_directive(x):
	pass


def is_private(x):
	if isinstance(x, StmtDef):
		return x.access_level == 'private'
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



def print_header(module, outname):
	outname = outname + '.h'
	output_open(outname)

	guardsymbol = outname.split("/")[-1]
	guardsymbol = guardsymbol[:-2].upper() + '_H'
	newline()
	out("#ifndef %s\n" % guardsymbol)
	out("#define %s\n" % guardsymbol)
	newline()
	include("stdint.h", local=False)
	newline()
	include("stdbool.h", local=False)
	newline()

	nl_after_defs = False
	for x in module.defs:
		if isinstance(x, StmtDirective):
			if isinstance(x, StmtDirectiveCInclude):
				newline()
				include(x.c_name, local=x.is_local)
				nl_after_defs = True
			#print_directive(x)

	if nl_after_defs:
		newline()

	# print C `#include ""` directive for included modules
	nl_after_incs = False
	for inc in module.included_modules:
		if not 'do_not_include' in inc.att:
			newline()
			include(inc.id + '.h', local=True)
			nl_after_incs = True

	if nl_after_incs:
		newline()

	for x in module.defs:
		if is_private(x):
			continue

		if x.hasAttribute('c_no_print') or x.hasAttribute('no_print'):
			continue

		if isinstance(x, StmtComment):
			continue

		if isinstance(x, StmtDirective):
			if isinstance(x, StmtDirectiveCInclude):
				continue

		#newline(x.nl)
		if x.nl >= 2:
			newline(2)
		else:
			newline(1)

		if isinstance(x, StmtImport):
			if not 'do_not_include' in x.module.att:
				s = os.path.basename(x.impline)
				include(s + '.h', local=True)

		elif isinstance(x, StmtDefFunc):
			if x.hasAttribute('inline'):
				print_def_func(x)
				continue
			print_decl_func(x)
		elif isinstance(x, StmtDefVar):
			print_deps(x.deps)
			print_def_var(x)
		elif isinstance(x, StmtDefType):
			print_deps(x.deps)
			print_def_type(x)
		elif isinstance(x, StmtDefConst):
			print_deps(x.deps)
			print_def_const(x)
		elif isinstance(x, StmtComment):
			print_comment(x)

	newline()
	newline()
	out("#endif /* %s */" % guardsymbol)
	newline()
	output_close()
	return



macro_definitions = {
	#
	'use_lengthof': """
#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */
""",

	#
	'use_bigint': """
#define BIG_INT128(hi64, lo64) (((__int128)(hi64) << 64) | ((__int128)(lo64)))
#define BIG_INT256(x3, x2, x1, x0)
"""
}

def print_cfile(module, _outname):
	outname = _outname + '.c'

	output_open(outname)

	if 'c_no_print' in module.att:
		output_close()
		return

	# before all print first comment (header) if present
	if len(module.defs) > 0:
		first = module.defs[0]
		if isinstance(first, StmtComment):
			print_comment(first)
			module.defs = module.defs[1:]
			newline()

	guardsymbol = ''

	newline()
	include("stdint.h", local=False)
	newline()
	include("stdbool.h", local=False)
	newline()
	include("string.h", local=False)

	if 'use_va_arg' in module.att:
		newline()
		include("stdarg.h", local=False)

	for x in module.defs:
		if isinstance(x, StmtDirectiveCInclude):
			newline()
			include(x.c_name, local=x.is_local)

	newline()
	newline()
	include("%s.h" % module.id)
	newline()


	for use in module.att:
		if use in macro_definitions:
			out(macro_definitions[use])


	if len(module.anon_recs) > 0:
		out("\n\n/* anonymous records */")
		for anon_rec in module.anon_recs:
			nl_indent()
			print_type_record(anon_rec, tag=anon_rec.c_anon_id)
			out(";")


	for x in module.defs:
		if x.hasAttribute('c_no_print') or x.hasAttribute('no_print'):
			continue

		if isinstance(x, StmtDirectiveCInclude):
			continue

		if x.nl >= 2:
			newline(2)
		else:
			newline(1)

		if isinstance(x, StmtDefConst) and is_private(x):
			print_deps(x.deps)
			print_def_const(x)
		elif isinstance(x, StmtDefType) and is_private(x):
			print_deps(x.deps)
			print_def_type(x)
		elif isinstance(x, StmtDefVar):
			print_deps(x.deps)
			print_def_var(x)
		elif isinstance(x, StmtDefFunc):
			print_deps(x.deps)
			print_def_func(x)
		elif isinstance(x, StmtComment):
			print_comment(x)
		elif isinstance(x, StmtDirective):
			print_directive(x)

	newline()
	newline()
	output_close()



def run(module, _outname, options):
	global cmodule
	cmodule = module

	hpath = _outname
	if 'include_dir' in options:
		inc_dir = options['include_dir']
		hname = os.path.basename(_outname)
		hpath = inc_dir + '/' + hname

	print_header(module, hpath)
	print_cfile(module, _outname)
	return



# возвращает само значение из цепочки cons
# (если только это не cons который приводит generic_composite,
# тк такой cons нужно печатать)
def get_root_value(x):
	if isinstance(x, ValueCons):
		# конструирование complex_immediate печатаем
		# for: (uint32_t[3]){1, 2, 3}
		# for: (Point){.x=1, .y=2}
		if x.value.isImmediate():
			return x
		return get_root_value(x.value)
	return x



def cons_vla_from_literal_array(x):
	if isinstance(x, ValueCons):
		if x.type.is_vla():
			#return x['value']['kind'] in ['literal', 'add']
			if isinstance(x, ValueBin):
				return x.op in ['literal', 'add']
	return False


# получает значение, печатает указатель на его корень (корневое значение)
def str_value_as_ptr(x):
	sstr = ''
	yy = x
	x = get_root_value(x)

	#print(x.__class__)
	if isinstance(x, ValueDeref):
		return str_value(x.value)

	if isinstance(x, ValueLiteral):
		print("SDSDSD")
		if x.type.is_string():
			return str_value(x)

	if isinstance(x, ValueCons):
		sstr += "/**/"
		# for *s == "Hi!"
		# string literal will be implicitly casted to StrX
		# and for getting pointer to this string
		# we need to print just string literal,
		# because in C string literal is pointer to c-string
		#if x.type.is_str() and
		if x.value.type.is_string():
			return str_value(x.value)

	sstr += "&"

	t = yy.type
	# КОСТЫЛЬ!

	if isinstance(x, ValueBin) and x.op in ['literal', 'add']:
		sstr += '(' + str_type(t) + ')'

	elif cons_vla_from_literal_array(x):
		# we need to print:
		#  &(uint32_t[]){1, 2, 3, 4, 5}
		# instead of:
		#  &(uint32_t[len]){1, 2, 3, 4, 5}
		sstr += '(' + str_type(t) + ')'
		sstr += str_value(x.value)
		return sstr

	sstr += str_value(x)
	return sstr



def memcopy_assign(left, right):
	rv = get_root_value(right)
	if rv.isZero():
		memzero_sizeof(left)
		return

	out("memcpy(")
	out(str_value_as_ptr(left))
	out(", ")
	out(str_value_as_ptr(right))
	out(", sizeof ")
	#print_type(left.type)
	print_value(left)
	out(")")


def memzero_sizeof(left):
	out("memset(")
	out(str_value_as_ptr(left))
	out(", 0, sizeof ")
	print_value(left)
	out(")")


def memcmp_eq(left, right, op='eq'):
	return memcmp_eq_str(left, right, op=op)


def strcmp_str(left, right, op='eq'):
	# не берем все в скобки все тк это eq операция
	# и ее приоритет не нарушается (!)
	sstr = 'strcmp('
	sstr += str_value_as_ptr(left)
	sstr += ', '
	sstr += str_value_as_ptr(right)
	if op == 'eq':
		sstr += ') == 0'
	else:
		sstr += ') != 0'
	return sstr


def memcmp_eq_str(left, right, op='eq'):
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
	if op == 'eq':
		sstr += ') == 0'
	else:
		sstr += ') != 0'
	return sstr


