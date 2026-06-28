# Types

The type system is *structural*: types with the same structure are
compatible, regardless of their names. Nominal typing is opt-in via
[`@branded`](./branded.md).

```
types
├── base        primitive types: Unit, Bool, IntX, NatX, WordX,
│               CharX, FloatX, FixedX, Byte ............... base.md
├── generic     compile-time types of literals:
│               Integer, Rational, String, ... ............ generic.md
├── array       [N]T, []T, strings ........................ array.md
├── record      {a: T1, b: T2} ............................ record.md
├── pointer     *T, Ptr (free pointer), nil ............... pointer.md
├── function    (a: T1) -> T2, pointer to function ........ func.md
├── branded     @branded T — nominal wrapper .............. branded.md
└── variant     A or B — discriminated union [experimental] variant.md
```

Named types are created with a [type definition](../def/type.md).
Type layout and qualifiers are controlled with
[annotations](../attribute.md): `@layout`, `@alignment`, `@volatile`,
`@const`.

There are no type casts; values of one type are obtained from another by
[value construction](../value/cons.md): `Float64 x`.
