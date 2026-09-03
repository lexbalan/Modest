
from hlir import *
from common import settings
from error import info, warning, error
from util import float_max, float_overflows, str_fractional
from .fixed import fixed_to_number



def value_float_create(val, ti=None):
	#info("value_float_create", ti)
	flt_width = int(settings['float_width'])
	typ = type_float_create(width=flt_width, ti=ti)
	typ.generic = True
	return ValueLiteral(typ, val, ti)



def value_float_can(to, from_type, method, ti):
	if from_type.is_generic():
		return from_type.is_int() or from_type.is_float() or from_type.is_integer() or from_type.is_rational()

	if method == 'implicit':
		return False

	c0 = from_type.is_rational()
	c1 = from_type.is_int()
	c2 = from_type.is_nat()
	c3 = from_type.is_float()
	c4 = from_type.is_fixed()
	c5 = from_type.is_word() and (method == 'unsafe')
	return c0 or c1 or c2 or c3 or c4 or c5



def value_float_cons(t, v, method, ti):
	assert(t.is_float())
	nv = ValueCons(t, t, v, method, ti=ti)
	if v.is_immediate():
		a = v.asset
		if v.type.is_fixed():
			# снимаем масштаб: сырое хранилище -> точное значение
			a = fixed_to_number(v.asset, v.type.fraction)

		# то же правило, что у целых (см. value_int_cons): за диапазон типа
		# константа не выходит. В рантайме переполнение дает бесконечность,
		# как велит IEEE 754, но здесь еще есть кому сказать об этом вслух
		if method != 'unsafe' and float_overflows(a, t.width):
			error("float overflow", ti)
			info("`%s` holds at most %s"
				% (t.to_str(), str_fractional(float_max(t.width), 64)), ti)

		nv.set_asset(a)
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv
	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv



