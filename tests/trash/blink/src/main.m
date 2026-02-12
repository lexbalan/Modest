
import "libc/stdio"


public func print(form: *Str8, ...) -> Unit {
	var va: __VA_List
	__va_start(va, form)

	let c = __va_arg(va, Char32)
	stdio.printf("CC32 = %d\n", c)
	stdio.printf("CC8 = %d\n", unsafe Char8 c)

	__va_end(va)
}


public func main() -> Int32 {
	let c = Char32 "#"
	print("%c", c)
	return 0
}

