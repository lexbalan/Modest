# Local Variable definition statement

Variable definition creates new *local variable* instance.

#### Common view

```
    var <#identifier#>: <#type_expression#>
```

#### Examples


```zig
func mid (a: Int32, b: Int32) -> Int32 {
    var result: Int32
    result = a + b
    result = result / 2
    return result
}
```


```swift

func main () -> Int32 {
    var x: Int16
    var y = 10 to Int32
    var z: Int32 = 10
    
    // We need to initialize x with some value
    // because local variable without default value
    // will contains 'garbage' value from memory
    // (some kind of 'random' value)
    x = 5
    
    printf("x = %hd\n", x)
    printf("y = %d\n", y)
    printf("z = %d\n", z)

    return 0
}
```
> Result: `x = 5` `y = 10` `z = 20`
