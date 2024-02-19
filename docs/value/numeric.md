# Numeric value expression

```zig
123   // decimal number
042   // decimal number (there's not octal literals)
0x2A  // hexadecimal number
```

#### Exmples

```zig
func main () -> Int32 {
    var x: Nat32
    x = 123
    printf("x = %i\n", x)

    var y: Nat32
    y = 042
    printf("y = %i\n", y)

    var z: Nat32
    z = 0x2A  // 0x2A == 42
    printf("z = %i\n", z)

    return 0
}
```

> Result:
`x = 123`
`y = 42`
`z = 42`



