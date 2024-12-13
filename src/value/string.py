
from .value import value_terminal, value_bin
from util import nbits_for_num
from hlir.type import hlir_type_string



def value_string_create(string, ti=None):
	#info("value_string_create %d" % length, ti)
	max_char_width = 8
	for c in string:
		cc = ord(c)
		n = nbits_for_num(cc)
		max_char_width = max(max_char_width, n)

	string_type = hlir_type_string(max_char_width, len(string), ti)
	nv = value_terminal(string_type, ti)
	nv['asset'] = string
	nv['immediate'] = True
	return nv


def value_string_add(l, r, ti):
	asset = l['asset'] + r['asset']
	max_char_width = max(l['type']['width'], r['type']['width'])
	type_result = hlir_type_string(max_char_width, len(asset), ti)
	nv = value_bin('add', l, r, type_result, ti=ti)
	nv['asset'] = asset
	nv['immediate'] = True
	return nv

