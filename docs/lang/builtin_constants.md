# Built-in Constants

Every module implicitly imports the `builtin` namespace with information
about the compiler and the target platform.

> **Status:** resolution of `builtin.*` is currently broken on the dev
> branch — see `docs/BUGS.md` (#5). The reference below describes the
> intended interface (`tests/builtin`).

## Top-level constants

A few constants are bound directly at module scope, not under the
`builtin.` namespace, so they are unaffected by the resolution bug above:

```modest
true, false          // Bool
nil                  // untyped null pointer
```

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
builtin.target.rationalPrecision      // decimal digits — see below

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

`builtin.target.rationalPrecision` (`Integer`, 256 by default) mirrors
`precision` in `cfg/*.toml`: the number of significant decimal digits
the **C backend** writes out when it renders a `Rational`/`Float`
constant literal as text. It does not affect `Rational` arithmetic
itself (already exact via an arbitrary-precision fraction), and it has
no effect on the LLVM backend, which always rounds such literals to
`Float64`. Nor does it carry through a compound expression (`3.14 +
0.5`) — see
[Rational precision](./type/generic.md#rational-precision) for the full
picture and caveats.

## Example

```modest
if builtin.target.endian == builtin.target.endianLittle {
	printf("little-endian\n")
}

var w: builtin.target.Word            // target word width

printf("rational precision: %d digits\n", Int32 builtin.target.rationalPrecision)
```
