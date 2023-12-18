

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







def str2utf8(string_items):
    codes = []
    for cc in string_items:
        c = chr(cc)
        utf8_bytes = bytes(c, encoding='utf-8') # [2:] - skip BOM
        i = 0
        while i < len(utf8_bytes):
            k = utf8_bytes[i]
            codes.append(k)
            i = i + 1

    codes.append(0)
    return codes


def str2utf16(string_items):
    codes = []
    for cc in string_items:
        c = chr(cc)
        utf16_bytes = bytes(c, encoding='utf-16')[2:] # [2:] - skip BOM

        i = 0
        encode = 'big-endian'
        while i < len(utf16_bytes):
            first = utf16_bytes[i+0]
            second = utf16_bytes[i+1]
            k = 0
            if encode == 'big-endian':
                k = second * 256 + first
            else:
                k = first * 256 + second
            i = i + 2

            codes.append(k)

    codes.append(0)
    return codes



def str2utf32(string_items):
    # python uses utf32 by default
    codes = []
    for cc in string_items:
        codes.append(cc)
    codes.append(0)
    return codes


# it also works
"""def str2utf32_2(string_items):
    codes = []
    for i in string_items:
        c = chr(i['imm'])
        utf32_bytes = bytes(c, encoding='utf-32')[4:] # [4:] - skip BOM

        #print(utf32_bytes)

        i = 0
        encode = 'big-endian'
        while i < len(utf32_bytes):
            first = utf32_bytes[i+0]
            second = utf32_bytes[i+1]
            third = utf32_bytes[i+2]
            fourth = utf32_bytes[i+3]
            k = 0
            if encode == 'big-endian':
                k = (fourth << 24) + (third << 16) + (second << 8) + first
            else:
                k = (first << 24) + (second << 16) + (third << 8) + fourth
            i = i + 4

            codes.append(k)

    return codes"""




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





def utf8_cc_arr_to_utf32_cc_arr(arr):
    arr = list(bytes(arr).decode('utf-8').encode('utf-32').decode('utf32'))

    res = []
    for c in arr:
        cc = ord(c)
        res.append(cc)

    return res



def utf16_cc_arr_to_utf32_cc_arr(arr):
    #"\ud83d\ude4f".encode('utf-16', 'surrogatepass')[2:].decode('utf-16').encode('utf-8').decode('utf-8')

    s16 = u""
    for cc in arr:
        s16 = s16 + chr(cc)

    s_list = list(s16.encode('utf-16', 'surrogatepass')[2:].decode('utf-16').encode('utf-32').decode('utf32'))

    res = []
    for c in s_list:
        cc = ord(c)
        res.append(cc)

    return res





