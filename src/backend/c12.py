# Есть проблема с массивом generic int когда индексируешь и приводишь к инту
# но индексируешь переменной (в цикле например)

import copy

from hlir import *
from .common import *
from error import info, warning, error, fatal
from unicode import chars_to_utf32
from util import str_fractional, align_bits_up

from .c11_1 import *

import re


def camel_to_lower_snake(name: str) -> str:
    # Вставляем подчёркивание перед заглавной буквой, если перед ней — строчная или цифра
    s = re.sub(r'(?<=[a-z0-9])([A-Z])', r'_\1', name)
    return s.lower()

def camel_to_upper_snake(name: str) -> str:
    # Вставляем подчёркивание перед заглавной буквой, если перед ней — строчная или цифра
    s = re.sub(r'(?<=[a-z0-9])([A-Z])', r'_\1', name)
    return s.upper()


def wrapp(s, cond):
	if cond:
		return '(' + s + ')'
	return s


cmodule = None


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
}


# default style is legacy
styleguide = legacy_style


cfunc = None


def newline(n=1):
	out(str_newline(n))


def nl_indent(nl=1):
	out(str_nl_indent(nl))


def is_global_context():
	global cfunc
	return cfunc == None


def is_local_context():
	return not is_global_context()



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


# Печатаем указатель на массив как указатель на его элемент
# ТОЛЬКО когда это указатель на строку!
def p2i_instead_p2a(t):
	return t.is_array_of_char()



def get_id_prefix(x):
	prefix = ''
	id = x.id

	if id.prefix != None:
		prefix = id.prefix

	nodecorate = not is_global_public(x) or id.hasAttribute('nodecorate')
	if nodecorate:
		return prefix

	module = x.getModule()
	if module != None:
		if not module.hasAttribute('nodecorate'):
			#if x.access_level != HLIR_ACCESS_LEVEL_PRIVATE:
			return "%s_%s" % (module.prefix, prefix)

	return prefix



def get_record_tag(x):
	if hasattr(x, 'id'):
		if hasattr(x.id, 'c') and x.id.c != None:
			id_str = get_id_prefix(x) + x.id.c
			return camel_to_lower_snake(id_str)

	if hasattr(x, 'c_anon_id'):
		return x.c_anon_id

	return None


def get_type_id_str(t):
	if t.is_integer():
		if t.width == 0:
			if t.is_unsigned():
				return 'unsigned int'
			return 'int'
		s = 'int%d_t' % align_bits_up(t.width)
		if t.is_unsigned():
			s = 'u' + s
		return s

	if t.is_rational():
		return "double"

	if isinstance(t, TypeRecord):
		if hasattr(t, 'id'):
			if hasattr(t.id, 'c_type'):
				return t.id.c_type

			if t.is_open_access:
				return get_id_prefix(t) + t.id.c

		tag = get_record_tag(t)
		if tag != None:
			isa = 'struct' if not t.layout == 'union' else 'union'
			kisa = isa + ' ' + tag
			return kisa

	if hasattr(t, 'id'):
		return get_id_prefix(t) + t.id.c


def get_id_str(x):
	if isinstance(x, Type):
		return get_type_id_str(x)

	if hasattr(x, 'id'):
		if x.id != None and x.id.c != None:
			return get_id_prefix(x) + x.id.c

	return None



def is_type_named(t):
	return hasattr(t, 'id') or (hasattr(t, 'c_anon_id') and t.c_anon_id != None)


#class CType():
#	def __init__(self, id_str=None, specs=None):
#		self.id_str = id_str
#		self.specs = specs if specs != None else []


# преобразуем Modest TypePointer -> CIR TypePointer
def do_ctype_pointer(t, specs=[]):
	to = t.to

	if p2i_instead_p2a(to):
		return CTypePointer(to=do_ctype(to.of), specs=specs)

	# IMPORTANT:
	# *[][]...([])T -> *[]T
	# В си нельзя создать указатель на массив вида *[][]
	# Но Modest это позволяет (!) НО при этом нельзя индексировать по такому указателю
	# Для работы нужно его сперва привести к типу *[n][m]...([k]) и тогда уже можно индексировать
	while to.is_open_array_of_open_array():
		to = to.of

	return CTypePointer(to=do_ctype(to), specs=specs)


# преобразуем Modest TypeFunc -> CIR TypeFunc
def do_ctype_func(t, specs=[]):
	params = []
	for p in t.params:
		id_str = p.id.str
		arg_ctype=do_ctype(p.type)
		if p.type.is_array():
			id_str = '_' + id_str
			arg_ctype = do_ctype(TypePointer(p.type))
		params.append(CField(id_str=id_str, type=arg_ctype, specs=[]))

	if not t.to.is_array():
		if t.to.is_unit():
			to=CTypeNamed('void')
		else:
			to=do_ctype(t.to)
	else:
		# Если f возвращает массив по значению, вернем void и добавим _sret_ - pointer to array
		to=CTypeNamed('void')
		sret_ctype = do_ctype(TypePointer(t.to))
		params.append(CField(id_str='_sret_', type=sret_ctype, specs=[]))

	return CTypeFunc(to=to, params=params, specs=specs, extra_args=t.extra_args)


# преобразуем Modest TypeArray -> CIR TypeArray
def do_ctype_array(t, specs=[]):
	# сливаем *[][] в *[]
	# такой укзаатель на массив массивов можно будет использовать только после приведения к *[n][m] (!)
	return CTypeArray(of=do_ctype(t.of), volume=t.volume, specs=specs)



# преобразуем Modest TypeRecord -> CIR TypeStruct
def do_ctype_struct(t, tag='', specs=[]):
	assert(isinstance(t, Type))
	fields = []
	for p in t.fields:
		fields.append(CField(id_str=p.id.str, type=do_ctype(p.type), specs=[], nl=p.nl))
	tag = camel_to_lower_snake(tag)
	isa = 'struct' if not t.layout == 'union' else 'union'
	kisa = isa + ' ' + tag
	return CTypeStruct(fields, specs=specs, tag=kisa)


def do_ctype_named(t, specs):
	id_str = get_type_id_str(t)
	return CTypeNamed(id_str, specs=specs)


# преобразуем Modest Type -> CIR Type
def do_ctype(t):
	assert(isinstance(t, Type))

	specs = []
	if t.hasAttribute2('const'):    specs.append('const')
	if t.hasAttribute2('volatile'): specs.append('volatile')
	if t.hasAttribute2('restrict'): specs.append('restrict')

	if is_type_named(t): return do_ctype_named(t, specs=specs)
	if t.is_pointer(): return do_ctype_pointer(t, specs=specs)
	if t.is_func(): return do_ctype_func(t, specs=specs)
	if t.is_array(): return do_ctype_array(t, specs=specs)
	if t.is_record(): return do_ctype_struct(t, specs=specs)
	return None


# Переводим представление о типе в Modest в представление о типе C backend
def str_type(t, ctx=[]):
	return str(do_ctype(t))


def str_type_record(t, tag='', ctx=[]):
	return str(do_ctype_struct(t, tag=tag))


def str_field(t, id_str, ctx=[]):
	return do_ctype(t).to_str(text=id_str)




bin_ops = {
	HLIR_VALUE_OP_OR: '|',
	HLIR_VALUE_OP_XOR: '^',
	HLIR_VALUE_OP_AND: '&',
	HLIR_VALUE_OP_SHL: '<<',
	HLIR_VALUE_OP_SHR: '>>',
	HLIR_VALUE_OP_EQ: '==',
	HLIR_VALUE_OP_NE: '!=',
	HLIR_VALUE_OP_LT: '<',
	HLIR_VALUE_OP_GT: '>',
	HLIR_VALUE_OP_LE: '<=',
	HLIR_VALUE_OP_GE: '>=',
	HLIR_VALUE_OP_ADD: '+',
	HLIR_VALUE_OP_SUB: '-',
	HLIR_VALUE_OP_MUL: '*',
	HLIR_VALUE_OP_DIV: '/',
	HLIR_VALUE_OP_REM: '%',
	HLIR_VALUE_OP_LOGIC_AND: '&&',
	HLIR_VALUE_OP_LOGIC_OR: '||'
}


