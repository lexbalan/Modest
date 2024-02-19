
# Binary Value Expressions


* All binary operations require that type(left) == type(right). (Only exception - ShL & ShR operations)
* For all binary operations type of result is type of arguments. (Exception - ShL & ShR operations, when result type is type(left) and comparison operations, when result type is always [*Bool*](../../types.md#Bool-type))


## *Equality* operations

Requires that **type(*left*)** will be equal to **type(*right*)**. Result type is [***Bool***](../../types.md#Bool-type). 

> Valid arguments type: [*Bool*](../../types.md#Bool-type), [*Byte*](../../types.md#Byte-type), [*Char*](../../types.md#Char-type), [*Integer*](../../types.md#Integer-type), [*Float*](../../types.md#Float-type), [*Array*](../../types.md#Array-type), [*Record*](../../types.md#Record-type), [*Pointer*](../../types.md#Pointer-type)

### Eq (Equal)
Returns ***true*** when *left* is **equal** to the *right*, otherwise returns ***false***.

```zig
    let x = a == b
```

### NE (Not Equal)
Returns ***true*** when *left* is **not equal** to the *right*, otherwise returns ***false***.

```zig
    let x = a != b
```


## *Comparison* operations
Requires that **type(*left*)** will be equal to **type(*right*)**. Result type is [***Bool***](../../types.md#Bool-type). 

> Valid arguments type: [*Integer*](../../types.md#Integer-type), [*Float*](../../types.md#Float-type)

### LT (Less Than)
Returns ***true*** when *left* is **less than** *right*, otherwise returns ***false***.

```zig
    let x = a < b
```

### GT (Greater Than)
Returns ***true*** when *left* is **greater than** *right*, otherwise returns ***false***.
```zig
    let x = a > b
```

### LE (Greater than or Equal)
Returns ***true*** when *left* is **greater than or equal** *right*, otherwise returns ***false***.
```zig
    let x = a <= b
```

### GE (Less than or Equal)
Returns ***true*** when *left* is **less than or equal** *right*, otherwise returns ***false***.
```zig
    let x = a >= b
```


# *Arithmetical* operations
Arithmetical operation requires that **type(*left*)** will be equal to **type(*right*)**. Result type will the same as type of received arguments.

> Valid arguments type: [*Integer*](../../types.md#Integer-type), [*Float*](../../types.md#Float-type)

### Add (addition)
Returns ***sum*** of *left* and *right* arguments.

```zig
    let x = a + b
```

### Sub (subtraction)
Returns difference between *left* and *right* arguments.
```zig
    let x = a - b
```

### Mul (multiplication)
Returns multiplication result of *left* and *right* arguments.
```zig
    let x = a * b
```

### Div (division)
Returns the result of dividing the *left* argument by the *right* argument.
```zig
    let x = a / b
```

### Rem (remainder of the division)
Returns the remainder of dividing the *left* argument by the *right* argument.
```zig
    let x = a % b
```


## *Logical & Bitwise* operations
Is *Logical* when arguments are Bool, otherwise is *Bitwise*. Requires that **type(*left*)** will be equal to **type(*right*)**. Result type will the same as type of received arguments.

> Valid arguments type: [*Bool*](../../types.md#Bool-type), [*Byte*](../../types.md#Byte-type), [*Integer*](../../types.md#Integer-types)

### Or
Returns result of ***or*** operation between *left* and *right* arguments.

```zig
    let x = a or b
```

### And
Returns result of ***and*** operation between *left* and *right* arguments.
```zig
    let x = a and b
```

### XOR
Returns result of ***xor*** operation between *left* and *right* arguments.
```zig
    let x = a xor b
```


# *Bitwise* operations

> Valid arguments type: [*Byte*](../../types.md#Byte-type), [*Integer*](../../types.md#Integer-type)

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

