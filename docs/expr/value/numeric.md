# Numeric value expression

```zig
42    // decimal number
0x2A  // hexadecimal number
```

#### Exmples

```zig
func main () -> Unit {
  var x : Nat32
  x := 42
  printf("x = %d\n", x)
  x := 0x2A  // 0x2A == 42
  printf("x = %d\n", x)
}
```
