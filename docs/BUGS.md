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
`testEmptySlice` in `tests/slice/src/main.modest` (passes, but only because
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
- **C-only.** The LLVM backend does not have this bug — verified by
  reading the emitted IR for the same `22 / 7` example: it inlines the
  already-folded value directly, `call ... @printf(..., %Float64
  3.1428571428571428)`, no division instruction at all. LLVM IR gives
  every constant an explicit type at its use site, so there is no
  macro-substitution layer and no target-language arithmetic to
  silently redo the fold. The modest self-backend (`-mbackend=modest`)
  is not applicable either way — it re-emits Modest source text
  (`const y: Float64 = 22 / 7`, unchanged) without evaluating anything;
  recompiling that output with `-mbackend=c11` hits this bug again.

## 12. LLVM backend does not apply C's default argument promotion to variadic calls

```modest
var f32: Float32 = 3.14159265358979323846264338327950288419716939937510582097494459
printf("f32 = %f\n", f32)
```

`-mbackend=llvm` prints `f32 = 0.000000`; `-mbackend=c11` (same source)
prints `f32 = 3.141593`, which is correct.

- Not a `Rational`-precision bug — the stored value is fine
  (`store %Float32 3.1415927410125732, ...` is the correctly-rounded
  `Float32` value of the literal). The bug is purely in how the
  argument is *passed* to a variadic call.
- Cause: a `float` (or any type narrower than what C's default
  argument promotion would give it) passed through a variadic `...`
  parameter must be widened before the call — C always promotes
  `float` to `double` for a `...` argument, and `printf`'s `%f` always
  reads a `double`-sized slot regardless of what was actually written.
  `do_eval_call` (`src/backend/llvm.py:1133-1198`) builds the argument
  list from `do_reval(a.value)` and prints each one with its own
  natural type (`llvm.py:1192`, `print_list_with(args,
  llvm_print_type_value)`) — there is no promotion step at all, so a
  4-byte `%Float32` gets passed where the callee expects an 8-byte
  `%Float64` slot.
- Checked whether this is float-specific: `Int8`/`Int16` arguments to
  the same kind of variadic call print correctly on this platform
  (arm64/AAPCS64) even though C would promote `char`/`short` to `int`
  too and this backend doesn't do that either. Likely coincidental —
  small integers land in a general-purpose register slot that
  `va_arg(int)` still reads correctly by luck of the ABI, whereas
  `float` occupies a different register class and a different byte
  width than `double`, so the mismatch is immediately visible. Not
  verified on other targets/ABIs — the underlying missing-promotion
  cause is the same for both, so integer variadic args should not be
  assumed safe on every target either.
- Scope: not specific to this test file or to `Rational` — any
  `Float32` value (whatever its origin) passed to a variadic function
  (`printf`, `sprintf`, any `@extern` with `...`) through the LLVM
  backend is affected.
- Expected: `do_eval_call` should widen variadic arguments per C's
  default argument promotion rules (`float` → `double`; integer types
  narrower than `int` → `int`) before emitting the call.
- Low priority for now — noted for later, not scheduled.

## 15. C backend's `#include` of its own header ignores `-o`

```sh
mcc -o out/prog -mbackend=c11 main.modest
# writes out/prog.c and out/prog.h, but out/prog.c contains:
#include "main.h"        # does not exist -> clang: file not found
```

- Cause: the include line is built from the module id (`include(module.id
  + '.h')`, `src/backend/c11.py:2161`), which is the *source* base name,
  while the header file is written as `os.path.basename(_outname) + '.h'`
  (`src/backend/c11.py:2282`) — the *output* prefix. The two agree only
  when `-o` happens to end in the same base name as the source.
- Expected: both should come from the same name.
- Went unnoticed because every existing invocation follows the
  `-o <dir>/main main.modest` shape, where the two coincide.

## 16. Backends disagree about a function that falls off its end

```modest
func maybe (a: Int32) -> Int32 {
	if a > 0 {
		return 111
	}
}                       // warning: expected return operator at end

printf("%d\n", maybe(0))
```

```
c11:  -1910964223       // whatever was in the register
llvm: 0
```

- The same program, compiled two ways, produces two different answers.
  Only a warning stands between the author and this, so it survives an
  ordinary build.
- Cause: the two backends fill the gap differently. `print_def_func`
  (`src/backend/llvm.py`) appends `ret <default value>` when the body
  does not end in a `return`, which is what keeps the emitted IR valid;
  the C backend appends nothing and lets the function run off its end,
  which is undefined behaviour in C. Neither is wrong on its own — they
  simply were never made to agree.
- Expected: one answer, whichever it is. Two ways to get there:
  - reject the program in the frontend — promote `expected return
    operator at end` from a warning to an error, so no backend ever sees
    a function with a missing `return`. This fits a language that
    otherwise refuses to guess (no implicit conversions, no implicit
    `Bool`), and it costs nothing at runtime;
  - or define the fallback in the language and make the C backend emit
    the same default value the LLVM backend does.
- The first is the smaller change and closes the divergence for good;
  the second makes falling off the end a legal, defined thing to write,
  which is a language decision, not a backend one.
- Not reproduced by the test suite yet: a test would have to assert one
  of the two behaviours, and which one is the open question — tracked in
  [`lang/OPENQUESTIONS.md`](./lang/OPENQUESTIONS.md) #1.

## 18. `@cbyvalue` on a type definition crashes the compiler

```modest
@cbyvalue
type ByValue = {
	a: Int32
}
```

```
AttributeError: 'StmtDefType' object has no attribute 'value'
```

- A Python traceback reaches the user instead of a diagnostic; the
  compiler does not get as far as reporting anything.
- Cause: `def_add_annotations` (`src/semantic.py:3166`) handles the
  annotation with `x.value.addAttribute("cbyvalue")`, but `x` here is a
  `StmtDefType`, which has no `.value` — only value definitions (`var`,
  `const`) do.
- Verified placements: `const`, `var` and `func` all accept `@cbyvalue`
  without complaint; only `type` crashes.
- Expected: whatever the annotation is supposed to mean on a type — apply
  it, or reject it with `annotation not applicable here`. Crashing is not
  one of the options.
- Worth settling at the same time: `docs/lang/attribute.md` describes
  `@cbyvalue` as "pass record by value in the C ABI", which reads like it
  belongs on a record type, while the implementation only ever consults
  it on a value (`src/backend/c11.py:1114`, where it means "print the
  constant's value rather than its identifier"). The documentation and
  the code describe two different features.


## 19. `-funsafe` is never consulted; only `pragma unsafe` grants permission

```bash
mcc -o out -mbackend=c11 -funsafe main.modest   # module has no pragma unsafe
```

```
error: for use 'unsafe' operator required -funsafe option
```

- The diagnostic names the flag the user just passed. Permission is granted
  solely by `pragma unsafe` in the module: `do_value_unsafe`
  (`src/semantic.py:1783`) tests only `cmodule.hasAttribute('unsafe')`.
- The `features` list that `-f<name>` fills in (`src/main.py:58`) is read in
  exactly one place — `'paranoid' in features` (`src/error.py:142`, `:152`).
  Nothing ever asks it about `unsafe`, so the flag is dead for this purpose.
- The `-funsafe` in the example Makefiles (`examples/crc32`, `examples/sha256`,
  `examples/xxh64`) is a no-op; those modules compile because of their pragma.
- Open question, not just a wording fix: is the command line supposed to be a
  second, independent way to opt in (then wire `features` into the check), or
  is `pragma unsafe` the only intended door (then drop `-funsafe` and reword
  the diagnostic to name the pragma)? Unsafe is expected to be reworked, so
  settle this as part of that.
- Docs updated to match the current behaviour: `docs/CHEATSHEET.md`
  (construction rules), `docs/lang/value/cons.md`, `docs/USAGE.md`.

## 20. Malformed expression in a call argument hangs the parser

```modest
let w = Word32 0x0F
printf("%d\n", ~ Word64 w)   // mcc spins forever, no diagnostic
printf("%d\n", - -x)         // same
```

- The same expressions outside a call report normally: `let r = ~ Word64 w`
  gives `error: unexpected token1 'Word64'`, and `let r = (~ Word64 w)` too.
  Only the argument list loops.
- Cause: `parse_args` (`src/parser.py`) has no progress or end-of-input guard —
  when `expr_value` stops without consuming the offending token, the loop keeps
  re-parsing it. Same shape as #8 (unterminated record type).
- Both triggers are unary operators applied to something above level 13 of the
  precedence table, which is a syntax error by itself; the point is that the
  compiler must say so instead of hanging.

## 21. Uninitialized-value check is bypassed by index and field access

```modest
var buf: [4]Word8
printf("%d\n", Nat32 buf[0])   // compiles; prints garbage

var p: Point
printf("%d\n", p.x)            // compiles; prints garbage
```

Reading the same locals as whole values is caught:

```modest
var x: Int32
var q = p
var b = buf                    // all three: error: attempt to use an uninitialized value
```

- So the check looks at the value itself but not at what an index or field
  access reads out of it — the two most common ways to touch an array or a
  record.
- `docs/CHEATSHEET.md` states the rule without an exception ("local: must assign
  before use (compile error otherwise)"), so the documentation currently
  promises more than the compiler checks.
- Verified for `[N]T` elements and record fields; both slip through.

## 22. An inline comment after a trailing operator breaks line continuation

```modest
let v = a |   // low bits
	(a << 8)
```

```
error: unexpected token1 ' low bits'
```

- A line ending in a binary operator continues on the next line (the operator is
  the continuation mark); the parser does this by skipping newlines after the
  operator — `self.skipn("\n")` in `expr_value_1` … `expr_value_8`
  (`src/parser.py`). Comments are not skipped there, so the comment token lands
  where the right operand is expected.
- Without the comment the same code compiles, and a blank line after the
  operator is tolerated:
  ```modest
  let v = a |

  	(a << 8)      // fine
  ```
- Hits exactly where inline comments are most useful — annotating the terms of a
  long multi-line expression — and the project's own style guide encourages
  comments to the right of code (`docs/CHEATSHEET.md`, Code Style).
- Fix belongs next to the newline skip: skip comment tokens the same way.

## 23. Breaking the line-continuation rule gives a diagnostic that does not teach it

```modest
let v = a
	| (a << 8)      // error: unexpected token1 '|'
```

```modest
let v = a |
return 0            // error: undefined value 'return'
```

- Both messages are technically true and practically useless: neither mentions
  that a continued expression must end the line with its operator.
- Wanted: for a binary operator at the start of a line — "binary operator at
  start of line; to continue an expression, put it at the end of the previous
  line". For a trailing operator with nothing to continue into — point at the
  operator, not at the innocent token on the next line that got swallowed.
- `unexpected token1` leaks an internal name into user-facing output; it appears
  in many other diagnostics too and deserves a separate pass.

## 24. `sizeof` of an array value through a pointer returns the element size

```modest
let q = *[10]Int32 p
return sizeof(*q)      // 4, expected 40
```

- Silently wrong, not a crash. `sizeof` of the array *type* is correct
  (`sizeof([10]Int32)` → 40), as is `sizeof(g)` for a real array variable —
  only the deref-through-pointer form is affected.
- Cause is `ARRAY_AS_POINTER`: Modest's `*[10]Int32` is emitted as `int32_t *`,
  so `do_cvalue_sizeof_value` (`src/backend/c11.py:1160`) prints `sizeof *q`,
  which in C is one `int32_t`.
- Not VLA-specific — reproduces with a constant size, and predates the
  `sizeof(item) * n` lowering.
- Fix: take the size from the type when the value's type is an array, i.e.
  `cvalue_sizeof_type(x.ofvalue.type)` instead of `CValueSizeofValue(...)`.
  Held back because it changes existing behavior rather than fixing a crash.
- No test covers `sizeof` of an array value.

## 25. `FixedX` has no binary point: nothing scales, anywhere

```modest
var a: Fixed32 = 1.5
var b: Fixed32 = 2.0
printf("%f\n", Float64 (a * b))   // 2.000000, expected 3.000000
```

`Fixed32`/`Fixed64` are documented (`docs/lang/type/base.md`) as fixed-point
with the point at `@fraction(N)`, default half the width. In practice the
type is an `int32_t`/`int64_t` alias and the scale is never applied:

- A rational literal is passed through unscaled — `var a: Fixed32 = 1.5`
  emits `int32_t a = 1.5;` (clang truncates it to 1), and
  `const half: Fixed32 = 0.5` emits `#define HALF ((int32_t)0.5)`, i.e. 0.
  `value_fixed_cons` (`src/value/fixed.py:36`) sets `nv.asset = 1` under a
  `# TODO` instead of computing `value * 2^fraction`.
- Arithmetic is plain integer arithmetic: `a * b` emits `a * b` with no
  `>> fraction`, `a / b` no `<< fraction`. The C backend *does* emit
  `__fixed32_mul`, `__fixed32_div`, `__fixed32_from_int32`,
  `__fixed32_to_int32`, `__fixed32_from_float64` and `__fixed32_to_float64`
  (`do_helper_use_fixed_point`, `src/backend/c11.py:2022`) — every use of a
  Fixed value pulls the helper block in, and no generated code ever calls it.
- `FixedX` ↔ `IntX` and `FixedX` → `FloatX` construction emits a bare C cast,
  so both directions are off by 2^fraction.
- `@fraction(N)` parses and lands on the type (`src/hlir/types.py:709`), but
  nothing except `Type.eq` ever reads `.fraction`. So the attribute changes
  the type's identity and nothing else.
- The LLVM backend cannot emit a Fixed literal at all:
  `do_eval_literal: unknown literal` (`src/backend/llvm.py:1873`), and the
  diagnostic it raises then crashes itself — `Value.print` does
  `len(x.asset)` on an int (`src/hlir/types.py:2104`), `TypeError`.

Waiting further down the same road, once the scale is actually applied:

- The helper block is 32-bit only. Everything for `Fixed64` beyond
  `__fixed64_create` is missing — no `__fixed64_mul`, `_div`, `_from_int64`,
  `_to_int64`, `_to_float64` — so a `Fixed64` fix cannot reuse the `Fixed32`
  path as it stands.
- The helpers scale with `(1 << fraction)` in plain `int`. For `Fixed64`,
  whose default fraction is 32, that shift is undefined behavior;
  `__fixed64_create` already contains it. It has to be `(1LL << fraction)`,
  or the scale has to be built at the fixed type's own width.
- `type_fixed_create` (`src/hlir/defs.py:84`) computes the default as
  `width / 2`, which in Python 3 is a *float* — `16.0`, not `16`. Harmless
  while nothing reads `.fraction`; the moment codegen interpolates it into a
  shift, it emits `>> 16.0`.
- The `modest` backend drops the attribute's argument: `@fraction(12)
  Fixed32` comes back out as `@fraction Fixed32`. It only has to survive
  codegen, so the test passes there — but the emitted source silently loses
  the binary point. Same class as the backend's other round-trip gaps.
- Under `-Wall -Wextra -pedantic` the generated C warns
  (`-Wliteral-conversion`, "changes value from 3.5 to 3") — the truncation is
  visible in the build log today, and nothing treats it as an error.
- `FixedX` carries `FLOAT_OPS` (`src/hlir/defs.py:83`), i.e. equ + ord + math
  and no `%`. That matches `docs/lang/type/base.md`; noted here only so a fix
  does not "helpfully" widen it.

Two design questions to settle before fixing, both visible in
`value_fixed_can` (`src/value/fixed.py:19`):

- `Float64 → Fixed32` is rejected (`cannot construct 'Fixed32' from
  'Float64' value`) while `Fixed32 → Float64` is allowed, even though the
  C helper `__fixed32_from_float64` is already written for it. The
  construction table in `docs/CHEATSHEET.md` has no `FixedX` target row.
- `WordX → FixedX` is unsafe-only, which reads as "the raw storage is the
  scaled integer", but the reverse (`unsafe WordX f`) is not documented as
  a reinterpretation, so the storage layout is not actually stated anywhere.

Reproducer: `tests/lang/type/fixed.modest` (XFAIL under c11 and llvm).
