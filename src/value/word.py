
from hlir import *
from error import info, warning, error
from util import nbits_for_num, int_zext



def value_word_create(num, ti=None):
	required_width = nbits_for_num(num)
	t = type_word_create(required_width, ti=ti)
	t.generic = True
	v = ValueLiteral(t, asset=num, ti=ti)
	return v


def word_can(to, from_type, method, ti):
	if from_type.is_type_integer():
		return from_type.width <= to.width

	if from_type.is_type_generic_word():
		return from_type.width <= to.width

	if method == 'implicit':
		return False

	c0 = from_type.is_type_integer()
	c1 = from_type.is_type_word()
	c2 = from_type.is_type_int()
	c3 = from_type.is_type_char()
	c4 = from_type.is_type_bool()
	c5 = from_type.is_type_pointer()
	c6 = from_type.is_type_float()
	c7 = from_type.is_type_nat()
	c8 = from_type.is_type_fixed()

	if c0 or c1 or c2 or c3 or c4 or c5 or c6 or c7 or c8:
		if from_type.width <= to.width:
			return True
		return method == 'unsafe'

	return False


def value_word_cons(t, v, method, ti):
	nv = ValueCons(t, t, v, method, ti=ti)
	if v.isValueImmediate():
		if method == 'implicit':
			if v.type.width > t.width:
				error("word overflow", ti)

		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		nv.set_asset(v.asset)
		if v.type.is_signed():
			nv.set_asset(int_zext(v.asset, v.type.width, t.width))
		return nv

	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	nv.rawMode = v.type.is_type_float()
	return nv


