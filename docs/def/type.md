
# Type Definition

Type definition bound an *identifier* with a type.

#### Common form
```
type <#identifier#> <#type_expression#>
```



#### Examples

```zig
type MyInt Int32

func main () -> Int {
	var x: MyInt
	x = 10
	printf("x = %d\n", x)
	return 0
}
```


### Type declaration
```
type <#identifier#>
```

#### Examples

```zig
// type declared, but not defined
// such types are called 'opaque'
type MyOpaqueType
```



