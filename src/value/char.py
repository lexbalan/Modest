
from hlir import *
from error import info, warning, error
from util import nbits_for_num
from unicode import utf32_str_to_utfx_char_codes
import type


def value_char_create(char_code, _type=None, ti=None):
	if _type == None:
		# if type not specified, set type as GenericChar
		char_width = nbits_for_num(char_code)
		_type = type.type_char(char_width, ti=ti)
		_type.generic = True

	return ValueLiteral(_type, char_code, ti)



def char_can(to, from_type, method, ti):
	if method == 'unsafe':
		return True

	if from_type.is_string():
		return from_type.length == 1 and from_type.width <= to.width

	if method == 'implicit':
		return False

	c0 = from_type.is_char()
	c1 = from_type.is_number()
	c2 = from_type.is_word()

	if c0 or c1 or c2:
		return from_type.width <= to.width


	return False



def value_char_cons(t, v, method, ti):
	from .cons import value_cons_immediate
	# String -> Char
	# ex: var c: Char8 = "A"
	if v.type.is_string():
		cc = ord(v.asset[0])
		nv = value_cons_immediate(t, v, method, ti)
		nv.asset = cc
		return nv

	if v.isValueImmediate():
		return value_cons_immediate(t, v, method, ti)

	nv = ValueCons(t, v, method, rawMode=False, ti=ti)
	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv



def utf32_chars_to_utfx_chars(str_asset, char_type, ti):
	char_codes = utf32_str_to_utfx_char_codes(str_asset, char_type.width)
	# [char_code] -> [value_char]
	chars = []
	for cc in char_codes:
		char = value_char_create(cc, char_type, ti)
		chars.append(char)
	return chars

