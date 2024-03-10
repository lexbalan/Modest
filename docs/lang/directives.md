# Compiler Directives


## Conditional Compilation

*Conditional compilation* directives allows to activate/deactivate top level code dependently of some conditions. This conditions must be immediate value expressions with Bool type.

### Common form

```
@if <# value_expression #>
    // code activated only when value_expression is true
@endif
```

```
@if <# value_expression #>
    // code activated
    // only when value_expression is true
@else
    // code activated
    // only when value_expression is false
@endif
```

```
@if <# value_expression_1 #>
    // code activated
    // only when value_expression_1 is true
@elseif <# value_expression_2 #>
    // code activated 
    // only when value_expression_1 is false
    // and value_expression_2 is true
@endif
```

```
@if <# value_expression_1 #>
    // code activated
    // only when value_expression_1 is true
@elseif <# value_expression_2 #>
    // code activated
    // only when value_expression_1 is false
    // and value_expression_2 is true
...
@elseif <# value_expression_n #>
    // code activated
    // only when all value_expressions before are false
    // and value_expression_n is true
@else
    // code activated
    // only when all value_expressions are false
@endif
```

### Examples

```zig
const __SYSTEM = 64

@if __SYSTEM == 32:
import "./system32"
@elseif __SYSTEM == 64:
import "./system64"
@elseif __SYSTEM == 128:
import "./system128"
@else
@error("system not implemented")
@endif
```


## Compiler messages

```zig
@info("this is info message")
@warning("this is warning message")
@error("this is error message")
```

## Attributes & Properties

```zig
@attribute("value:volatile")
var byteFromUart: Byte
```

```zig
@property("c_alias", "int")
type Int Int32
```


## Pragmas

```zig
// this pragma makes compiler to
// not print include directive for this file
@pragma("not_included")
```

## Compiler Feature
Enable compiler feature for curent source file (analog of *-f* compiler option)
```
@feature("unsafe")
@feature("unsafe-downcast")
@feature("unsafe-int-to-ptr")
@feature("unsafe-ptr-to-int")
...
```


