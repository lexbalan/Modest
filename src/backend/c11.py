# Есть проблема с массивом generic int когда индексируешь и приводишь к инту
# но индексируешь переменной (в цикле например)

import copy
import os
import re

from hlir import *
from error import info, warning, error, fatal
from unicode import chars_to_utf32
from util import str_fractional, align_bits_up, nbits_for_num
from common import features, get_setting
from cshape import *
from util import trace


ARRAY_AS_POINTER = True


def camel_to_lower_snake(name: str) -> str:
    # Вставляем подчёркивание перед заглавной буквой, если перед ней — строчная или цифра
    s = re.sub(r'(?<=[a-z0-9])([A-Z])', r'_\1', name)
    return s.lower()

def camel_to_upper_snake(name: str) -> str:
    # Вставляем подчёркивание перед заглавной буквой, если перед ней — строчная или цифра
    s = re.sub(r'(?<=[a-z0-9])([A-Z])', r'_\1', name)
    return s.upper()


intWidth = 32

# идетнифиаторы декларированных (или определенных) сущностей
declared = []
defined = []


func_undef_list = []
module_undef_list = []


csettings = {}
cfunc = None


# print pointer to array as a pointer to array item (C array decay)
POINTER_TO_ARRAY_RELAX = True




def init(settings):
	global csettings
	csettings = settings



def is_global_context():
	global cfunc
	return cfunc == None


def is_local_context():
	return not is_global_context()


def value_is_generic_immediate(v):
	return v.is_immediate() and v.type.is_generic()


# такое значение определено как макрос
def value_is_generic_immediate_const(v):
	return v.is_const() and value_is_generic_immediate(v)


def is_global_public(x):
	if hasattr(x, 'definition'):
		if x.definition != None:
			if x.definition.access_level == HLIR_ACCESS_LEVEL_PUBLIC:
				return True
	#warning("no glob prefix", x.ti)
	return False


# Печатаем указатель на массив как указатель на его элемент
# ТОЛЬКО когда это указатель на строку!
def need_ptr_to_item_instead_of_ptr_to_array(t):
	if ARRAY_AS_POINTER:
		return t.is_array()# and not t.is_array_of_array()
	return t.is_array_of_char()




def get_record_tag(x):
	if hasattr(x, 'id'):
		if hasattr(x.id, 'c') and x.id.c != None:
			id_str = x.id.prefix + x.id.c
			return camel_to_lower_snake(id_str)

	if hasattr(x, 'c_anon_id'):
		return x.c_anon_id

	return None


def get_type_id_str(t):
	if hasattr(t, 'id') and t.id != None:
		if t.id.c_alias != None:
			return t.id.c_alias

		if t.id.common != None:
			return t.id.common

	if isinstance(t, TypeRecord):
		if t.is_open_access:
			if hasattr(t, 'id'):
				return t.id.prefix + t.id.c

		tag = get_record_tag(t)
		if tag != None:
			isa = 'struct' if not t.layout == 'union' else 'union'
			kisa = isa + ' ' + tag
			return kisa

	if hasattr(t, 'id') and t.id != None:
		if t.id.c != None:
			return t.id.prefix + t.id.c

	return None


def get_id_str(x):
	if hasattr(x, 'id') and x.id != None:
		if x.id.c_alias != None:
			return x.id.c_alias

		if x.id.common != None:
			return x.id.common

		if x.id.c != None:
			return x.id.prefix + x.id.c

	return None



def is_named(t):
	return get_type_id_str(t) != None


# преобразуем Modest TypePointer -> CIR TypePointer
def do_ctype_pointer(t, specs=[]):
	to = t.to

	# IMPORTANT:
	# *[][]...([])T -> *[]T
	# В си нельзя создать указатель на массив вида *[][]
	# Но Modest это позволяет ⚠️ НО при этом нельзя индексировать по такому указателю
	# Для работы нужно его сперва привести к типу *[n][m]...([k]) и тогда уже можно индексировать
	# Реализуется это в си через void * - (это лучший вариант)
	if to.is_unsized_array_of_unsized_array():
		return CTypePointer(to=CTypeIdentifier("void"), specifiers=specs)

	if need_ptr_to_item_instead_of_ptr_to_array(to):
		return CTypePointer(to=do_ctype(to.of), specifiers=specs)

	return CTypePointer(to=do_ctype(to), specifiers=specs)


# преобразуем Modest TypeFunc -> CIR TypeFunc
def do_ctype_func(t, specs=[]):
	params = []
	for p in t.params:
		id_str = get_id_str(p)
		arg_ctype=do_ctype(p.type, is_param=True)
		if p.type.is_array():
			id_str = '_' + id_str
			arg_ctype = do_ctype(TypePointer(p.type), is_param=True)
			#arg_ctype.to.of.specs = ['const']
		params.append(CField(id=id_str, type=arg_ctype, specifiers=[]))


	if not t.to.is_array():
		if t.to.is_unit():
			to=CTypeIdentifier('void')
		else:
			to=do_ctype(t.to)
	else:
		# Если f возвращает массив по значению, добавим __out - pointer to array,
		# и его же вернем как результат: тогда вызов остается ВЫРАЖЕНИЕМ и годится
		# всюду, где нужно значение - в аргумент, в индексацию, в сравнение
		sret_ctype = do_ctype(TypePointer(t.to), is_param=True)
		params.append(CField(id='__out', type=sret_ctype, specifiers=[]))
		to=do_ctype(TypePointer(t.to), is_param=True)

	return CTypeFunction(to=to, params=params, specifiers=specs, extra_args=t.extra_args)


# CIR TypeArray хранит volume уже как CValue (или None) — приведение HLIR-значения
# к CIR откладывать до печати незачем и не нужно самому CIR
def do_ctype_array_volume(volume):
	if volume == None or volume.is_undefined():
		return None
	return do_cvalue(volume)


# преобразуем Modest TypeArray -> CIR TypeArray
def do_ctype_array(t, specs=[]):
	# сливаем *[][] в *[]
	# такой укзаатель на массив массивов можно будет использовать только после приведения к *[n][m] ⚠️
	return CTypeArray(item_type=do_ctype(t.of), size=do_ctype_array_volume(t.volume), specifiers=specs)



# преобразуем Modest TypeRecord -> CIR TypeStruct
def do_ctype_struct(t, tag='', specs=[]):
	assert(isinstance(t, Type))
	fields = []
	for f in t.fields:
		fields.append(CField(id=get_id_str(f), type=do_ctype(f.type), specifiers=[], nl=f.nl))
	tag = camel_to_lower_snake(tag)
	isa = 'struct' if not t.layout == 'union' else 'union'
	kisa = isa
	if tag:
		kisa = kisa + ' ' + tag
	return CTypeStruct(fields, specifiers=specs, tag=kisa)


def do_ctype_named(t, specs):
	id_str = get_type_id_str(t)
	return CTypeIdentifier(id_str, specifiers=specs)


def do_ctype_variant(t, specs):
	return CTypeIdentifier('struct ' + t.c_anon_id, specifiers=specs)


def do_def_type_variant(t):
	result = []

	# Emit full definitions of named sub-types before the variant struct.
	# Union members require complete types in C, so a forward declaration is not enough.
	for vtype in t.variants:
		if vtype.definition is not None:
			result.extend(do_def_type(vtype.definition))

	union_fields = []
	for i, vtype in enumerate(t.variants):
		union_fields.append(CField(id='_%d' % i, type=do_ctype(vtype), specifiers=[], nl=1))
	union_type = CTypeStruct(union_fields, specifiers=[], tag='union')

	outer_fields = [
		CField(id='tag', type=CTypeIdentifier('uint8_t'), specifiers=[], nl=1),
		CField(id='value', type=union_type, specifiers=[], nl=1),
	]
	struct_type = CTypeStruct(outer_fields, specifiers=[], tag='struct ' + t.c_anon_id)
	result.append(CStmtDefVar('', struct_type, storage_class='', attributes={}))
	return result


# преобразуем Modest Type -> CIR Type
def do_ctype(t, is_param=False):
	assert(isinstance(t, Type))

	if POINTER_TO_ARRAY_RELAX:
		if is_param:
			# Только для параметров функции!
			if t.is_pointer_to_array():
				if not need_ptr_to_item_instead_of_ptr_to_array(t.to):
					return CTypeArray(item_type=do_ctype(t.to.of), size=do_ctype_array_volume(t.to.volume))

	specs = []
	if t.hasAttribute('const'):    specs.append('const')
	if t.hasAttribute('volatile'): specs.append('volatile')
	if t.hasAttribute('restrict'): specs.append('restrict')

	if is_named(t): return do_ctype_named(t, specs=specs)
	if t.is_pointer(): return do_ctype_pointer(t, specs=specs)
	if t.is_func(): return do_ctype_func(t, specs=specs)
	if t.is_array(): return do_ctype_array(t, specs=specs)
	if t.is_record(): return do_ctype_struct(t, specs=specs)
	if t.is_variant(): return do_ctype_variant(t, specs=specs)
	return None


# Переводим представление о типе в Modest в представление о типе C backend
def str_type(t, ctx=None):
	return do_ctype(t).to_str()


#def str_type_record(t, tag='', ctx=[]):
#	return do_ctype_struct(t, tag=tag).to_str()


def str_field(t, id_str, ctx=[]):
	return do_ctype(t).to_str(text=id_str)




def needd(x):
	rv = get_root_value(x)
	return (x.type.is_int() or x.type.is_nat()) and (x.type.width < 32) and rv.is_bin()



def initializers_are_equal(a, b):
	if len(a) != len(b):
		return False

	i = 0
	while i < len(a):
		ini_left = a[i]
		ini_right = b[i]

		if ini_left.id.str != ini_right.id.str:
			return False
		if ini_left.id.c != ini_right.id.c:
			return False
		if ini_left.id.common != ini_right.id.common:
			return False

		if ini_right.value.type.is_concretic():
			if not Type.eq(ini_left.value.type, ini_right.value.type):
				return False

		i += 1

	return True



#def cstr(value, sz):
#	if sz > 8:
#		return "_STR%d(%s)" % (sz, str_value(value))
#	return str_value(value)
#




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
		if not v.is_zero():
			return False
		i = i + 1
	return True






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



def str_value(x, ctx=[]):
	cv = do_cvalue(x, ctx)
	if not cv:
		print(x.type)
		1/0
	return str_cvalue(cv)


def do_cvalue_literal_bool(v, ctx):
	if v.asset:
		return CValueIdentifier('true')
	return CValueIdentifier('false')


def do_cvalue_literal_string(chars, width):
	utf32_codes = chars_to_utf32(chars)
	sstr = ""
	for cc in utf32_codes:
		sstr += code_to_char(cc)
	return CValueString(sstr, width=width)


def do_cvalue_literal_rational(v, ctx):
	sstr = str_fractional(v.asset, v.type.width if v.type.is_float() else None)
	return CValueIdentifier(sstr)


def do_cvalue_literal_char(t, v, ctx):
	return CValueChar(v.asset, width=t.width)



# nmax - максимальное количество элементов, которое можно напечатать
def do_array_literal_from_nitems(items, nmax, ctx):
	initializers = []
	i = 0
	for item in items:
		if i >= nmax:
			break
		ini = do_cinitializer(item.type, item, ctx=ctx)
		ini.nl = item.nl
		initializers.append(ini)
		i += 1
	return CValueArray(initializers)


def do_array_literal_from_items(items, ctx):
	return do_array_literal_from_nitems(items, nmax=len(items), ctx=ctx)


def do_cvalue_literal_array(v, ctx):
	return do_array_literal_from_items(v.asset, ctx=ctx)



def do_cvalue_literal_record(v, ctx):
	items = []
	for kv in v.asset:
		if not kv.value.is_undefined():
			inititlizer = do_cinitializer(kv.value.type, kv.value, ctx=ctx)
			items.append(KV(get_id_str(kv), inititlizer, kv.nl))

	nv = CValueStruct(items)
	return nv



def do_cvalue_literal_pointer(v, ctx):
	if v.asset == 0:
		return CValueIdentifier("NULL")
	1/0



def cvalue_literal_integer(asset, width=0, is_unsigned=False, as_hex=False, nsigns=0, ctx=None):

	#width = max(width, nbits_for_num(asset, signed=not is_unsigned))
	width = nbits_for_num(asset, signed=not is_unsigned)

	suffix = ''
	if width >= 32: #csettings['int_width']:
		if is_unsigned and width >= 32:
			suffix += "U"    # unsigned

		if width == 64:   #csettings['long_long_width']:
			suffix += "LL"   # long long int
		elif width >= 32: #csettings['long_width']:
			suffix += "L"   # long long int
		else:
			suffix += "XL"   # extra long int (not defined in C)

	return CValueInteger(asset, as_hex=as_hex, nsigns=nsigns, suffix=suffix)



# FixedX печатается сырым хранилищем (значение * 2^fraction);
# отдельно от do_cvalue_literal_number, тк сюда приходят не только
# литералы, но и свернутые cons/bin - а у них нет поля nsigns
def do_cvalue_fixed(t, v, ctx):
	return cvalue_literal_integer(int(v.asset), width=t.width, ctx=ctx)



# Обратная сторона do_cvalue_fixed для WordX: масштаб не снимается,
# печатаем готовое хранилище. (Rational - только generic-литералы.)
def do_cvalue_from_fixed_folded(t, x, ctx):
	if t.is_float() or t.is_rational():
		return do_cvalue_literal_rational(x, ctx)

	return cvalue_literal_integer(int(x.asset), width=t.width,
		is_unsigned=t.is_nat() or t.is_word(), as_hex=t.is_word(), ctx=ctx)



# Снятие масштаба у FixedX. Известное на этапе компиляции выражение
# печатаем макросом: оно попадает в статические инициализаторы, где
# вызов функции недопустим. Тот же split, что и у do_cvalue_fixed_bin -
# но без его оговорки про литералы: макросы __FIXEDX_TO_* вычисляют
# операнд один раз, побочный эффект им не страшен.
# (!) Считать надо от того, что НАПЕЧАТАНО в C, а не от asset: у const
# с типом FixedX хранилище задает макрос FIXED64(), считающий в double,
# и на Fixed64 оно расходится с точной сверткой на 1 LSB (BUGS.md#25).
# Свернешь здесь - и `c` с `Float64 c` в одной программе разойдутся.
# (!) fraction берется у ИСХОДНОГО типа, а не у целевого - зеркально
# ветке type.is_fixed() в do_cvalue_cons2
def do_cvalue_from_fixed(t, x, ctx):
	value = x.value
	from_type = value.type

	if t.is_float():
		# у хелперов пивот всегда float64, FloatX уже поверх результата
		op = "to_float64"
		natural_width = 64
	else:
		# int такой же ширины, как у источника: масштаб снимается без
		# потери целой части, а сужение - отдельным приведением
		op = "to_int%d" % from_type.width
		natural_width = from_type.width

	if x.is_immediate():
		fn = "__FIXED%d_%s" % (from_type.width, op.upper())
	else:
		fn = "__fixed%d_%s" % (from_type.width, op)

	cv = CValueCall(CValueIdentifier(fn),
		[do_cvalue(value, ctx=ctx), CValueInteger(from_type.fraction)])

	if t.width != natural_width:
		cv = CValueCast(do_ctype(t), cv)

	return cv



# сам заботится о том чтобы литерал соответствовал типу (int/longlong)
def do_cvalue_literal_number(t, v, ctx):
	#if not (t.is_generic()):
	#	info("??", v.ti)
	if t.width > 64:
		high = cvalue_literal_integer(int(v.asset) >> 64, width=64, is_unsigned=not t.is_signed(), as_hex=True, ctx=ctx)
		low = cvalue_literal_integer(int(v.asset) & 0xffffffffffffffff, width=64, is_unsigned=not t.is_signed(), as_hex=True, ctx=ctx)
		return CValueCall(CValueIdentifier("BIG_INT128"), [high, low])

	is_unsigned = t.is_nat() or t.is_word() or (t.is_integer() and v.asset >= 0)
	as_hex = v.hasAttribute('hexadecimal') or t.is_word()
	cv = cvalue_literal_integer(int(v.asset), width=t.width, is_unsigned=is_unsigned, as_hex=as_hex, nsigns=v.nsigns, ctx=ctx)
	#cv.mark = '$%s' + str()
	return cv




def do_cvalue_literal_with_type(v, t, ctx):
	asset = v.asset

	if t.is_integer() or t.is_int() or t.is_nat() or t.is_word():
		return do_cvalue_literal_number(t, v, ctx)

	elif t.is_string():
		if t.is_concretic():
			width = t.of.width
		else:
			width = t.width
		return do_cvalue_literal_string(v.asset, width=width)

	elif t.is_bool(): return do_cvalue_literal_bool(v, ctx)
	elif t.is_rational(): return do_cvalue_literal_rational(v, ctx)
	elif t.is_float(): return do_cvalue_literal_rational(v, ctx)
	elif t.is_fixed(): return do_cvalue_fixed(t, v, ctx)
	elif t.is_char(): return do_cvalue_literal_char(t, v, ctx)
	elif t.is_array(): return do_cvalue_literal_array(v, ctx)
	elif t.is_record(): return do_cvalue_literal_record(v, ctx)
	elif t.is_pointer(): return do_cvalue_literal_pointer(v, ctx)
	else: error("str_value_literal not implemented for %s" % str(t), v.ti)

	print(t)
	1/0

	return None


def do_cvalue_cons_array(x, ctx):
	to_type = x.type
	value = x.value
	from_type = value.type

	if from_type.is_generic_array() or from_type.is_string():
		if from_type.is_string() and value.is_bin() and value.op == HLIR_VALUE_OP_STRCAT:
			return do_cvalue(x.value)

		if from_type.is_string():
			width = 0
			if to_type.is_concretic():
				width = to_type.of.width
			cv = do_cvalue_literal_string(x.value.asset, width)
		else:
			cv = do_cvalue(value, ctx=ctx)

		return cv

	# for:
	#    var x: [10]Word8 = "0123456789"
	# if from_type.is_string():
	# 	width = 0
	# 	if type.is_concretic():
	#  		width = type.to.of.width
	# 	return do_cvalue_literal_string(value, width=width)

#	cv = None
#	if x.is_literal():
#		cv = do_cvalue_literal_with_type(x, to_type, ctx=ctx)
#	else:
	cv = do_cvalue_cast(to_type, x.value, ctx)
	return cv




def initializer_already_here(items, initializer_id):
	for item in items:
		if item.key == initializer_id:
			return True
	return False



def do_cvalue_cons_record(x, ctx):
	to_type = x.type
	value = x.value
	from_type = value.type

	if to_type.is_unit():
		cv = CValueCast(CTypeIdentifier("void"), do_cvalue(value))
		return cv

	if to_type.is_generic_record() and from_type.is_generic_record():
		cv = do_cvalue(value, ctx=ctx)
		return cv

	# RecordA -> RecordB
	#if to_type.is_record():
	if from_type.is_record() and from_type.is_concretic():
		if to_type.uid == from_type.uid:
			# это одна и та же структура и приведение не требуется
			cv = do_cvalue(value, ctx=ctx)
			return cv

		# C cannot just cast struct to struct ⚠️
		cv = do_cvalue_cast_raw(to_type, x.value, ctx)
		return cv

	tt = do_ctype(to_type)

	if x.value.is_immediate():
		if not initializers_are_equal(x.asset, value.asset):
			# Если у нас в ValueCons asset отличается от asset в ValueCons#value
			# То печатаем литерал структуры из нашего asset
			record = do_cvalue_literal_record(x.value, ctx=ctx)

			# add extra non-zero items ⚠️
			for kv in x.asset:
				if not kv.value.is_undefined():
					if kv.value.is_zero():
						continue
					if initializer_already_here(record.items, get_id_str(kv)):
						continue

					inititlizer = do_cinitializer(kv.value.type, kv.value, ctx=ctx)
					record.items.append(KV(get_id_str(kv), inititlizer, kv.nl))

			cv = CValueCast(tt, record)
			return cv

	cv = do_cvalue(value, ctx=ctx)
	cv = CValueCast(tt, cv)
	return cv



# FIXED32(x, f) накладывает масштаб средствами C. Это читается куда лучше
# готового числа, но применимо не всегда:
#
# - под приведением должно лежать НЕмасштабированное значение. Если операнд
#   сам FixedX, масштаб в нем уже есть, и макрос наложил бы его второй раз
#   (когда-то так и было: `#define K (HALF * FIXED32(3.0, 16))`)
# - макрос считает в double, а свертка - в точных Fraction. Для Fixed32 это
#   неразличимо (хранилище <= 32 бит против 53 бит мантиссы), а вот на
#   Fixed64 результаты расходятся на младший бит
# - произвольное выражение под макрос не отдаем: его пересчитает уже
#   компилятор C, со своей семантикой (BUGS.md #10). Только литерал
#   и константа, т.е. ровно то, что человек и написал в исходнике
# - и только то, что известно на этапе компиляции: is_const() в этом
#   бэкенде верен и для параметров функции, а они значения рантаймовые
def fixed_cons_via_macro(value, x):
	if not x.is_immediate():
		return False

	if value.type.is_fixed():
		return False

	return value.is_literal() or value.is_const()



def do_cvalue_cons(x, ctx):
	t = x.type

	if x.value.type.is_fixed() and not t.is_fixed():
		# (!) WordX сюда не попадает намеренно: он забирает сырое
		# хранилище как есть, без снятия масштаба (docs/CHEATSHEET.md)
		if t.is_float() or t.is_int():
			return do_cvalue_from_fixed(t, x, ctx)

		if x.is_immediate():
			return do_cvalue_from_fixed_folded(t, x, ctx)

	cv = None
	if t.is_int(): cv = do_cvalue_cons_int(x, ctx)
	elif t.is_nat(): cv = do_cvalue_cons_nat(x, ctx)
	elif t.is_array(): cv = do_cvalue_cons_array(x, ctx)
	elif t.is_record(): cv = do_cvalue_cons_record(x, ctx)
	elif t.is_char(): cv = do_cvalue_cons_char(x, ctx)
	elif t.is_word(): cv = do_cvalue_cons_word(x, ctx)
	elif t.is_float(): cv = do_cvalue_cons_float(x, ctx)
	elif t.is_pointer(): cv = do_cvalue_cons_pointer(x, ctx)
	elif t.is_variant(): cv = do_cvalue_cons_variant(x, ctx)
	elif t.is_fixed(): cv = do_cvalue_cons_fixed(x, ctx)
	elif t.is_integer(): cv = do_cvalue(x.value, ctx)
	else:
		1/0
	#elif type.is_branded(): return do_cvalue_cast(x.type, x.value, ctx)
	assert(cv != None)
	return cv


def do_cvalue_cons_word(x, ctx):
	type = x.type
	value = x.value
	from_type = value.type


#	if from_type.is_generic():
#		if value.is_immediate():
#			if value.is_literal():
#				cv = do_cvalue_literal_number(type, value, ctx)
#				cv = CValueCast(do_ctype(type), cv)
#				return cv

	#if value.is_immediate() and value.is_literal():
	#	#if from_type.is_nat() and type.width == from_type.width:
	#	cv = do_cvalue_literal_with_type(value, type, ctx=ctx)
	#	return cv

	if x.method in ['implicit', 'default']:
		if value.is_literal():
			return do_cvalue_literal_number(type, value, ctx)
		#if type.width <= 32:
		cv = do_cvalue(value, ctx=ctx)
		return cv


	if from_type.is_int():
		if from_type.width < type.width:
			cv = do_cvalue(value, ctx=ctx)
			nat_same_sz = do_ctype(type_select_nat(from_type.width))
			cv = CValueCast(nat_same_sz, cv)
			cv = CValueCast(do_ctype(type), cv)
			return cv

	cv = do_cvalue_cast(type, value, ctx=ctx)
	return cv


def do_cvalue_cons_int(x, ctx):
	type = x.type
	value = x.value
	from_type = value.type

	if from_type.is_word() and type.width == from_type.width:
		cv = do_cvalue(value, ctx=ctx)
		return cv

	if x.method in ['implicit', 'default']:
		if value.is_literal():
			return do_cvalue_literal_number(type, value, ctx)
		#if type.width <= 32:
		cv = do_cvalue(value, ctx=ctx)
		return cv

	cv = do_cvalue_cast(type, value, ctx=ctx)
	return cv


def do_cvalue_cons_nat(x, ctx):
	type = x.type
	value = x.value
	from_type = value.type

	if from_type.is_word() and type.width == from_type.width:
		cv = do_cvalue(value, ctx=ctx)
		return cv

	if from_type.is_int():
		arg = do_cvalue(value, ctx=ctx)

		acall = None
		if value.type.width <= 32:
			acall = CValueCall(CValueIdentifier("abs"), [arg])
		elif value.type.width <= 64:
			acall = CValueCall(CValueIdentifier("llabs"), [arg])
		elif value.type.width <= 128:
			acall = CValueCall(CValueIdentifier("llabs"), [arg])
		else:
			1/0
			#return "<ABS_TOO_BIG>"

		ctype = do_ctype(type)
		return CValueCast(ctype, acall)

	if x.method in ['implicit', 'default']:
		if value.is_literal():
			return do_cvalue_literal_number(type, value, ctx)
		#if type.width <= 32:
		cv = do_cvalue(value, ctx=ctx)
		return cv

	cv = do_cvalue_cast(type, value, ctx=ctx)
	return cv


def do_cvalue_cons_float(x, ctx):
	type = x.type
	value = x.value
	from_type = value.type

	if value.is_literal() and (type.width == 64):
		return do_cvalue_literal_rational(value, ctx)

	if x.method in ['implicit', 'default']:

		if not Type.eq(type, value.type):
			if not (from_type.is_generic() or is_the_same_in_c(type, value.type)):
				return do_cvalue_cast(type, value, ctx=ctx)

		if type.width != 64:
			# ⚠️ Необходимо привести, тк в C литералы с плавающей точкой по умолчанию double
			return do_cvalue_cast(type, value, ctx=ctx)

	return do_cvalue_cast(type, value, ctx=ctx)


def do_cvalue_cons_char(x, ctx):
	type = x.type
	value = x.value
	if value.type.is_string():
		cv = None
		if value.is_literal():
			cv = do_cvalue_literal_char(type, x, ctx)
		else:
			cv = CValueIndex(do_cvalue(value), CValueInteger(0))
		return cv

	df = do_cvalue_cast(type, value, ctx=ctx)
	return df



def do_cvalue_cons_pointer(x, ctx):
	type = x.type
	value = x.value

	cv = None

	if x.method == 'default':
		cv = do_cvalue(value, ctx=ctx)
		return cv

	if value.type.is_free_pointer():
		if value.asset == 0:
			cv = do_cvalue(value, ctx=ctx)
		else:
			cv = do_cvalue_cast(type, value, ctx=ctx)
		return cv

	# *RecordA -> *RecordB
	# у нас типы структурные, а в си - номинальные
	# поэтому даже если структуры одинаковы, но имена разные
	# - их нужно жестко приводить
	if type.is_pointer_to_record() and value.type.is_pointer_to_record():
		if value.type.to.definition != type.to.definition:
			#return str_cast(type, value, ctx=ctx)
			cv = do_cvalue_cast(type, value, ctx)
			return cv

	elif type.is_pointer_to_array():
		if type.is_pointer_to_array_of_char() and value.type.is_string():

			if value.type.is_string():
				if value.is_bin() and value.op == HLIR_VALUE_OP_STRCAT:
					return do_cvalue(x.value, ctx=ctx)

			if not value.is_const():
				cv = do_cvalue_literal_string(value.asset, width=type.to.of.width)
			elif type.to.of.width > 8:
				cv = CValueCall(CValueIdentifier("_STR%d" % type.to.of.width), [do_cvalue(value)])
			else:
				cv = do_cvalue(value)
			return cv

		if x.method in ['explicit', 'unsafe']:
			cv = do_cvalue_cast(type, value, ctx)
		else:
			cv = do_cvalue(value, ctx)
		return cv

	if x.method in ['explicit', 'unsafe']:
		cv = do_cvalue_cast(type, value, ctx=ctx)
	else:
		cv = do_cvalue(value, ctx=ctx)
	return cv


def do_cvalue_cast(type, value, ctx):
	if is_named(type):
		if get_id_str(type) == get_id_str(value.type):
			cv = do_cvalue(value, ctx=ctx)
			return cv

	ctype = do_ctype(type)
	cvalue = do_cvalue(value, ctx=ctx)
	cv = CValueCast(ctype, cvalue)
	return cv



def do_cvalue_cast_raw(type, value, ctx):
	return CValueCall(
		CValueIdentifier("RAWCAST"),
		[
			CValueIdentifier(str_type(type)),
			CValueIdentifier(str_type(value.type)),
			do_cvalue(value, ctx=ctx)
		]
	)



def do_cvalue_cons_variant(x, ctx):
	# Возвращаем литерал структуры с полем __tag = 0 и полем __value = value
	items = []
	tag = x.type.getVariantId(x.value.type)
	items.append(KV('tag', CValueInteger(tag, as_hex=True), nl=x.nl))
	items.append(KV('value._%d' % tag, do_cvalue(x.value, ctx=ctx), nl=x.nl))
	variant_struct_literal = CValueStruct(items)
	return CValueCast(do_ctype(x.type), variant_struct_literal)


# Наложение масштаба при конструировании FixedX.
# (!) Возвращает значение ВСЕГДА. do_cvalue_cons2 зовет эту функцию через
# 'return', так что провалиться в разбор ниже уже нельзя, а None в этом
# месте означает не "не обработал", а "инициализатора нет": CStmtDefVar
# именно так кодирует объявление без значения, и молча напечатает
# '__fixed32 f;' вместо '__fixed32 f = ...'
def do_cvalue_cons_fixed(x, ctx):
	type = x.type
	value = x.value
	from_type = value.type

	if fixed_cons_via_macro(value, x):
		# позиция двоичной точки берется из типа
		args = [do_cvalue(value), CValueInteger(type.fraction)]
		return CValueCall(CValueIdentifier("FIXED%d" % type.width), args)

	if x.is_immediate():
		# масштаб посчитан на этапе свертки (см. value/fixed.py),
		# здесь печатаем готовое хранилище
		return do_cvalue_fixed(type, x, ctx)

	if from_type.is_float():
		# (!) не макрос: операнд может иметь побочный эффект
		# (`Fixed32 next()`), а FIXED*() вычисляет его дважды
		args = [do_cvalue(value), CValueInteger(type.fraction)]
		fn = "__fixed%d_from_float64" % type.width
		return CValueCall(CValueIdentifier(fn), args)

	if from_type.is_int() or from_type.is_nat():
		args = [do_cvalue(value), CValueInteger(type.fraction)]
		fn = "__fixed%d_from_int%d" % (type.width, type.width)
		return CValueCall(CValueIdentifier(fn), args)

	if from_type.is_fixed() and from_type.fraction != type.fraction:
		# перенос двоичной точки
		args = [do_cvalue(value),
			CValueInteger(from_type.fraction),
			CValueInteger(type.fraction)]
		cv = CValueCall(CValueIdentifier("__fixed_rescale"), args)
		if type.width != 64:
			cv = CValueCast(do_ctype(type), cv)
		return cv

	# Дальше масштаб трогать не надо, остается только ширина:
	# - WordX отдает сырое хранилище как есть (docs/CHEATSHEET.md)
	# - FixedY с тем же @fraction: двоичная точка уже на месте
	# do_cvalue_cast сам не поставит приведение, если C-имена совпали
	return do_cvalue_cast(type, value, ctx)
	
	


def do_cvalue_call(x, ctx, sret=None):
	cv = doo_call(x.func, x.args, ctx)

	# Массив возвращается через sret-параметр, и в позиции значения буфер
	# взять неоткуда - подставляем составной литерал.  Он lvalue, живет до
	# конца блока и остается ВНУТРИ выражения, так что ленивость `and`/`or`
	# не страдает.  Там, где буфер уже есть (`a = f()`, `return f()`), его
	# передают явно через sret
	if x.type.is_sized_array():
		if sret == None:
			sret = CValueCast(do_ctype(x.type), CValueArray([]))
		cv.args.append(sret)

	return cv



def do_cvalue_arg(av):
	if av.type.is_array() and not av.type.is_array_of_char():
		# Если в функцию передается массив по значению - передаем указатель на него ⚠️
		# тк функции си не умеют получать массивы по значению
		a = do_cvalue_as_ptr(av, parr_relax=POINTER_TO_ARRAY_RELAX)
	else:
		if not ARRAY_AS_POINTER:
			if av.type.is_pointer_to_array():
				if POINTER_TO_ARRAY_RELAX:
					if not av.type.to.is_array_of_char():
						if av.is_ref() and not (av.value.is_index() or av.value.is_slice()):
							av = av.value
						else:
							tt = TypePointer(av.type.to.of)
							av = ValueCons(tt, tt, av, 'explicit', av.ti)
		a = do_cvalue(av)

	return a


def doo_call(func, args, ctx):
	left = do_cvalue(func)
	xargs = []
	for arg in args:
		xargs.append(do_cvalue_arg(arg.value))
	return CValueCall(left, xargs)



def do_cvalue_index(x, ctx):
	left = x.left
	lx = do_cvalue(left)
	index = do_cvalue(x.index)

	if left.is_const():
		if left.type.is_generic() or left.is_global():
			if not left.type.is_string():
				ts = do_ctype(left.type)
				lx = CValueCast(ts, lx)

	if left.type.is_pointer_to_array():
		if POINTER_TO_ARRAY_RELAX:
			if left.is_param():
				if left.type.is_pointer_to_array():
					return CValueIndex(lx, index)

		if not need_ptr_to_item_instead_of_ptr_to_array(left.type.to):
			lx = CValueDereference(lx)

	return CValueIndex(lx, index)


def do_cvalue_slice(x, ctx):
	y = ValueIndex(x.type, x.left, x.index_from, ti=None)
	cv = do_cvalue_index(y, ctx=ctx)
	return cv


