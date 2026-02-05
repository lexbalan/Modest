
import decimal

from hlir import *
from common import settings
from util import dec_to_float
from error import info, warning, error
import type as type


"""
def value_float_create(num, ti=None):
	#info("value_float_create", ti)
	flt_width = int(settings['float_width'])
	typ = type_float_create(width=flt_width, ti=ti)
	typ.generic = True
	return ValueLiteral(typ, num, ti)
"""


def _value_float_cons_immediate(t, v, method, ti):
	#info("_value_float_cons_immediate", ti)
	from .cons import value_cons_immediate
	nv = value_cons_immediate(t, v, method, ti)
	if t.is_float():
		# привеодим asset к FloatXX
		a = dec_to_float(nv.asset, t.width)
		if a == None:
			a = dec_to_float(nv.asset, 64)
			warning("float value with width=%d not implemented" % t.width, ti)
		nv.asset = a
	nv.stage = HLIR_VALUE_STAGE_COMPILETIME
	return nv


def float_can(to, from_type, method, ti):
	if from_type.is_generic():
		return from_type.is_int() or from_type.is_float() or from_type.is_integer() or from_type.is_rational()

	if method == 'implicit':
		return False

	c0 = from_type.is_rational()
	c1 = from_type.is_int()
	c2 = from_type.is_nat()
	c3 = from_type.is_float()
	c4 = from_type.is_word() and (method == 'unsafe')

	return c0 or c1 or c2 or c3 or c4



def value_float_cons(t, v, method, ti):
	if v.isValueImmediate():
		return _value_float_cons_immediate(t, v, method, ti)
	nv = ValueCons(t, v, method, ti=ti)
	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv



