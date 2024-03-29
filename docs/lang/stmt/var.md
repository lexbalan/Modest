# Variable definition statement

Variable definition creates new *local variable* instance.

#### Common view

### Common forms
1. Local variable definition without *default value* (*local variable* will not be initialized and after creation it will contains memory garbage).
```
var <#identifier#> : <#type_expression#>
```

2. Local variable definition without explicit type specification, with *default value* (**it must have *Non-Generic type***). Type of variable will be the same as *default value* type.
```
var <#identifier#> = <#default_value_expression#>
```

3. Local variable definition with explicit type specification and *default value*. *Default value* will be implicit casted to type of variable definition.
```
var <#identifier#> : <#type_expression#> = <#default_value_expression#>
```


#### Examples


```swift
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
    var y = Int32 10
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
