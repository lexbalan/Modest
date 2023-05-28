# If statement

#### Common view

```golang
  if condition {
    // do something if condition != 0
  }
```

#### Examples

```golang
var a : Int32

func main () -> Unit {
  var a : Int32
  var b : Int32
  
  // input a
  printf("a = ");
  scanf("%d", &a);
  
  // input b
  printf("b = ");
  scanf("%d", &b);
  
  // print equation
  if a > b {
    printf("a > b\n")
  } else if a < b {
    printf("a < b\n")
  } else {
    printf("a == b\n")
  }
}

```