def needd(x):
	rv = get_root_value(x)
	return (x.type.is_int() or x.type.is_nat()) and (x.type.width < 32) and rv.isValueBin()





def str_value_new(x, ctx):
	t_str = str_type(x.value.type)
	return '(%s *)calloc(1, sizeof(%s))' % (t_str, t_str)







def initializers_are_different(a, b):
	if len(a) != len(b):
		return True

	i = 0
	while i < len(a):
		ini_left = a[i]
		ini_right = b[i]

		if not ini_right.value.type.is_generic():
			if not Type.eq(ini_left.value.type, ini_right.value.type):
				return True

		i += 1

	return False



def cstr(value, sz):
	if sz > 8:
		return "_STR%d(%s)" % (sz, str_value(value))
	return str_value(value)



# Дополнительная чисто сишная надстройка:
# если у нас тут указатель на массив - приводим к указателю на его элемент
def incast(type, value, ctx=[]):
#	if value.type.is_pointer_to_closed_array():
#		# Это аргумент с типом указатель на массив
#		# приведем его по месту к указателю на элемент этого массива
#		# тк C живет по своим правилам и выкидывает warning чаще там где не надо
#		if value.isValueRef():
#			if value.value.isValueIndex() or value.value.isValueSlice():
#				return "&" + str_value(value.value, ctx)
#			else:
#				return str_value(value.value, ctx)
#				#return "&" + str_value(value.value, ctx) + '[0]'

	return str_value(value, ctx)


def is_the_same_in_c(t0, t1):
	if t0.is_pointer_to_array() and t1.is_pointer_to_array():
		if t0.to.is_array_of_char() and t1.to.is_array_of_char():
			#info("the same?", t0.ti)
			return True
		if Type.eq(t0.to.of, t1.to.of):
			if t0.to.volume.asset == t1.to.volume.asset:
				# *[x]T <- *[x]T
				return True
			if t0.to.volume.asset == None and t1.to.volume.asset != None:
				# *[]T <- *[x]T
				return True
	return False







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



def print_literal_array_items(items, item_type):
	sstr = ''
	i = 0
	n = len(items)
	while i < n:
		a = items[i]

		nl = a.nl
		if nl > 0:
			sstr += str_nl_indent(nl=nl)
		else:
			if i > 0:
				sstr += " "

		if a.type.is_closed_array():
			sstr += '{' + print_literal_array_items(a.asset, item_type.of) + '}'
		else:
			sstr += str_value(a)

		i = i + 1

		# если это значание - zero, проверим все остальные справа
		# и если они тоже zero - их можно не печатать (zero tail)
		# ex: {'a', 'b', '\0', '\0', '\0'} -> {'a', 'b', '\0'}
		if a.isValueZero():
			if is_zero_tail(items, i, n):
				return sstr

		if i < n:
			sstr += ','

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
		#elif cc == 0x1B: return "\\e" # escape
		else: return "\\x%X" % cc

	elif cc <= 0x7E:
		sym = chr(cc)
		if sym == '\\': return '\\\\'
		elif sym == '"': return '\\"'
		else: return sym

	elif cc != 0:
		return chr(cc)


def string_literal_prefix(width):
	if width > 16: return "U"
	if width > 8: return "u"
	return ""


def str_utf32codes_as_string(utf32_codes, width, quote):
	sstr = ""
	sstr += string_literal_prefix(width)
	sstr += quote
	for cc in utf32_codes:
		sstr += code_to_char(cc)
	sstr += quote
	return sstr



def str_value_literal_bool2(num):
	return csettings['true_literal'] if num else csettings['false_literal']


def str_value_literal_bool(v, ctx):
	num = v.asset
	return str_value_literal_bool2(num)












def str_initializer(v):
	# В C выражение значения и выражение-инициализатор - это разные вещи!
	# В выражениях-инициализаторах C нельзя приводить массивы
	# А все остальное (например структуры) - можно:
	# .arr = (uint8_t [3]){1, 2, 3}  // error
	# .arr = {1, 2, 3}               // ok
	# .arr = (struct point){.x=1, .y=2, .z=3}  // ok
	return str_value(v, ctx=['initializer_context'])



def str_value(x, ctx=[]):
	cv = do_cvalue(x, ctx)
	if not cv:
		print(x.type)
		1/0
	return str_cvalue(cv)


def do_cvalue_literal_bool(v, ctx):
	if v.asset:
		return CValueNamed('true')
	return CValueNamed('false')


def do_cvalue_literal_string(chars, width):
	utf32_codes = chars_to_utf32(chars)
	sstr = ""
	for cc in utf32_codes:
		sstr += code_to_char(cc)
	return CValueString(sstr, width=width)


def do_cvalue_literal_rational(v, ctx):
	sstr = str_fractional(v.asset)
	return CValueNamed(sstr)


def do_cvalue_literal_char(t, v, ctx):
	cc = ord(v.asset[0])
	sstr = code_to_char(cc)
	return CValueChar(sstr, width=t.width)

def do_cvalue_literal_array(v, ctx):
	items = v.asset
	cvalues = []
	for item in items:
		cv = do_cinitializer(item, ctx=ctx)
		cvalues.append(cv)
	return CValueArray(cvalues)


def do_cvalue_literal_record(v, ctx):
	items = []
	for kv in v.asset:
		if not kv.value.isValueUndef():
			items.append(KV(kv.id.str, do_cinitializer(kv.value), kv.nl))
	return CValueStruct(items)



def do_cvalue_literal_pointer(v, ctx):
	if v.asset == 0:
		return CValueNamed("NULL")
	1/0


def do_cvalue_literal_with_type(v, t, ctx=[]):
	asset = v.asset

	if t.is_integer() or t.is_int() or t.is_nat() or t.is_word():
		as_hex = t.is_word() or v.type.is_word() or v.hasAttribute2('hexadecimal')
		#return str_value_literal_number(t, asset, as_hex=as_hex)
		return CValueInteger(asset, is_unsigned=t.is_unsigned(), as_hex=t.is_word())
	elif t.is_string():
		return do_cvalue_literal_string(v.asset, width=v.type.width)

	elif t.is_bool(): return do_cvalue_literal_bool(v, ctx)
	elif t.is_rational(): return do_cvalue_literal_rational(v, ctx)
	elif t.is_float(): return do_cvalue_literal_rational(v, ctx)
	elif t.is_char(): return do_cvalue_literal_char(t, v, ctx)
	elif t.is_array(): return do_cvalue_literal_array(v, ctx)
	elif t.is_record(): return do_cvalue_literal_record(v, ctx)
	elif t.is_pointer(): return do_cvalue_literal_pointer(v, ctx)
	#elif t.is_fixed(): return str_value_fixed(t, v, ctx)
	else: error("str_value_literal not implemented for %s" % str(t), v.ti)

	print(t)
	1/0

	return None


