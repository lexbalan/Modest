# Values

### Zero value
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


### Immediate values
*Immediate value* - is an value known in compile time. It can be a complex expression, but there is one rule: all values in this expression must be also **immediate**.


##### Example
```golang
// all these values are immediate
const x = 2  // 2
const y = 6  // 6
const z = (x * y) / (x + y)  // 1
const w = z < 10  // true
```


### Immutable values
*Immutable value* - value that cannot be changed in runtime. 
It is values *immediate values*, values created by `const` & `let` definitions, *parameters* of functions.
It is impossible to get pointer (ref operation) to immutable values.


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

