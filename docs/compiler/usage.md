# Usage

`mcc` is a thin bash wrapper: it activates the venv and runs
`src/main.py`.

## Invocation

```sh
export MODEST_DIR=/path/to/Modest      # compiler root
export MODEST_LIB=$MODEST_DIR/lib      # library search path

mcc -o <out> [options] <files.m>
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
job — each project's `Makefile` runs `mcc`, then `cc`/`clang` on the
output (see `tests/*/Makefile` for the pattern).

## Testing

```sh
cd tests && ./run.sh        # build + run the test suite
./check.sh                  # tests + build all examples
```

Tests are directories with `src/main.m` and a `Makefile` (`make test`).
The crypto tests (`sha256`, `aes256`, `chacha20`, `crc32`) double as
end-to-end semantic checks against known vectors. Known compiler bugs
are tracked in [../BUGS.md](../BUGS.md), design plans in
[../TODO.md](../TODO.md).
