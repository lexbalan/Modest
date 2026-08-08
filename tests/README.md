# Tests

Positive tests: each one compiles a Modest program, runs it, and checks
that it behaved as declared.  A test that only compiles proves very little,
so the default is to actually execute the result.

```sh
./run.py                # everything
./run.py while          # only tests whose path contains "while"
./run.py -b c11         # only the C11 backend
./run.py -v             # full compiler/program output for failures
./run.py --keep         # keep the generated .c/.ll and print their path
./run.py --list         # what would run
```

The runner exits non-zero if anything failed, and it always runs the whole
suite — one broken test never hides the rest.

A failure reports where it happened, not just that it happened: for a
compiler failure, the first diagnostic with its line; for a program that
returned the wrong code, the last thing it printed before giving up —
which, by the self-checking convention above, is the check that failed.

```
FAIL  lang/stmt/assign.m [c11] — exit 1, expected 0
      arr[1:4] = [7, 8, 0], expected [7, 8, 9]
      failed: assign

FAIL  lang/stmt/if.m [llvm] — clang failed (exit 1)
      if.ll:188: expected instruction opcode
```

Use `-v` when that is not enough, and `--keep` when the generated `.c` or
`.ll` is what you need to look at.

Nothing is built inside `tests/`.  Every case gets a fresh temporary
directory that is removed afterwards (`--keep` keeps it and prints the
path), so there is no generated output to gitignore, stage by accident, or
mistake for a source file.

## Writing a test

A test is one `.m` file.  Its leading comment block declares the
expectations; everything below is an ordinary Modest program.

```modest
// TEST: run
// BACKENDS: c11, llvm, modest
// EXPECT-EXIT: 0
// EXPECT-OUT: passed: while

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"

func main () -> Int {
	printf("passed: while\n")
	return exitSuccess
}
```

The program checks itself and reports through its exit code —
`exitSuccess` / `exitFailure` from `libc/stdlib`.  `EXPECT-OUT` is for
confirming that the checks it claims to run really ran: a program that
prints nothing and returns 0 also "passes" otherwise.

### Directives

| Directive | Default | Meaning |
|---|---|---|
| `TEST: run` | `run` | `run` = compile, link, execute. `build` = stop after linking |
| `BACKENDS: c11, llvm` | `c11, llvm` | which backends to run under |
| `EXPECT-EXIT: 0` | `0` | required exit code |
| `EXPECT-OUT: text` | — | substring that must appear in stdout; repeatable, matched **in order** |
| `LINK: other.m` | — | extra sources compiled and linked with this one (multi-module tests) |
| `FLAGS: -funsafe` | — | extra flags passed to `mcc` |
| `EXPECTED-FAIL: reason` | — | known-broken; see below |

A directive may be narrowed to some backends by naming them in
parentheses — `EXPECTED-FAIL(llvm): ...` marks the test broken under LLVM
only, and it still has to pass everywhere else.

`modest` is a valid backend here, but it emits Modest source rather than
something clang can link, so for it a test stops after code generation.

### Known-broken tests

A test for a bug that is not fixed yet stays in the suite, marked:

```modest
// EXPECTED-FAIL: BUGS.md#5 builtin.* does not resolve
// EXPECTED-FAIL(llvm): BUGS.md#13 invalid IR when every if branch returns
```

It is then expected to fail, and reported as `XFAIL` without failing the
run.  If it ever *passes*, the runner reports `XPASS` and fails the suite —
so a fixed bug forces the marker to be removed, in step with deleting the
entry from `docs/BUGS.md`.

This exists so that a broken test is never deleted or commented out of the
run to keep things green.  Both of those lose the information that the bug
has a reproducer.

## Layout

`lang/` mirrors `docs/lang/`, so a documented construct and its test sit at
the same path:

```
docs/lang/stmt/while.md   ->   tests/lang/stmt/while.m
```

Directories whose name starts with `_` are skipped by discovery — use them
for fixtures that are not tests themselves.
