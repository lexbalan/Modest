# If statement

#### Common form

```
if <# condition #> {
	// do something if condition is true
}
```

```
if <# condition #> {
	// do something if condition is true
} else {
	// do something if condition is false
}
```

```
if <# condition1 #> {
	// do something if condition1 is true
} else if <# condition2 #> {
	// do something if condition1 is false and condition2 is true

  ...

} else {
	// do something if all conditions above are false
}
```

#### Examples

```swift
// see: examples/stmt_if/src/main.m

import "libc/stdio"


public func main () -> Int {
	printf("if statement example\n")

	var a: Int32
	var b: Int32

	printf("enter a: ")
	scanf("%d", &a)
	printf("enter b: ")
	scanf("%d", &b)

	if a > b {
		printf("a > b\n")
	} else if a < b {
		printf("a < b\n")
	} else {
		printf("a == b\n")
	}

	return 0
}

```
