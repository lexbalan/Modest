
# Binary Value Expressions


* All binary operations require that type(left) == type(right). (Only exception - ShL & ShR operations)
* For all binary operations type of result is type of arguments. (Exception - ShL & ShR operations, when result type is type(left) and comparison operations, when result type is always [*Bool*](../../types.md#Bool-type))



### Or (logical & bitwise)
```zig
    let x = a or b
```

### And (logical & bitwise)
```zig
    let x = a and b
```

### XOR (eXclude Or) (logical & bitwise)
```zig
    let x = a xor b
```

### Eq (Equal)
Comparison operation. Result value type is [***Bool***](../../types.md#Bool-type). Returns ***true*** when *left* is **equal** to the *right*, otherwise returns ***false***.
You also can check for equality [***Array***](../../types.md#Array-type) and [***Record***](../../types.md#Record-type) values.
```zig
    let x = a == b
```

### NE (Not Equal)
Similar to the [equality-comparison operator](#Eq-Equal), but returns ***true*** when *left* is **not equal** to the *right*, otherwise returns ***false***.
```zig
    let x = a != b
```

### LT (Less Than)
Comparison operation. Result value type is [***Bool***](../../types.md#Bool-type). Returns ***true*** when *left* is **less than** *right*, otherwise returns ***false***.
```zig
    let x = a < b
```

### GT (Greater Than)
Comparison operation. Result value type is [***Bool***](../../types.md#Bool-type). Returns ***true*** when *left* is **greater than** *right*, otherwise returns ***false***.
```zig
    let x = a > b
```

### LE (Greater than or Equal)
Comparison operation. Result value type is [***Bool***](../../types.md#Bool-type). Returns ***true*** when *left* is **greater than or equal** *right*, otherwise returns ***false***.
```zig
    let x = a <= b
```

### GE (Less than or Equal)
Comparison operation. Result value type is [***Bool***](../../types.md#Bool-type). Returns ***true*** when *left* is **less than or equal** *right*, otherwise returns ***false***.
```zig
    let x = a >= b
```

### Add (addition)
Arithmetical operation. Requires that **type(*left*)** will be equal to **type(*right*)**. Result value type will the same as type of received arguments. Returns ***sum*** of *left* and *right* arguments.
```zig
    let x = a + b
```

### Sub (subtraction)
Arithmetical operation. Similar to the [Add](#Add-addition), but returns difference between *left* and *right* arguments.
```zig
    let x = a - b
```

### Mul (multiplication)
Arithmetical operation. Similar to the [Add](#Add-addition), but returns multiplication result of *left* and *right* arguments.
```zig
    let x = a * b
```

### Div (division)
Arithmetical operation. Similar to the [Add](#Add-addition), but returns the result of dividing the *left* argument by the *right* argument.
```zig
    let x = a / b
```

### Rem (remainder of the division)
Arithmetical operation. Similar to the [Add](#Add-addition), but returns the remainder of dividing the *left* argument by the *right* argument.
```zig
    let x = a % b
```

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

