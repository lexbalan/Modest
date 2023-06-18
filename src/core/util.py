


def nbits_for_int(x):
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


def nbytes_for_int(num, signed=True):
  nn = nbits_for_int(num)

  if signed:
    if num < 0:
      nn = nn + 1

  y = nbytes_for_bits(nn)
  #print("nbytes_for_int %d -> %d (%d)" % (num, nn, y))
  return y




DBL_MAX = 1.7976931348623158e+308  # /* max value */
DBL_MIN = 2.2250738585072014e-308  # /* min positive value */

FLT_MAX = 3.402823466e+38  # /* max value */
FLT_MIN = 1.175494351e-38  # /* min positive value */

def float_to_hex(f):
    return hex(struct.unpack('<I', struct.pack('<f', f))[0])

#float_to_hex(17.5)    # Output: '0x418c0000'

def double_to_hex(f):
    return hex(struct.unpack('<Q', struct.pack('<d', f))[0])

#double_to_hex(17.5)   # Output: '0x4031800000000000L'

# TODO!
def nbytes_for_float(num):
  return 4  # TODO!

