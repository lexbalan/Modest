
from hlir import *
from error import info, warning, error
from util import nbits_for_num


warning_cast_data_loss = True


def _check_width(from_type, t, method, ti):
	rv = True

	if Type.is_float(from_type):
		return True

	if from_type.width > t.width:
		#info("%s" % method, ti)
		if method != 'unsafe':
			warning("value cons with potential data loss", ti)
			rv = False

		elif warning_cast_data_loss:
			from trans import is_unsafe_mode
			if not (is_unsafe_mode() or 'unsafe-downcast' in features):
				warning("value cons with potential data loss", ti)

	if not rv:
		print("attempt to construct ", end='')
		Type.print(t)
		print(" from ", end='')
		Type.print(from_type)
		print()

	return rv



def nat_can(to, from_type, method, ti):
	if Type.is_integer(from_type):
		return True
#		return from_type.width <= to.width

	if method == 'implicit':
		return False

	#if Type.is_float(from_type):
	#	return True

	# explicit or unsafe cons method
	c0 = Type.is_integer(from_type)
	c1 = Type.is_nat(from_type)
	c2 = Type.is_word(from_type)
	c3 = Type.is_int(from_type)
	c4 = Type.is_float(from_type)
	c5 = Type.is_rational(from_type)

	if c0 or c1 or c2 or c3 or c4 or c5:
		if method == 'unsafe':
			return True
		return True
		return to.width >= from_type.width

	if method != 'unsafe':
		return False

	if Type.is_pointer(from_type):
		from common import settings
		return to.width >= int(settings['pointer_width'])

	return False



def value_nat_cons(t, v, method, ti):
	#info("value_nat_cons()", ti)
	_check_width(v.type, t, method, ti)

	if v.type.is_signed():
		from trans import cmodule_use
		cmodule_use('use_abs')

	nv = ValueCons(t, v, method, ti=ti)
	if v.isValueImmediate():
		if method != 'implicit':
			nv.stage = HLIR_VALUE_STAGE_COMPILETIME
			if v.asset != None:  # asset can be None in case of undefined value (!)
				a = abs(int(v.asset))
				nv.set_asset(a)  # here can be float
			return nv

		#info("value_cons_int_immediate", ti)
		width = t.width
		a = abs(int(v.asset))
		need_width = nbits_for_num(a)

		if need_width > width:
			error("natural overflow", ti)

		nv.set_asset(a)
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv

	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv


