
# *Index* value expression

### Common form
```
<#array_value#> [<#index_value#>]
<#pointer_to_array_value#> [<#index_value#>]
```

### Examples

#### Index by array value

```zig

const arrayLength = 5

var array: [arrayLength]Int32 = [1, 2, 3, 4, 5]


public func main () -> Int {
	var i: Nat32 = 0
	while i < arrayLength {
		// index array
		let array_item = array[i]

		printf("array[%i] = %i\n", i, array_item)
		++i
	}
	retutn 0
}
```

#### Index by pointer to array value

```zig

const arrayLength = 5

var array: [arrayLength]Int32 = [1, 2, 3, 4, 5]

var ptr_to_array: *[]Nat32
// or variant with type inference:
// var ptr_to_array = &array

public func main () -> Int {
	ptr_to_array = &array

	var i: Nat32 = 0
	while i < arrayLength {
		// index pointer to array
		let array_item = ptr_to_array[i]

		printf("ptr_to_array[%i] = %i\n", i, array_item)
		++i
	}
	retutn 0
}
```
