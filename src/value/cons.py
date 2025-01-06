import type as htype
from error import info, warning, error
from .value import Value, ValueBad, ValueCons
from .unit import unit_can, ValueUnit_cons
from .bool import bool_can, value_bool_cons
from .word import word_can, value_word_cons
from .char import char_can, value_char_cons
from .integer import integer_can, value_integer_cons, value_integer_create
from .float import float_can, value_float_cons
from .record import record_can, value_record_cons
from .array import array_can, value_array_cons
from .pointer import pointer_can, value_pointer_cons
from .bad import bad_can, ValueBad_cons
from .number import number_can, value_number_cons



# can be implicitly constructed value with type a from type b?
def cons_can(to, from_type, method):
	assert(to['isa'] == 'type')
	assert(from_type['isa'] == 'type')

	if htype.type_eq(to, from_type):
		return True

	if method == 'explicit':
		if htype.type_is_va_list(from_type):
			return True

		from trans import is_unsafe_mode
		if is_unsafe_mode():
			method = 'unsafe'

	checker = None
	if htype.type_is_number(to): checker = number_can
	elif htype.type_is_integer(to): checker = integer_can
	elif htype.type_is_unit(to): checker = unit_can
	elif htype.type_is_bool(to): checker = bool_can
	elif htype.type_is_word(to): checker = word_can
	elif htype.type_is_record(to): checker = record_can
	elif htype.type_is_pointer(to): checker = pointer_can
	elif htype.type_is_array(to): checker = array_can
	elif htype.type_is_float(to): checker = float_can
	elif htype.type_is_char(to): checker = char_can
	elif htype.type_is_bad(to): checker = bad_can
	else:
		info(to['kind'], to['ti'])
		assert(False)

	return checker(to, from_type, method)



# implisit cast possible only for:
# 1. Generic -> NonGeneric (Nil -> AnyPointer)
# 3. *[n]T -> *[]T
# 4. AnyPointer -> FreePointer
# 5. FreePointer -> AnyPointer
def value_cons_implicit(t, v, ti=None):
	assert(t['isa'] == 'type')
	assert(isinstance(v, Value))

	if Value.isBad(v) or htype.type_is_bad(t):
		return ValueBad(v.ti)

	ti = v.ti

	from_type = v.type

	if not cons_can(t, from_type, 'implicit'):
		info("cannot implicitly construct value", v.ti)
		return v

	# (!) потому что в C номинальные типы, а у нас - структурные

	# for structural type system support
	if htype.type_is_record(t) and htype.type_is_record(from_type):
		if id(t) != id(from_type):
			# Если структуры разные (номинативно!) то генерим cons операцию
			# для C и LLVM это важно (их не волнует то что структура может быть одинакова)
			return value_record_cons(t, v, 'implicit', ti=ti)

	# for structural type system support
	if htype.type_is_pointer_to_record(t) and htype.type_is_pointer_to_record(from_type):
		if id(t['to']) != id(from_type['to']):
			# Если это указатели на разные структуры (номинативно!) то генерим cons операцию
			# для C и LLVM это важно (их не волнует то что структура может быть одинакова)
			return value_pointer_cons(t, v, 'implicit', ti=ti)

	return value_cons(t, v, 'implicit', ti)



def value_cons_implicit_check(t, v):
	nv = value_cons_implicit(t, v)
	if not htype.type_eq(t, nv.type):
		error("type error", v.ti)
		print("expected: ", end='')
		htype.type_print(t)
		print("\nreceived: ", end='')
		htype.type_print(v.type)
		print("\n")
	return nv



def value_cons_explicit(t, v, ti):
	assert(t['isa'] == 'type')
	assert(isinstance(v, Value))
	assert(ti['isa'] == 'ti')

	if Value.isBad(v) or htype.type_is_bad(t):
		return ValueBad(v.ti)

	from_type = v.type

	if htype.type_eq(t, from_type):
		info("explicit cast to the same type", ti)
		return v

	if not cons_can(t, from_type, 'explicit'):
		error("cannot construct value", ti)
		htype.type_print(t)
		print(" from ", end='')
		htype.type_print(from_type)
		print()
		return ValueBad(v.ti)

	return value_cons(t, v, 'explicit', ti)



def value_cons_default(v):
	assert(isinstance(v, Value))
	t = _select_default_type_for(v.type)
	if t != None:
		#info("default cons", v.ti)
		nv = value_cons_implicit(t, v, v.ti)
		#if features.get('paranoid'):
		#	print("constructed: ", end='')
		#	htype.type_print(nv.type)
		#	print('')
		return nv

	return v



def _select_default_type_for(t):
	from trans import typeSysNat, typeSysInt, typeSysFloat, typeSysChar, typeSysStr

	if not htype.type_is_generic(t):
		return None

	if htype.type_is_number(t):
		t = typeSysInt
		if htype.type_is_unsigned(t):
			t = typeSysNat
		return t

	elif htype.type_is_string(t):
		return typeSysStr

	elif htype.type_is_float(t):
		return typeSysFloat

	elif htype.type_is_char(t):
		return typeSysChar

	elif htype.type_is_array(t):
		item_type = t['of']
		if htype.type_is_generic(t['of']):
			# выбираем тип для generic-элемента
			# [1, 2]  -> [2]Int32 [Int32 1, Int32 2]
			item_type = _select_default_type_for(t['of'])

		volume = t['volume']
		return htype.type_array(item_type, volume, t['ti'])


	# corresponded type not found!
	return None



# данная локальная функция пытается привести v к t
# возвращает None если не может привести (!)
# не принтует ошибку (но может выдать info)
def value_cons(t, v, method, ti):
	if Value.isBad(v) or htype.type_is_bad(t):
		return None

	if method == 'implicit':
		if htype.type_eq(v.type, t):
			return v

	if method == 'explicit':
		# Construction from __VA_List is an exceptional case
		if htype.type_is_va_list(v.type):
			return ValueCons(t, v, 'explicit', ti)

		from trans import is_unsafe_mode
		if is_unsafe_mode():
			method = 'unsafe'


	constructor = None
	if htype.type_is_number(t): constructor = value_number_cons
	elif htype.type_is_integer(t): constructor = value_integer_cons
	elif htype.type_is_float(t): constructor = value_float_cons
	elif htype.type_is_array(t): constructor = value_array_cons
	elif htype.type_is_record(t): constructor = value_record_cons
	elif htype.type_is_char(t): constructor = value_char_cons
	elif htype.type_is_word(t): constructor = value_word_cons
	elif htype.type_is_bool(t): constructor = value_bool_cons
	elif htype.type_is_pointer(t): constructor = value_pointer_cons
	elif htype.type_is_unit(t): constructor = ValueUnit_cons
	elif htype.type_is_bad(t): constructor = ValueBad_cons
	else:
		assert False, "unknown type kind '%s'" % t['kind']

	if constructor == None:
		return None

	nv = constructor(t, v, method, ti)
	if nv != None:
		nv.nl = v.nl
	else:
		print(t['kind'])
		htype.type_print(t)
		htype.type_print(v.type)

	return nv


