/*
  Name  : CRC-32
  Poly  : 0x04C11DB7    xxor32 + xxor26 + xxor23 + xxor22 + xxor16 + xxor12 + xxor11
                       + xxor10 + xxor8 + xxor7 + xxor5 + xxor4 + xxor2 + x + 1
  Init  : 0xFFFFFFFF
  Revert: true
  XorOut: 0xFFFFFFFF
  Check : 0xCBF43926 ("123456789")
  MaxLen: 268 435 455 байт (2 147 483 647 бит) - обнаружение
   одинарных, двойных, пакетных и всех нечетных ошибок
*/

pragma do_not_include
pragma unsafe

include "libc/stdio"


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

			++j
		}
		crc_table[i] = crc
		++i
    }

	//
	// calculate CRC32
	//

    crc = 0xFFFFFFFF

	i = 0
	while i < len {
		// 1
		let x = Word32 buf[i]
		let y = (crc xor x) and 0xFF
		// 2
		let yy = unsafe Nat8 y
		crc = crc_table[yy] xor (crc >> 8)
		++i
	}

	return crc xor 0xFFFFFFFF
}


