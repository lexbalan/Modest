import type as htype
from error import info, warning, error
from hlir.value import Value, ValueBad, ValueCons
from .unit import unit_can, ValueUnit_cons
from .bool import bool_can, value_bool_cons
from .word import word_can, value_word_cons
from .char import char_can, value_char_cons
from .integer import integer_can, value_integer_cons
from .natural import natural_can, value_natural_cons
from .float import float_can, value_float_cons
from .record import record_can, value_record_cons
from .array import array_can, value_array_cons
from .pointer import pointer_can, value_pointer_cons
from .bad import bad_can, ValueBad_cons
from .number import number_can, value_number_cons
from hlir.type import Type, TypeArray, TypeWord
from util import align_bits_up

# can be implicitly constructed value with type a from type b?
def cons_can(to, from_type, method, ti):
	assert(isinstance(to, Type))
	assert(isinstance(from_type, Type))

	if Type.eq(to, from_type):
		return True

	if method == 'explicit':
		if from_type.is_va_list():
			return True

		from trans import is_unsafe_mode
		if is_unsafe_mode():
			method = 'unsafe'

	checker = None
	if to.is_number(): checker = number_can
	elif to.is_integer(): checker = integer_can
	elif to.is_natural(): checker = natural_can
	elif to.is_unit(): checker = unit_can
	elif to.is_bool(): checker = bool_can
	elif to.is_word(): checker = word_can
	elif to.is_record(): checker = record_can
	elif to.is_pointer(): checker = pointer_can
	elif to.is_array(): checker = array_can
	elif to.is_float(): checker = float_can
	elif to.is_char(): checker = char_can
	elif to.is_bad(): checker = bad_can
	else:
		print (to.is_pointer())
		info(str(to), to.ti)
		assert(False)

	return checker(to, from_type, method, ti)



# implisit cast possible only for:
# 1. Generic -> NonGeneric (Nil -> AnyPointer)
# 3. *[n]T -> *[]T
# 4. AnyPointer -> FreePointer
# 5. FreePointer -> AnyPointer
def value_cons_implicit(t, v, ti=None):
	assert(isinstance(t, Type))
	assert(isinstance(v, Value))

	if v.isBad() or t.is_bad():
		return ValueBad(v.ti)

	ti = v.ti

	from_type = v.type

	if not cons_can(t, from_type, 'implicit', ti):
		#info("cannot implicitly construct value", v.ti)
		return v

	# (!) потому что в C номинальные типы, а у нас - структурные

	# for structural type system support
	if t.is_record() and from_type.is_record():
		if id(t) != id(from_type):
			# Если структуры разные (номинативно!) то генерим cons операцию
			# для C и LLVM это важно (их не волнует то что структура может быть одинакова)
			return value_record_cons(t, v, 'implicit', ti=ti)

	# for structural type system support
	if t.is_pointer_to_record() and from_type.is_pointer_to_record():
		if id(t.to) != id(from_type.to):
			# Если это указатели на разные структуры (номинативно!) то генерим cons операцию
			# для C и LLVM это важно (их не волнует то что структура может быть одинакова)
			return value_pointer_cons(t, v, 'implicit', ti=ti)

	return value_cons(t, v, 'implicit', ti)



def value_cons_implicit_check(t, v):
	nv = value_cons_implicit(t, v)
	if not Type.eq(t, nv.type):
		error("type error", v.ti)
		print("expected: ", end='')
		htype.type_print(t)
		print("\nreceived: ", end='')
		htype.type_print(v.type)
		print("\n")
	return nv



def value_cons_explicit(t, v, ti):
	assert(isinstance(t, Type))
	assert(isinstance(v, Value))
	assert(ti['isa'] == 'ti')

	if v.isBad() or t.is_bad():
		return ValueBad(v.ti)

	from_type = v.type

	if Type.eq(t, from_type):
		info("explicit cast to the same type", ti)
		return v

	if not cons_can(t, from_type, 'explicit', ti):
		error("cannot construct value", ti)
		htype.type_print(t)
		print(" from ", end='')
		htype.type_print(from_type)
		print()
		return ValueBad(v.ti)

	return value_cons(t, v, 'explicit', ti)



