# Compiler Directives


### Conditional Compilation


```
@if <# condition_value_expression #>
    // code activated only when condition_value_expression is true
@endif
```

```
@if <# condition_value_expression1 #>
    // code activated only when condition_value_expression is true
@else
    // code activated only when condition_value_expression is false
@endif
```

```
@if <# condition_value_expression_1 #>
    // code activated only when condition_value_expression_1 is true
@elseif <# condition_value_expression_2 #>
    // code activated 
    // only when condition_value_expression_1 is false
    // and condition_value_expression_2 is true
@endif
```

```
@if <# condition_value_expression_1 #>
    // code activated only when condition_value_expression_1 is true
@elseif <# condition_value_expression_2 #>
    // code activated
    // only when condition_value_expression_1 is false
    // and condition_value_expression_2 is true
...
@elseif <# condition_value_expression_n #>
    // code activated
    // only when all condition_value_expressions before are false
    // and condition_value_expression_n is true
@else
    // code activated only when all condition_value_expressions are false
@endif
```

#### Example

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


### Compiler messages

```zig
@info("this is info message")
@warning("this is warning message")
@error("this is error message")
```

### Attributes & Properties

```zig
@attribute("value:volatile")
var byteFromUart: Byte
```

```zig
@property("c_alias", "int")
type Int Int32
```


### Pragmas

```zig
// this pragma makes compiler to
// not print include directive for this file
@pragma("not_included")
```

### Feature
Enable compiler feature for curent source file (analog of *-f* compiler option)
```
@feature("unsafe")
@feature("unsafe-downcast")
@feature("unsafe-int-to-ptr")
@feature("unsafe-ptr-to-int")
...
```