def do_cvalue_cons_array(x, ctx):
	to_type = x.type
	value = x.value
	from_type = value.type

	if from_type.is_generic_array() or from_type.is_string():
		# C не позволяет приводить литерал массива к типу массива в инициализаторах(!)
		# Вот все можно приводить, все ок, а массив - нет.
		if 'initializer_context' in ctx:
			if from_type.is_string():
				width = 0
				if not to_type.is_generic():
					width = to_type.of.width
				cv = do_cvalue_literal_string(x.value.asset, width)
				cv.mark = 'CA1'
				return cv

			if x.asset:
				cv = do_cvalue_literal_with_type(x, to_type, ctx=ctx)
				cv.mark = 'CA2'
				return cv

		if from_type.is_string():
			#sstr += '{' + print_literal_array_items(x.asset, to_type.of) + '}'
			width = 0
			if not to_type.is_generic():
				width = to_type.of.width
			#print("width = " + str(width))
			cv = do_cvalue_literal_string(x.value.asset, width)
			cv.mark = 'CA3'
			return cv
		else:
			cv = do_cvalue(value, ctx=ctx)
			#cv.mark = '+'
			return cv

	# for:
	#    var x: [10]Word8 = "0123456789"
	# if from_type.is_string():
	# 	width = 0
	# 	if not type.is_generic():
	#  		width = type.to.of.width
	# 	return do_cvalue_literal_string(value, width=width)

#	cv = None
#	if x.isValueLiteral():
#		cv = do_cvalue_literal_with_type(x, to_type, ctx=ctx)
#	else:
	cv = do_cvalue_cast(to_type, x.value, ctx)
	cv.mark = 'CA4'
	return cv



def do_cvalue_cons_record(x, ctx):
	to_type = x.type
	value = x.value
	from_type = value.type

	if to_type.is_unit():
		return CValueCast(CTypeNamed("void"), do_cvalue(value))

	if from_type.is_generic_record():
		if to_type.is_generic_record():
			return do_cvalue(value, ctx=ctx)

	if from_type.is_generic_record():
		if to_type.is_generic_record():
			return do_cvalue(value, ctx=ctx)
#		cv = do_cvalue_literal_with_type(x, to_type, ctx=ctx)
#		cv = CValueCast(do_ctype(x.type), cv)
#		#cv = do_cvalue(value, ctx=ctx)
#		cv.mark = 'CR2'
#		return cv


	# RecordA -> RecordB
	#if to_type.is_record():
	if from_type.is_record() and not from_type.is_generic():
		if to_type.uid == from_type.uid:
			# это одна и та же структура и приведение не требуется
			return do_cvalue(value, ctx=ctx)
		# C cannot just cast struct to struct (!)
		#return str_cast(to_type, value, raw_cast=True, ctx=ctx)
		cv = do_cvalue_cast(to_type, x.value, ctx)
		cv.mark = 'CR3'
		return cv

	tt = do_ctype(to_type)

	if initializers_are_different(x.asset, value.asset):
		# Если у нас в ValueCons asset отличается от asset в ValueCons#value
		# То печатаем литерал структуры из нашего asset
		#return '(' + str_type(to_type) + ')' + str_value_literal_record(x, ctx=ctx)
		cv = CValueCast(tt, do_cvalue_literal_record(x, ctx=ctx))
		cv.mark = 'CR4'
		return cv

	cv = do_cvalue(value, ctx=ctx)
	cv = CValueCast(tt, cv)
	cv.mark = 'CR5'
	return cv
	#return '(' + str_type(to_type) + ')' + str_value(x.value, ctx=ctx)





#def str_cast(t, v, raw_cast=False, ctx=[]):
#	if raw_cast:
#		#assert(is_local_context())
#		return "RAWCAST(%s, %s, %s)" % (str_type(t), str_type(v.type), str_value(v, ctx=ctx))
#
#	return "(" + str_type(t) + ")" + wrapp(str_value(v, ctx=ctx), cond=(precedence(v) < CONS_PRECEDENCE))


def do_cvalue_cons(x, ctx):
	cv = do_cvalue_cons2(x, ctx)
	if isinstance(cv, str):
		print(x.type)
		1/0
	return cv

def do_cvalue_cons2(x, ctx):
	type = x.type
	value = x.value
	from_type = value.type

	if type.is_array():
		cv = do_cvalue_cons_array(x, ctx)
		return cv

	if type.is_record():
		cv = do_cvalue_cons_record(x, ctx)
		return cv

	if type.is_branded():
		return do_cvalue_cast(x.type, x.value, ctx)

	if type.is_char() and from_type.is_string():
		if value.isValueLiteral():
			return do_cvalue_literal_char(type, value, ctx)

	if value.isValueLiteral() and from_type.is_generic():
		if x.asset != None:
			return do_cvalue_literal_with_type(value, type, ctx=ctx)


	# *RecordA -> *RecordB
	# у нас типы структурные, а в си - номинальные
	# поэтому даже если структуры одинаковы, но имена разные
	# - их нужно жестко приводить
	if type.is_pointer_to_record() and from_type.is_pointer_to_record():
		if from_type.to.definition != type.to.definition:
			#return str_cast(type, value, ctx=ctx)
			return do_cvalue_cast(type, value, ctx)

	elif type.is_pointer_to_array():
		if from_type.is_string() and not value.isValueConst():
			cv = do_cvalue_literal_string(value.asset, width=type.to.of.width)
			return cv

	elif type.is_word() or type.is_int() or type.is_nat():
		if from_type.is_word() or from_type.is_int() or from_type.is_nat():
			if from_type.is_generic():
				return do_cvalue(value, ctx=ctx)
			if get_type_id_str(type) == get_type_id_str(from_type):
				return do_cvalue(value, ctx=ctx)


	if x.method in ['implicit', 'default']:
		#sstr = str_value(value)

		if not Type.eq(type, value.type):
			#if not (value.isValueLiteral() or is_the_same_in_c(type, value.type)):
			if not (from_type.is_generic() or is_the_same_in_c(type, value.type)):
				#sstr = "(" + str_type(type) + ")" + sstr
				cv = do_cvalue_cast(type, value, ctx=ctx)
				return cv

		cv = do_cvalue(value, ctx=ctx)
		return cv

	if value.isValueLiteral():
		cv = do_cvalue(value, ctx=ctx)
		return cv


	# (!) WARNING (!)
	# - in C  int32(-1) -> uint64 => 0xffffffffffffffff
	# - in Cm Int32(-1) -> Word64 => 0x00000000ffffffff
	# - in Cm Int32(-1) -> Nat64 => 1
	# required: (uint64_t)((uint32)int32_value)
	#if type.is_int():
	if from_type.is_int() or from_type.is_integer():
		if from_type.is_signed():
			if type.is_nat():
				arg = do_cvalue(value, ctx=ctx)

				acall = None
				if value.type.width <= 32:
					# TODO: see
					#return "(" + str_type(type) + ")" + "abs((int)" + str_value(value) + ")"
					acall = CValueCall(left=CValueNamed("abs"), args=[arg])
				elif value.type.width <= 64:
					# TODO: see
					#return "(" + str_type(type) + ")" + "llabs((long long int)" + str_value(value) + ")"
					acall = CValueCall(left=CValueNamed("llabs"), args=[arg])
				elif value.type.width <= 128:
					# TODO: see
					#return "(" + str_type(type) + ")" + "abs128(" + str_value(value) + ")"
					acall = CValueCall(left=CValueNamed("llabs"), args=[arg])
				else:
					1/0
					#return "<ABS_TOO_BIG>"

				ctype = do_ctype(type)
				return CValueCast(ctype, acall)

			elif type.is_word():
				if from_type.size < type.size:
					nat_same_sz = type_select_nat(from_type.width)
					#return "(" + str_type(type) + ")" + str_cast(nat_same_sz, value, ctx=ctx)
					return CValueCast

	# if from_type.is_string():
	# 	if type.is_char():
	# 		return do_cvalue_literal_char(type, value, [])

	# 	if type.is_array_of_char():
	# 		width = 0
	# 		if not type.is_generic():
	# 			width = type.of.width
	# 		return do_cvalue_literal_string(value.asset, width)

	# 	if type.is_pointer_to_array_of_char():
	# 		width = 0
	# 		if not type.is_generic():
	# 			width = type.to.of.width
	# 		return do_cvalue_literal_string(value.asset, width)


	# if type.is_array():
	# 	if 'initializer_context' in ctx:
	# 		return do_cvalue(x.value)


	# for: (uint32_t *)(void *)&i;
	# remove (void *)  ^^^^^^^^
	if value.isValueCons():
		if value.type.is_free_pointer():
			value = value.value

	return do_cvalue_cast(type, value, ctx=ctx)


