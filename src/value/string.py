
from hlir import *
from util import nbits_for_num



def value_string_create(string, ti=None):
	#info("value_string_create %d" % length, ti)
	max_char_width = 8
	for c in string:
		cc = ord(c)
		n = nbits_for_num(cc)
		max_char_width = max(max_char_width, n)

	#string_type = TypeString(max_char_width, len(string), ti)
	string_type = type_string_create(max_char_width, len(string), ti)
	return ValueLiteral(string_type, string, ti)


def value_string_add(l, r, ti):
	asset = l.asset + r.asset
	max_char_width = max(l.type.width, r.type.width)
	#type_result = TypeString(max_char_width, len(asset), ti)
	type_result = type_string_create(max_char_width, len(asset), ti)
	nv = ValueBin(type_result, HLIR_VALUE_OP_ADD, l, r, ti=ti)
	nv.asset = asset
	nv.stage = HLIR_VALUE_STAGE_COMPILETIME
	return nv

