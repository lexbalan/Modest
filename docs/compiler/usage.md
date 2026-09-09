# Usage

`modest` is a thin bash wrapper: it activates the venv and runs
`src/main.py`.

## Invocation

```sh
export MODEST_DIR=/path/to/Modest      # compiler root
export MODEST_LIB=$MODEST_DIR/lib      # library search path

modest -o <out> [options] <files.modest>
```

| Option | Meaning |
| :-- | :-- |
| `-o <path>` | output base name (`<path>.c`, `<path>.h`, `<path>.ll`, ...) |
| `-mbackend=c11\|llvm\|modest` | backend selection (any `-m<key>=<value>` overrides a config key) |
| `--config=<file.toml>` | target config, applied over `cfg/default.toml` |
| `-f <feature>` | enable a feature (`unsafe`, `paranoid`) |
| `-L <path>` | library path (overrides `MODEST_LIB`) |
| `-i <dir>` | directory for emitted `#include` paths |

Configuration is layered: `cfg/default.toml` → `--config` file → `-m`
overrides. The config defines the target (arch, OS, ABI, endianness),
type widths (`int_width`, `pointer_width`, ...) and the backend.

The compiler emits source; producing a binary is the build system's
job — each project's `Makefile` runs `modest`, then `cc`/`clang` on the
output (see `examples/*/Makefile` for the pattern).

## Testing

```sh
cd tests && ./run.py        # the whole suite
./run.py -b c11             # one backend
./run.py prog               # one part of the tree
```

One `.modest` file per test, expectations in its leading comment block:
`lang/` per language feature, `prog/` whole programs — the latter includes
the known-answer tests for `sha256`, `aes256`, `chacha20`, `crc32` and
`xxh64`. Known compiler bugs
are tracked in [../BUGS.md](../BUGS.md), design plans in
[../todo/TODO.md](../todo/TODO.md).
