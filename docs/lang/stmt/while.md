# While statement


#### Common view

```
    while <#condition#> {
        // do something while condition is true
    }
```

#### Examples

```swift
// see: examples/stmt_while/src/main.cm

import "libc/stdio"


func main() -> Int {
    printf("while statement test\n")

    var a = 0
    let b = 10

    while a < b {
        printf("a = %d\n", a)
        a = a + 1
    }

    return 0
}

```
> *Result: `a = 0` `a = 1` `a = 2` `a = 3` `a = 4` `a = 5` `a = 6` `a = 7` `a = 8` `a = 9` 

```swift

const nMax = 10

func main () -> Unit {
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

