# Array type expression

#### Common view

```golang
  [10]Int32  // type 'array of 10 Int32'
```

#### Examples

```golang

var a : [3]Int32

func main () -> Unit {
  a[0] := 0
  a[1] := 10
  a[2] := 100
  
  printf("a[0] = %d\n", a[0])
  printf("a[1] = %d\n", a[1])
  printf("a[2] = %d\n", a[2])
}
```
