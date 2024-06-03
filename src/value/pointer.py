
from error import info, warning, error
import hlir.type as type
from .value import value_cons_node, value_is_immediate, value_cons_immediate
from .char import utf32_chars_to_utfx_chars


def _value_pointer_cons_immediate(t, v, method, ti):
	#info("_value_pointer_cons_immediate", ti)
	return value_cons_immediate(t, v, method, ti)



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



def _do_cons_pointer(t, v, method, ti):
	if value_is_immediate(v):
		return _value_pointer_cons_immediate(t, v, method, ti)
	return value_cons_node(t, v, method, ti=ti)




def pointer_can(to, from_type, method):
	return False



def value_pointer_cons(t, v, method, ti):
	vtype = v['type']
	to_type = t

	if type.type_is_pointer(vtype):
		v_pointer_to = vtype['to']

		# Implicit cons pointer from pointer

		from_type = v['type']

		# cons *[]X from *[n]X +
		if type.type_is_pointer_to_defined_array(from_type) and type.type_is_pointer_to_undefined_array(t):
			if type.type_eq(from_type['to']['of'], t['to']['of']):
				return _do_cons_pointer(t, v, method, ti)

		# cons *X from Nil
		if type.type_is_free_pointer(from_type):
			return _do_cons_pointer(t, v, method, ti)

		# cons FreePointer from *X
		if type.type_is_pointer(from_type):
			if type.type_is_free_pointer(t):
				return _do_cons_pointer(t, v, method, ti=ti)


	else:
		# implicit cons pointer from non-pointer value

		if type.type_is_string(vtype):
			if type.type_is_pointer_to_array_of_char(to_type):
				return cons_ptr_to_str_from_string(t, v, method, ti)


	### EXPLICIT REGION ###

	if method == 'implicit':
		info("cannot implicitly cons Pointer value", ti)
		return v

	from main import features
	if not (features.get('unsafe') or features.get('unsafe-int-to-ptr')):
		info("explicit typecast pointer to integer is forbidden in safe mode", ti)
		return None

	### UNSAFE REGION ###

	# Ptr -> Ptr
	if type.type_is_pointer(vtype):
		return _do_cons_pointer(t, v, 'explicit', ti=ti)

	# Int -> Ptr
	elif type.type_is_integer(vtype):
		return _do_cons_pointer(t, v, 'explicit', ti=ti)

	# VA_List -> Ptr
	elif type.type_is_va_list(vtype):
		return value_cons_node(t, v, 'explicit', ti)


	return None




