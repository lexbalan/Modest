# Есть проблема с массивом generic int когда индексируешь и приводишь к инту
# но индексируешь переменной (в цикле например)


from error import info, error, fatal
from .common import *
import type as htype
from type import select_common_type, type_print
from value.value import value_is_undefined, value_is_immediate, value_is_generic_immediate, value_is_zero, value_attribute_check, value_print, value_index_array, value_is_literal
from value.integer import value_integer_create
from util import align_bits_up, nbits_for_num, get_item_by_id, align_to
from main import settings
import foundation

import copy

INDENT_SYMBOL = "\t"


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


def newline(n=1):
	out(nl_str * n)


def indent():
	ind(INDENT_SYMBOL)


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
	['pos', 'neg', 'not', 'cons', 'ref', 'deref', 'sizeof', 'alignof', 'offsetof', 'lengthof'], #10
	['call', 'index', 'access', 'access_module'], #11
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



def get_id_str(x):
	if not 'id' in x:
		return None

	if 'c' in x['id']:
		return x['id']['c']

	id_str = x['id']['str']
	if 'prefix' in x['id']:
		prefix = x['definition']['module']['prefix']
		if prefix != None:
			id_str = prefix + '_' + id_str
	return id_str


def print_id(x, prefix=''):
	out(prefix + get_id_str(x))





def strTypeRecord(t, tag=""):
	s = "struct"

	if 'packed' in t['att']:
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
	for field in t['fields']:

		if prev_nl == 0:
			s += " "

		if 'comments' in field:
			for comment in field['comments']:
				#s += str_nl_indent(comment['nl'])
				#print_comment(comment)
				pass

		s += str_nl_indent(field['nl'])
		prev_nl = field['nl']

		s+= strType(field['type'], core='', label=get_id_str(field))
		s += ";"

	indent_down()
	s += str_nl_indent(field['nl'])
	s += "}"
	return s



"""def print_type_enum(t):
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
	out("}")"""


def type_get_aka(t):
	if 'id' in t:
		if 'c' in t['id']:
			return t['id']['c']
		return get_id_str(t)

	if 'c_anon_id' in t:
		return 'struct ' + t['c_anon_id']

	return None




def prespace(s):
	if s == '':
		return ''
	return ' ' + s


def strTypeArray(t, label='', core=''):
	dim = ''

	t0 = t

	# handle array of array .. case
	i = 0
	while True:
		if t['volume']:
			if i > 0:
				dim += ' * '
			if 'id' in t['volume']:
				dim += get_id_str(t['volume'])
			elif value_is_undefined(t['volume']):
				pass
			elif 'asset' in  t['volume']:
				dim += str(t['volume']['asset'])
			else:
				dim += '<' + t['volume']['kind'] + '>'

		if not htype.type_is_array(t['of']):
			break
		t = t['of']
		i += 1

	# now dim like '10' or '20 * 30'

	dim = '[' + dim + ']'
	if htype.type_is_pointer(t['of']):
		of = t['of']
		if htype.type_is_array(of['to']):
			core = core + label + dim
			return strType(of, core=core)

		elif htype.type_is_func(of['to']):
			core = core + label + dim
			return strType(t['of'], core=core)

		elif isTypeSimple(of['to']):
			return strType(of) + core + label + dim

	left = strType(t['of'])

	if not htype.type_is_pointer(t['of']):
		label = prespace(label)
	return left + core + label + dim



def strFuncParamlist(params, va_arg):
	s = '('
	i = 0
	while i < len(params):
		param = params[i]
		if i > 0:
			s += ', '

		ptype = param['type']

		pstr = get_id_str(param)
		if pstr == None:
			pstr = ''
		else:
			# HACK
			# В C параметр не может быть функцией, а у нас - может
			# но реализован как указатель на функцию
			if htype.type_is_array(ptype):
				ptype = htype.type_pointer(ptype)
				pstr = '_' + pstr

		s += strType(ptype, label=pstr)
		i += 1

	if va_arg:
		if i > 0:
			s += ', '
		s += '...'

	s += ')'
	return s


def strTypeFunc(t, label='', core=''):
	fparams = t['params']
	fto = t['to']
	if htype.type_is_array(t['to']):
		# (!) HACK (!)
		# C не умеет возвращать массивы по значению,
		# поэтому если возвращаем массив вернем void
		# а сам массив пойдет через указатель __sret
		# который функция получит своим самым последним параметром
		# (sret = structure return)
		sret_param = {
			'type': htype.type_pointer(t['to']),
			'id': {'isa': 'id', 'id': '__sret', 'c': '__sret'}
		}

		fparams = t['params'] + [sret_param]
		fto = foundation.typeUnit

	params = strFuncParamlist(fparams, t['extra_args'])

	if not isTypeSimple(fto):
		if htype.type_is_pointer(fto):
			if htype.type_is_pointer(fto['to']) or htype.type_is_array(fto['to']) or htype.type_is_func(fto['to']):
				core = core + label + params
				return strType(fto, core=core)

	left = strType(fto)
	if not htype.type_is_pointer(fto):
		label = prespace(label)
	return left + core + label + params



def strTypePointer(t, label, core=''):
	tx = t

	c = ''
	while htype.type_is_pointer(tx):
		tx = tx['to']
		c += '*'

	if isSimSim(t):
		tx = tx['of']

	if not isTypeSimple(tx):
		core = '(' + c + core + label + ')'
		return strType(tx, core=core)

	return strType(tx) + ' ' + c + core + label


