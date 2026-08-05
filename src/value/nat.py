
from hlir import *
from error import info, warning, error
from util import nbits_for_num




def value_nat_can(to, from_type, method, ti):
	if from_type.is_integer():
		return True
#		return from_type.width <= to.width

	if method == 'implicit':
		return False

	#if from_type.is_float():
	#	return True

	# explicit or unsafe cons method
	c0 = from_type.is_integer()
	c1 = from_type.is_nat()
	c2 = from_type.is_word()
	c3 = from_type.is_int()
	c4 = from_type.is_float()
	c5 = from_type.is_rational()

	if c0 or c1 or c2 or c3 or c4 or c5:
		if method == 'unsafe':
			return True
		return True
		return to.width >= from_type.width

	if method != 'unsafe':
		return False

	if from_type.is_pointer():
		from common import settings
		return to.width >= int(settings['pointer_width'])

	return False



def value_nat_cons(t, v, method, ti):
	#info("value_nat_cons()", ti)

	from_width = v.type.width
	to_width = t.width

	if v.is_immediate() and v.type.is_float():
		from_width = nbits_for_num(int(v.value))

	if method != 'unsafe':
		if from_width > to_width:
			error("integer overflow", ti)
			info("attempt to construct `%s` from `%s`" % (t.to_str(), v.type.to_str()), ti)

	if v.type.is_signed():
		from semantic import cmodule_use
		cmodule_use('use_abs')

	nv = ValueCons(t, t, v, method, ti=ti)

	if v.is_immediate():
		a = abs(int(v.asset))
		nv.set_asset(a)
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv

	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv


