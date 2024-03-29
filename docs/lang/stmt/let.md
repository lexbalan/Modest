# Constant definition statement

#### Common form

Local constant can be created with `let` keyword. Unlike global constants (they requires *immediate* value), local constant can be created from any kind of value.

```
    let <#identifier#> = <#immediate_value_expression#>
```

#### Examples

```swift
func mid (a: Int32, b: Int32) -> Int32 {
    let sum = a + b
    let result = sum / 2
    return result
}
```
