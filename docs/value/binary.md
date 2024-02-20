
# Binary Value Expressions

* Binary value experssion received two arguments and returns result of operation.
* All binary operations require that type(left) == type(right) (Only exception - ShL & ShR operations).


- [*Equality* operations](#Equality-operations)
- [*Comparison* operations](#Comparison-operations)
- [*Arithmetical* operations](#Arithmetical-operations)
- [*Logical and Bitwise* operations](#Logical-and-Bitwise-operations)
- [*Shift* operations](#Bitwise-operations)




#### Common form
```
    <left_value_expression> <operator> <right_value_expression>
```


## *Equality* operations

Requires that **type(*left*)** will be equal to **type(*right*)**. Result type is [***Bool***](../types.md#Bool-type). 

> Valid arguments type: [*Bool*](../types.md#Bool-type), [*Byte*](../types.md#Byte-type), [*Char*](../types.md#Char-type), [*Integer*](../types.md#Integer-type), [*Float*](../types.md#Float-type), [*Array*](../types.md#Array-type), [*Record*](../types.md#Record-type), [*Pointer*](../types.md#Pointer-type)

### Eq (Equal)
Returns ***true*** when *left* is **equal** to the *right*, otherwise returns ***false***.

```zig
    a == b
```

### NE (Not Equal)
Returns ***true*** when *left* is **not equal** to the *right*, otherwise returns ***false***.

```zig
    a != b
```


## *Comparison* operations
Requires that **type(*left*)** will be equal to **type(*right*)**. Result type is [***Bool***](../types.md#Bool-type). 

> Valid arguments type: [*Integer*](../types.md#Integer-type), [*Float*](../types.md#Float-type)

### LT (Less Than)
Returns ***true*** when *left* is **less than** *right*, otherwise returns ***false***.

```zig
    a < b
```

### GT (Greater Than)
Returns ***true*** when *left* is **greater than** *right*, otherwise returns ***false***.
```zig
    a > b
```

### LE (Greater than or Equal)
Returns ***true*** when *left* is **greater than or equal** *right*, otherwise returns ***false***.
```zig
    a <= b
```

### GE (Less than or Equal)
Returns ***true*** when *left* is **less than or equal** *right*, otherwise returns ***false***.
```zig
    a >= b
```


# *Arithmetical* operations
Requires that **type(*left*)** will be equal to **type(*right*)**. Result type will the same as type of received arguments.

> Valid arguments type: [*Integer*](../types.md#Integer-type), [*Float*](../types.md#Float-type)

### Add (addition)
Returns ***sum*** of *left* and *right* arguments.

```zig
    a + b
```

### Sub (subtraction)
Returns difference between *left* and *right* arguments.
```zig
    a - b
```

### Mul (multiplication)
Returns multiplication result of *left* and *right* arguments.
```zig
    a * b
```

### Div (division)
Returns the result of dividing the *left* argument by the *right* argument.
```zig
    a / b
```

### Rem (remainder of the division)
Returns the remainder of dividing the *left* argument by the *right* argument.
```zig
    a % b
```


## *Logical and Bitwise* operations
Is *Logical* when arguments type is Bool, otherwise is *Bitwise*. Requires that **type(*left*)** will be equal to **type(*right*)**. Result type will the same as type of received arguments.

> Valid arguments type: [*Bool*](../types.md#Bool-type), [*Byte*](../types.md#Byte-type), [*Integer*](../types.md#Integer-types)

### Or
Returns result of ***or*** operation between *left* and *right* arguments.

```zig
    a or b
```

### And
Returns result of ***and*** operation between *left* and *right* arguments.
```zig
    a and b
```

### XOR
Returns result of ***xor*** operation between *left* and *right* arguments.
```zig
    a xor b
```


# *Shift* operations

Result type will the same as *left* argument type.

> Valid left argument type: [*Byte*](../types.md#Byte-type), [*Integer*](../types.md#Integer-type)

> Valid right argument type: [*Integer*](../types.md#Integer-type)

### ShL (Shift to the Left)

Allow that type(left) will not be equal to type(right).

```zig
    a << b
```

> type(a) can be different from type(b)

### ShR (Shift to the Right)

Allow that type(left) will not be equal to type(right). 

```zig
    a >> b
```

> type(a) can be different from type(b)
