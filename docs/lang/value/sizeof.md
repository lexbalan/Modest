# sizeof / alignof / lengthof / offsetof

Compile-time queries of size, alignment and layout. All fold to
immediate values.

## Form

```
sizeof(<#type#>)        sizeof(<#value#>)       // size in bytes
alignof(<#type#>)       alignof(<#value#>)      // alignment in bytes
lengthof(<#type#>)      lengthof(<#value#>)     // array element count
offsetof(<#Type.field#>)                        // field offset in bytes
```

## Semantics

- `sizeof` / `alignof` accept a type name or a value expression.
- `lengthof` applies to array types and array values; for `[N]T` it is
  `N`.
- `offsetof` takes a record type and a field: `offsetof(Point.y)`.
- Alignment of base types equals their size (`alignof(Unit)` is 1);
  records may change it with `@alignment(N)` / `@layout("packed")`.
- The result is a compile-time value carrying the width it needs, so it
  goes into any `NatX` wide enough to hold it — `var x: Nat16 =
  sizeof(T)` — and mixes with a variable of any numeric type, taking that
  type. Where there is no type to take, it becomes `Size`: `var x =
  sizeof(T)`, or an extra argument of a variadic function.
- The size of a VLA is known only at run time, so there is no width to
  carry: `sizeof` / `lengthof` of one is a `Size`.

## Examples

```modest
type Buf = [16]Word8
type Header = {tag: Word8, len: Nat32}

const bufBytes = sizeof(Buf)            // 16
const bufLen   = lengthof(Buf)          // 16
const lenOff   = offsetof(Header.len)   // 4 (with default layout)

var a: [5]Int32 = []
var i: Nat32 = 0
while i < lengthof(a) {
	a[i] = Int32 i
	++i
}

var small: Nat8 = sizeof(Buf)           // fits, no construction needed
var size = sizeof(Buf)                  // Size: nothing to take a type from
```

## See also

- [Base types](../type/base.md), [Record type](../type/record.md)
