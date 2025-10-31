
# *Access* value expression


### Common form
```
<#record_value#> . <#field_identifier#>
<#pointer_to_record_value#> . <#field_identifier#>
```

### Examples

#### Access by value

```zig
import "libc/stdio"

type Point = record {
	x: Int32
	y: Int32
}

public func main() -> Int32 {
	// create local instance of Point
	var point: Point

	// assign values to record fields
	// ('access operation' (by value) as lvalue)
	point.x = 10
	point.y = 20

	// read record fields
	// ('access operation' (by value) as rvalue)
	let x = point.x
	let y = point.y

	// print x & y for checking
	printf("x = %i\n", x)
	printf("y = %i\n", y)

	return 0
}
```

> Result: `x = 10` `y = 20`

#### Access by pointer to value

```zig
import "libc/stdio"

type Point = record {
	x: Int32
	y: Int32
}

var point: Point

// create var pointer to Point
var ptr_to_point: *Point


public func main() -> Int32 {
	// assign pointer to var point to ptr_to_point
	ptr_to_point = &point

	// or variant with type inference:
	// var ptr_to_point = &point

	// assign values to record fields
	// ('access operation' (by pointer) as lvalue)
	ptr_to_point.x = 10
	ptr_to_point.y = 20

	// read record fields
	// ('access operation' (by pointer) as rvalue)
	let x = ptr_to_point.x
	let y = ptr_to_point.y

	// print x & y for checking
	printf("x = %i\n", x)
	printf("y = %i\n", y)

	return 0
}
```

> Result: `x = 10` `y = 20`

