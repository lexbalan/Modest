
# Value Expression Index

```
    // index of array value
    <array_value>[<index_value>]

    // index of pointer to array value
    <pointer_to_array_value>[<index_value>]
```

### Examples

##### Array Index

```zig

const arrayLength = 5

var array: [arrayLength]Int32 = [1, 2, 3, 4, 5]


func main() -> Int {
    var i = 0
    while i < arrayLength {
        // index array
        let array_item = array[i]
    
        printf("array[%i] = %i\n", i, array_item)
        ++i
    }
    retutn 0
}
```

##### Pointer to Array Index

```zig

const arrayLength = 5

var array: [arrayLength]Int32 = [1, 2, 3, 4, 5]

var ptr_to_array = &array

func main() -> Int {
    var i = 0
    while i < arrayLength {
        // index pointer to array
        let array_item = ptr_to_array[i]

        printf("ptr_to_array[%i] = %i\n", i, array_item)
        ++i
    }
    retutn 0
}
```