def do_cvalue_cast(type, value, ctx):
	ctype = do_ctype(type)
	cvalue = do_cvalue(value, ctx=ctx)
	cv = CValueCast(ctype, cvalue)
	return cv


def do_cvalue_call(x, ctx):
	return doo_call(x.func, x.args)

def doo_call(func, args):
	left = do_cvalue(func)
	xargs = []
	for arg in args:
		av = arg.value
		a = do_cvalue(av)

		if av.type.is_array() and not av.type.is_array_of_char():
			# Если в функцию передается массив по значению - передаем указатель на него (!)
			# тк функции си не умеют получать массивы по значению
			a = CValueRef(a)

		xargs.append(a)

	return CValueCall(left, xargs)



def do_cvalue_index(x, ctx):
	left = x.left
	lx = do_cvalue(left)
	index = do_cvalue(x.index)


	if left.is_global_flag and left.isValueConst(): #left.type.is_generic_array():
		ts = do_ctype(left.type)
		vs = do_cvalue(left, ctx=ctx)
		#left_str += '((%s)%s)' % (ts, vs)
		lx = CValueCast(ts, vs)
	elif value_is_generic_immediate_const(left):
		ts = do_ctype(left.type)
		vs = do_cvalue(left, ctx=ctx)
		#left_str += '((%s)%s)' % (ts, vs)
		lx = CValueCast(ts, vs)

	#else:
	#	left_str += str_value(left, ctx=ctx)

#	if left.type.is_pointer() and not p2i_instead_p2a(left.type.to):
#		left_str = "(*%s)" % left_str

	if left.type.is_pointer_to_array() and not p2i_instead_p2a(left.type.to):
		lx = CValueSubexpr(CValueDeref(lx))


	return CValueIndex(lx, index)


def do_cvalue_slice(x, ctx):
	y = ValueIndex(x.type, x.left, x.index_from, ti=None)
	return do_cvalue_index(y, ctx=ctx)


def do_cvalue_access(x, ctx):
	left = x.left

	# если имеем дело c константной записью (глоб константа)
	# и результат операции доступа - константа которая уже тут
#	if not left.isValueConst():
#		if value_is_generic_immediate(left):
#			return str_value_literal(x, ctx)

	lx = do_cvalue(left, ctx=ctx)
	if value_is_generic_immediate_const(left):
		lx = CValueCast(do_ctype(left.type), lx)

	field_id_str = get_id_str(x.field)
	if left.type.is_pointer():
		return CValueAccessPtr(lx, field_id_str)
	return CValueAccess(lx, field_id_str)



def do_cvalue_shl(x, ctx):
	left = do_cvalue(x.left)
	right = do_cvalue(x.right)
	return CValueShl(left, right)


def do_cvalue_shr(x, ctx):
	left = do_cvalue(x.left)
	right = do_cvalue(x.right)
	return CValueShr(left, right)


def do_cvalue_ref(x, ctx):
	value = x.value
	cv = do_cvalue(value, ctx=ctx)

	if p2i_instead_p2a(x.type.to):
		if not (value.isValueIndex() or value.isValueSlice()):
			#return CValueRef(cv)
			# просто печатаем массив чаров как есть тк он автоматом decay to pointer
			return cv

	cv = CValueRef(cv)

	if value.isValueSlice():
		# ref to slice returns pointer to array item (!)
		# now we need to cast it to pointer to slice type array
		cv = CValueCast(do_ctype(x.type), cv)

	return cv


def do_cvalue_deref(x, ctx):
	v = do_cvalue(x.value)
	return CValueDeref(v)


def do_cvalue_subexpr(x, ctx):
	v = do_cvalue(x.value)
	return CValueSubexpr(v)


def do_cvalue_not(x, ctx):
	v = do_cvalue(x.value)
	if x.value.type.is_bool():
		return CValueNotLogical(v)
	return CValueNotBitwise(v)


def do_cvalue_neg(x, ctx):
	v = do_cvalue(x.value)
	return CValueNegative(v)


def do_cvalue_pos(x, ctx):
	v = do_cvalue(x.value)
	return CValuePositive(v)


def do_cvalue_const(x, ctx):
	if x.hasAttribute('cbyvalue'):
		# cbyvalue говорит о том что следует печатать значение константы (а не ее id)
		return do_cvalue_literal_with_type(x, x.type, ctx=ctx)

	id_str = get_id_str(x)
	if x.is_global_flag and not x.id.hasAttribute('nodecorate'):
		id_str = camel_to_upper_snake(id_str)

	cv = CValueNamed(id_str)

	if x.is_global_flag and x.type.is_array() and not x.type.is_generic():
		cv = CValueCast(do_ctype(x.type), cv)

	return cv


def do_cvalue_access_module(x, ctx):
	return do_cvalue(x.value, ctx)




def do_cvalue_lengthof_value(x, ctx):
	value = x.value

	if value_is_generic_immediate_const(value):
		if not value.type.is_string():
			return CValueInteger(value.type.volume.asset, is_unsigned=True)

	# generic array в си это просто макрос вида {1, 2, 3}
	# и его нельзя подставить в LENGTHOF (!)
	if value.isValueDeref() or x.type.is_generic_array():
		# решает проблему когда массив представлен указателем на элемент
		return do_cvalue(value.type.volume)

	if value.type.is_generic_array():
		return do_cvalue(value.type.volume)
#		ts = str_type(value.type)
#		vs = str_value(value, ctx=ctx)
#		sstr = '((%s)%s)' % (ts, vs)

	return CValueCall(left=CValueNamed("LENGTHOF"), args=[do_cvalue(x.value)])


def do_cvalue_sizeof_value(x, ctx):
	return CValueSizeofValue(do_cvalue(x.ofvalue))

def do_cvalue_sizeof_type(x, ctx):
	return CValueSizeofType(do_ctype(x.oftype))

def do_cvalue_lengthof_type(x, ctx):
	return CValueInteger(x.oftype.volume.asset, is_unsigned=True)


#
#def str_value_alignof(x, ctx):
#	if x.of.is_unit():
#		return "(/*alignof(void)*/(size_t)1)"
#	sstr = "__alignof("
#	sstr += str_type(x.of)
#	sstr += ")"
#	return sstr
#
#
#def str_value_offsetof(x, ctx):
#	sstr = "__offsetof("
#	sstr += str_type(x.oftype)
#	sstr += ", "
#	sstr += x.field.str
#	sstr += ")"
#	return sstr
#



def do_cvalue_va_start(x, ctx):
	return CValueVaStart(do_cvalue(x.va_list), do_cvalue(x.last_param))

def do_cvalue_va_arg(x, ctx):
	return CValueVaArg(do_cvalue(x.va_list), do_ctype(x.type))

def do_cvalue_va_end(x, ctx):
	return CValueVaEnd(do_cvalue(x.va_list))

def do_cvalue_va_copy(x, ctx):
	return CValueVaCopy(do_cvalue(x.dst), do_cvalue(x.src))


def do_cvalue_eq(x, logic, ctx):
	left = x.left
	right = x.right

	lx = None
	rx = None
	if left.type.is_aggregate():
		ct = Type.select_common_type(left.type, right.type, ti=x.ti)
		lc = get_cvalue_pointer_to(ct, left)
		rc = get_cvalue_pointer_to(ct, right)
		sc = get_cvalue_size_for(left, right, ti=x.ti)
		lx = CValueCall(CValueNamed("memcmp"), [lc, rc, sc])
		rx = CValueInteger(0)
	else:
		lx = do_cvalue(left)
		rx = do_cvalue(right)

	if logic:
		return CValueEq(lx, rx)
	return CValueNe(lx, rx)


