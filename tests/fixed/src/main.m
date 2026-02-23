// tests/eq/src/main.m

pragma unsafe

include "libc/stdio"
include "libc/stdlib"


// fx = i + m/n
func packFixed32 (i: Nat32, m: Nat32, n: Nat32 fraction: Nat8) -> Fixed32 {
	let tail = Nat64 m * (Nat64(Word32 1 << fraction) - 1) / Nat64 n
	return unsafe Fixed32 ((Word32 i << fraction) or unsafe Word32 tail)
}


// just returns head as is
func headFixed32 (f: Word32, fraction: Nat8) -> Nat32 {
	return unsafe Nat32 (f >> fraction)
}


// just returns tail as is
func tailFixed32 (f: Word32, fraction: Nat8) -> Nat32 {
	let mask = Word32(Nat32(Word32 1 << fraction) - 1)
	return Nat32(f and mask)
}


// precision = 10 ... 1000000 - number of zeroes = number of digits in output value
func printFixed32 (f: Word32, fraction: Nat8, precision: Nat32) -> Unit {
	let h = headFixed32(f, fraction)
	let t = tailFixed32(f, fraction)
	let tail = unsafe Nat32 (Nat64 t * Nat64 precision / Nat64(Word32 1 << fraction))
	printf("%d.%d", h, tail)
}


func testFixed32Static () -> Bool {
	@static
	var st: Nat32

	var f: @fraction(18) Fixed32
	//var f: Fixed32

	f = 3.1415926535897932384626433832795028841971693993751058209749445923

	let a = f + 1
	let b = f - 1
	let c = f * 2
	let d = f / 2

	printf("fx = ")
	printFixed32(Word32 f, 18, 1000000)
	printf("\n")

	let f2 = packFixed32(3, 1415926, 10000000, 20)
	printf("f2 = ")
	printFixed32(Word32 f2, 20, 10000000)
	printf("\n")

	printf("Raw f = %d\n", f)
	printf("Raw a = %d\n", a)
	printf("Raw b = %d\n", b)
	printf("Raw c = %d\n", c)
	printf("Raw d = %d\n", d)

	printf("Int32 f = %d\n", Int32 f)
	printf("Int32 a = %d\n", Int32 a)
	printf("Int32 b = %d\n", Int32 b)
	printf("Int32 c = %d\n", Int32 c)
	printf("Int32 d = %d\n", Int32 d)

	printf("Float32 f = %f\n", Float32 f)
	printf("Float32 a = %f\n", Float32 a)
	printf("Float32 b = %f\n", Float32 b)
	printf("Float32 c = %f\n", Float32 c)
	printf("Float32 d = %f\n", Float32 d)

	return true
}


public func main () -> Int32 {
	printf("test fixed\n")

	let success = testFixed32Static()

	printf("test ")
	if not success {
		printf("failed\n")
    	return exitFailure
	}

    printf("passed\n")
    return exitSuccess
}


