
# Compiler usage

##### Example:
```Shell
# For translation main.cm to main.c, just type
mcc -o main -mbackend=c main.cm
```

## Compiler flags

Use `-o` option for set output file name (without file extension)

*Usage example:*
```
mcc -o main main.cm
```

#### Feature flags

**-funsafe** - Enables *unsafe* mode when
  * You can cast pointer to another pointer
  * You can do *pointer arithmetics* (only with [*Pointer*](types.md) type value)

**-fparanoid** - Every warning becomes error


*Usage example:*
```
mcc -o main -fparanoid main.cm
```


#### Modifier flags

Use `-m` option to change compiler settings

`-m<varname>=<value>`

*Usage example:*
```
mcc -o main -mbackend=c main.cm
mcc -o main -mbackend=cm main.cm
mcc -o main -mbackend=llvm main.cm
```

