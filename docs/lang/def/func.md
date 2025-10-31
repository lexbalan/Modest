# Function Definition

Function definition creates new *function* instance.

#### Common form
```
func <#identifier#> <#func_type_expression#> {
	// function block
}
```

#### Examples

```swift

func sum_i32 (a: Int32, b: Int32) -> Int32 {
	return a + b
}

func test_sum () -> Unit {
	let a = 10
	let b = 20

	let expected_result = a + b
	let sum_result = sum_i32(a, b)

	if sum_result == expected_result {
		printf("function sum works fine!\n")
	} else {
		printf("something go wrong...\n")
	}
}

public func main () -> Int32 {
	test_sum()
	return 0
}

```
