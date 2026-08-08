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

## 13. LLVM backend emits invalid IR when every `if` branch returns

```modest
func sign (a: Int32) -> Int32 {
	if a > 0 {
		return 1
	} else {
		return 0
	}
}
```

clang refuses the output: `error: expected instruction opcode`.

```llvm
then_0:
	ret %Int32 1
	br label %endif_0     ; instruction after a terminator
else_0:
	ret %Int32 0
	br label %endif_0
endif_0:
}                         ; block with no terminator at all
```

- Cause: `print_stmt_if` (`src/backend/llvm.py:2024-2049`) emits
  `llvm_jump(endif_label)` after each branch and `llvm_label(endif_label)`
  at the end, both unconditionally — with no notion of whether the block
  it is closing already terminated. When a branch ends in `ret`, the
  jump lands after a terminator; when *every* branch does, the merge
  block is left empty and the function ends on a bare label.
- Expected: skip the jump when the branch already terminated, and skip
  the merge label entirely when it would be unreachable.
- Affects any `if`/`else` (including `else if` chains) whose branches all
  return — an ordinary way to write a small function, so this is easy to
  hit. Reproduced by `tests/lang/stmt/if.m`, marked `EXPECTED-FAIL(llvm)`.

## 15. C backend's `#include` of its own header ignores `-o`

```sh
mcc -o out/prog -mbackend=c11 main.m
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
  `-o <dir>/main main.m` shape, where the two coincide.