def value_cons_default(v):
	assert(isinstance(v, Value))

	# only for generics
	if v.type.is_generic():
		t = _select_default_type_for(v.type)
		if t != None:
			nv = value_cons_implicit(t, v, v.ti)
			#if features.get('paranoid'):
			#	print("constructed: ", end='')
			#	htype.type_print(nv.type)
			#	print('')
			return nv

	return v



def _select_default_type_for(t):
	from trans import typeSysWord, typeSysNat, typeSysInt, typeSysFloat, typeSysChar, typeSysStr

	# ONLY FOR GENERICS
	if not t.is_generic():
		return None

	if t.is_number():
		t = typeSysInt
		if t.is_unsigned():
			t = typeSysNat
		return t

	elif t.is_string():
		return typeSysStr

	elif t.is_float():
		return typeSysFloat

	elif t.is_char():
		return typeSysChar

	elif t.is_word():
		return typeSysWord

	elif t.is_array():
		item_type = t.of
		if item_type.is_generic():
			# выбираем тип для generic-элемента
			# [1, 2]  -> [2]Int32 [Int32 1, Int32 2]
			item_type = _select_default_type_for(item_type)

			if item_type == None:
				# не смогли подобрать default тип для элемента массива
				return None

		nt = TypeArray(item_type, t.volume, t.ti)
		return nt


	# corresponded type not found!
	return None



def _select_minimal_type_for(t):
	# ONLY FOR GENERICS
	if not t.is_generic():
		return None

	if t.is_array():
		pass
	elif t.is_string():
		return typeSysStr

	w = align_bits_up(t.width)

	if t.is_number():
		t = TypeInt(w)
		if t.is_unsigned():
			t = TypeNat(w)
		return t


	elif t.is_float():
		return TypeFloat(w)

	elif t.is_char():
		return TypeChar(w)

	elif t.is_word():
		return TypeWord(w)

	elif t.is_array():
		item_type = t.of
		if item_type.is_generic():
			# выбираем тип для generic-элемента
			# [1, 2]  -> [2]Int32 [Int32 1, Int32 2]
			item_type = _select_default_type_for(t.of)

			if item_type == None:
				# не смогли подобрать default тип для элемента массива
				return None

		nt = TypeArray(item_type, t.volume, t.ti)
		return nt

	# corresponded type not found!
	return None


# данная локальная функция пытается привести v к t
# возвращает None если не может привести (!)
# не принтует ошибку (но может выдать info)
def value_cons(t, v, method, ti):
	if v.isBad() or t.is_bad():
		return None

	if method == 'implicit':
		if Type.eq(v.type, t):
			return v

	if method == 'explicit':
		# Construction from __VA_List is an exceptional case
		if v.type.is_va_list():
			return ValueCons(t, v, 'explicit', ti)

		from trans import is_unsafe_mode
		if is_unsafe_mode():
			method = 'unsafe'


	constructor = None
	if t.is_number(): constructor = value_number_cons
	elif t.is_integer(): constructor = value_integer_cons
	elif t.is_natural(): constructor = value_natural_cons
	elif t.is_float(): constructor = value_float_cons
	elif t.is_array(): constructor = value_array_cons
	elif t.is_record(): constructor = value_record_cons
	elif t.is_char(): constructor = value_char_cons
	elif t.is_word(): constructor = value_word_cons
	elif t.is_bool(): constructor = value_bool_cons
	elif t.is_pointer(): constructor = value_pointer_cons
	elif t.is_unit(): constructor = ValueUnit_cons
	elif t.is_bad(): constructor = ValueBad_cons
	else:
		assert False, "unknown type kind '%s'" % t['kind']

	if constructor == None:
		return None

	nv = constructor(t, v, method, ti)
	if nv != None:
		nv.nl = v.nl
	else:
		print(t)
		htype.type_print(t)
		htype.type_print(v.type)

	return nv




# cons immediate такой же cons
# но поскольку у него value immediate, мы можем его asset
# привести и взять себе; Таким образом мы идем как литерал нода
# и в то же время как cons нода
def value_cons_immediate(t, v, method, ti):
	assert method in ['implicit', 'explicit', 'unsafe']
	nv = ValueCons(t, v, method, ti)

	nv.asset = v.asset
	nv.immediate = True

	if v.hasAttribute('hexadecimal'):
		nv.addAttribute('hexadecimal')

	nv.nl_end = v.nl_end

	return nv