def do_cvalue_access(x, ctx):
	left = x.left

	# если имеем дело c константной записью (глоб константа)
	# и результат операции доступа - константа которая уже тут
	#if not left.is_const():
	#if value_is_generic_immediate_const(left):
	#	return do_cvalue_literal_with_type(x, x.type, ctx)

	lx = do_cvalue(left, ctx=ctx)
	if value_is_generic_immediate_const(left):
		lx = CValueCast(do_ctype(left.type), lx)

	field_id_str = get_id_str(x.field)
	if left.type.is_pointer():
		return CValuePtrFieldAccess(lx, field_id_str)

	return CValueFieldAccess(lx, field_id_str)



def do_cvalue_shl(x, ctx):
	left = do_cvalue(x.left)
	#left.mark = '~~~' + str(left.__class__)

	#if x.type.width > 32:
	#if x.left.type.width < x.type.width:
	if x.left.type.is_generic():
		left = CValueCast(do_ctype(x.type), left)

	right = do_cvalue(x.right)
	cv = CValueShiftLeft(left, right)
	return cv


def do_cvalue_shr(x, ctx):
	left = do_cvalue(x.left)

	if x.type.width > 32 and x.left.type.width < x.type.width:
		left = CValueCast(do_ctype(x.type), left)

	right = do_cvalue(x.right)
	cv = CValueShiftRight(left, right)
	return cv


def do_cvalue_ref(x, ctx):
	value = x.value
	cv = do_cvalue(value, ctx=ctx)

	if ARRAY_AS_POINTER:
		if x.type.is_pointer_to_array() and value.type.is_array():
			if not value.is_slice():
				return cv

	if need_ptr_to_item_instead_of_ptr_to_array(x.type.to):
		if not (value.is_index() or value.is_slice()):
			#return CValueReference(cv)
			# просто печатаем массив чаров как есть тк он автоматом decay to pointer
			return cv

	cv = CValueReference(cv)

	if not ARRAY_AS_POINTER:
		if value.is_slice():
			# "ref to slice" in C is just pointer to array item,
			# therefore we need cast it to pointer to result array
			cv = CValueCast(do_ctype(x.type), cv)

	return cv


def do_cvalue_deref(x, ctx):
	v = do_cvalue(x.value)
	return CValueDereference(v)


def do_cvalue_subexpr(x, ctx):
	# скобки из исходника значимы: 'a - (b - c)' это не 'a - b - c'
	v = do_cvalue(x.value)
	return CValueParen(v)


def do_cvalue_not(x, ctx):
	v = do_cvalue(x.value)
	if x.value.type.is_bool():
		return CValueLogicalNot(v)
	return CValueBitwiseNot(v)


def do_cvalue_neg(x, ctx):
	v = do_cvalue(x.value)
	return CValueUnaryMinus(v)


def do_cvalue_pos(x, ctx):
	v = do_cvalue(x.value)
	return CValueUnaryPlus(v)


def do_cvalue_const(x, ctx):
	if x.hasAttribute('cbyvalue'):
		# cbyvalue говорит о том что следует печатать значение константы (а не ее id)
		return do_cvalue_literal_with_type(x, x.type, ctx=ctx)

	id_str = get_id_str(x)
	if x.is_global(): #and not x.id.hasAttribute('nodecorate'):
		if x.id.c_alias == None and x.id.common == None:
			id_str = camel_to_upper_snake(id_str)

	cv = CValueIdentifier(id_str)

#	if x.is_global() and x.type.is_array() and not x.type.is_generic():
#		cv = CValueCast(do_ctype(x.type), cv)

	return cv


def do_cvalue_access_module(x, ctx):
	return do_cvalue(x.value, ctx)



def do_cvalue_lengthof(array_value):
	if array_value.type.is_string():
		return CValueInteger(array_value.type.length)
	if array_value.is_immediate():
		return do_cvalue(array_value.type.volume)
	if array_value.is_const() and array_value.is_global():
		return do_cvalue(array_value.type.volume)
	elif array_value.is_slice():
		return do_cvalue(array_value.type.volume)

	lengthof_arg = do_cvalue(array_value)
	if ARRAY_AS_POINTER:
		if array_value.is_deref():
			return do_cvalue(array_value.type.volume)

	return CValueCall(CValueIdentifier("LENGTHOF"), [lengthof_arg])


def do_cvalue_lengthof_value(x, ctx):
	value = x.value
	cv = do_cvalue_lengthof(value)
	return cv


def do_cvalue_sizeof_value(x, ctx):
	return CValueSizeofValue(do_cvalue(x.ofvalue))

def do_cvalue_sizeof_type(x, ctx):
	if x.oftype.is_unit():
		return CValueCast(CTypeIdentifier("size_t"), CValueInteger(0))
	return cvalue_sizeof_type(x.oftype)

def do_cvalue_lengthof_type(x, ctx):
	# у VLA объём известен только в рантайме - печатаем само выражение,
	# а не литерал (asset у такого объёма пуст). Ср. llvm.do_eval_lengthof_type
	if x.oftype.is_vla():
		return do_cvalue(x.oftype.volume)
	return cvalue_literal_integer(x.asset, is_unsigned=True, ctx=ctx)

def do_cvalue_alignof_type(x, ctx):
	if x.oftype.is_unit():
		return CValueCast(CTypeIdentifier("size_t"), CValueInteger(1))
	return CValueCall(CValueIdentifier("__alignof"), [CValueIdentifier(str_type(x.oftype))])

def do_cvalue_alignof_value(x, ctx):
	return CValueCall(
		CValueIdentifier("__alignof"), [
			CValueCall(
				CValueIdentifier("__typeof__"), [do_cvalue(x.value)]
			)
		]
	)



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

	#if x.is_immediate():
	#	return str_value_literal_bool2(x.asset)

	lx = None
	rx = None
	if left.type.is_aggregate():
		# сравниваем массивы / записи
		a = do_cvalue_as_ptr(left)
		b = do_cvalue_as_ptr(right)
		sz = get_cvalue_size_for(left, right, ti=x.ti)
		lx = cvalue_memcmp(a, b, sz)
		rx = CValueInteger(0)

	#elif left.type.is_str() and right.type.is_str():
	elif left.type.is_str() or left.type.is_string():
		# сравниваем строки (Str8, Str16, Str32)
		ctype_pointer_to_chars = CTypePointer(CTypeIdentifier("char"))
		ctype_pointer_to_chars.specifiers = ['const']
		lx = CValueCall(CValueIdentifier("__builtin_strcmp"), [
			CValueCast(ctype_pointer_to_chars, do_cvalue_as_ptr(left)),
			CValueCast(ctype_pointer_to_chars, do_cvalue_as_ptr(right))
		])
		rx = CValueInteger(0)

	else:
		lx = do_cvalue(left)
		rx = do_cvalue(right)

	if logic:
		return CValueEq(lx, rx)

	return CValueNe(lx, rx)



# Размер типа как C-выражение.
#
# Для массива с неконстантным объёмом печатаем `sizeof(item) * n`, а не
# `sizeof(item [n])`: второе - это VLA-тип, а они в C11 необязательны
# (__STDC_NO_VLA__), не поддержаны MSVC и запрещены MISRA C:2012 (18.8).
# Машинный код получается тот же самый.
def cvalue_sizeof_type(t):
	if t.is_vla():
		return CValueMul(cvalue_sizeof_type(t.of), do_cvalue(t.volume))
	return CValueSizeofType(do_ctype(t))


def get_cvalue_size_for(a, b, ti):
	ct = Type.select_common_type(a.type, b.type, ti=ti)
	return cvalue_sizeof_type(ct)




def cvalue_memcpy(dst, src, size):
	assert(isinstance(dst, CValue))
	assert(isinstance(src, CValue))
	assert(isinstance(size, CValue))
	return CValueCall(CValueIdentifier("__builtin_memcpy"), [dst, src, size])


def cvalue_memcmp(a, b, size):
	assert(isinstance(a, CValue))
	assert(isinstance(b, CValue))
	assert(isinstance(size, CValue))
	return CValueCall(CValueIdentifier("__builtin_memcmp"), [a, b, size])


def cvalue_memzero(ptr, size):
	assert(isinstance(ptr, CValue))
	assert(isinstance(size, CValue))
	return CValueCall(CValueIdentifier("__builtin_bzero"), [ptr, size])


def cvalue_malloc(size):
	assert(isinstance(size, CValue))
	return CValueCall(CValueIdentifier("malloc"), [size])



def do_cvalue_new(x, ctx):
	sizeof = cvalue_sizeof_type(x.value.type)
	xvalue = do_cvalue_as_ptr(x.value)
	return CValueCast(do_ctype(x.type), cvalue_memcpy(cvalue_malloc(sizeof), xvalue, sizeof))



def do_cvalue_default(x, ctx):
	if x.type.is_integer() or x.type.is_int() or x.type.is_nat() or x.type.is_word():
		return cvalue_literal_integer(0, width=x.type.width, is_unsigned=not x.type.is_signed(), ctx=ctx)
	elif x.type.is_bool():
		return CValueIdentifier(csettings['false_literal'])
	elif x.type.is_char():
		return CValueChar(0, width=x.type.width)
	elif x.type.is_string():
		return do_cvalue_literal_string("", width=x.type.width)
	elif x.type.is_rational() or x.type.is_float():
		return CValueIdentifier("0.0")
	elif x.type.is_array():
		return do_cvalue_literal_array(ValueLiteral(x.type, [], ti=None), ctx)
	elif x.type.is_record():
		return do_cvalue_literal_record(ValueLiteral(x.type, [], ti=None), ctx)
	elif x.type.is_pointer():
		return CValueIdentifier("NULL")
	else:
		error("default value not implemented for type %s" % str(x.type), x.ti)
		1/0


# Смещение поля печатаем символьно - offsetof() из <stddef.h>, а не готовым
# числом: раскладка записи остаётся делом C-компилятора (ср. cvalue_sizeof_type)
def do_cvalue_offsetof(x, ctx):
	return CValueCall(
		CValueIdentifier("offsetof"), [
			CValueIdentifier(str_type(x.oftype)),
			CValueIdentifier(get_id_str(x.field_def))
		]
	)


