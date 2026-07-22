
from hlir import *
from error import info, warning, error
from util import nbits_for_num, int_zext



def value_int_can(to, from_type, method, ti):
	if Type.is_type_integer(from_type):
		return from_type.width <= to.width

	if method == 'implicit':
		return False

	# explicit or unsafe cons method

	if Type.is_type_float(from_type):
		return True

	c0 = Type.is_type_integer(from_type)
	c1 = Type.is_type_int(from_type)
	c2 = Type.is_type_nat(from_type)
	c3 = Type.is_type_word(from_type)
	c4 = Type.is_type_float(from_type)
	c5 = Type.is_type_fixed(from_type)
	c6 = Type.is_type_rational(from_type)

	if c0 or c1 or c2 or c3 or c4 or c5 or c6:
		if method == 'unsafe':
			return True
		return to.width >= from_type.width

	if method != 'unsafe':
		return False

	if Type.is_type_pointer(from_type):
		from common import settings
		return to.width >= int(settings['pointer_width'])

	return False



def value_int_cons(t, v, method, ti):
	#info("value_integer_cons()", ti)

	from_width = v.type.width
	to_width = t.width

	if Type.is_type_float(v.type) and v.isValueImmediate():
		from_width = nbits_for_num(int(v.value))

	if method != 'unsafe':
		if from_width > to_width:
			error("integer overflow", ti)
			info("attempt to construct `%s` from `%s`" % (t.to_str(), v.type.to_str()), ti)

	nv = ValueCons(t, t, v, method, ti=ti)
	if v.isValueImmediate():
		a = int(v.asset)
		nv.set_asset(a)
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv

	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv


