# Compiler usage

```sh
export MODEST_DIR=/path/to/Modest      # compiler root
export MODEST_LIB=$MODEST_DIR/lib      # library search path

mcc -o main -mbackend=c11 main.modest       # → main.c + main.h
mcc -o main -mbackend=llvm main.modest      # → main.ll
mcc -o main -mbackend=modest main.modest    # → main.modest (pretty-printed)
```

## Flags

| Flag | Meaning |
| :-- | :-- |
| `-o <path>` | output base name (extension is added by the backend) |
| `-mbackend=c11\|llvm\|modest` | backend selection (any `-m<key>=<value>` overrides a config key) |
| `-funsafe` | ignored — [unsafe constructions](./lang/value/cons.md) are enabled by `pragma unsafe` in the module ([BUGS.md](./BUGS.md) #19) |
| `-fparanoid` | warnings become errors |
| `--config=<file.toml>` | target config, applied over `cfg/default.toml` |

The compiler emits source; producing a binary is the build system's job —
run `cc`/`clang` on the output.

Full reference (config layering, `-L`, `-i`, testing):
[compiler/usage.md](./compiler/usage.md).
