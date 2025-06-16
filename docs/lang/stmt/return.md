# Return statement

*Return statement* breaks function execution and returns value (in case when function type declares non-*Unit* return type).

#### Common view

Return statement with *return value*
```
return <# return_value #>
```

Return statement without *return value*
```
return
```

#### Examples

```swift
func mid (a: Int32, b: Int32) -> Int32 {
	// in this case return statement stops function execution
	// and returns result of evaluation return value expression
	return (a + b) / 2
}
```

```swift
func do_nothing () -> Unit {
	// in this case return statement cannot returns some value,
	// (because function defined as function to Unit)
	// but it also stops function execution
	return
}

```
