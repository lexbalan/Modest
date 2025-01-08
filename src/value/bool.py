
from error import info, warning, error
import type as type
from .value import ValueLiteral, ValueCons, value_cons_immediate

import foundation


def value_bool_create(val, ti=None):
	v = ValueLiteral(foundation.typeBool, ti)
	v.immediate = True
	v.asset = val
	return v


def bool_can(to, from_type, method, ti):
	return False


def value_bool_cons(t, v, method, ti):
	return ValueBad(ti)



