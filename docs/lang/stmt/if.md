# If statement

#### Common form

```
    if <#bool_value_expression#> {
        // do something if condition is true
    }
```

```
    if <#bool_value_expression#> {
        // do something if condition is true
    } else {
        // do something if condition is false
    }
```

```
    if <#bool_value_expression_1#> {
        // do something if condition_1 is true
    } else if <#bool_value_expression_2#> {
        // do something if condition_1 is false and condition_2 is true

    ...

    } else {
        // do something if condition is false
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
