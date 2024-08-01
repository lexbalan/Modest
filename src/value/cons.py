
import hlir.type as type
from error import info, warning, error

from .value import value_is_bad, value_bad, value_is_immediate, value_cons_node
from .unit import value_unit_cons, unit_can
from .bool import value_bool_cons, bool_can
from .byte import value_byte_cons, byte_can
from .char import value_char_cons, char_can
from .integer import value_integer_cons, value_integer_create, integer_can
from .float import value_float_cons, float_can
from .record import value_record_cons, record_can
from .array import value_array_cons, array_can
from .pointer import value_pointer_cons, cons_ptr_to_str_from_string, pointer_can


# данная локальная функция пытается привести v к t
# возвращает None если не может привести (!)
# не принтует ошибку (но может выдать info)
def _do_value_cons(t, v, method, ti):
	if value_is_bad(v) or type.type_is_bad(t):
		return None

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
	elif type.type_is_byte(t): constructor = value_byte_cons
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
	"""print("cons_can? ", end='')
	type.type_print(from_type)
	print(" -> ", end='')
	type.type_print(to)"""

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
	elif type.type_is_byte(to): checker = byte_can
	elif type.type_is_record(to): checker = record_can
	elif type.type_is_pointer(to): checker = pointer_can
	elif type.type_is_array(to): checker = array_can
	elif type.type_is_float(to): checker = float_can
	elif type.type_is_char(to): checker = char_can

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
		return value_bad(v['ti'])

	ti = v['ti']

	from_type = v['type']


	if cons_can(t, from_type, 'implicit'):
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
				"""if type.type_eq_record(from_type['to'], t['to'], opt=[], nominative=True):
					# если номинативно равны - приведение не нужно
					return v
				el"""
				if type.type_eq_record(from_type['to'], t['to'], opt=[]):
					#info("***", v['ti'])
					# если равны но не номенативно - для C & LLVM нужно привдение
					# тк implicit то CM принтер не станет печатать приведение
					# а напечатает просто значение
					return value_record_cons(t, v, 'implicit', ti=ti)  # value_cons_node!
				"""elif t['to'] != from_type['to']:
					info("@@@", v['ti'])
					# суть в том что если типы все же разные
					# (пусть и структурно идентичные)
					# нам нужно сгенерировать implicit_cons
					# по которому C и LLVM принтер будет знать
					# что нужно сделать hard_cast
					# тк в них номинативная система типов
					return value_record_cons(t, v, 'implicit', ti=ti)"""

		# END - (!) потому что в C номинальные типы, а у нас - структурные

		nv = _do_value_cons(t, v, 'implicit', ti)
		if nv == None:
			return v
		return nv

	return v



def value_cons_explicit(t, v, ti):
	assert(t['isa'] == 'type')
	assert(v['isa'] == 'value')

	if value_is_bad(v) or type.type_is_bad(t):
		return value_bad(v['ti'])

	from_type = v['type']

	# for situation like:
	# var s = []Int32 [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
	if type.type_is_generic_array(from_type):
		if t['volume'] == None:
			t['volume'] = from_type['volume']

	if type.type_eq(t, from_type):
		info("explicit cast to the same type", ti)
		return v

	if not cons_can(t, from_type, 'explicit'):
		error("cannot do construct value", ti)
		"""type.type_print(t)
		print(" from ")
		type.type_print(from_type)
		print()"""
		return value_bad(v['ti'])

	nv = _do_value_cons(t, v, 'explicit', ti)
	assert(nv != None)
	return nv



def _try_to_implicit_cons(t, v, ti):
	nv = _do_value_cons(t, v, 'implicit', ti)
	return nv if (nv != None) else v


# избавляемся от generic
def value_cons_default(x):
	from_type = x['type']
	ti = x['ti']

	# THIS FUNCTION WORKS ONLY FOR GENERIC VALUES
	if not type.type_is_generic(from_type):
		return x

	from trans import typeSysNat, typeSysInt, typeSysFloat, typeSysChar, typeSysStr

	if type.type_is_integer(from_type):
		t = typeSysInt
		if not type.type_is_signed(from_type):
			t = typeSysNat
		return _try_to_implicit_cons(t, x, ti)

	elif type.type_is_string(from_type):
		return cons_ptr_to_str_from_string(typeSysStr, x, 'implicit', ti)

	elif type.type_is_float(from_type):
		return _try_to_implicit_cons(typeSysFloat, x, ti)

	elif type.type_is_char(from_type):
		return _try_to_implicit_cons(typeSysChar, x, ti)


	# Generic array with non-generic items -> Array
	# example:
	#   var a = [Int32 1, Int32 2]  // -> [2]Int32
	elif type.type_is_array(from_type):
		if type.type_is_generic(from_type):
			if not type.type_is_generic(from_type['of']):
				# GenericArray -> Array
				#print("- DEFAULT CONS ARRAY")
				item_type = from_type['of']
				length = len(x['asset'])
				volume = value_integer_create(length)
				t = type.hlir_type_array(item_type, volume, x['ti'])
				return _try_to_implicit_cons(t, x, ti)

	return x



def value_cons_implicit_check(t, v):
	nv = value_cons_implicit(t, v)
	#type.check(t, nv['type'], v['ti'])

	res = type.type_eq(t, nv['type'])
	if not res:
		error("type error", v['ti'])
		print("expected: ", end='')
		type_print(a)
		print("\nreceived: ", end='')
		type_print(b)
		print("\n")

	return nv


def value_bad_cons(t, v, method, ti):
	return value_bad(ti)





def implicit_cast_list(items, to_type):
	casted_items = []

	from .cons import value_cons_implicit
	i = 0
	while i < len(items):
		item = items[i]
		casted_item = value_cons_implicit(to_type, item)

		if 'nl_end' in item:
			casted_item['nl_end'] = item['nl_end']

		casted_items.append(casted_item)
		i = i + 1
	return casted_items


