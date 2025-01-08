
from error import error
from .value import ValueCons


def unit_can(to, from_type, method, ti):
	return method != 'implicit'


def ValueUnit_cons(t, v, method, ti):
	from_type = v.type
	if unit_can(t, from_type, method, ti):
		return ValueCons(t, v, method, ti=ti)

	return None


