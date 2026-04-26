// limits.m
//

pragma do_not_include
pragma prefix ""
pragma c_include "limits.h"


@alias("c", "INT8_MIN")
public const int8MinValue  = -128
@alias("c", "INT8_MAX")
public const int8MaxValue  = 127

@alias("c", "INT16_MIN")
public const int16MinValue = -32768
@alias("c", "INT16_MAX")
public const int16MaxValue = 32767

@alias("c", "INT32_MIN")
public const int32MinValue = -2147483648
@alias("c", "INT32_MAX")
public const int32MaxValue = 2147483647

@alias("c", "INT64_MIN")
public const int64MinValue = -9223372036854775808
@alias("c", "INT64_MAX")
public const int64MaxValue = 9223372036854775807

@cbyvalue
public const int128MinValue = -170141183460469231731687303715884105728
@cbyvalue
public const int128MaxValue = 170141183460469231731687303715884105727


@cbyvalue
public const nat8MinValue  = 0
@alias("c", "UINT8_MAX")
public const nat8MaxValue  = 255

@cbyvalue
public const nat16MinValue = 0
@alias("c", "UINT16_MAX")
public const nat16MaxValue = 65535

@cbyvalue
public const nat32MinValue = 0
@alias("c", "UINT32_MAX")
public const nat32MaxValue = 4294967295

@cbyvalue
public const nat64MinValue = 0
@alias("c", "UINT64_MAX")
public const nat64MaxValue = 18446744073709551615

@cbyvalue
public const nat128MinValue = 0
@cbyvalue
public const nat128MaxValue = 340282366920938463463374607431768211455


