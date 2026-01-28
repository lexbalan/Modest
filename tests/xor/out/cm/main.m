include "ctypes64"
include "stdio"



func xor_encrypter (buf: *[]Word8, buflen: Nat32, key: *[]Word8, keylen: Nat32) -> Unit {
	var i = Nat32 0
	var j = Nat32 0
	while i < buflen {
		buf[i] = buf[i] xor key[j]

		if j < (keylen - 1) {
			j = j + 1
		} else {
			j = 0
		}

		i = i + 1
	}
}

//xor_encrypt = xor_encrypter
//xor_decrypt = xor_encrypter

const msg_length = 12
const key_length = 3

var test_msg: [msg_length + 1]Char8 = "Hello World!"
var test_key: [key_length + 1]Char8 = "abc"


func print_bytes (buf: *[]Word8, len: Nat32) -> Unit {
	var i = Nat32 0
	while i < len {
		printf("0x%02X ", Word8 buf[i])
		i = i + 1
	}
	printf("\n")
}


public func main () -> Int {
	printf("test xor encrypting\n")

	let tmsg: *[]Word8 = unsafe *[]Word8 &test_msg
	let tkey: *[]Word8 = unsafe *[]Word8 &test_key

	printf("before encrypt test_msg: \n")
	print_bytes(tmsg, msg_length)

	// encrypt test data
	xor_encrypter(tmsg, msg_length, tkey, key_length)

	printf("after encrypt test_msg: \n")
	print_bytes(tmsg, msg_length)

	// decrypt test data
	xor_encrypter(tmsg, msg_length, tkey, key_length)

	printf("after decrypt test_msg: \n")
	print_bytes(tmsg, msg_length)

	return 0
}

