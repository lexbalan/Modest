
# *Call* value expression


### Common form
```
<#func_value_expression#> (<#arglist#>)
<#pointer_to_func_value_expression#> (<#arglist#>)
```

### Examples

#### Call by func value

```swift
func function_1 () -> Unit {
	printf("function_1()\n")
}

func function_2 (x: Int32) -> {
	printf("function_2(%i)\n", x)
}

func function_3 (x: Int32) -> Int32 {
	printf("function_3(%i)\n", x)
	return x + 1
}

public func main () -> Int {
	// just call
	function_1()

	// call with one argument
	function_2(42)

	// call with one argument
	// and print result value
	let y = function_3(42)
	print("function_3 returns %i\n", y)

	return 0
}
```


#### Call by pointer to func value

```swift
func function_1 () -> Unit {
	printf("function_1()\n")
}

func function_2 (x: Int32) -> Unit {
	printf("function_2(%i)\n", x)
}

func function_3 (x: Int32) -> Int32 {
	printf("function_3(%i)\n", x)
	return x + 1
}

var ptr_to_function_1: () -> Unit
var ptr_to_function_2: (x: Int32) -> Unit
var ptr_to_function_3: (x: Int32) -> Int32

// or variant with type inference:
// var ptr_to_function_1 = &function_1
// var ptr_to_function_2 = &function_2
// var ptr_to_function_3 = &function_3

public func main() -> Int {
	ptr_to_function_1 = &function_1
	ptr_to_function_2 = &function_2
	ptr_to_function_3 = &function_3

	// just call by pointer
	ptr_to_function_1()

	// call by pointer with one argument
	ptr_to_function_2(42)

	// call by pointer with one argument
	// and print result value
	let func3_arg = 42
	let y = ptr_to_function_3(func3_arg)
	print("ptr_to_function_3(%i) returns %i\n", func3_arg, y)

	return 0
}
```

#### Call with named arguments

```swift
// tests/named_args/src/main.m

import "libc/stdio"


func named_args_test (a: Int32, b: Int32, c: Int32) -> Int32 {
	return (a - b) * c
}


public func main () -> Int {
	printf("test named_args\n")

	let a = 25
	let b = 15
	let c = 3

	let x0 = (a - b) * c

	let x1 = named_args_test(
		c = c
		a = a
		b = b
	)

	if x0 == x1 {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}

	return 0
}

```
