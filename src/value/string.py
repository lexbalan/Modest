
from util import nbits_for_num
from hlir.type import TypeString
from hlir.value import ValueLiteral, ValueBin



def value_string_create(string, ti=None):
	#info("value_string_create %d" % length, ti)
	max_char_width = 8
	for c in string:
		cc = ord(c)
		n = nbits_for_num(cc)
		max_char_width = max(max_char_width, n)

	string_type = TypeString(max_char_width, len(string), ti)
	v = ValueLiteral(string_type, ti)
	v.asset = string
	v.immediate = True
	return v


def value_string_add(l, r, ti):
	asset = l.asset + r.asset
	max_char_width = max(l.type.width, r.type.width)
	type_result = TypeString(max_char_width, len(asset), ti)
	nv = ValueBin(type_result, 'add', l, r, ti=ti)
	nv.asset = asset
	nv.immediate = True
	return nv

