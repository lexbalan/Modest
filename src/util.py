

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


