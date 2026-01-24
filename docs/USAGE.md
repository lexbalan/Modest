
# Compiler usage

##### Example:
```shell
# For translation main.cm to main.c, just type
mcc -omain -mbackend=c11 main.cm
```

## Compiler flags

#### Output flag
Use `-o<output_file_name>` option for set output file name (without file extension)

*Usage example:*
```shell
mcc -o main main.cm
```

#### Feature flags
Use `-f<feature_name>` flag for enable some compiler options

***-funsafe*** - Enables *unsafe* mode when:
  * You can cast pointer to another pointer
  * You can do *pointer arithmetics* (only with [*FreePointer*](./type/pointer.md#Free-pointer) type value)

***-fparanoid*** - Every warning becomes error


*Usage example:*
```shell
mcc -o main -fparanoid main.cm	   # warnings as errors
mcc -o io -fparanoid -funsafe io.cm  # warnings as errors + unsafe mode
```

#### Modifier flags

Use `-m<varname>=<value>` option to change compiler settings

***-fbackend=<backend_name>*** - backend switching

*Usage example:*
```shell
mcc -o main -mbackend=c11  main.cm     # use C backend for translation to main.c
mcc -o main -mbackend=cm  main.cm    # use Modest backend for translation to main.cm
mcc -o main -mbackend=llvm  main.cm  # use LLVM backend for translation to main.ll
```