def get_cvalue_pointer_to(type, value):
	cv = do_cvalue(value)
	if value.type.is_pointer():
		#cv.mark = '$+'
		return cv  # is already pointer

	root = get_root_value(value)

	if root.isValueConst() and root.type.is_array():
		cv = CValueRef(CValueCast(do_ctype(root.type), cv))
		cv.mark = '?'
		return cv


	if value.type.is_generic():
		if not value.isValueCons():
			# is generic aggregate
			cv = CValueCast(do_ctype(type), cv)

	cv = CValueRef(cv)
	#cv.mark = '$%s' % str(value.type)
	return cv


def get_cvalue_size_for(a, b, ti):
	ct = Type.select_common_type(a.type, b.type, ti=ti)
	return CValueSizeofType(do_ctype(ct))


def do_cvalue_bin(x, ctx):
	left = do_cvalue(x.left)
	right = do_cvalue(x.right)
	op = bin_ops[x.op]
	if x.op == HLIR_VALUE_OP_ADD: return CValueAdd(left, right)
	if x.op == HLIR_VALUE_OP_SUB: return CValueSub(left, right)
	if x.op == HLIR_VALUE_OP_MUL: return CValueMul(left, right)
	if x.op == HLIR_VALUE_OP_DIV: return CValueDiv(left, right)
	if x.op == HLIR_VALUE_OP_REM: return CValueRem(left, right)
	if x.op == HLIR_VALUE_OP_SHL: return CValueShl(left, right)
	if x.op == HLIR_VALUE_OP_SHR: return CValueShr(left, right)
	if x.op == HLIR_VALUE_OP_LE: return CValueLE(left, right)
	if x.op == HLIR_VALUE_OP_GE: return CValueGE(left, right)
	if x.op == HLIR_VALUE_OP_LT: return CValueLt(left, right)
	if x.op == HLIR_VALUE_OP_GT: return CValueGt(left, right)
	if x.op == HLIR_VALUE_OP_EQ: return do_cvalue_eq(x, logic=True, ctx=ctx)
	if x.op == HLIR_VALUE_OP_NE: return do_cvalue_eq(x, logic=False, ctx=ctx)
	if x.op == HLIR_VALUE_OP_OR: return CValueOrBitwise(left, right)
	if x.op == HLIR_VALUE_OP_XOR: return CValueXorBitwise(left, right)
	if x.op == HLIR_VALUE_OP_AND: return CValueAndBitwise(left, right)
	if x.op == HLIR_VALUE_OP_LOGIC_OR: return CValueOrLogical(left, right)
	if x.op == HLIR_VALUE_OP_LOGIC_AND: return CValueAndLogical(left, right)


def do_cvalue(x, ctx=[]):
	if x.isValueCons(): return do_cvalue_cons(x, ctx)
	elif x.isValueLiteral(): return do_cvalue_literal_with_type(x, x.type, ctx)
	elif x.isValueConst(): return do_cvalue_const(x, ctx)
	elif x.isValueVar(): return CValueNamed(get_id_str(x))
	elif x.isValueFunc(): return CValueNamed(get_id_str(x))
	elif x.isValueBin(): return do_cvalue_bin(x, ctx)
	elif x.isValueCall(): return do_cvalue_call(x, ctx)
	elif x.isValueAccessRecord(): return do_cvalue_access(x, ctx)
	elif x.isValueArray(): return do_cvalue_literal_array(x, ctx)
	elif x.isValueRecord(): return do_cvalue_literal_record(x, ctx)
	elif x.isValueIndex(): return do_cvalue_index(x, ctx)
	elif x.isValueShl(): return do_cvalue_shl(x, ctx)
	elif x.isValueShr(): return do_cvalue_shr(x, ctx)
	elif x.isValueRef(): return do_cvalue_ref(x, ctx)
	elif x.isValueDeref(): return do_cvalue_deref(x, ctx)
	elif x.isValueSubexpr(): return do_cvalue_subexpr(x, ctx)
	elif x.isValueNot(): return do_cvalue_not(x, ctx)
	elif x.isValueNeg(): return do_cvalue_neg(x, ctx)
	elif x.isValuePos(): return do_cvalue_pos(x, ctx)
	elif x.isValueSlice(): return do_cvalue_slice(x, ctx)
	elif x.isValueAccessModule(): return do_cvalue_access_module(x, ctx)
	elif x.isValueLengthofValue(): return do_cvalue_lengthof_value(x, ctx)
	elif x.isValueSizeofType(): return do_cvalue_sizeof_type(x, ctx)
	elif x.isValueSizeofValue(): return do_cvalue_sizeof_value(x, ctx)
	elif x.isValueLengthofType(): return do_cvalue_lengthof_type(x, ctx)
	elif x.isValueVaStart(): return do_cvalue_va_start(x, ctx)
	elif x.isValueVaEnd(): return do_cvalue_va_end(x, ctx)
	elif x.isValueVaCopy(): return do_cvalue_va_copy(x, ctx)
	elif x.isValueUndef(): 1/0
	elif x.isValueBad():
		error("value bad in C backend", x.ti)

	print(x)
	assert(False)

#	elif x.isValueNew(): sstr += str_value_new(x, ctx)
#	elif x.isValueAlignof(): sstr += str_value_alignof(x, ctx)
#	elif x.isValueOffsetof(): sstr += str_value_offsetof(x, ctx)
#	else: sstr += str(x)

	return None


def do_cinitializer(x, ctx=[]):
	cv = do_cvalue(x, ctx=ctx+['initializer_context'])
	return cv



def print_value(x, ctx=[]):
	out(str_value(x, ctx=ctx))




def str_value_eq_composite(x, ctx):
	op = x.op
	left = x.left
	right = x.right

	if x.isValueImmediate():
		return str_value_literal_bool2(x.asset)

	# если сравниваем строки (Str8, Str16, Str32)
	if left.type.is_str() and right.type.is_str():
		return eq_str_by_strcmp(left, right, op=op)

	return eq_by_memcmp(left, right, op=op)



def eq_by_memcmp(left, right, op=HLIR_VALUE_OP_EQ):
	# не берем все в скобки все тк это eq операция
	# и ее приоритет не нарушается (!)
	sstr = 'memcmp('
	sstr += str_value_as_ptr(left)
	sstr += ', '
	sstr += str_value_as_ptr(right)
	sstr += ", sizeof("
	common_type = Type.select_common_type(left.type, right.type, ti=None)
	sstr += str_type(common_type)
	sstr += ")"
	if op == HLIR_VALUE_OP_EQ:
		sstr += ') == 0'
	else:
		sstr += ') != 0'
	return sstr




#
# Stmt
#




def str_macro_value(value):
	# Не берем в скобки литералы, композитные значения и строки
	is_func = value.isValueFunc()
	is_var = value.isValueVar()
	is_const = value.isValueConst()
	is_literal = value.isValueLiteral()
	is_agg = value.type.is_aggregate()

	is_str = value.type.is_string()

	# нельзя оборачивать круглыми скобками литерал массива или структуры
	need_wrap = False
	if not (is_literal or is_agg or is_str or is_const or is_var or is_func):
		need_wrap = precedence(value) < precedenceMax


	set_nl_symbol(" \\\n")
	sstr = wrapp(str_initializer(value), cond=need_wrap)
	set_nl_symbol("\n")
	#out("/*%s*/" % str(value))
	return sstr


def undef(identifier):
	out("\n#undef %s" % identifier)




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
	s = x.text.asset
	s = s.replace('\n', '\\n')
	out('"' + s + '"')

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



def do_array_len(array_value):
	if array_value.isValueImmediate():
		return CValueInteger(array_value.type.volume.asset)
	elif array_value.isValueSlice():
		return CValueInteger(array_value.type.volume)

	return CValueCall(CValueNamed("LENGTHOF"), [do_cvalue(array_value)])



