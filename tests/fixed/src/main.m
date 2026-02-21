// tests/eq/src/main.m

include "libc/stdio"
include "libc/stdlib"


func testFixed32Static () -> Bool {

	var f: @fraction(20) Fixed32
	//var f: Fixed32

	f = 3.1415926535897932384626433832795028841971693993751058209749445923

	let a = f + 1
	let b = f - 1
	let c = f * 2
	let d = f / 2

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


