
from error import info, warning, error
import type as type
from util import nbits_for_num
from .value import value_terminal, value_cons_node, value_cons_immediate
from unicode import utf32_str_to_utfx_char_codes


def value_char_create(char_code, _type=None, ti=None):
	if _type == None:
		# if type not specified, set type as GenericChar
		char_width = nbits_for_num(char_code)
		_type = type.type_char(char_width, ti=ti)
		_type['generic'] = True

	v = value_terminal(_type, ti)
	v.asset = char_code
	return v



def char_can(to, from_type, method):
	if method == 'unsafe':
		return True

	if type.type_is_string(from_type):
		return from_type['length'] == 1 and from_type['width'] <= to['width']

	if method == 'implicit':
		return False

	c = type.type_is_number(from_type)
	c0 = type.type_is_char(from_type)
	c1 = type.type_is_integer(from_type)
	c2 = type.type_is_word(from_type)

	if c or c0 or c1 or c2:
		return from_type['width'] <= to['width']


	return False



def value_char_cons(t, v, method, ti):
	from value.value import value_is_immediate

	# String -> Char
	# ex: var c: Char8 = "A"
	if type.type_is_string(v.type):
		#if v.type['length'] == 1:
		cc = ord(v.asset[0])
		nv = value_cons_immediate(t, v, method, ti)
		nv.immediate = True
		nv.asset = cc
		return nv


	if value_is_immediate(v):
		return value_cons_immediate(t, v, method, ti)

	return value_cons_node(t, v, method, ti=ti)



def utf32_chars_to_utfx_chars(str_asset, char_type, ti):
	char_codes = utf32_str_to_utfx_char_codes(str_asset, char_type['width'])
	# [char_code] -> [value_char]
	chars = []
	for cc in char_codes:
		char = value_char_create(cc, char_type, ti)
		chars.append(char)
	return chars

