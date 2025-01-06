
from error import info, warning, error
import type as type
from value.value import value_is_immediate
from .value import value_terminal, value_cons_node, value_cons_immediate

import foundation


def value_bool_create(val, ti=None):
	v = value_terminal(foundation.typeBool, ti)
	v.asset = val
	return v


def bool_can(to, from_type, method):
	return False


def value_bool_cons(t, v, method, ti):
	return value_bad(ti)



