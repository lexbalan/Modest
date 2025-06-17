
# Type Definition

Type definition bounds an [*identifier*](../identifier.md) with a [*type*](../type/README.md) (*type aliasing*).

#### Common form
```
type <#identifier#> = <#type_expression#>
```


#### Examples

```zig
type MyInt = Int32

public func main () -> Int {
	var x: MyInt
	x = 10
	printf("x = %d\n", x)
	return 0
}
```


### Type declaration
*Type declaration* creates new *undefined type* and bounds it with an *identifier*. This type can be defined after. You can create pointer to
undefined type, but cannot create field with such type.
```
type <#identifier#>
```

#### Examples

```zig
// type declared, but not defined!
type MyRecord

type MyRecord = record {
	self: *MyRecord
}
```



