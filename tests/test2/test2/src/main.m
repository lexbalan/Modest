// test2

include "libc/stdio"
include "libc/stdlib"
include "libc/string"


const c0 = 40

var a0: [4]Int32 = [10, 20, 30, c0]
var a1 = [4]Int32 [10, 20, 30, c0]

const pa0 = &a0
const pa1 = &a1


var ss: Str8 = "Hello World!"
var s: *Str8 = "Hello World!"


type Point = @public record {x: Int32, y: Int32}

var points = []Point [{x=0, y=0}, {x=1, y=1}]


func swap (a: [2]Int32) -> [2]Int32 {
	return [a[1], a[0]]
}

func sstr (s: [3]Char16) -> Unit {
	//
}


public func main () -> Int32 {
	printf("test2\n")

	var v0 = Int32 10
	var la0: [5]Int32 = [10, 20, 30, c0, v0]
	var la1 = [5]Int32 [10, 20, 30, c0, v0]

	let s = swap([1, 2])
	printf("s[0] = %d\n", s[0])
	printf("s[1] = %d\n", s[1])

	sstr("ABC")

	return 0
}

