# Array Types

Arrays in Modest represent a collection of elements of the same type. Modest supports fixed-size arrays, open arrays (dynamically-sized), and multi-dimensional arrays.

## Syntax

### Fixed-Size Array

An array with a known size at compile time:

```modest
[n]Type                    // where n is a compile-time constant
[10]Int32                  // array of 10 integers
[5][3]Float64              // 5x3 matrix of floats
```

### Open Array

An array with size shall be inferred at compile time:

```modest
[]Type                     // size determined at compile time
[][]Int32                  // jagged array of integers
```

### Pointer to Array

Used for passing arrays to functions or working with dynamic arrays:

```modest
*[]Type                    // pointer to array of unknown length
*[n]Type                   // pointer to fixed array of size n
```

## Literals

### Array Construction

```modest
[1, 2, 3, 4, 5]                    // implicit type inference
[]Int32 [1, 2, 3]                  // infered type is [3]Int32
[4]Str8 ["a", "b", "c", "d"]       // fixed-size with values
```

### Empty Arrays

```modest
var arr: []Int32           // open array, uninitialized
```

## Indexing and Access

### Single Element Access

```modest
var arr: [5]Int32 = [1, 2, 3, 4, 5]
var first = arr[0]         // 1
var last = arr[4]          // 5
```

### Slicing

Get a sub-array from an array:

```modest
var arr: [10]Int32 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

// we get copies of the original array
var slice1 = arr[1..3]     // [1, 2]
var slice2 = arr[0..5]     // [0, 1, 2, 3, 4]

// we get pointers to subarrays inside the original array (!)
var pslice1 = &arr[1..3]
var pslice2 = &arr[0..5]
```

### Array Length

```modest
lengthof([5]Int32)         // 5 (type)
lengthof(arr)              // actual length (value)
sizeof([10]Int32)          // total size in bytes
```

## Examples

### Fixed-Size Array

```modest
import "libc/stdio"

public func main () -> Int32 {
    var arr: [5]Int32 = [10, 20, 30, 40, 50]
    
    var i: Int32 = 0
    while i < 5 {
        printf("%d\n", arr[i])
        ++i
    }
    
    return 0
}
```

### Open Array (Unknown Size)

```modest
import "libc/stdio"
import "libc/stdlib"

func print_array (data: *[]Int32, length: Nat32) -> Unit {
    var i: Int32 = 0
    while i < length {
        printf("%d ", data[i])
        ++i
    }
    printf("\n")
}

public func main () -> Int32 {
    var arr: []Int32 = [1, 2, 3, 4, 5]
    print_array(&arr, lengthof(arr))
    return 0
}
```

### Multi-Dimensional Arrays

```modest
import "libc/stdio"

public func main () -> Int32 {
    var matrix: [2][3]Int32 = [[1, 2, 3], [4, 5, 6]]
    
    var i: Int32 = 0
    while i < 2 {
        var j: Int32 = 0
        while j < 3 {
            printf("%d ", matrix[i][j])
            ++j
        }
        printf("\n")
        ++i
    }
    
    return 0
}
```

### Jagged Arrays (Array of Pointers)

```modest
import "libc/stdio"

var strings: []*Str8 = ["Hello", "World", "Modest"]

public func main () -> Int32 {
    var i: Int32 = 0
    while i < 3 {
        printf("%s\n", strings[i])
        ++i
    }
    return 0
}
```

### Dynamic Arrays with `new`

```modest
import "libc/stdio"

func fill_array (arr: *[]Byte, size: Nat32, pattern: Byte) -> Unit {
    var i: Nat32 = 0
    while i < size {
        arr[i] = pattern
        ++i
    }
}

public func main () -> Int32 {
    let size = 1024
    let memory = new [size]Byte []
    
    fill_array(&memory, size, 0xFF)
    
    printf("Filled %d bytes\n", size)
    return 0
}
```

### Strings as Arrays

Strings in Modest are arrays of characters:

```modest
import "libc/stdio"

public func main () -> Int32 {
    var str: []Char8 = "Hello"
    var c: Char8 = str[0]  // 'H'
    
    var i: Int32 = 0
    while i < 5 {
        printf("%c", str[i])
        ++i
    }
    printf("\n")
    
    return 0
}
```

## Array Attributes

### Zero-Terminated Arrays

Use `@zarray` attribute for C-compatible strings:

```modest
var str: @zarray []Char8 = "hello"   // null-terminated
var builtin: Str8 = "world"          // Str8 is @zarray by default
```

## Important Notes

> Pointers do not work like arrays in C. For indexing into a pointer, you need a pointer to an array: `*[]Type`

> Array bounds are NOT checked at runtime - out-of-bounds access is undefined behavior

## Related Types

- **[Pointer Types](./POINTER.md)** - Often used with arrays
- **[String Handling](./SIMPLE.md)** - Strings as character arrays
- **[Type System Overview](./README.md)** - Learn about other type kinds

## See Also

- [Index Operations](../value/INDEX.md) - Array indexing details
- [Slice Operations](../value/SLICE.md) - Array slicing details
- [Cheatsheet - Arrays](../CHEATSHEET.md) - Quick reference
