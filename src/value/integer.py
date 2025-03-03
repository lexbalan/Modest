
from error import info, warning, error
from util import nbits_for_num
import type as htype
from type import type_print
from hlir.value import ValueLiteral, ValueCons
from hlir.type import Type


def value_integer_create(num, typ=None, ti=None):
	if typ == None:
		typ = htype.type_number_for(num, signed=num < 0, ti=ti)
	else:
		nbits = nbits_for_num(num)

		if nbits > typ.width:
			from error import error
			error("value size not corresponded type size", ti)
			return ValueBad(ti)

	v = ValueLiteral(typ, ti)
	v.asset = num
	v.nsigns = 0
	v.immediate = True
	return v



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
			if not (is_unsafe_mode() or features.get('unsafe-downcast')):
				warning("value cons with potential data loss", ti)

	if not rv:
		print("attempt to construct ", end='')
		type_print(t)
		print(" from ", end='')
		type_print(from_type)
		print()

	return rv



def _value_integer_cons_immediate(t, v, method, ti):
	#info("value_cons_int_immediate", ti)
	width = t.width
	need_width = nbits_for_num(v.asset)

	if need_width > width:
		error("integer overflow", ti)

	from .cons import value_cons_immediate
	return value_cons_immediate(t, v, method, ti)



def integer_can(to, from_type, method, ti):
	if Type.is_number(from_type):
		return from_type.width <= to.width

	if method == 'implicit':
		return False

	if Type.is_float(from_type):
		return True

	# explicit or unsafe cons method
	c = Type.is_number(from_type)
	c0 = Type.is_integer(from_type)
	c1 = Type.is_char(from_type)
	c2 = Type.is_word(from_type)
	c3 = Type.is_bool(from_type)
	if c or c0 or c1 or c2 or c3:
		if method == 'unsafe':
			return True
		return to.width >= from_type.width

	if method != 'unsafe':
		return False

	if Type.is_pointer(from_type):
		from main import settings
		return to.width >= int(settings.get('pointer_width'))

	return False




def value_integer_cons(t, v, method, ti):
	#info("value_integer_cons()", ti)
	_check_width(v.type, t, method, ti)

	if v.isImmediate():
		_check_width(v.type, t, method, ti)

		#if not t.signed:
		#	if v.asset < 0:
		#		return None

		if method != 'implicit':
			nv = ValueCons(t, v, method, ti=ti)
			nv.asset = int(v.asset)  # here can be float
			nv.immediate = True
			return nv
		return _value_integer_cons_immediate(t, v, method, ti)

	return ValueCons(t, v, method, ti=ti)


