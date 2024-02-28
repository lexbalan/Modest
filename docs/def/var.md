# Variable Definition

#### Common form
Variable definition without *default value*. *Global variable* will be initialized with ***zero*** value, *local variable* will not be initialized (after creation it will contains stack garbage).
```zig
var <#identifier#> : <#type_expression#>
```

Variable definition, without explicit type definition, with *default value* (**it must have Non-Generic type**). Type of variable will be the same as *default value* type.
```
var <#identifier#> = <#default_value_expression:non-generic#>
```

Variable definition, with explicit type definition and *default value*. *Default value* will be implicit casted to type of variable definition.
```
var <#identifier#> : <#type_expression#> = <#default_value_expression#>
```


#### Examples

```zig
var x: Int32

func main () -> Unit {
  x = 10
  
  printf("x = %d\n", x)
}
```
