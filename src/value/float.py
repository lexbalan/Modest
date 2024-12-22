
import settings
import decimal
from error import info, warning, error
import type as type
from type import type_float
from .value import value_is_immediate, value_terminal, value_cons_node, value_cons_immediate



def value_float_create(num, ti=None):
	#info("value_float_create", ti)
	flt_width = int(settings.get('float_width'))
	typ = type_float(width=flt_width, ti=ti)
	typ['generic'] = True
	v = value_terminal(typ, ti)
	v['asset'] = num
	v['immediate'] = True
	return v


def _value_float_cons_immediate(t, v, method, ti):
	#info("_value_float_cons_immediate", ti)
	nv = value_cons_immediate(t, v, method, ti)
	nv['asset'] = decimal.Decimal(nv['asset'])
	nv['immediate'] = True
	return nv



def float_can(to, from_type, method):
	if type.type_is_generic(from_type):
		return type.type_is_integer(from_type) or type.type_is_float(from_type) or type.type_is_number(from_type)

	if method == 'implicit':
		return False

	if type.type_is_integer(from_type):
		return True
	elif type.type_is_float(from_type):
		return True

	return False



def value_float_cons(t, v, method, ti):
	if value_is_immediate(v):
		return _value_float_cons_immediate(t, v, method, ti)
	return value_cons_node(t, v, method, ti=ti)


