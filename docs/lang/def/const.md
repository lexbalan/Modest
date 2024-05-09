# Constant Definition

Constant definition bounds an *identifier* with an [*immediate value*](../value/README.md) (*value aliasing*).

#### Common form

```
let <#identifier#> = <#immediate_value_expression#>
```

> <#value_expression#> must be immediate


#### Examples

```zig
let one = 1
let two = one + 1
let three = one + two
let four = two * 2
```



```zig
let message = "Hello World!\n"

func main () -> Int32 {
	printf("%s\n", message)
	return 0
}
```
