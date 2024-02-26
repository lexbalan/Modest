# Variable Definition

#### Common form
```zig
var <identifier> : <type_expression> [= <default_value_expression>]
```

```zig
// the 'var' directive creates a variable
// (in this case - variable x with type Int32)
var x: Int32
```

#### Examples

```zig
var x: Int32

func main () -> Unit {
  x = 10
  
  printf("x = %d\n", x)
}
```
