
from hlir import *
from common import settings
from error import info, warning, error



def value_float_create(val, ti=None):
	#info("value_float_create", ti)
	flt_width = int(settings['float_width'])
	typ = type_float_create(width=flt_width, ti=ti)
	typ.generic = True
	return ValueLiteral(typ, val, ti)



def value_float_can(to, from_type, method, ti):
	if from_type.is_generic():
		return from_type.is_type_int() or from_type.is_type_float() or from_type.is_type_integer() or from_type.is_type_rational()

	if method == 'implicit':
		return False

	c0 = from_type.is_type_rational()
	c1 = from_type.is_type_int()
	c2 = from_type.is_type_nat()
	c3 = from_type.is_type_float()
	c4 = from_type.is_type_fixed()
	c5 = from_type.is_type_word() and (method == 'unsafe')
	return c0 or c1 or c2 or c3 or c4 or c5



def value_float_cons(t, v, method, ti):
	assert(t.is_type_float())
	nv = ValueCons(t, t, v, method, ti=ti)
	if v.isValueImmediate():
		nv.set_asset(v.asset)
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv
	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv



