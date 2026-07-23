
from hlir import *
from error import info, warning, error
from .bool import value_bool_can, value_bool_cons
from .integer import value_integer_can, value_integer_cons
from .rational import value_rational_can, value_rational_cons
from .word import value_word_can, value_word_cons
from .char import value_char_can, value_char_cons
from .int import value_int_can, value_int_cons
from .nat import value_nat_can, value_nat_cons
from .float import value_float_can, value_float_cons
from .fixed import value_fixed_can, value_fixed_cons
from .record import value_record_can, value_record_cons
from .array import value_array_can, value_array_cons
from .pointer import value_pointer_can, value_pointer_cons
from .variant import value_variant_can, value_variant_cons
from .bad import value_bad_can, value_bad_cons

from util import align_bits_up


# can be implicitly constructed value with type a from type b?
def cons_can(to, from_type, method, ti):
	#info("cons can?", ti)
	assert(isinstance(to, Type))
	assert(isinstance(from_type, Type))
	assert(isinstance(ti, TextInfo))

	if to.is_type_variant() and not from_type.is_type_variant():
		return variant_can(to, from_type, method, ti)

	if to.brand != from_type.brand:
		if method == 'implicit':
			return False

#		if not from_type.is_generic():
#			if method != 'unsafe':
#				return False

	if Type.eq(to, from_type):
		return True

	if method == 'explicit':
		if from_type.is_type_va_list():
			return True

		from semantic import is_unsafe_mode
		if is_unsafe_mode():
			method = 'unsafe'

	checker = None
	if to.is_type_integer(): checker = value_integer_can
	elif to.is_type_rational(): checker = value_rational_can
	elif to.is_type_int(): checker = value_int_can
	elif to.is_type_nat(): checker = value_nat_can
	elif to.is_type_bool(): checker = value_bool_can
	elif to.is_type_word(): checker = value_word_can
	elif to.is_type_record(): checker = value_record_can
	elif to.is_type_pointer(): checker = value_pointer_can
	elif to.is_type_array(): checker = value_array_can
	elif to.is_type_float(): checker = value_float_can
	elif to.is_type_fixed(): checker = value_fixed_can
	elif to.is_type_char(): checker = value_char_can
	elif to.is_type_variant(): checker = value_variant_can
	elif to.is_bad(): checker = value_bad_can
	else:
		print(to.is_type_pointer())
		info(str(to), to.ti)
		assert(False)

	can = checker(to, from_type, method, ti)
	return can



# implisit cast possible only for:
# 1. Generic -> NonGeneric (Nil -> AnyPointer)
# 3. *[n]T -> *[]T
# 4. AnyPointer -> FreePointer
# 5. FreePointer -> AnyPointer
def value_cons_implicit(t, v):
	ti = v.ti
	#info("value_cons_implicit", ti)
	assert(isinstance(t, Type))
	assert(isinstance(v, Value))
	#assert(isinstance(ti, TextInfo))

	if v.isValueUndef():
		return ValueUndef(t, ti=ti)


	if v.isValueBad() or t.is_bad():
		return ValueBad(ti)

	#if t.annotations != {}:
	#	print(t.annotations)

	from_type = v.type

	if not cons_can(t, from_type, 'implicit', ti):
		#info("cannot implicitly construct value", ti)
		return v

	# (!) потому что в C номинальные типы, а у нас - структурные

	# for structural type system support
	if t.is_type_record() and from_type.is_type_record():
		# Конструируем запись из записи
		# если типы записей разные или если оба типа - Generic (!)
		# (!) сравниваем uid, а не id() объекта: alias копирует чужой uid
		# (см. Type.update), поэтому две ссылки на одну и ту же запись
		# через разные имена (type B = A) остаются номинативно одним типом
		if t.uid != from_type.uid or (t.is_generic() and from_type.is_generic()):
			# Если структуры разные (номинативно!) то генерим cons операцию
			# для C и LLVM это важно (их не волнует то что структура может быть одинакова)
			return value_record_cons(t, v, 'implicit', ti=ti)

	# for structural type system support
	if t.is_type_pointer_to_record() and from_type.is_type_pointer_to_record():
		if t.to.uid != from_type.to.uid:
			# Если это указатели на разные структуры (номинативно!) то генерим cons операцию
			# для C и LLVM это важно (их не волнует то что структура может быть одинакова)
			return value_pointer_cons(t, v, 'implicit', ti=ti)

	return value_cons(t, v, 'implicit', ti)



