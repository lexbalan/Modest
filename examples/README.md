# Examples

### Hello World

```zig

// for Int & printf
include "libc/stdio"


public func main () -> Int {
    printf("Hello World!\n")
    return 0
}

```

### Multiply table

```zig

include "libc/stdio"


func mtab (n: Nat32) -> Unit {
    var m: Nat32 = 1
    while m < 10 {
        let nm = n * m
        printf("%u * %u = %u\n", n, m, nm)
        // there is only prefix form of ++
        // and it is Statement (!)
        ++m
    }
}


public func main () -> Int {
    let n = 2 * 2
    printf("multiply table for %d\n", n)
    mtab(n)
    return 0
}

```


### Records

```zig

// this example shows how to create records Point & Line
// and determine length of the line

include "libc/math"
include "libc/stdio"


type Point = record {
    x: Float
    y: Float
}

type Line = record {
    a: Point
    b: Point
}


var line: Line = {
    a = {x = 0, y = 0}
    b = {x = 1.0, y = 1.0}
}


@inline
func max (a: Float, b: Float) -> Float {
    if a > b {
        return a
    }
    return b
}

@inline
func min (a: Float, b: Float) -> Float {
    if a < b {
        return a
    }
    return b
}


// Pythagorean theorem
func distance (a: Point, b: Point) -> Float {
    let dx = max(a.x, b.x) - min(a.x, b.x)
    let dy = max(a.y, b.y) - min(a.y, b.y)
    let dx2 = pow(dx, 2)
    let dy2 = pow(dy, 2)
    return sqrt(dx2 + dy2)
}


func lineLength (line: Line) -> Float {
    return distance(line.a, line.b)
}


func ptr_example () -> Unit {
    let ptr_p = *Point malloc(sizeof(Point))

    // access by pointer
    ptr_p.x = 10
    ptr_p.y = 20

    printf("point(%f, %f)\n", ptr_p.x, ptr_p.y)
}


public func main () -> Int {
    // by value
    let len = lineLength(line)
    printf("line length = %f\n", len)

    ptr_example()

    return 0
}

```


### Text file

```zig

// this example shows how to write & read text file

include "libc/stdio"


const filename = *Str8 "file.txt"


func write_example () -> Unit {
    printf("run write_example\n")

    let fp = fopen(filename, "w")

    if fp == nil {
        printf("error: cannot create file '%s'", filename)
        return
    }

    fprintf(fp, "some text.\n")

    fclose(fp)
}


func read_example () -> Unit {
    printf("run read_example\n")

    let fp = fopen(filename, "r")

    if fp == nil {
        printf("error: cannot open file '%s'", filename)
        return
    }

    printf("file '%s' contains: ", filename)
    while true {
        let ch = fgetc(fp)
        if ch == c_EOF {
            break
        }
        putchar(ch)
    }

    fclose(fp)
}


public func main () -> Int {
    printf("text_file example\n")
    write_example()
    read_example()
    return 0
}

```

