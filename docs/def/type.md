
# Type Definition

#### Common form
```zig
type <identifier> <type_expression>
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
```zig
type <new_type_identifier>
```

#### Examples

```zig
// type declared, but not defined
// such types are called 'opaque'
type MyOpaqueType
```