def do_cvalue(x, ctx=[]):
	if x.is_cons(): return do_cvalue_cons(x, ctx)
	elif x.is_literal(): return do_cvalue_literal_with_type(x, x.type, ctx)
	elif x.is_const(): return do_cvalue_const(x, ctx)
	elif x.is_var(): return CValueIdentifier(get_id_str(x))
	elif x.is_func(): return CValueIdentifier(get_id_str(x))
	elif x.is_bin(): return do_cvalue_bin(x, ctx)
	elif x.is_call(): return do_cvalue_call(x, ctx)
	elif x.is_access_record(): return do_cvalue_access(x, ctx)
	elif x.is_array(): return do_cvalue_literal_array(x, ctx)
	elif x.is_record(): return do_cvalue_literal_record(x, ctx)
	elif x.is_index(): return do_cvalue_index(x, ctx)
	elif x.is_shl(): return do_cvalue_shl(x, ctx)
	elif x.is_shr(): return do_cvalue_shr(x, ctx)
	elif x.is_ref(): return do_cvalue_ref(x, ctx)
	elif x.is_deref(): return do_cvalue_deref(x, ctx)
	elif x.is_subexpr(): return do_cvalue_subexpr(x, ctx)
	elif x.is_not(): return do_cvalue_not(x, ctx)
	elif x.is_neg(): return do_cvalue_neg(x, ctx)
	elif x.is_pos(): return do_cvalue_pos(x, ctx)
	elif x.is_slice(): return do_cvalue_slice(x, ctx)
	elif x.is_access_module(): return do_cvalue_access_module(x, ctx)
	elif x.is_lengthof_value(): return do_cvalue_lengthof_value(x, ctx)
	elif x.is_sizeof_type(): return do_cvalue_sizeof_type(x, ctx)
	elif x.is_sizeof_value(): return do_cvalue_sizeof_value(x, ctx)
	elif x.is_lengthof_type(): return do_cvalue_lengthof_type(x, ctx)
	elif x.is_alignof_type(): return do_cvalue_alignof_type(x, ctx)
	elif x.is_alignof_value(): return do_cvalue_alignof_value(x, ctx)
	elif x.is_offsetof(): return do_cvalue_offsetof(x, ctx)
	elif x.is_va_arg(): return do_cvalue_va_arg(x, ctx)
	elif x.is_va_start(): return do_cvalue_va_start(x, ctx)
	elif x.is_va_end(): return do_cvalue_va_end(x, ctx)
	elif x.is_va_copy(): return do_cvalue_va_copy(x, ctx)
	elif x.is_new(): return do_cvalue_new(x, ctx)
	elif x.is_default(): return do_cvalue_default(x, ctx)
	elif x.is_undefined():
		error("value undef in C backend", x.ti)
		exit(1)
	elif x.is_bad():
		error("value bad in C backend", x.ti)
		exit(1)

	print(x)
	assert(False)

#	elif x.is_new(): sstr += str_value_new(x, ctx)
#	else: sstr += str(x)

	return None


# Коррекция масштаба у FixedX '*' и '/' ('+' и '-' в ней не нуждаются -
# там масштаб сокращается сам). Известное на этапе компиляции выражение
# печатаем макросом: оно попадает в статические инициализаторы, где вызов
# функции недопустим. Ценой этого макрос вычисляет операнды дважды,
# поэтому все остальное идет через inline-функцию
# (то же правило, что и у fixed_cons_via_macro выше)
def do_cvalue_fixed_bin(x, ctx):
	args = [do_cvalue(x.left, ctx), do_cvalue(x.right, ctx)]
	# позиция двоичной точки берется из типа
	args.append(CValueInteger(x.type.fraction))

	op = "mul" if x.op == HLIR_VALUE_OP_MUL else "div"

	if x.is_immediate():
		fn = "__FIXED%d_%s" % (x.type.width, op.upper())
	else:
		fn = "__fixed%d_%s" % (x.type.width, op)

	return CValueCall(CValueIdentifier(fn), args)


def do_cvalue_bin(x, ctx):
	# (!) у FixedX масштаб не сокращается сам: 'a * b' над хранилищами
	# это не хранилище a*b
	if x.type.is_fixed() and x.op in [HLIR_VALUE_OP_MUL, HLIR_VALUE_OP_DIV]:
		return do_cvalue_fixed_bin(x, ctx)

	left = do_cvalue(x.left)
	right = do_cvalue(x.right)

	if not x.type.is_string():
		if x.left.type.width < x.type.width:
			left = CValueCast(do_ctype(x.type), left)

		if x.right.type.width < x.type.width:
			right = CValueCast(do_ctype(x.type), right)

	if x.op == HLIR_VALUE_OP_ADD: return CValueAdd(left, right)
	if x.op == HLIR_VALUE_OP_SUB: return CValueSub(left, right)
	if x.op == HLIR_VALUE_OP_MUL: return CValueMul(left, right)
	if x.op == HLIR_VALUE_OP_DIV: return CValueDiv(left, right)
	if x.op == HLIR_VALUE_OP_REM: return CValueMod(left, right)
	if x.op == HLIR_VALUE_OP_SHL: return CValueShiftLeft(left, right)
	if x.op == HLIR_VALUE_OP_SHR: return CValueShiftRight(left, right)
	if x.op == HLIR_VALUE_OP_LE: return CValueLE(left, right)
	if x.op == HLIR_VALUE_OP_GE: return CValueGE(left, right)
	if x.op == HLIR_VALUE_OP_LT: return CValueLt(left, right)
	if x.op == HLIR_VALUE_OP_GT: return CValueGt(left, right)
	if x.op == HLIR_VALUE_OP_EQ: return do_cvalue_eq(x, logic=True, ctx=ctx)
	if x.op == HLIR_VALUE_OP_NE: return do_cvalue_eq(x, logic=False, ctx=ctx)
	if x.op == HLIR_VALUE_OP_BITWISE_OR: return CValueBitwiseOr(left, right)
	if x.op == HLIR_VALUE_OP_BITWISE_XOR: return CValueBitwiseXor(left, right)
	if x.op == HLIR_VALUE_OP_BITWISE_AND: return CValueBitwiseAnd(left, right)
	if x.op == HLIR_VALUE_OP_LOGIC_OR: return CValueLogicalOr(left, right)
	if x.op == HLIR_VALUE_OP_LOGIC_AND: return CValueLogicalAnd(left, right)
	if x.op == HLIR_VALUE_OP_STRCAT: return CValueStringConcat(left, right)
	if x.op == HLIR_VALUE_OP_ARRCAT: return do_array_literal_from_items(x.asset, ctx=ctx)

	assert(False)


def do_cinitializer(type, value, ctx):
	if value.is_cons():
		return do_cinitializer_cons(type, value, ctx)
	return do_cvalue(value, ctx=ctx)


def do_cinitializer_cons(type, value, ctx):
	v = value.value
	to = value.type
	if Type.eq(to, value.type):
		if to.brand == v.type.brand:
			# у FixedX приведение несет в себе масштаб, снимать его нельзя
			if v.type.is_integer() and not to.is_fixed():
				value = value.value

	# ⚠️ C не позволяет приводить литерал массива к типу массива в инициализаторах
	# Вот все можно приводить, все ок, а массив - нет.
	if to.is_array():
		if v.is_array():
			if value.is_immediate():
				return do_array_literal_from_nitems(value.asset, nmax=len(v.asset), ctx=ctx)
			return do_cvalue_literal_with_type(v, to, ctx=ctx)

		elif v.type.is_string():
			width = 0
			if to.is_concretic():
				width = to.of.width
			cv_chars = []
			for char in v.asset:
				cv = CValueChar(ord(char), width=width)
				cv.nl = 0
				cv_chars.append(cv)
			cv = CValueArray(cv_chars)
			return cv

	if v.type.is_generic():
		if to.is_float() and v.type.is_rational():
			return do_cvalue(v, ctx=ctx)

	return do_cvalue(value, ctx=ctx)


#
# Stmt
#

def do_assign_array(left, right, ti):
	# array = function()
	if right.is_call():
		rv = Initializer(Id("sret"), left)
		return CStmtExpr(doo_call(right.func, right.args + [rv], ctx=[]))

	rv = get_root_value(right)
	if rv.is_zero():
		return do_memzero(left)

	l_root = get_root_value(left)
	r_root = get_root_value(right)

	#if Type.eq(l_root.type, r_root.type):
	if r_root.type.is_string():
		return assign_by_memcopy(left, right)

	# сравниваем размер элемента с типом right как он есть (в т.ч. под
	# явным приведением, напр. `[3]Int32 [1, 2, 3]`) - а не с типом
	# необёрнутого литерала (r_root), у которого может быть другой,
	# по умолчанию выведенный тип элемента
	if l_root.type.of.get_size() == right.type.of.get_size():
		return assign_by_memcopy(left, right)

	cleft = do_cvalue_as_ptr(left)
	cright = do_cvalue_as_ptr(right)
	slen = None
	if left.is_var() or left.is_const():
		slen = do_cvalue_lengthof(left)
	else:
		slen = do_cvalue(left.type.volume)
	#return CStmtExpr(CValueCall(CValueIdentifier("ARRCPY"), [cleft, CValueParen(cright), slen]))
	return CStmtExpr(cvalue_memcpy(cleft, CValueParen(cright), slen))



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
	return CStmtExpr(do_cvalue(x.value))


def do_cstmt_assign(x):
	left = x.left
	right = x.right

	if left.type.is_array():
		return do_assign_array(left, right, x.ti)

	if right.is_cons():
		if not right.value.is_literal():
			if right.type.is_int() or right.type.is_nat() or right.type.is_word():
				if right.value.type.width <= 32:
					right = right.value

	return CStmtAssignment(do_cvalue(left), do_cvalue(right))



def do_cstmt_return(x):
	global cfunc

	if cfunc.type.to.is_sized_array():
		# `return f()`: буфер вызываемой функции - наш собственный __out,
		# копировать нечего
		if x.value.is_call():
			return CStmtReturn(
				do_cvalue_call(x.value, ctx=[], sret=CValueIdentifier("__out"))
			)

		# memcpy отдает dst, так что он же и есть результат
		return CStmtReturn(
			cvalue_memcpy(
				CValueIdentifier("__out"),
				do_cvalue_as_ptr(x.value),
				cvalue_sizeof_type(x.value.type)
			)
		)

	cretval = None
	if x.value != None and not x.value.type.is_unit():
		cretval = do_cvalue(x.value)
	cstmt_return = CStmtReturn(cretval)
	return cstmt_return


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

	dynamic_init = init_value.type.is_array() and (init_value.is_runtime() or var_value.type.is_vla())

	civ = None
	if not dynamic_init and not init_value.is_undefined() and not init_value.type.is_va_list():
		civ = do_cinitializer(var_value.type, init_value, ctx=[])

	storage_class = ''
	if x.hasAttribute('static'):
		storage_class = 'static'

	dv = CStmtDefVar(get_id_str(var_value), do_ctype(var_value.type), initializer=civ, storage_class=storage_class)

	if dynamic_init:
		return (dv, do_assign_array(var_value, init_value, x.ti))

	return (dv,)


def const_as_macro(v):
	if v.is_global():
		return True
	if v.is_local():
		return value_is_generic_immediate(v)
	return False


def do_cstmt_const(x):
	const_value = x.value
	type = const_value.type
	init_value = x.init_value

#	if type.is_integer():
#		dt = CTypeEnum([CEnumItem(get_id_str(x), do_cvalue(init_value))])
#		dv = CStmtDefVar('', dt, storage_class='')#, attributes=x.attributes)
#		return (dv,)

	# print only generic constant as C macrodefinition
	if const_as_macro(const_value):
		id_str = get_id_str(const_value)
		global func_undef_list
		func_undef_list.append(id_str)
		# если точный тип константы неизвестен - печатаем ее как макро
		iv = do_cinitializer(type, init_value, ctx=[])
		macro = CMacroDefValue(id_str, iv)
		return macro

	civ = None
	if not (init_value.type.is_array() and init_value.is_runtime()):
		civ = do_cinitializer(type, init_value, ctx=[])

	ct = do_ctype(type)
	if type.is_array() and not init_value.is_immediate():
		ct.specifiers.remove('const')
	dv = CStmtDefVar(get_id_str(x), ct, initializer=civ, storage_class=None)

	# print constant as 'variable'
	# литерал массива включающий в себя переменные печатаем отдельно
	if init_value.type.is_array() and init_value.is_runtime():
		return (dv, do_assign_array(const_value, init_value, x.ti))

	return dv


def do_stmt_asm(x):
	text = x.text.asset

	outputs = []
	for output in x.outputs:
		outputs.append((do_cvalue(output[0]), do_cvalue(output[1])))

	inputs = []
	for _input in x.inputs:
		inputs.append((do_cvalue(_input[0]), do_cvalue(_input[1])))

	clobbers = []
	for clobber in x.clobbers:
		clobbers.append(do_cvalue(clobber))

	return CStmtInlineAsm(text, outputs, inputs, clobbers)



