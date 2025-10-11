import "misc/sha256"
include "ctypes64"
include "stdio"
// tests/sha256/src/main.m
import "misc/sha256" as sha256

const inputDataLength = 32


type SHA256_TestCase = record {
	inputData: [inputDataLength]Char8
	inputDataLen: Nat32

	expectedResult: Hash
}


var test0: SHA256_TestCase = SHA256_TestCase {
	inputData = "abc"
	inputDataLen = 3
	expectedResult = [
		0xBA, 0x78, 0x16, 0xBF, 0x8F, 0x01, 0xCF, 0xEA
		0x41, 0x41, 0x40, 0xDE, 0x5D, 0xAE, 0x22, 0x23
		0xB0, 0x03, 0x61, 0xA3, 0x96, 0x17, 0x7A, 0x9C
		0xB4, 0x10, 0xFF, 0x61, 0xF2, 0x00, 0x15, 0xAD
	]
}

var test1: SHA256_TestCase = SHA256_TestCase {
	inputData = "Hello World!"
	inputDataLen = 12
	expectedResult = [
		0x7F, 0x83, 0xB1, 0x65, 0x7F, 0xF1, 0xFC, 0x53
		0xB9, 0x2D, 0xC1, 0x81, 0x48, 0xA1, 0xD6, 0x5D
		0xFC, 0x2D, 0x4B, 0x1F, 0xA3, 0xD6, 0x77, 0x28
		0x4A, 0xDD, 0xD2, 0x00, 0x12, 0x6D, 0x90, 0x69
	]
}


const tests = [&test0, &test1]


func doTest (test: *SHA256_TestCase) -> Bool {
	var test_hash: Hash
	let msg: *[]Word8 = unsafe *[]Word8 &test.inputData
	let msgLen: Nat32 = test.inputDataLen

	sha256.hash(msg, msgLen, &test_hash)

	printf("'%s'", &test.inputData)
	printf(" -> ")

	var i: Nat32 = 0
	while i < sha256.hashSize {
		printf("%02X", test_hash[i])
		i = i + 1
	}

	printf("\n")

	return test_hash == test.expectedResult
}


public func main () -> Int {
	printf("test SHA256\n")

	var i: Nat32 = 0
	while i < lengthof(tests) {
		let test: *SHA256_TestCase = tests[i]
		let testResult: Bool = doTest(test)

		var res = *Str8 "failed"
		if testResult {
			res = "passed"
		}

		printf("test #%i: %s\n", i, res)

		i = i + 1
	}

	return 0
}

