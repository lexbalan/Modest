# Variant Type

> **Experimental.** The variant type exists as a proof-of-concept in the C11
> backend. The syntax and semantics described here are provisional and **will
> change** before the feature is considered stable.

A *variant* (discriminated union, tagged union) is a type whose value holds
exactly one of several alternative types at a time; a runtime tag records
which alternative is active.

## Form

```
<#TypeA#> or <#TypeB#> or ...
```

```modest
Int or Error            // two alternatives
Int or Error or Nil     // three alternatives
```

Variant types are anonymous; give them a name with a `type` definition:

```modest
type Result = Int or Error
```

## Semantics

- A variant type is a **distinct type** from each of its member types.
- The `or` operator is **n-ary**: `A or B or C` is a single flat variant with
  three alternatives, not a nesting of two-alternative variants.
- Tag values are the **positional indices** of the alternatives: 0 for the
  first, 1 for the second, and so on.
- Values are constructed **implicitly**: assigning or returning a value of
  type `A` where `A or B or C` is expected wraps it automatically, setting
  the tag to the index of `A`.
- Explicit construction uses the normal value-construction syntax:
  `Int 0` produces an `Int` that wraps implicitly into the variant.
- **Pattern matching** (`when x is { A => ... B => ... }`) is planned but
  **not yet implemented**; the active alternative cannot currently be inspected
  at the language level.
- A variant value occupies `pointer_width` bits (64 bits on 64-bit targets).

## Examples

```modest
type Error = @branded Nat32
const errorNone = Error 0
const errorSome = Error 1

func divide (a: Int, b: Int) -> Int or Error {
    if b == 0 { return errorSome }   // Error wraps implicitly
    return Int a / b                 // Int wraps implicitly
}

func main () -> Int {
    var r = divide(10, 2)   // r : Int or Error
    // inspection via `when` is not yet available
    return 0
}
```

<details>
<summary>C output (c11 backend)</summary>

For a function returning `Int or Error`, the C11 backend emits an anonymous
struct:

```c
struct __anonymous_variant_0 {
    uint8_t tag;
    union {
        intptr_t _0;   // Int
        uint32_t _1;   // Error
    } value;
};
```

Wrapping an `Int` value produces:

```c
(struct __anonymous_variant_0){.tag = 0, .value = {._0 = v}}
```

</details>

## Limitations (experimental)

- Only the C11 backend supports variant types; the LLVM backend does not.
- Pattern matching is not implemented; there is no way to read the tag or
  extract the inner value at the language level yet.
- The syntax (`A or B`) and the construction rules are subject to change.

## See also

- [Value construction](../value/cons.md)
- [Record type](./record.md)
- [Branded types](./branded.md)
