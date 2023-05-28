# Record type expression

```pascal
record {x : Int32, y : Int32}
```

#### Examples

```golang
type Point record {
  x : Int32
  y : Int32
}

func main () -> Unit {
  var p : Point
  
  p := {x=10, y=10}
  
  printf("p.x = %d\n", p.x)
  printf("p.y = %d\n", p.y)
}

```
