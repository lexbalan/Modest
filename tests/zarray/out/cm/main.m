private import "builtin"
include "ctypes64"
include "stdio"


var v: [5][4]Int32 = [[1, 2], [3, 4], [5, 6, 7], [8, 9, 10, 11], [12, 13]]


var str1: [3]Char8 = "abc"

// builtin type Str8 has 'zarray' attribute (!)
var str2: [3]Char8 = "abc"

var str3: [3]Char8 = "abc"


public func main () -> Int32 {
	return 0
}

