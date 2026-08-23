
from hlir import *
from error import info, warning, error
from util import nbits_for_num, int_zext
from .fixed import fixed_to_number


# FixedX -> целое: снимаем масштаб с усечением к нулю,
# как обычное приведение дробного к целому (и как __fixedX_to_intX)
def fixed_to_int(v):
	return int(fixed_to_number(v.asset, v.type.fraction))



def value_int_can(to, from_type, method, ti):
	if from_type.is_integer():
		return from_type.width <= to.width

	if method == 'implicit':
		return False

	# explicit or unsafe cons method

	if from_type.is_float():
		return True

	c0 = from_type.is_integer()
	c1 = from_type.is_int()
	c2 = from_type.is_nat()
	c3 = from_type.is_word()
	c4 = from_type.is_float()
	c5 = from_type.is_fixed()
	c6 = from_type.is_rational()

	if c0 or c1 or c2 or c3 or c4 or c5 or c6:
		if method == 'unsafe':
			return True
		return to.width >= from_type.width

	if method != 'unsafe':
		return False

	if from_type.is_pointer():
		from common import settings
		return to.width >= int(settings['pointer_width'])

	return False



def value_int_cons(t, v, method, ti):
	#info("value_integer_cons()", ti)

	from_width = v.type.width
	to_width = t.width

	if v.is_immediate() and v.type.is_float():
		from_width = nbits_for_num(int(v.value))

	if method != 'unsafe':
		if from_width > to_width:
			error("integer overflow", ti)
			info("attempt to construct `%s` from `%s`" % (t.to_str(), v.type.to_str()), ti)

	nv = ValueCons(t, t, v, method, ti=ti)
	if v.is_immediate():
		a = fixed_to_int(v) if v.type.is_fixed() else int(v.asset)
		nv.set_asset(a)
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv

	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv


