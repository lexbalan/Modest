# While statement


#### Common view

```zig
    while condition {
        // do something while condition != 0
    }
```

#### Examples

```zig

const nMax = 10

func main () -> Unit {
    // input n
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
    var i = 0
    while i < n {
        printf("i = %d\n", i)
    }
}
```
