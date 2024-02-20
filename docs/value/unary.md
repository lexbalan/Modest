
# Unary Value Expressions


- [*Not* operation](#Not)
- [*Neg* operation](#Neg)
- [*Ref* operation](#Ref)
- [*Deref* operation](#Deref)


#### Common form
```
    <operator> <argument_value_expression>
```


### Not

**Logical form** *(Requires Bool argument)*
Returns ***true*** when *argument* is ***false***, otherwise returns ***false***.

**Bitwise form** *(Requires Integer or Bool argument)*

> Valid argument type: [*Bool*](../types.md#Bool-type), [*Byte*](../types.md#Byte-type), [*Integer*](../types.md#Integer-type)

```zig
    not x
```

### Neg
Returns ***true*** when *left* is **not equal** to the *right*, otherwise returns ***false***.

> Valid argument type: [*Integer*](../types.md#Integer-type), [*Float*](../types.md#Float-type)

```zig
    -x
```

### Ref
Returns pointer to type(argument).

```zig
    &x
```

### Deref
Returns the value pointed to by the argument

> Valid argument type: [*Pointer*](../types.md#Pointer-type)

```zig
    *x
```

