# Known Bugs

Found 2026-06-11 while verifying documentation against the compiler
(merged 2026-07-29 with the older, previously-duplicated root-level BUGS.md).

This file is the only place bugs are recorded, so a bug is referred to as
`BUG#N` everywhere — docs, source comments, test `EXPECTED-FAIL` markers,
commit messages — without naming the file.  The number is permanent: an entry
is deleted when the bug is fixed, and numbers are never reused.

Nothing is kept here about fixed bugs.  What survives a fix is the test that
reproduced it: its `EXPECTED-FAIL` marker becomes a `Guards BUG#N (fixed
<date>)` line, so the number still leads to its reproducer (`tests/README.md`,
"Known-broken tests").  Who fixed it and when is git's to answer:
`git log -S '## BUG#N:' -- docs/BUGS.md`.

## BUG#5: `builtin.*` namespace does not resolve (regression)

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

## BUG#6: Empty slice assignment target emits a C zero-length array

```modest
var a: [5]Int32 = [10, 20, 30, 40, 50]
let s = a[2:2]
```

Generates `int32_t s[2 - 2];`, which clang only accepts as a GNU
extension (`-Wzero-length-array` under `-pedantic`). Array size comes
straight from the slice's `volume` expression with no zero-length case;
see `do_ctype_array_volume` in `src/backend/c11.py:210`. No reproducer in the
suite — the old `tests/slice` was not carried over into `tests/lang/`.

## BUG#7: C backend emits `arr[from][i]` for a postfix operator on a slice

```modest
var a: [5]Int32 = [1, 2, 3, 4, 5]
let x = a[1:4][0]                // 2
```

Generates `const int32_t x = a[1][0];`, which clang rejects —
*subscripted value is not an array, pointer, or vector*. The same for a
slice of a slice (`a[1:5][1:3][0]` becomes `a[1][1][0]`) and for a field
of a sliced record (`ps[1:3][0].x` becomes `ps[1][0].x`).

- Cause: `do_cvalue_slice` (`src/backend/c11.py:1130`) prints a slice as
  the lvalue of its first element, `a[from]`. That is what the slice's
  other uses want — they all take its address (`&a[from]`) and copy —
  but it is not an array object, so when `do_cvalue_index` /
  `do_cvalue_access` put another `[i]` or `.field` on it, they subscript
  a scalar.
- The LLVM backend is right here: it bitcasts the element pointer to a
  pointer to the slice's array type and indexes through that
  (`%10 = bitcast %Int32* %9 to [2 x %Int32]*`), so it prints 2. The
  `modest` backend re-emits the source and is unaffected.
- Fix, probably: when the left side of an index or an access is a slice,
  fold the slice's start into the index (`a[from + i]`), or do what LLVM
  does and go through a pointer to the slice's type.
- The parser half of this bug was fixed on 2026-08-28: `expr_value_11`
  returned instead of continuing the postfix loop after a slice, so
  everything after `a[1:4]` was re-read as a new statement — `[0]` became
  a stray array literal that codegen dropped (`{0};` in the output), and
  `a[1:4][1:3]` was a cascade of syntax errors.
- Reproducer: `tests/lang/value/slice/postfix.modest`, marked
  `EXPECTED-FAIL(c11)`.

## BUG#12: LLVM backend does not apply C's default argument promotion to variadic calls

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

## BUG#15: C backend's `#include` of its own header ignores `-o`

```sh
modest -o out/prog -mbackend=c11 main.modest
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

## BUG#18: `@cbyvalue` on a type definition crashes the compiler

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


## BUG#19: `-funsafe` is never consulted; only `pragma unsafe` grants permission

```bash
modest -o out -mbackend=c11 -funsafe main.modest   # module has no pragma unsafe
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

## BUG#20: Malformed expression in a call argument makes `parse_args` spin

```modest
const K: Int32 = 5
printf("%d\n", K)             // no hang any more, but see below
```

- Cause: `parse_args` (`src/parser.py`) has no progress guard — when
  `expr_value` stops without consuming the offending token, the loop keeps
  re-parsing it.
- The malformed argument here is a capitalized value identifier: `K` is a type
  name to the parser, so in a value position `expr_value` stops without
  consuming it and the argument list is left standing on `)`. Since 2026-09-08
  the definition is refused first, at its own site (`value identifier must
  start with a small letter; 'K' names a type`), but the call behind it still
  derails: `unexpected token1 ')'`, then `expected separator`, and only then
  does `parse_args` start spinning — so the useful diagnostic is not the last
  thing the user sees.
- Since the lexer got a real end-of-input token (2026-08-30), this no longer
  hangs: the loop drains the rest of the file, then hits `MAX_ERRORS` at EOF
  and exits. That is termination by accident, not a fix — the loop still makes
  no progress, and `expected separator` / `unexpected token1 'end-of-file'`
  alternate until the ten-error limit (`MAX_ERRORS`, `src/error.py`) cuts the
  run off; verified 2026-09-08. `parse_args` still needs a no-progress guard.
- The original triggers no longer reproduce at all:

  ```modest
  let w = Word32 0x0F
  printf("%d\n", ~ Word64 w)  // compiles cleanly now
  ```

  Both were unary operators applied above the postfix level of the precedence table;
  verified 2026-08-30 that this compiles without a diagnostic, and again
  2026-09-08. Whether it *should* is a question about the operand-type rules,
  not about this bug.

## BUG#22: An inline comment after a trailing operator breaks line continuation

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

