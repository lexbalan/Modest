# If statement

#### Common view

```zig
  if condition {
    // do something if condition != 0
  }
```

#### Examples

```zig
// see: examples/stmt_if/src/main.cm

import "libc/stdio"


func main() -> Int {
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
