
from error import error
from .value import ValueCons
#from type import type_is_number

def number_can(to, from_type, method, ti):
	return type_is_number(from_type)


def value_number_cons(t, v, method, ti):
	from_type = v.type
	if number_can(t, from_type, method):
		nv = ValueCons(t, v, method, ti=ti)
		nv.immediate = v.immediate
		nv.asset = v.asset
		return nv

	return None