## BUG#23: Breaking the line-continuation rule gives a diagnostic that does not teach it

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

## BUG#25: `FixedX` — the gaps left around a working type

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

## BUG#26: Record equality compares the padding between fields

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

## BUG#28: Bitwise operators reject a pair of literal operands

```modest
const flags: Word8 = 0x0F | 0x30      // error: unsuitable value type
                                      // 'Integer(8)' for 'bitwise-or' operation
```

- A literal has no type of its own and takes the other operand's, so
  `s | 0x0F` is fine. When *both* operands are literals there is nothing to
  take a type from, and the generic `Integer` that results is rejected by
  `&`, `|` and `^` — which accept `WordX` only.
- Combining two flag constants is the ordinary way to write a mask, and it
  does not compile at all: neither `const both: Word8 = 0x0F | 0x30` nor
  the untyped `const both = 0x0F | 0x30`.
- A chain over a variable used to hit the same error from a different
  direction: `&`, `^`, `|` grouped to the right, so `s ^ 0x0F ^ 0x30` was
  `s ^ (0x0F ^ 0x30)` — a literal pair. Those three operators are
  left-associative now, so the chain reaches only one literal at a time and
  compiles. That hid a symptom, not the defect: a literal pair written on
  its own still does not.
- Arithmetic does not have the problem: `1 + 2 + 3` folds, because `+`
  accepts a generic `Integer`.
- Fix: let `&`, `|` and `^` accept two `Integer` operands and fold them
  into an `Integer`, the way `+` already does — the result then adapts to
  whatever it meets, exactly like a single literal.
- Coverage: `tests/lang/value/binary/bitwise.modest` works around it by
  keeping one operand a variable.

## BUG#30: C backend does narrow `Word` operations at `int` width

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

## BUG#33: A malformed type crashes the compiler after reporting the error

```modest
type F = (Int32) -> Int   // a parameter without a name
```

Three correct diagnostics are printed — `expected type expr`,
`unexpected token '('`, `expected type expr` — and then the compiler dies
with a Python traceback instead of exiting:

```
File "src/semantic.py", line 3088, in def_phase2
    assert(df != None)
AssertionError
```

- Cause: `def_phase2` (`src/semantic.py:3088`) asserts that every
  definition was built, and `def_type_global` returns `None` for one whose
  type failed to parse. The `if df.is_stmt_bad(): continue` on the next
  line is the path this case should be taking.
- Any malformed type definition does it: `type F = (123) -> Int`,
  `type F = func: (x: Int32) -> Int` (the `func:` form belongs on a
  function definition, not on a type).
- A second crash site has the same root. `_parse_type_atom` returns `None`
  after `expected type expr`, and its callers subscript that without a
  check: `var p: *123` dies with `TypeError: 'NoneType' object is not
  subscriptable` at `parse_stmt_field` (`src/parser.py:2091`). The array
  and pointer branches of `_parse_type_atom` itself (`of['ti']`,
  `to['ti']`) would do the same if the lookahead in `is_type_expr` ever
  disagreed with the parse that follows it.
- Expected: stop at the error that was already reported, the way every
  other bad definition does.

## BUG#34: LLVM backend negates a float with the integer `sub`

```modest
var a: Float64 = 1.5
printf("%f\n", -a)          // c11: -1.500000    llvm: does not assemble
```

```
%3 = sub %Float64 0.0, %2   // error: invalid operand type for instruction
```

- `docs/lang/type/base.md` gives `FloatX` the `math` class, which includes
  unary `-`. The C backend prints `-a` and is right; the LLVM backend is
  not.
- Cause: `do_eval_neg` (`src/backend/llvm.py:2088`) builds the negation as
  `0 - x` and hands `llvm_eval_binary` the opcode `'sub'` as a literal
  string, with no float case. The binary path next to it does have one —
  `select_bin_opcode_f(opp, 'f' + opp, t)` in `select_bin_opcode`
  (`src/backend/llvm.py:3212`) — so `a - b` on floats correctly emits
  `fsub` and only the unary form is wrong. Affects `Float32` and `Float64`
  alike.
- The same function has a second failure mode, on the literal `-0.0`:

  ```modest
  var z: Float64 = -0.0       // llvm: TypeError, compiler traceback
  ```

  ```
  File "src/backend/llvm.py", line 208, in get_id_str
      return x.id.prefix + x.id.llvm
  TypeError: can only concatenate str (not "NoneType") to str
  ```

  Cause: `do_eval_cons` (`src/backend/llvm.py:1857`) decides whether a
  constant was folded with `if x.asset:` — a *truthiness* test. A folded
  `-0.0` is falsy in Python, so the emitter misses the literal path it
  takes for every other constant (`-2.25` is emitted as `store %Float64
  -2.25`), falls through to `do_reval` of the negation, and reaches
  `do_eval_neg` with a still-generic `Rational` zero, whose type has no
  LLVM id. `var z: Int32 = -0` goes the same way and emits `sext`
  constexprs that clang no longer accepts. The test should be
  `if x.asset != None:`, as `do_value_neg` (`src/semantic.py:936`)
  already writes it.
- Expected: `fsub` for a float operand, and a folded zero emitted as the
  literal it is.
- Coverage: `tests/lang/type/float/negation.modest`, marked
  `EXPECTED-FAIL(llvm)`.

## BUG#35: Backends disagree about `!=` on a NaN

```modest
var zero: Float64 = 0.0
var nan = zero / zero
if nan != nan { printf("NaN\n") }    // c11: prints    llvm: does not
```

