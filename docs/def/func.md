# Function Definition

Function definition creates new *function*.

#### Common form
```
func <#identifier#> <#func_type_expression#> {
	// function block
}
```

#### Examples

```swift

func sum_i32 (a: Int32, b: Int32) -> Int32 {
    return a + b
}

func test_sum () {
    let a = 10
    let b = 20
    let sum_result = sum_i32(a, b)
    if sum_result == a + b {
        printf("sum works fine!\n")
    } else {
        printf("something go wrong...\n")
    }
}

func main () -> Int32 {
    printf("Hello World!\n")

    test_sum()

    return 0
}

```
