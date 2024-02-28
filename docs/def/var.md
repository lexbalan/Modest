# Variable Definition

#### Common forms
Variable definition without *default value*. *Global variable* will be initialized with [***zero***](../value/README.md#Zero-value) value, *local variable* will not be initialized (after creation it will contains stack garbage).
```
var <#identifier#> : <#type_expression#>
```

Variable definition, without explicit type definition, with *default value* (**it must have Non-Generic type**). Type of variable will be the same as *default value* type.
```
var <#identifier#> = <#default_value_expression#>
```

Variable definition, with explicit type definition and *default value*. *Default value* will be implicit casted to type of variable definition.
```
var <#identifier#> : <#type_expression#> = <#default_value_expression#>
```


#### Examples

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


##### Local variables example
```swift

func main () -> Int32 {
    var x: Int16
    var y = 10 to Int32
    var z: Int32 = 10
    
    // We need to initialize x with some value
    // because local variable without default value
    // will contains 'garbage' value from program stack
    // (some kind of 'random' value)
    x = 5
    
    printf("x = %hd\n", x)
    printf("y = %d\n", y)
    printf("z = %d\n", z)

    return 0
}
```
> Result: `x = 5` `y = 10` `z = 20`
