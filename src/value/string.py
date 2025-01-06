
from .value import ValueLiteral, ValueBin
from util import nbits_for_num
from type import type_string



def value_string_create(string, ti=None):
	#info("value_string_create %d" % length, ti)
	max_char_width = 8
	for c in string:
		cc = ord(c)
		n = nbits_for_num(cc)
		max_char_width = max(max_char_width, n)

	string_type = type_string(max_char_width, len(string), ti)
	nv = ValueLiteral(string_type, ti)
	nv.asset = string
	nv.immediate = True
	return nv


def value_string_add(l, r, ti):
	asset = l.asset + r.asset
	max_char_width = max(l.type['width'], r.type['width'])
	type_result = type_string(max_char_width, len(asset), ti)
	nv = ValueBin('add', l, r, type_result, ti=ti)
	nv.asset = asset
	nv.immediate = True
	return nv

