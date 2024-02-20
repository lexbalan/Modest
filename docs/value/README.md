# Value expression

## Brief

### Literal values
* [Numeric value expression](./numeric.md)
* [String value expression](./string.md)

| Literal Kind | Examples | Type |
| :----------: | :------: | :--: |
| Numeric | `0, 1, 0xF` | GenericInteger |
| Rational | `0.5, 3.14, .125` | GenericFloat |
| Boolean | `false, true` | Bool |
| String | `"Hello!"` | GenericArray |
| Array | `[1, 2, 3]` | GenericArray |
| Record | `{x=10, y=20}` | GenericRecord |


### Binary & Unary operations

| Operation Kind | Operation| Valid Argument Types | Result type | Comment |
| :------------: | :--------| :------------------: | :---------: | :-----: |
|Equality|Eq, NE|Bool, Byte, Char, Integer, Float, Array, Record, Pointer|Bool|-|
|Comparison|LT, GT, LE, GE|Integer, Float|Bool|-|
|Arithmetical|Add, Sub, Mul, Div, Rem, Neg|Integer, Float|type(left)|-|
|Logical and Bitwise|And, Or, Xor, Not|Bool, Byte, Integer|type(left)|-|
|Shift|ShL, ShR|Integer (& Byte only as left argument)| type(left) |-|

* [Binary value expression](./binary.md)
* [Unary value expression](./unary.md)



### Special operations
* [Call value expression](./call.md)
* [Index value expression](./index.md)
* [Access value expression](./access.md)
* [Cast value expression](./cast.md)
* [Sizeof value expression](./sizeof.md)



[go back](../../README.md)
