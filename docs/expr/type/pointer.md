# Pointer type expression

#### Common view

```golang
  *Int32  // type 'pointer to Int32'
```

#### Examples

```golang
func main () -> Unit {
  var a : Int32
  var p : *Int32
  a := 0
  p := &a
  *p := 10
  printf("a = %d\n", a) // result: a = 10
}
```
