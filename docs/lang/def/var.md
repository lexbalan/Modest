# Variable Definition

Variable definition creates new *variable* instance.

### Common forms
1. Variable definition without *default value*. It will be initialized with [***zero***](../value/README.md#Zero-value) value.
```
var <#identifier#> : <#type_expression#>
```

2. Variable definition without explicit type specification, with *default value* (**it must have *Non-Generic type***). Type of variable will be the same as *default value* type.
```
var <#identifier#> = <#default_value_expression#>
```

3. Variable definition with explicit type specification and *default value*. *Default value* will be implicit casted to type of variable definition.
```
var <#identifier#> : <#type_expression#> = <#default_value_expression#>
```


## Global variables

Variable definition outside function body creates new *local variable* instance.

##### Global variables example
```swift
var x: Int16
var y = Int32 10
var z: Int32 = 20

public func main () -> Int32 {
	printf("x = %hd\n", x)
	printf("y = %d\n", y)
	printf("z = %d\n", z)

	return 0
}
```
*Result:*
>`x = 0`<br/>
>`y = 10`<br/>
>`z = 20`<br/>


```swift

var counter: Int

func count () -> Unit {
	++counter
}

public func main () -> Int {
	printf("before counter = %i\n", counter)

	// call function count for ten times
	var i: Nat32 = 0
	while i < 10 {
		count()
		++i
	}

	printf("after counter = %i\n", counter)

	return 0
}
```


## Local variables

Variable definition inside function body creates new *local variable* instance.


##### Global variables example

```swift
func mid (a: Int32, b: Int32) -> Int32 {
	var result: Int32
	result = a + b
	result = result / 2
	return result
}
```

```swift
public func main () -> Int32 {
	var x: Int16
	var y = Int32 10
	var z: Int32 = 10

	// We need to initialize x with some value
	// because local variable without default value
	// will contains 'garbage' value from memory
	// (some kind of 'random' value)
	x = 5

	printf("x = %hd\n", x)
	printf("y = %d\n", y)
	printf("z = %d\n", z)

	return 0
}
```
*Result:*
> `x = 5`<br/>
> `y = 10`<br/>
> `z = 20`<br/>


