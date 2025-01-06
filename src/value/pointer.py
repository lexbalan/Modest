
from error import info, warning, error
import type as type
from .value import ValueCons, value_is_immediate, value_cons_immediate
from .char import utf32_chars_to_utfx_chars



def pointer_can(to, from_type, method):
	# implicit region
	assert(type.type_is_pointer(to))

	if method == 'unsafe':
		if type.type_is_pointer(from_type) or type.type_is_integer(from_type) or type.type_is_number(from_type):
			# UNSAFE: cons ANY pointer from ANY pointer or integer
			return True

	# String -> *[]CharX
	if type.type_is_string(from_type):
		return type.type_is_pointer_to_array_of_char(to)

	if type.type_is_pointer(from_type):
		# implicit cons pointer from another pointer
		if type.type_is_generic(from_type):
			return True  # cons *X from Nil

		if type.type_is_free_pointer(to):
			return True  # cons FreePointer from *X

		# cons *[]X from *[n]X +
		if type.type_is_closed_array(from_type['to']) and type.type_is_open_array(to['to']):
			return type.type_eq(from_type['to']['of'], to['to']['of'])


	if method == 'implicit':
		return False

	if type.type_is_free_pointer(from_type):
		return True  # cons *X from FreePointer

	if method == 'explicit':
		return False

	# unsafe region

	if type.type_is_pointer(from_type):
		return True  # Ptr -> Ptr

	return False



def value_pointer_cons(t, v, method, ti):
	if value_is_immediate(v):
		if type.type_is_string(v.type):
			s_imm = utf32_chars_to_utfx_chars(v.asset, t['to']['of'], ti)
			nv = ValueCons(t, v, method, ti=ti)
			nv.asset = s_imm
			nv.att.append('zstring')

			# регистрируем строку в модуле
			from trans import module_strings_add
			module_strings_add(nv)

			return nv

		return value_cons_immediate(t, v, method, ti)

	return ValueCons(t, v, method, ti=ti)


