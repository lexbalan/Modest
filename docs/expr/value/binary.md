
# Binary Value Expressions


* All binary operations require that type(left) == type(right). (Only exception - ShL & ShR operations)
* For all binary operations type of result is type of arguments. (Exception - ShL & ShR operations, when result type is type(left) and comparison operations, when result type is always [*Bool*](../../types.md#Bool-type))



## *Logical & Bitwise* operations

> Valid types for *Logical & Bitwise operations*: [*Bool*](../../types.md#Bool-type), [*Byte*](../../types.md#Byte-type), [*Integer*](../../types.md#Integer-types)

### Or
Is *Logical* when arguments are Bool, otherwise is *Bitwise*. Requires that **type(*left*)** will be equal to **type(*right*)**. Result type will the same as type of received arguments. Returns result of ***or*** operation between *left* and *right* arguments.

```zig
    let x = a or b
```

### And
Similar to the [Or](#Or-logical-bitwise), but returns result of ***and*** operation between *left* and *right* arguments.
```zig
    let x = a and b
```

### XOR
Similar to the [Or](#Or-logical-bitwise), but returns result of ***xor*** operation between *left* and *right* arguments.
```zig
    let x = a xor b
```


## *Equality* operations

> Valid types for *Equality operations*: [*Bool*](../../types.md#Bool-type), [*Byte*](../../types.md#Byte-type), [*Char*](../../types.md#Char-type), [*Integer*](../../types.md#Integer-type), [*Float*](../../types.md#Float-type), [*Array*](../../types.md#Array-type), [*Record*](../../types.md#Record-type), [*Pointer*](../../types.md#Pointer-type)

### Eq (Equal)
Requires that **type(*left*)** will be equal to **type(*right*)**. Result type is [***Bool***](../../types.md#Bool-type). Returns ***true*** when *left* is **equal** to the *right*, otherwise returns ***false***.
You also can check for equality [***Array***](../../types.md#Array-type) and [***Record***](../../types.md#Record-type) values.

```zig
    let x = a == b
```

### NE (Not Equal)
Similar to the [equality-comparison operator](#Eq-Equal), but returns ***true*** when *left* is **not equal** to the *right*, otherwise returns ***false***.
```zig
    let x = a != b
```


## *Comparison* operations

> Valid types for *Comparison operations*: [*Integer*](../../types.md#Integer-type), [*Float*](../../types.md#Float-type)

### LT (Less Than)
Requires that **type(*left*)** will be equal to **type(*right*)**. Result type is [***Bool***](../../types.md#Bool-type). Returns ***true*** when *left* is **less than** *right*, otherwise returns ***false***.

```zig
    let x = a < b
```

### GT (Greater Than)
Similar to the [LT](#LT-Less-Than), but returns ***true*** when *left* is **greater than** *right*, otherwise returns ***false***.
```zig
    let x = a > b
```

### LE (Greater than or Equal)
Similar to the [LT](#LT-Less-Than), but returns ***true*** when *left* is **greater than or equal** *right*, otherwise returns ***false***.
```zig
    let x = a <= b
```

### GE (Less than or Equal)
Similar to the [LT](#LT-Less-Than), but returns ***true*** when *left* is **less than or equal** *right*, otherwise returns ***false***.
```zig
    let x = a >= b
```


# *Arithmetical* operations

> Valid types for *Arithmetical operations*: [*Integer*](../../types.md#Integer-type), [*Float*](../../types.md#Float-type)

### Add (addition)
Requires that **type(*left*)** will be equal to **type(*right*)**. Result type will the same as type of received arguments. Returns ***sum*** of *left* and *right* arguments.

```zig
    let x = a + b
```

### Sub (subtraction)
Similar to the [Add](#Add-addition), but returns difference between *left* and *right* arguments.
```zig
    let x = a - b
```

### Mul (multiplication)
Similar to the [Add](#Add-addition), but returns multiplication result of *left* and *right* arguments.
```zig
    let x = a * b
```

### Div (division)
Similar to the [Add](#Add-addition), but returns the result of dividing the *left* argument by the *right* argument.
```zig
    let x = a / b
```

### Rem (remainder of the division)
Similar to the [Add](#Add-addition), but returns the remainder of dividing the *left* argument by the *right* argument.
```zig
    let x = a % b
```


# *Bitwise* operations

> Valid types for *Bitwise operations*: [*Byte*](../../types.md#Byte-type), [*Integer*](../../types.md#Integer-type)

### ShL (Shift to the Left)

```zig
    let x = a << b
```

> type(a) can be different from type(b)

### ShR (Shift to the Right)

```zig
    let x = a >> b
```

> type(a) can be different from type(b)