def do_assign_array(left, right, ti):

	# array = function()
	if right.isValueCall():
		return CStmtValueExpr(doo_call(right.func, right.args + [Initializer(Id("sret"), left)]))

	rv = get_root_value(right)
	if rv.isValueZero():
		return do_memzero(left)

	#warning("LWANFDLMWDKLMAWLKMDELKAMWDLMAWLMDLKAMWLKDMALKWMDLAMWlDMLAKWMDLKAWMlKDMAWLKMDLKMAWLDKMWAlMKWDL", ti)

	if right.isValueCons():
		# Если справа приведенный к левому массив (более короткий? Generic)
		right = get_root_value(right)

	cleft = cvalue_as_ptr(left)
	cright = cvalue_as_ptr(right)

	slen = None
	if left.isValueVar() or left.isValueConst():
		slen = do_array_len(left)
	else:
		slen = do_cvalue(left.type.volume)

	l_root = get_root_value(left)
	r_root = get_root_value(right)

	#if Type.eq(l_root.type, r_root.type):
	if r_root.type.is_string():
		return assign_by_memcopy(left, right)

	if l_root.type.of.size == r_root.type.of.size:
		return assign_by_memcopy(left, right)

	return CStmtValueExpr(CValueCall(CValueNamed("ARRCPY"), [cleft, cright, slen]))




def do_cstmt_block(x):
	cstmts = []
	for stmt in x.stmts:
		xx = do_cstmt(stmt)
		if isinstance(xx, tuple):
			cstmts.extend(xx)
		else:
			cstmts.append(xx)
	return CStmtBlock(cstmts)


def do_cstmt_value_expr(x):
	return CStmtValueExpr(do_cvalue(x.value))


def do_cstmt_assign(x):
	if x.left.type.is_array():
		return do_assign_array(x.left, x.right, x.ti)

	return CStmtValueAssign(do_cvalue(x.left), do_cvalue(x.right))




def do_cstmt_return(x):
	global cfunc

	if cfunc.type.to.is_closed_array():
		return CStmtValueExpr(
			CValueCall(
				CValueNamed("memcpy"), [CValueNamed("_sret_"), cvalue_as_ptr(x.value), CValueSizeofType(do_ctype(x.value.type))]
			)
		)

	cretval = None
	if x.value != None and not x.value.type.is_unit():
		cretval = do_cvalue(x.value)
	cstmt_return = CStmtReturn(cretval)
	return cstmt_return
	#out(cstmt_return)


def do_cstmt_if(x):
	ccond = do_cvalue(x.cond)
	cthen = do_cstmt_block(x.then)
	cels = None
	if x.els:
		cels = do_cstmt(x.els)
		cels.nl = 0
	return CStmtIf(ccond, cthen, cels)


def do_cstmt_while(x):
	ccond = do_cvalue(x.cond)
	cblock = do_cstmt_block(x.stmt)
	return CStmtWhile(ccond, cblock)


def do_cstmt_var(x):
	var_value = x.value
	init_value = x.init_value

	civ = None
	if not init_value.isValueUndef():
		if not (init_value.type.is_array() and (init_value.isValueRuntime() or var_value.type.is_vla())):
			civ = do_cinitializer(init_value)

	storage_class = ''
	if x.hasAttribute('static'):
		storage_class = 'static'

	dv = CStmtDefVar(get_id_str(var_value), do_ctype(var_value.type), init_value=civ, storage_class=storage_class)

	if (init_value.type.is_array() and init_value.isValueRuntime()) or init_value.type.is_func():
		return (dv, do_assign_array(var_value, init_value, x.ti))

	return dv


def do_cstmt_const(x):
	const_value = x.value
	type = const_value.type
	init_value = x.init_value

	# print generic constant as C macro
	if value_is_generic_immediate(const_value):
		if not (type.is_integer() or type.is_rational()):
			id_str = get_id_str(const_value)
			global func_undef_list
			func_undef_list.append(id_str)
			# если точный тип константы неизвестен - печатаем ее как макро
			macro = CMacrodefinition(id_str, str_macro_value(init_value))
			return macro

	civ = None
	if not (init_value.type.is_array() and init_value.isValueRuntime()):
		civ = do_cvalue(init_value)

	dv = CStmtDefVar(get_id_str(x), do_ctype(type), init_value=civ, storage_class=None)

	# print constant as 'variable'
	# литерал массива включающий в себя переменные печатаем отдельно
	if init_value.type.is_array() and init_value.isValueRuntime():
		return (dv, do_assign_array(const_value, init_value, x.ti))

	return dv




def do_cstmt(x):
	if x.is_stmt_block(): return do_cstmt_block(x)
	elif x.is_stmt_value_expr(): return do_cstmt_value_expr(x)
	elif x.is_stmt_assign(): return do_cstmt_assign(x)
	elif x.is_stmt_return(): return do_cstmt_return(x)
	elif x.is_stmt_if(): return do_cstmt_if(x)
	elif x.is_stmt_while(): return do_cstmt_while(x)
	elif x.is_stmt_def_var(): return do_cstmt_var(x)
	elif x.is_stmt_def_const(): return do_cstmt_const(x)
	elif x.is_stmt_break(): return CStmtBreak()
	elif x.is_stmt_again(): return CStmtBreak()
#	elif x.is_stmt_comment(): do_ccomment(x)
#	elif x.is_stmt_def_type(): do_cdef_type(x)
#	elif x.is_stmt_asm(): return do_cstmt_asm(x)
#	else: lo("<stmt %s>" % str(x))






def do_decl_func(x):
	func = x.value
	storage_class = ''
	if x.hasAttribute2('extern'):
		storage_class = 'extern'
	elif (x.access_level == HLIR_ACCESS_LEVEL_PRIVATE) or x.hasAttribute2('static'):
		storage_class = 'static'

	if x.hasAttribute2('inline'):
		if storage_class != '':
			storage_class = storage_class + ' inline'
		else:
			storage_class = 'inline'

	dv = CStmtDefVar(get_id_str(func), do_ctype(func.type), storage_class=storage_class, annotations=x.annotations)
	return (dv,)
	#out(str(dv))


def do_def_func(x):
	global declared

	func = x.value

	global cfunc
	cfunc = func

	#out(str_gcc_attributes(x.annotations))

	storage_class = ''
	if x.hasAttribute2('extern'):
		storage_class = 'extern'
	elif (x.access_level == HLIR_ACCESS_LEVEL_PRIVATE) or x.hasAttribute2('static'):
		storage_class = 'static'

	if x.hasAttribute2('inline'):
		if storage_class != '':
			storage_class = storage_class + ' inline'
		else:
			storage_class = 'inline'

	#if storage_class != '':
	#	out(storage_class + ' ')

	cblock = do_cstmt_block(x.stmt)

	# for any array parameter print local holder value
	for param in func.type.params:
		if param.type.is_closed_array():
			#nl_indent(1)
			#paramId = get_id_str(param)
			#print_variable(paramId, param.type)
			#out(";")
			#nl_indent(1)
#			out("memcpy(%s, %s" % (paramId, '_' + paramId))
#			out(", sizeof(")
#			out(str_type(param.type))
#			out("));")

			paramId = get_id_str(param)
			dv = CStmtDefVar(paramId, do_ctype(param.type))
			mx = CStmtValueExpr(
				CValueCall(
					CValueNamed("memcpy"),
					[
						CValueNamed(paramId),
						CValueNamed('_' + paramId),
						CValueSizeofType(do_ctype(param.type))
					]
				)
			)

			cblock.stmts = [dv, mx] + cblock.stmts

	dv = CStmtDefFunc(get_id_str(func), do_ctype(func.type), cblock, storage_class=storage_class, annotations=x.annotations)

	cfunc = None
	return (dv,)


