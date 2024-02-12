# Function type expression

```zig
// type 'function without params, without return value'
() -> Unit

// type 'function with two Int32 params (a, b) and Int32 return value'
(a: Int32, b: Int32) -> Int32
```

#### Examples

```zig
func sum32 (a: Int32, b: Int32) -> Int32 {
  return a + b
}

func main () -> Unit {
  let x = sum32 (1, 2)
  printf("sum32 (1, 2) = %d\n", x)
}

```
