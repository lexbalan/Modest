
from error import info, warning, error
import hlir.type as type
from value.value import value_is_immediate
from .value import value_terminal, value_cons_node, value_cons_immediate

import foundation


def value_bool_create(val, ti=None):
	return value_terminal(foundation.typeBool, val, ti)


def _value_bool_cons_immediate(t, v, method, ti):
	if v['type']['width'] > t['width']:
		error("bool overflow", ti)

	return value_cons_immediate(t, v, method, ti)



def bool_can(to, from_type, method):
	if method == 'implicit':
		return False

	if type.type_is_integer(from_type):
		return True
	elif type.type_is_byte(from_type):
		return True

	return False



def value_bool_cons(t, v, method, ti):
	if value_is_immediate(v):
		return _value_bool_cons_immediate(t, v, method, ti)
	return value_cons_node(t, v, method, ti=ti)


