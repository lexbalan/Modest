# VA_List


## Examples

```swift
import "libc/stdio"
import "libc/unistd"

@unused_result
func print(format: *Str8, ...) -> SSizeT {
	var va: VA_List

	__va_start(va, format)

	let strMaxLen = 127 + 1
	var buf: [strMaxLen]Char8
	let n = vsnprintf(&buf, strMaxLen, format, va)

	__va_end(va)

	return write(c_STDOUT_FILENO, &buf, SizeT n)
}


func main() -> Int {
	var k = 10
	print("print test; k = %d\n", k)
	return 0
}

```
