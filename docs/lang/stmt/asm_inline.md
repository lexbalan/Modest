# ASM statement

#### Common form

```
    __asm(<# asm_text #>, <# outputs #>, <# inputs #>, <# clobbers #>)
```


#### Examples


```swift
// test/asm/src/main.cm

import "libc/stdio"


func sumsub64(a: Int64, b: Int64) -> Int64 {
    //printf("sumsub64(%lld, %lld)\n", a, b)

    var sum: Int64
    var sub: Int64

    __asm("add %0, %2, %3\nsub %1, %2, %3\n", [["=&r", sum], ["=&r", sub]], [["r", a], ["r", b]], ["cc"])

    printf("sumsub64 sum = %lld\n", sum)
    printf("sumsub64 sub = %lld\n", sub)

    return sum + sub
}


func sum64(a: Int64, b: Int64) -> Int64 {
    var sum: Int64
    __asm("add %0, %1, %2", [["=r", sum]], [["r", a], ["r", b]], ["cc"])
    return sum
}

func sub64(a: Int64, b: Int64) -> Int64 {
    var sub: Int64
    __asm("sub %0, %1, %2", [["=r", sub]], [["r", a], ["r", b]], ["cc"])
    return sub
}


func main() -> Int {
    printf("inline asm test\n")

    var a: Int64 = 10
    var b: Int64 = 20

    let sum = sum64(a, b)
    let sub = sub64(a, b)

    printf("sum(%lld, %lld) = %lld\n", a, b, sum)
    printf("sub(%lld, %lld) = %lld\n", a, b, sub)

    let sumsub = sumsub64(a, b)
    printf("sumsub64(%lld, %lld) = %lld\n", a, b, sumsub)

    return 0
}

```

*Result:*
> inline asm test <br/>
> sumsub64 sum = 30  <br/>
> sumsub64 sub = -10 <br/>
> sumsub64(10, 20) = 20  <br/>


