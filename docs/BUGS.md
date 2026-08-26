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

## 25. `FixedX` — the gaps left around a working type

The scale itself is right everywhere now: constant folding, run-time
construction and run-time `*` and `/` all apply it, in both backends.  What
is listed here is what still surrounds that.

Constant folding of `FixedX` is implemented: literals, `const`s, arithmetic
between them, array elements, `@fraction(N)` and every construction into and
out of `FixedX` apply the scale. A `FixedX` value stores the number multiplied
by `2^fraction`; the `asset` of an HLIR value with a `FixedX` type is that raw
storage, and `src/value/fixed.py` is the only place the scale is applied or
removed. Rounding is to the nearest representable step, a half step going away
from zero. Covered by `tests/lang/type/fixed/comptime.modest`.

Run-time arithmetic and construction apply and remove the scale too, in both
backends: `*` and `/` correct it through the `__fixedX_mul` / `__fixedX_div`
helpers (`do_cvalue_fixed_bin` in `src/backend/c11.py`, `llvm_eval_fixed_bin`
against the `fixed_helpers_impl` blob in `src/backend/llvm.py`), while `+`,
`-` and the comparisons need no correction — the scale cancels itself there.
Construction works in every direction the construction table allows — `IntX`,
`FloatX` and a `FixedY` with a different `@fraction`, with `WordX` staying the
raw storage on purpose. C11 goes through the `__fixedX_*` helpers, LLVM prints
the equivalent instructions; both round like the fold.

One deliberate exception, taken for the sake of readable C: where the operand
is a plain literal or a `const`, the C backend emits `FIXED32(1.5, 16)` rather
than the folded number (`fixed_cons_via_macro`, `src/backend/c11.py`). The
macro scales in `double` while the fold is exact, so the two disagree by one
LSB whenever the value needs more than 53 significant bits — reachable only
on `Fixed64`, where the fraction is 32 by default:

```c
FIXED64(1312230.071214217469, 32)   // C:    0x001405e6123b1850
                                    // fold: 0x001405e6123b184f  (LLVM emits this)
```

`Fixed32` can never hit it (32-bit storage against a 53-bit mantissa). Roughly
1 in 50000 random 12-decimal `Fixed64` literals diverges. Emitting the folded
number everywhere removes it — that was the behaviour until 2026-08-23, traded
away for output that reads like the source.

Two constraints on that macro, both load-bearing: it must stay a *constant
expression* (it lands in static initializers, so no function call inside), and
because that forces it to evaluate `(x)` twice, codegen must never hand it an
expression with side effects — run-time values go through
`__fixedX_from_float64` instead.

What is left:

- `Fixed64` multiplication and division need a `__int128` intermediate, which
  exists only on 64-bit targets; those four C helpers sit under
  `#ifdef __SIZEOF_INT128__`, so a module that uses `Fixed64 *` or `/` on a
  32-bit target fails to compile. The LLVM backend does not share the problem:
  `i128` is a native IR type there.
- `__fixed64_create` is dead code — nothing in codegen calls it — and it scales
  with `(1 << fraction)` in plain `int`, which is undefined behavior for a
  `Fixed64` fraction of 32. Everything else in the helper block builds the
  scale at `int64_t`.
- `NatX` is the one numeric target that does not accept a `FixedX` source
  (`value_nat_can`, `src/value/nat.py`), even though `IntX` accepts one and
  `NatX` accepts a `FloatY`. Looks like an omission rather than a rule; the
  construction table in `docs/CHEATSHEET.md` records the behaviour as it is.
- The `modest` backend drops the attribute's argument: `@fraction(12)
  Fixed32` comes back out as `@fraction Fixed32`. It only has to survive
  codegen, so the tests pass there — but the emitted source silently loses
  the binary point. Same class as the backend's other round-trip gaps.
- Integer literals wider than 32 bits get an `L` suffix rather than `LL`
  (`cvalue_literal_integer` sizes the suffix from the value, not the type),
  so a `Fixed64` constant emits e.g. `6442450944L`. Correct on LP64, wrong
  where `long` is 32-bit. Not `FixedX`-specific — a plain `Word64` constant
  does the same — but `Fixed64` values are large by construction, so it
  shows up there constantly.

Coverage: `tests/lang/type/fixed/runtime.modest` (run-time) and
`tests/lang/type/fixed/comptime.modest` (compile-time); both pass under c11 and
llvm.

## 26. Record equality compares the padding between fields

```modest
type Sample = {
	tag: Word8       // 1 byte, then 3 bytes of padding
	value: Int32
}

var a: Sample = {tag = 0x01, value = 7}
var b: Sample = {tag = 0x01, value = 7}

