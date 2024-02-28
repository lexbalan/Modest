# Constant Definition

#### Common form

```
const <#identifier#> = <#value_expression#>
```

> value_expression must be immediate


```zig
// the 'const' directive creates an alias for value expression result
// (in this case - four with value 4)
const four = 2 + 2
```

#### Examples

```zig
const message = "Hello World!\n"

func main () -> Unit {
  printf("%s\n", message)
}
```
