

def align_to(x, y):
	assert(y != 0)

	while x % y != 0:
		x = x + 1

	return x


def nbits_for_num(x):
	n = 1
	if x < 0:
		x = -x
		n = 2

	y = 1
	while x > y:
		y = (y << 1) | 1
		n = n + 1

	return n


# 7 -> 8, 12 -> 16, 17 -> 32, etc.
def align_bits_up(x):
	aligned_bits = 8
	while aligned_bits < x:
		aligned_bits = aligned_bits * 2
	return aligned_bits


# 7 -> 1, 9 -> 2, 17 -> 32, etc.
def nbytes_for_bits(x):
	return align_bits_up(x) // 8


# returns -1 if not found
def get_index_of_item_with_id(_list, id):
	i = 0
	while i < len(_list):
		item = _list[i]
		if item != None:
			if item['id']['str'] == id:
				return i
		i = i + 1
	return -1


def get_item_with_id(_list, id):
	i = get_index_of_item_with_id(_list, id)
	if i < 0:
		return None
	return _list[i]



"""def utf16_to_utf32(c):
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
"""