a == b        // llvm: false      c11: true
```

- `docs/lang/value/binary.md` says records compare field-wise. Both backends
  instead compare the object's raw bytes over `sizeof`, which includes the
  padding that belongs to no field: `__builtin_memcmp` in C
  (`cvalue_memcmp`, `src/backend/c11.py:1373`) and a hand-written `memeq`
  loop in LLVM (`llvm_memcmp`, `src/backend/llvm.py:814`).
- Only the LLVM backend is visibly wrong today, and the C backend is right
  by luck rather than by construction: it emits a compound literal
  (`(struct sample){.tag = 0x01, .value = 7}`), which clang zero-fills, so
  both objects' padding agrees. The LLVM backend emits an `alloca` and
  stores each field into it, leaving the three bytes between them as
  whatever the stack held — two identical values then differ.
- Arrays are unaffected unless their element type is a padded record: the
  elements of `[8]Int32` are contiguous, with nothing between them.
- The same comparison is what `!=` uses, so a padded record is unequal to
  itself in both directions.
- Fix: compare aggregates member-wise — field by field for a record,
  element by element for an array, recursing into both — and keep the
  byte-wise path only for types that provably have no padding. The
  alternative, zeroing every record on creation, makes the comparison
  correct by making every write more expensive, and still leaves a record
  reached through a pointer from elsewhere.
- Coverage: `tests/lang/value/binary/record_padding.modest`, marked
  `EXPECTED-FAIL(llvm)`. It passes under c11 on purpose — if that backend
  ever stops emitting a compound literal, the test reports it.

## 27. A prefix operator cannot be applied twice

```modest
var w: Word16 = 0xA55A
let r = ~~w        // error: unexpected token1 '~'
let n = - -a       // error: unexpected token1 '-'
let b = not not t  // error: undefined value 'not'
let s = &*p        // error: unexpected token1 '*'
```

- `docs/EBNF.txt:118` states the rule as `expr_10 ::= prefix_op* expr_11` —
  any number of prefix operators. The parser accepts one.
- Cause is one line per operator in `expr_value_10`
  (`src/parser.py:920`): `*` recurses into `expr_value_10` and therefore
  chains (`**pp` and `*&a` both compile), while `&`, `not`, `~`, `+` and
  `-` each call `expr_value_11` — the postfix level — so nothing but a
  primary may follow them.
- Parenthesising works: `~(~w)`, `-(-a)`, `&(*p)`. So this costs
  readability rather than expressiveness, which is why it has gone
  unnoticed — `~~w` is rare, `not not x` is a Bool round-trip nobody
  writes, and `- -a` is `a`.
- The `not not t` case is worth reading twice: the second `not` is taken
  for an identifier, so the diagnostic is `undefined value 'not'` and
  points at a name the language reserves.
- Fix: call `self.expr_value_10()` instead of `self.expr_value_11()` in the
  five branches. Precedence is unaffected — the level is the same one.
- No test covers repeated prefix operators; `tests/lang/value/unary.modest`
  does not exist yet.

## 28. Bitwise operators reject a pair of literal operands

```modest
const flags: Word8 = 0x0F | 0x30      // error: unsuitable value type
                                      // 'Integer(8)' for 'bitwise-or' operation
var s: Word8 = 0xA5
let r = s ^ 0x0F ^ 0x30               // same error
```

- A literal has no type of its own and takes the other operand's, so
  `s | 0x0F` is fine. When *both* operands are literals there is nothing to
  take a type from, and the generic `Integer` that results is rejected by
  `&`, `|` and `^` — which accept `WordX` only.
- Combining two flag constants is the ordinary way to write a mask, and it
  does not compile at all: neither `const both: Word8 = 0x0F | 0x30` nor
  the untyped `const both = 0x0F | 0x30`.
- The second line above is the same defect reached through associativity.
  `&`, `^`, `|` group to the **right** (`docs/lang/value/README.md`), so
  `s ^ 0x0F ^ 0x30` is `s ^ (0x0F ^ 0x30)` — a literal pair. Written
  left-grouped by hand, `(s ^ 0x0F) ^ 0x30` compiles. The cheatsheet's note
  that right grouping "makes no difference to the result" holds for values
  and not for literals, which is how this stayed hidden.
- Arithmetic does not have the problem: `1 + 2 + 3` folds, because `+`
  accepts a generic `Integer`.
- Fix: let `&`, `|` and `^` accept two `Integer` operands and fold them
  into an `Integer`, the way `+` already does — the result then adapts to
  whatever it meets, exactly like a single literal. Making the three
  operators left-associative would hide the chained case, but not
  `const both = 0x0F | 0x30`.
- Coverage: `tests/lang/value/binary/bitwise.modest` works around it by
  keeping one operand a variable.

## 29. A value identifier that starts with a capital is defined, then unusable

```modest
var Xx: Int32 = 1        // accepted
var y = Xx + 1           // error: undefined type
```

- `docs/lang/identifier.md` states the rule: the case of the first letter
  decides the class lexically, uppercase names a type, and `var Xx: Int32`
  is "a syntax error". The definition is accepted instead — for `var`,
  `const` and `func` alike (`func Foo () -> Int32` compiles).
- Every use then fails, because in a value position the capitalized name
  parses as a type: `Xx + 1` gives `undefined type`, `s ^ M1 ^ M2` gives
  `unexpected token1 '^'`, and a bare `let r = M1` gives `unexpected
  token1 'newline'`. None of them names the actual mistake.
- The cost is a definition that looks fine and a diagnostic that points at
  the use site with the wrong word. `const MASK: Word8 = 0x0F` is the
  spelling a C programmer reaches for first, and nothing says why it
  cannot work.
- Fix: reject the capitalized name where it is defined, with the rule in
  the message — the check belongs next to the identifier class the lexer
  already computes.

## 30. C backend does narrow `Word` operations at `int` width

```modest
var b: Word8 = 0x81
b << 1        // c11: 0x102     llvm: 0x02

