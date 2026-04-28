
from hlir import *
from error import info, warning, error


def value_bool_create(val, ti=None):
	return ValueLiteral(typeBool, val, ti)


def bool_can(to, from_type, method, ti):
	#info("bool_can", ti)
	return from_type.is_bool()


def value_bool_cons(t, v, method, ti):
	#info("value_bool_cons", ti)
	nv = ValueCons(t, t, v, method, ti=ti)
	nv.set_asset(v.asset)
	return nv



