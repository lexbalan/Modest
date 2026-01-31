// tests/xxx/src/main.m

include "libc/stdio"
include "libc/string"


type Point = record {
	x: Int32 = 32
	y: Int32 = 32
}


const hello = "Hello"

var str0: Str8 = hello
var str1: Str16 = hello
var str2: Str32 = hello

var pstr0: *Str8 = hello
var pstr1: *Str16 = hello
var pstr2: *Str32 = hello


func puts8 (s: *Str8) -> Unit {
}

func puts16 (s: *Str16) -> Unit {
}

func puts32 (s: *Str32) -> Unit {
}


func ss (s: [10]Char8) -> [10]Char8 {
	let ks = s[2:5]
	return s
}

var arr2d: [10][10]Int32

const cc1: Nat32

var ax: [cc1]Int32

public func main () -> Int32 {
	printf("Hello World!\n")

	var p_arr2d: *[][]Int32
	p_arr2d = &arr2d

	var a: @zarray [10]Byte

	//var b = Int32 cc1

	//let xx = p_arr2d[0]
	//let yy = p_arr2d[0:2]

	var s1: [32]Char8 = "Hello!"
	var s2: [32]Char8 = "World"

	puts8(&s1)

	let length = strlen(&s1)
	strcpy(&s2, &s1)
	strncpy(&s2, &s1, 5)

	puts8(&str0)
	puts8(pstr0)

	puts16(&str1)
	puts32(pstr2)

	return 0
}


// Unit
//public func xxx () -> record {} {
//	return {}
//}


