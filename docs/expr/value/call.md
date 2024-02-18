

```zig
func function_1() -> Unit {
    //
}

func function_2(x: Int32) {
    //
}

func function_3(x: Int32) -> Int32 {
    //
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
}
```
