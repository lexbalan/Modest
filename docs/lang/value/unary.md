
# Unary Value Expressions


#### Common form
```
<#operator#> <#argument_value_expression#>
```

#### Brief

| Operation | Code Example | Valid types | Result type | Comment |
| :-------: | :----------: | :---------: | :---------: | :-----: |
| [*Not*](#Not) | `not arg` | Bool, Word8, Integer | ***type***(*arg*) | |
| [*Neg*](#Neg) | `-arg` | Integer, Float | ***type***(*arg*) | |
| [*Ref*](#Ref) | `&arg` | *Any* | Pointer to ***type***(*arg*)| |
| [*Deref*](#Deref) | `*arg` | Pointer | ***type***(*arg*)#to | |



### Not

**Logical form** *(Requires Bool argument)*
Returns ***true*** when *argument* is ***false***, otherwise returns ***false***.

**Bitwise form** *(Requires Integer or Bool argument)*

> Valid argument type: [*Bool*](../types.md#Bool-type), [*Word8*](../types.md#Word8-type), [*Integer*](../types.md#Integer-type)

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
Returns pointer to ***type***(*argument*)

```zig
	&x
```

### Deref
Returns the value pointed to by the argument

> Valid argument type: [*Pointer*](../types.md#Pointer-type)

```zig
	*x
```

