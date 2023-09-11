

def nbits_for_num(x):
  n = 1
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


