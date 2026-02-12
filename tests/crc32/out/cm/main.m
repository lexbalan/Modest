import "misc/crc32"
include "ctypes64"
include "stdio"
include "stdlib"

import "misc/crc32" as crc32


const dataLength = 128
type Test = record {
	data: [dataLength]Byte
	len: Nat32
	hash: Word32
}


var tests: [3]Test = [
	{data = [dataLength]Byte "123456789", len = 9, hash = 0xCBF43926}
	{data = [dataLength]Byte "The quick brown fox jumps over the lazy dog", len = 43, hash = 0x414FA339}
	{data = [dataLength]Byte "Test vector from febooti.com", len = 28, hash = 0x0C877F61}
]


func runTest (test: *Test) -> Bool {
	let crc: Word32 = crc32.run(*[]Byte &test.data, test.len)
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
		i = i + 1
	}

	printf("passed\n")
	return exitSuccess
}

