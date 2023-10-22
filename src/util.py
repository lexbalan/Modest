

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



def float_align(f_num, power):
    import struct
    z = 0
    if power == 32:
        z = struct.unpack('<f', struct.pack('<f', f_num))[0]
    elif power == 64:
        z = struct.unpack('<d', struct.pack('<d', f_num))[0]
    else:
        fatal("too big float, float_align not implemented")

    return z






def str2utf8(string_items):
    codes = []
    for i in string_items:
        c = chr(i['imm'])
        utf8_bytes = bytes(c, encoding='utf-8') # [2:] - skip BOM
        i = 0
        while i < len(utf8_bytes):
            k = utf8_bytes[i]
            codes.append(k)
            i = i + 1

    return codes


def str2utf16(string_items):
    codes = []
    for i in string_items:
        c = chr(i['imm'])
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

    return codes



def str2utf32(string_items):
    # python uses utf32 by default
    codes = []
    for i in string_items:
        c = (i['imm'])
        codes.append(c)
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



