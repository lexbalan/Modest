
from error import info, warning, error
import hlir.type as type
from util import nbits_for_num
from .value import value_terminal, value_cons_node, value_cons_immediate
from unicode import utf32_str_to_utfx_char_codes


def value_char_create(char_code, _type=None, ti=None):
	if _type == None:
		# if type not specified, set type as GenericChar
		char_width = nbits_for_num(char_code)
		_type = type.hlir_type_char(char_width, ti=ti)
		_type['generic'] = True

	return value_terminal(_type, char_code, ti)



def _value_char_cons_immediate(t, v, method, ti):
	if v['type']['width'] > t['width']:
		info("char overflow", ti)

	return value_cons_immediate(t, v, method, ti)



def _do_cons_char(t, v, method, ti):
	from value.value import value_is_immediate
	if value_is_immediate(v):
		return _value_char_cons_immediate(t, v, method, ti)
	return value_cons_node(t, v, method, ti=ti)



def value_char_cons(t, v, method, ti):
	from_type = v['type']

	# String -> Char
	# ex: var c: Char8 = "A"
	if type.type_is_string(from_type):
		if len(v['asset']) == 1:
			cc = ord(v['asset'][0])
			nv = value_cons_immediate(t, v, method, ti)
			nv['asset'] = cc
			return nv


	# implicit casts
	if type.type_is_generic_char(from_type):
		return _value_char_cons_immediate(t, v, method, ti)


	# explicit casts
	if method != 'explicit':
		info("cannot implicitly cons Char value", ti)
		return None


	# Char -> Char
	if type.type_is_char(from_type):
		return _do_cons_char(t, v, 'explicit', ti)

	# Integer -> Char
	elif type.type_is_integer(from_type):
		return _do_cons_char(t, v, 'explicit', ti)

	# VA_List -> Char
	elif type.type_is_va_list(from_type):
		return value_cons_node(t, v, 'explicit', ti)

	return None




def utf32_chars_to_utfx_chars(str_asset, char_type, ti):
	char_codes = utf32_str_to_utfx_char_codes(str_asset, char_type['width'])

	chars = []
	for cc in char_codes:
		char = value_char_create(cc, char_type, ti)
		chars.append(char)

	return chars

