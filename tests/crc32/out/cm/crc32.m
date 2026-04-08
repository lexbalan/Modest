private import "builtin"
include "stdio"



const tableSize = 256


var table: [tableSize]Word32


// initialize table
public func init () -> Unit {
	var i = Nat32 0
	while i < tableSize {
		var crc = Word32 i
		var j = Nat32 0
		while j < 8 {
			if crc & 1 != 0 {
				crc = crc >> 1 ^ 0xEDB88320
			} else {
				crc = crc >> 1
			}

			j = j + 1
		}
		table[i] = crc
		i = i + 1
	}
}


// calculate CRC32
public func run (buf: *[]Word8, len: Nat32) -> Word32 {
	var crc: Word32 = 0xFFFFFFFF
	var i = Nat32 0
	while i < len {
		let x = Word32 buf[i]
		let y: Word32 = crc ^ x & 0xFF
		let yy: Nat8 = unsafe Nat8 y
		crc = table[yy] ^ (crc >> 8)
		i = i + 1
	}

	return crc ^ 0xFFFFFFFF
}

