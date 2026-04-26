# Function Types

Function types in Modest represent the type of a function

> There is no way to create field with function type, but we can use pointer to function

## Syntax

A function type is defined by its parameters and return type:

```modest
(param1: Type1, param2: Type2, ...) -> ReturnType
```

## Examples

### Basic Function Types

```modest
// Function with no parameters, returns Int32
() -> Int32

// Function with two Int32 parameters, returns Int32
(a: Int32, b: Int32) -> Int32

// Function with parameters of different types, returns Unit
(name: *[]Char8, age: Int32) -> Unit

// Function with multiple parameters
(x: Float64, y: Float64, z: Float64) -> Float64
```

## Usage

### Function Pointers

Store a function as a variable:

```modest
import "libc/stdio"

func add (a: Int32, b: Int32) -> Int32 {
    return a + b
}

func main () -> Int32 {
    var op: *(Int32, Int32) -> Int32 = &add
    var result = op(5, 3)  // calls add(5, 3)
    printf("Result: %d\n", result)
    return 0
}
```

### Function as Parameter

Pass a function to another function:

```modest
import "libc/stdio"

func apply_operation (a: Int32, b: Int32, op: *(Int32, Int32) -> Int32) -> Int32 {
    return op(a, b)
}

func multiply (a: Int32, b: Int32) -> Int32 {
    return a * b
}

func main () -> Int32 {
    var result = apply_operation(4, 5, &multiply)
    printf("Result: %d\n", result)  // prints: Result: 20
    return 0
}
```

### Function as Return Type

Return a function from a function:

```modest
func get_operation (op_type: Int32) -> *(Int32, Int32) -> Int32 {
    if op_type == 1 {
        return &add
    } else {
        return &multiply
    }
}

func add (a: Int32, b: Int32) -> Int32 {
    return a + b
}

func multiply (a: Int32, b: Int32) -> Int32 {
    return a * b
}
```

## Variadic Functions

Function types can include variadic parameters using `...`:

```modest
func printf (format: *[]Char8, ...) -> Int32
```

## Related Types

- **[Pointer Types](./POINTER.md)** - Function types are often used with pointers
- **[Record Types](./RECORD.md)** - Can contain function types as fields
- **[Type System Overview](./README.md)** - Learn about other type kinds

## See Also

- [Function Definitions](../def/FUNC.md) - How to define functions
- [Cheatsheet - Functions](../CHEATSHEET.md) - Quick reference for function syntax
