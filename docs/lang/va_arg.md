# __VA_List


## Examples

```swift
import "libc/stdio"
import "libc/unistd"

func print(format: *Str8, ...) -> @unused SSizeT {
	var va: __VA_List

	__va_start(va, format)

	let strMaxLen = 127 + 1
	var buf: [strMaxLen]Char8
	let n = vsnprintf(&buf, strMaxLen, format, va)

	__va_end(va)

	return write(c_STDOUT_FILENO, &buf, SizeT n)
}


public func main () -> Int {
	var k = 10
	print("print test; k = %d\n", k)
	return 0
}
```
