

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


def get_item_with_id(_list, name):
    for x in _list:
        if x['id']['str'] == name:
            return x
    return None



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



def utf8_cc_arr_to_utf32_cc_arr(arr):
    arr = list(bytes(arr).decode('utf-8').encode('utf-32').decode('utf32'))

    res = []
    for c in arr:
        cc = ord(c)
        res.append(cc)

    return res



def utf16_cc_arr_to_utf32_cc_arr(arr):
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
def utfx_chars_to_utf32_chars(codes, char_width):
    utf32_codes = []
    if char_width == 8: utf32_codes = utf8_cc_arr_to_utf32_cc_arr(codes)
    elif char_width == 16: utf32_codes = utf16_cc_arr_to_utf32_cc_arr(codes)
    elif char_width == 32: utf32_codes = codes
    return utf32_codes



# принимает массив кодов символов в кодировке utf-32
# возвращает питоновскую строку с этими символами
def utf32_chars_to_string(chars):
    ccodes = []
    for char in chars:
        cc = char['asset']
        ccodes.append(chr(cc))
    return ''.join(ccodes)






def utf32_chars_to_utfx_chars(strx, char_width):
    s_imm = []
    if char_width == 8: s_imm = str2utf8(strx)
    elif char_width == 16: s_imm = str2utf16(strx)
    elif char_width == 32: s_imm = str2utf32(strx)
    return s_imm


def str2utf8(string_asset):
    chars8 = []

    from foundation import typeChar8
    from value.char import value_char_create

    for c in string_asset:
        utf8_bytes = bytes(c, encoding='utf-8')
        i = 0
        while i < len(utf8_bytes):
            сс = utf8_bytes[i]
            char = value_char_create(сс, _type=typeChar8, ti=None)
            chars8.append(char)
            i = i + 1

    return chars8



def str2utf16(string_asset, encode='big-endian'):
    chars16 = []

    from foundation import typeChar16
    from value.char import value_char_create

    for c in string_asset:
        utf16_bytes = bytes(c, encoding='utf-16')[2:]  # [2:] - skip BOM

        i = 0
        while i < len(utf16_bytes):
            first = utf16_bytes[i+0]
            second = utf16_bytes[i+1]
            сс = 0
            if encode == 'big-endian':
                сс = second * 256 + first
            else:
                сс = first * 256 + second
            i = i + 2

            char = value_char_create(сс, _type=typeChar16, ti=None)
            chars16.append(char)

    return chars16



def str2utf32(string_asset):
    # (python uses utf32 by default)
    chars32 = []

    from foundation import typeChar32
    from value.char import value_char_create

    for c in string_asset:
        cc = ord(c)
        char = value_char_create(cc, _type=typeChar32, ti=None)
        chars32.append(char)

    return chars32



