# Целое на целевой машине: разрядности, выравнивание, упаковка.
# Вещественное - в real.py.


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
