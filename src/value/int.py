
from hlir import *
from error import info, warning, error
from type import type_print
from util import nbits_for_num, int_zext


warning_cast_data_loss = True


def _check_width(from_type, t, method, ti):
	rv = True

	if Type.is_float(from_type):
		return True

	if from_type.width > t.width:
		#info("%s" % method, ti)
		if method != 'unsafe':
			error("value cons with potential data loss", ti)
			rv = False

		elif warning_cast_data_loss:
			from trans import is_unsafe_mode
			if not (is_unsafe_mode() or 'unsafe-downcast' in features):
				warning("value cons with potential data loss", ti)

	if not rv:
		print("attempt to construct ", end='')
		type_print(t)
		print(" from ", end='')
		type_print(from_type)
		print()

	return rv






def int_can(to, from_type, method, ti):
	if Type.is_integer(from_type):
		return from_type.width <= to.width

	if method == 'implicit':
		return False

	# explicit or unsafe cons method

	if Type.is_float(from_type):
		return True

	c0 = Type.is_integer(from_type)
	c1 = Type.is_int(from_type)
	c2 = Type.is_nat(from_type)
	c3 = Type.is_word(from_type)
	c4 = Type.is_float(from_type)
	c5 = Type.is_fixed(from_type)
	c6 = Type.is_rational(from_type)

	if c0 or c1 or c2 or c3 or c4 or c5 or c6:
		if method == 'unsafe':
			return True
		return to.width >= from_type.width

	if method != 'unsafe':
		return False

	if Type.is_pointer(from_type):
		from common import settings
		return to.width >= int(settings['pointer_width'])

	return False



def value_int_cons(t, v, method, ti):
	#info("value_integer_cons()", ti)
	_check_width(v.type, t, method, ti)

	nv = ValueCons(t, v, method, ti=ti)
	if v.isValueImmediate():
		_check_width(v.type, t, method, ti)
		if method != 'implicit':
			if v.asset != None:  # asset can be None in case of undefined value (!)
				##################### ???????? !!!!!! Float, Generic float, need better cast!!!!
				nv.set_asset(int(v.asset))  # here can be float
			nv.stage = HLIR_VALUE_STAGE_COMPILETIME
			return nv
		width = t.width

		need_width = nbits_for_num(v.asset, signed=t.is_signed())

		#info("(%d %d %d)" % (v.asset, need_width, width), ti)
		if need_width > width:
			error("integer overflow", ti)

		nv.set_asset(v.asset)
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv

	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv


