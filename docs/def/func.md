# Function Definition

#### Common form
```zig
func <identifier> <type_expression> {
	// function block
}
```

```zig
// the 'func' directive creates a function

func main () -> Unit {
  printf("Hello World!\n")
}

func sum_i32 (a: Int32, b: Int32) -> Int32 {
  return a + b
}
```
