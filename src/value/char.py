
from hlir import *
from error import info, warning, error
from util import nbits_for_num
from unicode import utf32_chars_to_utfx_cc



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
		return from_type.width <= to.width #and from_type.length == 1

	if method == 'implicit':
		return False

	c0 = from_type.is_char()
	c1 = from_type.is_integer()
	c2 = from_type.is_word()

	if c0 or c1 or c2:
		return from_type.width <= to.width

	return False


def value_char_cons(t, v, method, ti):
	# String -> Char
	# ex: var c: Char8 = "A"
	nv = ValueCons(t, t, v, method, ti=ti)

	if v.type.is_string():
		c = '\0'
		if len(v.asset) == 1:
			c = v.asset[0]
		else:
			error("cannot construct %s value from String with length != 1" % t.to_str(), ti)
		nv.set_asset(ord(c))  # char code
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv

	if v.isValueImmediate():
		nv.set_asset(v.asset)
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv

	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv



def utf32_chars_to_utfx_char_values(str_asset, char_type, ti):
	char_codes = utf32_chars_to_utfx_cc(str_asset, char_type.width)
	# List[char_code] -> List[value_char]
	char_values = []
	for cc in char_codes:
		char_value = value_char_create(cc, char_type, ti)
		char_values.append(char_value)
	return char_values

