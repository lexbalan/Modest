# Unary Operations

## Form

```
<#operator#> <#value_expression#>
```

| Operator | Operand | Result | Meaning |
| :-- | :-- | :-- | :-- |
| `not` | Bool | Bool | logical negation |
| `not`, `~` | WordX | operand type | bitwise inversion |
| `-` | IntX, FloatX | operand type | arithmetic negation |
| `+` | numeric | operand type | no-op |
| `&` | mutable value or function | pointer | address-of |
| `*` | pointer | pointee | dereference |

## Semantics

- `-` requires a *signed* type: negating a `Nat` is an error
  (`expected value with signed type`).
- On `Word` operands `not` and `~` are the same bitwise inversion;
  on `Bool` only `not` is valid.
- `&` applies to mutable values (variables, fields, elements) and
  functions. Immutable values — `let` bindings, parameters,
  constants — have no address (`expected mutable value or function`).
- `*p` reads or (as an lvalue) writes the pointed-to value. Records and
  arrays behind pointers are accessed without explicit `*` — see
  [pointer](../type/pointer.md).
- `new` is parsed as a unary operator but is experimental — do not use.

## Examples

```modest
var flag: Bool = false
flag = not flag

var mask: Word8 = 0x0F
mask = ~mask                  // 0xF0

var x: Int32 = 5
let neg = -x

var p: *Int32 = &x
*p = 10                       // x == 10
```

## See also

- [Pointer type](../type/pointer.md), [Binary operations](./binary.md)
