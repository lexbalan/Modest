
# *Access* value expression


### Common form
```
    <record_value>.<field_identifier>
    <pointer_to_record_value>.<field_identifier>
```

### Examples

#### Access by value

```zig
import "libc/stdio.hm"

type Point record {
    x: Int32
    y: Int32
}

func main() -> Int32 {
    // create local instance of Point
    var point: Point
    
    // assign values to record fields
    // ('access operation' (by value) as lvalue)
    point.x = 10
    point.y = 20
    
    // read record fields
    // ('access operation' (by value) as rvalue)
    let x = point.x
    let y = point.y
    
    // print x & y for checking
    printf("x = %i\n", x)
    printf("y = %i\n", y)
    
    return 0
}
```

> Result: `x = 10` `y = 20`

#### Access by pointer to value

```zig
import "libc/stdio.hm"

type Point record {
    x: Int32
    y: Int32
}

var point: Point

// create pointer to var point
var pointer_to_point: *Point


func main() -> Int32 {
    pointer_to_point = &point
    
    // or variant with type inference:
    // var pointer_to_point = &point
    
    // assign values to record fields
    // ('access operation' (by pointer) as lvalue)
    pointer_to_point.x = 10
    pointer_to_point.y = 20
    
    // read record fields
    // ('access operation' (by pointer) as rvalue)
    let x = pointer_to_point.x
    let y = pointer_to_point.y
    
    // print x & y for checking
    printf("x = %i\n", x)
    printf("y = %i\n", y)
    
    return 0
}
```

> Result: `x = 10` `y = 20`

