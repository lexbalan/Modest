
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
Comparison operation. Result value type is [***Bool***](../../types.md#Bool-type). Returns ***true*** when *left* argument is **equal** to the *right*, otherwise returns ***false***.
You also can check for equality [***Array***](../../types.md#Array-type) and [***Record***](../../types.md#Record-type) values.
```zig
    let x = a == b
```

### NE (Not Equal)
Similar to the [equality-comparison operator](#Eq-Equal), but returns ***true*** when *left* argument is **not equal** to the *right*, otherwise returns ***false***.
```zig
    let x = a != b
```

### LT (Less Than)
Comparison operation. Result value type is [***Bool***](../../types.md#Bool-type). Returns ***true*** when *left* argument is **less than** *right*, otherwise returns ***false***.
```zig
    let x = a < b
```

### GT (Greater Than)
Comparison operation. Result value type is [***Bool***](../../types.md#Bool-type). Returns ***true*** when *left* argument is **greater than** *right*, otherwise returns ***false***.
```zig
    let x = a > b
```

### LE (Greater than or Equal)
Comparison operation. Result value type is [***Bool***](../../types.md#Bool-type). Returns ***true*** when *left* argument is **greater than or equal** *right*, otherwise returns ***false***.
```zig
    let x = a <= b
```

### GE (Less than or Equal)
Comparison operation. Result value type is [***Bool***](../../types.md#Bool-type). Returns ***true*** when *left* argument is **less than or equal** *right*, otherwise returns ***false***.
```zig
    let x = a >= b
```

### Add (addition)
```zig
    let x = a + b
```

### Sub (subtraction)
```zig
    let x = a - b
```

### Mul (multiplication)
```zig
    let x = a * b
```

### Div (division)
```zig
    let x = a / b
```

### Rem (remainder of the division)
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

