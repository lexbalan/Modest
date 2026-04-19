
from hlir import *
from error import info, error
from util import nbits_for_num
from fractions import Fraction
from hlir.defs import type_rational_create



def value_rational_create(x, ti=None):
	t = type_rational_create(ti=ti)
	v = ValueLiteral(t, asset=Fraction(x), ti=ti)
	return v


def rational_can(to, from_type, method, ti):
	return from_type.is_integer() or from_type.is_rational()


def value_rational_cons(t, v, method, ti):
	#info("value_rational_cons", ti)
	nv = ValueCons(t, t, v, method, ti=ti)
	nv.set_asset(v.asset)
	return nv


