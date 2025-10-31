# Fields

*Field* is a combination of *identifier* & *type*. Fields used in *variable definitions*, *function* & *record* type expressions.

```
<#identifier#> : <#type#>
```

#### Examples

Field in variable definition
```swift
var a : Int32
```

Fields in record type expression
```swift
record {
	x : Int64
	y : Int64
}
```

Fields in function type expression (parameters)
```swift
func sum (a : Int64, b : Int64) -> Int64 { ... }
```

