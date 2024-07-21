

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



"""
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
		cc = char['asset']
		ccodes.append(chr(cc))
	return ''.join(ccodes)
"""




