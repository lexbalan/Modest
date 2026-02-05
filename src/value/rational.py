
from hlir import *
from error import info, error
import type as htype
from util import nbits_for_num
from value.value import value_imm_literal_create
from decimal import Decimal


def value_rational_create(x, ti=None):
	t = htype.type_rational_create(ti=ti)
	v = value_imm_literal_create(t, asset=Decimal(x), ti=ti)
	return v


def rational_can(to, from_type, method, ti):
	return from_type.is_integer() or from_type.is_rational()


def value_rational_cons(t, v, method, ti):
	#info("value_rational_cons", ti)
	from_type = v.type
	if rational_can(t, from_type, method, ti):
		nv = ValueCons(t, v, method, ti=ti)
		nv.stage = v.stage
		nv.asset = v.asset
		return nv
	return None


