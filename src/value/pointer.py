
from error import info, warning, error
import type as type
from hlir.type import Type
from hlir.value import ValueCons
from .char import utf32_chars_to_utfx_chars
#from .array import array_can


def array_can2(a, b):
	if a.is_open_array() and b.is_closed_array():
		return array_can2(a.of, b.of)
	elif a.is_pointer() and b.is_pointer():
		return array_can2(a.to, b.to)

	return Type.eq(a, b)


def pointer_can(to, from_type, method, ti):
	# implicit region
	assert(to.is_pointer())

	if method == 'unsafe':
		if from_type.is_pointer() or from_type.is_int() or from_type.is_num():
			# UNSAFE: cons ANY pointer from ANY pointer or integer
			return True

	# String -> *[]CharX
	if from_type.is_string():
		return to.is_pointer_to_array_of_char()

	if from_type.is_pointer():
		# implicit cons pointer from another pointer
		if from_type.is_generic():
			return True  # cons *X from Nil

		if to.is_free_pointer():
			return True  # cons FreePointer from *X

		# cons *[]X from *[n]X +
		if to.to.is_open_array() and from_type.to.is_closed_array():
			return array_can2(to.to, from_type.to)



	if method == 'implicit':
		return False

	if from_type.is_free_pointer():
		return True  # cons *X from FreePointer

	# cons *[n]X from *[]X
	if to.is_pointer() and from_type.is_pointer():
		if to.to.is_closed_array() and from_type.to.is_open_array():
			return array_can2(from_type.to, to.to)
			#return True

	if method == 'explicit':
		return False

	# unsafe region

	if from_type.is_pointer():
		return True  # Ptr -> Ptr

	if from_type.is_word():
		return True  # Word -> Ptr

	return False



def value_pointer_cons(t, v, method, ti):
	if v.isImmediate():
		if v.type.is_string():
			s_imm = utf32_chars_to_utfx_chars(v.asset, t.to.of, ti)
			nv = ValueCons(t, v, method, ti=ti)
			nv.asset = s_imm
			nv.addAttribute('zstring')

			# регистрируем строку в модуле
			from trans import cmodule_strings_add
			cmodule_strings_add(nv)

			return nv
		from .cons import value_cons_immediate
		return value_cons_immediate(t, v, method, ti)

	return ValueCons(t, v, method, ti=ti)


