# Вещественное на целевой машине: IEEE 754 и печать литерала.
# Целое - в bits.py.

import math
import struct
from decimal import Decimal
from fractions import Fraction


# width - ширина, в которой напечатанное должно уцелеть. И C, и LLVM читают
# литерал как double, так что дальше 17-й значащей цифры печатать нечего:
# компилятор их все равно отбросит, и длинная запись не точнее, а только выглядит
# точнее. У Rational своего представления там нет, он едет тем же double
# (width=64); точной дробью он остается внутри компилятора.
# width=None - печатать как есть, без привязки к железу (modest-бэкенд).
def str_fractional(x, width=None):
	# у inf и nan десятичной записи нет: страховка, чтобы ни один бэкенд
	# не напечатал из них 'inf.0'. Каждый разбирается с ними до вызова сюда.
	special = float_special(x)
	if special is not None:
		return special

	def str_always_float(s):
		# дробная часть нужна всегда: LLVM без точки прочитает '1e-20'
		# как целое 1 и споткнется на остатке
		mantissa, e, exp = s.partition('e')
		if not '.' in mantissa:
			mantissa += '.0'
		return mantissa + e + exp

	# в голом float ширина FloatX не сохраняется, поэтому кратчайшую запись,
	# которая читается обратно в то же самое значение, ищем сами
	if width is not None:
		val = pack_float(x, width)
		for p in range(1, 18):
			s = '%.*g' % (p, val)
			if pack_float(s, width) == val:
				return str_always_float(s)

	return str_always_float(decimal_to_str(fractional_to_decimal(x)))


# 'inf' | '-inf' | 'nan' - если значение не число, иначе None.
# Десятичной записи у таких значений нет, и каждый бэкенд пишет их по-своему,
# поэтому распознаем их здесь, а печатает каждый сам. У Fraction и int их
# не бывает - только у float.
def float_special(x):
	if not isinstance(x, float):
		return None
	if math.isinf(x):
		return '-inf' if x < 0 else 'inf'
	if math.isnan(x):
		return 'nan'
	return None


# принимает на вход Fraction, Decimal, int, float
# возвращает ближайшее представимое floatX - то, что даст железо
def pack_float(val, width):
	if width <= 16:
		fmt = '<e'
	elif width <= 32:
		fmt = '<f'
	elif width <= 64:
		fmt = '<d'
	else:
		assert False, "Unsupported float width: {}".format(width)

	# железо не бросает исключений: за границей диапазона IEEE 754 дает
	# бесконечность. struct округляет верно вплоть до самого порога
	# (65519.99 -> 65504 для binary16), так что до except доходит ровно то,
	# что переполнилось бы и на железе. То же и у float(): очень большой
	# Fraction не переводится в double, и это тот же самый перелет.
	try:
		f = float(val)
	except OverflowError:
		return math.inf if val > 0 else -math.inf

	try:
		return struct.unpack(fmt, struct.pack(fmt, f))[0]
	except OverflowError:
		return math.copysign(math.inf, f)


# наибольшее конечное значение floatX - им же и заканчивается диапазон,
# следующее по величине уже бесконечность
FLOAT_MAX = {
	16: 65504.0,
	32: 3.4028234663852886e+38,
	64: 1.7976931348623157e+308,
}


def float_max(width):
	for w in sorted(FLOAT_MAX):
		if width <= w:
			return FLOAT_MAX[w]
	assert False, "Unsupported float width: {}".format(width)


# Конечное на входе, бесконечное после округления к ширине - это выход
# за диапазон типа, а не потеря точности: обратно из бесконечности уже
# ничего не достать.
def float_overflows(val, width):
	if val is None or float_special(val) is not None:
		return False
	return math.isinf(pack_float(val, width))


#def unpak_float_to_hex(fval, width):
#	if width == 32:
#		return '0x%X' % (struct.unpack('<i', struct.pack('<f', fval))[0])
#	elif width == 64:
#		return '0x%X' % (struct.unpack('<Q', struct.pack('<d', fval))[0])


def fractional_to_decimal(f):
	# у FloatX asset это float (см. Value.set_asset), у Rational - Fraction
	if isinstance(f, float):
		return Decimal(str(f))
	assert(isinstance(f, Fraction) or isinstance(f, int))
	return Decimal(f.numerator) / Decimal(f.denominator)


def decimal_to_str(d: Decimal, max_frac=None):
	s = format(d, 'f')
	# remove zero tail (only in the fractional part!)
	if '.' in s:
		s = s.rstrip('0')
		if s.endswith('.'):
			s = s + '0'
	return s

