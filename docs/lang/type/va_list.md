
# VA_List type

VA_List is a special pseudo-type used for creating variable-arguments functions. It can be only type of last parameter in function param list. For getting next argument value, you just need to cast VA_List parameter to desirable type.

```swift
func my_printf(fmt: *Str8, ...) {
	var i = 0
	while true {
		var c = str[i]

		if c == "\0"[0] {
			break
		}

		if c == "%"[0] {
			i = i + 1
			c = str[i]
			
			...

			if c == "i"[0] {
				// %i for signed integer (Int)
				let i = Int32 va_list
				. . .
			} else if (c == "n"[0]) {
				// %n for unsigned integer (Nat)
				let n = Nat32 va_list
				. . .
			}
			
			. . .

		} else {
			_putchar(c)
		}

		i = i + 1
	}
}

```