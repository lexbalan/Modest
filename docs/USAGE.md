
# Compiler usage

##### Example:
```Shell
mcc -o $(OUTDIR)/main -mbackend=cm $(INDIR)/main.cm
```

## Compiler flags

#### Feature flags

**-funsafe** -Enable *unsafe* mode when
  * You can cast pointer to another pointer
  * Enable pointer arithmetics for Pointer type

**-fparanoid** - Every warning becomes error


#### Modifier flags

**-mbackend=backend_name** - 

