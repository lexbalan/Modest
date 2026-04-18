// tests/zarray/src/main.m

include "libc/ctypes64"
include "libc/stdio"

var str1: []Char8 = "abc"

// builtin type Str8 has 'zarray' attribute (!)
var str2: Str8 = "abc"

var str3: @zarray []Char8 = "abc"


public func main () -> Int32 {
	return 0
}
