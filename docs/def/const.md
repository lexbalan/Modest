# Constant Definition

Constant definition bounds an *identifier* with an [*immediate value*](../value/README.md).

#### Common form

```
const <#identifier#> = <#value_expression#>
```

> <#value_expression#> must be immediate


```zig
// the 'const' directive creates an alias for value expression result
// (in this case - identifier 'four' with value '4')
const four = 2 + 2
```

#### Examples

```zig
const message = "Hello World!\n"

func main () -> Unit {
  printf("%s\n", message)
}
```
