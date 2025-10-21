
from error import info, warning, error
import type as type
from hlir.value import ValueLiteral, ValueCons

import foundation


def value_bool_create(val, ti=None):
	v = ValueLiteral(foundation.typeBool, val, ti)
	v.immediate = True
	return v


def bool_can(to, from_type, method, ti):
	return False


def value_bool_cons(t, v, method, ti):
	return ValueBad(ti)



