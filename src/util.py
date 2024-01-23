

def align_to(x, y):
    if y == 0:
        return 0

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


def nbytes_for_bits(x):
    aligned_bits = 8
    while aligned_bits < x:
        aligned_bits = aligned_bits * 2
    return aligned_bits // 8


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



