
from error import error
from .value import value_cons_node


def unit_can(to, from_type, method):
	return method != 'implicit'


def value_unit_cons(t, v, method, ti):
	from_type = v['type']
	if unit_can(t, from_type, method):
		return value_cons_node(t, v, method, ti=ti)

	return None


