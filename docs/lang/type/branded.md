# Branded Types

`@branded` creates a *nominal* type on top of a structural one: same
representation and operations, but not interchangeable with the parent
(the "newtype" pattern).

## Form

```
type <#identifier#> = @branded <#type_expression#>
```

## Semantics

Verified rules (`T` — parent type, `B = @branded T`):

| Conversion | Allowed? |
| :--- | :--- |
| `B` ← `T` implicitly | no — `cannot implicitly construct ...` |
| `B` ← generic literal implicitly | no — `type mismatch` |
| `B` ← `T` explicitly: `B x` | yes |
| `T` ← `B` explicitly: `T b` | yes |

- A branded type inherits all operations of its parent (`+`, `==`, ...,
  according to the parent's operation classes).
- Two different brands of the same parent are mutually incompatible.

## Examples

```modest
type Meters = @branded Float64
type Seconds = @branded Float64

var m: Meters = Meters 5.0
var s: Seconds = Seconds 1.0

m = m + m                  // operations inherited
m = Meters (Float64 s)     // deliberate conversion: two explicit steps
// m = s                   // error: different brands
// m = 5.0                 // error: construct explicitly

// enum idiom
type Color = @branded Nat8
const colorRed   = Color 0
const colorGreen = Color 1
```

## See also

- [Type definition](../def/type.md)
- [Value construction](../value/cons.md)
