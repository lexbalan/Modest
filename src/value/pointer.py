
from error import info, warning, error
import hlir.type as type
from .value import value_cons_node, value_is_immediate, value_cons_immediate
from .char import utf32_chars_to_utfx_chars


def cons_ptr_to_str_from_string(t, v, method, ti):
	#info("cons_ptr_to_str_from_string", ti)
	from trans import module_strings_add

	s_imm = utf32_chars_to_utfx_chars(v['asset'], t['to']['of'], ti)

	# получаем список кодов чаров для строки в целевой кодировке
	# из списка чар кодов в utf-32
	#s_imm = method(v['asset'])
	# массив кодов
	# длина полученной строки может отличаться от длины оригинала в utf-32
	# именно value_cons_node чтобы не пошел как immediate! тк *StrX это не immed
	nv = value_cons_node(t, v, method, ti=ti)
	nv['asset'] = s_imm
	# 'zstring' означает что строка должна быть нуль-терминирована
	# TODO: хотя - может это стоит переложить на бекенд? надо подумать
	nv['att'].append('zstring')
	module_strings_add(nv)
	return nv



def _value_pointer_cons_immediate(t, v, method, ti):
	#info("_value_pointer_cons_immediate", ti)
	if type.type_is_string(v['type']):
		return cons_ptr_to_str_from_string(t, v, method, ti)

	return value_cons_immediate(t, v, method, ti)



def width_ok(to, from_type, method):
	if method == 'unsafe':
		return True
	return from_type['width'] != to['width']



def pointer_can(to, from_type, method):
	if type.type_is_free_pointer(from_type):
		return True  # cons *X from Nil

	if type.type_is_pointer(from_type):
		# implicit cons pointer from another pointer

		if type.type_is_free_pointer(to):
			return True  # cons FreePointer from *X

		# cons *[]X from *[n]X +
		if type.type_is_pointer_to_defined_array(from_type) and type.type_is_pointer_to_undefined_array(to):
			if method == 'unsafe':
				return True  #! *[]X from *[n]Y !
			return type.type_eq(from_type['to']['of'], to['to']['of'])

	else:
		# implicit cons pointer from non-pointer
		# "string" -> *[]CharX
		if type.type_is_string(from_type):
			return type.type_is_pointer_to_array_of_char(to)


	if method == 'implicit':
		return False

	if method == 'explicit':
		return False

	# unsafe region

	if type.type_is_pointer(from_type):
		return True  # Ptr -> Ptr
	elif type.type_is_integer(from_type):
		return width_ok(to, from_type, method)  # Int -> Ptr

	return False



def value_pointer_cons(t, v, method, ti):
	if value_is_immediate(v):
		return _value_pointer_cons_immediate(t, v, method, ti)
	return value_cons_node(t, v, method, ti=ti)


