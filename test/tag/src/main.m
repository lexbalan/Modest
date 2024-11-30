
import "libc/stdio"


public func print(form: *Str8, ...) {
	var va: VA_List
	__va_start(va, form)

	let c = __va_arg(va, Char32)
	stdio.printf("CC32 = %d\n", c)
	stdio.printf("CC8 = %d\n", unsafe Char8 c)

	__va_end(va)
}



type Rec0 record {
	p: *Rec1
}

type Rec1 record {
	p: *Rec0
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

