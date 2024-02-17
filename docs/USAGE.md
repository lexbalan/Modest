
# Compiler usage

##### Example:
```shell
# For translation main.cm to main.c, just type
mcc -o main -mbackend=c main.cm
```

## Compiler flags

Use `-o` option for set output file name (without file extension)

*Usage example:*
```shell
mcc -o main main.cm
```

#### Feature flags
Use `-f` flag for enable some compiler options

**-funsafe** - Enables *unsafe* mode when
  * You can cast pointer to another pointer
  * You can do *pointer arithmetics* (only with [*Pointer*](types.md) type value)

**-fparanoid** - Every warning becomes error


*Usage example:*
```shell
mcc -o main -fparanoid main.cm  # warnings as errors
mcc -o io -fparanoid -funsafe io.cm  # warnings as errors + unsafe mode
```

#### Modifier flags

Use `-m` option to change compiler settings

`-m<varname>=<value>`

*Usage example:*
```shell
mcc -o main -mbackend=c main.cm  # C backend for translation to main.c
mcc -o main -mbackend=cm main.cm  # Modest backend for translation to main.cm
mcc -o main -mbackend=llvm main.cm  # LLVM backend for translation to main.ll
```