def value_cons_implicit_check(t, v):
	#info("value_cons_implicit_check", v.ti)
	nv = value_cons_implicit(t, v)

	if t.is_holed():
		# особая ситуация когда неявно конструируем []X из [x]X (!)
		if not cons_can(t, v.type, method='implicit', ti=v.ti):
			error("type error2", v.ti)
			print("expected: ", end='')
			Type.print(t)
			print("\nreceived: ", end='')
			Type.print(v.type)
			print("\n")

	elif not Type.eq(t, nv.type):
		error("cannot implicitly construct `%s` from `%s`\n" % (t.to_str(), v.type.to_str()), v.ti)

	return nv



def value_cons_explicit(t, v, ti):
	assert(isinstance(t, Type))
	assert(isinstance(v, Value))
	assert(isinstance(ti, TextInfo))

	if v.isValueBad() or t.is_bad():
		return ValueBad(v.ti)

	from_type = v.type

	if from_type.is_bad():
		return ValueBad(v.ti)

	if Type.eq(t, from_type):
		if not t.is_generic():
			if t.attributes == from_type.attributes:
				info("explicit cons from the same type", ti)
				return v

	if not cons_can(t, from_type, 'explicit', ti):
		error("cannot construct '%s' from '%s' value" % (t.to_str(), from_type.to_str()), ti)
		return ValueBad(v.ti)

	return value_cons(t, v, 'explicit', ti)



def value_cons_extra_arg(v):
	return value_cons_default(v)
#	t = v.type
#	if not t.is_generic():
#		return v
#	t = _select_default_type_for(t)
#	nv = value_cons(t, v, 'extra_arg', v.ti)
#	if nv == None:
#		return ValueBad(v.ti)
#	return nv


def value_cons_default(v):
	#info("value_cons_default", v.ti)

	if not v.type.is_generic():
		return v

	t = _select_default_type_for(v.type)
	if t != None:
		nv = value_cons_implicit(t, v)
		nv.method = 'default'
		return nv
	else:
		error("cannot select default type for value with generic type", v.ti)

	return v



def _select_default_type_for(t):
	from semantic import typeSysWord, typeSysNat, typeSysInt, typeSysFloat, typeSysChar, typeSysStr

	# ONLY FOR GENERICS
	if not t.is_generic():
		return None

	if t.is_type_integer():
		t = typeSysInt
		if t.is_unsigned():
			t = typeSysNat
		return t

	elif t.is_type_string():
		return typeSysStr

	elif t.is_type_float():
		return typeSysFloat

	elif t.is_type_char():
		return typeSysChar

	elif t.is_type_word():
		return typeSysWord

	elif t.is_type_rational():
		return typeSysFloat

	elif t.is_type_array():
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
	elif t.is_type_record():
		return t

	# corresponded type not found!
	return None



# данная локальная функция пытается привести v к t
# возвращает None если не может привести (!)
# не принтует ошибку (но может выдать info)
def value_cons(t, v, method, ti):
	if v.isValueBad() or t.is_bad():
		return None

	if method == 'implicit':
		if Type.eq(v.type, t):
			return v

	if method == 'explicit':
		# Construction from __VA_List is an exceptional case
		if v.type.is_type_va_list():
			nv = ValueCons(t, t, v, 'explicit', ti)
			nv.stage = HLIR_VALUE_STAGE_RUNTIME
			return nv

		from semantic import is_unsafe_mode
		if is_unsafe_mode():
			method = 'unsafe'

	constructor = None
	if t.is_type_integer(): constructor = value_integer_cons
	elif t.is_type_rational(): constructor = value_rational_cons
	elif t.is_type_int(): constructor = value_int_cons
	elif t.is_type_nat(): constructor = value_nat_cons
	elif t.is_type_array(): constructor = value_array_cons
	elif t.is_type_record(): constructor = value_record_cons
	elif t.is_type_char(): constructor = value_char_cons
	elif t.is_type_word(): constructor = value_word_cons
	elif t.is_type_bool(): constructor = value_bool_cons
	elif t.is_type_pointer(): constructor = value_pointer_cons
	elif t.is_type_fixed(): constructor = value_fixed_cons
	elif t.is_type_float(): constructor = value_float_cons
	elif t.is_type_variant(): constructor = value_variant_cons
	elif t.is_bad(): constructor = value_bad_cons
	else:
		assert False, "unknown type kind '%s'" % t['kind']

	if constructor == None:
		return None

	nv = constructor(t, v, method, ti)
	if nv != None:
		nv.nl = v.nl
	else:
		print(t)
		Type.print(t)
		Type.print(v.type)

	return nv


