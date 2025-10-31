# Record type

## Record type expression

#### Common view

```
record { <#fields#> }
```


#### Examples

```swift
record {x: Int32, y: Int32}  // type 'record with two fields x & y with type Int32'
```


```swift
type Point = record {
	x: Int32
	y: Int32
}

public func main () -> Unit {
	var p: Point

	// we can initialize record with 'literal record value'
	p = {x=10, y=10}

	// or
	// p.x = 10
	// p.y = 10

	printf("p.x = %d\n", p.x)
	printf("p.y = %d\n", p.y)
}
```
