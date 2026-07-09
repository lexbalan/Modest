# Known Bugs

Found 2026-06-11 while verifying documentation against the compiler.

## 1. Relative output path resolves to filesystem root

```sh
mcc -o out -mbackend=c11 main.m
# OSError: [Errno 30] Read-only file system: '/out.h'
```

`mcc -o <relative>` tries to write `/<name>.h`. Workaround: pass an
absolute path to `-o`. Path resolution in `src/main.py` (`include_dir` /
`outname` handling) + `src/backend/c11.py:2276`.

## 2. ICE on `let` without initializer

```modest
func main () -> Int {
	let x: Int32        // ZeroDivisionError in backend
	return 0
}
```

Crashes with `ZeroDivisionError` from the `1/0` placeholder at
`src/backend/c11.py:1273` (`elif x.isValueUndef(): 1/0`). Should be a
normal frontend error: `let` requires an initializer.

## 3. Slice assignment: wrong element type and byte count in C output

```modest
var arr: [5]Int32 = [9, 9, 9, 9, 9]
arr[1:4] = [3]Int32 [1, 2, 3]
```

Generates:

```c
__builtin_memcpy(&arr[1], ((&(int8_t [3]){1, 2, 3})), 4 - 1);
```

Wrong on two counts: the RHS literal is emitted as `int8_t[3]` regardless
of the declared `Int32` element type, and the length `4 - 1` is bytes,
not elements (should be `(4 - 1) * sizeof(int32_t)`). Generated C also
fails to compile (`cc` rejects it). Slice codegen in `src/backend/c11.py`.

## 4. Unsized-array variable with initializer: parse error at local scope

```modest
var s: []Char8 = "abc"     // OK at module level -> char s[3]
func main () -> Int {
	var t: []Char8 = "abc"   // error: expected ']' token
	return 0
}
```

At module level the "holed" type is completed from the initializer; the
same definition inside a function body fails to parse. Inconsistency —
parser statement path (`stmt_var` / type-vs-value disambiguation).
Or is locals-must-be-concrete intended? (question for Alex)

## 5. `builtin.*` namespace does not resolve (regression)

```modest
var w: builtin.target.Word        // error: unknown value
let v = builtin.compiler.version  // error: unknown value
```

The wiring exists (`create_builtin_module`, auto-import at
`src/semantic.py:2707`), but any `builtin.x` access fails with
`unknown value`. The repo's own `tests/builtin` fails with 10 errors —
it is not listed in `tests/run.sh`, so the regression went unnoticed.
Affects everything documented in `docs/lang/builtin_constants.md`.

## 6. Lexer accepts non-ASCII identifiers

```modest
var счётчик: Int32 = 0    // compiles, emitted into C as-is
```

By design (Alex, 2026-07-08) identifiers are ASCII Latin only; Unicode
is allowed only in comments and string literals. The lexer uses Python
`str.isalpha()` (`src/lexer.py`: `doId`, `isIdChar`), which accepts any
Unicode letter and passes it through to the output — works with clang,
not guaranteed elsewhere. Fix: restrict `doId` / `isIdChar` to
`[A-Za-z0-9_]`.

## 7. `__va_copy` result is unusable

```modest
var va, va2: __VA_List
__va_start(va, format)
__va_copy(va2, va)
vprintf(format, va2)      // error: attempt to use an uninitialized value
```

`do_value_va_copy` (`src/semantic.py:1053`) does not mark the destination
list as initialized — unlike `do_value_va_start`, which sets
`is_initialized = True` on its list. Copying works, but any subsequent
read of the copy is rejected, which defeats the purpose. Fix: set
`va_list0.is_initialized = True` in `do_value_va_copy`.
