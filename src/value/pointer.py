
from error import info, warning, error
import type as type
from hlir.type import Type
from hlir.value import ValueCons
from .char import utf32_chars_to_utfx_chars


def pointer_can(to, from_type, method, ti):
	# implicit region
	assert(to.is_pointer())

	if method == 'unsafe':
		if from_type.is_pointer() or from_type.is_integer() or from_type.is_number():
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
		if from_type.to.is_closed_array() and to.to.is_open_array():
			return Type.eq(from_type.to.of, to.to.of)


	if method == 'implicit':
		return False

	if from_type.is_free_pointer():
		return True  # cons *X from FreePointer

	if method == 'explicit':
		return False

	# unsafe region

	if from_type.is_pointer():
		return True  # Ptr -> Ptr

	return False



def value_pointer_cons(t, v, method, ti):
	if v.isImmediate():
		if v.type.is_string():
			s_imm = utf32_chars_to_utfx_chars(v.asset, t.to.of, ti)
			nv = ValueCons(t, v, method, ti=ti)
			nv.asset = s_imm
			nv.addAttribute('zstring')

			# регистрируем строку в модуле
			from trans import module_strings_add
			module_strings_add(nv)

			return nv
		from .cons import value_cons_immediate
		return value_cons_immediate(t, v, method, ti)

	return ValueCons(t, v, method, ti=ti)


