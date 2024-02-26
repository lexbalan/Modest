# Variable definition statement

#### Common view

```zig
    var a: Int32
```

#### Examples


##### Global Variable

```zig

var counter: Int

func count() {
    ++counter
}

func main() -> Int {
    printf("before counter = %i\n", counter)

    // call function count for ten times
    var i = 0
    while i < 10 {
        count()
        ++i
    }
    
    printf("after counter = %i\n", counter)
    
    return 0
}
```


##### Local Variable

```zig
func mid (a: Int32, b: Int32) -> Int32 {
    var result: Int32
    result = a + b
    result = result / 2
    return result
}
```
