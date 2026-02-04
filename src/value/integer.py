
from hlir import *
from error import info, error
import type as htype
from util import nbits_for_num
from value.value import value_imm_literal_create


def value_integer_create(num, ti=None):
	#signed = HLIR_TYPE_SIGNEDNESS_UNSIGNED
	#if num < 0:
	#	signed = HLIR_TYPE_SIGNEDNESS_SIGNED
	t = htype.type_integer_for(num, ti=ti)
	v = value_imm_literal_create(t, asset=num, ti=ti)
	return v


def integer_can(to, from_type, method, ti):
	return from_type.is_integer() or from_type.is_rational()


def value_integer_cons(t, v, method, ti):
	info("value_integer_cons", ti)
	from_type = v.type
	if integer_can(t, from_type, method, ti):
		nv = ValueCons(t, v, method, ti=ti)
		nv.stage = v.stage
		nv.asset = v.asset
		return nv

	return None


