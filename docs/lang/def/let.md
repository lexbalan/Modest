# Constant Definition

Constant definition bounds an [*identifier*](../identifier.md) with an [*immediate value*](../value/README.md) (*value aliasing*).

#### Common form

```
let <#identifier#> = <#value_expression#>
```

## Global constant definition

Global constant definition bounds an [*identifier*](../identifier.md) with an [*immediate value*](../value/README.md).


#### Examples

```swift
let one = 1
let two = one + 1
let three = one + two
let four = two * 2
```

```swift
let message = "Hello World!\n"

func main () -> Int32 {
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
	let result = sum / 2
	return result
}
```

