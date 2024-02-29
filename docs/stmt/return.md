# Return statement

*Return statement* breaks function execution and returns value (in case when function type declares non-*Unit* return type).

#### Common view

```
    return [<#value_expression#>]
```

#### Examples

```zig
func mid (a: Int32, b: Int32) -> Int32 {
    return (a + b) / 2
}
```
