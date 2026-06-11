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
