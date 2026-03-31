import "builtin"


type IntPtr = *Int32
type CharPtr = *Char8

var value: Int32 = 42
var ptr: *Int32 = &value

func swap (a: *Int32, b: *Int32) -> {} {
	let tmp: Int32 = *a
	*a = *b
	*b = tmp
}

func setToZero (p: *Int32) -> {} {
	*p = 0
}

func pointerArith () -> {} {
	var arr: [5]Int32
	var p: *Int32 = &arr[0]
}

func doublePtr (pp: **Int32) -> Int32 {
	return **pp
}

public func main () -> Int32 {
	var a: Int32 = 1
	var b: Int32 = 2
	swap(&a, &b)
	setToZero(&a)

	var p: *Int32 = &b
	var pp: **Int32 = &p
	var v: Int32 = doublePtr(pp)

	return 0
}

