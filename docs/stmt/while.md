# While statement


#### Common view

```zig
  while condition {
    // do something while condition != 0
  }
```

#### Examples

```zig
var a : Int32

func main () -> Unit {
  var i : Int32
  var n : Int32
  
  // input n
  printf("count for ");
  scanf("%d", &n);
 
  i := 0
  
  // print equation
  while i < n {
    printf("i = %d\n", i)
  }
}

```
