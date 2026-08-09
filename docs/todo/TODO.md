# Design TODO

## Comment pass-through to output

Design intent (Alex, 2026-07-08): the `c11` and `modest` backends should
carry source comments into the output text; the `llvm` backend is not
required to.

Status: currently comments are dropped by `c11` entirely, and `modest`
preserves only module-level `//` comments. `docs/lang/comments.md`
documents the current behavior. To be fixed.

## Identifier-class errors: parser → trans

Observation (2026-07-08): the lexical id/Id split produces poor
diagnostics at definition sites — `var Xx: Int32` fails with
`unexpected token 'newline'`, and `type myInt = ...` parses silently
but the name is unusable in type position.

Direction: keep the lexical split itself (it is load-bearing — `Id`
starting a type expression is what disambiguates construction
`Int32 x` from a call/value without semantic lookahead), but let the
parser accept either class at *definition-name* position and report the
mismatch in trans (or at parse time) with a clear message:
`type name must start with an uppercase letter` /
`value name must start with a lowercase letter`.

## Zero-terminated strings via `@zarray`

Design intent (Alex, 2026-06-11):

- A string literal contains **exactly** the characters written — no
  implicit terminator.
- The terminator appears at *construction* of a zero-terminated array.
  `@zarray` marks an array type as zero-terminated; constructing a value
  of such type appends the terminator.
- The built-in string types should carry the attribute:

  ```modest
  type Str8  = @zarray []Char8
  type Str16 = @zarray []Char16
  type Str32 = @zarray []Char32
  ```

- Consequences:
  - `*Str8 "xxx"` → array of 4 chars (terminator appended by
    construction);
  - `[]Char8 "xxx"` → array of exactly 3 chars, **no** terminator.

Status: the `@zarray` annotation is recognized by the compiler
(`hlir/types.py`), but the built-in `Str*` types do not carry it yet;
zero-termination currently comes from the C backend emitting C string
literals. To be implemented.

## Stack budget diagnostics

Idea (2026-06-12): per-target limits in `cfg/*.toml`, each producing a
warning when exceeded (error under `-f paranoid`). Three separate
limits — they answer different questions and have different fixes:

```toml
byvalue_copy_warn  = 64    # 1. implicit copy at a call boundary
stack_object_warn  = 128   # 2. single local object size
frame_warn         = 256   # 3. estimated locals total per function
```

1. **By-value copy** (param / return / assignment of a large value) —
   "you are copying needlessly"; fix: pass `*[N]T` / `*[]T`.

   ```
   warning: array of 4096 bytes passed by value (threshold 64);
            consider *[N]T
   ```

2. **Stack object** — "you are spending the budget"; a large local may
   be intentional but must be visible; fix: move to a global / pool.

3. **Frame size** — sum of locals per function. Honest *lower-bound
   estimate* only: actual layout, spills and alignment are decided by
   the C compiler, and VLAs are unbounded at compile time (warn on VLA
   presence separately?). Embedded analogue: GCC `-fstack-usage`.

Future extension: frame estimates + call graph + recursion ban =
statically provable max stack depth for the whole program — a rare and
valuable guarantee for embedded targets.

(Related but rejected for now: RVO-style lowering of array returns to
write directly into `__out` — deliberately left to the C optimizer.)

## Settings hierarchy: config → CLI → pragma

Idea (2026-06-12): one settings model with three layers, closest to the
code wins (same shadowing rule as name scoping):

1. `cfg/*.toml` — target/project knowledge, lives in the repo;
2. CLI flags (`-m`, `-f`) — knowledge of this particular build (CI,
   debugging); already override config;
3. module-level pragmas — the module author's knowledge, travels with
   the code; already exists ad hoc (`pragma unsafe`, `pragma prefix`).

Design constraints to resolve **before** implementing:

- **Whitelist.** Only locally-scoped settings are pragma-overridable
  (warning thresholds, unsafe, prefix, output style). Globally-coherent
  settings (type widths, arch/ABI/endianness, backend) must not vary
  per module — differing `intWidth` between modules breaks ABI at the
  module boundary.
- **Tighten-only for safety keys.** A pragma must not weaken what the
  CLI demanded (CI runs `-f paranoid`; a module must not opt out).
  Precedent: Rust `allow`/`warn`/`deny` are overridable, `forbid` is
  final. One rule suffices: inner layers may only increase strictness
  of safety-class keys (or: config/CLI may mark a key `final`).
- **Provenance.** With three layers, diagnostics need "who set this
  value": store the origin (`cfg/avr.toml:12` / CLI / `pragma at
  main.m:3`) next to the value, show it in `-v` and in warning texts.
  Analogue: `git config --show-origin`.

## Conditional compilation (`$`-directives)

Historical design, currently not implemented (the lexer tokenizes
`$name`, the parser rejects it at top level):

```
$if (<#immediate Bool#>)
	...
$elseif (<#immediate Bool#>)
	...
$else
	...
$endif
```

Companions from the same design: `__defined("id")`, `@undef("id")`,
compiler messages `@info` / `@warning` / `@error`, `@feature("unsafe")`.
Removed from `docs/lang/directive.md` (which now documents pragmas)
until reimplemented.

## LLVM backend: merge `ass` and `ass2`

Cleanup noted 2026-08-09, while fixing an invalid-IR bug in the LLVM
backend (former `BUGS.md` #17).

`src/backend/llvm.py` has two near-identical helpers that turn a value
plus indexes into an address:

| helper | called from | for |
| :-- | :-- | :-- |
| `ass` | `do_eval_index` | array element |
| `ass2` | `do_eval_access` | record field |

They differ in only two ways: `ass2` checks `by_value(left)` and falls
back to `extractvalue` for an operand that has no address, while `ass`
assumes a pointer unconditionally; and `ass` prepends the leading zero
index itself where `ass2` does it in the pointer branch. `ass` also
carries the VLA special case, which `ass2` has no need for.

That asymmetry was the bug: `b.data[0]` on a by-value record parameter
went through `ass2` (correctly producing a register value), then through
`ass` (which emitted `getelementptr` on a non-pointer). The fix gave
composite parameters an address on entry — see `param_needs_holder` — so
`ass` now always gets what it assumes. The duplication remains.

Direction: one helper. `do_eval_slice` contains a *third* copy of the
same by-value check (with a nice `expected immediate index value`
diagnostic for the runtime-index case), so there are three places
encoding one rule. Worth folding together — the class of bug this
produces is silent invalid output, not a compile error.

Also worth revisiting at the same time: `param_needs_holder` must be
consulted in three places (parameter naming, the locals table, the
holder `alloca`) and the emitted IR contradicts itself if they disagree
— that coupling would be better expressed once.
