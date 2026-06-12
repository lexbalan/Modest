# Index

Designates an element of an array by position. The expression denotes
the element itself — a *place*; the context decides what happens to it:
read, assignment target, or address-of (`&a[i]`).

## Form

```
<#array_value#>[<#index#>]
<#pointer_to_array#>[<#index#>]      // auto-deref
```

## Semantics

- Indices start at zero; the index is an integer expression.
- Usable as an rvalue, as an lvalue (`a[i] = v`), and as the operand of
  `&` — `&a[i]` is a pointer to the element (the standard way to point
  into an array, see [pointer](../type/pointer.md)).
- Through a pointer to array the indexing dereferences automatically:
  with `p: *[]Int32`, write `p[i]`.
- Multi-dimensional arrays index step by step: `m[i][j]`.
- Indexing a string yields a char: `s[0]`; indexing a string literal
  yields a generic char (`"A"[0]`).
- A pointer to a *nested* unsized array (`*[][]T`) cannot be indexed
  directly — construct a concrete view first.

## Examples

```modest
var a: [5]Int32 = [1, 2, 3, 4, 5]
let first = a[0]
a[4] = 50

var p: *[]Int32 = &a
p[1] = 20                     // auto-deref

var m: [2][3]Int32 = [[1, 2, 3], [4, 5, 6]]
let x = m[1][2]               // 6
```

## See also

- [Array type](../type/array.md), [Slice](./slice.md)
