
from error import info, warning, error
import type as type
from value.value import value_is_immediate
from .value import value_terminal, value_cons_node, value_cons_immediate

import foundation


def value_bool_create(val, ti=None):
	v = value_terminal(foundation.typeBool, ti)
	v['asset'] = val
	return v


def _value_bool_cons_immediate(t, v, method, ti):
	if v['type']['width'] > t['width']:
		error("bool overflow", ti)

	return value_cons_immediate(t, v, method, ti)



def bool_can(to, from_type, method):
	if method == 'implicit':
		return False

	if type.type_is_integer(from_type):
		return True
	elif type.type_is_word(from_type) and from_type['width'] == 8:
		return True

	return False



def value_bool_cons(t, v, method, ti):
	if value_is_immediate(v):
		return _value_bool_cons_immediate(t, v, method, ti)
	return value_cons_node(t, v, method, ti=ti)