######## -----------
"""
	out(str_field(func.type, get_id_str(func)))

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
	for param in func.type.params:
		if param.type.is_closed_array():
			nl_indent(1)
			paramId = get_id_str(param)
			print_variable(paramId, param.type)
			out(";")
			nl_indent(1)
			out("memcpy(%s, %s" % (paramId, '_' + paramId))
			out(", sizeof(")
			out(str_type(param.type))
			out("));")

	stmts = x.stmt.stmts
	for stmt in stmts:
		#print_stmt(stmt)
		out(str_cstmt(do_cstmt(stmt)))

	indent_down()

	global func_undef_list
	if len(func_undef_list) > 0:
		newline()
		for id_str in func_undef_list:
			undef(id_str)

	func_undef_list = []
	out("\n}\n")

	if not func.id.str in declared:
		declared.append(func.id.str)

	cfunc = None
"""




def do_def_type(x):
	global declared
	print_deps(x.deps)

	id_str = get_type_id_str(x.type)
	orig_type = x.original_type

	if orig_type.is_record() and not is_type_named(orig_type):
		return do_def_type_record(x)

	dt = CStmtDefType(id_str, do_ctype(orig_type))
	return (dt,)

	#out('typedef ' + str_field(orig_type, id_str) + ';')


def do_def_type_record(x):
	t = x.type
	id_str = get_type_id_str(t)

	defs = []

	# Если структура open & не задекларирована ранее - печатаем для нее typedef
	if (not id_str in declared) and t.is_open_record:
		tag = get_record_tag(t)
		isa = 'struct' if not t.layout == 'union' else 'union'
		kisa = isa + ' ' + tag
		dt = CStmtDefType(get_type_id_str(t), CTypeNamed(kisa))
		defs.append(dt)

	dt = do_ctype_struct(t, tag=get_record_tag(t), specs=[])

	dv = CStmtDefVar('', dt, storage_class='', annotations=x.annotations)
	defs.append(dv)
	return defs



## Указатель, массив и функция образуют пиздецовый заговор
#def print_variable(id_str, t, init_value=None, prefix='', ctx=[]):
#	assert (t != None)
#	out(str_field(t, id_str=(prefix + id_str), ctx=ctx))
#	if init_value != None:
#		out(" = ")
#		print_value(init_value, ctx=ctx)



def do_def_var(x, isdecl=False, is_extern=False):
	var_value = x.value

	# TODO: Почему-то атрибут 'extern' не работает, и накостылил через as_extern
	is_extern = is_extern or x.hasAttribute2('extern')

	storage_class = ''
	if x.access_level == HLIR_ACCESS_LEVEL_PRIVATE:
		if not (is_extern or x.hasAttribute2('nonstatic')):
			storage_class = "static"

	if is_extern:
		storage_class = "extern"

	civ = None
	if not (x.init_value.isValueUndef() or is_extern):
		civ = do_cinitializer(x.init_value)

	dv = CStmtDefVar(get_id_str(var_value), do_ctype(var_value.type), init_value=civ, storage_class=storage_class, annotations=x.annotations)
	#out(str(dv))
	return (dv,)



def do_def_const(x):
	id_str = camel_to_upper_snake(get_id_str(x.value))
	macro = CMacrodefinition(id_str, str_macro_value(x.init_value))
	#out(str(macro))
	module_undef_list.append(id_str)
	return (macro,)


already_included = []
def include(path, local=True):
	if path in already_included:
		return
	already_included.append(path)
	dv = CInclude(path, isglobal=not local)
	out(str(dv))



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

	xdeps = []

	if len(deps) == 0:
		return xdeps

	# печатаем декларации для типов от которых зависит этот тип
	for dep in deps:
#		if dep.id == None:
#			error("undefined", dep.ti)
#			return xdeps

		id_str = get_id_str(dep)
		if not id_str in declared:
			declared.append(id_str)

			if isinstance(dep, Value):
				xx = do_decl_func(dep.definition)
				xdeps.append(xx)

			elif isinstance(dep, Type):
				if dep.is_record():
					xx = do_decl_type_record(dep.definition)
					if isinstance(xx, tuple):
						xdeps.extend(xx)
					else:
						xdeps.append(xx)

	return xdeps


def do_decl_type_record(x):
	t = x.type
	tag = get_record_tag(t)
	isa = 'struct' if not t.layout == 'union' else 'union'
	kisa = isa + ' ' + tag
	dt = CStmtDeclType(CTypeNamed(kisa))
	if t.is_open_record:
		df = CStmtDefType(get_type_id_str(t), CTypeNamed(kisa))
		return (dt, df)
	return dt



def nnl(nl):
	if nl == 1:
		newline(1)
	elif nl >= 2:
		newline(2)



def print_helpers(module):
	for use in module.att:
		if use in h_helpers:
			newline()
			h_helpers[use]()

	if module.hasAttribute('use_unicode'):
		out("\n")
		out("\n#ifndef __STR_UNICODE__")
		out("\n#if __has_include(<uchar.h>)")
		include("uchar.h", local=False)
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


def print_header(module, outname):
	outname = outname + '.h'
	output_open(outname)

	defs = module.defs

	# Печатаем первые комментарии
#	if len(defs) > 0:
#		def0 = defs[0]
#		if def0.is_stmt_comment():
#			nnl(def0.nl)
#			print_comment(def0)
#			newline()
#			defs = module.defs[1:]

	#guardsymbol = outname.split("/")[-1]
	#guardsymbol = guardsymbol[:-2].upper() + '_H'
	guardsymbol = camel_to_upper_snake(module.prefix) + '_H'
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

	print_helpers(module)

	xdefs = []

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
			#nnl(1)
			if x.access_level == HLIR_ACCESS_LEVEL_PUBLIC and x.hasAttribute2('inline'):
				#out("static ")
				xdefs.extend(do_def_func(x))
				continue
			xdefs.extend(do_decl_func(x))
		elif x.is_stmt_def_var():
			#nnl(x.nl)
			xdefs.extend(do_def_var(x, as_extern=True))
		elif x.is_stmt_def_type():
			#nnl(x.nl)
			xdefs.extend(print_deps(x.deps))
			xdefs.extend(do_def_type(x))
		elif x.is_stmt_def_const():
			#nnl(x.nl)
			xdefs.extend(print_deps(x.deps))
			xdefs.extend(do_def_const(x))
		#elif x.is_stmt_comment():
		#	nnl(x.nl)
		#	print_comment(x)


	for xd in xdefs:
		out(str(xd))

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


def helper_use_rawcast():
	# из-за strict aliasing в C трюк с укзаателями не гарантирует что мы не словим UB при оптимизациях
	# union же гарантирует нам преобразование и данный трюк сработает на стандартах начиная с C99 и выше
	out("\n#define RAWCAST(type_dst, type_src, value) (((union { type_src src; type_dst dst; }){ .src = (value) }).dst)")
	module_undef_list.append("LENGTHOF")

def helper_use_bigint():
	out("\n#ifndef __BIG_INT128__")
	out("\n#define BIG_INT128(hi64, lo64) (((__int128)(hi64) << 64) | ((__int128)(lo64)))")
	out("\nstatic inline __int128 abs128(__int128 x) {return x < 0 ? -x : x;}")
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


#func packFixed32 (i: Nat32, m: Nat32, n: Nat32 fraction: Nat8) -> Fixed32 {
#	let tail = Nat64 m * (Nat64(Word32 1 << fraction) - 1) / Nat64 n
#	return unsafe Fixed32 ((Word32 i << fraction) or unsafe Word32 tail)
#}

