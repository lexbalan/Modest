# Function type

## Function type expression

#### Common form
```
( <#field_list#>] ) -> <#type_expression#>
```


```swift
// type 'function without params and without return value'
() -> Unit

// type 'function with two Int32 params (a, b) and Int32 return value'
(a: Int32, b: Int32) -> Int32
```

#### Examples

```swift
func sum32 (a: Int32, b: Int32) -> Int32 {
	return a + b
}

public func main () -> Int32 {
	let x = sum32 (1, 2)
	printf("sum32 (1, 2) = %d\n", x)
	return 0
}
```
