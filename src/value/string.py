
from .value import value_terminal
from util import nbits_for_num
from hlir.type import hlir_type_string


def value_string_create(string, ti=None):
    #info("value_string_create %d" % length, ti)
    """chars = []
    for char in string:
        cc = ord(char)
        char_value = value_char_create(cc, _type=None, ti=ti)
        chars.append(char_value)"""

    max_char_width = 8
    for c in string:
        cc = ord(c)
        n = nbits_for_num(cc)
        max_char_width = max(max_char_width, n)

    string_type = hlir_type_string(max_char_width, ti)
    nv = value_terminal(string_type, string, ti)
    nv['immediate'] = True
    return nv


# concatenation of two strings
def value_string_concat(l, r, ti):
    #info("value_array_concat", ti)
    newstring = l['asset'] + r['asset']
    return value_string_create(newstring, ti)

    """str_array_volume = value_integer_create(length)
    item_type = select_common_type(l['type']['of'], r['type']['of'])
    assert(item_type != None)
    t = hlir_type.hlir_type_array(item_type, volume=str_array_volume, ti=ti)
    t['generic'] = True

    nv = value_bin('add_arr', l, r, t, ti=ti)
    nv['asset'] = asset
    nv['immediate'] = True
    nv['nl_end'] = r['nl_end']
    return nv"""
