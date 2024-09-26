
import "libc/stdio"


export func print(form: *Str8, ...) {
	var va: VA_List
	__va_start(va, form)

	/*unsafe Char8*/
	let c = __va_arg(va, Char32)
	stdio.printf("CC32 = %d\n", c)
	stdio.printf("CC8 = %d\n", unsafe Char8 c)

	__va_end(va)
}


func main() -> Int32 {
	let c = Char32 "#"
	print("%c", c)
	return 0
}

