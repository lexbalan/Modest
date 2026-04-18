// tests/zarray/src/main.m

include "libc/ctypes64"
include "libc/stdio"

var v: [][]Int32 = [[1, 2], [3, 4], [5, 6, 7], [8, 9, 10, 11], [12, 13]]


var str1: []Char8 = "abc"

// builtin type Str8 has 'zarray' attribute (!)
var str2: Str8 = "abc"

var str3: @zarray []Char8 = "abc"


public func main () -> Int32 {
	return 0
}