def do_stmt_comment(x):
	if isinstance(x, StmtCommentLine):
		return (CStmtLineComment(x.lines),)
	elif isinstance(x, StmtCommentBlock):
		return (CStmtBlockComment(x.text),)
	return ()



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
	elif x.is_stmt_again(): return CStmtContinue()
	elif x.is_stmt_comment(): return do_stmt_comment(x)
	elif x.is_stmt_asm(): return do_stmt_asm(x)
	elif x.is_stmt_def_type(): return do_def_type(x)
	elif x.is_stmt_def_func(): return CRawText("") #do_def_func(x)
	elif x.is_stmt_increment(): return do_cstmt_increment(x)
	elif x.is_stmt_decrement(): return do_cstmt_decrement(x)
	1/0


def do_cstmt_increment(x):
	return CStmtIncrement(do_cvalue(x.value))

def do_cstmt_decrement(x):
	return CStmtDecrement(do_cvalue(x.value))


def do_decl_func(x):
	if x in declared:
		return []

	func = x.value
	storage_class = ''
	if x.hasAttribute('extern'):
		storage_class = 'extern'
	elif (x.access_level == HLIR_ACCESS_LEVEL_PRIVATE) or x.hasAttribute('static'):
		storage_class = 'static'

	if x.hasAttribute('inline'):
		if storage_class != '':
			storage_class = storage_class + ' inline'
		else:
			storage_class = 'inline'

	ftype = do_ctype(func.type)
	dv = CStmtDefVar(get_id_str(func), ftype, storage_class=storage_class, attributes=x.attributes)
	declared.append(x)
	return (dv,)


def do_def_func(x):
	global cfunc
	global defined

	if x in defined:
		return []

	if x.stmt == None:
		return do_decl_func(x)

	func = x.value

	old_cfunc = cfunc
	cfunc = func

	xdefs = []

	for df in func.funcs:
		xdefs.extend(do_def_func(df))

	storage_class = ''
	if x.hasAttribute('extern'):
		storage_class = 'extern'
	elif not x.hasAttribute('nonstatic'):
		if (x.access_level == HLIR_ACCESS_LEVEL_PRIVATE) or x.hasAttribute('static'):
			storage_class = 'static'

	if x.hasAttribute('inline'):
		if storage_class != '':
			storage_class = storage_class + ' inline'
		else:
			storage_class = 'inline'

	cblock = do_cstmt_block(x.stmt)

	#create local copy for array parameters
	for param in func.type.params:
		if param.type.is_sized_array():
			paramId = get_id_str(param)
			dv = CStmtDefVar(paramId, do_ctype(param.type))
			mx = CStmtExpr(
				cvalue_memcpy(
					CValueIdentifier(paramId),
					CValueIdentifier('_' + paramId),
					cvalue_sizeof_type(param.type)
				)
			)

			cblock.stmts = [dv, mx] + cblock.stmts


	global func_undef_list
	for id_str in func_undef_list:
		cblock.stmts.append(CMacroUndef(id_str))
	func_undef_list = []

	# a function definition always needs the parameter list spelled out,
	# even if func.type is a named alias (e.g. `func handler: FailHandler { ... }`)
	ftype = do_ctype_func(func.type)
	dv = CStmtDefFunc(get_id_str(func), ftype, cblock, storage_class=storage_class, attributes=x.attributes)

	cfunc = old_cfunc

	xdefs.append(dv)
	defined.append(x)
	return xdefs


def do_def_type(x):
	global defined

	if x in defined:
		return []

	do_deps(x.deps)

	id_str = get_id_str(x.type)
	orig_type = x.original_type

	if orig_type.is_record() and not is_named(orig_type):
		result = do_def_type_record(x.type)
		defined.append(x)
		return result

	dt = CStmtDefType(id_str, do_ctype(orig_type))
	defined.append(x)
	return (dt,)


def do_def_type_record(t):
	id_str = get_id_str(t)

	defs = ()

	# Если структура open & не задекларирована ранее - печатаем для нее typedef
	if (not id_str in declared) and t.is_open_record:
		tag = get_record_tag(t)
		isa = 'struct' if not t.layout == 'union' else 'union'
		kisa = isa + ' ' + tag
		dt = CStmtDefType(get_id_str(t), CTypeIdentifier(kisa))
		defs = (dt,)

	dt = do_ctype_struct(t, tag=get_record_tag(t), specs=[])

	dv = CStmtDefVar('', dt, storage_class='', attributes=t.attributes)
	defs = defs + (dv,)
	return defs


def do_def_var(x, isdecl=False):
	global defined

	is_extern = isdecl

	if isdecl:
		if x in declared:
			return []
	else:
		if x in defined:
			return []


	var_value = x.value

	# TODO: Почему-то атрибут 'extern' не работает, и накостылил через is_extern
	is_extern = is_extern or x.hasAttribute('extern')

	storage_class = ''
	if x.access_level == HLIR_ACCESS_LEVEL_PRIVATE:
		if not (is_extern or x.hasAttribute('nonstatic')):
			storage_class = "static"

	if is_extern:
		storage_class = "extern"

	civ = None
	if not (x.init_value.is_undefined() or x.init_value.is_default() or is_extern):
		civ = do_cinitializer(var_value.type, x.init_value, ctx=[])

	dv = CStmtDefVar(get_id_str(var_value), do_ctype(var_value.type), initializer=civ, storage_class=storage_class, attributes=x.attributes)

	if isdecl:
		declared.append(x)
	else:
		defined.append(x)

	return (dv,)


def do_def_const(x):
	global defined

	if x in defined:
		return []

	if x.hasAttribute('extern'):
  		return (CRawText(""),)

	id_str = camel_to_upper_snake(get_id_str(x.value))
	iv = do_cinitializer(x.value.type, x.init_value, ctx=[])

	if x.init_value.is_cons() and x.init_value.method != 'explicit':
		if x.init_value.value.type.is_generic() and not x.init_value.type.is_array():
			if not isinstance(iv, CValueCast):
				iv = CValueCast(do_ctype(x.value.type), iv)

#	if not isinstance(iv, CValueCast):
#		if not x.init_value.type.is_generic() and not x.init_value.type.is_array():
#			iv = CValueCast(do_ctype(x.value.type), iv)

	#iv.mark = str(x.init_value)
	macro = CMacroDefValue(id_str, iv)
	module_undef_list.append(id_str)
	defined.append(x)
	return (macro,)


already_included = []
def include(path, local=True):
	if path in already_included:
		return ()
	already_included.append(path)
	dv = CInclude(path, is_system=not local)
	return (dv,)



def print_directive(x):
	if isinstance(x, StmtDirectiveInsert):
		out(x.text)
		newline()



def is_private(x):
	if isinstance(x, StmtDef):
		return x.access_level == HLIR_ACCESS_LEVEL_PRIVATE
	return False



def do_deps(deps):
	xdeps = []
	for dep in deps:
		xdeps.extend(do_dep(dep))
	return xdeps



def do_dep(dep):
	global defined, declared

	if dep.definition != None:
		if isinstance(dep, ValueConst):
			return do_def_const(dep.definition)

		if isinstance(dep, ValueFunc):
			return do_decl_func(dep.definition)

		if isinstance(dep, TypeRecord):
			return do_decl_type_record(dep.definition)

	return []



def do_decl_type_record(x):
	if x in declared:
		return []

	t = x.type
	tag = get_record_tag(t)
	isa = 'struct' if not t.layout == 'union' else 'union'
	kisa = isa + ' ' + tag
	dt = CStmtDeclType(CTypeIdentifier(kisa))
	declared.append(x)
	if t.is_open_record:
		df = CStmtDefType(get_id_str(t), CTypeIdentifier(kisa))
		return (dt, df)
	return (dt,)


def do_helpers(module):

	if 'use_unicode' in module.helpers:
		pairs = [
			(
				"!defined(__STR_UNICODE__)",
				[
					CMacroDef("__STR_UNICODE__", None),
					CStmtDefType("char8_t", CTypeIdentifier("uint8_t")),
					CStmtDefType("char16_t", CTypeIdentifier("uint16_t")),
					CStmtDefType("char32_t", CTypeIdentifier("uint32_t")),
					CMacroDef("__STR8(x)", "x"),
					CMacroDef("__STR16(x)", "u##x"),
					CMacroDef("__STR32(x)", "U##x"),
					CMacroDef("_STR8(x)", "__STR8(x)"),
					CMacroDef("_STR16(x)", "__STR16(x)"),
					CMacroDef("_STR32(x)", "__STR32(x)"),
				]
			)
		]

		return [CConditionalRegion(pairs)]
	return []


def do_helper_use_stdlib():
	return include("stdlib.h", local=False)


def do_helper_use_va_arg():
	return include("stdarg.h", local=False)


def do_helper_use_lengthof():
	#module_undef_list.append("LENGTHOF")
	df = CConditionalRegion([("!defined(LENGTHOF)", [CMacroDef("LENGTHOF(x)", "(sizeof(x) / sizeof((x)[0]))")])])
	return (df,)


def do_helper_use_rawcast():
	# из-за strict aliasing в C трюк с укзаателями не гарантирует что мы не словим UB при оптимизациях
	# union же гарантирует нам преобразование и данный трюк сработает на стандартах начиная с C99 и выше
	df = CMacroDef("RAWCAST(type_dst, type_src, value)", "(((union { type_src src; type_dst dst; }){ .src = (value) }).dst)")
	return (df,)


def do_helper_use_bigint():
	sstr = ''
	sstr += ("\n#ifndef __BIG_INT128__")
	sstr += ("\n#define BIG_INT128(hi64, lo64) (((unsigned __int128)(hi64) << 64) | ((unsigned __int128)(lo64)))")
	sstr += ("\n__attribute__((unused)) static inline __int128 abs128(__int128 x) {return x < 0 ? -x : x;}")
	sstr += ("\n#endif  /* __BIG_INT128__ */")
	sstr += ("\n")
	#sstr += ("\n#ifndef __BIG_INT256__")
	#sstr += ("\n#define BIG_INT256(a, b, c, d)")
	#sstr += ("\n#endif  /* __BIG_INT256__ */")
	module_undef_list.append("__BIG_INT128__")
	#module_undef_list.append("__BIG_INT256__")
	return (CRawText(sstr),)


# not used, __builtin_memcpy() instead now
def do_helper_use_arrcpy():
	sstr = ''
	sstr += ("\n#define ARRCPY(dst, src, len) \\")
	sstr += ("\n	do { \\")
	sstr += ("\n		uint32_t _len = (uint32_t)(len); \\")
	sstr += ("\n		for (uint32_t _i = 0; _i < _len; _i++) { \\")
	sstr += ("\n			(*(dst))[_i] = (*(src))[_i]; \\")
	sstr += ("\n		} \\")
	sstr += ("\n	} while (0)")
	module_undef_list.append("ARRCPY")
	return (CRawText(sstr),)


#func packFixed32 (i: Nat32, m: Nat32, n: Nat32 fraction: Nat8) -> Fixed32 {
#	let tail = Nat64 m * (Nat64(Word32 1 << fraction) - 1) / Nat64 n
#	return unsafe Fixed32 ((Word32 i << fraction) or unsafe Word32 tail)
#}

