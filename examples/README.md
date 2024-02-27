# Examples

### Hello World

```zig
// see: examples/1.hello_world/src/main.cm

import "libc/stdio"

func main() -> Int {
    printf("Hello World!\n")
    return 0
}
```

### Multiply table

```zig
// see: examples/3.multiply_table/src/main.cm

import "libc/stdio"


func mtab(n: Int32) -> Unit {
    var m: Nat32 = 1
    while m < 10 {
        let nm = n * m
        printf("%d * %d = %d\n", n, m, nm)
        // there is only prefix form of ++
        // and it is Statement (!)
        ++m
    }
}


func main() -> Int32 {
    let n = 2 * 2
    printf("multiply table for %d\n", n)
    mtab(n)
    return 0
}

```


