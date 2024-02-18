# Numeric value expression

```zig
123   // decimal number
042   // decimal number (there's not octal literals)
0x2A  // hexadecimal number
```

#### Exmples

```zig
func main () -> Unit {
  var x: Nat32
  var y: Nat32
  var z: Nat32
  
  x = 123
  printf("x = %d\n", x)
  
  y = 042
  printf("y = %d\n", y)
  
  z = 0x2A  // 0x2A == 42
  printf("z = %d\n", z)
}
```

> Result:
`x = 123`
`y = 42`
`z = 42`



