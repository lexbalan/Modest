
from hlir import *
from error import info, warning, error
import type


def value_bool_create(val, ti=None):
	return ValueLiteral(typeBool, val, ti)


def bool_can(to, from_type, method, ti):
	return False


def value_bool_cons(t, v, method, ti):
	return ValueBad(ti)