def strTypeSimple(t, core='', label=''):
	aka = type_get_aka(t)
	if aka == None:
		if t['kind'] == 'int':
			s = 'int%d_t' % t['width']
			if not t['signed']:
				s = 'u' + s
			aka = s
		else:
			print("unk = " + t['kind'])
			print("generic = " + t['generic'])

	return aka + core + prespace(label)


def isSimSim(t):
	if htype.type_is_array(t['to']):
		if not 'alias' in t['to']['att']:
			return isTypeSimple(t['to']['of'])


def isTypeSimple(t):
	if type_get_aka(t) != None:
		return True
	return not t['kind'] in ['array', 'pointer', 'func', 'record']
	#return type_get_aka(t) != None


def strType(t, core='', label=''):
	if isTypeSimple(t):
		return strTypeSimple(t, core, label)
	elif htype.type_is_pointer(t):
		return strTypePointer(t, label, core)
	elif htype.type_is_array(t):
		return strTypeArray(t, label, core)
	elif htype.type_is_func(t):
		return strTypeFunc(t, label, core)
	elif htype.type_is_record(t):
		return strTypeRecord(t) + prespace(label)

	return '<type:%s>' % t['kind']



def print_type(t, label=''):
	tstr = strType(t, core='', label=label)
	out(tstr)


def print_type_array(t):
	out(strTypeArray(t))


def print_type_record(t, tag=''):
	out(strTypeRecord(t, tag=tag))




