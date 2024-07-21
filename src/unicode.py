

def utf32_str_to_utfx_char_codes(strx, char_width):
	char_codes = []
	if char_width == 8: char_codes = _str2utf8(strx)
	elif char_width == 16: char_codes = _str2utf16(strx)
	elif char_width == 32: char_codes = _str2utf32(strx)
	return char_codes


def _str2utf8(string_asset):
	char8_codes = []

	for c in string_asset:
		utf8_bytes = bytes(c, encoding='utf-8')
		i = 0
		while i < len(utf8_bytes):
			cc = utf8_bytes[i]
			char8_codes.append(cc)
			i = i + 1

	return char8_codes


def _str2utf16(string_asset, encode='big-endian'):
	char16_codes = []

	for c in string_asset:
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


def _str2utf32(string_asset):
	char32_codes = []

	for c in string_asset:
		cc = ord(c)  # (python uses utf32 by default)
		char32_codes.append(cc)

	return char32_codes



