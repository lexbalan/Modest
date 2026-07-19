# Literals

A literal denotes a value directly. Most literals have a
[generic type](../type/generic.md) that adapts to the required concrete
type at the use site.

## Form

| Literal | Examples | Type |
| :--- | :--- | :--- |
| Boolean | `true`, `false` | `Bool` |
| Integer | `0`, `42`, `0x2A`, `1_000_000` | `Integer` (generic) |
| Rational | `0.5`, `3.14` | `Rational` (generic) |
| String | `"abc"`, `'abc'` | `String` (generic) |
| Array | `[1, 2, 3]`, `[]` | generic array |
| Record | `{x = 10, y = 20}`, `{}` | generic record |
| Nil | `nil` | null pointer, any pointer type |

## Semantics

- Integer: decimal or hexadecimal (`0x...`); `_` may separate digit
  groups; a leading `0` is still decimal — there are no octal literals.
- Rational: requires digits on both sides of the dot (`0.5`, not `.5`).
- String: double or single quotes are equivalent; `\` escapes the next
  character. The value is a `[N]CharX` array containing exactly the
  characters written (see [array](../type/array.md)). Indexing a string
  literal yields a generic char: `"A"[0]`.
- Escapes: `\n`, `\t`, `\r`, `\a`, `\b`, `\f`, `\v`, `\"`, `\'`, `\\` denote
  single control/quote characters; `\xHH` consumes exactly two hex
  digits and denotes one byte (`\x0` is an error — pad to two; a third
  digit is just the next character, so `\x410` is `"A"` followed by
  `"0"`); and `\u{H...H}` denotes a Unicode code point from one to six
  hex digits (must be ≤ `10FFFF`), encoded as UTF-8 (`\u{41}` = `"A"`,
  `\u{1F389}` = 🎉). There is no bare decimal byte escape (`\NNN`) — it
  read a greedy run of digits with no fixed width, so `\6` followed by a
  literal `5` was indistinguishable from `\65`; use `\xHH` instead.
- Strings (and comments) may contain any Unicode text — the only places
  it is allowed; [identifiers](../identifier.md) are ASCII.
- A char value is a length-1 string converted to `CharX` — implicitly
  (`var c: Char8 = "A"`) or explicitly (`Char8 "A"`).
- `[]` / `{}` fill any array/record they are assigned to with default
  values (see [fields](../fields.md)).
- Constant expressions over literals fold at compile time and stay
  generic: `2 + 2` is still a generic `Integer`.

## Examples

```modest
var x: Nat32 = 0x2A          // 42
var f: Float64 = 3.14
var s: *Str8 = "Hello!\n"    // string handled through pointer
var e: *Str8 = "\x48\x69\u{21}"  // "Hi!"
var c: Char8 = "A"
var a: [3]Int32 = [1, 2, 3]
var p: *Int32 = nil
const big = 1_000_000
```

## See also

- [Generic types](../type/generic.md), [Construction](./cons.md)
