# Compiler Directives


### Conditional Compilation

```zig
const __SYSTEM = 64

@if __SYSTEM == 32:
import "./system32.hm"
@elseif __SYSTEM == 64:
import "./system64.hm"
@elseif __SYSTEM == 128:
import "./system128.hm"
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
@property("newtype.c_alias", "int")
type Int Int32
```



