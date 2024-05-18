
from .value import value_terminal
from util import nbits_for_num
from hlir.type import hlir_type_string
from .value import value_bin


def value_string_create(string, ti=None):
	#info("value_string_create %d" % length, ti)
	max_char_width = 8
	for c in string:
		cc = ord(c)
		n = nbits_for_num(cc)
		max_char_width = max(max_char_width, n)

	string_type = hlir_type_string(max_char_width, ti)
	nv = value_terminal(string_type, string, ti)
	nv['immediate'] = True
	return nv