def helper_use_fixed_point():
	out("\n#ifndef __FIXED_POINT__")

	out("\ntypedef int32_t __fixed32;")
	out("\ntypedef int64_t __fixed64;")

	out("\nstatic inline __fixed64 __fixed64_create(int64_t i, uint64_t m, uint64_t n, uint8_t fraction) {")
	out("\n	return (i << fraction) | (m * (1 << fraction) / n);")
	out("\n}")

	out("\nstatic inline __fixed32 __fixed32_from_int32(int32_t a, uint8_t fraction) {")
	out("\n	return a * (1 << fraction);")
	out("\n}")

	out("\n__attribute__((used))")
	out("\nstatic inline __fixed32 __fixed32_from_float64(double a, uint8_t fraction) {")
	out("\n	return (__fixed32)(a * (1 << fraction));")
	out("\n}")

	out("\nstatic inline int32_t __fixed32_to_int32(__fixed32 a, uint8_t fraction) {")
	out("\n	return a / (1 << fraction);")
	out("\n}")

	out("\nstatic inline double __fixed32_to_float64(__fixed32 a, uint8_t fraction) {")
	out("\n	return (double)a / (1 << fraction);")
	out("\n}")

	out("\nstatic inline __fixed32 __fixed32_mul(__fixed32 a, __fixed32 b, uint8_t fraction) {")
	out("\n	return (__fixed32)(((int64_t)a * (int64_t)b) >> fraction);")
	out("\n}")

	out("\nstatic inline __fixed32 __fixed32_div(__fixed32 a, __fixed32 b, uint8_t fraction) {")
	out("\n	return (__fixed32)(((int64_t)a << fraction) / (int64_t)b);")
	out("\n}")

	out("\n#endif /* __FIXED_POINT__ */")


h_helpers = {
	'use_bigint': helper_use_bigint,
}

c_helpers = {
	'use_abs': helper_use_abs,
	'use_lengthof': helper_use_lengthof,
	'use_arrcpy': helper_use_arrcpy,
	'use_va_arg': helper_use_va_arg,
	'use_raw_cast': helper_use_rawcast,
	'use_fixed_point': helper_use_fixed_point,
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
#	if len(defs) > 0:
#		def0 = defs[0]
#		if def0.is_stmt_comment():
#			nnl(def0.nl)
#			print_comment(def0)
#			newline()
#			defs = defs[1:]


	global already_included
	already_included = []
	if module.id != 'main':
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

	if module.id == 'main':
		print_helpers(module)


	nl_after_incs = False
	if defs != []:
		#newline()
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

	sss = True
	for x in defs:
		if x.is_stmt_import():
			#nnl(x.nl)
			if not x.module.hasAttribute('do_not_include'):
				if sss:
					sss = False
					newline()
				s = os.path.basename(x.impline)
				include(s + '.h', local=True)
				nl_after_incs = True

	#if nl_after_incs:
	#	newline()


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
			out(str_type_record(anon_rec, tag=anon_rec.c_anon_id))
			out(";")

	xdefs = []

	for x in defs:
		if x.hasAttribute('c_no_print') or x.hasAttribute('no_print'):
			continue

		if isinstance(x, StmtDirectiveCInclude):
			continue

		if x.comment != None:
			#out(str_newline(n=x.comment.nl))
			#print_comment(x.comment)
			pass

		if x.is_stmt_def_const() and is_private(x):
			#nnl(x.nl)
			xdefs.extend(print_deps(x.deps))
			xdefs.extend(do_def_const(x))

		elif x.is_stmt_def_type() and is_private(x):
			#nnl(x.nl)
			xdefs.extend(print_deps(x.deps))
			xdefs.extend(do_def_type(x))

		elif x.is_stmt_def_var():
			#nnl(x.nl)
			xdefs.extend(print_deps(x.deps))
			xdefs.extend(do_def_var(x))

		elif x.is_stmt_def_func():
			if x.access_level == HLIR_ACCESS_LEVEL_PUBLIC and x.hasAttribute2('inline'):
				continue
			#nnl(x.nl)
			xdefs.extend(print_deps(x.deps))
			#if x.deps != []:
			#	newline()
			xdefs.extend(do_def_func(x))
		elif x.is_stmt_comment():
			#nnl(x.nl)
			#if x.nl == 0:
			#	out("  ")
			#print_comment(x)
			pass
		elif x.is_stmt_directive():
#			print_directive(x)
			pass


	for xd in xdefs:
		out(str(xd))

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

	if module.id != 'main':
		print_header(module, hpath)
	print_cfile(module, _outname)
	return



# возвращает корневое значение из цепочки ValueCons & ValueSubexpr
# Костыль конечно, но пока C backend не разделен на два слоя, это хоть как то помогает
def get_root_value(x):
	if x.isValueCons():
		return get_root_value(x.value)
	if x.isValueSubexpr():
		return get_root_value(x.value)
	return x



def cons_vla_from_literal_array(x):
	if x.isValueCons():
		if x.type.is_vla():
			#return x['value']['kind'] in ['literal', HLIR_VALUE_OP_ADD]
			if x.isValueBin():
				return x.op in ['literal', HLIR_VALUE_OP_ADD]
	return False



def cvalue_as_ptr(x):
	t = x.type
	root = get_root_value(x)

	cv = None

	#root.type.is_str() or
	if root.type.is_string():
		return CValueRef(do_cvalue(root))

	if root.isValueImmediate():
		if x.type.is_aggregate() or value_is_generic_immediate_const(root):
			# generic immediate const is just a macro!
			vs = do_cvalue(root)
			ts = do_ctype(x.type)
			#return "&((%s)%s)" % (ts, vs)
			return CValueRef(CValueCast(ts, vs))

	if x.isValueCons():
		# for *s == "Hi!"
		# string literal will be implicitly casted to StrX
		# and for getting pointer to this string
		# we need to print just string literal,
		# because in C string literal is pointer to c-string
		if x.value.type.is_string():
			return do_cvalue(x.value)


	if root.isValueDeref():
		return do_cvalue(root.value)

	if root.isValueLiteral():
		if root.type.is_string():
			return do_cvalue(root)


	###

	cv = do_cvalue(root)
	cv = CValueRef(cv)

	if root.isValueSlice():
		ptr2slice = TypePointer(x.type)
		#sstr += "(" + str_type(ptr2slice) + ")"
		cv = CValueCast(do_ctype(ptr2slice), cv)

	return cv



# получает значение, печатает указатель на его корневое значение
def str_value_as_ptr(x):
	sstr = ''

	t = x.type
	root = get_root_value(x)

	#root.type.is_str() or
	if root.type.is_string():
		return "&" + str_value(root)


	if root.isValueImmediate():
		if x.type.is_aggregate() or value_is_generic_immediate_const(root):
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
		sstr += "(" + str_type(ptr2slice) + ")"
		#sstr += "(" + str_type_pointer(ptr2slice) + ")"

	if root.isValueDeref():
		return str_value(root.value)

	if root.isValueLiteral():
		if root.type.is_string():
			return str_value(root)

	sstr += "&"

	if root.isValueBin() and root.op in ['literal', HLIR_VALUE_OP_ADD]:
		sstr += '(' + str_type(t) + ')'

	#elif root.isValueLiteral() and (not root.isValueImmediate()):
	elif root.isValueArray() and (not root.isValueImmediate()):
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
	# TODO: improve it
	if get_root_value(right).isValueZero():
		return do_memzero(left)

	return CStmtValueExpr(
		CValueCall(
			CValueNamed("memcpy"), [cvalue_as_ptr(left), cvalue_as_ptr(right), CValueSizeofType(do_ctype(left.type))]
		)
	)


def do_memzero(value):
	return CStmtValueExpr(
		CValueCall(
			CValueNamed("memset"), [
				cvalue_as_ptr(value), CValueInteger(0), CValueSizeofType(do_ctype(value.type))
			]
		)
	)


def memzero(value):
	out("memset(")
	out(str_value_as_ptr(value))
	out(", 0, sizeof(")
	out(str_type(value.type))
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