- IEEE 754 makes NaN the one value not equal to itself, and that is the
  only way to detect one without a library. C's `!=` on floats is an
  *unordered* compare — true whenever either operand is NaN — and the C
  backend inherits it by printing `a != b` as C.
- Cause: `select_bin_opcode` (`src/backend/llvm.py:3203`) maps both `==`
  and `!=` through `'fcmp o' + opp`, which gives `fcmp one` — *ordered*
  and not equal, false for NaN. For `==` the ordered form is right
  (`fcmp oeq` and C's `==` are both false for NaN); only `!=` needs the
  unordered one, `fcmp une`.
- `<`, `>`, `<=`, `>=` are ordered in C too, so `fcmp o<cc>` is right for
  all four and they agree between the backends.
- Expected: `fcmp une` for `!=`, leaving `==` as it is.
- Coverage: `tests/lang/type/float/nan.modest`, marked
  `EXPECTED-FAIL(llvm)`.

## BUG#36: `FloatX` ↔ `WordX` converts numerically instead of reinterpreting bits

```modest
var f: Float32 = 1.0
printf("0x%08x\n", Word32 f)        // c11: 0x00000001, expected 0x3F800000

var w: Word32 = 0x3F800000
var g: Float32 = unsafe Float32 w
printf("%f\n", Float64 g)           // c11: 1065353216.0, expected 1.0
```

- `docs/lang/value/cons.md` states the rule twice: "`FloatY ↔ WordX`
  reinterprets bits (like `memcpy`), never converts numerically", and the
  construction table gives `WordX ← FloatY` as explicit, `FloatX ← WordY`
  as unsafe. `docs/CHEATSHEET.md` repeats it. Nothing implements it.
- The C backend prints an ordinary C cast — `(uint32_t)f` — so the value is
  rounded rather than reinterpreted, and a negative float is worse than
  wrong: `Word32 (-2.0)` is undefined behaviour in C and comes out `0`.
- The LLVM backend does not get that far in the `Float → Word` direction:
  it prints `%4 = cast %Float32 %3 to %Word32`, and `cast` has not been an
  LLVM instruction since 2.9, so the module does not assemble. The
  `Word → Float` direction assembles and is numeric, like C.
- The compile-time fold is a third path and a third failure. `unsafe Word32
  one` on a `const Float32` dies in `value_word_cons`
  (`src/value/word.py:54`), which passes the folded float to `int_zext`:

  ```
  File "src/bits.py", line 50, in int_to_bitstring
      return format(x & (2**width - 1), '0%db' % width)
  TypeError: unsupported operand type(s) for &: 'float' and 'int'
  ```

- Expected: both directions move the bits — `memcpy` or a union in C, a
  `bitcast` in LLVM IR — and the fold packs and unpacks the IEEE 754
  encoding (`struct.pack`) rather than treating the asset as an integer.
- This is the only way to reach the values IEEE 754 has and the language
  has no literal for: infinity, NaN, a denormal. Nothing else in the
  language names them.
- Coverage: `tests/lang/type/float/bits.modest`, marked `EXPECTED-FAIL`.
  It uses run-time values only — a compile-time one would crash the
  compiler and hide the rest of the file.

## BUG#37: `IntX` from a wider `FloatY` is rejected as an integer overflow

```modest
var f: Float64 = 2.75
var i: Int32 = Int32 f        // error: integer overflow
                              // info: attempt to construct `Int32` from `Float64`
```

- `docs/lang/value/cons.md` puts no width condition on a float source:
  `IntY` needs `Y≤X` to be implicit and `unsafe` above it, but `FloatY`
  is explicit at any width, and `NatX` reads the same way. `Int64 ←
  Float64` and `Int32 ← Float32` work; everything narrower does not.
- Cause: `value_int_cons` (`src/value/int.py:56`) takes `from_width =
  v.type.width` and rejects `from_width > to_width` for any source. For an
  integer source that is the documented rule; for a float it compares two
  unrelated things — a `Float64` holding `3.0` fits an `Int8`, one holding
  a googol fits nothing — so the width of the float says nothing about
  whether the value fits. `value_nat_cons` (`src/value/nat.py`) has the
  same shape.
- The line just above it is meant to handle exactly this case —
  `if v.is_immediate() and v.type.is_float(): from_width =
  nbits_for_num(int(v.value))`, i.e. ask the *value*, not the type — but
  it only runs for a folded float, and it crashes when it does:

  ```modest
  const c: Float64 = 2.75
  var i: Int64 = Int64 c      // AttributeError: 'ValueConst' object has no attribute 'value'
  ```

  The attribute is `asset`, not `value`; `value_int_cons` uses `v.asset`
  correctly four lines further down. So the fold path has never run.
- Expected: for a float source, check the value where there is one and
  otherwise let it through — the conversion truncates at run time, which
  is what the table promises. Whether an out-of-range float should be an
  error, a trap or undefined is a language question worth settling at the
  same time; C leaves it undefined.
- Coverage: `tests/lang/type/float/narrow_int.modest`, marked
  `EXPECTED-FAIL`. The working half of the table is
  `tests/lang/type/float/cons.modest`, which passes.

## BUG#40: LLVM backend builds the `FixedX` scale in the source float's width

```modest
var h: Float16 = 1.5
var x: Fixed32 = Fixed32 h   // c11: 1.5   llvm: 32767.999985
```

- A `FixedX` value is the number multiplied by `2^fraction`, so the
  conversion in multiplies by that scale — 65536 for the default 16.16
  `Fixed32`. The run-time path in `src/backend/llvm.py` emits
  `f = llvm_eval_binary('fmul', v, scale)` with `scale` created at the
  *source* float's type. 65536 is not a binary16 — the largest one is
  65504 — so the scale rounds to an infinity, and the product with it.
- The compiler used to die packing that constant; it no longer does, which
  only makes the fault quieter. The multiply has to happen at a width that
  holds `2^fraction`.
- `do_eval_from_fixed`, the function immediately below, has the mirror of
  this reasoning written out — "делим в ширине ИСТОЧНИКА: сузить раньше
  деления - потерять целую часть" — and gets the way out right. Only the
  way in was left at the source width.
- Float32 and Float64 hide it: 65536.0 and 2^32 are exact in both, so the
  scale fits and the product is right. `Float16` is the only source that
  fails, which is why the reproducer lives under `float16/`.
- The C backend is unaffected: it calls `__fixed32_from_float64`, which
  takes a `double` whatever the source was.
- Coverage: `tests/lang/type/float/float16/fixed.modest`, marked
  `EXPECTED-FAIL(llvm)`.

## BUG#42: `@layout("packed")` is ignored by both backends

```modest
type Header = @layout("packed") {
	tag: Word8
	len: Nat32
}

sizeof(Header)          // 8, expected 5
offsetof(Header.len)    // 4, expected 1
```

- The attribute is parsed and validated (`copy_with_atts` accepts
  `exact`, `packed`, `union` and stores the string in `nt.layout`,
  `src/hlir/types.py:687`), and then nothing reads it back for packing.
- The LLVM backend does look, but under the wrong name:
  `str_type_record` tests `t.hasAttribute('packed')`
  (`src/backend/llvm.py:907`) while the attribute was added under the kind
  `layout`, so the test is never true and the `<{ ... }>` packed form is
  never emitted. The C backend has no packing to emit at all.
- The layout is decided before either backend anyway:
  `calc_record_size_align` aligns every field as it goes, with no layout
  to consult — it runs from `TypeRecord.__init__`, before
  `copy_with_atts` has attached one. So `sizeof` and `offsetof` would
  stay padded even if both backends emitted the packed form.
- `@layout("exact")` is the default layout under another name and is
  unaffected. `union` is broken differently, see BUG#43.
- Coverage: `tests/lang/type/record/packed.modest`, marked
  `EXPECTED-FAIL` on both backends.

## BUG#43: LLVM backend ignores `@layout("union")`

```modest
type Color = @layout("union") {
	rgba: Word32
	bytes: [4]Word8
}

offsetof(Color.bytes)   // c11: 0    llvm: 4
sizeof(Color)           // c11: 4    llvm: 8
```

- The C backend emits `union` for a record whose `layout` is `union`
  (`isa = 'struct' if not t.layout == 'union' else 'union'`, four places
  in `src/backend/c11.py`). The LLVM backend never mentions `layout` and
  emits its ordinary struct, so the fields sit side by side instead of on
  top of each other: the aliasing the type exists for does not happen,
  and writing one field leaves the others as they were.
- LLVM has no union type — the C one is normally modelled as a struct
  holding a single array of bytes the size of the largest member, with
  each access bitcast to the field's type.
- The offsets come from `calc_record_size_align`, which lays every record
  out in sequence, so a fix has to reach the layout too (BUG#42 is the same
  gap seen from the packed side).
- Coverage: `tests/lang/type/record/union.modest`, marked
  `EXPECTED-FAIL(llvm)`.

## BUG#45: A comment after an empty record literal is a parse error

```modest
var p: Point = {}    // fills the record
```

```
error: unexpected token1 ' fills the record'
```

- Only the empty literal is affected, and only when a comment follows it
  on the same line: `{a = 1} // ...` and `[] // ...` both parse. Line and
  block comments fail alike, so it is the `{}` that leaves the lexer or
  the parser somewhere a comment cannot be read from.
- It bites where `{}` is most natural to explain — the line that fills a
  whole record with its defaults — and the workaround is to put the
  comment on the line above.
- No reproducer in the suite: a test for it would have to be a compile
  failure, and the runner has no expectation for that yet.

## BUG#46: C backend hands a compound literal to the `RAWCAST` macro

```modest
type Point = {x: Int32, y: Int32}
type Vec2 = {x: Int32, y: Int32}

var w: Vec2 = Point {x = 5, y = 6}
```

```c
struct vec2 w = RAWCAST(struct vec2, struct point, (struct point){.x = 5, .y = 6});
// error: too many arguments provided to function-like macro invocation
```

- Two record types with the same fields are one Modest type but two C
  structs, so the backend converts between them with its `RAWCAST` macro.
  The value it passes is a compound literal, whose braces carry commas —
  which the preprocessor reads as further macro arguments, and the
  translation unit does not compile.
- Every position is affected the same way: initializer, argument, and
  operand of `==`. A literal with no type name in front of it is built at
  the target's type in the first place, with no conversion to emit, and
  is fine.
- Fix: parenthesise the value in the macro's expansion site, or emit the
  conversion as a cast through a temporary rather than as a macro.
- Coverage: `tests/lang/type/record/structural_literal.modest`, marked
  `EXPECTED-FAIL(c11)`.

## BUG#47: LLVM backend stores a returned record under the callee's type

```modest
type Point = {x: Int32, y: Int32}
type Vec2 = {x: Int32, y: Int32}

func makeVec () -> Vec2 { ... }

var p: Point = makeVec()
```

```llvm
store %Point %2, %Point* %1   ; %2 is a %Vec2
; error: '%2' defined with type '%Vec2' but expected '%Point'
```

- Between two structurally identical record types the backend bridges the
  two LLVM names by bitcasting the *address*
  (`cons_composite_from_composite_by_adr`), which is why assignment
  between two variables works. A call result has no address to bitcast:
  the value arrives as `%Vec2` and is stored straight into a `%Point*`.
- The C backend converts through `RAWCAST` and is unaffected (its own
  trouble with that macro is BUG#46).
- Coverage: `tests/lang/type/record/structural_call.modest`, marked
  `EXPECTED-FAIL(llvm)`.

## BUG#48: C backend emits an anonymous record before the type it contains

```modest
type Point = {x: Int32, y: Int32}

type World = {
	name: Int32
	body: {pos: Point, speed: Int32}
}
```

```c
struct __anonymous_struct_3 {
	struct point pos;      // error: field has incomplete type
	int32_t speed;
};
struct point { ... };
```

- A struct holding another by value has to be emitted after it. Named
  records are ordered by their dependencies; anonymous ones are all
  written out first, ahead of every named type, including the ones their
  fields name.
- Only by-value fields matter: an anonymous record of scalars, or one
  holding a *pointer* to a named record, compiles.
- The LLVM backend orders both kinds correctly and is unaffected.
- Coverage: `tests/lang/type/record/anonymous_field.modest`, marked
  `EXPECTED-FAIL(c11)`.

## BUG#49: LLVM backend keeps the literal's type for an array of records with a pointer

```modest
type Ref = {tag: Int32, p: *Int32}

var rs: [2]Ref = [{tag = 1, p = &n}, {tag = 2, p = nil}]
```

```llvm
%10 = insertvalue {i8,%Int32*} zeroinitializer, i8 1, 0
store [2 x %Ref] %14, [2 x %Ref]* %9   ; %14 is [2 x {i8,%Int32*}]
; error: '%14' defined with type '[2 x { i8, ptr }]' but expected '[2 x %Ref]'
```

- The element of an array literal is a generic record literal, which has
  to be built at the array's element type. With scalar fields only that
  happens and the element comes out as `%Plain`; with a pointer among the
  fields the element keeps the literal's own type — note the `tag` left
  at the literal's `i8` as well — and the array of those does not store
  into an array of the record.
- One record at a time is fine in both backends; it is only the elements
  of an array literal that are left generic.
- The C backend is unaffected — it writes designated initializers, with
  no element type to get wrong.
- Coverage: `tests/lang/type/record/pointer_field.modest`, marked
  `EXPECTED-FAIL(llvm)`.

## BUG#50: C backend emits an identifier that is a C keyword as it stands

```modest
var double: Int32 = 2
var switch: Int32 = 1
```

```c
int32_t double = 2;    // error: cannot combine with previous declaration specifier
int32_t switch = 1;
```

- Modest's keywords are not C's, so a perfectly ordinary name — `double`,
  `switch`, `case`, `int`, `union`, `register` — reaches the C backend as
  an identifier and is written out unchanged. The generated translation
  unit does not compile, and the diagnostic points at C the author never
  wrote.
- Functions, variables and fields are all affected.
- The LLVM backend is unaffected: its identifiers are prefixed and quoted
  where they need to be.
- Fix: mangle any identifier that is a C keyword on the way out, the way
  the backend already mangles what it has to.
- No reproducer in the suite.

## BUG#51: A type named after a builtin redefines it in the LLVM backend

```modest
type Size = {w: Int32, h: Int32}
```

```llvm
%Size = type i64        ; the prelude's
%Size = type { ... }    ; error: redefinition of type
```

- `Size` is a builtin type name, and the front end lets a module define
  its own without a word: inside that module the user's `Size` wins, and
  `var n: Size = sizeof(Int32)` is reported as `type mismatch Size &
  Integer(8)` — which is the shadowing working as the front end sees it.
- The LLVM backend then emits the user's type under the same `%Size` the
  prelude already defines, and clang refuses the file. Every builtin type
  name is a candidate: `Size`, `Byte`, `Bool`, `File`, `Str8`.
- The C backend is unaffected: it lowercases record tags, so `struct
  size` does not collide with `size_t`.
- Fix: either reject a definition that shadows a builtin type, or emit
  user types under names that cannot collide with the prelude's.
- No reproducer in the suite.

## BUG#52: A branded record cannot be constructed from its parent

```modest
type Point = {x: Int32, y: Int32}
type Brand = @branded Point

var p: Point = {x = 1, y = 2}
var b: Brand = Brand p     // error: cannot construct 'Brand' from 'Point' value
var q: Point = Point b     // error: cannot construct 'Point' from 'Brand' value
```

- `docs/lang/type/branded.md` states both directions as allowed: `B` from
  `T` and `T` from `B`, explicitly, and that is what the whole newtype
  pattern rests on. It holds for scalar parents — `Meters 5.0`,
  `Float64 m` — and fails for a record parent, in both directions, in the
  front end.
- Constructing the brand from a literal works (`Brand {x = 1, y = 2}`),
  so a branded record is usable, only not convertible.
- Explicit construction between two *unbranded* records of the same
  fields is accepted (with an `explicit cons from the same type` note),
  which is the same code path minus the brand.
- No reproducer in the suite: the branded type has no test file yet, and
  `tests/lang/type/branded.modest` is where one belongs.

## BUG#54: An empty record type is emitted as `void` in an initializer

```modest
type Empty = {}
var e: Empty = {}
```

```c
struct empty {uint8_t __placeholder;};
static struct empty e = (void){0};   // error: variable has incomplete type 'void'
```

- The type is declared as a real struct with a placeholder byte, but
  `do_cvalue_cons_record` (`src/backend/c11.py:700`) treats an empty
  record as `Unit` and casts its initializer to `void`. The declaration
  and the initializer disagree, and the translation unit does not
  compile.
- The two views of an empty record need to agree: either it is `Unit` and
  gets no storage, or it is a struct and its initializer is `{0}` under
  the struct's own type.
- No reproducer in the suite: `tests/lang/type/record/` has no empty-record
  case.

## BUG#56: A named variant type crashes the C backend

```modest
type Err = @branded Nat32
type Res = Int32 or Err     // never used
```

```
TypeError: can only concatenate str (not "NoneType") to str
```

- `do_ctype_variant` (`src/backend/c11.py:240`) builds the C name from
  `t.c_anon_id`, which is `None` until something assigns it — nothing
  does for a variant reached through a `type` definition, and the
  definition alone is enough to crash: the type need not be used.
- The LLVM backend accepts the same file — but it does not lower a
  variant at all (`eval_cons_or`, `src/backend/llvm.py:1612`, is a bare
  `1/0`), so nothing that uses one gets past it either.
- Experimental type. `tests/lang/type/variant/basic.modest` covers what does
  work and spells the type out inline to stay clear of this.

## BUG#57: Each written-out variant type becomes its own C struct

```modest
func divide (a: Int32, b: Int32) -> Int32 or Err { ... }

var r: Int32 or Err = divide(10, 2)
```

```c
struct __anonymous_variant_0 {uint8_t tag; union {int32_t _0; Err _1;} value;};
struct __anonymous_variant_1 {uint8_t tag; union {int32_t _0; Err _1;} value;};
...
struct __anonymous_variant_1 r = divide(10, 2);
// error: initializing 'struct __anonymous_variant_1' with an expression
//        of incompatible type 'struct __anonymous_variant_0'
```

- Every occurrence of the same variant type is emitted as a fresh
  anonymous struct, so two spellings of one type do not match in C. The
  language has structural types; the C output makes them nominal, and
  identical variants stop being the same type.
- The natural way to write this — name the type once and use the name —
  is BUG#56, so both spellings of a shared variant type are currently
  unusable and only a value inferred from the call (`let r = divide(...)`)
  gets through.
- Coverage: `tests/lang/type/variant/basic.modest` holds the working shape and
  points here.

## BUG#58: `var` of type `Unit` is accepted and emits `void u;`

```modest
func main () -> Int {
	var u: Unit
	return 0
}
```

```c
void u;   // error: variable has incomplete type 'void'
```

- `Type.is_forbidden_var` (`src/hlir/types.py:1231`) rejects a function
  type and a zero-volume array but says nothing about `Unit`, so a
  variable of the type that has no storage gets storage anyway.
- `Unit` is the result type of a function that returns nothing; a
  variable of it is meaningless and belongs with the other forbidden
  types in `is_forbidden_var`, next to `is_func()`.
- No reproducer in the suite: a `reject` test belongs in
  `tests/lang/type/unit/`.

## BUG#60: Annotations on a local `var` are silently ignored

```modest
func main () -> Int32 {
	@immutable
	var lmax: Int32 = 100
	lmax = 200          // compiles; on a global the same code is an error
	return 0
}
```

- A global definition passes through `def_add_annotations`
  (`src/semantic.py:3227`), which handles the whole annotation set. A
  local `var` never reaches it: `do_stmt_var` (`src/semantic.py:1974`)
  walks `x['anno']` itself and only looks at `static` (and now
  `extern`, which it rejects). Everything else — `@immutable`,
  `@volatile`, `@used`, `@alias`, `@section` — is dropped without a
  word.
- Two outcomes are defensible: apply the annotations that make sense
  for a local, or reject the rest explicitly. Silence is the one that
  is not — `@immutable` reads as enforced and is not.
- No reproducer in the suite: `tests/lang/attribute/` (or wherever the
  annotation tests land) needs both a `reject` case and a case that
  proves an applied annotation works on a local.

## BUG#61: `@extern` variable with an initializer silently drops it

```modest
@extern("C")
var env: []Int32 = [1, 2, 3]
```

```c
extern int32_t env[3];   // the initializer is gone
```

- The initializer is accepted, used to infer the array size, and then
  never emitted, so the source claims storage that the output only
  declares.
- An `@extern` variable is a declaration of storage defined elsewhere;
  an initializer contradicts it and belongs in an error
  (C says the same: `extern int a[] = {...};` is a definition, not a
  declaration). The size should come from the type — `[3]Int32` — not
  from a dropped initializer.
- No reproducer in the suite: a `reject` test belongs next to the other
  `@extern` cases.

## BUG#62: C backend runs two unary signs together into `--` / `++`

```modest
var i: Int32 = 5
printf("%d\n", - -i)          // c11: 4, and i is now 4     llvm: 5
printf("%d\n", + +i)          // c11: 6, and i is now 6     llvm: 5
```

```c
printf("%d\n", --i);          // a pre-decrement, not a double negation
printf("%d\n", ++i);
```

- The worst shape a codegen bug can take: no diagnostic, valid C, and the
  wrong answer *plus* a variable silently mutated. Everything downstream of
  the expression sees the changed value, so one `- -i` moves every later
  reading of `i` by one.
- Cause is the printer, not the backend: `CValueUnaryMinus.__str__`
  (`~/p/cshape/cshape.py:678`) returns `'-%s' % operand` with no separator,
  and `CValueUnaryPlus` (`:667`) does the same with `'+'`. When the operand
  itself prints as `-i` the two signs meet and lex as one token. The other
  three prefix printers are safe: `~~w` and `!!b` are still two tokens in C,
  and `**p` cannot arise from `CValueDeref` alone.
- Only *adjacent* signs collide. `-(-i)` is right, and so is a binary
  operator meeting a unary one — `k - -m` prints with the spaces the binary
  printer puts in. A mixed pair is safe for the same reason: `- +m` prints
  `-+m`, which is two tokens.
- Three in a row stops compiling rather than compiling wrong: `- - -k`
  prints `---k`, and clang refuses it with `expression is not assignable`
  because `--k` is not an lvalue the third `-` can take.
- The `modest` backend prints `--i` too (`-mbackend=modest`), from the same
  shape of code. It only has to survive codegen, so nothing fails there,
  but the emitted source no longer says what the input said.
- The LLVM backend is right: it builds `0 - (0 - i)` as two instructions,
  with no text to run together.
- Fix belongs in cshape: emit a space (or parenthesise) when the operand's
  own text starts with the same sign character.
- Coverage: `tests/lang/value/unary/double_sign.modest`, marked
  `EXPECTED-FAIL(c11)`.

## BUG#63: LLVM backend inverts a literal at the literal's own width

```modest
var a: Word32 = ~0x0F
var b: Word32 = ~0x000000FF
var c: Word64 = ~0x0F
```

| | c11 | llvm |
| :-- | :-- | :-- |
| `~0x0F` → Word32 | `0xfffffff0` | `0x000000f0` |
| `~0x000000FF` → Word32 | `0xffffff00` | `0x00000000` |
| `~0x0F` → Word64 | `0xfffffffffffffff0` | `0x00000000000000f0` |

```llvm
%2 = xor i8 15, -1          ; the inversion happens at the literal's width
%3 = zext i8 %2 to %Word32  ; and the top bits are then filled with zeros
```

- A literal has no type of its own and takes the one it meets, so `~0x0F`
  assigned to a `Word32` is the complement of a 32-bit `0x0000000F`. The
  LLVM backend sizes the literal to its own value first — `0x0F` fits `i8`
  — inverts it there, and *zero*-extends the result, so every bit above the
  literal's width comes out 0 instead of 1.
- The same expression over a variable is right: `var w: Word32 = 0x0F` then
  `~w` emits `xor %Word32 %13, -1` and gives `0xfffffff0`. So the defect is
  specific to a literal operand, which is exactly how a mask is written.
- The wider the target and the smaller the literal, the more bits are lost;
  `~0x0000FFFF` into a `Word32` comes out 0, a mask that selects nothing.
- Not the same as BUG#30, which is the C backend doing narrow `Word`
  operations too *wide*. This one is the LLVM backend doing them too
  *narrow*, and it needs no narrow type to appear in the source.
- Fix: give the literal the target type before the inversion, the way the
  variable path already has it — the `zext` should not be there at all.
- Coverage: `tests/lang/value/unary/literal_width.modest`, marked
  `EXPECTED-FAIL(llvm)`.

## BUG#64: Unary operators accept operand types they are not defined for

The operand class of each unary operator was settled on 2026-09-07:

| Operator | Operand |
| :-- | :-- |
| `not` | Bool — and nothing else |
| `~` | WordX — and nothing else |
| `-`, `+` | IntX, FloatX, FixedX, Integer, Rational |

`not` and `~` are two operators, not two spellings of one: neither crosses
to the other's type. `docs/lang/value/unary.md` states the rule; the
compiler enforces almost none of it.

```modest
var t: Bool = true
var f: Float64 = 1.5
var i: Int32 = 5
var w: Word32 = 5
var n: Nat32 = 5

var a = not w       // accepted; `not` is Bool-only
var b = not i       // accepted; bitwise, -6
var c = ~t          // accepted; `~` is Word-only
var d = ~f          // accepted by modest — then clang and llvm-as reject it
var e = -w          // accepted; wraps, 0xfffffffb
var g = -t          // accepted
var h = +t          // accepted
var k = +n          // error: expected value with signed type
```

- Exactly one check exists — the signedness test behind `-`, which gives
  `expected value with signed type` on a `NatX`. That one is right, and it
  is the only operand rule applied anywhere.
- That check is also asked on the wrong operator. `+` shares it, so the
  picture for the no-op operator is inside out: `NatX` is refused, while
  `WordX` and `Bool` — which the rule does not admit at all — go through.
  Removing `+` from the signedness test and giving both `+` and `-` the
  numeric-operand test is one change, not two.
- Two different costs. Where the operand has an integer representation the
  program compiles and runs with a meaning the language does not define
  (`not` on an `Int32` is a bitwise inversion; `-` on a `Word32` wraps).
  Where it does not, the nonsense reaches the backend and the *user* gets
  the toolchain's diagnostic instead of modest's:

  ```
  c11:  p.c:11:13: error: invalid argument type 'double' to unary expression
  llvm: p.ll:102:11: error: instruction requires integer or integer vector operands
  ```

  `~f` and `not f` on a `FloatX` both do this, under both backends.
- `not` on a `WordX` is the one that has to be *removed* rather than
  refused-at-last: it works today, it is what `docs/lang/value/unary.md`
  used to document, and code may be relying on it. `~` is the spelling that
  survives.
- Coverage: `tests/lang/value/unary/reject_operand_type.modest`, marked
  `EXPECTED-FAIL` on both backends — it is a `reject` test that modest
  currently accepts, so it reports XFAIL until the check lands and XPASS
  the moment it does. The rules that *are* enforced are in
  `tests/lang/value/unary/reject.modest`.

## BUG#65: `&` on an `@immutable var` hands out a writable pointer

```modest
@immutable
var gimm: Int32 = 3

func main () -> Int {
	gimm = 9              // error: expected mutable value
	var p: *Int32 = &gimm // accepted
	*p = 99               // and this writes: gimm is 99
	return 0
}
```

- `docs/lang/value/unary.md` says `&` applies to mutable values, and the
  check exists — `&` on a `let`, on a parameter and on a `const` all give
  `expected mutable value or function`. An `@immutable var` passes it,
  even though direct assignment to the same name is refused two lines up.
- So the annotation is enforced against one way of writing and not the
  other, and the pointer is the way that leaves no trace at the definition.
  Both backends agree, on a global and on a local alike.
- No undefined behaviour is emitted — the C backend prints
  `static int32_t gimm = 3;` with no `const`, and LLVM prints
  `@gimm = internal global %Int32 3` — so this is an unenforced rule
  rather than a miscompilation.
- Related but distinct from BUG#60: that one is about a local `var`'s
  annotations never being read at all. This holds for a *global*
  `@immutable var`, whose annotation is read and does stop assignment.
- Fix: the mutability test behind `&` should ask the same question
  assignment asks. Whether `&` on an immutable value should instead yield a
  pointer-to-immutable is a language question the pointer type does not
  currently have an answer for.
- No reproducer in the suite; it belongs with the `@immutable` tests
  wherever the annotation cases land.

## BUG#66: An annotation after a parameter's type hangs the parser

```modest
module g

func f (x: Int32 @inline) -> Int32 {   // modest never returns
	return 0
}
```

- `@fraction(N)` and the rest go *before* the type (`x: @fraction(16)
  Fixed32`), and that form compiles. Writing the annotation *after* the
  type is simply wrong — but instead of a diagnostic, `modest` spins forever
  and has to be killed.
- It is the `@` that does it, not any particular annotation: `@inline`,
  `@fraction(16)` and `@immutable` all hang, while ordinary junk in the
  same position (`x: Int32 zzz`) is rejected cleanly with
  `unexpected token`. So the parameter-list loop has no progress
  guarantee once it meets `@` where it wants `,` or `)`.
- Only the parameter list is affected. The same misplacement elsewhere
  gives a proper error: `-> Fixed32 @fraction(16)` says
  `unexpected token '{'`, and `var x: Fixed32 @fraction(16) = 1.5` says
  `unexpected token1 '='`.
- Front-end, not codegen: it hangs identically under `-mbackend=c11`,
  `llvm` and `modest`, and no output file is ever written.
- Fix: the parameter-list loop must consume a token or bail on every
  iteration. Worth checking whether the same loop shape is used for
  record fields, which take annotations in the same position.
- No reproducer in the suite; a `reject_` test belongs next to the other
  parameter-parsing tests.

## BUG#67: LLVM backend stores into `None` through a pointer constant

```modest
pragma unsafe

type GPIO = @layout("packed") {
	dir: Word8
	out: Word8
}

const port = unsafe * @volatile GPIO Word16 0x23

func main () -> Int16 {
	port.dir = 0xff
	return 0
}
```

```llvm
store %Word8 %1, %Word8 None
```

- Assigning to a field reached through a `const` that is a dereferenced
  pointer built from a literal address — the memory-mapped register idiom —
  emits the Python `None` where the destination operand belongs. `llc` stops
  at `expected value token`.
- The address itself is never computed: there is no `getelementptr` and no
  `inttoptr` before the store, so the backend loses the destination rather
  than mis-forming it.
- Only the LLVM backend. The C backend handles the same source correctly
  (`PORT->dir = 0xFF;`), and reading the field is fine in both.
- Found through `examples/m328p_blink`, which is the idiom in real use
  (`avr.portB.dir = 0xff`) and does not build because of this: `make` there
  fails at `llc`, and the checked-in `out/llvm/*.ll` predate the breakage.
- Not a precedence question: the sources involved contain no binary
  operators at all.


## BUG#68: `-o` renames the generated files but not the module inside them

```sh
modest -o zzz -mbackend=c11 xxh64.modest
```

```c
/* zzz.c */
#include "xxh64.h"

/* zzz.h */
#if !defined(XXH64_H)
#define XXH64_H
```

- The C11 backend writes `zzz.c` and `zzz.h` as asked, but names the module
  after the source file: the self-include and the include guard both say
  `xxh64`. The `.c` then includes a header that was never written, and clang
  stops at `'xxh64.h' file not found`.
- The reverse case is worse, because it is silent. Two modules whose sources
  share a basename — a test `prog/crc32.modest` linked against
  `lib/misc/crc32.modest` — generate the same guard `CRC32_H` whatever `-o`
  calls the files. The second header to be included is skipped entirely, and
  the program links only if it happens not to need the declarations that were
  dropped.
- So the name a module is known by is the source filename, and `-o` cannot
  change it. Either the module name should follow `-o`, or it should be the
  import path (`misc/crc32`), which is unique by construction.
