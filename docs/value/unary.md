
# Unary Value Expressions


- [*Not* operations](#Not)
- [*Neg* operations](#Neg)
- [*Ref*](#Ref)
- [*Deref*](#Deref)


#### Common form
```
    <operator> <value_expression>
```


### Not

**Logical form** *(Requires Bool argument)*
Returns ***true*** when *argument* is ***false***, otherwise returns ***false***.

**Bitwise form** *(Requires Integer or Bool argument)*

> Valid arguments type: [*Bool*](../types.md#Bool-type), [*Byte*](../types.md#Byte-type), [*Integer*](../types.md#Integer-type)

```zig
    not x
```

### Neg
Returns ***true*** when *left* is **not equal** to the *right*, otherwise returns ***false***.

```zig
    - x
```

### Ref
Returns pointer to type(argument).

```zig
    &x
```

### Deref
Returns the value pointed to by the argument

> Valid arguments type: [*Pointer*](../types.md#Pointer-type)

```zig
    *x
```

