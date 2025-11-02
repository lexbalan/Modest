
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



def _value_natural_cons_immediate(t, v, method, ti):
	#info("value_cons_int_immediate", ti)
	width = t.width
	need_width = nbits_for_num(v.asset)

	if need_width > width:
		error("natural overflow", ti)

	from .cons import value_cons_immediate
	return value_cons_immediate(t, v, method, ti)



def natural_can(to, from_type, method, ti):
	if Type.is_number(from_type):
		return from_type.width <= to.width

	if method == 'implicit':
		return False

	if Type.is_float(from_type):
		return True

	# explicit or unsafe cons method
	c0 = Type.is_number(from_type)
	c1 = Type.is_nat(from_type)
	c2 = Type.is_word(from_type)
	c3 = Type.is_int(from_type)
	#c2 = Type.is_char(from_type)
	#c4 = Type.is_bool(from_type)
	#if c3:
	#	info("cons Nat from Int", ti)

	if c0 or c1 or c2 or c3:
		if method == 'unsafe':
			return True
		return to.width >= from_type.width

	if method != 'unsafe':
		return False

	if Type.is_pointer(from_type):
		from common import settings
		return to.width >= int(settings['pointer_width'])

	return False



def value_natural_cons(t, v, method, ti):
	#info("value_natural_cons()", ti)
	_check_width(v.type, t, method, ti)

	if v.type.is_signed():
		from trans import cmodule_use
		cmodule_use('use_abs')

	if v.isValueImmediate():
		_check_width(v.type, t, method, ti)
		if method != 'implicit':
			nv = ValueCons(t, v, method, rawMode=False, ti=ti)

			if v.type.is_signed():
				if v.asset < 0:
					nv.asset = -v.asset

			else:
				nv.asset = int(v.asset)  # here can be float

			nv.stage = HLIR_VALUE_STAGE_COMPILETIME
			return nv

		return _value_natural_cons_immediate(t, v, method, ti)

	return ValueCons(t, v, method, rawMode=False, ti=ti)


