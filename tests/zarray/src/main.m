// tests/zarray/src/main.m

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"


var v: [][]Int32 = [[1, 2], [3, 4], [5, 6, 7], [8, 9, 10, 11], [12, 13]]
var u = [][]Int32 [[1, 2], [3, 4], [5, 6, 7], [8, 9, 10, 11], [12, 13]]

var s: []*Str8 = ["abc", "def", "gefhk", "l"]
var s2: [4]Str8 = ["abc", "def", "gefhk", "l"]

var str1: []Char8 = "abc"
var a2 = [][]Char8 ["abc", "def"]

// builtin type Str8 has 'zarray' attribute (!)
var str2: Str8 = "abc"



const cv: [][]Int32 = [[1, 2], [3, 4], [5, 6, 7], [8, 9, 10, 11], [12, 13]]
const cu = [][]Int32 [[1, 2], [3, 4], [5, 6, 7], [8, 9, 10, 11], [12, 13]]

const cs: []*Str8 = ["abc", "def", "gefhk", "l"]
const cs2: [4]Str8 = ["abc", "def", "gefhk", "l"]

const cstr1: []Char8 = "abc"
const ca2 = [][]Char8 ["abc", "def"]


// builtin type Str8 has 'zarray' attribute (!)
const cstr2: Str8 = "abc"

var str3: @zarray []Char8 = "abc"


type Success = @branded Bool
const success = Success true
const failure = Success false



func suc () -> Success {
	return success
}


func main () -> Int32 {
	let success = suc()

	if u == v {
		printf("u == v\n")
	}

	v = cv
	u = cu
	s = cs
	s2 = cs2
	str1 = cstr2
	a2 = ca2

	let a = 5
	let b = 6
	let c = 7
	let arr = [a, b, c]

	// ! parsing error (!)
	var arr2 = []Int32 arr

	printf("memoryTest = %d\n", memoryTest())

	return Int32 0
}


func memoryTest () -> Bool {
	let memorySize = 1024 * 1024 * 100
	let memory = new [memorySize]Byte []//malloc(memorySize)
	//let memory = *[memorySize]Byte malloc(memorySize)
	let mem = * @volatile [memorySize]Byte memory
	if mem == nil {
		printf("cannot allocate memory\n")
		return false
	}
	var pattern: Word8
	var i: Nat8 = 0
	let nPatterns = 12
	while i < nPatterns {
		var pattern: Word8 = 0x00
		if i < 8 {
			pattern = Word8 1 << i
		} else if i == 8 {
			pattern = 0x00
		} else if i == 9 {
			pattern = 0x55
		} else if i == 10 {
			pattern = 0xAA
		} else {
			pattern = 0xFF
		}

		printf("check pattern = 0x%02x\n", pattern)

		if not testRegion(mem, memorySize, pattern) {
			return false
		}

		++i
	}

	return true
}


func testRegion (mem: *[]Byte, size: Nat32, pattern: Byte) -> Bool {
	// fill
	var i: Nat32 = 0
	while i < size {
		mem[i] = pattern
		++i
	}

	// check
	i = 0
	while i < size {
		if mem[i] != pattern {
			return false
		}
		++i
	}

	return true
}