# Только имена типов: FixedX печатается как __fixedX (см. type_fixed_create),
# поэтому typedef нужен и в заголовке, где публичное объявление может
# упомянуть тип, но ни одной fixed-операции нет. Повтор typedef с тем же
# типом легален в C11 (6.7p3), а вот static inline из полного хелпера
# продублировать нельзя - потому он и вынесен отдельно.
def do_helper_use_fixed_point_types():
	sstr = ''
	sstr += ("\n#ifndef __FIXED_POINT__")
	sstr += ("\ntypedef int32_t __fixed32;")
	sstr += ("\ntypedef int64_t __fixed64;")
	sstr += ("\n#endif /* __FIXED_POINT__ */\n")
	return (CRawText(sstr),)


def do_helper_use_fixed_point():
	sstr = ''
	sstr += ("\n#ifndef __FIXED_POINT__")

	sstr += ("\ntypedef int32_t __fixed32;")
	sstr += ("\ntypedef int64_t __fixed64;")

	# Округление к ближайшему, половина - от нуля: то же правило, что и у
	# свертки констант (см. value/fixed.py), иначе одно и то же выражение
	# давало бы разный результат в зависимости от того, известно оно на
	# этапе компиляции или нет.
	# (!) Макрос обязан оставаться КОНСТАНТНЫМ ВЫРАЖЕНИЕМ - он попадает
	# в статические инициализаторы, где вызов функции недопустим. Ценой
	# этого (x) вычисляется дважды, поэтому codegen подставляет сюда
	# только литералы и константы; для рантайма есть __fixedX_from_float64
	sstr += ("\n#define FIXED32(x, f) ((__fixed32)((double)(x) * (double)((int64_t)1 << (f)) + ((x) < 0 ? -0.5 : 0.5)))")
	sstr += ("\n#define FIXED64(x, f) ((__fixed64)((double)(x) * (double)((int64_t)1 << (f)) + ((x) < 0 ? -0.5 : 0.5)))")

	sstr += ("\nstatic inline __fixed64 __fixed64_create(int64_t i, uint64_t m, uint64_t n, uint8_t fraction) {")
	sstr += ("\n	return (i << fraction) | (m * (1 << fraction) / n);")
	sstr += ("\n}")

	# у целого источника дробной части нет, поэтому масштаб - ровно
	# сдвиг влево, и округлять тут нечего.
	# (!) 1 сдвигаем в ширине результата: `1 << 31` на int - переполнение
	sstr += ("\n__attribute__((used))")
	sstr += ("\nstatic inline __fixed32 __fixed32_from_int32(int32_t a, uint8_t fraction) {")
	sstr += ("\n	return (__fixed32)(a * ((int32_t)1 << fraction));")
	sstr += ("\n}")

	sstr += ("\n__attribute__((used))")
	sstr += ("\nstatic inline __fixed64 __fixed64_from_int64(int64_t a, uint8_t fraction) {")
	sstr += ("\n	return (__fixed64)(a * ((int64_t)1 << fraction));")
	sstr += ("\n}")

	# Перенос двоичной точки между разными @fraction. Считаем в int64
	# независимо от ширин: у сужения (Fixed64 -> Fixed32) урезать
	# операнд ДО переноса нельзя, целая часть уедет. Целевую ширину
	# накладывает codegen приведением результата.
	# Влево - точный сдвиг; вправо - округление к ближайшему, половина
	# от нуля, тем же правилом, что и свертка (см. value/fixed.py)
	sstr += ("\n__attribute__((used))")
	sstr += ("\nstatic inline int64_t __fixed_rescale(int64_t a, uint8_t from_fraction, uint8_t to_fraction) {")
	sstr += ("\n	if (to_fraction >= from_fraction) {")
	sstr += ("\n		return a << (to_fraction - from_fraction);")
	sstr += ("\n	} else {")
	sstr += ("\n		int64_t d = (int64_t)1 << (from_fraction - to_fraction);")
	sstr += ("\n		int64_t half = d / 2;")
	sstr += ("\n		return (a < 0 ? a - half : a + half) / d;")
	sstr += ("\n	}")
	sstr += ("\n}")

	# аргумент вычисляется один раз (в отличие от макроса) - через это
	# codegen пропускает рантаймовые значения, в т.ч. вызовы функций
	sstr += ("\n__attribute__((used))")
	sstr += ("\nstatic inline __fixed32 __fixed32_from_float64(double a, uint8_t fraction) {")
	sstr += ("\n	return FIXED32(a, fraction);")
	sstr += ("\n}")

	sstr += ("\n__attribute__((used))")
	sstr += ("\nstatic inline __fixed64 __fixed64_from_float64(double a, uint8_t fraction) {")
	sstr += ("\n	return FIXED64(a, fraction);")
	sstr += ("\n}")

	# Обратная сторона __fixedX_from_*: снимаем масштаб.
	# (!) 1 сдвигаем как int64_t: @fraction(N) доходит до 31 у Fixed32
	# и до 63 у Fixed64, а `1 << 31` на int - переполнение со знаком.
	# Деление, а не сдвиг: '/' у отрицательных отбрасывает дробь в
	# сторону нуля - как того требует таблица конструирования и как
	# считает свертка (int(Fraction) в value/int.py)
	#
	# Макрос и inline-функция считают одно и то же; макрос нужен затем,
	# что известное на этапе компиляции снятие масштаба попадает в
	# статические инициализаторы, где вызов функции недопустим. В отличие
	# от FIXED32()/FIXED64() операнд здесь вычисляется РОВНО ОДИН РАЗ,
	# поэтому оговорки "только литералы и константы" тут не нужно -
	# codegen отдает макросу любое immediate-выражение
	sstr += ("\n#define __FIXED32_TO_INT32(x, f) ((int32_t)((x) / ((int64_t)1 << (f))))")
	sstr += ("\n#define __FIXED64_TO_INT64(x, f) ((int64_t)((x) / ((int64_t)1 << (f))))")
	sstr += ("\n#define __FIXED32_TO_FLOAT64(x, f) ((double)(x) / (double)((int64_t)1 << (f)))")
	sstr += ("\n#define __FIXED64_TO_FLOAT64(x, f) ((double)(x) / (double)((int64_t)1 << (f)))")

	sstr += ("\n__attribute__((used))")
	sstr += ("\nstatic inline int32_t __fixed32_to_int32(__fixed32 a, uint8_t fraction) {")
	sstr += ("\n	return (int32_t)(a / ((int64_t)1 << fraction));")
	sstr += ("\n}")

	sstr += ("\n__attribute__((used))")
	sstr += ("\nstatic inline int64_t __fixed64_to_int64(__fixed64 a, uint8_t fraction) {")
	sstr += ("\n	return a / ((int64_t)1 << fraction);")
	sstr += ("\n}")

	sstr += ("\n__attribute__((used))")
	sstr += ("\nstatic inline double __fixed32_to_float64(__fixed32 a, uint8_t fraction) {")
	sstr += ("\n	return (double)a / (double)((int64_t)1 << fraction);")
	sstr += ("\n}")

	sstr += ("\n__attribute__((used))")
	sstr += ("\nstatic inline double __fixed64_to_float64(__fixed64 a, uint8_t fraction) {")
	sstr += ("\n	return (double)a / (double)((int64_t)1 << fraction);")
	sstr += ("\n}")

	# у mul масштаб возводится в квадрат, у div - сокращается;
	# половину младшего разряда добавляем ДО деления, чтобы округление
	# (к ближайшему, половина - от нуля) совпало со сверткой констант.
	# Делим, а не сдвигаем: '/' у отрицательных отбрасывает дробь в
	# сторону нуля, а '>>' - в сторону минус бесконечности, и половина
	# ушла бы не от нуля, а вниз (плюс сдвиг отрицательного в C11 UB).
	# Промежуточное произведение вдвое шире хранилища: int64_t у Fixed32,
	# __int128 у Fixed64
	#
	# (!) МАКРОСЫ обязаны оставаться КОНСТАНТНЫМ ВЫРАЖЕНИЕМ - они попадают
	# в статические инициализаторы, где вызов функции недопустим. Ценой
	# этого операнды вычисляются дважды, поэтому codegen подставляет их
	# только там, где выражение известно на этапе компиляции; для рантайма
	# есть одноименные inline-функции (см. do_cvalue_fixed_bin)
	sstr += ("\n#define __FIXED32_MUL(a, b, f) \\")
	sstr += ("\n	((__fixed32)(((int64_t)(a) * (int64_t)(b) < 0 \\")
	sstr += ("\n		? (int64_t)(a) * (int64_t)(b) - (((int64_t)1 << (f)) / 2) \\")
	sstr += ("\n		: (int64_t)(a) * (int64_t)(b) + (((int64_t)1 << (f)) / 2)) \\")
	sstr += ("\n	/ ((int64_t)1 << (f))))")

	sstr += ("\n#define __FIXED32_DIV(a, b, f) \\")
	sstr += ("\n	((__fixed32)((((a) < 0) == ((b) < 0) \\")
	sstr += ("\n		? (int64_t)(a) * ((int64_t)1 << (f)) + (int64_t)(b) / 2 \\")
	sstr += ("\n		: (int64_t)(a) * ((int64_t)1 << (f)) - (int64_t)(b) / 2) \\")
	sstr += ("\n	/ (int64_t)(b)))")

	sstr += ("\nstatic inline __fixed32 __fixed32_mul(__fixed32 a, __fixed32 b, uint8_t fraction) {")
	sstr += ("\n	int64_t p = (int64_t)a * (int64_t)b;")
	sstr += ("\n	int64_t scale = (int64_t)1 << fraction;")
	sstr += ("\n	return (__fixed32)((p < 0 ? p - scale / 2 : p + scale / 2) / scale);")
	sstr += ("\n}")

	sstr += ("\nstatic inline __fixed32 __fixed32_div(__fixed32 a, __fixed32 b, uint8_t fraction) {")
	sstr += ("\n	int64_t n = (int64_t)a * ((int64_t)1 << fraction);")
	sstr += ("\n	int64_t half = (int64_t)b / 2;")
	sstr += ("\n	return (__fixed32)(((a < 0) == (b < 0) ? n + half : n - half) / (int64_t)b);")
	sstr += ("\n}")

	# __int128 есть только у 64-битных целей: под guard, чтобы модуль,
	# который пользуется одним лишь Fixed32, собирался и без него
	sstr += ("\n#ifdef __SIZEOF_INT128__")

	sstr += ("\n#define __FIXED64_MUL(a, b, f) \\")
	sstr += ("\n	((__fixed64)(((__int128)(a) * (__int128)(b) < 0 \\")
	sstr += ("\n		? (__int128)(a) * (__int128)(b) - (((__int128)1 << (f)) / 2) \\")
	sstr += ("\n		: (__int128)(a) * (__int128)(b) + (((__int128)1 << (f)) / 2)) \\")
	sstr += ("\n	/ ((__int128)1 << (f))))")

	sstr += ("\n#define __FIXED64_DIV(a, b, f) \\")
	sstr += ("\n	((__fixed64)((((a) < 0) == ((b) < 0) \\")
	sstr += ("\n		? (__int128)(a) * ((__int128)1 << (f)) + (__int128)(b) / 2 \\")
	sstr += ("\n		: (__int128)(a) * ((__int128)1 << (f)) - (__int128)(b) / 2) \\")
	sstr += ("\n	/ (__int128)(b)))")

	sstr += ("\nstatic inline __fixed64 __fixed64_mul(__fixed64 a, __fixed64 b, uint8_t fraction) {")
	sstr += ("\n	__int128 p = (__int128)a * (__int128)b;")
	sstr += ("\n	__int128 scale = (__int128)1 << fraction;")
	sstr += ("\n	return (__fixed64)((p < 0 ? p - scale / 2 : p + scale / 2) / scale);")
	sstr += ("\n}")

	sstr += ("\nstatic inline __fixed64 __fixed64_div(__fixed64 a, __fixed64 b, uint8_t fraction) {")
	sstr += ("\n	__int128 n = (__int128)a * ((__int128)1 << fraction);")
	sstr += ("\n	__int128 half = (__int128)b / 2;")
	sstr += ("\n	return (__fixed64)(((a < 0) == (b < 0) ? n + half : n - half) / (__int128)b);")
	sstr += ("\n}")

	sstr += ("\n#endif /* __SIZEOF_INT128__ */")

	sstr += ("\n#endif /* __FIXED_POINT__ */\n")
	return (CRawText(sstr),)


h_helpers = {
	'use_bigint': do_helper_use_bigint,
	'use_va_arg': do_helper_use_va_arg,
	'use_fixed_point': do_helper_use_fixed_point_types,
}

c_helpers = {
	'use_abs': do_helper_use_stdlib,
	'use_lengthof': do_helper_use_lengthof,
	'use_arrcpy': do_helper_use_arrcpy,
	'use_raw_cast': do_helper_use_rawcast,
	'use_fixed_point': do_helper_use_fixed_point,
	'use_bigint': do_helper_use_bigint,
	'use_malloc': do_helper_use_stdlib,
	'use_va_arg': do_helper_use_va_arg,
}


def do_header(module):
	defs = module.defs

	global already_included
	already_included = []

	xdefs = []

	guardsymbol = camel_to_upper_snake(module.id) + '_H'
	xdefs.append(CMacroDef(guardsymbol, None))

	if defs != []:
		for x in defs:
			if x.is_stmt_directive() and isinstance(x, StmtDirectiveCInclude):
				xdefs.extend(include(x.c_name, local=x.is_local))

	# add C include directive for included modules
	for inc in module.included_modules:
		if not inc.hasAttribute('do_not_include'):
			xdefs.extend(include(inc.id + '.h', local=True))

	for x in defs:
		if x.is_stmt_import() and x.module != None and not x.module.hasAttribute('do_not_include'):
			s = ""
			if hasattr(x, 'cinclude'):
				s = x.cinclude
				#print(">> HAS cinclude %s" % s)
			else:
				s = os.path.basename(x.impline + '.h')
			if s != "":
				xdefs.extend(include(s, local=True))

	xdefs.extend(include("stddef.h", local=False))
	xdefs.extend(include("stdint.h", local=False))
	xdefs.extend(include("stdbool.h", local=False))
	xdefs.extend(do_helpers(module))

	# TODO: убери это - не место в атрибутах модуля, а то по сути это уже не атрибуты, а зависимости от хелперов
	for use in module.helpers:
		if use in h_helpers:
			xdefs.extend(h_helpers[use]())

	#xdefs.append(CRawText("\n"))

	for x in defs:
		if is_private(x):
			continue

		if x.hasAttribute('c_no_print') or x.hasAttribute('no_print'):
			continue

		#if x.is_stmt_directive():
		#	if isinstance(x, StmtDirectiveCInclude):
		#		continue

		if x.is_stmt_def_func():
			if x.access_level == HLIR_ACCESS_LEVEL_PUBLIC and x.hasAttribute('inline'):
				xdefs.extend(do_def_func(x))
				continue
			xdefs.extend(do_decl_func(x))
		elif x.is_stmt_def_var():
			xdefs.extend(do_def_var(x, isdecl=True))
		elif x.is_stmt_def_type():
			xdefs.extend(do_deps(x.deps))
			xdefs.extend(do_def_type(x))
		elif x.is_stmt_def_const():
			xdefs.extend(do_deps(x.deps))
			xdefs.extend(do_def_const(x))
		elif x.is_stmt_comment():
			xdefs.extend(do_stmt_comment(x))

	dv = CConditionalRegion(pairs=[("!defined(%s)" % guardsymbol, xdefs)])
	return (dv,)


def was_defined(x):
	global defined
	if not x in defined:
		defined.append(x)


def extt(module):
	for m in module.included_modules:
		extt(m)
	for d in module.defs:
		was_defined(d)



def do_cfile(module):
	defs = module.defs

	global already_included, defined
	already_included = []

	xdefs = []

	if module.id != 'main':
		xdefs.extend(include(module.id + '.h'))

	xdefs.extend(include("stddef.h", local=False))
	xdefs.extend(include("stdint.h", local=False))
	xdefs.extend(include("stdbool.h", local=False))
	#xdefs.extend(include("string.h", local=False))

	for x in defs:
		if isinstance(x, StmtDirectiveCInclude) and (not x.is_local and x.c_name in STD_HEADERS):
			xdefs.extend(include(x.c_name, local=x.is_local))

	for x in defs:
		if x.is_stmt_directive() and isinstance(x, StmtDirectiveCInclude):
			xdefs.extend(include(x.c_name, local=x.is_local))

	# print C include for included modules
	for inc in module.included_modules:
		if not inc.hasAttribute('do_not_include'):
			xdefs.extend(include(inc.id + '.h', local=True))

	for x in defs:
		if x.is_stmt_import() and x.module != None and not x.module.hasAttribute('do_not_include'):
			s = ""
			if hasattr(x, 'cinclude'):
				s = x.cinclude
				#print(">> HAS cinclude %s" % s)
			else:
				s = os.path.basename(x.impline + '.h')
			if s != "":
				xdefs.extend(include(s, local=True))

	for x in defs:
		if isinstance(x, StmtDirectiveCInclude):
			xdefs.extend(include(x.c_name, local=x.is_local))


	# закидываем в defined все StmtDefXXX из импортируемых модулей ⚠️
	for m in module.included_modules:
		extt(m)


	# TODO: убери это - не место в атрибутах модуля, а то по сути это уже не атрибуты, а зависимости от хелперов
	for use in module.helpers:
		if use in c_helpers:
			xdefs.extend(c_helpers[use]())


	if len(module.anon_recs) > 0:
		#out("\n\n/* anonymous records */")
		for t in module.anon_recs:
			xdefs.extend(do_def_type_record(t))

	if len(module.anon_vars) > 0:
		for t in module.anon_vars:
			xdefs.extend(do_def_type_variant(t))

	xdefs.extend(do_helpers(module))

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
			xdefs.extend(do_deps(x.deps))
			xdefs.extend(do_def_const(x))

		elif x.is_stmt_def_type() and is_private(x):
			xdefs.extend(do_deps(x.deps))
			xdefs.extend(do_def_type(x))

		elif x.is_stmt_def_var():
			xdefs.extend(do_deps(x.deps))
			xdefs.extend(do_def_var(x))

		elif x.is_stmt_def_func():
			if x.access_level == HLIR_ACCESS_LEVEL_PUBLIC and x.hasAttribute('inline'):
				continue
			if x.deps != []:
				xdefs.append(CRawText("\n"))
				xdefs.extend(do_deps(x.deps))
			xdefs.extend(do_def_func(x))
		elif x.is_stmt_comment():
			xdefs.extend(do_stmt_comment(x))
			#print_comment(x)
			pass
		elif x.is_stmt_directive():
#			print_directive(x)
			pass

	return xdefs


def dump(filename, defs):
	global file
	dirname = os.path.dirname(filename)
	if dirname != '':
		os.makedirs(dirname, exist_ok=True)
	file = open(filename, "w", encoding=get_setting('backend.encoding'))
	for d in defs:
		file.write(render(d, style='legacy'))
	file.write("\n\n")
	file.close()


def run(module, _outname):
	global csettings

	if module.hasAttribute('c_no_print'):
		return

	hpath = _outname
	if 'include_dir' in csettings:
		inc_dir = csettings['include_dir']
		hname = os.path.basename(_outname)
		hpath = os.path.join(inc_dir, hname)


	if not 'no-h-file' in features:
		if module.id != 'main':
			hh = do_header(module)
			dump(hpath + '.h', hh)

	if not 'no-c-file' in features:
		cc = do_cfile(module)
		dump(_outname + '.c', cc)




# возвращает корневое значение из цепочки ValueCons & ValueSubexpr
# Костыль конечно, но пока C backend не разделен на два слоя, это хоть как то помогает
def get_root_value(x):
	if x.is_cons():
		return get_root_value(x.value)
	if x.is_subexpr():
		return get_root_value(x.value)
	return x



def cons_vla_from_literal_array(x):
	if x.is_cons():
		if x.type.is_vla():
			#return x['value']['kind'] in ['literal', HLIR_VALUE_OP_ADD]
			if x.is_bin():
				return x.op in ['literal', HLIR_VALUE_OP_ADD]
	return False



# получает Value, возаращает такой CValue у которого можно взять ref ⚠️
def do_cvalue_mem(x):
	cv = do_cvalue(x)

	if x.type.is_string():
		return cv

	if x.is_array() or (x.is_cons() and x.value.is_array()):
		cv = CValueCast(do_ctype(x.type), cv)
		return cv

	if x.is_runtime():
		return cv

	if not x.type.is_aggregate():
		error("attempt to load non aggregate", x.ti)
		print(x)
		exit(1)

	if x.type.is_generic():
		cv = CValueCast(do_ctype(x.type), cv)
		return cv

	if x.type.is_array():
		root = get_root_value(x)
		if root.is_const() and const_as_macro(root):
			ts = do_ctype(x.type)
			cv = CValueCast(ts, cv)
			return cv

	return cv



def do_cvalue_as_ptr(x, parr_relax=False):

	# cv = do_cvalue_mem(x)
	# if x.type.is_array():
	# 	return cv
	# return CValueReference(cv)

	if x.is_deref():
		return do_cvalue(x.value)  # Если это разыменовывание - просто вернем его аргумент (это указатель)

	if x.is_call():
		if x.type.is_sized_array():
			return do_cvalue(x)

		if x.type.is_record():
			item = do_cvalue(x)
			item.nl = 0
			ctype = CTypeArray(do_ctype(x.type), CValueInteger(1))
			return CValueCast(ctype, CValueArray([item]))

	if parr_relax and x.type.is_array():
		root = get_root_value(x)
		if root.is_array():
			return do_cvalue_mem(x)
		if root.is_var() or (root.is_const() and not const_as_macro(root)) or root.is_access_record():
			return do_cvalue(root)
		if ARRAY_AS_POINTER and root.is_const() and const_as_macro(root):
			return do_cvalue_mem(x)

	cv = do_cvalue_mem(x)
	cv = CValueReference(cv)

	# Если взяли адрес у array item - нужно привести его к *[]
	if not ARRAY_AS_POINTER:
		if x.is_slice():
			cv = CValueCast(CTypePointer(do_ctype(x.type)), cv)

		if parr_relax and x.type.is_array():
			cv = CValueCast(CTypePointer(do_ctype(x.type.of)), cv)

	return cv


def do_memzero(value):
	return CStmtExpr(cvalue_memzero(do_cvalue_as_ptr(value), cvalue_sizeof_type(value.type)))


def assign_by_memcopy(left, right):
	# TODO: improve it
	if get_root_value(right).is_zero():
		return do_memzero(left)

	return CStmtExpr(
		cvalue_memcpy(
			do_cvalue_as_ptr(left),
			do_cvalue_as_ptr(right),
			cvalue_sizeof_type(left.type)
		)
	)



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

