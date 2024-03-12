# Built-in constants

```zig
import "libc/stdio"

func main() -> Int {
    printf("__compilerVersionMajor = %u\n", __compilerVersionMajor)
    printf("__compilerVersionMinor = %u\n", __compilerVersionMinor)

    printf("__systemPointerWidth = %i\n", __systemPointerWidth)
    printf("__systemCharWidth = %i\n", __systemCharWidth)
    printf("__systemIntWidth = %i\n", __systemIntWidth)
    printf("__systemFloatWidth = %i\n", __systemFloatWidth)

    printf("__platformSystem = %s\n", *Str8 __platformSystem)
    printf("__platformRelease = %s\n", *Str8 __platformRelease)

    return 0
}

```
