
from hlir import *
from common import settings
from error import info, warning, error



def value_fixed_create(val, ti=None):
	#info("value_fixed_create", ti)
	from semantic import cmodule_use
	cmodule_use('use_fixed_point')

	flt_width = int(settings['fixed_width'])
	typ = type_fixed_create(width=flt_width, ti=ti)
	typ.generic = True
	return ValueLiteral(typ, val, ti)



def value_fixed_can(to, from_type, method, ti):
	if from_type.is_generic():
		return from_type.is_type_int() or from_type.is_type_fixed() or from_type.is_type_integer() or from_type.is_type_rational()

	if method == 'implicit':
		return False

	c0 = from_type.is_type_rational()
	c1 = from_type.is_type_integer()
	c2 = from_type.is_type_int()
	c3 = from_type.is_type_nat()
	c4 = from_type.is_type_fixed()
	c5 = from_type.is_type_word() and (method == 'unsafe')
	return c0 or c1 or c2 or c3 or c4 or c5



def value_fixed_cons(t, v, method, ti):
	#info("value_fixed_cons", ti)
	from semantic import cmodule_use
	cmodule_use('use_fixed_point')
	nv = ValueCons(t, t, v, method, ti=ti)

	if v.isValueImmediate():
		a = v.asset
		# TODO
		#a = 1
		#nv.set_asset(a)
		nv.asset = 1
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv

	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv



