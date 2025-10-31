# Pointer type

## Pointer type expression

#### Common form
```
	* <#type_expression#>
```


#### Examples

```swift
	*Int32	  // pointer to Int32
	**Int32   // pointer to pointer to Int32
	***Int32  // pointer to pointer to pointer to Int32
	...
```

```swift
public func main () -> Int32 {
	var a: Int32
	var p: *Int32
	a = 0
	p = &a
	*p = 10
	printf("a = %d\n", a) // result: a = 10

	return 0
}
```


## Free pointer

*Pointer to Unit* (aka *Free pointer type*) can points to value of **any type**.
```swift
// see: test/free_pointer/src/main.m

import "libc/stdio"

public func main () -> Int32 {
	var a: Bool
	var b: Int32
	var c: Int64

	//
	var freePointer: *Unit

	// free pointer can points to value of any type
	freePointer = &a  // it's ok (just for demonstration)
	freePointer = &b  // it's also ok
	freePointer = &c  // after all it will be points to value c (with type Int64)

	// you can't do dereference operation with Free pointer
	// (because runtime doesn't have any idea about value type it pointee),
	// but you can construct another (non Free) pointer from it
	// and use it as usualy
	*(*Int64 freePointer) = 123456789123456789

	printf("c = 0x%llX\n", c)

	// Let's create new pointer to *Int64 from freePointer
	let px = *Int64 freePointer

	// And will use it...
	let x = *px

	// for pointer mechanics checking
	printf("x = 0x%llX\n", x)

	return 0
}
```
> Result: `c = 0x123456789ABCDEF` `x = 0x123456789ABCDEF`



