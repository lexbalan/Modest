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
see `do_ctype_array_volume` in `src/backend/c11.py:210`. No reproducer in the
suite — the old `tests/slice` was not carried over into `tests/lang/`.

## 7. C backend emits `arr[from][i]` for a postfix operator on a slice

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

## 20. Malformed expression in a call argument makes `parse_args` spin

```modest
const K: Int32 = 5
printf("%d\n", K)             // no hang any more, but see below
```

- Cause: `parse_args` (`src/parser.py`) has no progress guard — when
  `expr_value` stops without consuming the offending token, the loop keeps
  re-parsing it.
- The malformed argument here comes from #29 — `K` starts with a capital, so
  in a value position it parses as a type and the argument list is left
  standing on `)`. Two errors are printed (`unexpected token1 ')'`, then
  `expected separator`) and only then does `parse_args` start spinning, so the
  diagnostics are not the last thing the user sees.
- Since the lexer got a real end-of-input token (2026-08-30), this no longer
  hangs: the loop drains the rest of the file, then hits `MAX_ERRORS` at EOF
  and exits. That is termination by accident, not a fix — the loop still makes
  no progress, and the user gets ten copies of `unexpected token1
  'end-of-file'` instead of one useful message. `parse_args` still needs a
  no-progress guard.
- The original triggers no longer reproduce at all:

  ```modest
  let w = Word32 0x0F
  printf("%d\n", ~ Word64 w)  // compiles cleanly now
  ```

  Both were unary operators applied above level 13 of the precedence table;
  verified 2026-08-30 that this compiles without a diagnostic. Whether it
  *should* is a separate question — see #29 for the remaining half of the
  misleading-diagnostic story.

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
- The same line also blocks a prefix operator in front of a *builtin*
  operator, which is not a repeated prefix at all: `sizeof`, `alignof`,
  `lengthof`, `offsetof` and `__defined` are parsed in `expr_value_10`
  too, so nothing above level 11 may follow `-`, `~`, `+`, `&` or `not`
  either. Each one is then read as an identifier, and what happens next
  depends on what is inside its parentheses:

  ```modest
  let n = -lengthof(a)      // error: undefined value 'lengthof'
  let b = not __defined(x)  // error: undefined value '__defined'
  let s = -sizeof(Int32)    // mcc spins forever
  let m = -alignof(Int32)   // same
  ```

  `lengthof(a)` and `__defined(x)` hold a value, so the phantom call
  parses and the error is reported. `sizeof(Int32)` holds a *type*, which
  `parse_args` cannot parse and will not skip — so the diagnostic never
  arrives and #20 hangs the compiler instead.
- Fix: call `self.expr_value_10()` instead of `self.expr_value_11()` in the
  five branches. Precedence is unaffected — the level is the same one.
- No test covers repeated prefix operators; `tests/lang/value/unary.modest`
  does not exist yet.

## 28. Bitwise operators reject a pair of literal operands

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
- Worse, a capitalized name used as a call argument does not merely give the
  wrong diagnostic — it hangs the compiler, because the unparsed argument
  trips #20:

  ```modest
  const K: Int32 = 5
  printf("%d\n", K)           // mcc spins forever after two errors
  ```

  `const K` / `const MASK` is exactly the spelling a C programmer writes
  first, so this is the likely first encounter with both bugs at once.
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

## 33. A malformed type crashes the compiler after reporting the error

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

## 34. LLVM backend negates a float with the integer `sub`

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

## 35. Backends disagree about `!=` on a NaN

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

## 36. `FloatX` ↔ `WordX` converts numerically instead of reinterpreting bits

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
  File "src/util.py", line 52, in int_to_bitstring
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

## 37. `IntX` from a wider `FloatY` is rejected as an integer overflow

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

## 38. `%` on a float is accepted, and the C backend emits invalid C

```modest
var a: Float64 = 5.0
var b: Float64 = 2.0
printf("%f\n", a % b)
```

```
c11:  invalid operands to binary expression ('double' and 'double')
llvm: 1.000000
```

- `docs/lang/value/binary.md` restricts `%` to integers ("`%`: integers
  only"), and `docs/lang/type/base.md` gives `FloatX` the classes `equ`,
  `ord` and `math` without `rem`. The frontend does not enforce either:
  the operation is accepted and handed to the backends.
- The C backend prints it as C's `%`, which does not exist for `double`,
  so the module does not compile — the error surfaces from clang, naming C
  types the author never wrote. The LLVM backend prints `frem` and
  computes a correct floating-point remainder.
- So the same program is a compile error one way and a working program the
  other, and neither matches the documentation.
- Expected: reject `%` on a `FloatX` operand in the frontend, next to where
  the bitwise operators are rejected for it (`unsuitable value type
  'Float64' for 'bitwise-and' operation` is already the diagnostic for
  `a & b`). If the language would rather have the operation, it needs a
  line in `binary.md` and a `fmod` in the C backend — but that is a
  language decision, not a backend one.
- No reproducer in the suite: a positive test cannot assert an operation
  the language does not have.

## 39. LLVM backend dies on a float literal past the target's range

```modest
var m: Float16 = 70000.0     // c11: inf     llvm: OverflowError, traceback
```

```
File "src/util.py", line 143, in pack_float
    return struct.unpack('<e', struct.pack('<e', f))[0]
OverflowError: float too large to pack with e format
```

- `pack_float` (`src/util.py:139`) rounds a folded constant to the width
  of its type before the LLVM backend prints it — the comment at
  `print_rational` (`src/backend/llvm.py:497`) explains why it must. For a
  value outside the target's range `struct.pack` raises instead of
  returning an infinity, and nothing catches it.
- Not specific to `Float16`: the `'<f'` branch one line below does the same
  for a `Float32` literal above 3.4e38. Binary16 is simply where an
  ordinary five-digit number reaches it, since the largest finite one is
  65504.
- The C backend prints the literal as C and lets the compiler round it, so
  the same source gives `inf` there. Two backends, one traceback and one
  answer.
- What the *language* should do here is a separate question, worth settling
  with the fix: `docs/lang/value/cons.md` makes a compile-time integer
  overflow an error (`Nat8 256` does not compile), and the same argument
  could be made for a float literal that does not fit. IEEE 754 says
  infinity. Either is defensible; a Python traceback is neither.
- Coverage: `tests/lang/type/float/float16/range.modest`, marked
  `EXPECTED-FAIL(llvm)`. It asserts the IEEE answer, which is what the
  working backend already gives.

## 40. LLVM backend builds the `FixedX` scale in the source float's width

```modest
var h: Float16 = 1.5
var x: Fixed32 = Fixed32 h   // c11: 1.5   llvm: OverflowError, traceback
```

- A `FixedX` value is the number multiplied by `2^fraction`, so the
  conversion in multiplies by that scale — 65536 for the default 16.16
  `Fixed32`. The run-time path in `src/backend/llvm.py` emits
  `f = llvm_eval_binary('fmul', v, scale)` with `scale` created at the
  *source* float's type. 65536 is not a binary16 — the largest one is
  65504 — so the compiler dies packing the constant (through the same
  `pack_float` as #39) before the product is ever emitted.
- Even with #39 fixed this stays wrong: the scale would become `inf` and
  the product with it, and any `Float16` source would convert to garbage.
  The multiply has to happen at a width that holds `2^fraction`.
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
