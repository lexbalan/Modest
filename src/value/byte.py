
from error import info, warning, error
import hlir.type as type
from value.value import value_is_immediate
from .value import value_cons_node, value_cons_immediate


def _value_byte_cons_immediate(t, v, method, ti):
	if v['type']['width'] > t['width']:
		error("byte overflow", ti)

	return value_cons_immediate(t, v, method, ti)



def width_ok(to, from_type, method):
	if method == 'unsafe':
		return True
	return from_type['width'] <= to['width']


def byte_can(to, from_type, method):
	if type.type_is_generic_integer(from_type):
		return width_ok(to, from_type, method)

	if method == 'implicit':
		return False

	if type.type_is_integer(from_type):
		return width_ok(to, from_type, method)

	return False


def value_byte_cons(t, v, method, ti):
	if value_is_immediate(v):
		return _value_byte_cons_immediate(t, v, method, ti)
	return value_cons_node(t, v, method, ti=ti)

