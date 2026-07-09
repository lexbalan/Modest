# Types

The type system is *structural*: types with the same structure are
compatible, regardless of their names. Nominal typing is opt-in via
[`@branded`](./branded.md).

| Type | Form | Page |
| :-- | :-- | :-- |
| Base | `Unit`, `Bool`, `IntX`, `NatX`, `WordX`, `CharX`, `FloatX`, `FixedX`, `Byte` | [base](./base.md) |
| Generic | compile-time types of literals: `Integer`, `Rational`, `String`, ... | [generic](./generic.md) |
| Array | `[N]T`, `[]T`, strings | [array](./array.md) |
| Record | `{a: T1, b: T2}` | [record](./record.md) |
| Pointer | `*T`, `Ptr` (free pointer), `nil` | [pointer](./pointer.md) |
| Function | `(a: T1) -> T2`, pointer to function | [func](./func.md) |
| Branded | `@branded T` — nominal wrapper | [branded](./branded.md) |
| Variant | `A or B` — discriminated union *(experimental)* | [variant](./variant.md) |

Named types are created with a [type definition](../def/type.md).
Type layout and qualifiers are controlled with
[annotations](../attribute.md): `@layout`, `@alignment`, `@volatile`,
`@const`.

There are no type casts; values of one type are obtained from another by
[value construction](../value/cons.md): `Float64 x`.
