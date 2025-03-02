
import "libc/stdio"



public type Rec0 record {
	p: *Rec1
}

public type Rec1 record {
	p: *Rec0
}


type X record {
	text: [10]Char8
}

var x = X {
	text = "abcdefghkj"
}

public func main() -> Int32 {
	let c = Char32 "#"
	print("%c", c)


	var r0: Rec0
	var r1: Rec1

	r0.p = &r1
	r1.p = &r0

	return 0
}


func print(form: *Str8, ...) {
	var va: __VA_List
	__va_start(va, form)

	let c = __va_arg(va, Char32)
	stdio.printf("CC32 = %d\n", c)
	stdio.printf("CC8 = %d\n", unsafe Char8 c)

	__va_end(va)
}


