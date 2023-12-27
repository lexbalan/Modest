
# VA_List

VA_List is a special type used for creating variable-arguments function. It must be last parameter in function param list. For getting next argument value, you just need cast it to desirable type.

```
func _printf(fmt: *Str8, va: VA_List) {
    var i := 0
	while true {
        var c := str[i]

		if c == "\0"[0] {
			break
		}

		if c == "%"[0] {
            i := i + 1
            c := str[i]
            
            ...

			if (c == "i"[0]) or (c == "d"[0]) {
                // %i & %d for signed integer (Int)
                let i = va_list to Int32
				. . .
            } else if (c == "x"[0]) {
                // %n for unsigned integer (Nat)
                let n = va_list to Nat32
				. . .
			}
            
            . . .

		} else {
			_putchar(c)
		}

        i := i + 1
	}
}

}

```