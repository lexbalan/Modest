// tests/crc32/src/main.m

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"

pragma c_include "./crc32.h"
import "misc/crc32"


const dataLength = 128
type Test = record {
	data: [dataLength]Byte
	len: Nat32
	hash: Word32
}


var tests: []Test = [
	{data = [dataLength]Byte "123456789", len = 9, hash = 0xCBF43926}
	{data = [dataLength]Byte "The quick brown fox jumps over the lazy dog", len = 43, hash = 0x414fa339}
	{data = [dataLength]Byte "Test vector from febooti.com", len = 28, hash = 0x0c877f61}
]


func runTest (test: *Test) -> Bool {
	let crc = crc32.run(*[]Byte &test.data, test.len)
	return crc == test.hash
}


public func main () -> Int {
	printf("CRC32 test ")

	var i = Nat32 0
	while i < lengthof(tests) {
		if not runTest(&tests[i]) {
			printf("#%d failed\n", i)
			return exitFailure
		}
		++i
	}

	printf("passed\n")
	return exitSuccess
}

