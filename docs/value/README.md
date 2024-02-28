# Value expression

## Brief

#### Zero value
Zero value means 0 for any Numeric types, empty array value and empty record value.

```
    0, [], {}
```

Any [global variable](../def/var.md), defined without *default value*, after creation will be contains *zero value*.


### [Literal values](./literal.md)
* [Integer value expression](./literal.md#Integer-literals)
* [String value expression](./literal.md#String-literals)
* [Array value expression](./literal.md#Array-literals)
* [Record value expression](./literal.md#Record-literals)

### Binary & Unary operations

| Operation Kind | Operation| Valid Argument Types | Result type | Comment |
| :------------: | :--------| :------------------: | :---------: | :-----: |
|Equality|Eq, NE|Bool, Byte, Char, Integer, Float, Array, Record, Pointer | Bool |-|
|Comparison|LT, GT, LE, GE|Integer, Float|Bool|-|
|Arithmetical|Add, Sub, Mul, Div, Rem, Neg|Integer, Float | ***type***(*left*) |-|
|Logical and Bitwise|And, Or, Xor, Not|Bool, Byte, Integer | ***type***(*left*) |-|
|Shift|ShL, ShR|Integer (& Byte only as left argument) | ***type***(*left*) |-|

* [Binary value expression](./binary.md)
* [Unary value expression](./unary.md)



### Special operations
* [Call value expression](./call.md)
* [Index value expression](./index.md)
* [Access value expression](./access.md)
* [Cast value expression](./cast.md)
* [Sizeof value expression](./sizeof.md)



[go back](../../README.md)

