
from hlir import *
from error import error
import type as htype
from util import nbits_for_num
from value.value import value_imm_literal_create


def value_number_create(num, ti=None):
	#signed = HLIR_TYPE_SIGNEDNESS_UNSIGNED
	#if num < 0:
	#	signed = HLIR_TYPE_SIGNEDNESS_SIGNED
	t = htype.type_number_for(num, ti=ti)
	v = value_imm_literal_create(t, asset=num, ti=ti)
	return v


def number_can(to, from_type, method, ti):
	return from_type.is_number()


def value_number_cons(t, v, method, ti):
	from_type = v.type
	if number_can(t, from_type, method, ti):
		nv = ValueCons(t, v, method, rawMode=False, ti=ti)
		nv.stage = v.stage
		nv.asset = v.asset
		return nv

	return None


