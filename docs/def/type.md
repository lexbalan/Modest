
# Type Definition

```zig
// the 'type' directive creates an alias for an existing type
// (in this case - MyInt for built-in type Int32)
type MyInt Int64
```

Type declaration
```zig
// type declared, but not defined
// such types are called 'opaque'
type MyOpaqueType
```

#### Examples

```zig
type MyInt Int32

var x : MyInt

func main () -> Unit {
  x = 10
  
  printf("x = %d\n", x)
}
```





