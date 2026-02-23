
from hlir import *
from error import info, error
from util import nbits_for_num
from hlir.utils import type_integer_for
from fractions import Fraction



def value_integer_create(num, ti=None):
	t = type_integer_for(Fraction(num), ti=ti)
	v = ValueLiteral(t, asset=num, ti=ti)
	return v


def integer_can(to, from_type, method, ti):
	return from_type.is_integer() or from_type.is_rational()


def value_integer_cons(t, v, method, ti):
	#info("value_integer_cons", ti)
	nv = ValueCons(t, v, method, ti=ti)
	nv.stage = v.stage
	nv.set_asset(int(v.asset))
	return nv


