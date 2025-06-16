# Constant Definition

Constant definition bounds an [*identifier*](../identifier.md) with an [*immediate value*](../value/README.md) (*value aliasing*).

### Common form

#### Global const
```
// for global const
const <#identifier#> = <#immediate_value_expression#>
// or:
const <#identifier#>: <#type_expression#> = <#immediate_value_expression#>
```

#### Local const
```
let <#identifier#> = <#value_expression#>
// or:
let <#identifier#>: <#type_expression#> = <#value_expression#>
```


## Global constant definition

Global constant definition bounds an [*identifier*](../identifier.md) with an [*immediate value*](../value/README.md).


#### Examples

```swift
const one = 1
const two = one + 1
const three = one + two
const four = two * 2
```

```swift
const message = "Hello World!\n"

public func main () -> Int32 {
	printf("%s\n", message)
	return 0
}
```


## Local constant definition

Local constant definition bounds an [*identifier*](../identifier.md) with an value.

#### Examples

```swift
func mid (a: Int32, b: Int32) -> Int32 {
	let sum = a + b
	let result: Int32 = sum / 2
	return result
}
```

