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
