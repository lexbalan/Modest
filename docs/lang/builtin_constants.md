# Built-in Constants

Every module implicitly imports the `builtin` namespace with information
about the compiler and the target platform.

> **Status:** resolution of `builtin.*` is currently broken on the dev
> branch — see `docs/BUGS.md` (#5). The reference below describes the
> intended interface (`tests/builtin`).

## Reference

```modest
// compiler
builtin.compiler.name                 // *Str
builtin.compiler.version.major        // Nat32
builtin.compiler.version.minor        // Nat32
builtin.compiler.version.patch        // Nat32

// target: widths (configured by cfg/*.toml)
builtin.target.pointerWidth           // bits
builtin.target.charWidth
builtin.target.intWidth
builtin.target.floatWidth

// target: identity (branded string constants for comparison)
builtin.target.name
builtin.target.arch       // compare with: archX86, archX86_64, archArm,
                          //   archAarch64, archRiscv32, archRiscv64
builtin.target.os         // osLinux, osMacos, ...
builtin.target.abi        // abiSysV, abiEabi, ...
builtin.target.endian     // endianLittle, endianBig

// target-width type aliases
builtin.target.Word, builtin.target.Int, builtin.target.Nat
```

The unqualified aliases `Int`, `Nat`, `Word`, `Size` are also available
directly (see [base types](./type/base.md)).

## Example

```modest
if builtin.target.endian == builtin.target.endianLittle {
	printf("little-endian\n")
}

var w: builtin.target.Word            // target word width
```
