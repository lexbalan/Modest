# Known Bugs

Found 2026-06-11 while verifying documentation against the compiler
(merged 2026-07-29 with the older, previously-duplicated root-level BUGS.md).

## 5. `builtin.*` namespace does not resolve (regression)

```modest
var w: builtin.target.Word        // error: via import is forbidden
let v = builtin.compiler.version  // error: unknown value
```

The wiring exists (`create_builtin_module`, auto-import at
`src/semantic.py:2707`), but any `builtin.x` access fails with
`unknown value`. The repo's own `tests/builtin` fails with 10 errors —
it is not listed in `tests/run.sh`, so the regression went unnoticed.
Affects everything under the `builtin.*` namespace in
`docs/lang/builtin_constants.md`, including
`builtin.target.rationalPrecision`. Top-level constants documented on
that same page (`true`, `false`, `nil`) are bound directly at module
scope, not under `builtin.*`, and are unaffected.

## 6. Empty slice assignment target emits a C zero-length array

```modest
var a: [5]Int32 = [10, 20, 30, 40, 50]
let s = a[2:2]
```

Generates `int32_t s[2 - 2];`, which clang only accepts as a GNU
extension (`-Wzero-length-array` under `-pedantic`). Array size comes
straight from the slice's `volume` expression with no zero-length case;
see `do_ctype_array_volume` in `src/backend/c11.py:210`. Reproduced by
`testEmptySlice` in `tests/slice/src/main.m` (passes, but only because
`-pedantic` warnings aren't treated as errors).

## 7. Postfix operators after a slice are silently dropped

```modest
let x = arr[1:3][0]
// compiles; x becomes the slice, [0] vanishes
```

- Cause: `expr_value_11` returns immediately after parsing a slice instead of
  continuing the postfix loop; the trailing `[0]` is then parsed as a
  standalone array-literal statement and discarded by codegen.
- Expected: postfix ops after a slice apply to the slice result (or are
  rejected with a diagnostic).

## 8. Unterminated record type hangs the compiler

```modest
type Broken = {
	x: Int32
// EOF here — mcc spins forever, no diagnostic
```

- Cause: the field loop in `parse_type_record` (`src/parser.py`) has no
  end-of-input check; at EOF `parse_stmt_field` keeps producing empty
  identifiers without consuming anything.
- Expected: `error: expected '}'` (unexpected end of file) and exit.

## 9. Fields of function-local record types are inaccessible (needs triage)

```modest
func main () -> Int32 {
	type L = { a: Int32 }
	var v: L
	v.a = 7        // error: access to private field of record
	return v.a
}
```

The same record defined at module level works fine. Possibly the
access-level check ties the local definition to the wrong scope.

## 10. C backend re-emits binary expressions as source text, discarding the compile-time fold

```modest
const y: Float64 = 22 / 7
printf("%f\n", y)   // prints 3.000000, expected ~3.142857
```

- `do_bin_immediate` (`src/semantic.py:791-825`) folds constants
  correctly at the HLIR level: `DIV` on two `Integer` literals uses
  Python's true division (`l.asset / r.asset`, `semantic.py:809`), so
  the compile-time `.asset` on the `ValueBin` node is the right value
  (a fraction, not truncated). But the C backend never reads it —
  `do_cvalue_bin` (`src/backend/c11.py:1364-1395`) unconditionally
  re-emits `x.left op x.right` as source text for *every* binary op,
  folded or not, and lets the C compiler redo the arithmetic. C sees
  `22 / 7` as plain integer division and truncates to `3`.
- One side effect: `Integer / Integer` folding also leaves the node in
  an inconsistent state — the result type is narrowed to `Integer`
  (`semantic.py:773-776`, via `nbits_for_num(asset)` truncating the
  float `asset` with `int(x)`) while `.asset` itself is a fractional
  Python `float`, not a whole number.
- Another side effect: it silently caps `Rational` precision at
  whatever the target compiler's own float arithmetic gives. `3.14 +
  0.5` folds to an exact `Fraction` internally, but the C backend
  re-emits `3.14 + 0.5` as text and lets C redo the addition in
  `double`, so raising `rationalPrecision` (see
  `docs/lang/type/generic.md#rational-precision`) only helps a single
  literal, never the result of an operation.
- Expected: the C backend should use the folded `.asset` for
  compile-time-stage `ValueBin` nodes instead of re-emitting operands,
  or otherwise guarantee the emitted C expression reproduces the value
  the compiler already computed.

## 11. Implicit `Rational` → `Float32` construction of a `const` reference emits no cast

```modest
const pi = 3.14159

var f32: Float32 = pi
if f32 != pi {
	printf("mismatch\n")   // prints — should never fire
}
```

- A module-level `const` is emitted as a bare, untyped C macro:
  `#define PI 3.14159`. `var f32: Float32 = pi` correctly rounds it to
  `float` at the definition site, but `f32 != pi` re-expands the same
  macro with **no cast**: `if (f32 != PI)`. In C, an unsuffixed decimal
  literal is always `double`, and comparing `float != double` promotes
  the `float` back to `double` — so the comparison actually happens
  between the *unrounded* double `3.14159` and `f32` widened back to
  double, not between two `Float32` values.
- Concretely: `float` nearest to `3.14159`, widened back to `double`, is
  `3.14159011840820312500`; the plain `double` literal `3.14159` is
  `3.14158999999999988262`. Different values, so `!=` is (wrongly) true.
- Cause: `do_cvalue_cons2` (`src/backend/c11.py:688-699`) skips emitting
  a cast whenever the source type is generic —
  `if not (from_type.is_generic() or is_the_same_in_c(type, value.type)): ...cast...`
  (`c11.py:693`). That shortcut is correct for `Integer` (an unsuffixed
  C integer literal already behaves like the target width at any
  concrete use site) but wrong for `Rational` → `Float32`/`Fixed32`:
  C's literal typing has no notion of "narrower than double", so
  skipping the cast silently reintroduces `double` precision.
  Writing the construction explicitly (`Float32 pi`) does produce a
  `(float)` cast and fixes the comparison — the implicit path is the
  one that's broken.
- Related to #10 (C backend not preserving a Modest-level typing
  decision into the emitted C), but a different code path: this one is
  about implicit construction of a `const` reference, not about
  re-emitting a folded binary expression.
- Expected: implicit `Rational`/`Integer` → narrower-than-`double`
  float construction should still emit a cast (or print the literal
  with an `f` suffix) whenever the target width is less than the
  representation C would otherwise give the bare literal.

