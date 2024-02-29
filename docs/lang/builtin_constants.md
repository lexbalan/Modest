# Built-in constants

```zig
import "libc/stdio"

func main() -> Int {
    printf("__compilerVersionMajor = %i\n", __compilerVersionMajor)
    printf("__compilerVersionMinor = %i\n", __compilerVersionMinor)

    printf("__systemPointerWidth = %i\n", __systemPointerWidth)
    printf("__systemCharWidth = %i\n", __systemCharWidth)
    printf("__systemIntWidth = %i\n", __systemIntWidth)
    printf("__systemFloatWidth = %i\n", __systemFloatWidth)

    printf("__platformSystem = %s\n", __platformSystem to *Str8)
    printf("__platformRelease = %s\n", __platformRelease to *Str8)

    return 0
}

```
