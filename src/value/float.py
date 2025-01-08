
import settings
import decimal
from error import info, warning, error
import type as type
from type import TypeFloat
from .value import ValueLiteral, ValueCons, value_cons_immediate



def value_float_create(num, ti=None):
	#info("value_float_create", ti)
	flt_width = int(settings.get('float_width'))
	typ = TypeFloat(width=flt_width, ti=ti)
	typ.generic = True
	v = ValueLiteral(typ, ti)
	v.asset = num
	v.immediate = True
	return v


def _value_float_cons_immediate(t, v, method, ti):
	#info("_value_float_cons_immediate", ti)
	nv = value_cons_immediate(t, v, method, ti)
	nv.asset = decimal.Decimal(nv.asset)
	nv.immediate = True
	return nv



def float_can(to, from_type, method, ti):
	if from_type.is_generic():
		return from_type.is_integer() or from_type.is_float() or from_type.is_number()

	if method == 'implicit':
		return False

	if from_type.is_integer():
		return True
	elif from_type.is_float():
		return True

	return False



def value_float_cons(t, v, method, ti):
	if v.isImmediate():
		return _value_float_cons_immediate(t, v, method, ti)
	return ValueCons(t, v, method, ti=ti)


