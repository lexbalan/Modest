
import struct
from decimal import Decimal
from fractions import Fraction


def align_to(x, y):
	assert(y != 0)

	while x % y != 0:
		x = x + 1

	return x


def nbits_for_num(x, signed=False):
	if x == None:
		return 0  # case when we works with asset from value with TypeUndef

	x = int(x)

	i = 0

	if x < 0:
		x = -x
		x -= 1

	while x != 0:
		x = x // 2
		i = i + 1
	if signed:
		i += 1
	return i



# 7 -> 8, 12 -> 16, 17 -> 32, etc.
def align_bits_up(x):
	aligned_bits = 8
	while aligned_bits < x:
		aligned_bits = aligned_bits * 2
	return aligned_bits


# 7 -> 1, 9 -> 2, 17 -> 4, etc.
def nbytes_for_bits(x):
	return align_bits_up(x) // 8





def utf32cc_to_utf8_str(cc):
	# Преобразуем целое число в байты (UTF-32 требует 4 байта)
	utf32_bytes = cc.to_bytes(4, byteorder='little')
	utf8_string = utf32_bytes.decode('utf-32')
	return utf8_string







def int_to_bitstring(x, width):
	return format(x & (2**width - 1), '0%db' % width)

def bitstring_to_int(bitstring, width):
	# Преобразуем строку в число
	number = int(bitstring, 2)

	# Если старший бит равен 1, то число отрицательное
	if bitstring[0] == '1':
		number -= (1 << width)

	return number


# Получает int и расширяет его битовое представление нулями
# с width_from до width_to
def int_zext(x, width_from, width_to):
	bitstring = int_to_bitstring(x, width_from)
	# extend bitstring with zeros
	if width_to > width_from:
		pad = width_to - width_from
		bitstring = "0" * pad + bitstring
	#else:
	return bitstring_to_int(bitstring, width_to)





def str_always_float(s):
	if not '.' in s:
		return s + '.0'
	return s


def str_fractional(x):
	return str_always_float(decimal_to_str(fractional_to_decimal(x)))




def pack_int(value, width, signed=False):
    """
    Эмулирует поведение целых чисел фиксированной разрядности.
    :param value: Исходное число
    :param width: Битность (8, 16, 32, 64, 128, 256 и т.д.)
    :param signed: Флаг знакового числа (True - int, False - uint)
    """
    # 1. Применяем маску для беззнакового переполнения
    # (1 << 8) - 1  => 255 (0xFF)
    # (1 << 128) - 1 => огромная маска из 128 единиц
    mask = (1 << width) - 1
    truncated = value & mask

    if not signed:
        return truncated

    # 2. Логика знакового числа (двухдополнительный код)
    # Проверяем, установлен ли самый левый (знаковый) бит
    msb_check = 1 << (width - 1)

    if truncated >= msb_check:
        # Если бит установлен, превращаем в отрицательное
        return truncated - (1 << width)

    return truncated


## принимает на вход Decimal, int, etc.
## возвращает 32 или 64 битное представление float числа
#def pack_float(val, width):
#	z = None
#	if width <= 16:
#		z = struct.unpack('<e', struct.pack('<e', val))[0]
#	elif width <= 32:
#		z = struct.unpack('<f', struct.pack('<f', val))[0]
#	elif width <= 64:
#		z = struct.unpack('<d', struct.pack('<d', val))[0]
#	return z


#def unpak_float_to_hex(fval, width):
#	if width == 32:
#		return '0x%X' % (struct.unpack('<i', struct.pack('<f', fval))[0])
#	elif width == 64:
#		return '0x%X' % (struct.unpack('<Q', struct.pack('<d', fval))[0])


def fractional_to_decimal(f):
	#print(f.__class__)
	#print(f.numerator)
	#print(f.denominator)
	assert(isinstance(f, Fraction) or isinstance(f, int))
	return Decimal(f.numerator) / Decimal(f.denominator)


def decimal_to_str(d: Decimal, max_frac=None):
	s = format(d, 'f')
	# remove zero tail
	i = len(s) - 1
	while i >= 0:
		if s[i] == '0':
			i -= 1
		else:
			i += 2
			break
	return s[0:i]



"""
def utf16_to_utf32(c):
	leading = c[0]

	if (leading < 0xD800) | (leading > 0xDFFF):
		return  [leading, 1]

	elif leading >= 0xDC00:
		#error("Недопустимая кодовая последовательность.")
		pass
	else:
		code = (leading & 0x3FF) << 10
		trailing = c[1]
		if (trailing < 0xDC00) or (trailing > 0xDFFF):
			#error("Недопустимая кодовая последовательность.")
			pass
		else:
			code = code | (trailing & 0x3FF)
			return [(code + 0x10000), 2]


	return ['', 0]

def _utf8_cc_arr_to_utf32_cc_arr(arr):
	arr = list(bytes(arr).decode('utf-8').encode('utf-32').decode('utf32'))

	res = []
	for c in arr:
		cc = ord(c)
		res.append(cc)

	return res


def _utf16_cc_arr_to_utf32_cc_arr(arr):
	s16 = u""
	for cc in arr:
		s16 = s16 + chr(cc)

	s_list = list(s16.encode('utf-16', 'surrogatepass')[2:].decode('utf-16').encode('utf-32').decode('utf32'))

	res = []
	for c in s_list:
		cc = ord(c)
		res.append(cc)

	return res


# получаем список кодов UTF-32 из кодов utf8/16/32
def utfx_chars_to_utf32_chars(utf32_codes, char_width):
	utf32_codes = []
	if char_width == 8:
		utf32_codes = _utf8_cc_arr_to_utf32_cc_arr(utf32_codes)
	elif char_width == 16:
		utf32_codes = _utf16_cc_arr_to_utf32_cc_arr(utf32_codes)
	return utf32_codes


# принимает массив кодов символов в кодировке utf-32
# возвращает питоновскую строку с этими символами
def utf32_chars_to_string(chars):
	ccodes = []
	for char in chars:
		cc = char.asset
		ccodes.append(chr(cc))
	return ''.join(ccodes)
"""




