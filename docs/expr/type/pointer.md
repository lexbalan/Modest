# Pointer type expression

#### Common view

```golang
  *Int32  // pointer to Int32
```

#### Examples

```golang
func main () -> Int32 {
  var a : Int32
  var p : *Int32
  a := 0
  p := &a
  *p := 10
  printf("a = %d\n", a) // result: a = 10
}
```
