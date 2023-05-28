
# Type Definition

```golang
// the 'type' directive creates an alias for an existing type
// (in this case - MyInt for built-in type Int32)
type MyInt Int64
```

#### Examples

```golang
type MyInt Int32

var x : MyInt

func main () -> Unit {
  x := 10
  
  printf("x = %d\n", x)
}
```
