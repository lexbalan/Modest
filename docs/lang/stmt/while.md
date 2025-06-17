# While statement


#### Common view

```
while <# condition #> {
	// do something while condition is true
}
```


## Break statement
`break`


## Again statement
`again`



#### Examples

```swift

import "libc/stdio"


public func main () -> Int {
	printf("while statement test\n")

	var a: Nat32 = 0
	let b: Nat32 = 10

	while a < b {
		printf("a = %d\n", a)
		a = a + 1
	}

	return 0
}

```
*Result:*
> `a = 0`<br/>
> `a = 1`<br/>
> `a = 2`<br/>
> `a = 3`<br/>
> `a = 4`<br/>
> `a = 5`<br/>
> `a = 6`<br/>
> `a = 7`<br/>
> `a = 8`<br/>
> `a = 9` <br/>

```swift

const nMax = 10

public func main () -> Unit {
	printf("count for: ")

	var n: Int32
	while true {
		scanf("%d", &n)
		if n < 0 {
			printf("enter positive number: ")
			again
		} else if n >= nMax {
			printf("enter number less than %i: " % nMax)
			again
		} else {
			break
		}
	}

	// count (print) in cycle
	var i: Int32 = 0
	while i < n {
		printf("i = %d\n", i)
	}
}
```

