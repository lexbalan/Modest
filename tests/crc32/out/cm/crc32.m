include "stdio"



public func run (buf: *[]Word8, len: Nat32) -> Word32 {
	let tableSize = 256
	var crc_table: [tableSize]Word32
	var crc: Word32

	//
	// create table before
	//

	var i = Nat32 0
	while i < tableSize {
		crc = Word32 i
		var j = Nat32 0
		while j < 8 {
			if (crc and 1) != 0 {
				crc = (crc >> 1) xor 0xEDB88320
			} else {
				crc = crc >> 1
			}

			j = j + 1
		}
		crc_table[i] = crc
		i = i + 1
	}

	//
	// calculate CRC32
	//

	crc = 0xFFFFFFFF

	i = 0
	while i < len {
		// 1
		let x = Word32 buf[i]
		let y: Word32 = (crc xor x) and 0xFF
		// 2
		let yy: Nat8 = unsafe Nat8 y
		crc = crc_table[yy] xor (crc >> 8)
		i = i + 1
	}

	return crc xor 0xFFFFFFFF
}

