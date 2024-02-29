# Constant Definition

Constant definition bounds an *identifier* with an [*immediate value*](../value/README.md).

#### Common form

```
const <#identifier#> = <#immediate_value_expression#>
```

> <#value_expression#> must be immediate


#### Examples

```zig
const one = 1
const two = one + 1
const three = one + two
const four = two * 2
```



```zig
const message = "Hello World!\n"

func main () -> Int32 {
    printf("%s\n", message)
    return 0
}
```
