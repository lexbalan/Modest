# Global Variable Definition

Variable definition creates new *variable* instance.

### Common forms
1. Global variable definition without *default value*. It will be initialized with [***zero***](../value/README.md#Zero-value) value.
```
var <#identifier#> : <#type_expression#>
```

2. Global variable definition without explicit type specification, with *default value* (**it must have *Non-Generic type***). Type of variable will be the same as *default value* type.
```
var <#identifier#> = <#default_value_expression#>
```

3. Global variable definition with explicit type specification and *default value*. *Default value* will be implicit casted to type of variable definition.
```
var <#identifier#> : <#type_expression#> = <#default_value_expression#>
```


### Global variables


##### Global variables example
```swift
var x: Int16
var y = 10 to Int32
var z: Int32 = 20

func main () -> Int32 {
    printf("x = %hd\n", x)
    printf("y = %d\n", y)
    printf("z = %d\n", z)

    return 0
}
```
> Result: `x = 0` `y = 10` `z = 20`



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

