# Array type

## Array type expression

#### Common view

```
	[ <#immediate_value_expression#> ] <#type_expression#>
```

> There's no way to create array of array but you can create array of pointers to arrays


#### Examples

```zig

var a: [3]Int32

public func main () -> Unit {
	a[0] = 0
	a[1] = 10
	a[2] = 100

	printf("a[0] = %d\n", a[0])
	printf("a[1] = %d\n", a[1])
	printf("a[2] = %d\n", a[2])
}
```


##### Open array type

```
	[ ] <#type_expression#>
```

