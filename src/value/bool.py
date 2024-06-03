
from error import info, warning, error
import hlir.type as type
from value.value import value_is_immediate
from util import nbits_for_num
from .value import value_cons_node, value_cons_immediate
from .integer import value_integer_create

import foundation


def value_bool_create(num):
	return value_integer_create(num, typ=foundation.typeBool)


def _value_bool_cons_immediate(t, v, method, ti):
	if v['type']['width'] > t['width']:
		error("bool overflow", ti)

	return value_cons_immediate(t, v, method, ti)



def _do_cons_bool(t, v, method, ti):
	if value_is_immediate(v):
		return _value_bool_cons_immediate(t, v, method, ti)
	return value_cons_node(t, v, method, ti=ti)



def value_bool_cons(t, v, method, ti):
	from_type = v['type']

	# explicit casts
	if method == 'implicit':
		info("cannot implicitly cons Bool value", ti)
		return None

	# Integer -> Bool
	if type.type_is_integer(from_type):
		return _do_cons_bool(t, v, 'explicit', ti)

	# Byte -> Bool
	elif type.type_is_byte(from_type):
		return _do_cons_bool(t, v, 'explicit', ti)

	# VA_List -> Bool
	elif type.type_is_va_list(from_type):
		return value_cons_node(t, v, 'explicit', ti)

	return None


