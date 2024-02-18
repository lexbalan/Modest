
# Value Expression Index


```zig

const arrayLength = 5

var array: [arrayLength]Int32 = [1, 2, 3, 4, 5]


func main() -> Int {
    var i = 0
    while i < arrayLength {
        // index array
        let array_item = array[i]
    
        printf("array[%i] = %i", i, array_item)
        ++i
    }
    retutn 0
}
```