bin_ops = {
	'or': '|', 'xor': '^', 'and': '&', 'shl': '<<', 'shr': '>>',
	'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
	'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'rem': '%',
	'logic_and': '&&', 'logic_or': '||'
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

	# GCC выдает warning например в: 1 << 2 + 2, тк считает
	# Что юзер имел в виду (1 << 2) + 2, а у << приоритет тние
	# чтобы он не ругался, завернем такие выражения в скобки

	if op in ['eq', 'ne']:
		if htype.type_is_record(left['type']):
			return print_value_eq_record(x, ctx)
		elif htype.type_is_array(left['type']):
			return print_value_eq_array(x, ctx)
		elif htype.type_is_string(left['type']):
			return print_value_bool_lit(x, ctx)


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

	elif op == 'add':
		if htype.type_is_array(left['type']):
			return print_value_literal(x, ctx)

		if htype.type_is_string(left['type']):
			if left['type']['width'] != right['type']['width']:
				# для случаев вроде "Hello" + U"World!"
				# (печатаем сам литерал, тк C иначе не умеет)
				# (U"Hello World!")
				print_value_string(x, ctx)
				return

			print_value(left, need_wrap=need_wrap_left)
			out(' ')
			print_value(right, need_wrap=need_wrap_right)
			return

	print_value(left, need_wrap=need_wrap_left)
	out(' %s ' % bin_ops[op])
	print_value(right, need_wrap=need_wrap_right)



def print_value_eq_record(x, ctx):
	return print_value_eq_composite(x, ctx)


def print_value_eq_array(x, ctx):
	return print_value_eq_composite(x, ctx)


def print_value_eq_composite(x, ctx):
	op = x['kind']
	left = x['left']
	right = x['right']

	if value_is_immediate(x):
		return print_value_bool_lit(x, ctx)

	memcmp_eq(left, right, op=op)
	return



un_ops = {
	'ref': '&', 'deref': '*',
	'pos': '+', 'neg': '-',
	'not': '~', 'logic_not': '!'
}


def print_value_un(v, ctx):
	op = v['kind']
	value = v['value']

	p0 = precedence(v)
	pv = precedence(value)

#	if v['kind'] == 'ref':
#		if htype.type_is_array(value['type']):
#			if value['kind'] != 'slice':
#				if isSimSim(v['type']):
#					# to prevent:
#					# "warning: incompatible pointer types passing 'uint8_t (*)[10]' to
#					# parameter of type 'uint8_t *'"
#					out("(")
#					print_type(v['type'])
#					out(")")

	out(un_ops[op])
	print_value(value, need_wrap=pv<p0)

	if v['kind'] == 'ref':
		if htype.type_is_array(value['type']):
			if value['kind'] != 'slice':
				if isSimSim(v['type']):
					# take pointer to first array item, not pointer to array
					out("[0]")



def print_value_call(v, ctx, arrayResult=None):
	left = v['func']

	print_value(left)

	ftype = left['type']
	if htype.type_is_pointer(ftype):
		ftype = ftype['to']
	params = ftype['params']
	args = v['args']
	n = len(args)

	out("(")

	if arrayResult != None:
		print_value(arrayResult)
		if n > 0:
			out(", ")

	i = 0
	while i < n:
		a = None
		if args[i]['isa'] == 'initializer':
			a = args[i]['value']
		else:
			a = args[i]

		# не всегда когда есть аргумент есть и соотв ему параметер (!)
		try:
			# если тип аргумента отличается модификатором (const, volatile)
			# то явно приведем его к типу параметра, чтобы C не ругался
			# (try: проверяем только те аргументы, для которых есть параметры)
			p = params[i]
			pt = p['type']

			if not htype.type_eq(pt, a['type'], opt=['att_checking']):
				print_cast(pt, a)
			else:
				print_value(a, ctx=ctx)

		except:
			print_value(a, ctx=ctx)

		i = i + 1
		if i < n:
			out(", ")

	out(")")



def print_value_slice(x, ctx):
	#out("/* slice */")
	varray = x['left']
	y = value_index_array(varray, x['type'], x['index_from'], ti=None)
	print_value_index(y, ctx)



def print_value_index(x, ctx):
	array = x['array']

	if htype.type_is_pointer(array['type']):
		# index trough pointer to array (requires dereference)
		ptr2array = array
		need_wrap = precedence(ptr2array) < precedence(x)

		if not isSimSim(array['type']):
			out("(*")

		print_value(ptr2array, ctx=['do_unwrap'], need_wrap=need_wrap)

		if not isSimSim(array['type']):
			out(")")

		out("["); print_value(x['index']); out("]")
		return

	indexes = []

	xx = x
	while xx['kind'] == 'index':
		a = xx['array']
		indexes.append(xx['index'])
		xx = a

	dims = []
	yy = xx['type']
	while htype.type_is_closed_array(yy):
		dims.append(yy['volume'])
		yy = yy['of']

	# поскольку индексация идет в обратном порядке,
	# приведем список к прямому порядку (так как индексация записывается)
	indexes.reverse()

	need_wrap = precedence(xx) < precedence(x)

	ctx=['do_unwrap']

	#out("/*? %s ?*/" % xx['kind'])
	print_value(xx, ctx=ctx, need_wrap=need_wrap)

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



def print_value_access(x, ctx):
	left = x['record']

	if htype.type_is_pointer(left['type']):
		need_wrap = precedence(left) < precedence(x)
		print_value(left, need_wrap=need_wrap)
		out("->")
		print_id(x['field'])
		return

	# если имеем дело c дженерик записью (глоб константа)
	#if htype.type_is_generic(left['type']):
	#	if value_is_immediate(x):
	if value_is_generic_immediate(left):
		print_value_literal(x, ['print_immediate'])
		return

	need_wrap = precedence(left) < precedence(x)
	print_value(left, need_wrap=need_wrap)
	out('.')
	print_id(x['field'])



def print_value_access_module(v, ctx):
	left = v['left']
	#out("%s.%s" % (left['id'], v['right']['str']))

	id_str = get_id_str(v['right'])
	out("%s" % (id_str))


def print_cast_hard(t, v, ctx=[]):
	# hard cast is possible only in function body
	assert(is_local_context())
	out("*(")
	print_type(t)
	out("*)&")
	need_wrap = precedence(v) < precedence({'kind': 'cons'})
	print_value(v, ctx=ctx, need_wrap=need_wrap)



def print_cast(t, v, ctx=[]):
	#array_as_ptr = not 'array_as_array' in ctx
	out("("); print_type(t); out(")")

	need_wrap = precedence(v) < precedence({'kind': 'cons'})
	if v['kind'] in ['literal', 'add']:
		need_wrap = not htype.type_is_composite(v['type'])

	print_value(v, ctx=ctx, need_wrap=need_wrap)





def print_value_cons_record(x, ctx):
	to_type = x['type']
	value = x['value']
	from_type = value['type']

	if htype.type_is_generic_record(from_type):
		if is_local_context():
			print_cast(to_type, value)
		else:
			print_value(value, ctx=ctx)
		return


	# RecordA -> RecordB
	#if htype.type_is_record(to_type):
	if htype.type_is_record(from_type):
		# C cannot cast struct to struct (!)
		print_cast_hard(to_type, value)
		return



def print_value_cons_array(x, ctx):
	to_type = x['type']
	value = x['value']
	from_type = value['type']

	# Local:
	# В C мы не можем просто напечатать {0, 1, 2, 3} и получить массив
	# Но мы можем сделать так: (<item_type>[4]){0, 1, 2, 3}
	# But in Global:
	# печатаем как есть, иначе ошибка (о Боже C это нечто!):
	# {0, 1, 2, 3}
	#if is_global_context():
	if htype.type_is_generic_array(from_type):
		# если это литеральная (и не глобальная) константа-массив
		# то мы должны ее привести к требуемому типу
		is_const = value['kind'] in ['const', 'literal', 'add']
		if is_const and not 'kostil' in value['att']:
			ctx=['array_as_array']

			if htype.type_is_char(to_type['of']):
				if htype.type_is_string(from_type['of']):
					chars = []
					for item in value['items']:
						ch = item['asset']
						chars.append(ch)

					char_width = to_type['of']['width']
					print_string_literal(chars, char_width)
					return

			print_cast(to_type, value, ctx=ctx)
		else:
			print_value(value, ctx=ctx)
		return


	if htype.type_is_string(from_type):
		if htype.type_is_char(to_type['of']):
			# cast <string literal> to <array of chars>:
			if to_type['of']['width'] == from_type['width']:
				print_value(value, ctx=ctx)
			else:
				print_string_literal(value['asset'], to_type['of']['width'])
			return

	# for:
	#    var x: [10]Word8 = "0123456789"
	if htype.type_is_string(value['type']):
		print_value(value, ctx=ctx)
		return

	return print_cast(to_type, value, ctx)





def print_suffix(to_type, num):
	req_bits = nbits_for_num(num)

	# ! `not is_signed()`, because here can be Word (it nor signed, nor unsigned) !
	if not htype.type_is_signed(to_type):
		if req_bits >= CC_INT_SIZE_BITS:
			out("U")

	if req_bits <= CC_INT_SIZE_BITS:
		pass  # int
	elif req_bits <= CC_LONG_SIZE_BITS:
		out("L")  # long int
	else:
		out("LL")  # long long int





def print_value_cons(x, ctx):
	to_type = x['type']
	value = x['value']
	from_type = value['type']

	if htype.type_is_array(to_type):
		return print_value_cons_array(x, ctx)

	if htype.type_is_record(to_type):
		return print_value_cons_record(x, ctx)

	if htype.type_is_string(from_type):
		# cast <string literal> to <pointer to array of chars>:
		if htype.type_is_pointer(to_type):
			# let genericStringConst = "S-t-r-i-n-g-Ω 🐀🎉🦄"
			# let string8Const = *Str8 genericStringConst  // <-
			if to_type['to']['of']['width'] != from_type['width']:
				print_string_literal(value['asset'], to_type['to']['of']['width'])
				return

		if htype.type_is_char(to_type):
			print_value_char(x, ctx)
			return


	# в у нас типы структурные, в си - номинальные
	# поэтому даже если структуры одинаковы, но имена разные
	# их нужно приводить
	# *RecordA -> *RecordB
	if htype.type_is_pointer_to_record(from_type):
		if htype.type_is_pointer_to_record(to_type):
			# НО если это реально один и тот же тип, то приведение не нужно!
			if id(from_type) != id(to_type):
				print_cast(to_type, value, ctx)
				return


	if htype.type_is_float(to_type):
		if htype.type_is_integer(from_type) or htype.type_is_number(from_type):
			print_cast(to_type, value, ctx)
			return


	if x['method'] == 'implicit':
		# не печатаем обычный implicit_cast
		# (это не касается того что выше ^^)
		print_value(value)

		# print postfix ('u', 'U', 'L', 'LL', etc.)
		if value['kind'] == 'literal':
			if htype.type_is_number(from_type) or htype.type_is_integer(from_type) or htype.type_is_word(from_type):
				# up to 'long long'
				if to_type['width'] <= 64:
					print_suffix(to_type, value['asset'])
		return


	if value['kind'] == 'literal':
		print_value(value)





		return


	# (!) WARNING (!)
	# - in C  int32(-1) -> uint64 => 0xffffffffffffffff
	# - in Cm int32(-1) -> uint64 => 0x00000000ffffffff
	# required: (uint64_t)((uint32)int32_value)
	if htype.type_is_integer(to_type):
		if htype.type_is_integer(from_type) or htype.type_is_number(from_type):
			if htype.type_is_signed(from_type) and htype.type_is_unsigned(to_type):
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

		nl = a['nl']
		if nl > 0:
			newline(n=nl)
			indent()
		else:
			if i > 0:
				out(" ")

		if htype.type_is_closed_array(a['type']):
			print_array_values(a['items'], ctx)
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
	print_string_literal(x['asset'], x['type']['width'])


def print_value_char(x, ctx):
	print_char_literal(x['asset'], x['type']['width'])



def print_string_literal(chars, width):
	utf32_codes = []
	for ch in chars:
		cc = ord(ch)
		utf32_codes.append(cc)
	print_utf32codes_as_string(utf32_codes, width)


def print_char_literal(cc, width):
	print_utf32codes_as_string([cc], width, quote="'")



def print_value_array(v, ctx):
	if htype.type_is_array_of_char(v['type']):
		char_type = v['type']['of']
		char_width = char_type['width']

		# массивы чаров в конце которых только один терминальный ноль
		# печатаем в виде строковых литералов C
		values = v['items']
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
			print_utf32codes_as_string(utf32_codes, width=char_width)
			return

	out("{")
	indent_up()
	print_array_values(v['items'], ctx)
	indent_down()

	if 'nl_end' in v:
		if v['nl_end'] > 0:
			newline(n=v['nl_end'])
			indent()

	out("}")




def print_value_record(v, ctx):
	out("{")
	indent_up()

	nitems = len(v['items'])
	i = 0

	# for situation when firat item is value_zero
	# without it, forst value will be printed with space before it.
	item_printed = False

	while i < nitems:
		item = v['type']['fields'][i]
		field_id_str = get_id_str(item)
		ini = get_item_by_id(v['items'], field_id_str)

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
	#	out(")")
	return



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
	prefix = ""
	if width <= 8: prefix = ""
	elif width <= 16: prefix = "u"
	elif width <= 32: prefix = "U"
	out(prefix)
	out(quote)
	for cc in utf32_codes:
		out(code_to_char(cc))
	out(quote)



def print_value_bool_lit(x, ctx):
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

	# Big Number?
	if x['type']['width'] > 64:
		if True:
			# print Big Numbers
			high64 = (num >> 64) & 0xFFFFFFFFFFFFFFFF
			low64 = num & 0xFFFFFFFFFFFFFFFF

			out("(((__int128)0x%XULL << 64) | ((__int128)0x%XULL))" % (high64, low64))
			return


	if value_attribute_check(x, 'hexadecimal'):
		fmt = "0x%%0%dX" % nsigns
		out(fmt % num)
		return  #? 0xXXXXXXXXUL is normal?
	else:
		out(str(num))



def print_value_float(x, ctx):
	out('{0:f}'.format(x['asset']))


def print_value_ptr(x, ctx):
	if x['asset'] == 0:
		out("NULL")
	else:
		out("(("); print_type(x['type']); out(")")
		out("0x%08X)" % x['asset'])


def print_value_literal(x, ctx):
	t = x['type']
	if htype.type_is_number(t): print_value_integer(x, ctx)
	elif htype.type_is_integer(t): print_value_integer(x, ctx)
	elif htype.type_is_word(t): print_value_integer(x, ctx)
	elif htype.type_is_float(t): print_value_float(x, ctx)
	elif htype.type_is_string(t): print_value_string(x, ctx)
	elif htype.type_is_record(t): print_value_record(x, ctx)
	elif htype.type_is_array(t): print_value_array(x, ctx)
	elif htype.type_is_bool(t): print_value_bool_lit(x, ctx)
	elif htype.type_is_char(t): print_value_char(x, ctx)
	elif htype.type_is_pointer(t): print_value_ptr(x, ctx)
	elif htype.type_is_enum(t): print_value_enum(x, ctx)
	else: error("print_value_literal not implemented", x['ti'])


def print_value_by_id(x, ctx=[], prefix=''):
	if 'c' in x:
		out(x['c'])
	else:
		print_id(x, prefix)



# & let
def print_value_const(x, ctx):
	prefix=''

	if htype.type_is_array(x['type']):
		if is_global_context():
			prefix = '_'

	print_value_by_id(x, ctx, prefix)
	return


def print_value_func(x, ctx):
	return print_value_by_id(x, ctx, prefix='')


def print_value_var(x, ctx):
	return print_value_by_id(x, ctx, prefix='')


def print_value_sizeof_value(x, ctx):
	out("sizeof ")
	print_value(x['of'])


def print_value_sizeof_type(x, ctx):
	out("sizeof(")
	print_type(x['of'])
	out(")")


def print_value_alignof(x, ctx):
	out("__alignof(")
	print_type(x['of'])
	out(")")


def print_value_offsetof(x, ctx):
	out("__offsetof(")
	print_type(x['of'])
	out(", ")
	out(x['field']['str'])
	out(")")


def print_value_lengthof(x, ctx):
	v = x['value']
	if not v['kind'] in ['var', 'let']:
		print_value(v['type']['volume'], need_wrap=True)
		return

	# sizeof(array) / sizeof(array[0])
	out("LENGTHOF(")
	print_value(v)
	out(")")
	return



def print_value_va_start(x, ctx):
	out("va_start(")
	print_value(x['va_list'])
	out(", ")
	print_value(x['last_param'])
	out(")")


def print_value_va_arg(x, ctx):
	out("va_arg(")
	print_value(x['va_list'])
	out(", ")
	print_type(x['type'])
	out(")")


def print_value_va_end(x, ctx):
	out("va_end(")
	print_value(x['va_list'])
	out(")")


def print_value_va_copy(x, ctx):
	out("va_copy(")
	print_value(x['dst'])
	out(", ")
	print_value(x['src'])
	out(")")


def print_value(x, ctx=[], need_wrap=False):
	if need_wrap:
		out("(")

	k = x['kind']

	if k == 'literal': print_value_literal(x, ctx)
	elif k in bin_ops: print_value_bin(x, ctx)
	elif k in un_ops: print_value_un(x, ctx)
	elif k == 'cons': print_value_cons(x, ctx)
	elif k == 'const': print_value_const(x, ctx)
	elif k == 'func': print_value_func(x, ctx)
	elif k == 'var': print_value_var(x, ctx)
	elif k == 'call': print_value_call(x, ctx)
	elif k == 'index': print_value_index(x, ctx)
	elif k == 'slice': print_value_slice(x, ctx)
	elif k == 'access': print_value_access(x, ctx)
	elif k == 'access_module': print_value_access_module(x, ctx)
	elif k == 'sizeof_value': print_value_sizeof_value(x, ctx)
	elif k == 'sizeof_type': print_value_sizeof_type(x, ctx)
	elif k == 'alignof': print_value_alignof(x, ctx)
	elif k == 'offsetof': y = print_value_offsetof(x, ctx)
	elif k == 'lengthof': y = print_value_lengthof(x, ctx)
	elif k == 'va_start': y = print_value_va_start(x, ctx)
	elif k == 'va_arg': y = print_value_va_arg(x, ctx)
	elif k == 'va_end': y = print_value_va_end(x, ctx)
	elif k == 'va_copy': y = print_value_va_copy(x, ctx)
	else:
		out("<%s>" % k)
		info("HERE<%s>" % k, x)
		fatal("unknown opcode '%s'" % k)
		exit(-1)

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
	global cfunc

	if isSretFunc(cfunc['type']):
		out("memcpy(__sret, ")
		print_value_as_ptr(x['value'])
		out(", sizeof(")
		print_type(x['value']['type'])
		out("));")
		return

	out("return")

	if x['value'] != None:
		out(" ")
		print_value(x['value'])

	out(";")



def print_stmt_var(x):
	var_value = x['var_value']
	init_value = x['init_value']

	#if DONT_PRINT_UNUSED:
	#	if init_value != None:
	#		if var_value['usecnt'] == 0:
	#			if init_value['kind'] != 'call':
	#				return

	print_variable(get_id_str(var_value), var_value['type'])

	v = var_value
	iv = init_value
	# если инициализирующее значение - это
	# литерал массива включающий в себя переменные
	# то печатаем это иначе (w/ memcpy)
	if htype.type_is_array(iv['type']):
		runtimeLiteral = iv['kind'] == 'literal' and not value_is_immediate(iv)
		if not runtimeLiteral:
			out(";")
			nl_indent()
			do_assign(v, iv)
			return


	if htype.type_is_array(var_value['type']):
		if not value_is_immediate(init_value):
			# array assignation by non-immediate value
			out(";")
			nl_indent(1)
			memcopy_assign(var_value, init_value)
			out(";")
			return

	if not value_is_undefined(init_value):
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
	literal = value['kind'] == 'literal'
	is_comp = htype.type_is_composite(value['type'])

	is_str = False
	if value['kind'] == 'cons':
		is_str = htype.type_is_string(value['value']['type'])

	if not (literal or is_comp or is_str):
		need_wrap = precedence(value) < precedenceMax

	nl_str = " \\\n"
	print_value(value, need_wrap=need_wrap)
	nl_str = "\n"


def print_stmt_let(x):
	id = x['id']
	v = x['value']
	iv = x['init_value']

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
	if htype.type_is_array(iv['type']):
		runtimeLiteral = iv['kind'] == 'literal' and not value_is_immediate(iv)
		if not runtimeLiteral:
			print_variable(get_id_str(x), v['type'])
			out(";")
			nl_indent()
			do_assign(v, iv)
			return

	# Локальные константы (втч. композитные) печатаем как переменные
	# ПОТОМУ ЧТО: они должны "заморозить" свои значения по месту
	print_variable(get_id_str(x), v['type'], as_const=True)
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
	print_value_string(x['text'], [])

	# print 'out' pairs
	args1 = x['outputs']
	if len(args1) > 0:
		nl_indent(1)
		out(': ')
		print_list_by(args1, print_asm_pair)
	else:
		out(':')

	# print 'in' pairs
	args2 = x['inputs']
	if len(args2) > 0:
		nl_indent(1)
		out(': ')
		print_list_by(args2, print_asm_pair)
	else:
		out(':')

	# print clobber list
	if len(x['clobbers']) > 0:
		nl_indent(1)
		out(': ')
		print_list_by(x['clobbers'], print_value)


	indent_down()
	nl_indent(1)
	out(");")
	return



def assign_array(left, right):
	# если справа 'обернутое' значение
	# (для того чтобы в C вернуть массив из функции
	# его нужно 'обернуть' в структуру)
	if right['kind'] == 'call':
		print_value_call(right, [], arrayResult=left)
		return

	memcopy_assign(left, right)
	return


def do_assign(left, right):
	#out("/*%s*/" % right['kind'])

	if htype.type_is_array(right['type']):
		assign_array(left, right)

	else:
		print_value(left)
		out(" = ")
		print_value(right)

	out(";")
	return


def print_stmt_assign(x):
	do_assign(x['left'], x['right'])


def print_stmt_value(x):
	print_value(x['value']); out(";")


def print_stmt(x):
	nl_indent(x['nl'])
	k = x['kind']
	if k == 'block': print_stmt_block(x)
	elif k == 'value': print_stmt_value(x)
	elif k == 'assign': print_stmt_assign(x)
	elif k == 'return': print_stmt_return(x)
	elif k == 'if': print_stmt_if(x, need_else_branch=False)
	elif k == 'while': print_stmt_while(x)
	elif k == 'var': print_stmt_var(x)
	elif k == 'let': print_stmt_let(x)
	elif k == 'break': out('break;')
	elif k == 'again': out('continue;')
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



# Функция возвращает массив по значению?
def isSretFunc(ftype):
	return htype.type_is_closed_array(ftype['to'])


def print_func_return_type(ftype):
	if not isSretFunc(ftype):
		print_type(ftype['to'])
		return

	out("void")
	return


def print_func_paramlist(ftype):
	params = ftype['params']
	extra_args = ftype['extra_args']

	out("(")

	if isSretFunc(ftype):
		print_variable("__sret", ftype['to'])
		if len(params) > 0:
			out(", ")

	i = 0
	for param in params:
		if i > 0: out(", ")

		paramId = get_id_str(param)
		if htype.type_is_closed_array(param['type']):
			paramId = '_' + paramId
		print_variable(paramId, param['type'])
		i = i + 1

	if extra_args:
		out(", ...")

	out(")")
	return


def print_func_signature(id_str, ftype):
	print_type(ftype, label=id_str)




def print_decl_func(x):
	if 'gnu_att' in x:
		out('__attribute__((%s))\n' % x['gnu_att'])

	if x['access_level'] == 'private':
		out("static ")

	if 'inline' in x['att']:
		out("inline ")

	ftype = x['value']['type']
	id_str = get_id_str(x['value'])
	print_func_signature(id_str, ftype)
	out(";")





def print_def_func(x):
	global declared

	func = x['value']

	global cfunc
	cfunc = func

	if 'gnu_att' in x:
		out('__attribute__((%s))\n' % x['gnu_att'])

	if x['access_level'] == 'private':
		out("static ")

	if 'inline' in x['att']:
		out("inline ")

	ftype = func['type']

	# если функция уже была определена, то обертки над ее типами
	# уже были напечатаны (если они были), и их нельзя печатать еще раз
	#print_wrappers = not 'declared' in func['att']
	print_func_signature(get_id_str(func), ftype)

	if x['stmt'] == None:
		out(";")
		return

	if styleguide['LINE_BREAK_BEFORE_FUNC_BRACE']:
		newline()
	else:
		out(" ")

	out("{")
	indent_up()


	# for any array parameter print local holder value
	for param in ftype['params']:
		if htype.type_is_closed_array(param['type']):
			nl_indent(1)

			paramId = get_id_str(param)
			print_variable(paramId, param['type'])
			out(";")

			nl_indent(1)

			out("memcpy(%s, %s" % (paramId, '_' + paramId))
			out(", sizeof(")
			print_type(param['type'])
			out("));")


	stmts = x['stmt']['stmts']
	print_statements(stmts)

	indent_down()

	global func_undef_list
	if len(func_undef_list) > 0:
		newline()
		for id_str in func_undef_list:
			out("\n#undef %s" % id_str)

	func_undef_list = []
	out("\n}")

	if not func['id']['str'] in declared:
		declared.append(func['id']['str'])

	cfunc = None





def print_decl_type(x):
	id_str = get_id_str(x['type'])
	out("struct %s;" % id_str)
	if not NO_TYPEDEF_STRUCTS:
		out("\ntypedef struct %s %s;" % (id_str, id_str))


def print_def_type(x):
	global declared

	id_str = get_id_str(x['type'])
	otype = x['original_type']

	if htype.type_is_record(otype):
		print_type_record(otype, tag=id_str)
		out(";")
		if not id_str in declared:
			out("\ntypedef struct %s %s;" % (id_str, id_str))
		return

	out("typedef ")
	print_type(otype, label=id_str)
	out(";")



# Указатель, массив и функция образуют пиздецовый заговор
def print_variable(id_str, t, as_const=False, init_value=None, prefix=''):
	assert (t != None)
	print_type(t, label=(prefix + id_str))
	if init_value != None:
		out(" = ")
		print_value(init_value)


def print_def_var(x, isdecl=False):
	if 'gnu_att' in x:
		out('__attribute__((%s))\n' % x['gnu_att'])

	#id = x['id']
	var = x['var_value']
	if USE_STATIC_VARIABLES:
		if not 'global' in var['att']:
			if not 'extern' in var['att']:
				out("static ")

	if 'extern' in var['att']:
		out("extern ")
	if 'volatile' in var['att']:
		out("volatile ")

	print_variable(get_id_str(x['var_value']), var['type'])

	init_value = x['init_value']

	if not value_is_undefined(init_value):
		out(" = ")
		print_value(init_value, ctx=['no-literal-array-cast'])

	out(";")



def print_def_const(x):
	global nl_str
	const_value = x['value']
	init_value = x['init_value']
	id = x['id']
	id_str = get_id_str(const_value)

	# глобальные константы-массивы печатаем особенно
	# сперва печатаем его литерал как одноименный макрос с префиксом '_'
	# затем создаем одноименную переменную (инициализируем ее макроопределением).
	# обычно будем использовать сам макрос,
	# но в случае индексирования переменной - будем обращаться к переменной
	if htype.type_is_array(const_value['type']):
		print_macro_definition(id_str, init_value, val_ctx=[], prefix='_')
		newline()
		print_variable(id_str, const_value['type'], as_const=True)
		out(" = _%s;" % id_str)
		const_value['att'].append('kostil')
		return

	print_macro_definition(id_str, init_value, val_ctx=[])
	return


def print_include(x):
	include(x['c_name'], local=x['local'])


def include(string, local=True):
	if local:
		include_text = "#include \"%s\"" % string
	else:
		include_text = "#include <%s>" % string
	out(include_text + '\n')



def print_insert(x):
	out(x['str'])


def print_comment(x):
	k = x['kind']
	if k == 'line': print_comment_line(x)
	elif k == 'block': print_comment_block(x)


def print_comment_block(x):
	out("/*%s*/" % x['text'])


def print_comment_line(x):
	lines = x['lines']
	i = 0
	n = len(lines)
	while i < n:
		line = lines[i]
		out("//%s" % line['str'])
		i = i + 1
		if i < n:
			newline()
			indent()



def cdirectives(module):
#	for im in module['imports']:
#		imported_module = module['imports'][im]
#
#		for obj in imported_module['defs']:
#			if obj['isa'] == 'directive':
#				if obj['kind'] == 'c_include':
#					print_include(obj)

	for obj in module['defs']:
		if obj['isa'] == 'directive':
			if obj['kind'] == 'c_include':
				print_include(obj)



def print_cdecl_type(x):
	newline(n=x['nl'])

	id_str = get_id_str(x['type'])
	out("struct %s;" % id_str)
	if not NO_TYPEDEF_STRUCTS:
		out("\ntypedef struct %s %s;" % (id_str, id_str))


def print_cdecl_func(x):
	newline(n=x['nl'])

	#if 'gnu_att' in x:
	#	out('__attribute__((%s))\n' % x['gnu_att'])

	if x['access_level'] == 'private':
		out("static ")

	print_func_signature(get_id_str(sym), x['symbol']['type'])
	out(";")


def print_directive(x):
	k = x['kind']
	#if k == 'import': print_include(x)
	if k == 'insert':
		newline(n=x['nl'])
		print_insert(x)
	elif k == 'cdecl_func':
		newline(n=x['nl'])
		print_cdecl_func(x)
	elif k == 'cdecl_type':
		newline(n=x['nl'])
		print_cdecl_type(x)



def is_private(x):
	if 'access_level' in x:
		return x['access_level'] == 'private'
	return False


def print_deps(deps):
	global declared
	if len(deps) == 0:
		return

	# печатаем декларации для типов от которых зависит этот тип
	for dep in deps:
		if not 'id' in dep:
			error("undefined", dep['ti'])
			return

		out("\n")
		id_str = get_id_str(dep)
		if not id_str in declared:
			declared.append(id_str)
			if dep['isa'] == 'type':
				print_decl_type(dep['definition'])
			elif dep['isa'] == 'value':
				print_decl_func(dep['definition'])

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
	include("stdbool.h", local=False)
	#include("string.h", local=False)
	cdirectives(module)

	# print directives (only for header)
	for obj in module['defs']:
		if obj['isa'] == 'directive':
			if obj['kind'] == 'c_include':
				print_include(obj)
			elif obj['kind'] == 'import':
				if not 'do_not_include' in obj['import_module']['att']:
					x = os.path.basename(obj['str'])
					include(x + '.h', local=True)


	newline()

#	out("\n/* forward type declaration */")
#	for rec in module['records']:
#		rec_id = get_id_str(rec)
#		out("\ntypedef struct %s %s; //" % (rec_id, rec_id))


	for x in module['defs']:
		if 'c_no_print' in x['att']:
			continue
		if 'no_print' in x['att']:
			continue

		if is_private(x):
			continue

		isa = x['isa']

		if isa in ['def_func']:
			if 'inline' in x['att']:
				newline(1)
				print_def_func(x)
				continue
			newline(1)
			print_decl_func(x)
		elif isa == 'def_var':
			print_deps(x['deps'])
			newline(1)
			print_def_var(x)
		elif isa in ['def_type', 'decl_type']:
			print_deps(x['deps'])
			newline(1)
			print_def_type(x)
		elif isa == 'def_const':
			print_deps(x['deps'])
			newline(1)
			print_def_const(x)

	newline()
	newline()
	out("#endif /* %s */" % guardsymbol)
	newline()
	output_close()
	return



def print_cfile(module, _outname):
	outname = _outname + '.c'

	output_open(outname)

	if 'c_no_print' in module['att']:
		print("--------MODULE CNOPRINT")
		output_close()
		return

	# before all print first comment (header) if present
	if len(module['defs']) > 0:
		first = module['defs'][0]
		if first['isa'] == 'comment':
			nl_indent(first['nl'])
			print_comment(first)
			module['defs'] = module['defs'][1:]
		else:
			out("// %s" % outname)
		newline()

	guardsymbol = ''

	newline()
	include("stdint.h", local=False)
	include("stdbool.h", local=False)
	include("string.h", local=False)

	if 'use_va_arg' in module['att']:
		include("stdarg.h", local=False)

	newline()
	include("%s.h" % module['id'])

	if 'use_lengthof' in module['att']:
		newline()
		out("#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))")


	if len(module['anon_recs']) > 0:
		out("\n/* anonymous records */")
		for anon_rec in module['anon_recs']:
			nl_indent()
			print_type_record(anon_rec, tag=anon_rec['c_anon_id'])
			out(";")


	# types & constants
	for x in module['defs']:
		if 'c_no_print' in x['att']:
			continue
		if 'no_print' in x['att']:
			continue

		isa = x['isa']
		if isa == 'def_const' and is_private(x):
			print_deps(x['deps'])
			newline(n=x['nl'])
			print_def_const(x)
		elif isa == 'def_type' and is_private(x):
			print_deps(x['deps'])
			newline(n=x['nl'])
			print_def_type(x)
		elif isa == 'def_var':
			print_deps(x['deps'])
			newline(n=x['nl'])
			print_def_var(x)
		elif isa == 'decl_var':
			newline(n=x['nl'])
			print_def_var(x, isdecl=True)
		elif isa == 'def_func':
			print_deps(x['deps'])
			newline(n=x['nl'])
			print_def_func(x)
		elif isa == 'comment':
			nl_indent(x['nl'])
			print_comment(x)
		elif isa == 'directive':
			print_directive(x)

	newline()
	newline()
	output_close()



def run(module, _outname, options):
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
	if x['kind'] == 'cons':
		# конструирование complex_immediate печатаем
		# for: (uint32_t[3]){1, 2, 3}
		# for: (Point){.x=1, .y=2}
		if value_is_immediate(x['value']):
			return x
		return get_root_value(x['value'])
	return x



def cons_vla_from_literal_array(x):
	if x['kind'] == 'cons':
		if htype.type_is_vla(x['type']):
			return x['value']['kind'] in ['literal', 'add']
	return False


# получает значение, печатает указатель на его корень (корневое значение)
def print_value_as_ptr(x):
	yy = x
	x = get_root_value(x)

	if x['kind'] == 'deref':
		x = x['value']
		print_value(x)
	else:
		out("&")

		t = yy['type']
		# КОСТЫЛЬ!
		if x['kind'] in ['literal', 'add']:
			out("(")
			if htype.type_is_array(t):
				print_type_array(t)

			else:
				print_type(t)
			out(")")

		elif cons_vla_from_literal_array(x):
			# we need to print:
			#  &(uint32_t[]){1, 2, 3, 4, 5}
			# instead of:
			#  &(uint32_t[len]){1, 2, 3, 4, 5}
			out("(")
			print_type_array(t)
			out(")")
			print_value(x['value'])
			return

		print_value(x)



def memcopy_assign(left, right):
	rv = get_root_value(right)
	if value_is_zero(rv):
		memzero_sizeof(left)
		return

	out("memcpy(")
	print_value_as_ptr(left)
	out(", ")
	print_value_as_ptr(right)
	out(", sizeof ")
	print_value(left)
	out(")")



def memzero_sizeof(left):
	out("memset(")
	print_value_as_ptr(left)
	out(", 0, sizeof ")
	print_value(left)
	out(")")


def memcmp_eq(left, right, op='eq'):
	out('memcmp(')
	print_value_as_ptr(left)
	out(', ')
	print_value_as_ptr(right)
	out(", sizeof(")
	common_type = select_common_type(left['type'], right['type'])
	print_type(common_type)
	out(")")
	if op == 'eq':
		out(') == 0')
	else:
		out(') != 0')


