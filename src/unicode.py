
# Array[chars] -> Array[CharCode]
def utf32_chars_to_utfx_cc(chars, char_width):
	if char_width == 8: return chars_to_utf8(chars)
	elif char_width == 16: return chars_to_utf16(chars)
	elif char_width == 32: return chars_to_utf32(chars)
	return []


def chars_to_utf8(chars):
	char8_codes = []

	for c in chars:
		utf8_bytes = bytes(c, encoding='utf-8')
		i = 0
		while i < len(utf8_bytes):
			cc = utf8_bytes[i]
			char8_codes.append(cc)
			i = i + 1

	return char8_codes


def chars_to_utf16(chars, encode='big-endian'):
	char16_codes = []

	for c in chars:
		utf16_bytes = bytes(c, encoding='utf-16')[2:]  # [2:] - skip BOM

		i = 0
		while i < len(utf16_bytes):
			first = utf16_bytes[i+0]
			second = utf16_bytes[i+1]
			cc = 0
			if encode == 'big-endian':
				cc = second * 256 + first
			else:
				cc = first * 256 + second
			i = i + 2

			char16_codes.append(cc)

	return char16_codes


def chars_to_utf32(chars):
	char32_codes = []

	for c in chars:
		cc = ord(c)  # (python uses utf32 by default)
		char32_codes.append(cc)

	return char32_codes


