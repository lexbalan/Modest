
import numbers
from fractions import Fraction

from hlir import *
from common import settings
from error import info, warning, error
from util import nbits_for_num



# FixedX хранит число, умноженное на 2^fraction: asset значения с типом
# FixedX это ВСЕГДА сырое хранилище (целое), а не математическое значение.
# Через эту границу переводят ровно две функции ниже, и только они -
# см. docs/lang/type/base.md


# Округление к ближайшему, половина - от нуля.
# Симметрично для отрицательных (в отличие от round(), который
# округляет половину к четному: round(0.5) == 0, round(1.5) == 2)
def round_half_away(q):
	n, d = q.numerator, q.denominator
	if n >= 0:
		return (2 * n + d) // (2 * d)
	return -((-2 * n + d) // (2 * d))


# точное значение -> сырое хранилище FixedX
def fixed_from_number(x, fraction):
	return round_half_away(to_fraction(x) * (1 << fraction))


# сырое хранилище FixedX -> точное значение
def fixed_to_number(a, fraction):
	return Fraction(int(a), 1 << fraction)


# asset бывает Fraction (Rational), int (IntX/NatX/Integer)
# или numpy.floatXX (FloatX); numpy.float32 не наследует float,
# поэтому через float() (!)
def to_fraction(x):
	if isinstance(x, Fraction):
		return x
	if isinstance(x, int):
		return Fraction(x)
	return Fraction(float(x))



def value_fixed_create(val, ti=None):
	#info("value_fixed_create", ti)
	from semantic import cmodule_use
	cmodule_use('use_fixed_point')

	flt_width = int(settings['fixed_width'])
	typ = type_fixed_create(width=flt_width, ti=ti)
	typ.generic = True
	return ValueLiteral(typ, fixed_from_number(val, typ.fraction), ti)



def value_fixed_can(to, from_type, method, ti):
	if from_type.is_generic():
		return from_type.is_int() or from_type.is_fixed() or from_type.is_integer() or from_type.is_rational()

	if method == 'implicit':
		return False

	c0 = from_type.is_rational()
	c1 = from_type.is_integer()
	c2 = from_type.is_int()
	c3 = from_type.is_nat()
	c4 = from_type.is_fixed()
	c5 = from_type.is_word() and (method == 'unsafe')
	c6 = from_type.is_float()
	return c0 or c1 or c2 or c3 or c4 or c5 or c6



# Значение уже известно на этапе компиляции - считаем хранилище сразу
def fixed_cons_immediate(t, v, ti):
	from_type = v.type

	if from_type.is_word():
		# unsafe WordX: сырое хранилище как есть, масштаб не трогаем
		return v.asset

	if from_type.is_fixed():
		# перенос двоичной точки между разными @fraction
		a = fixed_from_number(fixed_to_number(v.asset, from_type.fraction), t.fraction)
	else:
		a = fixed_from_number(v.asset, t.fraction)

	if nbits_for_num(a, signed=True) > t.width:
		error("fixed point overflow", ti)
		info("value does not fit into '%s' with %d fraction bits" % (t.to_str(), t.fraction), ti)

	return a



def value_fixed_cons(t, v, method, ti):
	#info("value_fixed_cons", ti)
	from semantic import cmodule_use
	cmodule_use('use_fixed_point')
	nv = ValueCons(t, t, v, method, ti=ti)

	# numbers.Real покрывает int / Fraction / numpy.floatXX разом,
	# и отсекает asset у ValueDefault ('<default>') и агрегатов (list)
	if v.is_immediate() and isinstance(v.asset, numbers.Real):
		nv.set_asset(fixed_cons_immediate(t, v, ti))
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv

	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv
