
import type as type
from error import info, warning, error

from .value import value_bad, value_is_bad, value_is_undefined, value_is_immediate, value_cons_node
from .unit import unit_can, value_unit_cons
from .bool import bool_can, value_bool_cons
from .word import word_can, value_word_cons
from .char import char_can, value_char_cons
from .integer import integer_can, value_integer_cons, value_integer_create
from .float import float_can, value_float_cons
from .record import record_can, value_record_cons
from .array import array_can, value_array_cons
from .pointer import pointer_can, value_pointer_cons, cons_ptr_to_str_from_string
from .bad import bad_can, value_bad_cons

# данная локальная функция пытается привести v к t
# возвращает None если не может привести (!)
# не принтует ошибку (но может выдать info)
def _do_value_cons(t, v, method, ti):
	if value_is_bad(v) or type.type_is_bad(t):
		return None

	#if type.type_is_record(t):
	#	info(" CONS RECORD %s" % t['kind'], ti)
	#if type.type_is_string(v['type']):
	#	info("+++++++ CONS %s" % t['kind'], ti)
	#	pass

	if method == 'implicit':
		if type.type_eq(v['type'], t):
			return v

	if method == 'explicit':
		if type.type_is_va_list(v['type']):
			return value_cons_node(t, v, 'explicit', ti)

		from trans import is_unsafe_mode
		if is_unsafe_mode():
			method = 'unsafe'


	constructor = None
	if type.type_is_integer(t): constructor = value_integer_cons
	elif type.type_is_float(t): constructor = value_float_cons
	elif type.type_is_array(t): constructor = value_array_cons
	elif type.type_is_record(t): constructor = value_record_cons
	elif type.type_is_char(t): constructor = value_char_cons
	elif type.type_is_word(t): constructor = value_word_cons
	elif type.type_is_bool(t): constructor = value_bool_cons
	elif type.type_is_pointer(t): constructor = value_pointer_cons
	elif type.type_is_unit(t): constructor = value_unit_cons
	elif type.type_is_bad(t): constructor = value_bad_cons
	else: assert False, "unknown type kind '%s'" % t['kind']

	if constructor == None:
		return None

	nv = constructor(t, v, method, ti)
	if nv != None:
		if 'nl' in v:
			nv['nl'] = v['nl']
	else:
		print(t['kind'])
		type.type_print(t)
		type.type_print(v['type'])

	return nv



# can be implicitly constructed value with type a from type b?
def cons_can(to, from_type, method):
#	print("cons_can? ", end='')
#	type.type_print(from_type)
#	print(" -> ", end='')
#	type.type_print(to)
#	print()

	if type.type_eq(to, from_type):
		return True

	if method == 'explicit':
		if type.type_is_va_list(from_type):
			return True

		from trans import is_unsafe_mode
		if is_unsafe_mode():
			method = 'unsafe'

	checker = None
	if type.type_is_integer(to): checker = integer_can
	elif type.type_is_unit(to): checker = unit_can
	elif type.type_is_bool(to): checker = bool_can
	elif type.type_is_word(to): checker = word_can
	elif type.type_is_record(to): checker = record_can
	elif type.type_is_pointer(to): checker = pointer_can
	elif type.type_is_array(to): checker = array_can
	elif type.type_is_float(to): checker = float_can
	elif type.type_is_char(to): checker = char_can
	elif type.type_is_bad(to): checker = bad_can

	res = False
	if checker != None:
		res = checker(to, from_type, method)
	#print(" = %d" % res)
	return res



def value_cons_implicit(t, v):
	assert(t['isa'] == 'type')
	assert(v['isa'] == 'value')

	# implisit cast possible only for:
	# 1. Generic -> NonGeneric
	# 2. Nil -> AnyPointer
	# 3. *[n]T -> *[]T
	# 4. AnyPointer -> FreePointer
	# 5. FreePointer -> AnyPointer

	if value_is_bad(v) or type.type_is_bad(t):
		return value_bad(v)

	ti = v['ti']

	from_type = v['type']

	if not cons_can(t, from_type, 'implicit'):
		#info("cannot implicitly construct value", v['ti'])
		return v

	# (!) потому что в C номинальные типы, а у нас - структурные

	# for structural type system support
	if type.type_is_record(t) and type.type_is_record(from_type):

		if type.type_is_generic(from_type):
			return _do_value_cons(t, v, 'implicit', ti)
			return value_record_cons(t, v, 'implicit', ti)

		elif not type.type_eq_record(t, from_type, opt=[], nominative=True):
			return value_cons_node(t, v, 'implicit', ti=ti)  # value_cons_node!

		elif t != from_type:
			# суть в том что если типы все же разные
			# (пусть и структурно идентичные)
			# нам нужно сгенерировать implicit_cons
			# по которому C и LLVM принтер будет знать
			# что нужно сделать hard_cast
			# тк в них номинативная система типов
			return value_record_cons(t, v, 'implicit', ti=ti)



	# for structural type system support
	if type.type_is_pointer_to_record(t):
		if type.type_is_pointer_to_record(from_type):
			if type.type_eq_record(from_type['to'], t['to'], opt=[]):
				# если равны но не номенативно - для C & LLVM нужно привдение
				# тк implicit то CM принтер не станет печатать приведение
				# а напечатает просто значение
				return value_pointer_cons(t, v, 'implicit', ti=ti)  # value_cons_node?


	return _do_value_cons(t, v, 'implicit', ti)


def value_cons_explicit(t, v, ti):
	assert(t['isa'] == 'type')
	assert(v['isa'] == 'value')
	assert(ti['isa'] == 'ti')

	if value_is_bad(v) or type.type_is_bad(t):
		return value_bad(v['ti'])

	from_type = v['type']

	if type.type_eq(t, from_type):
		info("explicit cast to the same type", ti)
		return v

	if not cons_can(t, from_type, 'explicit'):
		error("cannot construct value", ti)
		type.type_print(t)
		print(" from ", end='')
		type.type_print(from_type)
		print()
		return value_bad(v['ti'])

	return _do_value_cons(t, v, 'explicit', ti)



# for value
def select_default_type_for(x):
	xt = x['type']
	from trans import typeSysNat, typeSysInt, typeSysFloat, typeSysChar, typeSysStr

	if not type.type_is_generic(xt):
		return None

	if type.type_is_integer(xt):
		t = typeSysInt
		if type.type_is_unsigned(xt):
			t = typeSysNat
		return t

	elif type.type_is_string(xt):
		return typeSysStr

	elif type.type_is_float(xt):
		return typeSysFloat

	elif type.type_is_char(xt):
		return typeSysChar

	# Generic array with non-generic items -> Array
	# example:
	#   var a = [Int32 1, Int32 2]  // -> [2]Int32
	elif type.type_is_array(xt):
		if not type.type_is_generic(xt['of']):
			# GenericArray -> Array
			#print("- DEFAULT CONS ARRAY")
			item_type = xt['of']
			length = len(x['items'])
			volume = value_integer_create(length)
			return type.type_array(item_type, volume, x['ti'])

	return None # corresponded type not found!


# избавляемся от generic
def value_cons_default(v):
	t = select_default_type_for(v)
	if t != None:
		nv = _do_value_cons(t, v, 'implicit', v['ti'])
		if nv != None:
			return nv
	return v


def value_cons_implicit_check(t, v):
	nv = value_cons_implicit(t, v)
	#type.check(t, nv['type'], v['ti'])

	res = type.type_eq(t, nv['type'])
	if not res:
		error("type error", v['ti'])
		print("expected: ", end='')
		type.type_print(t)
		print("\nreceived: ", end='')
		type.type_print(v['type'])
		print("\n")

	return nv


