// tests/crc32/src/main.m

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"

import "misc/crc32"


const dataBufferLength = 128

type Test = record {
	data: [dataBufferLength]Byte
	len: Nat32
	hash: Word32
}


var tests: []Test = [
	{data = [dataBufferLength]Byte "123456789", len = 9, hash = 0xcbf43926}
	{data = [dataBufferLength]Byte "The quick brown fox jumps over the lazy dog", len = 43, hash = 0x414fa339}
	{data = [dataBufferLength]Byte "Test vector from febooti.com", len = 28, hash = 0x0c877f61}
]


func runTest (test: *Test) -> Bool {
	let crc = crc32.run(*[]Byte &test.data, test.len)
	return crc == test.hash
}


public func main () -> Int {
	printf("test CRC32\n")

	// (!)
	crc32.init()

	var success = true

	var i = Nat32 0
	while i < lengthof(tests) {
		if not runTest(&tests[i]) {
			printf("test #%d failed\n", i)
			success = false
		} else {
			printf("test #%d passed\n", i)
		}
		++i
	}

	printf("test ")
	if not success {
		printf("failed\n")
    	return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}

