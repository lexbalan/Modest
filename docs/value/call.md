
# *Call* value expression


### Common form
```
    <func_value>(<arglist>)
    <pointer_to_func_value>(<arglist>)
```

### Examples

#### Call by func value

```zig
func function_1() -> Unit {
    printf("function_1()\n")
}

func function_2(x: Int32) {
    printf("function_2(%i)\n", x)
}

func function_3(x: Int32) -> Int32 {
    printf("function_3(%i)\n", x)
    return x + 1
}

func main() -> Int {
    // just call
    function_1()

    // call with one argument
    function_2(42)

    // call with one argument
    // and print result value
    let y = function_3(42)
    print("function_3 returns %i\n", y)

    return 0
}
```


#### Call by pointer to func value

```zig
func function_1() -> Unit {
    printf("function_1()\n")
}

func function_2(x: Int32) {
    printf("function_2(%i)\n", x)
}

func function_3(x: Int32) -> Int32 {
    printf("function_3(%i)\n", x)
    return x + 1
}


var ptr_to_function_1: () -> Unit
var ptr_to_function_2: (x: Int32) -> Unit
var ptr_to_function_3: (x: Int32) -> Int32

// or variant with type inference:
// var ptr_to_function_1 = &function_1
// var ptr_to_function_2 = &function_2
// var ptr_to_function_3 = &function_3


func main() -> Int {

    ptr_to_function_1 = &function_1
    ptr_to_function_2 = &function_2
    ptr_to_function_3 = &function_3

    // just call by pointer
    ptr_to_function_1()

    // call by pointer with one argument
    ptr_to_function_2(42)

    // call by pointer with one argument
    // and print result value
    let func3_arg = 42
    let y = ptr_to_function_3(func3_arg)
    print("ptr_to_function_3(%i) returns %i\n", func3_arg, y)

    return 0
}
```

