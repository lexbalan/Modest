
from error import error
from hlir.value import ValueLiteral, ValueCons
import type as htype
from util import nbits_for_num
from value.value import value_imm_literal_create


def value_number_create(num, ti=None):
	t = htype.type_number_for(num, signed=num < 0, ti=ti)
	v = value_imm_literal_create(t, asset=num, ti=ti)
	return v


def number_can(to, from_type, method, ti):
	return type_is_num(from_type)


def value_number_cons(t, v, method, ti):
	from_type = v.type
	if number_can(t, from_type, method):
		nv = ValueCons(t, v, method, ti=ti)
		nv.immediate = v.immediate
		nv.asset = v.asset
		return nv

	return None