var f: Word8 = 0xF0
~f            // c11: 0xFFFFFF0F llvm: 0x0F
```

- `docs/lang/value/binary.md` gives the result of a bitwise or shift
  operation the operand's own type, and `docs/lang/value/unary.md` does the
  same for `~`. A `Word8` result cannot hold 0x102.
- The C backend emits the expression as C and lets C's integer promotions
  apply: `uint8_t` becomes `int`, the operation happens at 32 bits, and the
  bits that left the type are still there. The LLVM backend does the
  operation at `i8` and truncates by construction, so the two disagree.
- Affects `<<` and `~`/`not` on `Word8` and `Word16` — every operation that
  can produce a bit outside the operand width. `&`, `|`, `^` and `>>`
  cannot, and agree.
- Hidden by assignment: `var r: Word8 = b << 1` is 0x02 under both
  backends, because C truncates on the store. It shows where the
  expression is used directly — in a comparison, as a call argument, as an
  operand of a wider construction.
- The same promotion applies to `Int8`/`Int16` arithmetic, where the result
  is a signed overflow rather than an extra bit: `Int8 100 * 2` is 200 in C
  and -56 in LLVM IR. What Modest wants there is a separate question — the
  language has not said whether signed overflow wraps — so this entry
  covers the `Word` case, where wrapping is the whole meaning of the type.
- Fix: cast the result of a narrow `Word` operation back to its own type in
  `cvalue_binary` / the unary path — `(uint8_t)(b << 1)` — or hoist it into
  a temporary of the operand type.
- Coverage: `tests/lang/value/binary/narrow_width.modest`, marked
  `EXPECTED-FAIL(c11)`.

## 31. C backend drops parentheses, changing what the expression means

```modest
var a = opaque(1)
var b = opaque(2)
var c = opaque(3)

a - (b - c)      // c11: -4      llvm: 2
```

```c
printf("%d\n", a - b - c);        // the parentheses are gone
```

- Not a folding problem: the operands are run-time values. `do_cvalue_bin`
  (`src/backend/c11.py`) re-emits `left op right` as source text — see
  BUGS.md #10 for the other half of that decision — and adds parentheses
  only when the two operators sit at *different* precedence levels. A
  same-level subexpression on the right of a left-associative operator
  loses its grouping, and C regroups it to the left.
- `a - (b - c)` becomes `a - b - c`, `a / (b / c)` the same way. So does a
  comparison against a comparison: `t != (a == a)` is emitted as
  `t != a == a`, which C reads as `(t != a) == a`.
- Different-level groupings are emitted correctly — `(a + b) * c`,
  `(w & m) == 0`, `(t or f) and f` all keep their parentheses — which is
  why this survived: the classic C-precedence traps are the ones handled.
- Silent and value-changing, on ordinary arithmetic over variables. This is
  the most dangerous shape a backend bug can have.
- The LLVM backend is unaffected: it emits one instruction per operation
  from the tree, so grouping cannot be lost. The `modest` backend re-emits
  source text and has the same defect (`src/backend/modest.py`), where it
  matters less — see the note on that backend in BUGS.md #10.
- Fix: parenthesise from the tree rather than from the precedence table —
  wrap a binary operand whenever it is itself a binary operation of the
  same level, or simply wrap every non-atomic operand and let the C
  compiler's own reader deal with the noise.
- Coverage: `tests/lang/value/binary/parens.modest`, marked
  `EXPECTED-FAIL(c11)`.

## 32. Compile-time `%` uses floored remainder, run time uses truncated

```modest
const negTen: Int32 = -10
const three: Int32 = 3

negTen % three     // folded: 2, computed at run time: -1
```

- `docs/lang/value/binary.md`: integer division truncates and `%` is the
  remainder that truncation leaves, so `-10 % 3` is `-1`. That is what both
  backends compute at run time, and what C and LLVM IR both do.
- The fold does not agree. The table in `do_bin_immediate`
  (`src/semantic.py:842`) maps the operator onto Python's `%`, which is
  *floored*: `-10 % 3` is `2` in Python and `10 % -3` is `-2`. Only the
  signs differ from the run-time answer — with both operands positive the
  two definitions coincide, which is why nothing noticed.
- Visible under llvm, where the folded value is what gets emitted. Under
  c11 the same expression comes out right by accident: that backend
  re-emits the operands as C source text and lets C recompute them
  (BUGS.md #10), and C truncates.
- `/` does not have the problem: the fold divides and the result is
  truncated toward zero before it is used.
- Fix: fold `%` as `a - (a // b) * b` with truncating division — or
  `math.fmod` semantics: `abs(a) % abs(b)` carrying the sign of `a`.
- Coverage: `tests/lang/value/binary/fold_remainder.modest`, marked
  `EXPECTED-FAIL(llvm)`.
