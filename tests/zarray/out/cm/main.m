private import "builtin"
include "ctypes64"
include "stdio"



var v: [5][4]Int32 = [[1, 2], [3, 4], [5, 6, 7], [8, 9, 10, 11], [12, 13]]
var u = [][]Int32 [[1, 2], [3, 4], [5, 6, 7], [8, 9, 10, 11], [12, 13]]

var s: [4]*Str8 = ["abc", "def", "gefhk", "l"]
var s2: [4][5]Char8 = ["abc", "def", "gefhk", "l"]

var str1: [3]Char8 = "abc"
var a2 = [][]Char8 ["abc", "def"]

// builtin type Str8 has 'zarray' attribute (!)
var str2: [3]Char8 = "abc"



const cv: [5][4]Int32 = [[1, 2], [3, 4], [5, 6, 7], [8, 9, 10, 11], [12, 13]]
const cu = [][]Int32 [[1, 2], [3, 4], [5, 6, 7], [8, 9, 10, 11], [12, 13]]

const cs: [4]*Str8 = ["abc", "def", "gefhk", "l"]
const cs2: [4][5]Char8 = ["abc", "def", "gefhk", "l"]

const cstr1: [3]Char8 = "abc"
const ca2 = [][]Char8 ["abc", "def"]


// builtin type Str8 has 'zarray' attribute (!)
const cstr2: [3]Char8 = "abc"



var str3: [3]Char8 = "abc"


public func main () -> Int32 {
	if u == v {
		printf("u == v\n")
	}

	v = cv
	u = cu
	s = cs
	s2 = cs2
	str1 = cstr2
	a2 = ca2

	var i: Int32
	if i > 0 {
	}

	return 0
}

