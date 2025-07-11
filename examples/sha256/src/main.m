// tests/sha256/src/main.m

include "libc/ctypes64"
include "libc/stdio"


import "misc/sha256"
pragma c_include "./sha256.h"


const inputDataLength = 32


type SHA256_TestCase = record {
	input_data: [inputDataLength]Char8
	input_data_len: Nat32

	expected_result: sha256.Hash
	//expected_result2: Word256
}


var test0 = SHA256_TestCase {
	input_data = "abc"
	input_data_len = 3
	expected_result = [
		0xBA, 0x78, 0x16, 0xBF, 0x8F, 0x01, 0xCF, 0xEA
		0x41, 0x41, 0x40, 0xDE, 0x5D, 0xAE, 0x22, 0x23
		0xB0, 0x03, 0x61, 0xA3, 0x96, 0x17, 0x7A, 0x9C
		0xB4, 0x10, 0xFF, 0x61, 0xF2, 0x00, 0x15, 0xAD
	]

	//expected_result2 = 0xBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD
}

var test1 = SHA256_TestCase {
	input_data = "Hello World!"
	input_data_len = 12
	expected_result = [
		0x7F, 0x83, 0xB1, 0x65, 0x7F, 0xF1, 0xFC, 0x53
		0xB9, 0x2D, 0xC1, 0x81, 0x48, 0xA1, 0xD6, 0x5D
		0xFC, 0x2D, 0x4B, 0x1F, 0xA3, 0xD6, 0x77, 0x28
		0x4A, 0xDD, 0xD2, 0x00, 0x12, 0x6D, 0x90, 0x69
	]

	//expected_result2 = 0x7F83B1657FF1FC53B92DC18148A1D65DFC2D4B1FA3D677284ADDD200126D9069
}


const tests = [&test0, &test1]


func doTest(test: *SHA256_TestCase) -> Bool {
	var test_hash: sha256.Hash
	let msg = unsafe *[]Word8 &test.input_data
	let msg_len = test.input_data_len

	sha256.hash(msg, msg_len, &test_hash)

	printf("'%s'", &test.input_data)
	printf(" -> ")

	var i: Nat32 = 0
	while i < sha256.hashSize {
		printf("%02X", test_hash[i])
		++i
	}

	printf("\n")

	return test_hash == test.expected_result
}


public func main () -> Int {
	printf("test SHA256\n")

	var i: Nat32 = 0
	while i < lengthof(tests) {
		let test = tests[i]
		let test_result = doTest(test)

		var res = *Str8 "failed"
		if test_result {
			res = "passed"
		}

		printf("test #%i: %s\n", i, res)

		++i
	}

	return 0
}


